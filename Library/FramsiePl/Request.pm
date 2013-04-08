#!/usr/bin/perl -w

## Define the package name
package FramsiePl::Request;

## Define the instance placeholder
my($mInstance);

###############################################################################
### Singleton #################################################################
###############################################################################

###
## This subroutine maintains the singleton instance of this class
## @return FramsiePl::Request $mInstance
###
sub Instance {
    ## Check for an existing instance
    if (!$mInstance) {
	## Create a new instance
	$mInstance = new FramsiePl::Request();
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
## @return FramsiePl::Request
###
sub new {
    
}

###############################################################################
### Subroutines ###############################################################
###############################################################################

## Terminate
1;

## We're done
__END__;
