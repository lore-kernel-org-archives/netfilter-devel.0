From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: performance issues (nat / conntrack)
Date: Mon, 24 Jun 2002 08:18:57 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15639.14434.1338.37297@isis.cs3-inc.com>
References: <20020623132739.12D52455E@lists.samba.org>
	<15638.42021.31206.821255@isis.cs3-inc.com>
	<20020624080618.Q5183@oknodo.bof.de>
	<15638.48245.84830.480715@isis.cs3-inc.com>
	<20020624084836.R5183@oknodo.bof.de>
	<15638.49692.902811.4513@isis.cs3-inc.com>
	<20020624091325.S5183@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020624091325.S5183@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > > I suggest instead that the hash lookup be limited to a small number of
 > > probes.  If not found in, say, 10 probes, act like it's not there and
 > > the table is full.
 > 
 > For each packet, there is exactly one hash chain to look up. So you end
 > up limiting the _length_ of the single chain when creating new entries.

So far I agree.

 > To the user, that would mean random breakage long before saturation,
 > for the sake of handling a hypothetical attack.

I'm not sure what meaning you have in mind here for the term "random".
It should happen with extremely low probability.  I'm expecting the
max chain length to be a lot longer than the average chain length when
the table is "full".  But still short enough that a search of that
length has negligible cost in comparison to the rest of the processing
that has to be done for any packet.

Any statistics majors out there?
Assuming the choice of bucket is uniformly distributed, what's the
probability in a table containing E entries in B buckets, that the
next entry will fall into a bucket containing >= n elements?

Since a hash bucket costs much less than a conntrack entry I think
we can afford to make the expected number of entries per bucket pretty
small.  Just choose an acceptable probability of this particular
failure and a maximum search cost (proportional to the number of 
entries allowed in a bucket) and do the computation to be provided
by our friendly statistics major to find the hash table size.

I'd expect my proposed sum of IP addresses and ports mod the largest 
odd number less than the table size to be uniformly distributed, but
perhaps our volunteer can also tell us how to test that.  Probably
the answer is to do a printk when a bucket search reaches the limit.
Then try to determine whether in those cases you're actually under
attack or this is really just bad luck.

 > Thus, you also need an "am I under attack" algorithm first, and enable
 > that limiting behaviour only when that algorithm triggers.

I prefer an algorithm that does not have to make this decision.

 > In practise, the denial of service attacks I've seen fill your slowest
 > link, and there's nothing you can do about that except rate limit on
 > the _other_ side.

This is a different problem.  Here we have a situation where there are
particular packets that have much greater cost than others.  The
attacker can succeed with much lower bandwidth than the slowest link.
In my case the forwarding machine was saturated with 1000 small
packets/sec (about 50KBytes), which was far below the network
bandwidth.  Even if we manage to fix the bandwidth attack problem you
still have to deal with this other problem of requests that have low
cost in bandwidth but high costs in other dimensions.
