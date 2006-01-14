package File::Rename;

use 5.006;
use 5.8.0;
use strict;
use warnings;
use base qw(Exporter);

our @EXPORT_OK = qw( rename );
our $VERSION = '0.02';

sub rename_files ($$@) {
    my $code = shift;
    my $verbose = shift;
    for (@_) {
        my $was = $_;
	&$code;
    	if( $was eq $_ ){ }		# ignore quietly
    	elsif( -e $_ )	{ 
		warn  "$was not renamed: $_ already exists\n"; 
	}
    	elsif( CORE::rename($was,$_)) { 
		print "$was renamed as $_\n" if $verbose; 
	}
    	else { 	warn  "Can't rename $was $_: $!\n"; }
    }
}

sub rename_list ($$$;$) {
    my($code, $verbose, $fh, $file) = @_;
    print "reading filenames from ",
	(defined $file ? $file : 'file handle ($fh)'),
	"\n" if $verbose;
    chop(my @file = <$fh>); 
    rename_files $code, $verbose,  @file;
}

sub rename (\@$;$) {
    my($argv, $code, $verbose) = @_;
    unless( ref $code ) {
	$code = eval 'sub { '. $code .' }' or die $@;
    }
    if( @$argv ) { rename_files $code, $verbose, @$argv }
    else { rename_list $code, $verbose, \*STDIN, 'STDIN' }
}

1;

__END__

=head1 NAME

File::Rename - Perl extension for renaming multiple files

=head1 SYNOPSIS

  use File::Rename qw(rename);		# hide CORE::rename
  rename @ARGV, sub { s/\.pl\z/.pm/ }, 1;

  use File::Rename;
  File::Rename::rename @ARGV, '$_ = lc';

=head1 DESCRIPTION

=over 4

=item C<rename( FILES, CODE [, VERBOSE])>

rename FILES using CODE,
if FILES is empty read list of files from stdin

=item C<rename_files( CODE, VERBOSE, FILES)>

rename FILES using CODE

=item C<rename_list( CODE, VERBOSE, HANDLE [, FILENAME])>

rename a list of file read from HANDLE, using CODE

=back

=head2 OPTIONS

=over 8

=item FILES

List of files to be renamed,
for C<rename> must be an array

=item CODE

Subroutine to change file names,
for C<rename> can be a string,
otherside a code reference

=item VERBOSE

Flag for printing names of files successfully renamed,
optional for C<rename>

=item HANDLE

Filehandle to read file names to be renames

=item FILENAME (Optional)

Name of file that HANDLE reads from

=back

=head2 EXPORT

None by default.

=head1 ENVIRONMENT

No environment variables are used.

=head1 SEE ALSO

mv(1), perl(1), rename (1)

=head1 AUTHOR

Robin Barker <RMBarker@cpan.org>

=head1 DIAGNOSTICS

Errors from the code argument are not trapped.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, 2005, 2006 by Robin Barker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
