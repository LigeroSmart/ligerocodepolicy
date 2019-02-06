# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::JavaScript::UnloadEvent;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 5, 0 );

    my $ErrorMessage;
    my $Counter;

    for my $Line ( split( /\n/, $Code ) ) {
        $Counter++;
        if ( $Line =~ m{ \.bind\(['"]unload }xms || $Line =~ m{ \.on\(['"]unload }xms ) {
            $ErrorMessage
                .= "ERROR: Found window unload event in line( $Counter ): $Line\n";
            $ErrorMessage .= "Please use Core.App.BindWindowUnloadEvent() for cross-browser compatibility.\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n$ErrorMessage";
    }
}

1;
