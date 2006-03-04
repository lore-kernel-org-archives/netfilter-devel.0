From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Hashtrie testing (was: Re: [PATCH 4/4] first conntrack ID must be
	1 not 2)
Date: Sat, 04 Mar 2006 17:23:26 +0100
Message-ID: <1141489406.3881.23.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-KwudO+Q5pOR5I9P/H1TP"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602171921540.31400@blackhole.kfki.hu>
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


--=-KwudO+Q5pOR5I9P/H1TP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-02-17 at 19:41 +0100, Jozsef Kadlecsik wrote:

(Changing subject and removing some cc's)

> Hi Martin,

Hi Jozsef

> On Fri, 17 Feb 2006, Jozsef Kadlecsik wrote:
>=20
> > I'm collecting the ideas, so can't submit patches yet ;-).

:)

I'll move my svn tree to the netfilter svn sometime soon.

> Two more things:
>=20
> - the Jenkins hash internally produces 96 bits, which we could
>   use in the hashtrie

That's a great idea, will look into it.

> - there should be some (whatever artifical) tests to study the
>   dynamical behaviour of the hashtrie: say all the entries are
>   added, then half of them deleted and added back again, but
>   in reverse order. Will the maxdepth grow?

I've performed some simple tests with this and here are the results:

First I tried removing the upper half of the conntrack entries (it's the
conntrack entries index in the test array that's printed out in the
"Removing" line below)

Number of entries in hashtrie: 819200
Number of children in hashtrie: 27345
Maxdepth of hashtrie: 3 (0 =3D=3D root)
Removing entries between 204800 and 409599.
Adding entries between 409599 and 204800.
insert (half reverse): time: 1484 cyc, 929 ns (1076184/s)
Number of entries in hashtrie: 819200
Number of children in hashtrie: 27345
Maxdepth of hashtrie: 3 (0 =3D=3D root)

No diffrence at all which is a bit weird, I had to doublecheck the code
to see that I really readded the entries in reverse order and I did.

Then I tried it with the lower half of the conntrack entries, those
lower in the tree and got this:

Number of entries in hashtrie: 819200
Number of children in hashtrie: 27273
Maxdepth of hashtrie: 3 (0 =3D=3D root)
Removing entries between 0 and 204799.
Adding entries between 204799 and 0.
insert (half reverse): time: 1627 cyc, 1018 ns (981869/s)
Number of entries in hashtrie: 819200
Number of children in hashtrie: 29189
Maxdepth of hashtrie: 3 (0 =3D=3D root)

Here wee see that the number of child-nodes has increased from 27273 to
29189, that's a 7.0% increase, but the max depth hasn't increased in
this particular test. Given the right sitation the maxdepth will
probably increase, it's likely to occur sometimes since the number of
child-nodes has increased.

Then I tried to remove every other entry and then readding them in
reverse order (this test is performed after the previous readd of the
lower half, not the same testrun as above so the absolute numbers
doesn't match those above):

Number of entries in hashtrie: 819200
Number of children in hashtrie: 27329
Maxdepth of hashtrie: 3 (0 =3D=3D root)
Removing entries between 0 and 204799.
Adding entries between 204799 and 0.
insert (half reverse): time: 1590 cyc, 996 ns (1004079/s)
Number of entries in hashtrie: 819200
Number of children in hashtrie: 29253
Maxdepth of hashtrie: 3 (0 =3D=3D root)
Removing every other entry from 0 to 409599
Adding every other entry from 409599 to 0
insert (other reverse): time: 1637 cyc, 1025 ns (975239/s)
Number of entries in hashtrie: 819200
Number of children in hashtrie: 29376
Maxdepth of hashtrie: 3 (0 =3D=3D root)

Here we see that the number of child-nodes increased in the
remove_lower_half_and_readd_in_reverse_order test just as it did before,
and then the number of child-nodes increased again after removing every
other entry and adding them back in reverse order. The total increase
after both tests is 7.5%

More testing is clearly needed.

--=20
/Martin

--=-KwudO+Q5pOR5I9P/H1TP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBECb79Wm2vlfa207ERAvUCAJ9RlECyZWNtx+lT1lmilQ/ztfP0SQCggQXP
PVTEyDWKFpztwFhYS4TrekU=
=Mkta
-----END PGP SIGNATURE-----

--=-KwudO+Q5pOR5I9P/H1TP--
