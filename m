From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] cleanup for random seed initialization ip_conntrack_hash_rnd
Date: Tue, 13 Apr 2004 01:30:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040412233025.GF1424@sunbeam.de.gnumonks.org>
References: <407B1E91.5090206@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eVzOFob/8UvintSX"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <407B1E91.5090206@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eVzOFob/8UvintSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2004 at 12:56:17AM +0200, Pablo Neira wrote:
> Hi Harald and list,
>=20
> Attached a clean up for the initialization of the random seed used in=20
> ip_conntrack. With this patch the random seed is initialized once when=20
> ip_conntrack is loaded instead of checking every time a conntrack is=20
> created whether it was already initialized or not. If I'm missing=20
> something, please let me know.

yes, you are missing that there might not be sufficient entropy yet at
the time ip_conntrack is loaded (or, for that matter, consider a
statically linked ip_conntrack).

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

--eVzOFob/8UvintSX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAeyaQuOzVP8+Oy+QRAkFbAJ9YnB8nnf1fTacSS4lB/2BmCu50hwCff4n9
pJX1wVLgQfYhHqXxLRiCdXI=
=SJle
-----END PGP SIGNATURE-----

--eVzOFob/8UvintSX--
