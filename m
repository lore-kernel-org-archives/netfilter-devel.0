From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter on solaris?
Date: Sat, 15 Jun 2002 14:55:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615145530.T2543@sunbeam.de.gnumonks.org>
References: <20020614100540.GA6399@balabit.hu> <Pine.LNX.4.33.0206141216360.17029-100000@blackhole.kfki.hu> <20020614104707.GA6827@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uqlJfHshKOiOfK6d"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20020614104707.GA6827@balabit.hu>; from bazsi@balabit.hu on Fri, Jun 14, 2002 at 12:47:07PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--uqlJfHshKOiOfK6d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2002 at 12:47:07PM +0200, Balazs Scheidler wrote:
> > But how do you imagine the porting so that the maintenance would not
> > become a nightmare?
>=20
> Of course I'd want to provide system independency using some headers which
> would make it work on both Linux/Solaris, so it could be incorporated into
> standard Netfilter as well.=20

Just to make this clear:

As long as I am one of the maintainers of netfilter/iptables, I am not=20
going to do any extra hassle in order to support different operating system=
s.
This includes using weird different types instead of sk_buff.  Linux kernel
hackers expect to see linux code, not something abstract using only typedefs
and macros all over the place.

Sorry.

> Bazsi

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--uqlJfHshKOiOfK6d
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9CzlBXaXGVTD0i/8RAhqKAKCkGlkx+eySZml8kOxj4thnhx8/QwCfUAzQ
vVab1RHGGl/NqJ8teEmLyNs=
=oiDG
-----END PGP SIGNATURE-----

--uqlJfHshKOiOfK6d--
