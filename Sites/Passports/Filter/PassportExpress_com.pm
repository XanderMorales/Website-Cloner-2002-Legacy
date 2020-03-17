#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::_Initializable;
use Allied::Sites::Passports::PassportsSite;

#############################################################
package Allied::Sites::Passports::Filter::PassportExpress_com;
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
	$self->Allied::Sites::Passports::Filter::Default::_init();
        $self->{FILTER} = 'PassportSite';
        $self->{REQUESTED_PAGE} = $page;
        $self->_set_page($page);
	$self->{CUSTOM_FILES_PATH} = '/usr/local/apache/files/Passports/passportexpress_com/';		# path to custom webiste thtml files

	$self->{CONFIG_FILE} = '/usr/local/apache/files/Passports/passportexpress_com/PassportExpress_com.conf';
	my $conf = new Config::General("$self->{CONFIG_FILE}");
        %{$self->{FILTERED_CONFIG}} = $conf->getall();
        %{$self->{CONFIG}} = (
                %{$self->{CONFIG}},
                %{$self->{FILTERED_CONFIG}},
        );
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
