From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] fixes for ipt_unclean.c
Date: Mon, 14 Oct 2002 13:26:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014132620.O13233@sunbeam.de.gnumonks.org>
References: <20021014132237.N13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4OxkfA0LVqADv3Vx"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20021014132237.N13233@sunbeam.de.gnumonks.org>; from laforge@gnumonks.org on Mon, Oct 14, 2002 at 01:22:37PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4OxkfA0LVqADv3Vx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2002 at 01:22:37PM +0200, Harald Welte wrote:
> Hi Dave!
>=20
> Below are two fixes for the EXPERIMENTAL ipt_unclean.c
>=20
> It fixes two bugs:
>=20
> - packets with UDP sport =3D=3D 0 are OK according to RFC768
> - UDP checksum is optional (old code required packet to have a checksum)

I've actually already sent you the UDP checksum fix.  The UDP sport fix is=
=20
new, though.  Just ignore the one failing hunk, thanks.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--4OxkfA0LVqADv3Vx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qqnbXaXGVTD0i/8RArbHAKCnGVsALFuY1GW5FluJnN7LgsH9rgCfcZEW
pxx8pS5Suptv93y4DoGn8Qo=
=PoXi
-----END PGP SIGNATURE-----

--4OxkfA0LVqADv3Vx--
