From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ADMIN] netfilter.org CVS now converted to subversion
Date: Mon, 18 Oct 2004 01:39:37 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041017233937.GB21927@sunbeam.de.gnumonks.org>
References: <20041007164628.GN13901@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0410180124290.11959@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	netfilter-announce@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0410180124290.11959@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 18, 2004 at 01:25:01AM +0200, Henrik Nordstrom wrote:
> On Thu, 7 Oct 2004, Harald Welte wrote:
>=20
> >The old CVS tree will be available for 30 days, so people can still
> >create patches from their changes by using 'cvs diff'.  Startin from
> >November 7, 2004 the CVS pserver service will be deactivated.
>=20
> is it only me, or have the cvs pserver been shut down already?

mh, I changed the config but didn't ask xinetd to reload... somehow it
apparently reloaded the config earlier today :(

it's running again now.

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

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBcwK4XaXGVTD0i/8RAj+5AJwJaM1ckCe4kzLeiVAxFy+zaPkwggCfXref
dNXK2DdLebQdbZbnq76QouI=
=c+NB
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
