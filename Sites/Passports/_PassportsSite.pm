use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::Sites::Universal::UniversalSite;
package Allied::Sites::Passports::PassportsSite;
$VERSION =  '1.0';
@ISA = qw (Allied::Sites::Universal::UniversalSite);
#############################################################
use strict;
use CGI qw(:standard);
use vars qw(%__PAGES);

%__PAGES     = (
		home			=> 'home',
                contact_us		=> 'contact_us',
                contactus_thankyou	=> 'contactus_thankyou',
                about_us		=> 'about_us',
                css			=> 'css',
                js			=> 'js',
                affiliates		=> 'affiliates',
                affiliates2		=> 'affiliates2',
                affiliates3		=> 'affiliates3',
                affiliates4		=> 'affiliates4',
                affiliates5		=> 'affiliates5',
                pop_up			=> 'pop_up',
                mailer			=> 'mailer',
                passport		=> 'passport',
                service			=> 'service',
                over16			=> 'over16',
               	under15			=> 'under15',
               	first			=> 'first',
               	second			=> 'second',
		child			=> 'child',
               	child1			=> 'child1',
               	identityform		=> 'identityform',
               	extend			=> 'extend',
               	lost			=> 'lost',
               	renew			=> 'renew',
               	consularform		=> 'consularform',
               	forms			=> 'forms',
               	pages			=> 'pages',
               	name			=> 'name',
		childlost		=> 'childlost',
		child2nd		=> 'child2nd',
		customer_service	=> 'customer_service',
		show_visa		=> 'show_visa',
		corporate_services	=> 'corporate_services',
		test			=> 'test',
); # page= param's!

sub test{
        my ($self, $page, @args) = @_;
	use Config::General;
	my $conf = new Config::General("/usr/local/apache/files/Passports/config.txt");
	my %config = $conf->getall;

	foreach(sort keys %config){
		print "$_ => $config{$_}<br>";
	}
}

#############################################################
sub CHECK_PAGE {
        my ($self, $page, @args) = @_;
	#warn $page;
	my $file = $self->{TEMPLATE_PATH} . $page . '.thtml';
	if (-e $file) {
		$self -> print_header();
        	$self -> thtml($self->{TEMPLATE_PATH},$page . '.thtml');
        	$self -> print_footer();
	} else { $self->Allied::Sites::Universal::UniversalSite::ERROR(); }
}
#############################################################
sub thtml {
        my ($self, $path, $thtml, @args) = @_;
        my $template = HTML::Template->new(filename => $path . $thtml,
					   path=>$self->{TEMPLATE_PATH},
					   'die_on_bad_params', 0, 'cache',0);
	$template->param($self->global_thtml_params());
        print $template->output;
}
#############################################################
sub global_thtml_params {
        my ($self,@args) = @_;
	my $page = param('page') || 'home';

	my $p_u = $self->{PRICING}->{PASSPORT_URGENT};
	$p_u =~ s/\$//g;

	my $p_r = $self->{PRICING}->{PASSPORT_RUSH};
	$p_r =~ s/\$//g;

	my $p_r_s = $self->{PRICING}->{RETURN_SHIPPING};
	$p_r_s =~ s/\$//g;

	my $s_stand = $self->{PRICING}->{SHIPPING_STANDARD};
	$s_stand =~ s/\$//g;

	my $s_sat = $self->{PRICING}->{SHIPPING_SATURDAY};
	$s_sat =~ s/\$//g;

	my $p_u_t = $p_u + $p_r_s;
	my $p_r_t = $p_r + $p_r_s;
	my $shipping_add_for_sat = $s_sat - $s_stand;
	my $p_u_t_w_sat = $p_u + $s_sat;
	my $p_r_t_w_sat = $p_r + $s_sat;
	$self->{CONFIG}->{CURRENT_NAME} 		= $page;
	$self->{CONFIG}->{AFFID} 			= $self->{AFFILIATE_ID};
	$self->{CONFIG}->{AFFILIATE_ID} 		= $self->{AFFILIATE_ID};
	$self->{CONFIG}->{TEMPLATE_PATH}		= $self->{TEMPLATE_PATH};
	$self->{CONFIG}->{AFFILIATE_LOGIN}	= $self->{AFFILIATE_LOGIN};
	$self->{CONFIG}->{AFFILIATE_URL}		= $self->{AFFILIATE_URL};
	$self->{CONFIG}->{SHIPPING_ADD_FOR_SAT}   = '$' . $shipping_add_for_sat;
	$self->{CONFIG}->{PASSPORT_URGENT_TOTAL}  = '$' . $p_u_t;
	$self->{CONFIG}->{PASSPORT_URGENT_TOTAL_WSAT} = '$' . $p_u_t_w_sat;
	$self->{CONFIG}->{PASSPORT_RUSH_TOTAL}        = '$' . $p_r_t;
	$self->{CONFIG}->{PASSPORT_RUSH_TOTAL_WSAT}   = '$' . $p_r_t_w_sat;
	while(my($n,$v)=each(%{$self->{CONFIG}})){
	warn "$n -> $v \n";
	}
	return %{$self->{CONFIG}};
}
#############################################################
sub child {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'child.thtml');
}

