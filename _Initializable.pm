package Allied::_Initializable;

sub new {
        # Class Constructor
        # Expected Input Array: $_[0] = object_reference, $_[1] = record name/num
        my ($this, @arg) = @_;
        my $this_is_obj = ref($this);
        my $class = $this_is_obj || $this;
        my $self = bless {}, $class;
        $self->_init(@arg);
        return $self;
}

sub DESTROY { }
1;