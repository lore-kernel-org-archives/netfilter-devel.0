From: Patrick Schaaf <bof@bof.de>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
	be 1 not 2)
Date: Wed, 8 Mar 2006 07:34:17 +0100
Message-ID: <20060308063416.GB22702@oknodo.bof.de>
References: <Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
	<Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
	<Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
	<1141503111.3881.61.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
	<1141580938.3881.129.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
	<1141756438.3881.158.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1141756438.3881.158.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > This structure is quite tricky :-).
> 
> Yes it is :) Image how I felt when I got it described to me in
> conversations on irc.

Hmm. Evoke this feeling again. :) Now I'll describe an easy way (haha)
to get rid of half of the tuples, for the case of no-NAT. I did that
before, but if you are now revisiting conntracking basics, maybe
it's time to retell:

Notice that for the non-NAT case, the two tuples of a connection
are fully symmetric in src(ip|port) vs. dst(ip|port). For ease
of exposition, imagine each (ip|port) to be an 48-bit number.

Given two numbers A and B, a function can easily be implemented:

	symsort: N x N -> N x N x Z2
		given (a, b), if a <= b, result is (a, b, 0)
		given (a, b), if a  > b, result is (b, a, 1)

Given the symmetric tuples from both halves of one connection,
this function returns the same A/B results in both cases,
with a different flip bit (third result).

So, when doing the hash lookup, run symsort first, and look for the resulting
"sorted" tuple.

The flip bit output of symsort needs to be taken into
account when classifying original / other destination. Details...

One would have a single tuple, instead of two, in struct ip_conntrack.
For NATted connections, an additional tuple would be allocated on
demand, referenced from ip_conntrack by a pointer, and also put into
the hashes.

When a non-NAT conntrack gets deleted, only one hash entry needs
to be removed, avoiding the need for complex lock ordering schemes
in that place. You can always tell you have this case, by looking
whether the NAT-tuple-pointer is != 0.

Downsides:
- complexity
- second tuple in separate memory, in the NAT case. Maybe more cache
  misses in some places

Upsides in the non-NAT case:
- half the memory for tuples
- half the number of hash insertions and deletions with their assorted
cache influences

best regards
  Patrick
