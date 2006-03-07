From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID
	must be 1 not 2)
Date: Tue, 07 Mar 2006 19:33:58 +0100
Message-ID: <1141756438.3881.158.camel@localhost.localdomain>
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
	<Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-L1tbYvAbYkF24ixdeC0x"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
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


--=-L1tbYvAbYkF24ixdeC0x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-03-06 at 14:15 +0100, Jozsef Kadlecsik wrote:
> Hi Martin

Hi Jozsef

> > HASHSHIFT and HASHNUM controls the number of struct hashentry per child=
.
> > The original idea was to allocate 1 page (4kB) for each child but I got
> > better results with 2kB, which means it isn't as wide as it was from th=
e
> > start.
>=20
> Did you get faster lookups/insertions/deletions with half of the page
> size?

Yes I did, but I don't trust my testresults 100% (run on my laptop)
because of the fact that my laptop gets better results if I put the
padding at the start of struct hashentry than if I put the padding at
the end.

> As far as I see, the structure should satisfy "contradicting"
> requirements. We want an as low tree as possible, thus minimising the cos=
t
> of the operations. That includes the number of levels of the childs and
> the number of slots in a bucket and the latter depends on the HASHALIGN,
> hashbits_t parameters and the members of the hashentry structure. So in
> theory we should maximize HASHSHIFT and minimize NUMENTRY. However we do
> not want a preallocated, huge, sparse hash either, and therefore it is
> hard to tell the best values.

Maximizing HASHSHIFT makes us allocate a lot for each node.
And minimizing HASHNUM makes struct hashentry smaller, thus giving a
_lot_ of buckets in each node.
Will having say 200 buckets with 3 entries in each bucket be better than
50 buckets with 12 entries in each bucket? Same number of entries in the
node but one child-pointer per bucket, which might lead to even more
child-nodes in the case where we have 200 buckets that fill up rather
quick since they only hold a small number of entries. But on the other
hand we hash to 200 buckets instead of 50 buckets so the total fill-rate
of the node is the same for both cases.
And having lots of entries in a bucket doesn't really cause a
performance degradation as long as you keep the bucket not larger than
the cacheline size and it has to be cacheline aligned.

Having lots of buckets will give an even flatter tree.
I think I've tested this as well about a year ago but I can't remember
the results.

> This structure is quite tricky :-).

Yes it is :) Image how I felt when I got it described to me in
conversations on irc.
There's been a lot of experimentations and failures along the path and
there's still a lot of things to test and rewrite.

> > Small hashbits_t doesn't have anything to do with it, hashbits_t is jus=
t
> > for accelerating lookups. If we have a low number of struct hashentry
> > per child-node we'll probably fill them up faster since there's fewer o=
f
> > them to be filled. And if we have a low NUMENTRY they will also be
> > filled faster.
>=20
> But how can we explain the so few entries in the buckets? Your numbers
> suggest that most of the buckets are pretty empty, as if there were two
> slots full from the 64 in the DoS case.

Yes, it's weird. Havn't had time to write the code to traverse the
produce stats from the tree yet, who knows, tonight may be the night
when that happens :)

> Or we can say that the DoS has got an effect: the jenkins hash were
> unable to produce good enough keys. Or using the 32 bits from the 96
> internal ones is not sufficient.

That might be the case.

> But in the non-DoS random pattern case, there was 819200 entries / 27345
> child-nodes =3D~ 29 entries/child-nodes, that's still around 10%
> utilization. So it looks it's not the jenkins hash which produces the
> sparse tree.

I'll see what I can dig out from the entries in the nodes, it might be
very unbalanced.

> > The problem is how do you know which entry along a path is the oldest?
> > Entries aren't always added to the front like with the current linked
> > lists in the hashtable.
>=20
> We could check the timer of the entry: the oldest one is that which would
> time out nearest in the future.

Ouch, this is exactly what we don't want to do. If we are under attack
we don't want to start looking at entries to determine which entries to
evict, that would result in lots of cachemisses which slows things down
a lot.
The current eviction algorithm tries to evict entries along the path
that the new entry will use, and respect the level of the entries so you
don't end up evicting entries from the root-node all the time, those
free slots will get filled up with new entries rather quickly and we
don't want to evict things we probably just added.
But that doesn't say the current eviction algorithm does the right
thing, it was just something me and Rusty came up with during the
workshop as an aproximation.
Fast batch-killing of entries, but try to not evict from the often
walked parts of the path too often. It is best-effort, no need to bend
over backwards just to do the right thing in all situations, it's not
worth it in the end.

> > The solution would be "ordered independent locking" which locks and add=
s
> > entries based on bucket number that the tuplex hash into.
> > That way we still keep the current behaviour while simplifying the
> > locking, no chance of deadlocks.
>=20
> That looks perfect!

It came to me after writing the description of the "unordered
independent locking", it hit me like a punch in the face, it was so
simple.

--=20
/Martin

--=-L1tbYvAbYkF24ixdeC0x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEDdIWWm2vlfa207ERAuURAJ9dQVnK/GPqvtKT0Zx23rXQoYJHdACgkCfG
1AHkciuErKj+OXOQQh10OtU=
=6/G5
-----END PGP SIGNATURE-----

--=-L1tbYvAbYkF24ixdeC0x--
