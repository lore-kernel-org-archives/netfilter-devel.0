From: Harald Welte <laforge@netfilter.org>
Subject: Re: String match for 2.6?
Date: Thu, 16 Dec 2004 14:43:22 +0100
Message-ID: <20041216134322.GJ10165@sunbeam.de.gnumonks.org>
References: <000401c4d458$00f82710$450aa8c0@hierzo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jITzwD3HDGXid3BE"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Content-Disposition: inline
In-Reply-To: <000401c4d458$00f82710$450aa8c0@hierzo>
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


--jITzwD3HDGXid3BE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 27, 2004 at 09:06:30AM +0100, Udo van den Heuvel wrote:
> Hello,
>=20
> Can anyone here comment on the status of the string match for the 2.6 ker=
nel
> series?

The status is that no one submitted a working port yet.  The string
match is not an official feature of netfilter/iptables, but rather a
contributed patch.  The core developers are unlikely to spend time on
it.

> Kind regards,
> Udo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jITzwD3HDGXid3BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwZD6XaXGVTD0i/8RAqMyAJ0QGwHi62gunDsFgVgZervjAJLSNwCgoyD4
dzzXpC+IJ2s1p6u6MJed0H0=
=HUV8
-----END PGP SIGNATURE-----

--jITzwD3HDGXid3BE--