#############################################################
#############################################################
###############  AFFIIATE PROGRAM PAGES #####################
#############################################################
#############################################################
sub affiliates {
	my ($self, @args) = @_;	
	$self -> print_header();
	$self -> affiliate_header();
	$self -> thtml($self->{TEMPLATE_PATH},'affiliates.thtml');
	$self->affiliate_footer('javascript:void(0)','/?page=affiliates2');
	$self -> print_footer();
}
#############################################################
sub affiliates2 {
        my ($self, @args) = @_;
	$self -> print_header();
	$self -> affiliate_header();
	$self -> thtml($self->{TEMPLATE_PATH},'affiliates2.thtml');
	$self->affiliate_footer('/?page=affiliates','/?page=affiliates3');
	$self -> print_footer();
}
#############################################################
sub affiliates3 {
        my ($self, @args) = @_;
	$self -> print_header();
	$self -> affiliate_header();
	$self -> thtml($self->{TEMPLATE_PATH},'affiliates3.thtml');
	$self->affiliate_footer('/?page=affiliates2','/?page=affiliates4');
	$self -> print_footer();
}
#############################################################
sub affiliates4 {
        my ($self, @args) = @_;
	$self -> print_header();
	$self -> affiliate_header();
	$self -> thtml($self->{TEMPLATE_PATH},'affiliates4.thtml');
	$self->affiliate_footer('/?page=affiliates3','/?page=affiliates5');
	$self -> print_footer();
}
#############################################################
sub affiliates5 {
        my ($self, @args) = @_;
	$self -> print_header();
	$self -> affiliate_header();
	$self -> thtml($self->{TEMPLATE_PATH},'affiliates5.thtml');
	$self->affiliate_footer('/?page=affiliates4','javascript:void(0)');
	$self -> print_footer();
}
#############################################################
sub affiliate_header {
        my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'affiliate_header.thtml');
}
#############################################################
sub affiliate_footer {
        my ($self, $prev, $next, $print_prev, $print_next) = @_;
        if ($prev !~ /^java/) { $print_prev = 1; }
        if ($next !~ /^java/) { $print_next = 1; }
	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'affiliate_footer.thtml');
		$template->param(
			PRINT_PREV		=> $print_prev,
			URL_PREV		=> $prev,
			AFFILIATE_LOGIN		=> $self->{AFFILIATE_LOGIN},
			AFFILIATE_URL		=> $self->{AFFILIATE_URL},
			PRINT_NEXT		=> $print_next,
			URL_NEXT		=> $next,
		);
        print $template->output;
}

#############################################################
#############################################################
#############  HEADER / FOOTER VARIABLES  ###################
#############################################################
#############################################################
sub contact_us {
        my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'contact_us.thtml');
	$self -> print_footer();
}
#############################################################
sub passport{
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'passport.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub service {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'service.thtml');
	$self -> print_footer();
}
#############################################################
sub over16 {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'over16.thtml');
	$self -> print_footer();
}
#############################################################
sub under15 {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'under15.thtml');
	$self -> print_footer();
}
#############################################################
sub first {
        my ($self, @args) = @_;
        $self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'first.thtml');
        $self -> print_footer();
}
#############################################################
sub second {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'second.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub child1 {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'child1.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub identityform {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'identityform.thtml');
}
#############################################################
sub extend {
        my ($self, @args) = @_;
        $self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'extend.thtml');
        $self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub lost {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'lost.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub renew {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'renew.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub consularform {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'consularform.thtml');
}
#############################################################
sub forms {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'forms.thtml');
	$self -> print_footer();
}
#############################################################
sub pages {
        my ($self, @args) = @_;
        $self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'pages.thtml');
        $self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub name {
        my ($self, @args) = @_;
        $self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'name.thtml');
        $self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub child2nd {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'child2nd.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub childlost {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'childlost.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub customer_service {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'customer_service.thtml');
	$self -> print_footer();
}
#############################################################
sub corporate_services {
	my ($self, @args) = @_;
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'corporate_services.thtml');
	$self -> print_footer();
}

