package WebEditors::RequestHandler;

use lib ("/home/sites/webeditors/com/perl-lib/");
use Apache::Constants qw(:common);
$VERSION =  '1.0';
use strict;

sub handler{
	my $r = shift;
	if (($r->content_type() ne 'text/html') && ($r->content_type() ne 'httpd/unix-directory') && ($r->content_type() ne 'text/plain')){ return DECLINED; }
	else { my $self = new WebEditors::Downloads($r); $self->run($r); }
}
1;