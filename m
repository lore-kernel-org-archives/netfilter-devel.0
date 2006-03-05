From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Hashtrie testing (was: Re: [PATCH 4/4] first conntrack ID must
	be 1 not 2)
Date: Sun, 05 Mar 2006 14:24:16 +0100
Message-ID: <1141565056.3881.74.camel@localhost.localdomain>
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
	<Pine.LNX.4.58.0602171921540.31400@blackhole.kfki.hu>
	<1141489406.3881.23.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603051026320.28988@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2pDXEwuZqr4z85CZA9e4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0603051026320.28988@blackhole.kfki.hu>
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


--=-2pDXEwuZqr4z85CZA9e4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2006-03-05 at 10:49 +0100, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef

> > I'll move my svn tree to the netfilter svn sometime soon.
>=20
> That'll be great!

After a small struggle with 'svnadmin dump', 'svndumpfilter' and 'sed'
it's finally there with all history.

trunk/hashtrie

Enjoy and don't laugh too much at all the early experimentation :)

> > First I tried removing the upper half of the conntrack entries (it's th=
e
> > conntrack entries index in the test array that's printed out in the
> > "Removing" line below)
> >
> > Number of entries in hashtrie: 819200
> > Number of children in hashtrie: 27345
> > Maxdepth of hashtrie: 3 (0 =3D=3D root)
> > Removing entries between 204800 and 409599.
> > Adding entries between 409599 and 204800.
> > insert (half reverse): time: 1484 cyc, 929 ns (1076184/s)
> > Number of entries in hashtrie: 819200
> > Number of children in hashtrie: 27345
> > Maxdepth of hashtrie: 3 (0 =3D=3D root)
> >
> > No diffrence at all which is a bit weird, I had to doublecheck the code
> > to see that I really readded the entries in reverse order and I did.
>=20
> That's really weird: same maxdepth and exactly the same number of
> children!

Yes I thought so too, I even added a bunch of debug printf's to the code
to verify that it actually readded them in reverse order, and it did.

> > Then I tried it with the lower half of the conntrack entries, those
> > lower in the tree and got this:
> >
> > Number of entries in hashtrie: 819200
> > Number of children in hashtrie: 27273
> > Maxdepth of hashtrie: 3 (0 =3D=3D root)
> > Removing entries between 0 and 204799.
> > Adding entries between 204799 and 0.
> > insert (half reverse): time: 1627 cyc, 1018 ns (981869/s)
> > Number of entries in hashtrie: 819200
> > Number of children in hashtrie: 29189
> > Maxdepth of hashtrie: 3 (0 =3D=3D root)
> >
> > Here wee see that the number of child-nodes has increased from 27273 to
> > 29189, that's a 7.0% increase, but the max depth hasn't increased in
> > this particular test. Given the right sitation the maxdepth will
> > probably increase, it's likely to occur sometimes since the number of
> > child-nodes has increased.
>=20
> Half of the entries were removed then re-added and it produced 7% increas=
e
> in the number of the child nodes. That might be good or bad as well.

Yes I don't know either :)
In these tests both source and destination ipaddresses are random,
that's usually not the case in most installations.
With fixed dst ip, port and 1024 sourceipaddresses and random src ports
it increases by 7.2%

> [...]
> > More testing is clearly needed.
>=20
> Yes, one is somehow uneasy. Hm. What about filling up the hashtrie and
> then some long loop of deleting 10% at random and adding *new* random
> entries? We could measure the change in maxdepth/childnodes after every
> delete/add cycle. What were the peak numbers? At what numbers would it
> stabilize?

I'll test this as well during the evening.
Removing 10% of the entries at random, and then give those entries new
random values and readd them.

--=20
/Martin

--=-2pDXEwuZqr4z85CZA9e4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBECuaAWm2vlfa207ERAqYnAJ90qs0Ii6FJqmUm2OSix4xo3l0xWgCfdpJg
/CMhaTqn1s3ZYxnP39Ul4q8=
=qyuU
-----END PGP SIGNATURE-----

--=-2pDXEwuZqr4z85CZA9e4--
