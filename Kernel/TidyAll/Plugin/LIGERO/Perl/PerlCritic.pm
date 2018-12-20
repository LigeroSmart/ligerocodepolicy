# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Perl::PerlCritic;

use strict;
use warnings;

use File::Basename;
use lib dirname(__FILE__) . '/../';    # Find our Perl::Critic policies

use parent qw(TidyAll::Plugin::LIGERO::Perl);
use Perl::Critic;

use Perl::Critic::Policy::LIGERO::ProhibitLowPrecendeceOps;
use Perl::Critic::Policy::LIGERO::ProhibitSmartMatchOperator;
use Perl::Critic::Policy::LIGERO::ProhibitRandInTests;
use Perl::Critic::Policy::LIGERO::ProhibitOpen;
use Perl::Critic::Policy::LIGERO::ProhibitUnless;
use Perl::Critic::Policy::LIGERO::RequireCamelCase;
use Perl::Critic::Policy::LIGERO::RequireLabels;
use Perl::Critic::Policy::LIGERO::RequireParensWithMethods;
use Perl::Critic::Policy::LIGERO::RequireTrueReturnValueForModules;

our $Critic;

sub validate_file {    ## no critic
    my ( $Self, $Filename ) = @_;

    return if $Self->IsPluginDisabled( Filename => $Filename );
    return if $Self->IsFrameworkVersionLessThan( 3, 2 );

    if ( !$Critic ) {
        my $Severity = 4;
        if ( $Self->IsFrameworkVersionLessThan( 6, 0 ) ) {
            $Severity = 5;    #  less strict for older versions
        }
        $Critic = Perl::Critic->new(
            -severity => $Severity,
            -exclude  => [
                'Perl::Critic::Policy::Modules::RequireExplicitPackage',    # this breaks in our scripts/test folder
            ],
        );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::ProhibitLowPrecendeceOps' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::ProhibitSmartMatchOperator' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::ProhibitRandInTests' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::ProhibitOpen' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::ProhibitUnless' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::RequireCamelCase' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::RequireLabels' );
        $Critic->add_policy( -policy => 'Perl::Critic::Policy::LIGERO::RequireParensWithMethods' );
        $Critic->add_policy(
            -policy => 'Perl::Critic::Policy::LIGERO::RequireTrueReturnValueForModules'
        );
    }

    # Force stringification of $Filename as it is a Path::Tiny object in Code::TidyAll 0.50+.
    my @Violations = $Critic->critique("$Filename");

    if (@Violations) {
        die __PACKAGE__ . "\n@Violations";
    }
}

1;
