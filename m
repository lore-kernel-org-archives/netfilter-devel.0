From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must be
	1 not 2)
Date: Sat, 04 Mar 2006 21:11:51 +0100
Message-ID: <1141503111.3881.61.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2RJbgbeh03CAyLU0baeR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
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


--=-2RJbgbeh03CAyLU0baeR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-02-17 at 10:30 +0100, Jozsef Kadlecsik wrote:

> Here are the tests I'd like to see against hashtrie:
>=20
> - larger hashentry, i.e. when HASHSIFT is equal to 6, 7 or 8

I have seen good results when sizeof(struct hashentry) =3D 64 on my
laptop. But on the other hand my laptop likes the padding of struct
hashentry at the beginning with gives unaligned pointers. It's an
Pentium M processor in my laptop.

> - other HASHALIGN, hashbit_t values: (32, u8), (64, u16) and (64, u32).

Yes this needs more testing as well.

>   The current (32, u8) doesn't look optimal on 64bit CPUs, (64, u16) seem=
s
>   to be the best, but without testing it's hard to choose.

Currently I don't have any 64bit cpus to test things on.

> - DoS against hashtrie by non-random tuples: single fixed destination IP,
>   port and successive source IP, port numbers. (I don't think the current
>   max 7 levels (childs) can survive such an attack.)

I just ran some tests on this with this code:

dstip =3D 192 << 24 | 168 << 16 | 1 << 8 | 1;
srcip =3D 200 << 24 | 100 << 16 | 50 << 8 | 0;

conntrack[i]->tuple[IP_CT_DIR_ORIGINAL].src.ip =3D srcip + rand() % 1024;
conntrack[i]->tuple[IP_CT_DIR_ORIGINAL].src.u.tcp.port =3D (u16)rand();
conntrack[i]->tuple[IP_CT_DIR_ORIGINAL].dst.ip =3D dstip;
conntrack[i]->tuple[IP_CT_DIR_ORIGINAL].dst.u.tcp.port =3D 80;

And this is the result I got:

sizeof struct hashentry: 32
sizeof struct ip_conntrack: 48
number of conntrack entries: 1228800
number of slots per hashtrie bucket: 5
number of pad bytes: 3
number of bytes per child: 2048
insert: time: 11299 cyc, 18854 ns (53040/s)
Number of failed inserts: 22232
Number of entries in hashtrie: 2435368
Number of children in hashtrie: 238756
Maxdepth of hashtrie: 3 (0 =3D=3D root)
Maximum memory usage: 488972288

2.4 million entries in the hashtrie with fixed dstip, port and 1024
srcip's with random ports and a maxdepth of 3. I'd say the jenkins hash
is doing its job quite nicely, wasn't expecting such good results.

In the results above you see my main worry regarding hashtrie, the
memory usage, 200 bytes per entry in hashtrie (400 bytes per conntrack)
in this scenario, which means that the child-nodes aren't very populated
in the leaf nodes.

2435368 entries / 238756 child-nodes =3D 10.2 entries/child-node

And there's 2048 / 32 =3D 64 struct hashentry per child-node.
That's 64 * 5 =3D 320 entries/child-node

10.2 / 320 =3D 3.2% usage of child-nodes in average which is simply
horrible.

I'm almost starting to think there's a major bug in there somewhere.=20
I need to write some code to walk the tree and calculate the usage of
each level to see that it's actually 100% for all buckets that has a
child.

> Somehow I don't really like the eviction algorithm. What about some lazy
> auto-eviction instead: say, if there are more than 90% of the max
> elements, then drop a (any) unassured connection which can be found on th=
e
> path when inserting a new one. Thus the current fixed stack could be
> eliminated and there were no builtin limit in the depth.

Couldn't this lead to the situation where we evict an entry early on the
path, and then that slot gets reused for another entry that's also
unassured, and it repeats...
The problem with eviction in the hashtrie is that the depth of the entry
has no correlation to the age of the entry like in the current hashtable
(that's only true if you have long linked lists which leads to poor
performance, so no real-world installation has properly working
evication anyway today so maybe it doesn't matter too much)

> > I have an old untested patch against nf_conntrack as well but it needs
> > some rewriting of the conntrack locking in order to avoid an SMP deadlo=
ck.
>=20
> Rusty's lock-ordering is a sure solution, but penalizes the process.
> I have been thinking on wether we could use simply, separated, unordered
> locking:
>=20
> 1. lock bucket according to tuple1
> 	add element
>    unlock bucket
> 2. lock bucket according to tuple2,
> 	add element
>    unlock bucket
>    if (add element failed)
> 	undo 1.

Yes this is the way I've been thinking about. If we get into the case
where we have conntrack A and B that have the exact same tuples but in
reverse it doesn't really matter if one gets dropped or both, this is
strictly best effort, no need to bend over backwards in order to
minimize racewindows if it isn't anything serious.
The only case I can think about where it might matter is the case of
simultaneous open from both sides with the same source/destination
ports, dns (some clients issue requests from port 53), games and ipsec
isakmp come to mind.=20

--=20
/Martin

--=-2RJbgbeh03CAyLU0baeR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBECfSHWm2vlfa207ERAjcEAJ9CxLfewBfiFzUg3Xf1/l9TmpDyGACfTL9C
BAkGMlRFSO/sFeYB7yrWqUg=
=uHwh
-----END PGP SIGNATURE-----

--=-2RJbgbeh03CAyLU0baeR--
