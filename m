From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix grammar error in manpage
Date: Tue, 1 Apr 2014 17:46:34 +0700
Message-ID: <20140401104634.GB2110@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45610 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaDAKqk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:46:40 -0400
Received: by mail-pb0-f45.google.com with SMTP id uo5so9672248pbc.32
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Apr 2014 03:46:40 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Refer to: https://bugs.launchpad.net/ubuntu/+source/lintian/+bug/608231

The "allows to" is a common grammar error which it will probably be replaced
by "allows one to" as a suggestion in above bug report page.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 src/ipset.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 6c9a0f5..6d272db 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -905,7 +905,7 @@ The protocol family of the IP addresses to be stored in=
 the set. The default is
 \fBinet\fR, i.e IPv4.
 .TP
 \fBmarkmask\fR \fIvalue\fR
-Allows to set bits you are interested in the packet mark. This values is t=
hen used to perform bitwise AND operation for every mark added.
+Allows you to set bits you are interested in the packet mark. This values =
is then used to perform bitwise AND operation for every mark added.
 markmask can be any value between 1 and 4294967295, by default all 32 bits=
 are set.
 .TP
 \fBhashsize\fR \fIvalue\fR
--=20
1.9.1


--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTOpkKAAoJEJ0EcL2mzcRXkCwQALrxHeeijcbxJCvb0mQphx9v
nwObTc7AbOXRwRytxLEVJH0xq7XIGNen8ghkhwLYD93LtMtXFHankFdF7RIDkK19
GyyIPAv40gHla6yRspm/q5LX4nIdpLS7n2J6UUlQZ5o29cK6RtFKn9TWl1qZLojg
szJFZC6NWmnSXWWOraWNnqzZIw4Wa130NqBg8Eiog1Sagd/tGM2PNjlO1s9VLft1
IXRiW6dNYSteyylviPXsYLFO8p+ze9Ol4daQsLf5uOyWpX7TDdyrDDylHfPyB/T9
1XwCxIrZRytqo6RQnNdYdR6Y//Tq1udvB+Joybt2LeX4swyUJYL71367YrMC4BhH
Mwvxc2YV/ZdSBnzd1QqVnHrHdOS45sLWIsMwRVmlj7BaVXjy05VKHPD0uxb3tM/v
V9hFovSZ1lDK9a/tBIHponAT0EHco01sIRLy/JkMhDT7YbjmnxkZXd/FM9BAN6PN
qrrSzJNzHPiWK7kICCdMfwMochxD7GWw86U0carTP8hGOJ4gaL/W7CIGqbnBTpJf
CCyT7mUKghPVV5hsP7j2h0EdKqHZQcDNAN8dOm10VOPz7N8aVlzvXqp6bUbxrgeW
O/LaZaa11twtGQ9qu/gkAstIeZdQovIxvht6RrKQtbVVopRSPuBOtRZDioAGqe/1
pMQYM3VrT1FNINaNCUFz
=LiJy
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
