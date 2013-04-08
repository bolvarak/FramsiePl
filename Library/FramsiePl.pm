#!/usr/bin/perl -w

## Define the package name
package FramsiePl;

## We want to allow INI config files
use Config::INI::Reader;

## We want easy directory determination
use Cwd;

## Allow data dumping
use Data::Dumper;

## We want to allow JSON config files and communications
use JSON;

## We want to allow dynamic module loading
use Module::Load;

## Use strict syntax
use strict;

## We want to allow XML config files and communications
use XML::Simple;

## Create an instance placeholder
my($mInstance);

###############################################################################
### Singleton #################################################################
###############################################################################

###
## This subroutine maintains the singleton instance of this package
## @param string $sBasePath [undef]
## @return FramsiePl $oSelf
###
sub Instance {
	## Check for an instance
	if (!$mInstance) {
		## Load the base path
		my($sBasePath) = shift;
		## Create a new instance
		$mInstance = new FramsiePl($sBasePath);
	}
	## Return the instance
	return $mInstance;
}

###
## This subroutine sets an external instance of FramsiePl into this instance
###
sub SetInstance {
	## Load the instance
	my($oNewInstance) = shift;
	## Check the instance type
	if (ref $oNewInstance eq 'FramsiePl') {
		## Set the new instance
		$mInstance = $oNewInstance;
		## Return the instance
		return $mInstance;
	}
	## Not a FramsiePl instance, terminate
	die("The provided instance reference is not that of FramsiePl.\n");
}

###############################################################################
### Constructor ###############################################################
###############################################################################

###
## This constructor sets up the package, which should always be a singleton
## @param string $sClass
## @param string $sBasePath
## @return FramsiePl $oSelf
###
sub new {
	## Load the class name
	my($sClass) = shift;
	## Setup the instance
	my($oSelf)  = {
		ApplicationPath   => getcwd().'/Application',
		BasePath          => shift || getcwd(),
		ConfigurationPath => getcwd().'/Conf',
		ControllerPath    => getcwd().'/Application/Controllers',
		ModelPath         => getcwd().'/Application/Models',
		ModulePath        => getcwd().'/Library',
		Redirects         => {},
		TemplatePath      => getcwd().'/Application/Templates',
		ViewPath          => getcwd().'/Application/Views'
	};
	## Bless the class and return the instance
	return bless($oSelf, $sClass);
}

###############################################################################
### Subroutines ###############################################################
###############################################################################

###
## This subroutine adds a controller/view redirect into the instance
## @param FramsiePl $oSelf
## @param string $sSource
## @param string $sDestination
## @return FramsiePl $oSelf
###
sub AddRedirect {
	## Load the instance, source and destination
	my($oSelf, $sSource, $sDestination) = @_;
	## Set the redirect into the instance
	$oSelf->{"Redirects"}{$sSource}     = $sDestination;
	## Return the instance
	return $oSelf;
}


sub Execute {
	## Load the instance
	my($oSelf) = shift;
}

###############################################################################
### Getters ###################################################################
###############################################################################

###
## This subroutine returns the current ApplicationPath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ApplicationPath"}
###
sub GetApplicationPath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ApplicationPath"};
}

###
## This subroutine returns the current BasePath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"BasePath"}
###
sub GetBasePath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"BasePath"};
}

###
## This subroutine returns the current ConfigurationPath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ConfigurationPath"}
###
sub GetConfigurationPath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ConfigurationPath"};
}

###
## This subroutine returns the current ControllerPath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ControllerPath"}
###
sub GetControllerPath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ControllerPath"};
}

###
## This subroutine returns the current ModelPath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ModelPath"}
###
sub GetModelPath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ModelPath"};
}

###
## This subroutine returns the current ModulePath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ModulePath"}
###
sub GetModulePath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ModulePath"};
}

###
## This subroutine returns the current TemplatePath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"TemplatePath"}
###
sub GetTemplatePath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"TemplatePath"};
}

###
## This subroutine returns the current ViewPath from the instance
## @param FramsiePl $oSelf
## @return string $oSelf->{"ViewPath"}
###
sub GetViewPath {
	## Load the instance
	my($oSelf) = shift;
	## Return the path
	return $oSelf->{"ViewPath"};
}

###############################################################################
### Setters ###################################################################
###############################################################################

###
## This subroutine sets the ApplicationPath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetApplicationPath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the ApplicationPath
	$oSelf->{"ApplicationPath"} =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the BasePath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetBasePath {
	## Load the path
	my($oSelf, $sPath)   = @_;
	## Set the BasePath
	$oSelf->{"BasePath"} = $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the ConfigurationPath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetConfigurationPath {
	## Load the path
	my($oSelf, $sPath)            =  @_;
	## Localize the BasePath
	my($sBasePath)                =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                        =~  s/~/${sBasePath}/g;
	## Set the ConfigurationPath
	$oSelf->{"ConfigurationPath"} =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the ControllerPath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetControllerPath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the ControllerPath
	$oSelf->{"ControllerPath"}  =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the ModelPath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetModelPath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the ModelPath
	$oSelf->{"ModelPath"}       =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the ModulePath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetModulePath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the ModulePath
	$oSelf->{"ModulePath"}      =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the TemplatePath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetTemplatePath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the TemplatePath
	$oSelf->{"TemplatePath"}    =  $sPath;
	## Return the instance
	return $oSelf;
}

###
## This subroutine sets the ViewPath into the instance
## @param FramsiePl $oSelf
## @param string $sPath
## @return FramsiePl $oSelf
###
sub SetViewPath {
	## Load the path
	my($oSelf, $sPath)          =  @_;
	## Localize the BasePath
	my($sBasePath)              =  $oSelf->{"BasePath"};
	## Replace the tilda with the base path
	$sPath                      =~  s/~/${sBasePath}/g;
	## Set the ViewPath
	$oSelf->{"ViewPath"}        =  $sPath;
	## Return the instance
	return $oSelf;
}

## Terminate
1;

## We're done
__END__;
