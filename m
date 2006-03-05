From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID
	must be 1 not 2)
Date: Sun, 05 Mar 2006 18:48:58 +0100
Message-ID: <1141580938.3881.129.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Lxu0bJW9iJfzLDMmgF58"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
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


--=-Lxu0bJW9iJfzLDMmgF58
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2006-03-05 at 12:24 +0100, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef

> HASHSIFT (i.e. HASHNUM) defines the hash size of the hashtrie.
> But the hashtrie - according to your tests - are much "wider" than
> "deep". So there might be no point in widening the hash.

HASHSHIFT and HASHNUM controls the number of struct hashentry per child.
The original idea was to allocate 1 page (4kB) for each child but I got
better results with 2kB, which means it isn't as wide as it was from the
start.

> > > - other HASHALIGN, hashbit_t values: (32, u8), (64, u16) and (64, u32=
).
> >
> > Yes this needs more testing as well.
> >
> > >   The current (32, u8) doesn't look optimal on 64bit CPUs, (64, u16) =
seems
> > >   to be the best, but without testing it's hard to choose.
> >
> > Currently I don't have any 64bit cpus to test things on.

HASHALIGN is the size of struct hashentry, the idea is that HASHALIGN
should be equal to the cacheline size of the cpu it's running on. That
way you only get one cachemiss per level in the tree.
HASHALIGN is set to 32 bytes just because my laptop has 32byte
cachelines, other cpus has 64bytes or even 128bytes.

hashbit_t is an u8 because in my tests I havn't see any gain by going to
more bits.
The only purpose of hashbits is to "cheat" a bit during lookup, store a
part of the hash-value in the datastructure so you can easily determine
if a member even can be a possible match by comparing the hashbits to
the hashvalue you are searching for, this eliminates a lot of
cachemisses (without this the datastructure will behave more like a
linked list).

I've tested with diffrent number of bits for hashbits but I havn't seen
any real gain by going over 7 bits which is what is currently used, and
the last bit is used as status bit for ASSURED.

> With the default (32, u8) settings NUMENTRY looks too small on 64bit
> CPUs:

Yes it's too small, luckily I don't know of any 64bit cpus that have
32byte cachelines :)
Lets say we keep hashbits as an u8 then we get the following results for
diffrent cacheline sizes (I believe the intel p4 has 128byte cachelines)

HASHALIGN =3D 32
hashbits_t =3D u8

    32bit CPU:  NUMENTRY =3D (32 - 4)/(1+4) =3D 5
                PADNUM =3D 32 - 4 - 5*(1+4) =3D 3

    64bit CPU:  NUMENTRY =3D (32 - 8)/(1+8) =3D 2
                PADNUM =3D 32 - 8 - 2*(1+8) =3D 6


HASHALIGN =3D 64
hashbits_t =3D u8

    32bit CPU: NUMENTRY =3D (64 - 4)/(1 + 4) =3D 12
                       PADNUM =3D 64 - 4 - 12*(1 + 4) =3D 0

    64bit CPU: NUMENTRY =3D (64 - 8)/(1 + 8) =3D 6
                       PADNUM =3D 64 - 8 - 6*(1 + 8) =3D 2

HASHALIGN =3D 128
hashbits_t =3D u8

    32bit CPU: NUMENTRY =3D (128 - 4)/(1 +4) =3D 24
                       PADNUM =3D 128 - 4 - 24*(1 + 4) =3D 4

    64bit CPU: NUMENTRY =3D (128 - 8)/(1 + 8) =3D 13
                       PADNUM =3D 128 - 8 - 13*(1 + 8) =3D 3

When HASHALIGN goes up we need to reduce HASHSHIFT in order to make sure
we don't try to allocate > 1 page (usually 4kB) of memory.

> > > - DoS against hashtrie by non-random tuples: single fixed destination=
 IP,
