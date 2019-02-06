# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/package Perl::Critic::Policy::LIGERO::ProhibitUnless;

## nofilter(TidyAll::Plugin::LIGERO::Common::HeaderlineFilename)
## nofilter(TidyAll::Plugin::LIGERO::Legal::ReplaceCopyright)
## nofilter(TidyAll::Plugin::LIGERO::Legal::LicenseValidator)
## nofilter(TidyAll::Plugin::LIGERO::Perl::PerlCritic)

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use parent 'Perl::Critic::Policy';
use parent 'Perl::Critic::PolicyLIGERO';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Use of 'unless' is not allowed.};
Readonly::Scalar my $EXPL => q{Please use a negating 'if' instead.};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( ligero ) }
sub applies_to           { return 'PPI::Token::Word' }

sub violates {
    my ( $Self, $Element ) = @_;

    return if $Self->IsFrameworkVersionLessThan( 4, 0 );

    return if ( $Element->content() ne 'unless' );
    return $Self->violation( $DESC, $EXPL, $Element );
}

1;
