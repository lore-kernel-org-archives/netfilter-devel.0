From: Harald Welte <laforge@netfilter.org>
Subject: Re: connlimit error?
Date: Sun, 10 Apr 2005 22:52:39 +0200
Message-ID: <20050410205239.GW9155@sunbeam.de.gnumonks.org>
References: <1112710072.30219.3.camel@sas>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KiAQxGMWqEV9jhSy"
Cc: netfilter-devel@lists.netfilter.org, kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wojciech 'Sas' Ci?ciwa <cieciwa@dzp.ntt.com.pl>
Content-Disposition: inline
In-Reply-To: <1112710072.30219.3.camel@sas>
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


--KiAQxGMWqEV9jhSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05, 2005 at 04:07:52PM +0200, Wojciech 'Sas' Ci?ciwa wrote:
> In connlimit module for 2.6.11 in line 74 is:
> [..]
> [74]                    found !=3D NULL && ct =3D tuplehash_to_ctrack(fou=
nd)
> &&
> [..]
> in my kernel 2.6.11.6 with some patches it can't compile
> return error:
> router:~/rpm/BUILD/linux-2.6.11.6%make SUBDIRS=3Dnet/ipv4/netfilter
>   CC [M]  net/ipv4/netfilter/ipt_connlimit.o
> net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
> net/ipv4/netfilter/ipt_connlimit.c:75: error: invalid lvalue in
> assignment
> make[1]: *** [net/ipv4/netfilter/ipt_connlimit.o] Error 1
> make: *** [_module_net/ipv4/netfilter] Error 2
>=20
> when I removed "ct =3D tuplehash_to_ctrack(found)"
> like in linux-2.6 module all looks OK.
>=20
> Can anyone looking on this ?

should be fixed now. =20

btw: preferred way for a bug report is via https://bugzilla.netfilter.org

> Thanx.
> 					Sas.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KiAQxGMWqEV9jhSy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZIXXaXGVTD0i/8RAvYeAJsF59KOVjcVsivhcRNTPSpsOvlUzACfXV2b
o5/qpFmH9RPLxBjCJof92ww=
=bMQe
-----END PGP SIGNATURE-----

--KiAQxGMWqEV9jhSy--
