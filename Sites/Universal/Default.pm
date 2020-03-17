#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::_Initializable;
use Allied::Sites::Universal::UniversalSite;

#############################################################
package Allied::Sites::Universal::Default;
#############################################################

$VERSION =  '1.0';
@ISA = qw (Allied::_Initializable Allied::Sites::Universal::UniversalSite);

#############################################################
{ # BEGIN CLASS CLOSURE
my %_PAGES = (
);
my $_FILTER = 'Amigo';
sub _init{
	my ($self, $page, @arg) = @_;	
        $self->{PAGE} = \&ERROR;
	return $self;
}
sub run {
	my ($self, @arg) = @_;	
        &{$self->{PAGE}};
}

} # END CLASS CLOSURE
#############################################################
1;
__END__

=pod

=head1 PACKAGE NAME

Allied::Sites::Universal::Default;

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 AUTHOR

Arturo Martinez de Vara <F<subsonic_youth@yahoo.com>>

=head1 COPYRIGHT

Aztec Holding and Management Co. and Web Editors

=pod
