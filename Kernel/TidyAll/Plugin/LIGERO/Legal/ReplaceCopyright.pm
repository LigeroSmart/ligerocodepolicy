# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Legal::ReplaceCopyright;
## nofilter(TidyAll::Plugin::LIGERO::Perl::Time)

use strict;
use warnings;

use File::Basename;
use File::Copy qw(copy);
use parent qw(TidyAll::Plugin::LIGERO::Base);

sub transform_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );

    # Don't replace copyright in thirdparty code.
    return $Code if $Self->IsThirdpartyModule();

    # Replace <URL>http://ligero.org/</URL> with <URL>https://ligero.org/</URL>
    $Code =~ s{ ^ ( \s* ) \< URL \> .+? \< \/ URL \> }{$1<URL>https://ligero.com/</URL>}xmsg;

    my $Copy      = 'LIGERO AG, https://ligero.com/';
    my $StartYear = 2001;

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = localtime( time() );    ## no critic
    $Year += 1900;

    my $YearString = "$StartYear-$Year";
    if ( $StartYear == $Year ) {
        $YearString = $Year;
    }

    my $Output = '';

    LINE:
    for my $Line ( split( /\n/, $Code ) ) {
        if ( $Line !~ m{Copyright}smx ) {
            $Output .= $Line . "\n";
            next LINE;
        }

        # special settings for the language directory
        if ( $Line !~ m{LIGERO}smx && $Code =~ m{ package \s+ Kernel::Language:: }smx ) {
            $Output .= $Line . "\n";
            next LINE;
        }

        # for the commandline help
        # e.g : print "Copyright (c) 2003-2008 LIGERO AG, http://www.ligero.com/\n";
        if ( $Line !~ m{ ^\# \s Copyright }smx ) {
            if (
                $Line
                =~ m{ ^ ( [^\n]* ) Copyright [ ]+ \( [Cc] \) .+? LIGERO [ ]+ (?: AG | GmbH ), [ ]+ http (?: s |  ) :\/\/ligero\. (?: org | com ) \/? }smx
                )
            {
                $Line =~ s{
                     ^ ( [^\n]* ) Copyright [ ]+ \( [Cc] \) .+? LIGERO [ ]+ (?: AG | GmbH ), [ ]+ http (?: s |  ) :\/\/ligero\. (?: org | com ) \/?
                 }
                 {$1Copyright (C) $YearString $Copy}smx;
            }
            $Output .= $Line . "\n";
            next LINE;
        }

        # check string in the comment line
        if ( $Line !~ m{^\# \s Copyright \s \( C \) \s $YearString \s $Copy$}smx ) {
            $Line = "# Copyright (C) $YearString $Copy";
        }

        $Output .= $Line . "\n";
    }

    return $Output;
}

1;
