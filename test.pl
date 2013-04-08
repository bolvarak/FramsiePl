#!/usr/bin/perl -w

## Use our local library
use lib('/Users/tbrown/Documents/Repositories/FramsiePl/Library');

## Use FramsiePl
use FramsiePl;

## Use the data dumper
use Data::Dumper;

## Dump the FramsiePl instance
print Dumper(FramsiePl::Instance()->AddRedirect('/home', '/default')->Execute('/index.pl/home/default/foo/bar'));
