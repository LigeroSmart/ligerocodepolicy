# --
# Copyright (C) 2018-2018 LIGERO AG, https://complemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::LIGERO::Git::PreReceive;

use strict;
use warnings;

=head1 SYNOPSIS

This pre receive hook loads the LIGERO version of Code::TidyAll
with the custom plugins, executes it for any modified files
and returns a corresponding status code.

=cut

use Cwd;
use File::Spec;
use File::Basename;

use Code::TidyAll;
use IPC::System::Simple qw(capturex run);
use Try::Tiny;
use TidyAll::LIGERO;
use Moo;

# Ignore these repositories on the server so that we can always push to them.
my %IgnoreRepositories = (
    'ligerocodepolicy.git' => 1,

    # auto-generated documentation
    'ligero-github-io.git' => 1,

    # documentation toolchain
    'docbuild.git' => 1,

    # Thirdparty code
    'bugs-ligero-org.git' => 1,

    # LIGERO Blog
    'blog-ligero-com.git' => 1,

    # LIGERO Blog
    'www-ligero-com.git' => 1,

    # LIGEROTube
    'clips-ligero-com.git' => 1,

    # Internal UX/UI team repository
    'ux-ui.git' => 1,
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage;
    try {

        print "LIGEROCodePolicy pre receive hook starting...\n";

        my $Input = $Param{Input};
        if ( !$Input ) {
            $Input = do { local $/; <STDIN> };
        }

        # Debug
        #print "Got data:\n$Input";

        my $RootDirectory = Cwd::realpath();
        local $ENV{GIT_DIR} = $RootDirectory;

        my $RepositoryName = [ split m{/}, $RootDirectory ]->[-1];
        if ( $IgnoreRepositories{$RepositoryName} ) {
            print "Skipping checks for repository $RepositoryName.\n";
            return;
        }

        $ErrorMessage = $Self->HandleInput($Input);
    }
    catch {
        my $Exception = $_;
        print STDERR "*** Error running pre-receive hook (allowing push to proceed):\n$Exception";
    };
    if ($ErrorMessage) {
        print STDERR "$ErrorMessage\n";
        print STDERR "*** Push was rejected. Please fix the errors and try again. ***\n";
        exit 1;
    }
}

sub HandleInput {
    my ( $Self, $Input ) = @_;

    my @Lines = split( "\n", $Input );

    my (@Results);

    LINE:
    for my $Line (@Lines) {
        chomp($Line);
        my ( $Base, $Commit, $Ref ) = split( /\s+/, $Line );

        if ( substr( $Ref, 0, 9 ) eq 'refs/tags' ) {
            print "$Ref is a tag, ignoring.\n";
            next LINE;
        }

        if ( $Commit =~ m/^0+$/ ) {
            print "No target commit found, stopping.\n";
            next LINE;
        }

        print "Checking framework version for $Ref... ";

        my @FileList = $Self->GetGitFileList($Commit);

        # Create tidyall for each branch separately
        my $TidyAll = $Self->CreateTidyAll( $Commit, \@FileList );

        my @ChangedFiles = $Self->GetChangedFiles( $Base, $Commit );

        FILE:
        for my $File (@ChangedFiles) {

            # Don't try to validate deleted files.
            if ( !grep { $_ eq $File } @FileList ) {
                print "$File was deleted, ignoring.\n";
                next FILE;
            }

            # Get file from git repository.
            my $Contents = $Self->GetGitFileContents( $File, $Commit );

            # Only validate files which actually have some content.
            if ( $Contents =~ /\S/ && $Contents =~ /\n/ ) {
                push( @Results, $TidyAll->process_source( $Contents, $File ) );
            }
        }
    }

    my $ErrorMessage;
    if ( my @ErrorResults = grep { $_->error() } @Results ) {
        my $ErrorCount = scalar(@ErrorResults);
        $ErrorMessage = sprintf(
            "%d file%s did not pass tidyall check",
            $ErrorCount,
            $ErrorCount > 1 ? "s" : ""
        );
    }

    return $ErrorMessage;
}

