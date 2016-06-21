From: Ben Hutchings <ben@decadent.org.uk>
Subject: [stable] netfilter fixes for CVE-2016-3134
Date: Wed, 22 Jun 2016 00:41:11 +0100
Message-ID: <1466552471.27155.238.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DmlHUumtcbJjKyMT6EAz"
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: stable <stable@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbcFUXlO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2016 19:41:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-DmlHUumtcbJjKyMT6EAz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please cherry-pick these for all branches older than 4.6:

commit bdf533de6968e9686df777dc178486f600c6e617
Author: Florian Westphal
<fw@strlen.de>
Date:=C2=A0=C2=A0=C2=A0Tue Mar 22 18:02:49 2016 +0100

=C2=A0=C2=A0=C2=A0=C2=A0netfilter: x_tables: validate e->target_offset earl=
y

commit 6e94e0cfb0887e4013b3b930fa6ab1fe6bb6ba91
Author: Florian Westphal <fw@strlen.de>
Date:=C2=A0=C2=A0=C2=A0Tue Mar 22 18:02:50 2016 +0100

=C2=A0=C2=A0=C2=A0=C2=A0netfilter: x_tables: make sure e->next_offset cover=
s remaining blob size

commit 54d83fc74aa9ec72794373cb47432c5f7fb1a309
Author: Florian Westphal <fw@strlen.de>
Date:=C2=A0=C2=A0=C2=A0Tue Mar 22 18:02:52 2016 +0100

=C2=A0=C2=A0=C2=A0=C2=A0netfilter: x_tables: fix unconditional helper

Ben.

--=C2=A0

Ben Hutchings
Nothing is ever a complete failure; it can always serve as a bad
example.

--=-DmlHUumtcbJjKyMT6EAz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXadCXAAoJEOe/yOyVhhEJwKUP/1qxFWQ5HkYLljJAIpLIDUkp
CUSRTpbXdnWlaD9PHqQe31EriNmfGxTlFG0v7pJWa9Z1Ikn6fgD1fmxk9j36Nz+Z
M34PwKRvoTRPGtu8s3iC1kvY8uMw5NQsUOJVvKLXXJB43/0J7xMeTOGrhbgD+IDw
VQNq4qz5J0WHGlbqsYV64bRVeUgY5K71ADKafyQxmQ4QSno3P9lZaBwjjqbE8f9J
1NffrxTi93Fek861lR7gE/mMQPLVyJdx2qHsVj+YW/dYEe/IYRHOESlnBnfdrFmW
P+W6luvJPObGJ692UGqdRgb/lPzpVr9mqh/sSxMu4tTTJVGv7Iz0w3mq+jShniCa
IH8xxv6i4BhmKu7FENf0TFvnXFkX5Jy1L54oz8j7dNd0TlIuST37FGwsS4dQg3lU
5A6/CyUdLyRZ1lIJf9h4N8n+LCrZ+09Y7hpmBilIk2PMhPRtQdNLEqqYvIShC/Sv
5UEzNsEp1gpMjF+t+zQLcvmpV4916L0Q+PMUruNvd6eaJkbPqAaUymk/UrVL+qif
4rE4a+iSYC6jazK6yfz9Z6o4vZQSALep9TWCp30QM3ojQtP4AQcuDlmCnf7EVzBX
/B04WWl96cEiv0nK/NLVljY54YJVTPo2R7RQK20n13+j69OLm148wtRI3TRDU0nD
doXfJvo53lmT9zyyqaD5
=2+8H
-----END PGP SIGNATURE-----

--=-DmlHUumtcbJjKyMT6EAz--
