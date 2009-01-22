From: Eric Leblond <eric@inl.fr>
Subject: Re: Ulogd patch series
Date: Thu, 22 Jan 2009 14:16:16 +0100
Message-ID: <1232630176.27232.2.camel@khasse.inl.fr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vLGu4++Dn+Y3VUGCR507"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55081 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAVNQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:16:18 -0500
In-Reply-To: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-vLGu4++Dn+Y3VUGCR507
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 20 janvier 2009 =C3=A0 12:16 +0100, Jan Engelhardt a =C3=A9crit :
> Hi,
>=20
>=20
> here are a bunch of patches that seemed to come in handy whilst=20
> packaging ulogd as rpm.
>=20
> Please pull from
> 	git://dev.medozas.de/ulogd master
>=20
> to recieve:
> Jan Engelhardt (5):
>       build: compile fix

This one seems to be linked with your distro but the fix is harmless so
I've applied it.

>       Update .gitignore and remove install-sh
>       build: use -avoid-version for modules
>       build: resolve autotools suggestions to use AC_CONFIG_MACRO_DIR
>       build: update configure.ac
>=20
>=20
> Patches will be posted for review as replies.

All applied.

Thanks Jan.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-vLGu4++Dn+Y3VUGCR507
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl4cZ0ACgkQnxA7CdMWjzJWxACfZL32l7aWKiXmuv0UKV9EHDt3
4bgAn3EpKT+P/OPewMHwDO45nnYOWKfM
=3jDp
-----END PGP SIGNATURE-----

--=-vLGu4++Dn+Y3VUGCR507--

