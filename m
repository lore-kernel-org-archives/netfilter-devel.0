From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]  libip6t_dst.c
Date: Thu, 4 Sep 2003 23:53:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030904215338.GE6909@obroa-skai.de.gnumonks.org>
References: <3F5785BD.9010202@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Cc: Netfilter Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3F5785BD.9010202@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2003 at 02:34:37PM -0400, Stephane Ouellette wrote:
> Harald,
>=20
>  in a patch I've sent you recently, I introduced a typo.

well, that happens. No problem.

> 1- Fix preprocessor directive usage,
> 2- Redefine UNAME and LNAME macros such that their value is determined=20
> at compile-time, not at run-time,
> 3- Modify all printf() calls that use LNAME and UNAME to take advantage=
=20
> of the compile-time macro definitions,
> 4- More indentation fixes.

ok, thanks. I'm fine with all changes.  Patch will appear in CVS
shortly.

> Stephane Ouellette.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/V7RiXaXGVTD0i/8RAulBAKCcWguSGS2h2mK1ut7hUicYmxSm/wCfag9T
MqbMpbicgGEn9fYNGiojcG0=
=kbsx
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
