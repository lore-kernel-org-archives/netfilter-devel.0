From: Nigel Kukard <nkukard@lbsd.net>
Subject: [nkukard@lbsd.net: Re: Experimental RTSP modules]
Date: Sat, 24 May 2003 09:40:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030524074054.GB14062@lbsd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >  * IPv6 modules
>=20
> ipv6 is not supported by conntrack or NAT, so I guess that's going to be
> hard to support :)  This is has been discussed quite a number of times
> on the devel list.
>=20
> > Hints for implementing IPv6 conntrack and nat modules especially apprec=
iated
> > (why are there no IRC or FTP modules for IPv6?)
>=20

hrmmm... what is missing in supporting IPv6? Ok, I've read most of the posts
about code duplication if you copied IPv4 and modified it to support IPv6,
changing all the function names along the way. Maybe we should have a=20
discussion about how to move forward? What needs to be done, planning ...=
=20
etc to integrate the IPv4 and new IPv6 conntrack into 1 easy to use interfa=
ce.

I would be more than happy to lend a few of my developers to help with IPv6=
=20
support. Most of our work revolves around networking under linux, and we
are busy moving over to IPv6, so it will help every1.


Regards
Nigel





--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zyIGKoUGSidwLE4RAr4wAKCf2r5/Qe/pKLgMxh5zc/KS/fhegQCdEGdU
hjhxzk9ygB1A2yOIAF8Pdgs=
=uE6x
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
