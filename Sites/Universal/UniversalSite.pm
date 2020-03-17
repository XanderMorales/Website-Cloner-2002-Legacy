#############################################################
# Copyright 2002 Aztec Holding and Management Co. and Web Editors
#############################################################
use lib ("/usr/local/apache/sites/allied/perl-lib/");
use HTML::Template;

#############################################################
package Allied::Sites::Universal::UniversalSite;
#############################################################

$VERSION =  '1.0';
use strict;
use vars qw(%__PAGES);

#############################################################
%__PAGES = (
	info		=> 'info',
	ERROR 		=> 'ERROR',
	ContactUs	=> 'ContactUs',
);

sub ContactUs{
	my ($self, @arg) = @_;

print << "END";
<i><b>this is the universal contactus page.</i></b>
END
}

#############################################################
sub ERROR {
        my ($self, @arg) = @_;
        $self -> print_header();
        my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . '404_ERROR.thtml','die_on_bad_params', 0);
                $template->param(
			DOMAIN_NAME => $self->{STYLED_DOMAIN} .".". $self->{TLD},
                );
        print $template->output;
        $self -> print_footer();
}

sub info {
print << "END";
written by the matrix.
END
}

#############################################################
1;
__END__

=pod

=head1 PACKAGE NAME

Allied::Sites::Universal::UniversalSite;

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 AUTHOR

Arturo Martinez de Vara <F<subsonic_youth@yahoo.com>>

=head1 COPYRIGHT

Aztec Holding and Management Co. and Web Editors

=pod
