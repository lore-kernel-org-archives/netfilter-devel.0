From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
	[nf|ct]netlink and event API]
Date: Tue, 12 Jul 2005 09:55:38 +0200
Message-ID: <20050712075538.GQ16728@sunbeam.de.gnumonks.org>
References: <20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net> <42C426B2.6030907@eurodev.net>
	<42D29EC0.9050707@ufomechanic.net>
	<20050711171023.GG16728@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0507111943150.32325@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P9SDCAjI7+EA+Yxm"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507111943150.32325@yvahk01.tjqt.qr>
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


--P9SDCAjI7+EA+Yxm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2005 at 07:45:17PM +0200, Jan Engelhardt wrote:
>=20
> >nf_conntrack goes the way to layer-3-independent connection tracking.
> >However, conntrack will remain to happen at layer3 and 4 (with minor
> >exceptions to higher layers in the case of conntrack helpers).
>=20
> Minor? Hehe that's good :p Reminds me of l7-filter.sf.net
> (It's not even a helper as in ip_conntrack_irc, but a match module)

exactly, it's an iptables match module and therefore not related to
nf_conntrack or ip_conntrack.  And there is a reason I don't like the
idea of pushing it into mainline...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--P9SDCAjI7+EA+Yxm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC03d6XaXGVTD0i/8RAjmJAJ9SnIR+EvLcD9CoQCHqW0HQ3gdBfQCfR2gK
iURWgJX48VSS4rARdxauXOw=
=Spuq
-----END PGP SIGNATURE-----

--P9SDCAjI7+EA+Yxm--