#############################################################
#############################################################
##############  SPECIAL METHOD VARIABLES  ###################
#############################################################
#############################################################
sub contactus_thankyou{
	my ($self, $name, @args) = @_;
	$self -> print_header();
        my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'contactus_thankyou.thtml','die_on_bad_params',0,'cache',1);
		$template->param($self->global_thtml_params());
		$template->param(
			NAME => $name,
		);
        print $template->output;
	$self -> print_footer();
}
#############################################################
sub pop_up {
	my ($self, @args) = @_;
	my $action = param('action');
        my $file = $self->{TEMPLATE_PATH} . "pop/" . $action . '.thtml';
	my $path = $self->{TEMPLATE_PATH} . "pop/";
        if (-e $file) {
                my $template = HTML::Template->new(filename => $file,path=>$path,'die_on_bad_params', 0, 'cache',1);
                $template->param($self->global_thtml_params());
        	print $template->output;
        }
	else { $self->Allied::Sites::Universal::UniversalSite::ERROR(); }
}
#############################################################
sub show_visa {
	my ($self, @args) = @_;
	my $action = param('action');
        my $file = $self->{TEMPLATE_PATH} . "visa/" . $action . '.thtml';
	my $path = $self->{TEMPLATE_PATH} . "visa/";
        if (-e $file) {
                $self -> print_header();
                my $template = HTML::Template->new(filename => $file,path=>$path,'die_on_bad_params', 0, 'cache',1);
        	$template->param($self->global_thtml_params());
        	print $template->output;
                $self -> print_footer();
        }
	else { $self->Allied::Sites::Universal::UniversalSite::ERROR(); }
}
#############################################################
sub mailer {
	my ($self, @args) = @_;
	my $action = param('action');
	my $mailer_method = "\$self->Allied::Sites::Passports::Mailer::$action";
        my $eval = eval($mailer_method);
        my $value =($eval)?$eval:$self->Allied::Sites::Universal::UniversalSite::ERROR();
        return $value;
}

#############################################################
#############################################################
###############  UNIQUE WEB SITE ELEMENTS ###################
#############################################################
#############################################################
# ALEX
sub home {
	my ($self, @args) = @_;	
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{PROMO});
        my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'home.thtml', path => $self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
		$template->param($self->global_thtml_params());
		#$template->param(PROMO => $self->{PROMO});
        print $template->output;
#	print " $self->{PRICING}->{URGENT}  ";
	$self->print_footer($self->{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub about_us {
	my ($self, @args) = @_;	
	$self -> print_header($self->{LEFT_NAV},$self->{PROMO});
	$self -> thtml($self->{CUSTOM_FILES_PATH},'about_us.thtml');
	$self -> print_footer($self->{PROMO},$self->{LEFT_NAV});
}
#############################################################
sub left_nav {
        my ($self, @args) = @_;
	$self -> thtml($self->{CUSTOM_FILES_PATH},'left_nav.thtml');
}
#############################################################
sub pull_down_menu {
        my ($self, @args) = @_;
	$self -> thtml($self->{CUSTOM_FILES_PATH},'pull_down_menu.thtml');
}
#############################################################
sub promo {
        my ($self, @args) = @_;
	$self -> thtml($self->{CUSTOM_FILES_PATH},'promo.thtml');
}
#############################################################
sub js {
        my ($self, @args) = @_;
        my $_affiliate_site_cookie = 'false';           ## is this an affiliate cobrand/private label site? if so change false to affiliate id.
        my $_affiliate_phone_number_cookie = 'true';    ## should we plant a cookie to show extension in phone number?(planted in form for this site!)
        $self->javascript($_affiliate_site_cookie,$_affiliate_phone_number_cookie);
}
#############################################################
sub metatags {
        my ($self, @args) = @_;
	$self -> thtml($self->{CUSTOM_FILES_PATH},'meta_tags.txt');
}
#############################################################
sub css {
        my ($self, @args) = @_;
	$self -> thtml($self->{CUSTOM_FILES_PATH},'passport.css');
}
#############################################################
sub print_header {
	my ($self, $left_nav, $promo, @args) = @_;
	my $affid;
	if (param('affid') ne ''){ $affid = param('affid'); }
        my $template = HTML::Template->new(filename=>$self->{CUSTOM_FILES_PATH} . 'header.thtml',debug=>1,path=>$self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
		$template->param($self->global_thtml_params());
		#$template->param(%{$self->{CONFIG}});
                $template->param(
                        AFFID => $affid,
			LEFT_NAV => $left_nav,
                        PROMO => $promo,
                );
        print $template->output;
}
#############################################################
sub print_footer {
	my ($self, $promo, $left_nav, @args) = @_;	
	my $affid;
	if (param('affid') ne ''){ $affid = param('affid'); }
        my $template = HTML::Template->new(filename=>$self->{CUSTOM_FILES_PATH} . 'footer.thtml',path=>$self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
		$template->param($self->global_thtml_params());
		#$template->param(%{$self->{CONFIG}});
                $template->param(
                        AFFID => $affid,
                        PROMO => $promo,
			LEFT_NAV => $left_nav,
                );
        print $template->output;
}
1;
__END__
