From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] patch-o-matic fixes
Date: Wed, 30 Apr 2003 17:32:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430153222.GC685@sunbeam.de.gnumonks.org>
References: <20030430085332.GA32392@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20030430085332.GA32392@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2003 at 10:53:32AM +0200, Willy Tarreau wrote:
> Hi Harald,
>=20
> here are 2 patches so slightly modify 2 patches in the patch-o-matic :
>=20
> 1) u32 classifier applies at a wrong level because it contains the full p=
ath,
>    which ends up creating a usr directory in the kernel tree

fixed in cvs now.

> 2) extra/tcp_window_tracking doesn't apply to 2.4.21-rc1 anymore because
>    of a small context change.

I don't want to change this before we have a cumulative 2.4.21.patch.
This is the only way in order to have patch-o-matic compatible with
old and new kernel versions.

Martin, can you please make a cumulative 2.4.21-rc1.patch, including all
netfilter changes that have been included up to rc1?=20

> Cheers,
> Willy
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r+yGXaXGVTD0i/8RAteJAJ4sPngcXkOny2kM4h54dtiDK4+YKgCcCGm6
+954CRNkvwuiq6rjQSsu5D0=
=+gQ4
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
