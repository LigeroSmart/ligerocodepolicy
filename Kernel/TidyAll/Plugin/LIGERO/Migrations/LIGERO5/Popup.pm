# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Migrations::LIGERO5::Popup;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 5, 0 );

    my ( $Counter, $ErrorMessage );

    for my $Line ( split /\n/, $Code ) {
        $Counter++;

        # look for forbidden text in popup header
        # text should be "cancel & close" or "undo & close"
        # but not "xyz & close window" anymore
        if ( $Line =~ m{\[% Translate\("(Undo & close window|Cancel & close window|Close window)}smi ) {
            $ErrorMessage .= "Line $Counter: $Line\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n" . <<EOF;
Popup close notice should not contain the word "window".
$ErrorMessage
EOF
    }

    return;
}

1;
