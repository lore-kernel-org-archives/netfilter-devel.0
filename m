From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: How/where does the kernel map packets to an application ...
Date: Thu, 15 Jan 2004 20:34:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074195257.21470.24.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0401150801330.11137-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tc15ZLXuUwdw3BUuMgYq"
Cc: Andrej Ricnik <andrej@paradise.net.nz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401150801330.11137-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-tc15ZLXuUwdw3BUuMgYq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-01-15 at 08:10, Henrik Nordstrom wrote:

> > At which point does the kernel determine which application
> > a incoming packet is meant for?
>=20
> Ah, incoming packets. Then the situation is a little harder. The owner=20
> match only works on outgoing packets.

extra/owner-socketlookup.patch from patch-o-matic adds support for
looking it up for incoming packets.
It's basicly a layering violation but it works...

--=20
/Martin

--=-tc15ZLXuUwdw3BUuMgYq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBABus5Wm2vlfa207ERAudTAJ9x3IhGImbxVTwTqs6wYuK+ov3gUACdEIaN
3mDIBWYTOUHqBLnjnq6/89U=
=siUN
-----END PGP SIGNATURE-----

--=-tc15ZLXuUwdw3BUuMgYq--
