#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::_Initializable;
use Allied::Sites::Passports::PassportsSite;

#############################################################
package Allied::Sites::Passports::Filter::test3_PassportExpress_com;
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
	$self->Allied::Sites::Passports::Filter::Default::_set_page();
}

sub _init {
	my ($self, $page, @arg) = @_;
	$self->Allied::Sites::Passports::Filter::Default::_init($page);
        $self->{FILTER} = 'test3_PassportExpress_com';
	$self->{COMPANY_NAME} = 'Passport Express';							# company name
	$self->{CONTACT_US} = 'alex@alltripinsurance.com';						# email address for contact form
	$self->{CUSTOMER_SERVICE_EMAIL} = 'info@passportexpress.com';					# email adress for info page
	$self->{CUSTOM_FILES_PATH} = '/usr/local/apache/files/Passports/test3_passportexpress_com/';		# path to custom webiste thtml files
        $self->{PRICING} = {
                PASSPORT_URGENT         => '$150',
                PASSPORT_RUSH           => '$100',
                PASSPORT_REGULAR        => '$75',
                VISA_URGENT             => '$100',
                VISA_RUSH               => '$75',
                SHIPPING_STANDARD       => '$15',
                SHIPPING_SATURDAY       => '$25',
		RETURN_SHIPPING         => '$15',
        };
        #you'll have to dereference it either way like this $self->{PRICING}->{URGENT}
        $self->{ORDER_NUMBER} ='(800)284-2564';
        $self->{INFO_NUMBER} ='(401)331-6236';
	return $self;
}

sub run {
	my ($self, @arg) = @_;	
	$self->Allied::Sites::Passports::Filter::Default::run();
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
