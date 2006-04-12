From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH IP{,
	6}TABLES 0/4] fix loading icmpv6 module and minor changes
Date: Wed, 12 Apr 2006 12:43:18 +0200
Message-ID: <20060412104318.GS31616@sunbeam.de.gnumonks.org>
References: <200604071130.k37BUBa3009024@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D8QxnvyRlKGQJxl7"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200604071130.k37BUBa3009024@toshiba.co.jp>
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


--D8QxnvyRlKGQJxl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 07, 2006 at 08:30:11PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi,
>=20
> One patch fixes unusable icmpv6 because ip6tables doesn't try to load
> libip6t_icmpv6.so. Others are minor fixes/cleanup in ip{,6}tables.
>=20
> If no objection/miss, I'll commit them next weekend.

ah, ok. pleaes ignore my comment from a couple of minutes ago.  Please
commit at least simple fixes like this immediately in the future.=20

The changes are visible in the changelog (netfilter-cvslog mailinglist),
and if there really are any problems with a change, we can always fix
it incrementally.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--D8QxnvyRlKGQJxl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPNnGXaXGVTD0i/8RAtuHAJ4hfbptZv243TmecL6WSygN9iKjEwCeNQuK
QPQHf5dd7ZifbIYqsLnsST4=
=UPlv
-----END PGP SIGNATURE-----

--D8QxnvyRlKGQJxl7--
