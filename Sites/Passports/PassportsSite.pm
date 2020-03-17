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
	home				=> 'home',
	contactus_thankyou	=> 'contactus_thankyou',
	about_us			=> 'about_us',
	css					=> 'css',
	js					=> 'js',
	pop_up				=> 'pop_up',
	mailer				=> 'mailer',
	child				=> 'child',
	child1				=> 'child1',
	identityform		=> 'identityform',
	extend				=> 'extend',
	lost				=> 'lost',
	renew				=> 'renew',
	consularform		=> 'consularform',
	forms				=> 'forms',
	pages				=> 'pages',
	name				=> 'name',
	childlost			=> 'childlost',
	child2nd			=> 'child2nd',
	customer_service	=> 'customer_service',
	show_visa			=> 'show_visa',
	corporate_services	=> 'corporate_services',
	test				=> 'test',
	ziplocator			=> 'ziplocator',
	poptop				=> 'poptop',
	popzips				=> 'popzips',
	passport			=> 'yes_left_nav_yes_promo',
	second				=> 'yes_left_nav_yes_promo',
	contact_us			=> 'yes_left_nav_yes_promo',
	service				=> 'yes_left_nav_no_promo',
	over16				=> 'yes_left_nav_no_promo',
	under15				=> 'yes_left_nav_no_promo',
	first				=> 'yes_left_nav_no_promo',
	something			=> 'no_left_nav_no_promo',
	child1415a			=> 'no_left_nav_no_promo',
	child1415b			=> 'no_left_nav_no_promo',
	childa				=> 'no_left_nav_no_promo',
	childb				=> 'no_left_nav_no_promo',
	childlost1415a		=> 'no_left_nav_no_promo',
	childlost1415b		=> 'no_left_nav_no_promo',
	childlosta			=> 'no_left_nav_no_promo',
	childlostb			=> 'no_left_nav_no_promo',
	extenda				=> 'no_left_nav_no_promo',
	extendb				=> 'no_left_nav_no_promo',
	firsta				=> 'no_left_nav_no_promo',
	firstb				=> 'no_left_nav_no_promo',
	losta				=> 'no_left_nav_no_promo',
	lostb				=> 'no_left_nav_no_promo',
	namea				=> 'no_left_nav_no_promo',
	nameb				=> 'no_left_nav_no_promo',
	pagesa				=> 'no_left_nav_no_promo',
	pagesb				=> 'no_left_nav_no_promo',
	renewa				=> 'no_left_nav_no_promo',
	renewb				=> 'no_left_nav_no_promo',
	seconda				=> 'no_left_nav_no_promo',
	secondb				=> 'no_left_nav_no_promo',
	visa_include			=> 'visa_include',
	passport_include		=> 'passport_include',
);


#############################################################
sub passport_include {
	my ($self,@args) = @_;
	my $affid;
	if (param('affid') ne ''){ $affid = param('affid'); }
	my $page ='passport_include';

	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . $page . '.thtml',path=>$self->{TEMPLATE_PATH},'die_on_bad_params', 0, 'cache',0);
        $template->param($self->global_thtml_params());
	$template->param( AFFID => $affid,);
        print $template->output;

	#$self -> thtml($self->{TEMPLATE_PATH},$page . '.thtml');
}
#############################################################
sub visa_include {
	my ($self,@args) = @_;

        my $affid;
        if (param('affid') ne ''){ $affid = param('affid'); }
	my $page ='visa_include';
        my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . $page . '.thtml',path=>$self->{TEMPLATE_PATH},'die_on_bad_params', 0, 'cache',0);
        $template->param($self->global_thtml_params());
        $template->param( AFFID => $affid,);
        print $template->output;
}
#############################################################
sub test{
	my ($self, $page, @args) = @_;
}
#############################################################
sub CHECK_PAGE {
	my ($self, $page, @args) = @_;
	my $file = $self->{TEMPLATE_PATH} . $page . '.thtml';
	if (-e $file) {
		$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
		#$self -> print_header();
		$self -> thtml($self->{TEMPLATE_PATH},$page . '.thtml');
		$self -> print_footer();
	}
	else { $self->Allied::Sites::Universal::UniversalSite::ERROR(); }
}
#############################################################
sub thtml {
	my ($self, $path, $thtml, @args) = @_;
	my $template = HTML::Template->new(filename => $path . $thtml,path=>$self->{TEMPLATE_PATH},'die_on_bad_params', 0, 'cache',0);
	$template->param($self->global_thtml_params());
	print $template->output;
}
#############################################################
sub global_thtml_params {
	my ($self,@args) = @_;
	my $page = param('page') || 'home';

	my $p_u = $self->{CONFIG}->{PASSPORT_URGENT};
	$p_u =~ s/\$//g;

	my $p_r = $self->{CONFIG}->{PASSPORT_RUSH};
	$p_r =~ s/\$//g;

	my $p_r_s = $self->{CONFIG}->{RETURN_SHIPPING};
	$p_r_s =~ s/\$//g;

	my $s_stand = $self->{CONFIG}->{SHIPPING_STANDARD};
	$s_stand =~ s/\$//g;

	my $s_sat = $self->{CONFIG}->{SHIPPING_SATURDAY};
	$s_sat =~ s/\$//g;

	my $p_u_t = $p_u + $p_r_s;
	my $p_r_t = $p_r + $p_r_s;
	my $shipping_add_for_sat = $s_sat - $s_stand;
	my $p_u_t_w_sat = $p_u + $s_sat;
	my $p_r_t_w_sat = $p_r + $s_sat;
	$self->{CONFIG}->{CURRENT_PAGE} 		= $page;
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

	while(my($n,$v)=each(%__PAGES)){
	if($n eq $page){ $self->{CONFIG}->{$n} = '1'; }
	else { $self->{CONFIG}->{$n} = '0'; }
	}

	return %{$self->{CONFIG}};
}
#############################################################
sub child {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'child.thtml');
}
#########################
# no left nav, no promo #
#########################
sub no_left_nav_no_promo {
	my ($self, @args) = @_;
	my $page=param('page');
	$self -> print_header();
	$self -> thtml($self->{TEMPLATE_PATH},"$page" . '.thtml');
	$self -> print_footer();
}
###########################
# yes left nav, yes promo #
###########################
sub yes_left_nav_yes_promo {
	my ($self, @args) = @_;
	my $page=param('page');
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},"$page" . '.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
###########################
# yes left nav, no promo #
###########################
sub yes_left_nav_no_promo {
	my ($self, @args) = @_;
	my $page=param('page');
	$self -> print_header($self->{CONFIG}{LEFT_NAV},'');
	$self -> thtml($self->{TEMPLATE_PATH},"$page" . '.thtml');
	$self -> print_footer('',$self->{CONFIG}{LEFT_NAV});
}

