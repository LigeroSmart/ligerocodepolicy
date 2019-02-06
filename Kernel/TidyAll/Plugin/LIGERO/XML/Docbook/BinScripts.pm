# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::XML::Docbook::BinScripts;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Base);

=head1 SYNOPSIS

This plugin checks that bin scripts point to new paths.

=cut

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return $Code if $Self->IsFrameworkVersionLessThan( 5, 0 );

    my %AllowedFiles = (
        'ligero.CheckModules.pl'   => 1,
        'ligero.CheckSum.pl'       => 1,
        'ligero.CodePolicy.pl'     => 1,
        'ligero.Console.pl'        => 1,
        'ligero.Daemon.pl'         => 1,
        'ligero.SetPermissions.pl' => 1,
    );

    my ( $Counter, $ErrorMessage );

    LINE:
    for my $Line ( split /\n/, $Code ) {
        $Counter++;
        if ( $Line =~ /bin\/(ligero\.\w+\.pl)/ismx ) {

            next LINE if $AllowedFiles{$1};

            $ErrorMessage .= "Line $Counter: $Line\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n" . <<EOF;
Don't use old bin scripts in documentation.
$ErrorMessage
EOF
    }

    return;
}

1;
