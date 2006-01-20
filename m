From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 14:07:44 +0100
Message-ID: <20060120130744.GH4603@sunbeam.de.gnumonks.org>
References: <20060120081151.GV4603@sunbeam.de.gnumonks.org>
	<200601200955.k0K9tSnM001413@toshiba.co.jp>
	<20060120112126.GB4603@sunbeam.de.gnumonks.org>
	<200601201150.k0KBoKM4002074@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0JXx0QNa4/JeB8y"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601201150.k0KBoKM4002074@toshiba.co.jp>
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


--z0JXx0QNa4/JeB8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2006 at 08:50:19PM +0900, Yasuyuki KOZAKAI wrote:

> Well, I don't want to do it. Only ESP header is special because it cannot=
 be
> skipped. On the other hand, AH is normal IPv6 extension header and can be
> skipped like others. Then 'ip6tables -p tcp -m ah ...' makes sense,
> for example.

ok, so the only thing 'missing' is the spi matching - a feature that
sounds cool but I doubt anyone is using anyway.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--z0JXx0QNa4/JeB8y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0OCgXaXGVTD0i/8RAsxcAJ4jgOocx/rPF7af+7YG1eFLjl5AEwCfT4mX
74lkK4neEy+lHGZd/9EjyH4=
=n4+4
-----END PGP SIGNATURE-----

--z0JXx0QNa4/JeB8y--
