From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH][TRIVIAL]  Unused variable in libipt_LOG.c and libip6t_LOG.c
Date: Mon, 11 Aug 2003 21:54:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030811195418.GH11901@sunbeam.de.gnumonks.org>
References: <3F2DA5B8.8040109@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3F2DA5B8.8040109@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 03, 2003 at 08:15:52PM -0400, Stephane Ouellette wrote:
> Harald,
>=20
>   the following two patches remove an unused variable in save() and=20
> convert all structure initialization to C99.

thanks, applied.

> Regards,
> Stephane Ouellette
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/N/RqXaXGVTD0i/8RAtGcAKCv7v3xFcZ/Z5Y64tlk0KFhnamwqQCfQHpV
KQNcdTcw7PHapqTluo3mpU4=
=HuwC
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--
