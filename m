From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH 14/18] Netfilter: Conntrack Hash Allocation using
	__get_free_pages
Date: Sat, 8 Jan 2005 19:17:20 +0100
Message-ID: <20050108181720.GA21428@zion.homelinux.com>
References: <1104896182.20582.81.camel@localhost.localdomain>
	<1105133206.1087.46.camel@tux.rsn.bth.se>
	<20050108175744.GA20579@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <20050108175744.GA20579@zion.homelinux.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

please cat my previous posting to /dev/null, this was brain garbage
:-)


Sven (staying away from computer for the rest of the day)


On Sat, Jan 08, 2005 at 06:57:44PM +0100, Sven Schuster told us:
> shouldn't this be
>=20
> +		if (ip_conntrack_max > ip_conntrack_htable_size)
>=20
> because you only want ip_conntrack_max to decrease when htable_size has
> become smaller than conntrack_max after the allocation??
>=20
>=20
> Sven
>=20

--=20
Linux zion 2.6.10-bk7 #0 Fri Jan 7 19:08:39 CET 2005 i686 athlon i386 GNU/L=
inux
 19:15:20 up 23:52,  1 user,  load average: 0.11, 0.05, 0.02

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFB4COwo4FAdB2PneQRAp33AJ9yJSXBXoPaTISRAJrSCa1GRnDfLQCeP5Lp
7dAQKLxh1hbXI2k6ugwfT+E=
=8akx
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
