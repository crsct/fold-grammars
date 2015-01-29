#!/usr/bin/env perl

sub getPath {
	my ($url) = @_;
	my @parts = split(m|/|, $url);
	pop @parts;
	unshift @parts, "./" if (@parts == 0);
	return join('/', @parts).'/';
}

use lib getPath($0)."../Applications/lib/";
use strict;
use warnings;
use Data::Dumper;
use foldGrammars::Settings;
use foldGrammars::Utils;

my $TARGET_LAUNCHPAD = 'launchpad';
my $TARGET_PORTS = 'macports';

my @SERIES = ("lucid", "precise", "trusty", "utopic");
#~ my @SERIES = ("lucid", "precise", "trusty");
my $USER = 'Bielefeld BioInformatics Service';
my $EMAIL = 'bibi-help@cebitec.uni-bielefeld.de';
my $TMPDIR = 'tmpDir';
my $KEYFINGERPRINT = '0x8FE66EF2';

my ($package, $comment, $target) = @ARGV;
die "usage: perl $0 <package name> <comment> <target=launchpad | macports>" if (@ARGV != 3);

my $foundPackage = 'false';
foreach my $availPackage (keys(%Settings::PROGINFOS)) {
	if ($package eq $availPackage) {
		$foundPackage = 'true';
		last;
	}
}
if ($foundPackage eq 'false') {
	print STDERR "Can't find package description for '$package', available packages are:\n";
	foreach my $availPackage (keys(%Settings::PROGINFOS)) {
		print STDERR "\t'".$availPackage."'\tversion ".$Settings::PROGINFOS{$availPackage}->{version}. " (".$Settings::PROGINFOS{$availPackage}->{date}.")\n";
	}
	exit(1);
}
die "no comment is given!\n" if ((not defined $comment) || ($comment =~ m/^\s*$/));

if ($target eq $TARGET_LAUNCHPAD) {
	commitDebian($package, $comment);
} else {
	die "target '$target' is unknown. Available targets are '$TARGET_LAUNCHPAD' and '$TARGET_PORTS'\n";
}

sub commitDebian {
	my ($package, $comment) = @_;
	
	if ((exists $Settings::PROGINFOS{$package}->{packageDir}) && (-d $Settings::PROGINFOS{$package}->{packageDir}.'/debian')) {
		my $pathContainingDebian = $Settings::PROGINFOS{$package}->{packageDir};
		my $newversion = $Settings::PROGINFOS{$package}->{version};
		my $currentDir = Utils::execute(Settings::getBinaries("pwd")); chomp $currentDir;
		Utils::execute("rm -rf $TMPDIR") if (-d $TMPDIR);
		mkdir $TMPDIR;
		my $packageDir = $TMPDIR.'/'.$package.'_'.$newversion;
		mkdir $packageDir;
		print Utils::execute("hg clone ../../ $packageDir/$package");
		Utils::execute("cp -r $pathContainingDebian/debian $packageDir");
		Utils::execute("cd $TMPDIR && tar czvf ${package}_$newversion.orig.tar.gz ${package}_$newversion");
		
		foreach my $series (@SERIES) {
			Utils::execute("export DEBFULLNAME=\"$USER\"; export DEBEMAIL=\"$EMAIL\"; cd $pathContainingDebian && debchange --newversion $newversion-0ubuntu1~${series}1 $comment --package $package --distribution $series");
			Utils::execute("cp -r $pathContainingDebian/debian $packageDir");
			print Utils::execute("cd $TMPDIR/${package}_$newversion && debuild -S -k\"$KEYFINGERPRINT\"");
			print Utils::execute("dput ppa:bibi-help/bibitools $TMPDIR/${package}_$newversion-0ubuntu1~${series}1_source.changes");
		}
		Utils::execute("rm -rf $TMPDIR");
	} else {
		die "cannot find debian package description in '".$Settings::PROGINFOS{$package}->{packageDir}."'\n";
	}
}

sub commitOSX {
	my ($package, $comment) = @_;
	
	
}