sub CreateTidyAll {
    my ( $Self, $Commit, $FileList ) = @_;

    # Find LIGEROCodePolicy configuration
    my $ConfigFile = dirname(__FILE__) . '/../../tidyallrc';

    my $TidyAll = TidyAll::LIGERO->new_from_conf_file(
        $ConfigFile,
        check_only => 1,
        mode       => 'commit',
    );

    # We cannot use these functions here because we have a bare git repository,
    #   so we have to do it on our own.
    #$TidyAll->DetermineFrameworkVersionFromDirectory();
    #$TidyAll->GetFileListFromDirectory();

    # Set the list of files to be checked
    @TidyAll::LIGERO::FileList = @{$FileList};

    # Now we try to determine the LIGERO version from the commit

    # Look for a RELEASE file first to determine the framework version
    if ( grep { $_ eq 'RELEASE' } @{$FileList} ) {
        my @Content = split /\n/, $Self->GetGitFileContents( 'RELEASE', $Commit );

        my ( $VersionMajor, $VersionMinor ) = $Content[1] =~ m{^VERSION\s+=\s+(\d+)\.(\d+)\.}xms;
        $TidyAll::LIGERO::FrameworkVersionMajor = $VersionMajor;
        $TidyAll::LIGERO::FrameworkVersionMinor = $VersionMinor;
    }

    # Look for any SOPM files
    else {
        FILE:
        for my $File ( @{$FileList} ) {
            if ( substr( $File, -5, 5 ) eq '.sopm' ) {
                my @Content = split /\n/, $Self->GetGitFileContents( $File, $Commit );

                for my $Line (@Content) {
                    if ( $Line =~ m{ <Framework (?: [ ]+ [^<>]* )? > }xms ) {
                        my ( $VersionMajor, $VersionMinor )
                            = $Line =~ m{ <Framework (?: [ ]+ [^<>]* )? > (\d+) \. (\d+) \. [^<*]+ <\/Framework> }xms;
                        if (
                            $VersionMajor > $TidyAll::LIGERO::FrameworkVersionMajor
                            || (
                                $VersionMajor == $TidyAll::LIGERO::FrameworkVersionMajor
                                && $VersionMinor > $TidyAll::LIGERO::FrameworkVersionMinor
                            )
                            )
                        {
                            $TidyAll::LIGERO::FrameworkVersionMajor = $VersionMajor;
                            $TidyAll::LIGERO::FrameworkVersionMinor = $VersionMinor;
                        }
                    }
                    elsif ( $Line =~ m{<Vendor>} && $Line !~ m{LIGERO} ) {
                        $TidyAll::LIGERO::ThirdpartyModule = 1;
                    }
                }

                last FILE;
            }
        }
    }

    if ($TidyAll::LIGERO::FrameworkVersionMajor) {
        print
            "Found LIGERO version $TidyAll::LIGERO::FrameworkVersionMajor.$TidyAll::LIGERO::FrameworkVersionMinor\n";
    }
    else {
        print "Could not determine LIGERO version (assuming latest version)!\n";
    }

    if ($TidyAll::LIGERO::ThirdpartyModule) {
        print
            "This seems to be a module not copyrighted by LIGERO AG. File copyright will not be changed.\n";
    }
    else {
        print
            "This module seems to be copyrighted by LIGERO AG. File copyright will automatically be assigned to LIGERO AG.\n";
        print
            "  If this is not correct, you can change the <Vendor> tag in your SOPM.\n";
    }

    return $TidyAll;
}

sub GetGitFileContents {
    my ( $Self, $File, $Commit ) = @_;
    my $Content = capturex( "git", "show", "$Commit:$File" );
    return $Content;
}

sub GetGitFileList {
    my ( $Self, $Commit ) = @_;
    my $Output = capturex( "git", "ls-tree", "--name-only", "-r", "$Commit" );
    return split /\n/, $Output;
}

sub GetChangedFiles {
    my ( $Self, $Base, $Commit ) = @_;

    # Only use the last commit if we have a new branch.
    #   This is not perfect, but otherwise quite complicated.
    if ( $Base =~ m/^0+$/ ) {
        my $Output = capturex( 'git', 'diff-tree', '--no-commit-id', '--name-only', '-r', $Commit );
        my @Files  = grep {/\S/} split( "\n", $Output );
        return @Files;
    }

    my $Output = capturex( 'git', "diff", "--numstat", "--name-only", "$Base..$Commit" );
    my @Files  = grep {/\S/} split( "\n", $Output );
    return @Files;
}

1;
