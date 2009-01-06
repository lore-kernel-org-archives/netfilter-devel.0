From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 0/6] DB performance
Date: Wed, 07 Jan 2009 00:27:05 +0100
Message-ID: <1231284425.4137.5.camel@ice-age>
References: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-h/mGDzdYJypSXlbumdBs"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:49882 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZAFX1K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:27:10 -0500
In-Reply-To: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-h/mGDzdYJypSXlbumdBs
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 06 janvier 2009 =E0 23:31 +0100, Pierre Chifflier a =E9crit :
> This patchset aims to improve the DB performance with the following
> improvements:
>=20
> * Allow local (unix socket) connections to PostgreSQL database
> This one was spotted while profiling using callgrind, and noticing
> unexpected calls to SSL functions. Using a local connection improves
> speed a lot (by a factor 4 here).

Good news :)

All patches have been applied after having coding style fixed. Be
careful on that next time.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-h/mGDzdYJypSXlbumdBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD4DBQBJY+jGnxA7CdMWjzIRAj1IAJY0HwfBNv+mFB31meTHAljHCY1qAJ9vd1w3
m4hE6Xt30QMFZGaigtPMAQ==
=I8uz
-----END PGP SIGNATURE-----

--=-h/mGDzdYJypSXlbumdBs--

