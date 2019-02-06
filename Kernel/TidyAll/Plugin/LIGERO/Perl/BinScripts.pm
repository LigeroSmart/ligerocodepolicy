# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Perl::BinScripts;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Perl);

# We only want to allow a handful of scripts in bin. All the rest should be
#   migrated to console commands.

sub validate_file {    ## no critic
    my ( $Self, $Filename ) = @_;

    return if $Self->IsPluginDisabled( Filename => $Filename );
    return if $Self->IsFrameworkVersionLessThan( 5, 0 );

    my %AllowedFiles = (
        'ligero.CheckModules.pl'   => 1,
        'ligero.CheckSum.pl'       => 1,
        'ligero.CodePolicy.pl'     => 1,
        'ligero.Console.pl'        => 1,
        'ligero.Daemon.pl'         => 1,
        'ligero.SetPermissions.pl' => 1,
    );

    if ( !$AllowedFiles{ File::Basename::basename($Filename) } ) {
        die __PACKAGE__ . "\n" . <<EOF;
Please migrate all bin/ scripts to Kernel::System::Console::Command objects.
EOF
    }
}

1;
