From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: Will the PPTP patch compile with kernel 2.6.14?
Date: Thu, 22 Sep 2005 23:38:04 +0200
Message-ID: <20050922213803.GA6249@zion.homelinux.com>
References: <365871C49598504A9481DDBEC3EB49551232E2@MAIL.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Content-Disposition: inline
In-Reply-To: <365871C49598504A9481DDBEC3EB49551232E2@MAIL.InfraSupportEtc.com>
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


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Greg,

On Thu, Sep 22, 2005 at 01:43:34PM -0500, Greg Scott told us:
> Curious minds want to know - with the recent problems compiling the PPTP
> patch with 2.6.11, 12, and .13 and the work documented in the Sept.
> archives in this list - will the PPTP patch work wth kernel 2.6.14 when
> the stable version hits the streets?  (According to kernel.org, 2.6.14
> is at RC2 right now.)

you mean the pptp conntrack + NAT helper??
Harald has submitted it for inclusion into 2.6.14 a few days ago:
http://www.kernel.org/git/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D926b50f92a30090da2c1a8675de954c2d9b09732


have a nice day

Sven

>=20
> Thanks
>=20
> - Greg Scott
>=20
>=20

--=20
Linux zion.homelinux.com 2.6.14-rc2-mm1_6 #6 Thu Sep 22 13:08:16 CEST 2005 =
i686 athlon i386 GNU/Linux
 23:32:29 up  1:04,  1 user,  load average: 0.43, 0.28, 0.11

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMyQ7o4FAdB2PneQRAjIyAJ4nHzfFIw2CdNdv89AcZO+a/Tb6KgCeOrbC
TDJvRhcQROswNBfSRYdFTVs=
=6f8z
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
