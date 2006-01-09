From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 9 Jan 2006 10:19:46 +0100
Message-ID: <20060109091946.GH24266@sunbeam.de.gnumonks.org>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C199C4.2080902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W2ydbIOJmkm74tJ2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43C199C4.2080902@trash.net>
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


--W2ydbIOJmkm74tJ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09, 2006 at 12:01:24AM +0100, Patrick McHardy wrote:
> OK, here are a couple of more comments.

thanks a lot.

> - xt_owner:
>=20
> Unfortunately I think the owner match can't be converted to x_tables
> without breaking compatiblity with ip6_tables. The ip6_tables version
> never supported command and sid matching, so the structures differ in
> size and layout.

yes. The xt_owner file is not active and I should have deleted it from
the tree.  As you might have noticed, ip[6]t_owner.c are still present
and active.  I arrived at the same conclusion as you, but just never
removed the files.  done now.

> - xt_realm:
>=20
> IPv6 doesn't use tclassid, so its currently useless for ip6_tables.
> Maybe keep it as an x_tables match and just don't register for
> ip6_tables.

This is actually what it does.  only registers for AF_INET.

> - xt_conntrack:
>=20
> The existing match is unfixable IPv4 specific because of address sizes,
> NAT support, ..., so it also shouldn't register for IPv6. An
> IPv6-capable version probably needs to duplicate most of the code,
> but I'd keep it as x_tables match anyway.

mh, ok, removed AF_INET registration from my tree.

> - assertion while adding rules

oops, somebody is actually still using CONFIG_NETFILTER_DEBUG...

> I get this assertion while adding rules:
> ASSERT: CPU #0, filter comefrom(ecbaf05c) =3D 2
>=20
> I assume its known because the place responsible for setting comefrom
> is surrounded by CONFIG_FIXME :) I'm going to look into fixing it.

Well, if you look into that, I'll rather work on something else now.
Just send me a patch :)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--W2ydbIOJmkm74tJ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDwiqyXaXGVTD0i/8RAh9EAJ4xi98000GBjTWXvyaUETSdFXKQuwCfQz/0
gXsxtQW7Z4yEvp5b4by0/I8=
=EHJw
-----END PGP SIGNATURE-----

--W2ydbIOJmkm74tJ2--
