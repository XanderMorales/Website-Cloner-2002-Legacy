use lib ("/usr/local/apache/sites/allied/perl-lib/");
use Allied::Sites::Universal::UniversalSite;
package Allied::Sites::CRS::CRSSite;
$VERSION =  '1.0';
@ISA = qw (Allied::Sites::Universal::UniversalSite);
#############################################################
use strict;
use CGI qw(:standard);
use DBI;
use vars qw(%__PAGES $ADMIN_PASS $dsn $db_username $db_password $ADMIN_USER);
$dsn = "DBI:mysql:host=localhost;database=CRS";
$db_username = 'root';
$db_password = '<inchoate>';


%__PAGES     = (
	home				=> 'login',
	login				=> 'login',
	login_submit			=> 'login_submit',
	report				=> 'report',
	upload_data			=> 'upload_data',
);

$ADMIN_USER = 'FLOPPY';
$ADMIN_PASS = 'FLOPPY';

#############################################################
sub login_submit {
	my ($self,@args) = @_;
$self->print_header();
print <<"END";
<table align="center" width="100%"><tr><td align="center">
END
	my $username = param('username');
	my $password = param('password');
	if (($username eq $ADMIN_USER) && ($password eq $ADMIN_PASS)) { $self->admin_screen(); } 
	else {
		my $dbh = $self->DB_Connection(); 
		my $sql = qq~SELECT * FROM Affiliates WHERE Account_Code = '$password'~; 
		my $sth = $self->Execute_SQL($dbh,$sql);
		my @ROWS;
		my $bad_pass = '0';
		while(my $row = $sth->fetchrow_hashref){
        		push(@ROWS, $row);
			if( $row->{Email} ne $username){$bad_pass = 1;} # check for bad username/pass
		}
		if ($bad_pass ne '1'){ $self->login("Login was incorrect, please try  again."); }
		else { 
my $template = HTML::Template->new(filename => $self->{OSITE}->{TEMPLATE_PATH} . 'announce.thtml', path => $self->{OSITE}->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',0);
$template->param($self->{OSITE}->global_thtml_params());
print $template->output;
	                      #  print qq~Announcement Screen~;
                        	print qq~<div>Click here for your <a href="/?page=report&username=$username&password=$password">commission report</a></div>~;
		}
	}
print <<"END";
</td></tr></table>
END
$self->print_footer();
}
#############################################################
sub report  {
	my ($self,@args) = @_;
$self->print_header();
	my $username = param('username');
	my $password = param('password');
	if (($username eq $ADMIN_USER) && ($password eq $ADMIN_PASS)) { $self->admin_screen(); } 
	else {
print <<"END";
<center>
<h3>$self->{OSITE}->{CONFIG}->{COMPANY_NAME} Commission Reporting System</h3>
</center>
END
		my $dbh = $self->DB_Connection(); 

		my $sql2 = qq~SELECT * FROM From_To_Dates~; 
		my $sth2 = $self->Execute_SQL($dbh,$sql2);
		my @ROWS2;
                while(my $row2 = $sth2->fetchrow_hashref){
                        push(@ROWS2, $row2);
print <<"END";
<table align="center" border="0" cellpadding="3" cellspacing="0" width="560">
  <tr>
	<td align="right"><font size="1" face="tahoma">
	From: $row2->{From_Date}
	&nbsp;&nbsp;&nbsp;
	To: $row2->{To_Date}
	</td>
  </tr>
</table>
END
		}
	
		my $sql = qq~SELECT * FROM Affiliates WHERE Account_Code = '$password'~; 
		my $sth = $self->Execute_SQL($dbh,$sql);
		my @ROWS;
		my $bad_pass = '0';
                while(my $row = $sth->fetchrow_hashref){
                        push(@ROWS, $row);
                        if( $row->{Email} ne $username){$bad_pass = 1;} # check for bad username/pass
                }
                if ($bad_pass ne '1'){ $self->login('Login Was Incorrect'); }
                else {
print <<"END";
<table align="center" border="1" cellpadding="3" cellspacing="0" width="560">
  <tr>
	<td align="center" bgcolor="#eeeeee"><b>Date</b></td>
	<td align="center" bgcolor="#eeeeee"><b>Check #</b></td>
	<td align="center" bgcolor="#eeeeee"><b>Description</b></td>
	<td align="center" bgcolor="#eeeeee"><b>Commission</b></td>
  </tr>
END
                        for my $row(@ROWS){
                                print qq~
  				<tr bgcolor="#CEFFCE">
                                <td>$row->{Date}</td>
                                <td>$row->{Check_Number}</td>
                                <td>$row->{Description}</td>
                                <td>\$$row->{Commission}</td>
				</tr>
                                ~;
                        }
print <<"END";
</table>
END
                }
        }

$self->print_footer();
}

#############################################################
sub upload_data {
	my ($self,@args) = @_;
	my $q = new CGI;
	my $fh = $q->upload('file');
	my $password = param('password');
	my $from = param('from');
	my $to = param('to');

	if ($password eq $ADMIN_PASS) {  
		# delete all records from old Affiliates db
		my $dbh = $self->DB_Connection(); 
		my $sql = "delete from Affiliates"; 
		$self->Execute_SQL($dbh,$sql);

		# delete all records from To From db
		my $sql = "delete from From_To_Dates"; 
		$self->Execute_SQL($dbh,$sql);
		
		# add new From_To_Dates db
		my $sql = qq~INSERT INTO From_To_Dates VALUES(NULL,"$from","$to")~; 
		$self->Execute_SQL($dbh,$sql);
	
		# Insert new records		
		while(<$fh>){
		my @data = split(/\t/,$_);
		my $sql = qq~insert into Affiliates (ID,Account_Code,Commission,Date,Check_Number,Description,Email) VALUES (NULL,'$data[0]','$data[1]','$data[2]','$data[3]','$data[4]','$data[5]')~; 
		$self->Execute_SQL($dbh,$sql);
		}
		print "Database has been updated";
	}	
	else {
	$self->admin_screen('Incorrect Password Please Try Again');
	}
}
#############################################################
sub admin_screen {
	my ($self,$msg,@args) = @_;
print qq~
<center>
<h3>Admin Screen<br>$msg</h3>
</center>
<form action="/" method="post" enctype="multipart/form-data">
<input type="hidden" name="page" value="upload_data"><br>
<table align="center">
  <tr>
	<td>.TXT File to upload:</td>
	<td><input type="file" name="file"></td>
  </tr>
  <tr>
	<td>Admin Pass:</td>
	<td><input type="password" name="password"></td>
  </tr>
  <tr>
	<td>From (MM/DD/YYYY):</td>
	<td><input type="text" name="from"></td>
  </tr>
  <tr>
	<td>To (MM/DD/YYYY):</td>
	<td><input type="text" name="to"></td>
  </tr>
  <tr>
	<td colspan="2"><input type="submit" value=" Update Datatbase"></td>
  </tr>
</table>
</form>
~;
}
#############################################################
sub login {
	my ($self,$msg,@args) = @_;
$self->print_header();
print <<"END";
<table align="center" width="100%"><tr><td align="center">
END
	print qq~
<font color="red">$msg</font><br>
<h3>$self->{OSITE}->{CONFIG}->{COMPANY_NAME} Affiliate Commission Reporting System.</h3>
<form action="/" method="post">
<input type="hidden" name="page" value="login_submit"><br>
<table><tr>
<td>User Id:</td>
<td><input type="text" name="username"></td>
</tr><tr>
<td>Password:</td>
<td><input type="password" name="password"></td>
</tr>
<tr>
<td colspan="2"><input type="submit" value=" Login "></td>
</tr></table>
</form>

~;
$self->print_footer();
}

#############################################################
sub Execute_SQL{
        my ($self, $dbh, $SQL, @arg) = @_;
        my $sth;
  eval{
    $sth = $dbh->prepare($SQL);
  };
    $sth->execute;
    return ($sth);
}

#############################################################
sub DB_Connection{
        my ($self, @arg) = @_;
        my $dbh  = DBI->connect($dsn, $db_username, $db_password)  || warn "cant login
 $self->{ORDER_DB}";
        return $dbh;
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
	#while(my($n,$v)=each(%{$self->{CONFIG}})){
	#warn "$n -> $v \n";
	#}
	return %{$self->{CONFIG}};
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
        my $template = HTML::Template->new(filename=>$self->{OSITE}->{CUSTOM_FILES_PATH} . 'affiliate_header.thtml',path=>$self->{OSITE}->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
        $template->param($self->{OSITE}->global_thtml_params());
        $template->param(
                AFFID => $affid,
                LEFT_NAV => $left_nav,
                PROMO => $promo,
        );
        print $template->output;
}
=cut
#############################################################
sub print_header {
	my ($self, @args) = @_;
print <<"END";
<html>
<head>
<title>$self->{OSITE}->{CONFIG}->{COMPANY_NAME} Affiliate Commission Reporting System</title>
</head>
<style>
body {font-family:arial,helvetica; font-size:12px; }
td {font-family:arial,helvetica; font-size:12px; }
</style>
<body>
END
}
=cut
#############################################################
sub print_footer {
        my ($self, $promo, $left_nav, @args) = @_;
        my $affid;
        if (param('affid') ne ''){ $affid = param('affid'); }
        my $template = HTML::Template->new(filename=>$self->{OSITE}->{CUSTOM_FILES_PATH} . 'affiliate_footer.thtml',path=>$self->{OSITE}->{CUSTOM_FILES_PATH},'die_on_bad_params',0,'cache',1);
        $template->param($self->{OSITE}->global_thtml_params());
        $template->param(
                AFFID => $affid,
                PROMO => $promo,
                LEFT_NAV => $left_nav,
        );
        print $template->output;
}
=cut
#############################################################
sub print_footer {
	my ($self, @args) = @_;	
print <<"END";
</body>
</html>
END
}
=cut
1;
__END__
