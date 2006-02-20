From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] disallow multiple matches of same type
Date: Mon, 20 Feb 2006 19:49:50 +0100
Message-ID: <20060220184949.GS5288@sunbeam.de.gnumonks.org>
References: <20060220055421.GA10552@linuxace.com> <43F9FE8E.5050607@trash.net>
	<20060220183122.GA17077@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHTUIiWqaPwZ9IpM"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20060220183122.GA17077@linuxace.com>
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


--xHTUIiWqaPwZ9IpM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2006 at 10:31:22AM -0800, Phil Oester wrote:
> On Mon, Feb 20, 2006 at 06:38:22PM +0100, Patrick McHardy wrote:
> > I think Harald already did something in this direction. Harald?
>=20
> He corrected it so iptables didn't segfault, and opened a new bug
> for the incorrect behaviour.  This fixes that new bug.

that's correct. Haven't reviewed your bugfix yet, though.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xHTUIiWqaPwZ9IpM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD+g9NXaXGVTD0i/8RAmhMAJ4hrNxqeEH/THFOmwsQU6jWsrrqbgCgjsBI
gWr5OjzQ6FZr8al7pmdoYkw=
=JeNi
-----END PGP SIGNATURE-----

--xHTUIiWqaPwZ9IpM--
