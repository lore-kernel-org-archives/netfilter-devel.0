From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Fri, 17 Feb 2006 10:30:23 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
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

On Fri, 17 Feb 2006, Martin Josefsson wrote:

> > That's actually fine! Now I should complete that hashtrie/hashtable
> > testing I have been planning...
>
> Great that you are testing hashtrie, it works fine in all my simple tests
> but there might still be a lot of bugs in it, especially in the forced
> eviction, it might not be optimal, me and rusty tried to come up with a
> way to make it fair wrt the depth in the tree we are evicting at.
>
> If you have any suggestions and/or patches, please let me know :)

Here are the tests I'd like to see against hashtrie:

- larger hashentry, i.e. when HASHSIFT is equal to 6, 7 or 8
- other HASHALIGN, hashbit_t values: (32, u8), (64, u16) and (64, u32).
  The current (32, u8) doesn't look optimal on 64bit CPUs, (64, u16) seems
  to be the best, but without testing it's hard to choose.
- DoS against hashtrie by non-random tuples: single fixed destination IP,
  port and successive source IP, port numbers. (I don't think the current
  max 7 levels (childs) can survive such an attack.)

Somehow I don't really like the eviction algorithm. What about some lazy
auto-eviction instead: say, if there are more than 90% of the max
elements, then drop a (any) unassured connection which can be found on the
path when inserting a new one. Thus the current fixed stack could be
eliminated and there were no builtin limit in the depth.

I'm collecting the ideas, so can't submit patches yet ;-).

> I have an old untested patch against nf_conntrack as well but it needs
> some rewriting of the conntrack locking in order to avoid an SMP deadlock.

Rusty's lock-ordering is a sure solution, but penalizes the process.
I have been thinking on wether we could use simply, separated, unordered
locking:

1. lock bucket according to tuple1
	add element
   unlock bucket
2. lock bucket according to tuple2,
	add element
   unlock bucket
   if (add element failed)
	undo 1.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
