#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::_Initializable;
use Allied::Sites::Passports::PassportsSite;

#############################################################
package Allied::Sites::Passports::Filter::Matrix;
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
        $self->{FILTER} = 'Matrix';
        $self->{REQUESTED_PAGE} = $page;
        $self->{CONFIG_FILE} = '/usr/local/apache/sites/allied/config/test.conf';
	my $conf = new Config::General("$self->{CONFIG_FILE}");
	%{$self->{CONFIG}} = $conf->getall();

        $self->_set_page($page);
	
	return $self;
}

sub run {
	my ($self, @arg) = @_;	
	#$self->Allied::Sites::Passports::Filter::Default::run(); uncomment for cobrand or private label!!!
        &{ $self->{PAGE} };
}

##### ADD FILTERED SUBS BELOW #######
sub home {
	my ($self, @arg) = @_;	
print "$self->{FILTER}<p>";
foreach (%{$self->{CONFIG}}){
print "$_  ->  $self->{CONFIG}->{$_}\n<p>";
}

}

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
