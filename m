From: Harald Welte <laforge@gnumonks.org>
Subject: Re: /proc/net/ip_conntrack does not list all connections
Date: Thu, 5 Dec 2002 21:24:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205202422.GI11068@naboo.club.berlin.ccc.de>
References: <1038075353.86497.yihyung@so-net.net.tw> <3DE17053.1070500@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Op27XXJsWz80g3oF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3DE17053.1070500@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Op27XXJsWz80g3oF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2002 at 10:35:31AM +1000, Philip Craig wrote:
> yihyung wrote:
> > I made a patch to fix it for my 2.4.19 kernel.
>=20
> /proc/net/ip_masquerade has similar problems, as does
> /proc/net/ip_tables_names (although you will probably
> never have enough table names for that one to occur).
> I posted a patch for these a while ago:
>=20
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-February/006716=
.htm

thanks for pointing this out.  I simply missed it.  Please try pushing
this again as soon as you think something was missed.

I'll put it in the pending repository of pom now.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--Op27XXJsWz80g3oF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977X2XaXGVTD0i/8RAhlXAKCt6LswodlvRAbff4AToTQEVqhlqwCfQr5k
elfakLQCljMK2nT7vYV28bM=
=kJET
-----END PGP SIGNATURE-----

--Op27XXJsWz80g3oF--
