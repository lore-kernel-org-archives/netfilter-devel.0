From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Re: Mixed IPv4+IPv6 sets
Date: Wed, 09 Sep 2015 11:07:08 +0100
Message-ID: <55F004CC.2080207@gaast.net>
References: <55EC8B7F.4040303@gaast.net> <20150907185025.GB17921@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:39831 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbbIIKHM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 06:07:12 -0400
In-Reply-To: <20150907185025.GB17921@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07-09-15 19:50, Pablo Neira Ayuso wrote:
> 
> Could you illustrate with examples what you would like to have and the
> limitations you currently hitting?
> 
So what I was trying to do is define sets with my local + trusted
networks. So for example:

define local = {
	192.168.0.0/24,
	2001:888:1001:1::/64,
}

define trusted = {
	$local
	87.198.233.214,
	2001:888:1001::/48,
}

So I'd use these as whitelists, could use $trusted as a wider whitelist
for all my networks and $local as just for completely local traffic.
Containing IPv4 and IPv6 addresses/networks.

Now I'd love to be able to just, for example (and apologies for the
likely wrong syntax, I have not been able to start using nftables in
full, just experimenting):

table inet filter {
	chain forward {
		type filter hook forward priority 0;
		...
		# (Mostly) don't filter traffic from my trusted nets
		inet saddr $trusted accept;
		# Filter the rest more strictly.
		...
	}
}

This won't work because inet is not an existing match rule. I can have
an "inet" table but it still needs to have ip and ip6 match rules
separately. It is nice that many other rules just work like for example
tcp/udp and ct.

Now if I could just do:

		# (Mostly) don't filter traffic from my trusted nets
		ip saddr $trusted accept;
		ip6 saddr $trusted accept;

somehow and have nft take just the v4 and just the v6 addresses for each
line, that would also be workable. Or what I tried doing (but then I ran
into the crash bug I've just reported), is separate the two whitelists
completely and do:

		# (Mostly) don't filter traffic from my trusted nets
		ip saddr $trusted4 accept;
		ip6 saddr $trusted6 accept;

The latter would work and is not bad, just kludgy. Being able to just
refer to a single mixed set of addresses from a single rule would
certainly be the most convenient, as one more step towards fully
unifying IPv4 + IPv6 filtering.


Kind regards,

Wilmer van der Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
