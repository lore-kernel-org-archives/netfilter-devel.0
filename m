From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] netfilter unclean match extension
Date: Wed, 23 Oct 2002 13:22:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021023132248.E2450@sunbeam.de.gnumonks.org>
References: <20021022144050.GH3039@naboo.club.berlin.ccc.de> <20021023.040314.88793185.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20021023.040314.88793185.davem@redhat.com>; from davem@redhat.com on Wed, Oct 23, 2002 at 04:03:14AM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2002 at 04:03:14AM -0700, David Miller wrote:
>    From: Harald Welte <laforge@gnumonks.org>
>    Date: Tue, 22 Oct 2002 16:40:50 +0200
>   =20
>    Exerpt from RFC 791: Various Control Flags.  Bit 0: reserved, must be =
zero
>=20
> Just to be clear, if a future RFC or ietf working draft defines
> meaning for this field, will we remove this new test from the
> unclean module?

yes, we will.  But right now the RFC doesn't only say 'reserved for future
use', but says 'must be zero'.

IIRC, this is different from the ECN case.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9toaIXaXGVTD0i/8RAvp6AJwK1Jp+/wTqNnlcG+N71R+LcG4kaQCdFhVM
KmV7MXcaxDefQWEM73dTu+Q=
=Tj9r
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
