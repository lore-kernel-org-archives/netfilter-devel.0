From: Eric Leblond <eric@inl.fr>
Subject: Ulogd2: fix autogen.sh
Date: Thu, 03 Jan 2008 14:22:35 +0100
Message-ID: <1199366555.11916.2.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xxvd2j1O7Qg21FZ54S8o"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:51179 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYACNWg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:22:36 -0500
Received: from khasse.inl.fr ([192.168.33.139])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JAQ1r-0004uu-AF
	for netfilter-devel@vger.kernel.org; Thu, 03 Jan 2008 14:22:35 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-xxvd2j1O7Qg21FZ54S8o
Content-Type: multipart/mixed; boundary="=-Jtc8YcXiuLS4OobcnElM"


--=-Jtc8YcXiuLS4OobcnElM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

This small patch adds a call to autoheader which is needed to compile
ulogd2 from subversion.

By the way, it could be nice to do a call to:
 svn rm aclocal.m4
which should not in subversion.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 40, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-Jtc8YcXiuLS4OobcnElM
Content-Disposition: attachment; filename=ulogd-autoheader-call.diff
Content-Type: text/x-patch; name=ulogd-autoheader-call.diff; charset=UTF-8
Content-Transfer-Encoding: base64

PT09IGF1dG9nZW4uc2gNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGF1dG9nZW4uc2gJKHJldmlzaW9uIDQ4Nzcp
DQorKysgYXV0b2dlbi5zaAkocmV2aXNpb24gNDg3OCkNCkBAIC0xLDYgKzEsNyBAQA0KICMhL2Jp
bi9zaA0KIA0KIGFjbG9jYWwNCithdXRvaGVhZGVyDQogbGlidG9vbGl6ZSAtYyAtLWZvcmNlIA0K
IGF1dG9tYWtlIC1jIC0tYWRkLW1pc3NpbmcNCiBhdXRvY29uZg0K


--=-Jtc8YcXiuLS4OobcnElM--

--=-xxvd2j1O7Qg21FZ54S8o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfOGbnxA7CdMWjzIRArG6AJ0a3N3bYRTXQp6G9ypL9Qx9paZPGwCdHsBj
Sy469S8Z6qtdA6wFfd3vhbQ=
=P2VP
-----END PGP SIGNATURE-----

--=-xxvd2j1O7Qg21FZ54S8o--

