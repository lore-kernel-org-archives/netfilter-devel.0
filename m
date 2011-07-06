From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Byte order problem in libxt_conntrack.c
Date: Wed, 06 Jul 2011 15:50:02 -0700
Message-ID: <1309992602.6466.41.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rEcAw6VGBxEBAwFZ3cdE"
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:49846 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1GFW43 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:56:29 -0400
Received: from [IPv6:2001:470:b:227:222:3fff:fef6:7c0e] (sami.shorewall.net [IPv6:2001:470:b:227:222:3fff:fef6:7c0e])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by lists.shorewall.net (Postfix) with ESMTPSA id 2CF21F4A896
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2011 15:50:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-rEcAw6VGBxEBAwFZ3cdE
Content-Type: multipart/mixed; boundary="=-sx7l82u+F6gfrzRbpjNW"


--=-sx7l82u+F6gfrzRbpjNW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Using iptables 4.4.11.1, the following input:

-A lan-dmz -p 6 --dport 80 -m conntrack --ctorigdstport 8080 -d 70.90.191.1=
25 -m conntrack --ctorigdst 172.20.1.254 -j ACCEPT

Results in this:

Chain lan-dmz (1 references)
 pkts bytes target     prot opt in     out     source               destina=
tion        =20
    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            70.90.1=
91.125        tcp dpt:80 ctorigdstport 36895 ctorigdst 172.20.1.254

Note that 8080 =3D=3D 0x1f90 while 36895 =3D=3D 0x901f.

The attached patch seems to resolve the issue.

-Tom
--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--=-sx7l82u+F6gfrzRbpjNW
Content-Disposition: attachment; filename="CONNTRACK.patch"
Content-Type: text/x-patch; name="CONNTRACK.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

LS0tIGV4dGVuc2lvbnMvbGlieHRfY29ubnRyYWNrLmMub3JpZwkyMDExLTA2LTA4IDA2OjI2OjE3
LjAwMDAwMDAwMCAtMDcwMA0KKysrIGV4dGVuc2lvbnMvbGlieHRfY29ubnRyYWNrLmMJMjAxMS0w
Ny0wNiAxNToyMjowMy4wMDAwMDAwMDAgLTA3MDANCkBAIC0xMzAsMTMgKzEzMCwxMyBAQA0KIAl7
Lm5hbWUgPSAiY3RleHBpcmUiLCAuaWQgPSBPX0NURVhQSVJFLCAudHlwZSA9IFhUVFlQRV9VSU5U
MzJSQywNCiAJIC5mbGFncyA9IFhUT1BUX0lOVkVSVH0sDQogCXsubmFtZSA9ICJjdG9yaWdzcmNw
b3J0IiwgLmlkID0gT19DVE9SSUdTUkNQT1JULCAudHlwZSA9IFhUVFlQRV9QT1JUUkMsDQotCSAu
ZmxhZ3MgPSBYVE9QVF9JTlZFUlR9LA0KKwkgLmZsYWdzID0gWFRPUFRfSU5WRVJUfFhUT1BUX05C
T30sDQogCXsubmFtZSA9ICJjdG9yaWdkc3Rwb3J0IiwgLmlkID0gT19DVE9SSUdEU1RQT1JULCAu
dHlwZSA9IFhUVFlQRV9QT1JUUkMsDQotCSAuZmxhZ3MgPSBYVE9QVF9JTlZFUlR9LA0KKwkgLmZs
YWdzID0gWFRPUFRfSU5WRVJUfFhUT1BUX05CT30sDQogCXsubmFtZSA9ICJjdHJlcGxzcmNwb3J0
IiwgLmlkID0gT19DVFJFUExTUkNQT1JULCAudHlwZSA9IFhUVFlQRV9QT1JUUkMsDQotCSAuZmxh
Z3MgPSBYVE9QVF9JTlZFUlR9LA0KKwkgLmZsYWdzID0gWFRPUFRfSU5WRVJUfFhUT1BUX05CT30s
DQogCXsubmFtZSA9ICJjdHJlcGxkc3Rwb3J0IiwgLmlkID0gT19DVFJFUExEU1RQT1JULCAudHlw
ZSA9IFhUVFlQRV9QT1JUUkMsDQotCSAuZmxhZ3MgPSBYVE9QVF9JTlZFUlR9LA0KKwkgLmZsYWdz
ID0gWFRPUFRfSU5WRVJUfFhUT1BUX05CT30sDQogCXsubmFtZSA9ICJjdGRpciIsIC5pZCA9IE9f
Q1RESVIsIC50eXBlID0gWFRUWVBFX1NUUklOR30sDQogCVhUT1BUX1RBQkxFRU5ELA0KIH07DQo=


--=-sx7l82u+F6gfrzRbpjNW--

--=-rEcAw6VGBxEBAwFZ3cdE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk4U5poACgkQO/MAbZfjDLLoUgCbBBEchuLIQ7+DgAzhQneQ4f4U
QekAnj4s6rTzCbqX76A2j/+s7UGDha5c
=vgad
-----END PGP SIGNATURE-----

--=-rEcAw6VGBxEBAwFZ3cdE--

