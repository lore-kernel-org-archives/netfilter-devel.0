From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables/extensions/libipt_time.c missing include
Date: Tue, 27 Jan 2004 14:08:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127130851.GS11761@sunbeam.de.gnumonks.org>
References: <20040127105745.GG11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271300460.16067-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PY8tzLeNxmyMVNR3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401271300460.16067-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PY8tzLeNxmyMVNR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 01:02:17PM +0100, Henrik Nordstrom wrote:

> > At least on my debian machines /usr/include/stddef.h doesn't exist.
>=20
> There should be one in your gcc include directory. It is a compiler=20
> dependent include, not a system dependent one.

stupid me, thanks.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PY8tzLeNxmyMVNR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFmLjXaXGVTD0i/8RAmkFAJsHnfpi1E2qPk7CIDezIk7RQToCQgCeOYye
ika5x4HYRfluvK12S7ZChSE=
=ITyy
-----END PGP SIGNATURE-----

--PY8tzLeNxmyMVNR3--
