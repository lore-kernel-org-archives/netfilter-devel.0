From: Eric Leblond <eric@inl.fr>
Subject: Re: ENOBUF error during recv
Date: Fri, 09 Jan 2009 23:09:25 +0100
Message-ID: <1231538965.30864.6.camel@ice-age>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr>
	 <200901091454.45485.ryan.vanriper@adventiumlabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XZFRuYy3aJskQyLaOS9+"
Cc: netfilter-devel@vger.kernel.org
To: ryan.vanriper@adventiumlabs.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:43620 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZAIWJa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:09:30 -0500
In-Reply-To: <200901091454.45485.ryan.vanriper@adventiumlabs.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-XZFRuYy3aJskQyLaOS9+
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,
Le vendredi 09 janvier 2009 =E0 14:54 -0600, Ryan VanRiper a =E9crit :
> I am using the nfqnl_test.c program and noticed that under network load (=
ie.=20
> sending a 20meg text file) the while loop doing the recv in main() fails =
and=20
> after some debugging returns a perror of ENOBUFF (105) ?
>=20
> Any ideas why this would happen ?
>=20
> I using centos 5.2 i386 32bit, and 2.6.18 kernel.

This question has been answer during the last 15 days, please check the
archive before asking:
http://marc.info/?l=3Dnetfilter-devel&m=3D123099679021495&w=3D2

The nfnetlink buffer is full. For production system, you can increase it
with=20
	nfnl_rcvbufsiz(nfq_nfnlh(h), SIZE);

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-XZFRuYy3aJskQyLaOS9+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJZ8sSnxA7CdMWjzIRAsGJAJsGG7RupWH0dkckDXfP1Od6q7+0oACfVQVN
g+x5s3yNogDPHgbCnOc0eFc=
=3yHB
-----END PGP SIGNATURE-----

--=-XZFRuYy3aJskQyLaOS9+--

