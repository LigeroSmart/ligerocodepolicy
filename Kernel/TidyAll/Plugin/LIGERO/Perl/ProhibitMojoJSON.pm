# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Perl::ProhibitMojoJSON;

## nofilter(TidyAll::Plugin::LIGERO::Perl::ProhibitMojoJSON)

use strict;
use warnings;

use parent 'TidyAll::Plugin::LIGERO::Base';

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 7, 0 );

    if ( $Code =~ m{Mojo::JSON}smx ) {
        die __PACKAGE__ . "\n" . <<EOF;
Don't use Mojo::JSON directly, use Kernel::System::JSON instead.
EOF
    }

    return;
}

1;
