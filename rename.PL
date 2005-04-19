use strict;
use File::Basename qw(dirname);
use File::Path qw(mkpath);

my $file = shift;
unless( -d( my $dir = dirname $file ) ) { mkpath $dir, 1 }
open OUT, '>', $file or die "$0 can't open $file: $!\n";

print OUT "#!perl -w\n";
print OUT while <DATA>;
exit;
__END__
# Larry(?)'s RCS header:
#  RCSfile: rename,v   Revision: 4.1   Date: 92/08/07 17:20:30 
#
# $RCSfile: rename.PL,v $$Revision: 1.1 $$Date: 2005/04/14 13:19:22 $
#
# $Log: rename.PL,v $
# Revision 1.1  2005/04/14 13:19:22  rmb1
# Initial revision
#
# Revision 1.5  1998/12/18 16:16:31  rmb1
# moved to perl/source
# changed man documentation to POD
#
# Revision 1.4  1997/02/27  17:19:26  rmb1
# corrected usage string
#
# Revision 1.3  1997/02/27  16:39:07  rmb1
# added -v
#
# Revision 1.2  1997/02/27  16:15:40  rmb1
# *** empty log message ***
#
# Revision 1.1  1997/02/27  15:48:51  rmb1
# Initial revision
#

use strict;
use File::Rename ();
use Getopt::Long;
$Getopt::Long::ignorecase = 0;

my $bad_args;
GetOptions('-v' => \my $verbose)	or $bad_args = 1;
my $op = shift				or $bad_args = 1; 

die "Usage: rename [-v] perlexpr [filenames]\n"	if $bad_args;

@ARGV = map glob, @ARGV if $^O =~ /Win/;
File::Rename::rename @ARGV, $op, $verbose;

__END__


=head1 NAME

rename - renames multiple files

=head1 SYNOPSIS

B<rename> S<[ B<-v> ]> I<perlexpr> S<[ I<files> ]>

=head1 DESCRIPTION

C<rename>
renames the filenames supplied according to the rule specified as the
first argument.
The I<perlexpr> 
argument is a Perl expression which is expected to modify the C<$_>
string in Perl for at least some of the filenames specified.
If a given filename is not modified by the expression, it will not be
renamed.
If no filenames are given on the command line, filenames will be read
via standard input.

For example, to rename all files matching C<*.bak> to strip the extension,
you might say

	rename 's/\e.bak$//' *.bak

To translate uppercase names to lower, you'd use

	rename 'y/A-Z/a-z/' *

=head1 OPTIONS

=over 8

=item B<-v>

Verbose: print names of files successfully renamed.

=back

=head1 ENVIRONMENT

No environment variables are used.

=head1 AUTHOR

Larry Wall

=head1 SEE ALSO

mv(1), perl(1)

=head1 DIAGNOSTICS

If you give an invalid Perl expression you'll get a syntax error.

=head1 BUGS

The original
C<rename>
did not check for the existence of target filenames,
so had to be used with care.
I hope I've fixed that (Robin Barker).

=cut

