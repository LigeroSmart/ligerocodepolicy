# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/package Perl::Critic::Policy::LIGERO::RequireTrueReturnValueForModules;

## nofilter(TidyAll::Plugin::LIGERO::Common::HeaderlineFilename)
## nofilter(TidyAll::Plugin::LIGERO::Legal::ReplaceCopyright)
## nofilter(TidyAll::Plugin::LIGERO::Legal::LicenseValidator)
## nofilter(TidyAll::Plugin::LIGERO::Perl::PerlCritic)

use strict;
use warnings;

# SYNOPSIS: Check if modules have a "true" return value

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use parent 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.02';

Readonly::Scalar my $DESC => q{Modules have to return a true value ("1;")};
Readonly::Scalar my $EXPL => q{Use "1;" as the last statement of the module};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( ligero ) }
sub applies_to           { return 'PPI::Document' }

sub violates {
    my ( $self, $elem ) = @_;

    return if $self->_is_script($elem);
    return if $self->_returns_1($elem);
    return $self->violation( $DESC, $EXPL, $elem );
}

sub _returns_1 {
    my ( $self, $elem ) = @_;

    my $last_statement = ( grep { ref $_ eq 'PPI::Statement' } $elem->schildren )[-1];
    return 0 if !$last_statement;
    return 1 if $last_statement eq '1;';
    return 0;
}

sub _is_script {
    my ( $self, $elem ) = @_;

    my $document = $elem->document;
    my $filename = $document->logical_filename;

    my $is_module = $filename =~ m{ \.pm \z }xms;

    return !$is_module;
}

1;
