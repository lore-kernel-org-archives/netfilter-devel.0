From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Mon, 6 Mar 2006 14:15:10 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
	<Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
	<Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
	<1141503111.3881.61.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
	<1141580938.3881.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1141580938.3881.129.camel@localhost.localdomain>
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

Hi Martin

On Sun, 5 Mar 2006, Martin Josefsson wrote:

> HASHSHIFT and HASHNUM controls the number of struct hashentry per child.
> The original idea was to allocate 1 page (4kB) for each child but I got
> better results with 2kB, which means it isn't as wide as it was from the
> start.

Did you get faster lookups/insertions/deletions with half of the page
size?

> HASHALIGN is the size of struct hashentry, the idea is that HASHALIGN
> should be equal to the cacheline size of the cpu it's running on. That
> way you only get one cachemiss per level in the tree.
> HASHALIGN is set to 32 bytes just because my laptop has 32byte
> cachelines, other cpus has 64bytes or even 128bytes.

As far as I see, the structure should satisfy "contradicting"
requirements. We want an as low tree as possible, thus minimising the cost
of the operations. That includes the number of levels of the childs and
the number of slots in a bucket and the latter depends on the HASHALIGN,
hashbits_t parameters and the members of the hashentry structure. So in
theory we should maximize HASHSHIFT and minimize NUMENTRY. However we do
not want a preallocated, huge, sparse hash either, and therefore it is
hard to tell the best values.

> hashbit_t is an u8 because in my tests I havn't see any gain by going to
> more bits.
> The only purpose of hashbits is to "cheat" a bit during lookup, store a
> part of the hash-value in the datastructure so you can easily determine
> if a member even can be a possible match by comparing the hashbits to
> the hashvalue you are searching for, this eliminates a lot of
> cachemisses (without this the datastructure will behave more like a
> linked list).

This structure is quite tricky :-).

> > Yes, that could help to spot the problem. But if there are clashes
> > (due to using to small parts of the hash key, i.e  hashbits_t = u8), then
> > the node can be fairly low utilized and still there is a need to expand by
> > new childs.
>
> Small hashbits_t doesn't have anything to do with it, hashbits_t is just
> for accelerating lookups. If we have a low number of struct hashentry
> per child-node we'll probably fill them up faster since there's fewer of
> them to be filled. And if we have a low NUMENTRY they will also be
> filled faster.

But how can we explain the so few entries in the buckets? Your numbers
suggest that most of the buckets are pretty empty, as if there were two
slots full from the 64 in the DoS case.

Or we can say that the DoS has got an effect: the jenkins hash were
unable to produce good enough keys. Or using the 32 bits from the 96
internal ones is not sufficient.

But in the non-DoS random pattern case, there was 819200 entries / 27345
child-nodes =~ 29 entries/child-nodes, that's still around 10%
utilization. So it looks it's not the jenkins hash which produces the
sparse tree.

> The problem is how do you know which entry along a path is the oldest?
> Entries aren't always added to the front like with the current linked
> lists in the hashtable.

We could check the timer of the entry: the oldest one is that which would
time out nearest in the future.

[...]
> these happen at the same time:
> packet from client A hashes into bucket C, lock and add entry.
> packet from client B hashes into bucket D, lock and add entry.
>
> and after that these happen at the same time:
> packet from client A hashes into bucket D, lock and find entry, remove
> entry in bucket C
> packet from client B hashes into bucket C, lock and find entry, remove
> entry in bucket D
>
> This leads to no conntrack entry created for any of the clients
> connection attempts.
>
> The solution would be "ordered independent locking" which locks and adds
> entries based on bucket number that the tuplex hash into.
> That way we still keep the current behaviour while simplifying the
> locking, no chance of deadlocks.

That looks perfect!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
