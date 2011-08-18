From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Parsing bug in libxt_conntrack.c 1.4.12
Date: Thu, 18 Aug 2011 15:11:16 -0700
Message-ID: <1313705476.819.29.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RWJg+8/mqre0EFTA/70z"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:41610 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1HRWSd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:18:33 -0400
Received: from [IPv6:2001:470:b:227:222:3fff:fef6:7c0e] (sami.shorewall.net [IPv6:2001:470:b:227:222:3fff:fef6:7c0e])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by lists.shorewall.net (Postfix) with ESMTPSA id 571F1F4A896
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2011 15:11:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-RWJg+8/mqre0EFTA/70z
Content-Type: multipart/mixed; boundary="=-DobsGO7NOdTgEWjjpYDh"


--=-DobsGO7NOdTgEWjjpYDh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just discovered this little gem:

sami:/home/teastep/iptables# iptables -N foo
sami:/home/teastep/iptables# iptables -A foo -m conntrack --ctorigdstport 2=
2
iptables v1.4.12: conntrack rev 2 does not support port ranges
Try `iptables -h' or 'iptables --help' for more information.
sami:/home/teastep/iptables#=20

The attached seems to correct it.

-Tom

--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--=-DobsGO7NOdTgEWjjpYDh
Content-Disposition: attachment; filename="commit-57c7c79"
Content-Type: text/plain; name="commit-57c7c79"; charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IDU3YzdjNzk5NTMyNmEzN2M5ODNhYzZjYTQwMjZlYjE3NjU5NWZiMzcNCkF1dGhvcjog
VG9tIEVhc3RlcCA8dGVhc3RlcEBzaG9yZXdhbGwubmV0Pg0KRGF0ZTogICBUaHUgQXVnIDE4IDE1
OjA5OjE0IDIwMTEgLTA3MDANCg0KICAgIENvcnJlY3QgcGFyc2luZyBidWcgaW4gbGlieHRfY29u
bnRyYWNrLmMNCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBUb20gRWFzdGVwIDx0ZWFzdGVwQHNo
b3Jld2FsbC5uZXQ+DQoNCmRpZmYgLS1naXQgYS9leHRlbnNpb25zL2xpYnh0X2Nvbm50cmFjay5j
IGIvZXh0ZW5zaW9ucy9saWJ4dF9jb25udHJhY2suYw0KaW5kZXggYmU5NTUyOS4uNmE3OWUzNyAx
MDA2NDQNCi0tLSBhL2V4dGVuc2lvbnMvbGlieHRfY29ubnRyYWNrLmMNCisrKyBiL2V4dGVuc2lv
bnMvbGlieHRfY29ubnRyYWNrLmMNCkBAIC0xMzAsMTMgKzEzMCwxMyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHh0X29wdGlvbl9lbnRyeSBjb25udHJhY2syX210X29wdHNbXSA9IHsNCiAJIC5mbGFn
cyA9IFhUT1BUX0lOVkVSVH0sDQogCXsubmFtZSA9ICJjdGV4cGlyZSIsIC5pZCA9IE9fQ1RFWFBJ
UkUsIC50eXBlID0gWFRUWVBFX1VJTlQzMlJDLA0KIAkgLmZsYWdzID0gWFRPUFRfSU5WRVJUfSwN
Ci0Jey5uYW1lID0gImN0b3JpZ3NyY3BvcnQiLCAuaWQgPSBPX0NUT1JJR1NSQ1BPUlQsIC50eXBl
ID0gWFRUWVBFX1BPUlQsDQorCXsubmFtZSA9ICJjdG9yaWdzcmNwb3J0IiwgLmlkID0gT19DVE9S
SUdTUkNQT1JULCAudHlwZSA9IFhUVFlQRV9QT1JUUkMsDQogCSAuZmxhZ3MgPSBYVE9QVF9JTlZF
UlQgfCBYVE9QVF9OQk99LA0KLQl7Lm5hbWUgPSAiY3RvcmlnZHN0cG9ydCIsIC5pZCA9IE9fQ1RP
UklHRFNUUE9SVCwgLnR5cGUgPSBYVFRZUEVfUE9SVCwNCisJey5uYW1lID0gImN0b3JpZ2RzdHBv
cnQiLCAuaWQgPSBPX0NUT1JJR0RTVFBPUlQsIC50eXBlID0gWFRUWVBFX1BPUlRSQywNCiAJIC5m
bGFncyA9IFhUT1BUX0lOVkVSVCB8IFhUT1BUX05CT30sDQotCXsubmFtZSA9ICJjdHJlcGxzcmNw
b3J0IiwgLmlkID0gT19DVFJFUExTUkNQT1JULCAudHlwZSA9IFhUVFlQRV9QT1JULA0KKwl7Lm5h
bWUgPSAiY3RyZXBsc3JjcG9ydCIsIC5pZCA9IE9fQ1RSRVBMU1JDUE9SVCwgLnR5cGUgPSBYVFRZ
UEVfUE9SVFJDLA0KIAkgLmZsYWdzID0gWFRPUFRfSU5WRVJUIHwgWFRPUFRfTkJPfSwNCi0Jey5u
YW1lID0gImN0cmVwbGRzdHBvcnQiLCAuaWQgPSBPX0NUUkVQTERTVFBPUlQsIC50eXBlID0gWFRU
WVBFX1BPUlQsDQorCXsubmFtZSA9ICJjdHJlcGxkc3Rwb3J0IiwgLmlkID0gT19DVFJFUExEU1RQ
T1JULCAudHlwZSA9IFhUVFlQRV9QT1JUUkMsDQogCSAuZmxhZ3MgPSBYVE9QVF9JTlZFUlQgfCBY
VE9QVF9OQk99LA0KIAl7Lm5hbWUgPSAiY3RkaXIiLCAuaWQgPSBPX0NURElSLCAudHlwZSA9IFhU
VFlQRV9TVFJJTkd9LA0KIAlYVE9QVF9UQUJMRUVORCwNCg==


--=-DobsGO7NOdTgEWjjpYDh--

--=-RWJg+8/mqre0EFTA/70z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk5NjfgACgkQO/MAbZfjDLLHrgCfQCZh/ByCFaV60ySGtRT2IoLa
txUAn2IJtVi73yUp8H3BDB8tWhcAxmdh
=V5Pi
-----END PGP SIGNATURE-----

--=-RWJg+8/mqre0EFTA/70z--

