From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] iptables-save match tos bug-fix
Date: Thu, 28 Nov 2002 09:02:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021128080233.GH7047@naboo.de.gnumonks.org>
References: <20021126032827.0c755686.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Schwendt <rh0209ms@arcor.de>
Content-Disposition: inline
In-Reply-To: <20021126032827.0c755686.rh0209ms@arcor.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2002 at 03:28:27AM +0100, Michael Schwendt wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Hi everyone!
>=20
> Here's one more patch for another "missing space in save() function"
> bug. This time it's the "tos match" userspace extension. An inverted
> TOS match is not saved correctly, so that iptables-restore would
> understand it.

thanks. I'll apply it as soon as I have IP connectivity again.

> Michael

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE95c2ZXaXGVTD0i/8RAiiCAJ4zhSW9rKgC2NOQCEs7ODzMMxEa0ACfU0p9
Auo5fch7zOFvITWYohSRWCM=
=fToC
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
