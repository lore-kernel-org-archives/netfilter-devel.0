From: Harald Welte <laforge@netfilter.org>
Subject: Re: Call for testing: patch-o-matic-ng (condition filter)
Date: Tue, 23 Dec 2003 18:41:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031223174153.GB3879@obroa-skai.de.gnumonks.org>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> <1072086985.1031.7.camel@nienna.balabit> <20031222120047.GK5058@obroa-skai.de.gnumonks.org> <200312230757.23207.timg@tpi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Gardner <timg@tpi.com>
Content-Disposition: inline
In-Reply-To: <200312230757.23207.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2003 at 07:57:23AM -0700, Tim Gardner wrote:
> Harald,
>=20
> The condition filter (at least for 2.6) has extra files:
>=20
> condition/linux/net/ipv6/Makefile.ladd
> condition/linux/net/ipv6/Config.in.ladd
>=20
> The presense of Makefile.ladd will not allow the filter to be applied. I=
=20
> suspect Config.in.ladd will cause a similar problem for 2.4.

thanks a lot, I'm removing them from CVS right now.

> Attached is a patch that removes these files as well as patches=20
> ipt_condition.c for 2.6.

we'd need lots of fixes like this one.  Are there any volunteers for submit=
ting patches like this and making sure that 2.4.x and 2.6.x compile ok ?

> Tim Gardner - timg@tpi.com
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6H5hXaXGVTD0i/8RAih6AKC1YxennGllezS0tv2vIyf7cFxnWQCcCZEm
QYl+9+JchFXEWjCLU5CXpLY=
=BDw/
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