> > >   port and successive source IP, port numbers. (I don't think the cur=
rent
> > >   max 7 levels (childs) can survive such an attack.)
[snip]
> > 2.4 million entries in the hashtrie with fixed dstip, port and 1024
> > srcip's with random ports and a maxdepth of 3. I'd say the jenkins hash
> > is doing its job quite nicely, wasn't expecting such good results.
>=20
> The hashtrie tends to grow wider and not deeper:
>=20
> level:		childs (max)	entries (max)
> 0		64		320
> 1		4160		20800
> 2		266304		1331520
> 3		17043520	85217600

It grows wider if and only if we get hashvalues that aren't too similar
in the high bits. If that happens we grow deeper instead of wider. But
it seems the jenkins hash is really good at distributing the changes
over all of the bits in the hashvalue. (it's just a little bit on the
heavy side, it uses plenty of cpu)

> > I'm almost starting to think there's a major bug in there somewhere.
> > I need to write some code to walk the tree and calculate the usage of
> > each level to see that it's actually 100% for all buckets that has a
> > child.
>=20
> Yes, that could help to spot the problem. But if there are clashes
> (due to using to small parts of the hash key, i.e  hashbits_t =3D u8), th=
en
> the node can be fairly low utilized and still there is a need to expand b=
y
> new childs.

Small hashbits_t doesn't have anything to do with it, hashbits_t is just
for accelerating lookups. If we have a low number of struct hashentry
per child-node we'll probably fill them up faster since there's fewer of
them to be filled. And if we have a low NUMENTRY they will also be
filled faster.

> > Couldn't this lead to the situation where we evict an entry early on th=
e
> > path, and then that slot gets reused for another entry that's also
> > unassured, and it repeats...
>=20
> You mean, we could always evict the newest unassured entries instead of
> the oldest ones? The algorithm could be extended so that we'd walk the
> whole tree and register the oldest unassured entry in the path. I'm more
> worried that we'd check too litle number of entries as the tree is shorte=
r
> than I thought.

The problem is how do you know which entry along a path is the oldest?
Entries aren't always added to the front like with the current linked
lists in the hashtable.

> > > I have been thinking on wether we could use simply, separated, unorde=
red
> > > locking:
> [...]
> > The only case I can think about where it might matter is the case of
> > simultaneous open from both sides with the same source/destination
> > ports, dns (some clients issue requests from port 53), games and ipsec
> > isakmp come to mind.
>=20
> That can be fixed by checking that we undo the insertion for the same
> conntrack entry we were unable to add at the second step.

What I meant is the following situation:

clients A & B are both located behind NAT and are trying to connect to
each other.
Both bind to the same port, lets say X and try to connect to each others
external ip.
Currently if the packets from both clients arrive at the same time at an
SMP firewall we add a conntrack entry for one of the clients but drop
the second one because of the global lock.
With Rustys lock ordering we keep this behaviour since both buckets are
locked in the same order for both packets.
With the "unordered independent locking" of buckets we might end up
with:

these happen at the same time:
packet from client A hashes into bucket C, lock and add entry.
packet from client B hashes into bucket D, lock and add entry.

and after that these happen at the same time:
packet from client A hashes into bucket D, lock and find entry, remove
entry in bucket C
packet from client B hashes into bucket C, lock and find entry, remove
entry in bucket D

This leads to no conntrack entry created for any of the clients
connection attempts.

The solution would be "ordered independent locking" which locks and adds
entries based on bucket number that the tuplex hash into.
That way we still keep the current behaviour while simplifying the
locking, no chance of deadlocks.

--=20
/Martin

--=-Lxu0bJW9iJfzLDMmgF58
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBECySKWm2vlfa207ERAqvQAJ0dKvq+UXLfeJB3xoE4g8JwSl8GvgCfTzzz
F3kVsXnMqrBgPpgNK3ubWgM=
=wY8M
-----END PGP SIGNATURE-----

--=-Lxu0bJW9iJfzLDMmgF58--
