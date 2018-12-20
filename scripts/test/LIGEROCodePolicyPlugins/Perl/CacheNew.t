# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
use strict;
use warnings;
## nofilter(TidyAll::Plugin::LIGERO::Common::CustomizationMarkers)

use vars (qw($Self));
use utf8;

use scripts::test::LIGEROCodePolicyPlugins;

my @Tests = (
    {
        Name      => 'CacheNew, forbidden',
        Filename  => 'test.pl',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::Perl::CacheNew)],
        Framework => '4.0',
        Source    => <<'EOF',
Kernel::System::Cache->new(%{$Self});
EOF
        Exception => 1,
    },
    {
        Name      => 'CacheNew, ok',
        Filename  => 'test.pl',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::Perl::CacheNew)],
        Framework => '4.0',
        Source    => <<'EOF',
$Kernel::OM->Get('Kernel::System::Cache');
EOF
        Exception => 0,
    },
);

$Self->scripts::test::LIGEROCodePolicyPlugins::Run( Tests => \@Tests );

1;
