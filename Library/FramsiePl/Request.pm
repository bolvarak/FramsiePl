#!/usr/bin/perl -w

## Define the package name
package FramsiePl::Request;

## Use the data dumper
use Data::Dumper;

## We want to dynamically load modules
use Module::Load;

## Use strict syntax
use strict;

## Define the instance placeholder
my($mInstance);

###############################################################################
### Singleton #################################################################
###############################################################################

###
## This subroutine maintains the singleton instance of this class
## @param string $sRequestUri
## @return FramsiePl::Request $mInstance
###
sub Instance {
	## Load the request URI
	my($sRequestUri) = shift;
	## Check for an existing instance
	if (!$mInstance) {
		## Create a new instance
		$mInstance = new FramsiePl::Request($sRequestUri);
	}
	## Return the instance
	return $mInstance;
}

###
## This subroutine sets an external instance into this class
## @param FramsiePl::Request $oInstance
## @return FramsiePl::Request $mInstance
###
sub SetInstance {
	## Load the external instance
	my($oInstance) = shift;
	## Check the instance
	if (ref $oInstance eq 'FramsiePl::Request') {
		## Set the instance
		$mInstance = $oInstance;
		## Return the instance
		return $mInstance;
	}
	## This is not a proper instance, terminate
	die("The provided instance is not that of FramsiePl::Request.\n");
}

###############################################################################
### Constructor ###############################################################
###############################################################################

###
## The constructor sets up the package and instance variables
## @param string $sClass
## @param string RequestUri [undef]
## @return FramsiePl::Request
###
sub new {
	## Load the class name
	my($sClass) = shift;
	## Define the instance
	my($oSelf)  = {
		Controller   => undef,
		Headers      => undef,
		PostData     => (),
		Query        => (),
		Request      => shift || $ENV{REQUEST_URI},
		RequestParts => [],
		View         => undef
	};
	## Return the blessed instance
	return bless($oSelf, $sClass);
}

###############################################################################
### Subroutines ###############################################################
###############################################################################

###
## This subroutine routes the request based on the request URI
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Request $oSelf
###
sub Route {
	## Load the instance
	my($oSelf) = shift;
	## Load the request
	$oSelf->_processRequest();
	## Load the controller
	$oSelf->_processController();
	## Load the view
	$oSelf->_processView();
	## Load the query
	$oSelf->_processQuery();
	## Return the instance
	return $oSelf;
}

###############################################################################
### Protected Subroutines #####################################################
###############################################################################

###
## This subroutine processes the controller from the request
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Request $oSelf
###
sub _processController {
	## Load the instance
	my($oSelf) = shift;
	## Grab the controller
	my($sController)     = @{$oSelf->{"RequestParts"}}[0];
	## Check for special characters
	if ($sController =~ m/[^a-zA-Z\d]/) {
		## Split the parts up
		my(@aParts)  = split(/[^a-zA-Z\d]/, $sController);
		## Reset the controller
		$sController = "";
		## Loop through the parts
		foreach my $sPart (@aParts) {
			## Append the parts to the controller name
			$sController .= ucfirst($sPart);
		}
	}
	## Setup the controller path
	my($sControllerPath) = FramsiPl::Instance()->GetControllerPath()."/$sController.pm";
	## Check to see if the controller exists
	if (-e $sControllerPath) {
		## Load the controller
		load $sController;
		## Set the controller into the instance
		$oSelf->{"Controller"} = $sController->new();
		## Remove the controller from the request parts
		shift(@{$oSelf->{"RequestParts"}});
	} else {
		## Load the default controller
		load "Default";
		## Set the controller into the instance
		$oSelf->{"Controller"} = Default->new();
	}
	## Check the controller instance
	if (!$oSelf->{"Controller"}->isa('FramsiePl::Controller')) {
		## This is not a valid FramsiePl::Controller
		die(ref $oSelf->{"Controller"}." is not a valid instance of FramsiePl::Controller.\n");
	}
	## Check to see if the controller has an __initialize magic subroutine
	if ($oSelf->{"Controller"}->can("__initialize")) {
		## Execute the __initialize subroutine
		$oSelf->{"Controller"}->__initialize();
	}
	## Return the instance
	return $oSelf;
}

###
## This subroutine processes the remaining parts of the request URI into the instance
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Request $oSelf
###
sub _processQuery {
	## Load the instance
	my($oSelf) = shift;
	## Loop through the last of the request parts
	for (my $iParam = 0; $iParam < scalar(@{$oSelf->{"RequestParts"}}); $iParam += 2) {
		## Add the parameter to the query
		$oSelf->{"Query"}{@{$oSelf->{"RequestParts"}}[$iParam]} = FramsiePl::Instance()->DetermineTrueValue(@{$oSelf->{"RequestParts"}}[($iParam + 1)]) || undef;
	}
	## Return the instance
	return $oSelf;
}

