From: Harald Welte <laforge@netfilter.org>
Subject: Re: [BUG] ipt_SAME rule can't be deleted
Date: Thu, 16 Dec 2004 13:42:13 +0100
Message-ID: <20041216124212.GG10165@sunbeam.de.gnumonks.org>
References: <20041204150223.GA10247@dfbbb.opencjk.org>
	<Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
	<51066.142.169.215.10.1102366785.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sClP8c1IaQxyux9v"
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
Content-Disposition: inline
In-Reply-To: <51066.142.169.215.10.1102366785.squirrel@142.169.215.10>
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


--sClP8c1IaQxyux9v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2004 at 03:59:45PM -0500, Samuel Jean wrote:
> On Mon, December 6, 2004 2:34 am, Henrik Nordstrom said:
>=20
> >          u_int32_t *iparray;
> >
> > If I am right the same problem applies to -m limit and any other extens=
ion
> > storing private kernel side stuff within it's info data..
> >
>=20
> If I am right too,
> This wouldn't happen if we moved u_int32_t *iparray at end of structure.
> Then, registering the target plugin that way :
>=20
>     .size            =3D IPT_ALIGN(sizeof(struct ipt_same_info)),
>     .userspacesize   =3D offsetof(struct ipt_same_info, iparray),
>=20
> Would fix this inconveniant.

Unfortunately we cannot just change the order now, since then we run
into all the back/forward compatibility issues again...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sClP8c1IaQxyux9v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwYKkXaXGVTD0i/8RAnUUAJoD53n/lCO1KAzz1JPi/r0rk4RDrwCgq+AA
SnoHs+a6ksJHfxsvHeZoDDk=
=eanA
-----END PGP SIGNATURE-----

--sClP8c1IaQxyux9v--
