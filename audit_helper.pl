#!/usr/bin/perl
use strict;
use Data::Dumper;
use Cwd;
use File::Path;

my $book;
my $files;

$| = 1;

sub unquote {
	my $string = shift;

	return substr($string, 1, -1);
}

while(<STDIN>) {
	my @line = split;
	my %h;
	foreach my $item (@line) {
		my ($v, $k)= split("=", $item);
		$h{$v} = $k;
	}

	if (($h{"type"} =~ /UNKNOWN.*/) || ($h{"type"} eq "EOE")) {
		if (defined($h{"msg"}) && defined($book->{$h{"msg"}})) {
			foreach my $path (@{$book->{$h{"msg"}}->{"path"}}) {
				if (defined($book->{$h{"msg"}}->{"key"})) {
#					if (($book->{$h{"msg"}}->{"cwd"} ne "/") ||
#						($path =~ /$book->{$h{"msg"}}->{"key"}/ ) ||
#						($path eq "/") || 
#						($path eq ".") || 
#						($path eq "/.") ||
#						($path eq "null") ||
#						($path =~ /.pivot.root.*/)) {
#						next;
#					}
					my $fullpath = $book->{$h{"msg"}}->{"key"}.$path;
					my $linkpath = $book->{$h{"msg"}}->{"key"}."/.workbench/linked".$path;
					if ( $fullpath =~ /$linkpath"/ ) {
						next
					}
					if (! -d $linkpath) {
						mkpath($linkpath);
						print $fullpath."\n";
					}
					next;
				}
			}
			delete $book->{$h{"msg"}};
		}
	} elsif ($h{"type"} eq "SYSCALL") {
		$book->{$h{"msg"}}->{"key"} = unquote($h{"key"});
	} elsif ($h{"type"} eq "CWD") {
		$book->{$h{"msg"}}->{"cwd"} = unquote($h{"cwd"});
	} elsif ($h{"type"} eq "PATH") {
		push @{$book->{$h{"msg"}}->{"path"}}, unquote($h{"name"});
	}
}
