From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Wed, 30 Apr 2003 17:57:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430155736.GE685@sunbeam.de.gnumonks.org>
References: <20030427094949.GF990@sunbeam.de.gnumonks.org> <20030427.173804.13764775.davem@redhat.com> <Pine.LNX.4.44L.0304281710230.12878-100000@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Cc: netfilter-devel@lists.netfilter.org, hime@engineer.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech Sas Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0304281710230.12878-100000@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 05:13:15PM +0200, Wojciech Sas Cieciwa wrote:
>=20
> Hi,
> This is small patch to fix toruble on PPC with netfilter in module.
> [Without this compiler generate "unresolved symbols"]

indeed, there is no need for using floating point arithmetics at all.

Hime, would the proposed changes be fine with you (as the original
author) ?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3Pql8miugIZX0722
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/JwXaXGVTD0i/8RAhzSAKCZdGGZLtuDE1dJea3bQ2LDMQJIewCgkHde
f0Q4nEGkGJtKdnAlXQB6hbQ=
=6sxL
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
