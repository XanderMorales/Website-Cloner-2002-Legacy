use lib ("/home/sites/webeditors/com/perl-lib/");
package WebEditors::Downloads;
use strict;
use Fcntl ':flock'; # import LOCK_* constants

{# BEGIN CLASS CLOSURE
sub new{
        my ($class, $r, @arg) = @_;
        my $self = bless {}, ref($class) || $class;
        $self->_init($r, @arg);
        return $self;
}
sub _init{
	my ($self, $r, @arg) = @_;
	# url params
	my %params = $r->args;
	%params = (%params, $r->content);
	%{$self->{PARAMS}} =  %params;
	# get url params like so $self->{PARAMS}->{page} where page is ?page = whatever
	$self->{SERVER_PATH_TO_WEB_ROOT} = '/home/sites/webeditors.com/web'; # no slash at the end
	$self->{WEB_DOWNLOAD_PATH} = '/downloads/'; # Full Web URL to download path
	$self->{JAVASCRIPTS} = {
		'WE_Cookies'			=> 'WECookies.zip',
		'WE_Exit_Consol'		=> 'WEExitConsol.zip',
		'WE_Entrance_Console'	=> 'WEEntranceConsole.zip',
		'WE_Zula_Protector'		=> 'WEZulaProtector.zip',
	};
	return $self;
}
sub run{
	my ($self, $r, @arg) = @_;
	# conditional are ran if param value exist in hash $self->{JAVASCRIPTS}
	# if it is a download
	if($self->{JAVASCRIPTS}->{$self->{PARAMS}->{download}}){ # param download
		$self->track_download($self->{JAVASCRIPTS}->{$self->{PARAMS}->{download}});
		my $location = 'http://www.webeditors.com' . $self->{WEB_DOWNLOAD_PATH} . $self->{JAVASCRIPTS}->{$self->{PARAMS}->{download}};
		my $status = '302';
		$r->status($status);
		$r->header_out('Location',$location);
		$r->send_http_header();
	}
	# if it is a display of downloads
	elsif($self->{JAVASCRIPTS}->{$self->{PARAMS}->{display_download}}){ # param display_download
		$r->send_http_header('text/html');
		$self->display_dowload($self->{JAVASCRIPTS}->{$self->{PARAMS}->{display_download}});
	}
}
sub track_download{
	my ($self, $file_name, @arg) = @_;
	my $file_to_download = $self->{WEB_DOWNLOAD_PATH} . $file_name;
	$file_name =~ s/\./_/g; # file  name for creating a db
	my $db_file = $self->{SERVER_PATH_TO_WEB_ROOT} . $self->{WEB_DOWNLOAD_PATH} . $file_name . ".db";
	my $total_downloads = $self->get_download($db_file) || 300;
	open(HITS, "> $db_file") or warn "Can't open $file_name: $!";
		$self->lock();
		print HITS $total_downloads + 1;
		$self->unlock();
	close HITS;
}
sub display_dowload {
	my ($self, $file_name, @arg) = @_;
	$file_name =~ s/\./_/g; # file  name for creating a db
	my $db_file = $self->{SERVER_PATH_TO_WEB_ROOT} . $self->{WEB_DOWNLOAD_PATH} . $file_name . ".db";
	my $total_downloads = $self->get_download($db_file) || 300;
  	print "$total_downloads";
}
sub get_download {
	my ($self, $db_file, @arg) = @_;
	my $total_downloads;
	open(HITS, "+< $db_file") or warn "Can't open $db_file: $!";
		while(<HITS>){ $total_downloads = $_; }
	close HITS;
	return $total_downloads;
}
## File Handle Methods for file locking
sub lock {
	my ($self, @arg) = @_;
	flock(HITS, LOCK_EX);
	# and, in case someone appended
	# while we were waiting...
	seek(HITS, 0, 2);
}
sub unlock {
	my ($self, @arg) = @_;
	flock(HITS, LOCK_UN);
}
sub DESTROY{ }
#############################
}# END CLASS CLOSURE

1;