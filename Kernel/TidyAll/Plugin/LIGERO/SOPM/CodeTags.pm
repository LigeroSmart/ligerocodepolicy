# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::SOPM::CodeTags;

use strict;
use warnings;

use parent qw(TidyAll::Plugin::LIGERO::Base);

sub validate_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return if $Self->IsPluginDisabled( Code => $Code );
    return if $Self->IsFrameworkVersionLessThan( 4, 0 );

    my ( @SelfUsed, @CDATAMissing );

    $Code =~ s{
        (<Code[a-zA-Z]+.*?>)    # start tag
        (.*?)                   # content
        </Code[a-zA-Z]+.*?>     # end tag
    }{
        my $StartTag = $1;
        my $TagContent = $2;

        if ($TagContent =~ m{\$Self}smx) {
            push @SelfUsed, $StartTag;
        }
        if ($TagContent !~ m{ \A\s*<!\[CDATA\[ }smx) {
            push @CDATAMissing, $StartTag;
        }

    }smxge;

    my $ErrorMessage;

    if (@SelfUsed) {
        $ErrorMessage
            .= "Don't use \$Self in <Code*> tags. Use \$Kernel::OM->Get() instead to access objects.\n";
        $ErrorMessage .= "Wrong tags found: " . join( ', ', @SelfUsed ) . "\n";
    }

    if (@CDATAMissing) {
        $ErrorMessage .= "<Code*> tags should always be wrapped in CDATA sections.\n";
        $ErrorMessage .= "Wrong tags found: " . join( ', ', @SelfUsed ) . "\n";
    }

    ## nofilter(TidyAll::Plugin::LIGERO::Perl::ObjectDependencies)
    my $Example = <<'EOF';
Here is a valid example tag:
    <CodeInstall Type="post"><![CDATA[
        $Kernel::OM->Get('var::packagesetup::MyPackage')->CodeInstall();
    ]]></CodeInstall>
EOF

    if ($ErrorMessage) {
        die __PACKAGE__ . "\n$ErrorMessage\n$Example";
    }
}

1;
