From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix ip_conntrack_helper_pptp build when
	CONFIG_IP_NF_NAT_NEEDED=n
Date: Thu, 3 Nov 2005 18:46:31 +0100
Message-ID: <20051103174631.GE905@sunbeam.de.gnumonks.org>
References: <1130807635.6630.13.camel@localhost>
	<20051103095409.GY4479@sunbeam.de.gnumonks.org>
	<1131035393.6600.118.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
Cc: netfilter-devel@lists.netfilter.org, 336431@bugs.debian.org,
	control@bugs.debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dann frazier <dannf@hp.com>
Content-Disposition: inline
In-Reply-To: <1131035393.6600.118.camel@localhost>
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


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2005 at 09:29:53AM -0700, dann frazier wrote:
> tags 336431 + upstream
> tags 336431 + patch
> stop
>=20
> On Thu, 2005-11-03 at 10:54 +0100, Harald Welte wrote:
> > On Mon, Oct 31, 2005 at 06:13:55PM -0700, dann frazier wrote:
> > > As reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D336=
431,
> > > ip_conntrack_helper_pptp in 2.6.14 fails to build if
> > > CONFIG_IP_NF_NAT_NEEDED isn't enabled.  This patch fixes this by
> > > disabling manipulation of the dir field of ip_conntrack_expect
> > > structures when full nat isn't configured.  Compile tested only.
> >=20
> > Thanks for reporting this bug.   Yasuyuki Kozakai has submitted a
> > slightly cleaner version, so I'm merging his patch.
>=20
> Thanks for the response Harald.
>=20
> Looks like this is the patch we should use:
>   http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D2991

no, it's=20

http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3001

sorry for the confusion.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDakz3XaXGVTD0i/8RApBgAKCa+dVLyt+Y1B4ffNoAeT2Sx6BgBgCbBIXQ
OqZP4GxuNwWRErt2JDCPxik=
=EypX
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
