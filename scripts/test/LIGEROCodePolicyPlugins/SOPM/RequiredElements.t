# --
# Copyright (C) 2001-2018 LIGERO AG, https://ligero.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
use strict;
use warnings;

use vars (qw($Self));
use utf8;

use scripts::test::LIGEROCodePolicyPlugins;

my @Tests = (
    {
        Name      => 'Minimal valid SOPM.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>0</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
    {
        Name      => 'Missing name.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing description.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing version.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing framework.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing vendor.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing URL.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Missing license.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'Invalid content for PackageIsDownloadable flag.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>test</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'LIGEROCodePolicy - missing PackageIsDownloadable + PackageIsBuildable.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'LIGEROCodePolicy - valid SOPM.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROCodePolicy</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>0</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
    {
        Name      => 'ITSMIncidentProblemManagement - missing PackageIsDownloadable + PackageIsBuildable.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>ITSMIncidentProblemManagement</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'ITSMIncidentProblemManagement - valid SOPM.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>ITSMIncidentProblemManagement</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>0</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
    {
        Name      => 'TimeAccounting - missing PackageIsDownloadable + PackageIsBuildable.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>TimeAccounting</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'TimeAccounting - valid SOPM.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>TimeAccounting</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>0</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
    {
        Name      => 'LIGEROSTORM - missing PackageIsDownloadable + PackageIsBuildable.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROSTORM</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 1,
    },
    {
        Name      => 'LIGEROSTORM - valid SOPM.',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>LIGEROSTORM</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <PackageIsDownloadable>0</PackageIsDownloadable>
    <PackageIsBuildable>0</PackageIsBuildable>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
    {
        Name      => 'Test123 - valid SOPM (no restricted package).',
        Filename  => 'Test.pm',
        Plugins   => [qw(TidyAll::Plugin::LIGERO::SOPM::RequiredElements)],
        Framework => '7.0',
        Source    => <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<ligero_package version="1.0">
    <Name>Test123</Name>
    <Version>0.0.0</Version>
    <Framework>7.0.x</Framework>
    <Vendor>LIGERO AG</Vendor>
    <URL>https://ligero.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">LIGERO code quality checks.</Description>
    <Filelist>
        <File Permission="755" Location="bin/ligero.CodePolicy.pl" />
    </Filelist>
</ligero_package>
EOF
        Exception => 0,
    },
);

$Self->scripts::test::LIGEROCodePolicyPlugins::Run( Tests => \@Tests );

1;
