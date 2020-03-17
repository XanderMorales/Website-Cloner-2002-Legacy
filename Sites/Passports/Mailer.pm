use lib ("/usr/local/apache/sites/allied/perl-lib/");
package Allied::Sites::Passports::Mailer;
$VERSION = '1.0';
use strict;
use CGI qw(:standard);

#########################################################################################
sub contact_us {
	my ($self, @args) = @_;  
	my $email = param('email');
	my $name = param('name');
	my $subject = "Contact Us From $ENV{'HTTP_HOST'}";
	$self->Allied::Sites::Passports::Mailer::send_email_to_us($email, $subject, $self->{CONFIG}{CONTACT_US});
	$self->contactus_thankyou($name);
}

#########################################################################################
sub send_email_to_us {
	my ($self, $from, $subject, @recipients) = @_;  
	my $to = join(', ', @recipients);
open (MAIL, "|$self->{MAILPROG} $to") || warn "Can't open $self->{MAILPROG}!\n";
print MAIL << "END";
Return-Path: <$from> 
From: <$from> 
To: $to
Subject: $subject
MIME-Version: 1.0 
Content-Type: text/html; charset=us-ascii
Status:   

END
my $query= new CGI;
my @names = $query->param;

print MAIL <<"END";
<html><head><title>$subject</title>
</head><body>
<h1>$subject</h1>
END
my $Name;
foreach(@names){
my $value = param("$_");
if($_ eq 'Name'){ $Name = $_; }
if(($_ ne 'page') && ($_ ne 'action')) {
print MAIL <<"END";
<b>$_\</b>: $value<Br>
END
}

print MAIL "</body></html>";
}
close(MAIL);
}
1;
__END__
