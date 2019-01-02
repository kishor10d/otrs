#!/usr/bin/perl -w
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Loader;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;

sub PrintHelp {
    print <<"EOF";
otrs.LoaderCache.pl - Commandline interface to the
     cache of the CSS/JavaScript loading mechanism of OTRS

Usage: otrs.LoaderCache.pl -o delete

Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
EOF
}

# get options
my %Opts = ();
getopt( 'ho', \%Opts );
if ( $Opts{h} ) {
    PrintHelp();
    exit 1;
}

# create common objects
my %CommonObject = ();

$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Test',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

# create needed objects
$CommonObject{LoaderObject} = Kernel::System::Loader->new(%CommonObject);

if ( $Opts{o} && lc( $Opts{o} ) eq 'delete' ) {
    print "Deleting all Loader cache files...\n";
    my @DeletedFiles = $CommonObject{LoaderObject}->CacheDelete();
    if (@DeletedFiles) {
        print "The following files were deleted:\n\t";
        print join "\n\t", @DeletedFiles;
        print "\n";
    }
    else {
        print "No file was deleted.\n";
    }
    exit 0;
}
else {
    PrintHelp();
}

exit 1;
