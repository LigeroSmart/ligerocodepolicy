# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/# --
# Copyright (C) 2018-2018 LIGERO AG, https://copmplemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Common::ProhibitEmailAddresses;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Base);

=head1 SYNOPSIS

This plugin disallows problematic email addresses.

=cut

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return $Code if $Self->IsFrameworkVersionLessThan( 3, 3 );

    my ( $Counter, $ErrorMessage );

    for my $Line ( split /\n/, $Code ) {
        $Counter++;
        if ( $Line =~ /support\@ligero\.(?:com|de)/ismx ) {
            $ErrorMessage .= "Line $Counter: $Line\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n" . <<EOF;
Don't use support\@ligero.com in any source files or documents as this address has SPAM problems.
$ErrorMessage
EOF
    }
    return;
}

1;
