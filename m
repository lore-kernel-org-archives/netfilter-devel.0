From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] patch-o-matic fixes
Date: Wed, 30 Apr 2003 22:20:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430202009.GK685@sunbeam.de.gnumonks.org>
References: <20030430085332.GA32392@alpha.home.local> <20030430153222.GC685@sunbeam.de.gnumonks.org> <1051717921.8200.151.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wHh0aNzodMFDTGdO"
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051717921.8200.151.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wHh0aNzodMFDTGdO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2003 at 05:52:01PM +0200, Martin Josefsson wrote:

> It does apply IF you've applied pending/24_conntrack-nosysctl.patch
> Which should have been done. We've had implicit dependencies on
> submitted and pending stuff many times.
>=20
> No need to make a cumulative -rc1 patch, I've managed to get it working
> for .18 .19 .20 .21-rc1 and .21-bk

great, thanks for pointing this out.

> /Martin
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wHh0aNzodMFDTGdO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+sC/5XaXGVTD0i/8RAhQEAKCLD/OusVVRDz5DAf56q5AcCmqc2wCggPU0
bnbPoynJf5+L26dfWPY22Vo=
=sTz6
-----END PGP SIGNATURE-----

--wHh0aNzodMFDTGdO--
