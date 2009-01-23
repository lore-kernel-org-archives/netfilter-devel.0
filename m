From: Eric Leblond <eric@inl.fr>
Subject: Re: Is the libnetfilter_queue thread-safe?
Date: Fri, 23 Jan 2009 08:35:25 +0100
Message-ID: <1232696125.22893.5.camel@ice-age>
References: <web-4707182@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-x6ErBJHlDAYxltTwdFtl"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jacky Luk <jacky.luk@primecreation.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:32958 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZAWHfd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:35:33 -0500
In-Reply-To: <web-4707182@mail.primecreation.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-x6ErBJHlDAYxltTwdFtl
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 23 janvier 2009 =E0 12:02 +0800, Jacky Luk a =E9crit :
> Hi,
>=20
> I would like to ask a question about the=20
> libnetfilter_queue. Is the libnetfilter_queue thread-safe?=20

Is had yet to be decide :/ From my experience on NuFW, you can use it
with multithreaded programs and you can have a reading thread and a
writing thread working together on the same queue.

> Would the API of libnetfilter_queue cause the kernel crash=20
> under multi-threading environment?

Clearly not, the worse that can happen is an application crash not a
kernel crash.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-x6ErBJHlDAYxltTwdFtl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJeXM6nxA7CdMWjzIRAproAKCPomDxQhyb7b3K0MyD0IiAihvPfACgjCZ0
veLfkUoV1Xwcarap/ji0Vsk=
=d8j6
-----END PGP SIGNATURE-----

--=-x6ErBJHlDAYxltTwdFtl--

