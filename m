From: Eric Leblond <eric@inl.fr>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Fri, 19 Jan 2007 23:46:25 +0100
Message-ID: <1169246785.13592.5.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net>  <45B10222.1040806@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-/WBBSB5z0MBQdLjezawL"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45B10222.1040806@netfilter.org>
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


--=-/WBBSB5z0MBQdLjezawL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Le vendredi 19 janvier 2007 =E0 18:38 +0100, Pablo Neira Ayuso a =E9crit :
> Patrick McHardy wrote:
> > Eric Leblond wrote:
> >>  /* rtnl_receive - receive netlink packets from rtnetlink socket */
> >> -int rtnl_receive()
> >> +int rtnl_receive(int rtnl_fd)
> >=20
> > header file needs to be fixed as well. Is the global rtnl_fd still
> > needed?
>=20
> Indeed. Eric, all this global stuff below must dissapear at all, from
> rtnl.c:

I totally agree. Patch was prefixed with RFC because I wanted to see if
API was correct. As there is no problem from this point, I will do the
needed cleaning.

All my apologies to Patrick, a bad vimrc and some mistakes make from
previous patch something awful.

> static struct ifindex_map *ifindex_map[16];

To answer to Patrick, I really don't like to have variable and type with
the same name, it's quiet confusing. That's why I change it to "struct
ifindex_map_t".

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-/WBBSB5z0MBQdLjezawL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFsUpBnxA7CdMWjzIRAoRcAJ9EzlpujbCWHlLvYUWM4iZ9GIgTNACfQidd
do46GgUA1d5iI26wYgxdNF8=
=AbWz
-----END PGP SIGNATURE-----

--=-/WBBSB5z0MBQdLjezawL--
