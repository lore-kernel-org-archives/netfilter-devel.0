From: Harald Welte <laforge@netfilter.org>
Subject: Re: [patch-o-matic-ng] raw
Date: Wed, 21 Jan 2004 09:15:38 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121141538.GU8642@obroa-skai.de.gnumonks.org>
References: <200401161520.27405.timg@tpi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wIc/V6YLA2QdyfT4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Gardner <timg@tpi.com>
Content-Disposition: inline
In-Reply-To: <200401161520.27405.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wIc/V6YLA2QdyfT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2004 at 03:20:27PM -0700, Tim Gardner wrote:
> Harald,
>=20
> Please add to raw/linux/net/ipv4/netfilter/Makefile.ladd:
>=20
> obj-$(CONFIG_IP_NF_RAW) +=3D iptable_raw.o

I'll add a Makefile.ladd_2 for that.

> Tim Gardner - timg@tpi.com

P.S.: It would really help if you'd start to use unified diffs :)

Thanks again.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wIc/V6YLA2QdyfT4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADomJXaXGVTD0i/8RAnZ1AKCcgYum5nMvLz6R+Vh9uWhITO2WEwCgoEiV
Ft7TiH4RwhDl/lgYiu13XSY=
=U2MQ
-----END PGP SIGNATURE-----

--wIc/V6YLA2QdyfT4--
