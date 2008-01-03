From: Eric Leblond <eric@inl.fr>
Subject: Ulogd2: code cleaning
Date: Fri, 04 Jan 2008 00:45:21 +0100
Message-ID: <1199403921.16528.24.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dxtRAEJXy7A05+hAhkEb"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:56939 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYACXpX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:45:23 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=[192.168.1.2])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JAZkY-0002iM-EA
	for netfilter-devel@vger.kernel.org; Fri, 04 Jan 2008 00:45:22 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-dxtRAEJXy7A05+hAhkEb
Content-Type: multipart/mixed; boundary="=-L0f8yVyCOYlCmNA4R9MY"


--=-L0f8yVyCOYlCmNA4R9MY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

This patch adds an enum to get rid of access to array via numerical
index in NFLOG input plugin.

This replaces code like:
	ret[0].flags |=3D ULOGD_RETF_VALID;
	ret[11].u.value.ui16 =3D ntohs(hw->hw_addrlen);

with:
	ret[NFLOG_KEY_RAW_MAC].flags |=3D ULOGD_RETF_VALID;
	ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =3D ntohs(hw->hw_addrlen);
which is more readable.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-L0f8yVyCOYlCmNA4R9MY
Content-Disposition: attachment; filename=ulogd2-add-enum-to-clarify-code.diff
Content-Type: text/x-patch; name=ulogd2-add-enum-to-clarify-code.diff;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

DQpQcm9wZXJ0eSBjaGFuZ2VzIG9uOiANCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCk5hbWU6IHN2azptZXJnZQ0KICsw
YjU3YWUyMS01MGU4LTczNmYtNTQwNi02ZDZiZjJjZTQyNWE6L2JyYW5jaGVzL3Vsb2cvdWxvZ2Qy
OjcxNjUNCiAgZWY1MzdhMTMtMDQwNi00YWQ1LWFlZmQtMGRlN2YyMjc5NTBmOi9sb2NhbC91bG9n
ZDItaW5sOjQ5MDgNCg0K


--=-L0f8yVyCOYlCmNA4R9MY--

--=-dxtRAEJXy7A05+hAhkEb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfXORnxA7CdMWjzIRAgwRAJ9F/J0xSeaFcaHQFLc5fJaftYCK4wCfc/FG
r5REQ8KQChzFzfdeHV3w8Do=
=zdov
-----END PGP SIGNATURE-----

--=-dxtRAEJXy7A05+hAhkEb--

