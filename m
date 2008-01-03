From: Eric Leblond <eric@inl.fr>
Subject: Ulogd2: add missing section in configuration file
Date: Thu, 03 Jan 2008 14:27:38 +0100
Message-ID: <1199366858.11916.10.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o1Vy/YdTqC3qCfV0x9KB"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:57506 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYACN1j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:27:39 -0500
Received: from khasse.inl.fr ([192.168.33.139])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JAQ6k-00053d-At
	for netfilter-devel@vger.kernel.org; Thu, 03 Jan 2008 14:27:38 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-o1Vy/YdTqC3qCfV0x9KB
Content-Type: multipart/mixed; boundary="=-SwlX1g39yO1xUvCyOKaE"


--=-SwlX1g39yO1xUvCyOKaE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

This patch adds an empty section which is needed to have NFCT logging
working.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 40, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-SwlX1g39yO1xUvCyOKaE
Content-Disposition: attachment; filename=ulogd2-add-nfct-section.diff
Content-Type: text/x-patch; name=ulogd2-add-nfct-section.diff; charset=UTF-8
Content-Transfer-Encoding: base64

PT09IHVsb2dkLmNvbmYuaW4NCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIHVsb2dkLmNvbmYuaW4JKHJldmlzaW9u
IDQ4ODIpDQorKysgdWxvZ2QuY29uZi5pbgkocmV2aXNpb24gNDg4MykNCkBAIC01MCw2ICs1MCw4
IEBADQogIyB0aGlzIGlzIGEgc3RhY2sgZm9yIGZsb3ctYmFzZWQgbG9nZ2luZyB2aWEgT1BSSU5U
DQogI3N0YWNrPWN0MTpORkNULG9wMTpPUFJJTlQNCiANCitbY3QxXQ0KKw0KIFtsb2cxXQ0KICMg
bmV0bGluayBtdWx0aWNhc3QgZ3JvdXAgKHRoZSBzYW1lIGFzIHRoZSBpcHRhYmxlcyAtLXVsb2ct
bmxncm91cCBwYXJhbSkNCiBncm91cD0wDQo=


--=-SwlX1g39yO1xUvCyOKaE--

--=-o1Vy/YdTqC3qCfV0x9KB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfOLKnxA7CdMWjzIRAoDYAJ4n/eouMf/JAPPJwMT2SOCotzWdGgCaAwb0
+STVCYlV8TxXIlSoldBQw/A=
=fCrF
-----END PGP SIGNATURE-----

--=-o1Vy/YdTqC3qCfV0x9KB--

