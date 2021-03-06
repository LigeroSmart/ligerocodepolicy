# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/

package Perl::Critic::Policy::LIGERO::ProhibitRandInTests;

## nofilter(TidyAll::Plugin::LIGERO::Common::HeaderlineFilename)
## nofilter(TidyAll::Plugin::LIGERO::Legal::ReplaceCopyright)
## nofilter(TidyAll::Plugin::LIGERO::Legal::LicenseValidator)
## nofilter(TidyAll::Plugin::LIGERO::Perl::PerlCritic)

use strict;
use warnings;

# SYNOPSIS: Check if modules have a "true" return value

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use parent 'Perl::Critic::Policy';
use parent 'Perl::Critic::PolicyLIGERO';

use Readonly;

our $VERSION = '0.02';

Readonly::Scalar my $DESC => q{Use of "rand()" or "srand()" is not allowed in tests.};
Readonly::Scalar my $EXPL => q{Use Kernel::System::UnitTest::Helper::GetRandomNumber() or GetRandomID() instead.};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( ligero ) }
sub applies_to           { return 'PPI::Token::Word' }

sub violates {
    my ( $Self, $Element ) = @_;

    return if $Self->IsFrameworkVersionLessThan( 6, 0 );

    return if !$Self->_is_test($Element);

    if ( $Element eq 'rand' || $Element eq 'srand' ) {
        return $Self->violation( $DESC, $EXPL, $Element );
    }

    return;
}

sub _is_test {
    my ( $Self, $Element ) = @_;

    my $Document = $Element->document;
    my $Filename = $Document->logical_filename;
    my $IsTest   = $Filename =~ m{ \.t \z }xms;

    return $IsTest;
}

1;
