#!/usr/bin/perl
use Data::Dumper;

my $decision;
my $repo;
my @ipkg;

foreach my $tmp (split(',',$ARGV[1])) {
        $decision->{$tmp} = 1;
        push @ipkg, $tmp;
}
foreach my $tmp (split(',',$ARGV[2])) {
        $decision->{$tmp} = 0;
}

open(F, $ARGV[0]);
my $key = "";
while(<F>) {
        if (/^(\S+)/) {
                $key = $1;
                $repo->{$key} = [];
                next
        }
       
        if (/Depends:\s+(\S+)\s+/) {
                push @{$repo->{$key}}, $1;
        } else {
                print "UNKNOWN =>".$_."<=\n";
        }
}
close(F);

sub decide {
        my $pkg = shift;

        if ($decision->{$pkg} == 1) {
                foreach my $tmp (@{$repo->{$pkg}}) {
                        if (not defined($decision->{$tmp})) {
                                $decision->{$tmp} = 1;
                                decide($tmp);
                        }
                }
        }
}

foreach my $tmp (keys %{$repo}) {
        decide($tmp);
}

my $include;
my $exclude;
foreach my $tmp (keys %{$decision}) {
        if ($decision->{$tmp} == 1) {
                push @{$include}, $tmp;
        } else {
                push @{$exclude}, $tmp;
        }
}

print "Include: ";
open(F, ">debs-included.lst");
foreach my $tmp (sort @{$include}) {
        print " ".$tmp;
	print F $tmp."\n";
}
print "\n";
close(F);

print "Exclude: ";
open(F, ">debs-excluded.lst");
foreach my $tmp (sort @{$exclude}) {
        print " ".$tmp;
	print F $tmp."\n";
}
close(F);
print "\n";

