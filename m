From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 21:35:20 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628213520.C4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.45834.373409.220647@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 12:03:38PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Don,

>  > I have real data [...] from several boxen providing transparent proxy
>  > service to dialup customers, 3000 customers per box peak, running DNS
>  > and squid towards the Internet.
>  > With the peak load, the proxy boxen have up to 100000 conntrack entries
> 
> If you can put some data on a web page that I could download I'd be
> happy to write and run the program that analyzes it and compares it
> to the results expected for a uniform hash function.

I have put a current sample, with ~33000 entries from one of those
proxy boxen, at http://bei.bof.de/ip_conntrack.1.gz

To protect the innoccent (i.e. my customers and their surfing habits),
I have modified the top 16 bit of the IP addresses (keeping a random
but unique-once-determined mapping). The low order 16 bit are unmodified.
I hope this is sufficient to combine realism wrt hashing with privacy.
The Perl script I used for transforming the ip_conntrack input, is appended
for review.

> Just in case you consider this to be a drawback, I might as well
> mention up front that this program will be written in lisp.
> (I consider it to be a benefit.)

That's your choice. I would write it in Perl or C.

> I suppose /proc/net/ip_conntrack is the preferred data format

The data format should be nearly /proc/net/ip_conntrack, the only modification
is that I compressed multiple whitespace down to a single character, and the
abovementioned mangling of the IP addresses.

I'm looking forward to your results. Tell me if you want more data.

best regards
  Patrick

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ctmangle

#! /usr/bin/perl -w

use strict;

# tcp      6 114 TIME_WAIT src=XX.XXX.211.64 dst=YYY.Y.144.66 sport=34685 dport=80 src=YYY.Y.144.66 dst=XX.XXX.211.64 sport=80 dport=34685 [ASSURED] use=1 

my %ipmap = ();

sub domap {
	my $ip = $_[0];
	if (!defined($ipmap{$ip})) {
		my $r = rand (2**16)-1;
		my $m = '';
		$m .= ($r & 255); $r >>= 8; $m .= '.' . ($r & 255);
		$ipmap{$ip} = $m;
	}
	return $ipmap{$ip};
}

while (<>) {
	chop;
	my @F = split;
	my $out = '';
	my $sep = '';
	for my $token (@F) {
		if ($token =~ /^([^=]+)=(\d+\.\d+)(\.\d+\.\d+)$/) {
			my $ip = domap($2);
			$out .= "$sep${1}=$ip${3}";
		} else {
			$out .= "$sep$token";
		}
		$sep = ' ';
	}
	print "$out\n";
}

--gBBFr7Ir9EOA20Yy--
