# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::DTL::Baselink;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

=head1 SYNOPSIS

This plugin verifies that $Env{"Baselink"} is not used in form tags.

=cut

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return $Code if $Self->IsFrameworkVersionLessThan( 2, 4 );

    my $Counter;
    my $ErrorMessage;

    for my $Line ( split /\n/, $Code ) {
        $Counter++;

        if ( $Line =~ /<form.+action="\$Env\{"Baselink"\}"/i ) {
            $ErrorMessage .= __PACKAGE__ . "\n" . <<EOF;
\$Env{\"Baselink\"} is not allowed in <form>tags. Use \$Env{\"CGIHandle\"}!
Line $Counter: $Line
EOF
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n$ErrorMessage";
    }
}

1;
