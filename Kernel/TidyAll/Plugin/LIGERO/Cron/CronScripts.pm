# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Cron::CronScripts;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Base);

# We only want to allow two cron files from LIGERO 5 on as the rest is managed
# via the cron daemon.

sub validate_file {    ## no critic
    my ( $Self, $Filename ) = @_;

    return if $Self->IsPluginDisabled( Filename => $Filename );
    return if $Self->IsFrameworkVersionLessThan( 5, 0 );

    my %AllowedFiles = (
        'aaa_base.dist'       => 1,
        'ligero_daemon.dist'    => 1,
        'ligero_webserver.dist' => 1,
    );

    if ( !$AllowedFiles{ File::Basename::basename($Filename) } ) {
        die __PACKAGE__ . "\n" . <<EOF;
Please migrate all scron scripts to be handled via the LIGERO Daemon (see SysConfig setting Daemon::SchedulerCronTaskManager::Task).
EOF
    }
}

1;
