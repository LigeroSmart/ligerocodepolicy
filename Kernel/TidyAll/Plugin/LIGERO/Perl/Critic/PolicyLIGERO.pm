# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Perl::Critic::PolicyLIGERO;

#
# Base class for custome Perl::Critic policies.
#

use strict;
use warnings;

no strict 'vars';    ## no critic

use vars qw(
    $TidyAll::LIGERO::FrameworkVersionMajor
    $TidyAll::LIGERO::FrameworkVersionMinor
);

# Base class for LIGERO perl critic policies

sub IsFrameworkVersionLessThan {
    my ( $Self, $FrameworkVersionMajor, $FrameworkVersionMinor ) = @_;

    if ($TidyAll::LIGERO::FrameworkVersionMajor) {
        return 1 if $TidyAll::LIGERO::FrameworkVersionMajor < $FrameworkVersionMajor;
        return 0 if $TidyAll::LIGERO::FrameworkVersionMajor > $FrameworkVersionMajor;
        return 1 if $TidyAll::LIGERO::FrameworkVersionMinor < $FrameworkVersionMinor;
        return 0;
    }

    # Default: if framework is unknown, return false (strict checks).
    return 0;
}

1;
