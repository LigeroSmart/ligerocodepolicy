# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::SOPM::OndemandTestingPresent;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 7, 0 );

    my $DocumentationPresent = grep { $_ =~ m{[.]ligero-ci[.]yml} } @TidyAll::LIGERO::FileList;

    if ( !$DocumentationPresent ) {
        die __PACKAGE__ . "\nEvery package needs to contain an active OnDemand testing configuration (.ligero-ci.yml).\n";
    }
}

1;
