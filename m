From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Sun, 10 Apr 2005 22:45:42 +0200
Message-ID: <20050410204542.GT9155@sunbeam.de.gnumonks.org>
References: <424747D5.8060500@eurodev.net> <42502B1B.7090309@trash.net>
	<42540839.8020405@ufomechanic.net> <4254265F.6080607@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rOjEwMPcOTyw+8kE"
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <4254265F.6080607@eurodev.net>
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


--rOjEwMPcOTyw+8kE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 06, 2005 at 08:11:43PM +0200, Pablo Neira wrote:
> Amin Azez wrote:
> >It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) requi=
res=20
> >ct-event (although this is not listed in the pom-ng dependancies).
> >Pablo, can you confirm this?
>=20
> I've just merged Harald's and my port. You can get it from:
>=20
> http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.1=
1/

do you mind creating a patch against svn so we can put it into
nfnetlink-ctnetlink/linux-2.6.11 ?

thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rOjEwMPcOTyw+8kE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZB2XaXGVTD0i/8RAnc/AJ90UJvvPx/kbl7At1PoqfIgy0kXsACfff7i
pgrHbvIOKnDY4th4ssjHkG0=
=9Mvx
-----END PGP SIGNATURE-----

--rOjEwMPcOTyw+8kE--
