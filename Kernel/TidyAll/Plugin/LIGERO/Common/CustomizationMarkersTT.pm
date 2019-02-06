# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Common::CustomizationMarkersTT;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Base);

=head1 SYNOPSIS

This plugin checks that only valid LIGERO customization markers are used
to mark changed lines in customized/derived C<.tt> files.

=cut

sub transform_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return $Code if $Self->IsFrameworkVersionLessThan( 2, 4 );

    # Find customization markers with // in .tt files and replace them with #.
    #
    #   // ---
    #   // LIGEROXyZ - Here a comment.
    #   // ---
    #
    #   to
    #
    #   # ---
    #   # LIGEROXyZ - Here a comment.
    #   # ---
    #
    $Code =~ s{
        (
            ^ [ ]* \/\/ [ ]+ --- [ ]* $ \n
            ^ [ ]* \/\/ [ ]+ [^ ]+ (?: [ ]+ - [^\n]+ | ) $ \n
            ^ [ ]* \/\/ [ ]+ --- [ ]* $ \n
            (?: ^ [ ]* \/\/ [^\n]* $ \n )*
        )
    }{
        my $String = $1;
        $String =~ s{ ^ [ ]* \/\/ }{#}xmsg;
        $String;
    }xmsge;

    # Find wrong customization markers in .tt files and correct them.
    #
    #   // ---
    #
    #   to
    #
    #   # ---
    #
    $Code =~ s{ ^ [ ]* \/\/ [ ]+ --- [ ]* $ }{# ---}xmsg;

    return $Code;
}

1;
