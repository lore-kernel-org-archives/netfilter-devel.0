From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH, RFC] possible use of freed skbuff in netfilter.c
Date: Wed, 30 Apr 2003 18:37:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430163749.GJ685@sunbeam.de.gnumonks.org>
References: <200304251957.18012.bdschuym@pandora.be> <20030429145129.GG684@naboo.intranet.astaro.de> <20030429.235444.26991098.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
Cc: bdschuym@pandora.be, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030429.235444.26991098.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2003 at 11:54:44PM -0700, David S. Miller wrote:
>    From: Harald Welte <laforge@netfilter.org>
>    Date: Tue, 29 Apr 2003 16:51:29 +0200
>=20
>    I'm fine with this fix, please apply (if it isn't already).
>=20
> Applied.  Should we be putting this fix into 2.4.x as well?

Since 2.4.x doesn't have the physindev/physoutdev, the bug is not
present in 2.4.x - and thus no fix needed.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/vdXaXGVTD0i/8RAgDAAKCNWVugWDN9bXXoxxdgUnfTIeRJYwCfX/jM
pl01F/5mp/OVzX5m/aEAvrw=
=Jpsw
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
