#!/usr/bin/perl
# - latexpand   D. Musliner University of Michigan
# Short program to expand out LaTeX \input and \include commands.
# Essentially a tiny part of 'go' hacked out.
# Removes comments as a side effect, does not deal with escaped %s.
#
# 15 Sept 1999  M. Lovell       Hewlett-Packard, Co
# Improved comment removal code.  Now handles escaped %'s.
#
#
$TEXINPUTS = $ENV{'TEXINPUTS'};
if (!$TEXINPUTS) { $TEXINPUTS = '.'; }

&scan_for_includes(shift);

#************************************************************
# - looks recursively for included & inputted files, expands.
# - note only primitive comment removal: cannot deal with escaped %s.

sub scan_for_includes
{
  local(*FILE); if (!open(FILE,$_[0]))
    { warn "WARNING: could not open input file [$_[0]]\n"; return; }
  while(<FILE>)
    {
    # comment removal
    s/^%.*\n//;
    s/([^\\])%.*\n/$1/;

    if (/\\include[{\s]+([^\001}]*)[\s}]/)
      {
        $full_filename = $1;
        if ($1 =~ m/\./)
          { $full_filename = &find_file($full_filename,$TEXINPUTS); }
        else
          { $full_filename = &find_file("$full_filename.tex",$TEXINPUTS); }
        warn "  Found include for file [$full_filename]\n";
        &scan_for_includes($full_filename);
      }
    elsif (/\\input[{\s]+([^\001}]*)[\s}]/)
      {
        $full_filename = $1;
        if ($1 =~ m/\./)
          { $full_filename = &find_file($full_filename,$TEXINPUTS); }
        else
          { $full_filename = &find_file("$full_filename.tex",$TEXINPUTS); }
        warn "  Found input for file [$full_filename]\n";
        &scan_for_includes($full_filename);
      }
    elsif (/\\bibliographystyle/) {}
    elsif (/\\bibliography/) {
        $bibfname = $_[0];
        $bibfname =~ s/.tex$//;
        $bibfname = "${bibfname}.bbl";
        &scan_for_includes($bibfname);
    }
    else { print; }
    }
}

#************************************************************
# given filename and path, return full name of file, or die if none found.

sub find_file
{
  foreach $dir (split(':',$_[1]))
    { if (-e "$dir/$_[0]") { return("$dir/$_[0]"); } }
  die "ERROR: Could not find file [$_[0]] in path [$_[1]]\n";
}
