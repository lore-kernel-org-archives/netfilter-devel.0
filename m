From: "Christoph A." <casmls@gmail.com>
Subject: Re: building nftables: =?windows-1252?Q?=91nfnl=5Fnft=5Fset=5Fin?=
 =?windows-1252?Q?it=92_undeclared?=
Date: Sun, 19 Jul 2009 18:32:11 +0200
Message-ID: <4A634A8B.3040003@gmail.com>
References: <4A61B7DD.9050201@gmail.com> <alpine.LSU.2.00.0907181853420.4742@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig06210FD98B7BBC8DA6962B1A"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	"Christoph A." <casmls@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:59666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbZGSQe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:34:27 -0400
Received: by fg-out-1718.google.com with SMTP id e12so383907fga.17
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Jul 2009 09:34:26 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0907181853420.4742@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06210FD98B7BBC8DA6962B1A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 18.07.2009 18:54, schrieb Jan Engelhardt:
> On Saturday 2009-07-18 13:54, Christoph A. wrote:
>> Hi!
>>
>> I'm building a enviroment where I can paly around with nftables.
>>
>> Building libnl-nft I encountered the same problem as described here:
>>
>> http://osdir.com/ml/general/2009-04/msg03933.html
>=20
> nfnl_nftset_init was removed in=20
> 0917b23733f46c65703545f82cc633836436f13b. nftables was not updated=20
> (yet).
>=20
> The combination of libnl-nft--9e3c81f64856ac0068f63f4d2b8f97c5f091e2e8 =
+=20
> nftables-414fa58ae9f283c35c8510fc31f28ba77bb5fdf5
> compiles through though.

After resolving the missing limits.h [1], the too new bison version [2]
and the configure script telling me that my malloc() version is not GNU
compatible, compiling was successfull.

[1] http://osdir.com/ml/catch/2009-03/msg04455.html
[2] http://markmail.org/message/xfay3mxmz4my4rog

thank you and thanks to orb (from #netfilter)

best regards
Christoph



--------------enig06210FD98B7BBC8DA6962B1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkpjSqoACgkQrq+riTAIEg0zlwCfe3cD9C8ddRzp3rMrf9+60UQc
x5sAnRvMvAYYTOh/GbiqkTAlOVkPsJJx
=AJPw
-----END PGP SIGNATURE-----

--------------enig06210FD98B7BBC8DA6962B1A--
