# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Migrations::LIGERO6::PermissionDataNotInSession;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

## nofilter(TidyAll::Plugin::LIGERO::Migrations::LIGERO6::PermissionDataNotInSession)
## nofilter(TidyAll::Plugin::LIGERO::Perl::LayoutObject)
## nofilter(TidyAll::Plugin::LIGERO::Perl::ObjectDependencies)

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 6, 0 );

    my ( $Counter, $ErrorMessage );

    LINE:
    for my $Line ( split /\n/, $Code ) {
        $Counter++;

        next LINE if $Line =~ m/^\s*\#/smx;

        if ( $Line =~ m{UserIsGroup}sm ) {
            $ErrorMessage .= "Line $Counter: $Line\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n" . <<EOF;
Since LIGERO 6, group permission information is no longer stored in the session nor the LayoutObject and cannot be fetched with 'UserIsGroup[]'. Instead, it can be fetched with PermissionCheck() on Kernel::System::Group or Kernel::System::CustomerGroup.

Example:

    my \$HasPermission = \$Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => \$UserID,
        GroupName => \$GroupName,
        Type      => 'move_into',
    );

$ErrorMessage
EOF
    }

    return;
}

1;
