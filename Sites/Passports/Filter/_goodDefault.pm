#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::_Initializable;
use Allied::Sites::Passports::PassportsSite;

#############################################################
package Allied::Sites::Passports::Filter::Default;
#############################################################

$VERSION =  '1.0';
@ISA = ('Allied::_Initializable',
	'Allied::Sites::Passports::PassportsSite',
	'Allied::Sites::Passports::Mailer',
	'Allied::Sites::Passports::JavaScript');

use strict;
use CGI qw(:standard);
#############################################################
{ # BEGIN CLASS CLOSURE
my %__CUSTOM_PAGES = ();
sub _set_page {
	my ($self, @arg) = @_;	
	#$self->Allied::Sites::Passports::Filter::Default::_set_page(); uncomment for cobrand or private label!!!
	# create the available page hash by merging the Universal, AllTrip and Filter hashs
	my %_PAGES = (	%Allied::Sites::Universal::UniversalSite::__PAGES,
		   	%Allied::Sites::Passports::PassportsSite::__PAGES,
			%__CUSTOM_PAGES
		     );
        if ($self->{REQUESTED_PAGE} ne '') {
                my $eval_code = "\$self->{PAGE} = sub { \$self->$_PAGES{ $self->{REQUESTED_PAGE} }; };";
                        eval($eval_code);
                        if ($@) { $self->{PAGE} = sub { $self->CHECK_PAGE($self->{REQUESTED_PAGE}); }; }
        }
}

sub _init {
	my ($self, $page, @arg) = @_;
	#$self->Allied::Sites::Passports::Filter::Default::_init($page); uncomment for cobrand or private label!!!
        $self->{ERROR_PAGE} = sub { $self->ERROR; };
        $self->{FILTER} = 'Default';
        $self->{REQUESTED_PAGE} = $page;
        $self->_set_page($page);
	$self->{MAILPROG} = '/usr/sbin/sendmail';
	$self->{AFFILIATE_URL} = 'http://affiliates.allpassportsandvisas.com/cgibin/signup.cgi';
	$self->{AFFILIATE_LOGIN} = 'http://affiliates.allpassportsandvisas.com/cgibin/stats.cgi';
	$self->{TEMPLATE_PATH} = '/usr/local/apache/files/Passports/content/';
	$self->{AFFILIATE_ID} = "<script> var id=get_cookie_value('affiliate'); if (id != null) document.write('AffiliateID: '+id);</script>";
	$self->{COMPANY_NAME} = 'Instant Passport';							# company name
	$self->{CONTACT_US} = 'alex@alltripinsurance.com';						# email address for contact form
	$self->{CUSTOMER_SERVICE_EMAIL} = 'info@instantpassport.com';					# email adress for info page
	$self->{PROMO} = 1;										# Promotional items 1=on 0=off
	$self->{LEFT_NAV} = 1;										# left navivation 1=on 0=off	
	$self->{CUSTOM_FILES_PATH} = '/usr/local/apache/files/Passports/instantpassport_com/';		# path to custom webiste thtml files
        $self->{PRICING} = {
                PASSPORT_URGENT         => '$110',
                PASSPORT_RUSH           => '$75',
                PASSPORT_REGULAR        => '$75',
                VISA_URGENT             => '$75',
                VISA_RUSH               => '$50',
                SHIPPING_STANDARD       => '$15',
                SHIPPING_SATURDAY       => '$25',
		RETURN_SHIPPING		=> '$15',
        };
        #you'll have to dereference it either way like this $self->{PRICING}->{URGENT}
        $self->{ORDER_NUMBER} ='(800)284-2564';
        $self->{INFO_NUMBER} ='(401)331-6236';
	$self->{IP}=0;
	$self->{PE}=0;
	$self->{AB}=0;
	return $self;
}

sub run {
	my ($self, @arg) = @_;	
	#$self->Allied::Sites::Passports::Filter::Default::run(); uncomment for cobrand or private label!!!
        &{ $self->{PAGE} };
}

##### ADD FILTERED SUBS BELOW #######

} # END CLASS CLOSURE
#############################################################
1;
__END__

=pod

=head1 PACKAGE NAME

Allied::Sites::Passports::Default;

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 AUTHOR

Arturo Martinez de Vara <F<subsonic_youth@yahoo.com>>

=head1 COPYRIGHT

Aztec Holding and Management Co. and Web Editors

=pod
