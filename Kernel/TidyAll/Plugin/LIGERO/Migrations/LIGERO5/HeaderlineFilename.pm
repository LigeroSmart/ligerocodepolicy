# --
# Modified version of the work: Copyright (C) 2019 Ligero, https://www.complemento.net.br/
# based on the original work of:
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package TidyAll::Plugin::LIGERO::Migrations::LIGERO5::HeaderlineFilename;

use strict;
use warnings;

use File::Basename;

use parent qw(TidyAll::Plugin::LIGERO::Base);

=head1 SYNOPSIS

LIGERO used to have the filename in the second line of every file;
drop this with LIGERO 5.

=cut

sub transform_source {    ## no critic
    my ( $Self, $Code ) = @_;

    return $Code if $Self->IsPluginDisabled( Code => $Code );

    # Catch Perl and JS coments
    my $CommentStart = "(?:\\#|//)";

    $Code =~ s{
        (
            \A
            (?: $CommentStart![^\n]+\n )?                   # shebang line
            $CommentStart[ ]--\n                            # separator
        )
            (?: $CommentStart \s+ (?!Copyright)[^\n]+\n )+  # Old documentation header lines to be removed
        (
            (?: $CommentStart \s+ Copyright[^\n]+\n )+      # copyright
            $CommentStart[ ]--\n          # separator
        )
    }
    {$1$2}ismx;

    return $Code;
}

1;