###
## This subroutine splits up the request URI
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Request $oSelf
###
sub _processRequest {
	## Load the instance
	my($oSelf)        = shift;
	## Load the query string
	my($sQueryString) = $ENV{"QUERY_STRING"};
	## Check for a filename
	if ($oSelf->{"Request"} =~ m/\/?index\.pl/i) {
		## Remove the filename
		$oSelf->{"Request"} =~ s/\/?index\.pl//i;
	}
	## Remove the query string
	$oSelf->{"Request"} =~ s/${sQueryString}//;
	## Split the request parts
	@{$oSelf->{"RequestParts"}} = split(/\//, $oSelf->{"Request"});
	## Check the first part
	if (!@{$oSelf->{"RequestParts"}}[0]) {
		## Remove the empty request part
		shift(@{$oSelf->{"RequestParts"}});
	}
	## Return the instance
	return $oSelf;
}

###
## This subroutine processes the view from the request URI
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Request $oSelf
###
sub _processView {
	## Load the instance
	my($oSelf) = shift;
	## Define the view placeholder
	my($sView);
	## Check for a view
	if (defined(@{$oSelf->{"RequestParts"}}[0])) {
		## Grab the controller
		$sView = @{$oSelf->{"RequestParts"}}[0];
		## Check for special characters
		if ($sView =~ m/[^a-zA-Z\d]/) {
			## Split the parts up
			my(@aParts)  = split(/[^a-zA-Z\d]/, $sView);
			## Reset the controller
			$sView = $aParts[0];
			## Remove the first part
			shift(@aParts);
			## Loop through the parts
			foreach my $sPart (@aParts) {
				## Append the parts to the controller name
				$sView .= ucfirst($sPart);
			}
		}
		## Remove the view from the request parts
		shift(@{$oSelf->{"RequestParts"}});
	} else {
		## Set the view to the default view
		$sView = "index";
	}
	## Check to see if the view method exists
	if (!$oSelf->{"Controller"}->can($sView)) {
		## The view method does not exist
		die("The view method \"$sView\" does not exist in the \"".ref $oSelf->{"Controller"}.".\"\n");
	}
	## Execute the view method
	$oSelf->{"Controller"}->$sView();
	## Set the view into the instance
	$oSelf->{"View"} = $oSelf->{"Controller"}->getView();
	## Return the instance
	return $oSelf;
}

###############################################################################
### Getters ###################################################################
###############################################################################

###
## This subroutine returns the current controller from the instance
## @param FramsiePl::Request $oSelf
## @return FramsiePl::Controller $oSelf->{"Controller"}
###
sub GetController {
	## Load the instance
	my($oSelf) = shift;
	## Return the controller instance
	return $oSelf->{"Controller"};
}

###
## This subroutine returns the current request headers from the instance
## @param FramsiePl::Request $oSelf
## @return hash $oSelf->{"Headers"}
###
sub GetHeaders {
	## Load the instance
	my($oSelf) = shift;
	## Return the request headers
	return $oSelf->{"Headers"};
}

###
## This subroutine returns a GET/POST/Query request parameter from the instance
## @param FramsiePl::Request $oSelf
## @param string $sParam
## @return mixed|undef
###
sub GetParam {
	## Load the instance and desired parameter
	my($oSelf, $sParam) = @_;
	## Check to see if the parameter exists in the POST request
	if ($oSelf->{"Post"}{$sParam}) {
		## Return the parameter
		return $oSelf->{"PostData"}{$sParam};
	}
	## Check to see if the parameter exists in the GET request
	if ($oSelf->{"Query"}{$sParam}) {
		## Return the parameter
		return $oSelf->{"Query"}{$sParam};
	}
	## Return undefined by default
	return undef;
}

###
## This subroutine returns the current POST request from the instance
## @param FramsiePl::Request $oSelf
## @return hash $oSelf->{"PostData"}
###
sub GetPostData {
	## Load the instance
	my($oSelf) = shift;
	## Return the POST hash
	return $oSelf->{"PostData"};
}

###
## This subroutine returns the current GET/Query request from the instance
## @param FramsiePl::Request $oSelf
## @return hash $oSelf->{"Query"}
###
sub GetQuery {
	## Load the instance
	my($oSelf) = shift;
	## Return the query parameters
	return $oSelf->{"Query"};
}

###
## This subroutine returns the current request URI from the instance
## @param FramsiePl::Request $oSelf
## @return string $oSelf->{"Request"}
###
sub GetRequest {
	## Load the instance
	my($oSelf) = shift;
	## Return the request URI
	return $oSelf->{"Request"};
}

###
## This subroutine returns the current view from the instance
## @param FramsiePl::Request $oSelf
## @return FramsiePl::View
###
sub GetView {
	## Load the instance
	my($oSelf) = shift;
	## Return the view instance
	return $oSelf->{"View"};
}

## Terminate
1;

## We're done
__END__;
