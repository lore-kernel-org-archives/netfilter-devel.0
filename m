From: Harald Welte <laforge@netfilter.org>
Subject: Re: about netfilter priority
Date: Fri, 25 Jul 2003 22:50:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205029.GB3244@sunbeam.de.gnumonks.org>
References: <1057760867.2143.15.camel@sonata>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DQ8UAJma2QEM50Gm"
Cc: ml_linux-net <linux-net@vger.kernel.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yuan ChunYang <cyyuanml@sonata.iscas.ac.cn>
Content-Disposition: inline
In-Reply-To: <1057760867.2143.15.camel@sonata>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DQ8UAJma2QEM50Gm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Wed, Jul 09, 2003 at 10:27:48PM +0800, Yuan ChunYang wrote:
>=20
> As we know ,netfilter supply seven priorities,
>         NF_IP_PRI_FIRST =3D INT_MIN,
>         NF_IP_PRI_CONNTRACK =3D -200,
>         NF_IP_PRI_MANGLE =3D -150,
>         NF_IP_PRI_NAT_DST =3D -100,
>         NF_IP_PRI_FILTER =3D 0,
>         NF_IP_PRI_NAT_SRC =3D 100,
>         NF_IP_PRI_LAST =3D INT_MAX,
>=20
> 1.Can somebody can tell me how to use this priority?

The priority determines the order in which registered functions are
called [in case you have multiple functions registered at one hook].

> Please help me!
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DQ8UAJma2QEM50Gm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZgVXaXGVTD0i/8RAi9KAKCSe0ANtbsw8TFjwHPRPX1DB/r4jQCgomMT
U316CZCkX4Dzs6b4hp7pthE=
=Rr3y
-----END PGP SIGNATURE-----

--DQ8UAJma2QEM50Gm--
