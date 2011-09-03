From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Correct CONNSECMARK_save()
Date: Sat, 03 Sep 2011 06:24:38 -0700
Message-ID: <1315056278.2383.5.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rhjLyLopS5Q/eQXcEUL2"
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([70.90.191.124]:57098 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1ICNYk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Sep 2011 09:24:40 -0400
Received: from [IPv6:2001:470:b:227:222:3fff:fef6:7c0e] (sami.shorewall.net [IPv6:2001:470:b:227:222:3fff:fef6:7c0e])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by lists.shorewall.net (Postfix) with ESMTPSA id B3E55F4A896
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Sep 2011 06:24:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-rhjLyLopS5Q/eQXcEUL2
Content-Type: multipart/mixed; boundary="=-02XCVI9WxYYIU6ZWE6aG"


--=-02XCVI9WxYYIU6ZWE6aG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Output is missing a space between 'CONNSECMARK' and '--'.

        sami:~# iptables -N foo -t mangle
        sami:~# iptables -A foo -t mangle -j CONNSECMARK --save
        sami:~# iptables -S -t mangle
        -P PREROUTING ACCEPT
        -P INPUT ACCEPT
        -P FORWARD ACCEPT
        -P OUTPUT ACCEPT
        -P POSTROUTING ACCEPT
        -N foo
        -A foo -j CONNSECMARK--save
        sami:~#=20

-Tom
--=20
Tom Eastep        \ When I die, I want to go like my Grandfather who
Shoreline,         \ died peacefully in his sleep. Not screaming like
Washington, USA     \ all of the passengers in his car
http://shorewall.net \________________________________________________


--=-02XCVI9WxYYIU6ZWE6aG
Content-Disposition: attachment; filename="commit-953ba77"
Content-Type: text/plain; name="commit-953ba77"; charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IDk1M2JhNzdhZmZhYjE5ZjE2YmQ5MDY0ZDZiODM0NGMzZDEyYTliNTMNCkF1dGhvcjog
VG9tIEVhc3RlcCA8dGVhc3RlcEBzaG9yZXdhbGwubmV0Pg0KRGF0ZTogICBGcmkgU2VwIDIgMTc6
NDU6NTEgMjAxMSAtMDcwMA0KDQogICAgUmVzb2x2ZSAtUyBpc3N1ZSB3aXRoIENPTk5TRUNNQVJL
DQoNCmRpZmYgLS1naXQgYS9leHRlbnNpb25zL2xpYnh0X0NPTk5TRUNNQVJLLmMgYi9leHRlbnNp
b25zL2xpYnh0X0NPTk5TRUNNQVJLLmMNCmluZGV4IGRmMmU2YjguLjBiM2NkNzkgMTAwNjQ0DQot
LS0gYS9leHRlbnNpb25zL2xpYnh0X0NPTk5TRUNNQVJLLmMNCisrKyBiL2V4dGVuc2lvbnMvbGli
eHRfQ09OTlNFQ01BUksuYw0KQEAgLTg3LDcgKzg3LDcgQEAgQ09OTlNFQ01BUktfc2F2ZShjb25z
dCB2b2lkICppcCwgY29uc3Qgc3RydWN0IHh0X2VudHJ5X3RhcmdldCAqdGFyZ2V0KQ0KIAljb25z
dCBzdHJ1Y3QgeHRfY29ubnNlY21hcmtfdGFyZ2V0X2luZm8gKmluZm8gPQ0KIAkJKHN0cnVjdCB4
dF9jb25uc2VjbWFya190YXJnZXRfaW5mbyopdGFyZ2V0LT5kYXRhOw0KIA0KLQlwcmludGYoIi0t
Iik7DQorCXByaW50ZigiIC0tIik7DQogCXByaW50X2Nvbm5zZWNtYXJrKGluZm8pOw0KIH0NCiAN
Cg==


--=-02XCVI9WxYYIU6ZWE6aG--

--=-rhjLyLopS5Q/eQXcEUL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk5iKpEACgkQO/MAbZfjDLIb6wCfSCkCHrcDLyTXLwyWja2xD/dE
o1YAoKcgT6b+AKkco2XVI6YANre73aOQ
=Ytu7
-----END PGP SIGNATURE-----

--=-rhjLyLopS5Q/eQXcEUL2--

