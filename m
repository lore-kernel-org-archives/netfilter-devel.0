From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Sun, 5 Mar 2006 12:24:55 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1141503111.3881.61.camel@localhost.localdomain>
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

Hi Martin,

On Sat, 4 Mar 2006, Martin Josefsson wrote:

> On Fri, 2006-02-17 at 10:30 +0100, Jozsef Kadlecsik wrote:
>
> > Here are the tests I'd like to see against hashtrie:
> >
> > - larger hashentry, i.e. when HASHSIFT is equal to 6, 7 or 8
>
> I have seen good results when sizeof(struct hashentry) = 64 on my
> laptop. But on the other hand my laptop likes the padding of struct
> hashentry at the beginning with gives unaligned pointers. It's an
> Pentium M processor in my laptop.

HASHSIFT (i.e. HASHNUM) defines the hash size of the hashtrie.
But the hashtrie - according to your tests - are much "wider" than
"deep". So there might be no point in widening the hash.

> > - other HASHALIGN, hashbit_t values: (32, u8), (64, u16) and (64, u32).
>
> Yes this needs more testing as well.
>
> >   The current (32, u8) doesn't look optimal on 64bit CPUs, (64, u16) seems
> >   to be the best, but without testing it's hard to choose.
>
> Currently I don't have any 64bit cpus to test things on.

With the default (32, u8) settings NUMENTRY looks too small on 64bit
CPUs:

HASHALIGN = 32
hashbits_t = u8

    32bit CPU:  NUMENTRY = (32 - 4)/(1+4) = 5
                PADNUM = 32 - 4 - 5*(1+4) = 3

    64bit CPU:  NUMENTRY = (32 - 8)/(1+8) = 2
                PADNUM = 32 - 8 - 2*(1+8) = 6

HASHALIGN = 64
hashbits_t = u16

    32bit CPU:  NUMENTRY = (64 - 4)/(2+4) = 10
                PADNUM = 64 - 4 - 10*(2+4) = 0

    64bit CPU:  NUMENTRY = (64 - 8)/(2+8) = 5
                PADNUM = 64 - 8 - 5*(2+8) = 6

HASHALIGN = 64
hashbits_t = u32

    32bit CPU:  NUMENTRY = (64 - 4)/(4+4) = 7
                PADNUM = 64 - 4 - 7*(4+4) = 4

    64bit CPU:  NUMENTRY = (64 - 8)/(4+8) = 4
                PADNUM = 64 - 8 - 4*(4+8) = 8

> > - DoS against hashtrie by non-random tuples: single fixed destination IP,
> >   port and successive source IP, port numbers. (I don't think the current
> >   max 7 levels (childs) can survive such an attack.)
>
> I just ran some tests on this with this code:
[...]
> And this is the result I got:
>
> sizeof struct hashentry: 32
> sizeof struct ip_conntrack: 48
> number of conntrack entries: 1228800
> number of slots per hashtrie bucket: 5
> number of pad bytes: 3
> number of bytes per child: 2048
> insert: time: 11299 cyc, 18854 ns (53040/s)
> Number of failed inserts: 22232
> Number of entries in hashtrie: 2435368
> Number of children in hashtrie: 238756
> Maxdepth of hashtrie: 3 (0 == root)
> Maximum memory usage: 488972288
>
> 2.4 million entries in the hashtrie with fixed dstip, port and 1024
> srcip's with random ports and a maxdepth of 3. I'd say the jenkins hash
> is doing its job quite nicely, wasn't expecting such good results.

The hashtrie tends to grow wider and not deeper:

level:		childs (max)	entries (max)
0		64		320
1		4160		20800
2		266304		1331520
3		17043520	85217600

> In the results above you see my main worry regarding hashtrie, the
> memory usage, 200 bytes per entry in hashtrie (400 bytes per conntrack)
> in this scenario, which means that the child-nodes aren't very populated
> in the leaf nodes.
>
> 2435368 entries / 238756 child-nodes = 10.2 entries/child-node
>
> And there's 2048 / 32 = 64 struct hashentry per child-node.
> That's 64 * 5 = 320 entries/child-node
>
> 10.2 / 320 = 3.2% usage of child-nodes in average which is simply
> horrible.
>
> I'm almost starting to think there's a major bug in there somewhere.
> I need to write some code to walk the tree and calculate the usage of
> each level to see that it's actually 100% for all buckets that has a
> child.

Yes, that could help to spot the problem. But if there are clashes
(due to using to small parts of the hash key, i.e  hashbits_t = u8), then
the node can be fairly low utilized and still there is a need to expand by
new childs.

> > Somehow I don't really like the eviction algorithm. What about some lazy
> > auto-eviction instead: say, if there are more than 90% of the max
> > elements, then drop a (any) unassured connection which can be found on the
> > path when inserting a new one. Thus the current fixed stack could be
> > eliminated and there were no builtin limit in the depth.
>
> Couldn't this lead to the situation where we evict an entry early on the
> path, and then that slot gets reused for another entry that's also
> unassured, and it repeats...

You mean, we could always evict the newest unassured entries instead of
the oldest ones? The algorithm could be extended so that we'd walk the
whole tree and register the oldest unassured entry in the path. I'm more
worried that we'd check too litle number of entries as the tree is shorter
than I thought.

> > I have been thinking on wether we could use simply, separated, unordered
> > locking:
[...]
> The only case I can think about where it might matter is the case of
> simultaneous open from both sides with the same source/destination
> ports, dns (some clients issue requests from port 53), games and ipsec
> isakmp come to mind.

That can be fixed by checking that we undo the insertion for the same
conntrack entry we were unable to add at the second step.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
