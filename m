From: Harald Welte <laforge@netfilter.org>
Subject: Re: connlimit error?
Date: Sun, 10 Apr 2005 22:55:44 +0200
Message-ID: <20050410205544.GX9155@sunbeam.de.gnumonks.org>
References: <1112710072.30219.3.camel@sas>
	<Pine.LNX.4.61.0504051612120.19152@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VnWlMppcSjFk8Aqi"
Cc: kraxel@bytesex.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0504051612120.19152@filer.marasystems.com>
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


--VnWlMppcSjFk8Aqi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05, 2005 at 04:13:41PM +0200, Henrik Nordstrom wrote:
> On Tue, 5 Apr 2005, Wojciech 'Sas' [iso-8859-2] Ci=EAciwa wrote:
>=20
> >In connlimit module for 2.6.11 in line 74 is:
> >[..]
> >[74]                    found !=3D NULL && ct =3D tuplehash_to_ctrack(fo=
und)
> >&&
>=20
> If I am not mistaken that =3D should be a =3D=3D

No, actually not.  two lines above "struct ip_conntrack *ct =3D NULL".

The whole purpose of this segment is to check for 'found' and if there
is one, resolve 'ct' based on found and do some further checks.  I've
added the missing parenthesis in svn now.

[yes, bad programming style, but I didn't want to change more than
absolutely required between 2.6.10 and 2.6.11 versions]
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VnWlMppcSjFk8Aqi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZLQXaXGVTD0i/8RAgTIAKCcJgrfWw94wYwvpfBXm4DTS2TjbACeJeWX
1zI8BDky9O5myLrCPJTxUxg=
=BPFw
-----END PGP SIGNATURE-----

--VnWlMppcSjFk8Aqi--
