From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] cleanup conntrack helper API
Date: Mon, 29 Mar 2004 16:45:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329144558.GI7039@sunbeam.de.gnumonks.org>
References: <20040329104011.GE1528@sunbeam.de.gnumonks.org> <40682F02.6000901@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZkK3DH7HIvxYLwhR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <40682F02.6000901@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZkK3DH7HIvxYLwhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2004 at 04:13:22PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> Harald Welte wrote:
>=20
> >Hi Dave!
> >
> >This is the first in a set of 2.6.x optimization patches.  Obviosly,
> >they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.
> >=20
> >
> If this patch goes to stable kernel 2.6 branch, it implies that all=20
> helpers available in pom-ng which use the old call won't compile, so=20
> they won't work :-).

I was well aware of that.

> So, do you want me to prepare a patch for all those helpers?

I actually thought you alrady did so (the 'cvs' patch you sent).  But I
only discovered now, that this was a misconception.

Please go ahead and send me a fix for pom-ng :)

Thanks.

> regards,
> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZkK3DH7HIvxYLwhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAaDamXaXGVTD0i/8RAkuHAKCqQ3jcY/aY8g4vY6cfmWw0fQvIEgCgtErr
p/NisWeIIG1LMgl2nur5aws=
=O5aQ
-----END PGP SIGNATURE-----

--ZkK3DH7HIvxYLwhR--
