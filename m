From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 14/18] Netfilter:  Conntrack Hash Allocation using
	__get_free_pages
Date: Sat, 08 Jan 2005 19:40:13 +0100
Message-ID: <1105209613.4514.19.camel@tux.rsn.bth.se>
References: <1104896182.20582.81.camel@localhost.localdomain>
	<1105133206.1087.46.camel@tux.rsn.bth.se>
	<20050108175744.GA20579@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-lOJiBE3/DKR9og/AXdHY"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20050108175744.GA20579@zion.homelinux.com>
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


--=-lOJiBE3/DKR9og/AXdHY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2005-01-08 at 18:57 +0100, Sven Schuster wrote:
> Hi Martin,

Hi Sven

> On Fri, Jan 07, 2005 at 10:26:46PM +0100, Martin Josefsson told us:
> > +++ linux-2.6.10-bk050106/net/ipv4/netfilter/ip_conntrack_core.c	2005-0=
1-07 22:14:44.000000000 +0100
> > @@ -1349,7 +1349,7 @@
> ...
> > +	if (ip_conntrack_hash) {
> > +		/* Recalculate hashtable size based on order. */
> > +		ip_conntrack_htable_size =3D ((1U << order) << PAGE_SHIFT)
> > +						/ sizeof(struct list_head);
> > +		if (ip_conntrack_max < ip_conntrack_htable_size)
> > +			ip_conntrack_max =3D ip_conntrack_htable_size;
> > +	} else {=20
>=20
> shouldn't this be
>=20
> +		if (ip_conntrack_max > ip_conntrack_htable_size)
>=20
> because you only want ip_conntrack_max to decrease when htable_size has
> become smaller than conntrack_max after the allocation??

No since ip_conntrack_htable_size can't become smaller after the
recalculation, it can either remain the same or become larger due to
that we allocate memory based on order.

Say you have 704MB ram like my workstation, this gives 5632 buckets
without the patch.
5632 buckets =3D 5632 * 8 (two pointers on 32bit machine) bytes =3D 45056
bytes

order 0 means 2^0 pages of memory, order 1 means 2^1 pages of
memory.....
and a page of memory is 4096byte on x86. So in order to allocate 45056
bytes of memory we need 45056 bytes / 4096 bytes/page =3D 11 pages.
And in order to allocate 11 pages we need an order 4 allocation. 2^4 =3D
16 pages (2^3 =3D 8 pages which is too small) =3D 65536 bytes.

So we've allocated 16 pages of memory but we are only using 11 of those
pages.
My patch simply recalculates ip_conntrack_htable_size in order to make
most use of the memory we've actually allocated. pagesize * 2^order is
always at least as big as the amount we requested. So
ip_conntrack_htable_size will never be smaller after this recalculation.

The reason I added the 'if (ip_conntrack_max <
ip_conntrack_htable_size)' was that there is a possibility that the
recalculation increases ip_conntrack_htable_size so it becomes larger
than ip_conntrack_max which doesn't really make sense.
This can happen on machines with very little memory, if I've done my
match correctly this happens on machines with less than 8MB ram. One can
ask the question of how sane a person is to run conntrack on an <8MB
machine... but it looks better in nfsim :)

--=20
/Martin

--=-lOJiBE3/DKR9og/AXdHY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB4CkMWm2vlfa207ERAkdiAJ40WlcfuQvLBTKTyumyYpwJmjQtAACgxRtS
YXjZqkYqYFAkX2X5Lw33dtc=
=lQjF
-----END PGP SIGNATURE-----

--=-lOJiBE3/DKR9og/AXdHY--
