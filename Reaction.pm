############################################################
# The Website Cloner V2.0								   #
# Copywrite Web Editors 2000 - 2003						   #
# All Rights Reserved!									   #
#														   #
# THE END-USER LICENSE AGREEMENT FOR THE WEBSITE CLONER	   #
# CAN BE FOUND AT: http://www.webeditors.com/terms.shtml   #
# This Software is bound that EULA. The EULA may be		   #
# modified by Web Editors from time to time; you should	   #
# check that document on a	regular basis.				   #
############################################################
use lib ("/usr/local/apache/perl-lib/");
package WebEditors::WebsiteCloner::Reaction;
$VERSION =  '2.0';
use strict;

{ # BEGIN CLASS CLOSURE
#############################################################
sub new{
        my ($class, $r, @arg) = @_;
        my $self = bless {}, ref($class) || $class;
        $self->_init($r, @arg);
        return $self;
}
#############################################################
sub _init{
	my ($self, $r, @arg) = @_;
	# url params
	my %params = $r->args;
	%params = (%params, $r->content);
	%{$self->{PARAMS}} =  %params;
	# get url params like so $self->{PARAMS}->{page} where page is ?page = whatever
	
	$self->{SITE_FILTER} = $self->_get_site_filter($arg[0]);
	($self->{SITE_BASE}, $self->{FILTER}) = split(/\./,$self->{SITE_FILTER});

	return $self;
}

# Define Class Globals
my %_site_filter = (

	#####################################################
	## .NET SITES 
	#####################################################
	net => {
	},

	#####################################################
	## .COM SITES 
	#####################################################
	com => {
			aaainstantpassport	=> {
				affiliates	=> 'CRS.Default',
				aaans1		=> 'Passports.AAAInstantPassport_com',
				aaans2		=> 'Passports.AAAInstantPassport_com',
				www			=> 'Passports.AAAInstantPassport_com',
				CATCH_ALL	=> 'Passports.AAAInstantPassport_com',
			},
			allpassportsandvisas	=> {
				affiliates	=> 'CRS.Default',
				eric		=> 'Passports.Default',
				config	 	=> 'Passports.Matrix',
				'config2'	=> 'Passports.Matrix2',
				'test'		=> 'Passports.InstantPassport_com',
				'test2'		=> 'Passports.PassportExpress_com',
				'test3'		=> 'Passports.test3_PassportExpress_com',
				'abriggs'	=> 'Passports.ABriggs_com',
				CATCH_ALL	=> 'Passports.Default',
				STYLED_DOMAIN	=> 'InstantPassport',
			},
			passportnetwork         => {
				affiliates	=> 'CRS.Default',
				'abns1'		=> 'Passports.ABriggs_com',
				'abns2'		=> 'Passports.ABriggs_com',
				'abriggs'	=> 'Passports.ABriggs_com',
				'ipns1'		=> 'Passports.InstantPassport_com',
				'ipns2'		=> 'Passports.InstantPassport_com',
				'pens1'		=> 'Passports.PassportExpress_com',
				'pens2'		=> 'Passports.PassportExpress_com',
				www			=> 'Passports.Default',
				CATCH_ALL	=> 'Passports.Default',
                        },
			abriggs			=> {
				affiliates	=> 'CRS.Default',
				'abns1'		=> 'Passports.ABriggs_com',
				'abns2'		=> 'Passports.ABriggs_com',
				www			=> 'Passports.ABriggs_com',
				CATCH_ALL	=> 'Passports.ABriggs_com',
			},
			'123instantpassport'         => {
				affiliates	=> 'CRS.Default',
                                www             => 'Passports.InstantPassport_com',
                                CATCH_ALL       => 'Passports.InstantPassport_com',
                        },
			instantpassport		=> {
				affiliates	=> 'CRS.Default',
				'demo'		=> 'Passports.Demo_InstantPassport_com',
				'demons1'	=> 'Passports.Demo_InstantPassport_com',
				'demons2'	=> 'Passports.Demo_InstantPassport_com',
				'ipns1'		=> 'Passports.InstantPassport_com',
				'ipns2'		=> 'Passports.InstantPassport_com',
				www		=> 'Passports.InstantPassport_com',
				CATCH_ALL	=> 'Passports.InstantPassport_com',
			},
			passportexpress		=> {
				affiliates	=> 'CRS.Default',
				'clia'		=> 'Passports.Clia_PassportExpress_com',
				'cruise411'	=> 'Passports.Cruise411_InstantPassport_com',
				'aaa'		=> 'Passports.AAA_PassportExpress_com',
				'aaans1'	=> 'Passports.AAA_PassportExpress_com',
				'aaans2'	=> 'Passports.AAA_PassportExpress_com',
				'orbitz'	=> 'Passports.Orbitz_PassportExpress_com',
				'orbitzns1'	=> 'Passports.Orbitz_PassportExpress_com',
				'orbitzns2'	=> 'Passports.Orbitz_PassportExpress_com',
				'demo'		=> 'Passports.Demo_PassportExpress_com',
				'demons1'	=> 'Passports.Demo_PassportExpress_com',
				'demons2'	=> 'Passports.Demo_PassportExpress_com',
				'pens1'		=> 'Passports.PassportExpress_com',
				'pens2'		=> 'Passports.PassportExpress_com',
				'taedge1'	=> 'Passports.Taedge1_PassportExpress_com',
				'taedge2'	=> 'Passports.Taedge2_PassportExpress_com',
				www			=> 'Passports.PassportExpress_com',
				CATCH_ALL   => 'Passports.PassportExpress_com',
			},
	},

	#####################################################
	## .ORG SITES 
	#####################################################
	org => {
	},

	#####################################################
	## .BIZ SITES 
	#####################################################
	biz =>	{
	},

	#####################################################
	## .INFO SITES 
	#####################################################
	info =>	{
	},

CATCH_ALL 	=>   'Passports.Default'
);

my %_available_sites = (
	CRS		=> 	'On',
	Passports	=> 	'On',
	Universal	=> 	'On',
);



sub run {
	my ($self, @arg) = @_;
	my $site;
	my $page_to_run = CGI::param('page') || "home";
	if ($_available_sites{$self->{SITE_BASE}} eq 'On'){
		my $eval_code = "\$site = new Allied::Sites::$self->{SITE_BASE}::Filter::$self->{FILTER}(\"$page_to_run\");";
		eval($eval_code);
	}
	else {
		my $site = new Allied::Sites::Universal::Default('ERROR');
	}
	#warn $@; #UCOMMENT TO CHECK FOR UNBLESSED REFERENCE ERROR
	$site->{SUB_DOMAIN} = $self->{SUB_DOMAIN};
	$site->{DOMAIN} = $self->{DOMAIN};
	$site->{TLD} = $self->{TLD};
	$site->{SERVER_NAME} = lc($ENV{HTTP_HOST});
	$site->{STYLED_DOMAIN} = $_site_filter{$self->{TLD}}->{$self->{DOMAIN}}->{STYLED_DOMAIN} || $ENV{'HTTP_HOST'};
	$site->run();
}

sub _get_site_filter{
	my ($self, @arg) = @_;
	my $_HTTP_HOST= $arg[0] || $ENV{'HTTP_HOST'};
	my @_host_parts = split(/\./,$_HTTP_HOST);		# split HTTP_HOST into it's dot seperated components
	my $tld = $_host_parts[$#_host_parts];
	my $domain = lc($_host_parts[($#_host_parts - 1 )]);
	my $sub_domain;	
	$self->{SUB_DOMAIN} = $sub_domain;
	$self->{DOMAIN} = $domain;
	$self->{TLD} = $tld;
	if ($#_host_parts > 1){					# if true domain has a subdomain if false structure = (domain.com)
	$sub_domain = join("\.",@_host_parts[0..($#_host_parts - 2)]); # join the rest of the subdomain back together
	}
	my $sf;
		if (($_site_filter{$tld} eq '') || ($_site_filter{$tld}->{$domain} eq '')) { $sf = $_site_filter{CATCH_ALL}; }
		else {
			if($_site_filter{$tld}->{$domain}->{$sub_domain}){ $sf = $_site_filter{$tld}->{$domain}->{$sub_domain}; }
			else { $sf = $_site_filter{$tld}->{$domain}->{CATCH_ALL}; }
		}

	return $sf;
}

sub _env {
	my ($self, @arg) = @_;
	while(my ($_n, $_v)=each(%ENV)){
		print "$_n -> $_v<br>\n";
	}
	return;
}

sub DESTROY { }

} # END CLASS CLOSURE
1;