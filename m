From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/4] Fix light memory error in parse_mac2str
Date: Wed, 10 Dec 2008 12:01:28 +0100
Message-ID: <1228906888.2872.22.camel@khasse.inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
	 <1228135316-12578-3-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0GqhgxVFKrgDvgh/ZQOq"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:41811 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYLJLBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:01:37 -0500
In-Reply-To: <1228135316-12578-3-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-0GqhgxVFKrgDvgh/ZQOq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 01 d=C3=A9cembre 2008 =C3=A0 13:41 +0100, Pierre Chifflier a =C3=
=A9crit :
> When len is 0 (for ex. when the input mac is NULL), parse_mac2str tries
> to calloc a 0-bytes bloc, which leads to a conditional jump based
> on uninitialized value (spotted by valgrind).
>=20

Applied, thanks.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-0GqhgxVFKrgDvgh/ZQOq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/oYQACgkQnxA7CdMWjzJ55QCeIX4uRpTiWNrz2Eq1gxyjJNXp
IewAn0hUcIP58mnmlD/XjzZ9TD+Gc4fG
=X3jZ
-----END PGP SIGNATURE-----

--=-0GqhgxVFKrgDvgh/ZQOq--

