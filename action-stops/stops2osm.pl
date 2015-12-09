#!/usr/bin/perl -w

# This script converts a GTFS stops.txt into an OSM file.
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

use strict;
use Text::CSV;
use XML::Writer;
use Encode;
use Switch;

if (scalar @ARGV < 2) {
    print "Usage: $0 stops.txt stops.osm\n";
    exit 1;
}

my $csvfile = $ARGV[0];
my $csv = Text::CSV->new ( { binary => 1,  empty_is_undef => 1 } )
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();

# stops.txt has a BOM marker which we need to properly handle otherwise our
# first key from the CSV header will have the BOM in as part of the first key!
use File::BOM();
open my $csvfh, "< :utf8 :via(File::BOM)", $csvfile or die "$csvfile: $!";

my $xmlout = new IO::File(">$ARGV[1]");
my $xmlwriter = new XML::Writer(OUTPUT => $xmlout, NEWLINES => 'true');

# remap the CSV keys using this hash.
# note that all keys not mentioned here will be dropped so if you want
# some left as is, map them to themselfs (i.e. same key and value in the hash)
my %key_map = ("stop_name" => "name");

# add new tags to created objects from this hash
my %new_map = (
    'source' => 'ACTION',
    'network' => 'ACTION',
    'operator' => 'ACTION',
    'contact:phone' => '+61 131710'
);

$csv->column_names($csv->getline($csvfh));


$xmlwriter->xmlDecl("UTF-8");

#start the XML file
$xmlwriter->startTag("osm", "version" => "0.6");

my $node_id = 0;

my $default_attr = 'visible="true" version="1"';

sub tag($$) {
    my ($key, $value) = @_;
    $xmlwriter->emptyTag('tag', 'k' => encode('utf8', $key), 'v' => encode('utf8', $value));
}

#read through the input CSV file
while ( my $row_hash = $csv->getline_hr( $csvfh ) ) {
  my $x = $row_hash->{'stop_lon'};
  my $y = $row_hash->{'stop_lat'};

  if (defined $x && defined $y) {
    $node_id--;

    $xmlwriter->startTag('node', 'id' => $node_id, 'lat' => $y, 'lon' => $x, 'visible' => 'true', 'version' => '1');

    foreach my $key (keys %{ $row_hash } ) {
        my $value = $row_hash->{$key};
        # if the value for this property is defined
        if (defined $value) {
            # if direct mapping was defined
            if (exists $key_map{$key}) {
              $key = $key_map{$key};
              tag($key, $value);
            } else {
                switch ($key) {
                    case "stop_name" {
                        tag('name', $value);
                    }
                    case "stop_id" {
                        tag('highway', 'bus_stop');
                        tag('ref', $value);
                    }
                }
            }
        }
    }

    # add new tags
    foreach my $new_key (keys %new_map) {
      $xmlwriter->emptyTag('tag', 'k' => encode('utf8', $new_key), 'v' => encode('utf8', $new_map{$new_key}));
    }

    $xmlwriter->endTag('node');
  }
}

#finish the XML file and exit
$xmlwriter->endTag("osm");
$xmlwriter->end();
$xmlout->close();
