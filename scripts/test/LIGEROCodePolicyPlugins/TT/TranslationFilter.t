# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use vars (qw($Self));
use utf8;

use scripts::test::LIGEROCodePolicyPlugins;

my @Tests = (
    {
        Name      => 'Simple function translation, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate("Hello, world!") %]
EOF
        Exception => 1,
    },
    {
        Name      => 'Simple function translation with HTML filter, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate("Hello, world!") | html %]
EOF
        Exception => 0,
    },
    {
        Name      => 'Simple function translation with JSON filter, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate("Hello, world!") | JSON %]
EOF
        Exception => 0,
    },
    {
        Name      => 'Variable function translation, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate(Data.Language) %]
EOF
        Exception => 1,
    },
    {
        Name      => 'Variable function translation, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate(Data.Language) | html %]
EOF
        Exception => 0,
    },
    {
        Name      => 'Complex function translation, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
&ndash; <span title="[% Translate("Created") %]: [% Data.CreateTime | Localize("TimeShort") %]">[% Data.CreateTime | Localize("TimeShort") %]</span> [% Translate("via %s", Translate(Data.CommunicationChannel)) | html %]
EOF
        Exception => 1,
    },
    {
        Name      => 'Complex function translation, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
&ndash; <span title="[% Translate("Created") | html %]: [% Data.CreateTime | Localize("TimeShort") %]">[% Data.CreateTime | Localize("TimeShort") %]</span> [% Translate("via %s", Translate(Data.CommunicationChannel)) | html %]
EOF
        Exception => 0,
    },
    {
        Name      => 'Function translation with placeholder, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<a href="[% Env("Baselink") %]Action=AdminLIGEROBusiness" class="Button"><i class="fa fa-angle-double-up"></i> [% Translate("Upgrade to %s", LIGEROBusinessLabel) %]</a>
EOF
        Exception => 1,
    },
    {
        Name      => 'Function translation with placeholder, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<a href="[% Env("Baselink") %]Action=AdminLIGEROBusiness" class="Button"><i class="fa fa-angle-double-up"></i> [% Translate("Upgrade to %s") | html | ReplacePlaceholders(LIGEROBusinessLabel) %]</a>
EOF
        Exception => 0,
    },
    {
        Name      => 'Function translation with placeholders, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate('This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!', LIGEROBusinessLabel, '<a href="mailto:sales@ligero.com">sales@ligero.com</a>') %]
EOF
        Exception => 1,
    },
    {
        Name      => 'Function translation with placeholders, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
[% Translate('This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!') | html | ReplacePlaceholders(LIGEROBusinessLabel, '<a href="mailto:sales@ligero.com">sales@ligero.com</a>') %]
EOF
        Exception => 0,
    },
    {
        Name      => 'Function translation with no spaces, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<button class="Primary CallForAction" type="submit" value="[%Translate("Add")%]"><span>[% Translate("Add") | html %]</span></button>
EOF
        Exception => 1,
    },
    {
        Name      => 'Function translation with no spaces, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<button class="Primary CallForAction" type="submit" value="[%Translate("Add")|html%]"><span>[% Translate("Add") | html %]</span></button>
EOF
        Exception => 0,
    },
    {
        Name      => 'Filter translation, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<span title="[% Translate(Data.Content) | html %]">[% Data.Content | Translate | truncate(Data.MaxLength) %]</span>
EOF
        Exception => 1,
    },
    {
        Name      => 'Filter translation, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
<span title="[% Translate(Data.Content) | html %]">[% Data.Content | Translate | truncate(Data.MaxLength) | html %]</span>
EOF
        Exception => 0,
    },
    {
        Name      => 'Second filter translation, invalid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
var Message = [% Data.CustomerRegExErrorMessageServerErrorMessage | Translate %];
EOF
        Exception => 1,
    },
    {
        Name      => 'Second filter translation, valid',
        Filename  => 'Template.tt',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::TT::TranslationFilter)],
        Framework => '6.0',
        Source    => <<'EOF',
var Message = [% Data.CustomerRegExErrorMessageServerErrorMessage | Translate | JSON %];
EOF
        Exception => 0,
    },

);

$Self->scripts::test::LIGEROCodePolicyPlugins::Run( Tests => \@Tests );

1;
