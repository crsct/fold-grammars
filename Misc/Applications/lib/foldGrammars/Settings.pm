#!/usr/bin/env perl

use strict;
use warnings;

package Settings;

our %PROGINFOS = (
	'rnashapes', 				{date => '07.05.2014', version => '3.2.1', name => 'RNAshapes', packageDir => 'RNAshapes/'},
	'rnaalishapes', 		{date => '07.05.2014', version => '2.4.1', name => 'RNAalishapes', packageDir => 'RNAalishapes/'},
	'pkiss', 						{date => '07.05.2014', version => '2.2.9', name => 'pKiss', packageDir => 'pKiss/'},
	'palikiss',					{date => '07.05.2014', version => '1.0.1', name => 'pAliKiss', packageDir => 'pAliKiss/'},
	'libfoldgrammars', 	{date => '07.05.2014', version => '1.1.3', name => 'libfoldgrammars', packageDir => 'libfoldGrammars/'},
	'rapidshapes', 			{date => '07.05.2014', version => '2.0.8', name => 'RapidShapes', packageDir => 'RapidShapes/'},
	'knotinframe', 			{date => '07.05.2014', version => '2.0.5', name => 'knotinframe', packageDir => 'Knotinframe/'},
	'rapidshapestest', 	{date => '01.03.2013', version => '2.1.0', name => 'RapidShapes-Test'},
	'getoutsidetruth', 	{date => '19.04.2013', version => '1.0.0', name => 'getOutsideTruth'},
	'acms',						{date => '07.05.2014', version => '1.0.4', name => 'acms', packageDir => 'aCMs/'},
	'acmbuild', 				{date => '28.03.2014', version => '1.0.3', name => 'acmbuild'},
	'acmsearch', 				{date => '28.03.2014', version => '1.0.3', name => 'acmsearch'},
);


our $rootDir = '/home/sjanssen/Desktop/fold-grammars/'; #must point to the root directory of the fold-grammars repository!
our $prototypeDirectory = $rootDir; #for RapidShapes: directory where to find bgap sources, i.e. the fold-grammars repository somewhere in the file system
our $bgapDir = '/stefan/'; #must point to the directory containing "bin" "include" "share" and "lib" sub-directories of Bellman's Gap Compiler

our $tmpdir = '/tmp/'; #temporary directory
our $fileseparater = '/'; #character that separates directories in a path, / in unix but \ in windows

our %BINARIES = (
	'cat', 'cat',
	'rm', 'rm',
	'mkdir', 'mkdir',
	'cp', 'cp',
	'mv', 'mv',
	'pwd', 'pwd',
	'gapc', 'gapc',
	'make', 'make',
	'grep', 'grep',
	'echo', 'echo',
	'gunzip', 'gunzip',
	'sh', 'sh',
	'bc', 'bc',
	'head', 'head',
	'tail', 'tail',
	'perl', 'perl',
	'readlink', 'readlink',
	'uname', 'uname',
	'find', 'find',
	'gs', 'gs',
	'RNAsubopt', 'RNAsubopt-2.1.3',
	'RNAfold', 'RNAfold-2.1.3',
	'date', 'date',
	'ln', 'ln',
	'hybrid-ss-min', 'hybrid-ss-min-3.8',
	'ct2b.pl', 'ct2b.pl',
	'centroid_fold', 'centroid_fold',
	'ulimit', 'ulimit',
	'mktemp', 'mktemp',
	'cut', 'cut',
	'wc', 'wc',
	'gcc','gcc',
	'ls','ls',
	'ghc','ghc',
);

our %TDMfiles = (
	'macrostate', 'macrostate.gap',
	'microstate', 'microstate.gap',
	'overdangle', 'overdangle.gap',
	'nodangle', 'nodangle.gap',
);
our $TDMgenerator = 'tdmGenerator.gap';

our $OUTPUT_MINLEFTWIDTH = 7;
our $OUTPUT_FIELDSPACER = "  ";
our $SCIDECIMALS = 3;

our $MODE_MFE = 'mfe';
our $MODE_SUBOPT = 'subopt';
our $MODE_SHAPES = 'shapes';
our $MODE_PROBS = 'probs';
our $MODE_SAMPLE = 'sample';
our $MODE_EVAL = 'eval';
our $MODE_ENFORCE = 'enforce';
our $MODE_LOCAL = 'local';
our $MODE_CAST = 'cast';
our $MODE_KBEST = 'kbest';
our $MODE_LIST = 'list';
our $MODE_ENERGY = 'energy';
our $MODE_ABSTRACT = 'abstract';
our $MODE_OUTSIDE = 'outside';
our $MODE_ANALYSE_OUTSIDE = 'analyse_outside';
our $MODE_PFALL = 'pfall';
our $MODE_MEA = 'mea';

our $MODE_KIF = 'kif'; #single and thus default mode for KnotInFrame

our $MODE_ACM = 'acm'; #single and thus default mode for ACMs

our $ARCHTRIPLE = qx($BINARIES{gcc} -dumpmachine); chomp $ARCHTRIPLE;
our $RNAPARAM1999 =  $Settings::bgapDir.'share/gapc/librna/rna_turner1999.par';
our $RNAPARAM2004 = $Settings::bgapDir.'share/gapc/librna/rna_turner2004.par';

1;
