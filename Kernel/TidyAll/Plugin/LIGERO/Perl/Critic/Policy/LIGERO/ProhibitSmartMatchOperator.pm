# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/

package Perl::Critic::Policy::LIGERO::ProhibitSmartMatchOperator;

## nofilter(TidyAll::Plugin::LIGERO::Common::HeaderlineFilename)
## nofilter(TidyAll::Plugin::LIGERO::Legal::ReplaceCopyright)
## nofilter(TidyAll::Plugin::LIGERO::Legal::LicenseValidator)
## nofilter(TidyAll::Plugin::LIGERO::Perl::PerlCritic)

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use parent 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Use of smart match operator ~~ is not allowed};
Readonly::Scalar my $EXPL =>
    q{This operator behaves differently in Perl 5.10.0 and 5.10.1.};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( ligero ) }
sub applies_to           { return 'PPI::Token::Operator' }

sub violates {
    my ( $self, $elem ) = @_;

    return if $elem ne '~~';
    return $self->violation( $DESC, $EXPL, $elem );
}

1;
