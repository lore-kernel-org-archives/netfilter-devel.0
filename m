From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID
	must be 1 not 2)
Date: Sun, 12 Mar 2006 19:49:05 +0100
Message-ID: <1142189345.3881.181.camel@localhost.localdomain>
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
	<1141756438.3881.158.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-YiCWQJYeyKdhpaMImyP2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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


--=-YiCWQJYeyKdhpaMImyP2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-03-07 at 19:33 +0100, Martin Josefsson wrote:

Hi Jozsef

> > But in the non-DoS random pattern case, there was 819200 entries / 2734=
5
> > child-nodes =3D~ 29 entries/child-nodes, that's still around 10%
> > utilization. So it looks it's not the jenkins hash which produces the
> > sparse tree.
>=20
> I'll see what I can dig out from the entries in the nodes, it might be
> very unbalanced.

I've added some very simple debug-code and here's what I've found so far
when testing with random src/dst ip/port.

number of slots per hashtrie bucket: 5
...
Depth 4 - Number of children 0
Depth 4 - Number of buckets 0
Depth 4 - Number of not full buckets 0

Depth 3 - Number of children 0
Depth 3 - Number of buckets 7801856
Depth 3 - Number of entries 291689 (0%)
Depth 3 - Number of not full buckets 7801856

Depth 2 - Number of children 121904
Depth 2 - Number of buckets 262144
Depth 2 - Number of entries 1121175 (85%)
Depth 2 - Number of not full buckets 99698

Depth 1 - Number of children 4096
Depth 1 - Number of buckets 4096
Depth 1 - Number of entries 20480 (100%)
Depth 1 - Number of not full buckets 0

Depth 0 - Number of children 64
Depth 0 - Number of buckets 64
Depth 0 - Number of entries 256 (100%)
Depth 0 - Number of not full buckets 0

If we look at depth 2 we can see the following:

We have 121904 buckets that are "overfull", thus leading to an
expansion.
(121904 * 5 + 291689) / (121904 * 5) =3D 1.48 =3D 148%

And we have 262144 - 121904 - 99698 =3D 40542 buckets that are 100% full.

And we have 99698 not full buckets with a number of entries:
1121175 - (121904 + 40542) * 5 =3D 308945 entries
308945 / (99698 * 5) =3D 0.62 =3D 62% usage

Summary:
121904 buckets that are 148% used.
40542 buckets that are 100% used.
99698 buckets that are 62% used.

So the jenkins hash doesn't seem to be able to distribute the entries
very well.

This leads to the allocation of 121904 children for just 291689 entries,
that's a huge waste of memory. But even if we are able to come up with a
better hash algorithm for this we'll still have this problem when we
start expanding deeper, the size of the tree simply explodes. One idea
I've played with earlier is to change the number of buckets per child
depending on the depth, so we have larger children at the top of the
tree and then they get smaller further down. I'll have to revive that
code (should be somewhere in svn) in order to say if it helped the
memory usage or not, I know it made things a bit slower.

I've also tried making the buckets larger and decreasing HASHSHIFT in
order to not exceed 4kB allocations, this allows the buckets to absorb
the imperfectness of the hashing and memory usage goes down a _lot_.
But... this is will simply destroy performance on machines with small
cachelines as it will lead to lots of cachemisses per bucket.

Any ideas?

--=20
/Martin

--=-YiCWQJYeyKdhpaMImyP2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEFG0hWm2vlfa207ERAloQAKDDVoI3aCFwxCCJsUeY1Uk4F4raEACgmw15
cAksEfvQTASQYsASBEOfHHw=
=sFO+
-----END PGP SIGNATURE-----

--=-YiCWQJYeyKdhpaMImyP2--