#############################################################
#############################################################
#############  HEADER / FOOTER VARIABLES  ###################
#############################################################
#############################################################

#############################################################
sub child1 {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'child1.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub identityform {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'identityform.thtml');
}
#############################################################
sub extend {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'extend.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub lost {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'lost.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub renew {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'renew.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub consularform {
	my ($self, @args) = @_;
	$self -> thtml($self->{TEMPLATE_PATH},'consularform.thtml');
}
#############################################################
sub forms {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'forms.thtml');
	$self -> print_footer();
}
#############################################################
sub pages {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'pages.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub name {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'name.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub child2nd {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'child2nd.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub childlost {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'childlost.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub customer_service {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{TEMPLATE_PATH},'customer_service.thtml');
	$self -> print_footer();
}
#############################################################
sub corporate_services {
	my ($self, @args) = @_;
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
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
sub home {
	my ($self, @args) = @_;	
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'home.thtml', path => $self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
	$template->param($self->global_thtml_params());
	print $template->output;
	$self->print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub ziplocator {
	my ($self, @args) = @_;	
	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'ziplocator.thtml', path => $self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
	$template->param($self->global_thtml_params());
	print $template->output;
}
#############################################################
sub poptop {
	my ($self, @args) = @_;	
	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'poptop.thtml', path => $self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
	$template->param($self->global_thtml_params());
	print $template->output;
}
#############################################################
sub popzips {
	my ($self, @args) = @_;	
	my $template = HTML::Template->new(filename => $self->{TEMPLATE_PATH} . 'popzips.thtml', path => $self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
	$template->param($self->global_thtml_params());
	print $template->output;
}
#############################################################
sub about_us {
	my ($self, @args) = @_;	
	$self -> print_header($self->{CONFIG}{LEFT_NAV},$self->{CONFIG}{PROMO});
	$self -> thtml($self->{CUSTOM_FILES_PATH},'about_us.thtml');
	$self -> print_footer($self->{CONFIG}{PROMO},$self->{CONFIG}{LEFT_NAV});
}
#############################################################
sub js {
	my ($self, @args) = @_;
	my $_affiliate_site_cookie = 'false';           ## is this an affiliate cobrand/private label site? if so change false to affiliate id.
	my $_affiliate_phone_number_cookie = 'true';    ## should we plant a cookie to show extension in phone number?(planted in form for this site!)
	$self->javascript($_affiliate_site_cookie,$_affiliate_phone_number_cookie);
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
	#my $template = HTML::Template->new(filename=>$self->{CUSTOM_FILES_PATH} . 'header.thtml',debug=>1,path=>$self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
	my $template = HTML::Template->new(filename=>$self->{CUSTOM_FILES_PATH} . 'header.thtml',path=>$self->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
	$template->param($self->global_thtml_params());
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
	$template->param(
		AFFID => $affid,
		PROMO => $promo,
		LEFT_NAV => $left_nav,
	);
	print $template->output;
}
1;
__END__
