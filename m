From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] RFC: fast string matching infrastrure for netfilter
Date: Mon, 10 Jan 2005 11:06:24 +0100
Message-ID: <20050110100624.GQ18568@sunbeam.de.gnumonks.org>
References: <41E1AECD.6020209@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zBPbvmIlJjvpbu6L"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41E1AECD.6020209@eurodev.net>
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


--zBPbvmIlJjvpbu6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 09, 2005 at 11:23:09PM +0100, Pablo Neira wrote:
> Hi,
>=20
> I've finished a first usable version of a infrastructure to look for=20
> matchings in a packet. Features:
>=20
> * A library consisting in three public functions: constructor,=20
> destructor and searching.

you are aware that I was working on exactly the same thing, based on
in-kernel libqsearch by Phillipe Biondi? ;)

One of my major changes to the original libqsearch was to move
allocation from callee-based allocation to caller-based allocation.

This way we avoid too many dynamically kmalloc-allocated structures, and
a caller (for example a conntrack helper) can allocate the search
context as part of a different structure.

I haven't finished those patches, but I'll try to clean them up until
tomorrow, so we can have a discussion and maybe merge the good ideas of
both.

> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zBPbvmIlJjvpbu6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB4lOgXaXGVTD0i/8RAjIFAJ9+A411M2n+eVF/ALTJi8bxxuZ6cQCfWJeJ
ZQT7Lu16MK1kQEeVDXQNaNY=
=PDbo
-----END PGP SIGNATURE-----

--zBPbvmIlJjvpbu6L--
