From: Eric Leblond <eric@regit.org>
Subject: Re: [Ulogd PATCH 0/4] Implement filter for NFCT
Date: Sat, 05 Jan 2013 10:57:29 +0100
Message-ID: <1357379849.14581.2.camel@tiger2>
References: <1356715802-11572-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Yg3id3JMQ54FRpE3+sC7"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44784 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3AEJ6L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:58:11 -0500
Received: from ip-37-24-162-232.unitymediagroup.de ([37.24.162.232] helo=[192.168.0.110])
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1TrQW1-0006NS-2F
	for netfilter-devel@vger.kernel.org; Sat, 05 Jan 2013 10:58:09 +0100
In-Reply-To: <1356715802-11572-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Yg3id3JMQ54FRpE3+sC7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2012-12-28 at 18:29 +0100, Eric Leblond wrote:
> Hello,
>=20
> This patchset implements filtering capability in NFCT input plugin. For
> now this is only possible when NFCT is used in event mode as the
> libnetfilter_conntrack library does not support filtering of dump.

Patches pushed to git tree.

BR,
--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

--=-Yg3id3JMQ54FRpE3+sC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlDn+QkACgkQnxA7CdMWjzLlmgCcC0TUtw25oUkILA7GSxX43le3
Hs0AoJAfPUKqHYrdKK5+u+Lt4WSzW6nq
=H+Ej
-----END PGP SIGNATURE-----

--=-Yg3id3JMQ54FRpE3+sC7--

