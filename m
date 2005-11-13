From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Link netfilter before ipv4.
Date: Sun, 13 Nov 2005 15:18:56 +0100
Message-ID: <20051113141856.GS17476@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
	<200511130810.jAD8AhXT003387@toshiba.co.jp>
	<Pine.LNX.4.64.0511131420010.20769@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWOY2/vB4uO4FuME"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0511131420010.20769@bizon.gios.gov.pl>
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


--JWOY2/vB4uO4FuME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 02:27:41PM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Sun, 13 Nov 2005, Yasuyuki KOZAKAI wrote:
> <CUT>
> >Good catch! But that patch seems not to able to apply current tree becau=
se of
> >Hunk. Harald, could you apply attached patch instead ?
> Just tested with 2.6.15-rc1. No problem with attached version.
>=20
> >Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Why did you remove my Signed-off-by line?

I already indicated to yasuyuki that he should take care of this in the
future.

The patch in my tree (which will be submitted later today) has you
signed-off-line, don't worry :)


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JWOY2/vB4uO4FuME
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDd0tQXaXGVTD0i/8RAkJlAJ93DGedBmPL4if7zjA507EenuWwWACgmmER
+D1gpqrtA0ITbHmgxfw7NDw=
=UTGj
-----END PGP SIGNATURE-----

--JWOY2/vB4uO4FuME--
