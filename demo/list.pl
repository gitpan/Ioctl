#!./perl -w

use Ioctl;

my $ok=0;
my $total=0;

for my $c (@Ioctl::EXPORT_OK) {
    my $got = eval { &{"Ioctl::$c"}; };
    if ($@) {
	$got = '?'
    } else {
	++$ok;
    }
    printf "%-20s %s\n", $c, $got;
    ++$total;
}
printf "%02d%% of the constants have values\n", 100 * $ok/$total;
