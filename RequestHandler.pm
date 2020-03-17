############################################################
# The Website Cloner V2.0								   #
# Copywrite Web Editors 2000 - 2003						   #
# All Rights Reserved!									   #
#														   #
# THE END-USER LICENSE AGREEMENT FOR THE WEBSITE CLONER	   #
# CAN BE FOUND AT: http://www.webeditors.com/terms.shtml   #
# This Software is bound that EULA. The EULA may be		   #
# modified by Web Editors from time to time; you should	   #
# check that document on a	regular basis.				   #
############################################################
use lib ("/usr/local/apache/perl-lib/");
package WebEditors::WebsiteCloner::RequestHandler;
use Apache::Constants qw(:common);
$VERSION =  '2.0';
use strict;


######################################################################################
sub handler{
	my $r = shift;
# temp
	if ( $ENV{'REQUEST_URI'} =~ /^\/clia/i){
	      $r->send_cgi_header(<<EOT);
Content-type: text/html
Location: http://clia.passportexpress.com

EOT
	}
	else {
# temp
	if (($r->content_type() ne 'text/html') && ($r->content_type() ne 'httpd/unix-directory') && ($r->content_type() ne 'text/plain')){ return DECLINED; }
	else {
		my $self = new WebEditors::WebsiteCloner::Reaction($r);
		$self->run($r);
	}
	#else { my $self = new WebEditors::Downloads($r); $self->run($r); }
	} # temp close else
}

######################################################################################

1;
