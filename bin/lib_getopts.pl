;# getoptsnew.pl - a better getopts.pl

;# Usage:
;#      do Getoptsnew('a:bcd;g');  # -a and -d take args. Many -d's can happen. -b & -c not. Sets opt_* as a
;#                                 #  side effect.
;#                                 # sets $opt_a, $opt_b, $opt_c, $opt_g, and @opt_d

sub Getopts {
    local($argumentative) = @_;
    local(@args,$_,$first,$rest);
    local($errs) = 0;
    local($[) = 0;

    @args = split( / */, $argumentative );
    while(@ARGV && ($_ = $ARGV[0]) =~ /^-(.)(.*)/) {
    ($first,$rest) = ($1,$2);
    $pos = index($argumentative,$first);
    if ($pos >= $[) {
        if ($args[$pos+1] eq ';') {
            shift(@ARGV);
            if($rest eq '') {
                ++$errs unless @ARGV;
                $rest = shift(@ARGV);
            }
            eval "\@opt_$first\[\$\#opt_$first++] = \$rest;";
        } elsif ($args[$pos+1] eq ':') {
            shift(@ARGV);
            if($rest eq '') {
                ++$errs unless @ARGV;
                $rest = shift(@ARGV);
            }
            eval "\$opt_$first = \$rest;";
        } else {
            eval "\$opt_$first = 1";
            if($rest eq '') {
                shift(@ARGV);
            } else {
                $ARGV[0] = "-$rest";
            }
        }
    }
    else {
        print STDERR "Unknown option: $first\n";
        ++$errs;
        if($rest ne '') {
        $ARGV[0] = "-$rest";
        }
        else {
        shift(@ARGV);
        }
    }
    }
    $errs == 0;
}

# The following line needed to load this as a library
1
