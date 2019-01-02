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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;

# common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.CleanTicketIndex.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

# check args
my $Command = shift || '--help';
print "otrs.CleanTicketIndex.pl - clean static index\n";
print "Copyright (C) 2001-2019 OTRS AG, https://otrs.com/\n";

my $Module = $CommonObject{ConfigObject}->Get('Ticket::IndexModule');
print "Module is $Module\n";
if ( $Module !~ /StaticDB/ ) {
    print "OTRS is configured to use $Module as index\n";

    $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT count(*) from ticket_index'
    );
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        if ( $Row[0] ) {
            print "Found $Row[0] records in StaticDB index.\n";
            print "Deleting $Row[0] records...";
            $CommonObject{DBObject}->Do( SQL => 'DELETE FROM ticket_index' );
            print " OK!\n";
        }
        else { print "No records found in StaticDB index.. OK!\n"; }
    }

    $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT count(*) from ticket_lock_index'
    );
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        if ( $Row[0] ) {
            print "Found $Row[0] records in StaticDB lock_index.\n";
            print "Deleting $Row[0] records...";
            $CommonObject{DBObject}->Do(
                SQL => 'DELETE FROM ticket_lock_index'
            );
            print " OK!\n";
        }
        else { print "No records found in StaticDB lock_index.. OK!\n"; }
    }

}
else {
    print "You are using $Module as index, you should not clean it.\n";
}

exit(0);
