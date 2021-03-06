# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Migrations::LIGERO6::SysConfig;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 6, 0 );

    my ( $Counter, $ErrorMessage );

    LINE:
    for my $Line ( split /\n/, $Code ) {
        $Counter++;

        next LINE if $Line =~ m/^\s*\#/smx;

        # Look for code that uses not not existing functions.
        if (
            $Line =~ m{
            ->(CreateConfig|ConfigItemUpdate|ConfigItemGet|ConfigItemReset
            |ConfigItemValidityUpdate|ConfigGroupList|ConfigSubGroupList
            |ConfigSubGroupConfigItemList|ConfigItemSearch|ConfigItemTranslatableStrings
            |ConfigItemValidate|ConfigItemCheckAll)\(}smx
            )
        {
            # Skip ITSM functions, which have same name.
            next LINE if $Line =~ m{ConfigItemObject};
            next LINE if $Line =~ m{ITSM};

            $ErrorMessage .= "Line $Counter: $Line\n";
        }
    }

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n" . <<EOF;
Use of unexisting methods in Kernel::System::SysConfig is not allowed (CreateConfig, ConfigItemUpdate,
ConfigItemGet, ConfigItemReset, ConfigItemValidityUpdate,ConfigGroupList, ConfigSubGroupList,
ConfigSubGroupConfigItemList, ConfigItemSearch, ConfigItemTranslatableStrings, ConfigItemValidate
and ConfigItemCheckAll).

    Please see http://doc.ligero.com/doc/manual/developer/6.0/en/html/package-porting.html#package-porting-5-to-6 for porting guidelines.
$ErrorMessage
EOF
    }

    return;
}

1;
