From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ipt_physdev
Date: Tue, 11 Feb 2003 21:13:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030211201356.GA13814@sunbeam.de.gnumonks.org>
References: <200302110051.18402.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200302110051.18402.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2003 at 12:51:18AM +0100, Bart De Schuymer wrote:
> Hello Harald,
>=20
> In attachment is a patch for the userspace module corresponding with the=
=20
> ipt_physdev.c kernel module included in the standard 2.5 kernel. This mod=
ule=20
> allows filtering on the bridge ports. Since the header file is already in=
 the=20
> standard kernel, I took the liberty of adding the module directly in the=
=20
> extensions/Makefile.=20

That's perfectly fine with me. patch applied.

> Note that this kernel module does not exist for 2.4.

no problem. Maybe you could add a patch for iptables.8, adding
documentation and stating that there is no physdev support for 2.4.x ?

> Bart

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+SVmEXaXGVTD0i/8RAuv+AJ4lgEO9nPK8v375smdCqY/pl0B1CwCghe9T
NFhtgeRhqn/eoGNoJ4N6YHI=
=P7nD
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
