use lib ("/usr/local/apache/sites/allied/perl-lib/");
package Allied::Sites::Passports::JavaScript;
$VERSION = '1.0';
use strict;
use CGI qw(:standard);

#############################################################
sub javascript {
        my ($self, $_affiliate_site_cookie, $_affiliate_phone_number_cookie) = @_;
print <<"END";
function pop_up(url,width,height,scroll,resizable) {
        if (window.nw && !window.nw.closed) { window.nw.close(); }
        nw = window.open(url,'nw','width=' + width + ',height=' + height + ',resizable=' +resizable+ ',toolbar=no,scrollbars=' +scroll+ ',menubar=no,status=no' );
        window.nw.focus();
}
function new_win_close_cur_pop(url) {
        if (window.nw && !window.nw.closed) { window.nw.close(); }
        nw2 = window.open(url,'nw2','width=640,height=480,resizable=yes,toolbar=yes,scrollbars=yes,menubar=yes,status=yes' );
        window.nw2.focus();
        window.self.close();
}
function new_pop_close_cur_pop(url,width,height,scroll,resizable) {
        if (window.nw && !window.nw.closed) { window.nw.close(); }
        nw3 = window.open(url,'nw3','width=' + width + ',height=' + height + ',resizable=' +resizable+ ',toolbar=no,scrollbars=' +scroll+ ',menubar=no,status=no' );
        window.nw3.focus();
        window.self.close();
}
function openpopup(){
	var popurl="/?page=ziplocator";
	winpops=window.open(popurl,"","width=425,height=320");
}
END
	if(!($_affiliate_site_cookie eq 'false')) { $self->affiliate_site_cookie($_affiliate_site_cookie); }
	if($_affiliate_phone_number_cookie eq 'true') { $self->affiliate_phone_number_cookie(); }
	$self->cookie_code();
}

#############################################################
sub affiliate_site_cookie {
        my ($self, $_affiliate_site_cookie) = @_;
print <<"END";
  var cookie_value = get_cookie_value('affiliate');
  var id = '$_affiliate_site_cookie';
        if (cookie_value == null) { set_cookie('affiliate','$_affiliate_site_cookie','/','365'); }
END
}

#############################################################
sub affiliate_phone_number_cookie {
        my ($self, @args) = @_;
        my $affid = param('affid') || 'null';
print <<"END";
  var cookie_value = get_cookie_value('affiliate');
  var affid = '$affid';
        if (affid != 'null') { set_cookie('affiliate','$affid','/','365'); }
END
}

#############################################################
sub cookie_code {
        my ($self, @args) = @_;
print <<'END';
function set_cookie(name,value,path,expires,domain,secure) {
// create or expire cookie (to expire a cookie pass in '-1')
	var today = new Date();
	var expr = new Date(today.getTime() + (expires * 86400000));
	var milk = name + "=" + escape(value)
		+ ((expires)?";expires=" + expr.toGMTString():5)
		+ ((path)?";path=" + path:";path=/")
		+ ((domain)?";domain=" + domain: ";domain=" + document.domain)
		+ ((secure)?";secure":"");
	document.cookie = milk
}
function get_cookie_value(name) {
    var get = document.cookie.indexOf(name + "=");
    var index =(get != -1)?document.cookie.indexOf("=", get) + 1:0;
    var endstr = document.cookie.indexOf(";", index);
    if (endstr == -1) endstr = document.cookie.length;
    return (index != 0)?unescape(document.cookie.substring(index,endstr)):null;
}
function get_all_cookies() {
	var a = new Array();
	var split_cookie = document.cookie.split(";");
	for (count=0; count < split_cookie.length; count++)
	{
		var get_cookie_name = split_cookie[count].indexOf('=');
		var cookie_name = split_cookie[count].substring(get_cookie_name,0);
        	var new_name = cookie_name.replace(' ','');
		a.push(new_name);
	}
	return a;
}
END
}

1;
__END__
