From: Louis Sautier <sautier.louis@gmail.com>
Subject: [PATCH] xtables-compat-restore: fix translation of mangle's OUTPUT
Date: Sun, 10 Sep 2017 02:39:51 +0200
Message-ID: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="p8Vjqvil5K2ltdX5woUGQVUrqFcIarQux"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:47091 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdIJAjy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Sep 2017 20:39:54 -0400
Received: by mail-wm0-f50.google.com with SMTP id i189so20626867wmf.1
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Sep 2017 17:39:54 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec13:b0:dacb:8aff:fe9a:3ce1? ([2a01:e34:ec13:b0:dacb:8aff:fe9a:3ce1])
        by smtp.gmail.com with ESMTPSA id 137sm5129492wmp.7.2017.09.09.17.39.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Sep 2017 17:39:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p8Vjqvil5K2ltdX5woUGQVUrqFcIarQux
Content-Type: multipart/mixed; boundary="bQiuTjkRbNQ1iDvobVwfuWrPoArxMxxrV";
 protected-headers="v1"
From: Louis Sautier <sautier.louis@gmail.com>
To: netfilter-devel@vger.kernel.org
Message-ID: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
Subject: [PATCH] xtables-compat-restore: fix translation of mangle's OUTPUT

--bQiuTjkRbNQ1iDvobVwfuWrPoArxMxxrV
Content-Type: multipart/mixed;
 boundary="------------ABE8A28D34B72243C8F0128F"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------ABE8A28D34B72243C8F0128F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,
I noticed that the iptables-restore-translate tool does not properly
translate the OUTPUT chain from the mangle table. It creates a filter
chain when it should be creating a route chain.
Here is a rather simple patch that should fix the issue.

Please CC me, I'm not subscribed.

Kind regards,

Louis

--------------ABE8A28D34B72243C8F0128F
Content-Type: text/x-patch;
 name="0001-xtables-compat-restore-fix-translation-of-mangle-s-O.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-xtables-compat-restore-fix-translation-of-mangle-s-O.pa";
 filename*1="tch"

=46rom 4eb328c7756044279243419dd3f116754f924a3e Mon Sep 17 00:00:00 2001
From: Louis Sautier <sautier.louis@gmail.com>
Date: Sun, 10 Sep 2017 02:13:18 +0200
Subject: [PATCH] xtables-compat-restore: fix translation of mangle's OUTP=
UT
 chain

This chain should be translated as a route chain, not as a filter chain.
---
 iptables/xtables-translate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3e6c7051..4f6a9caf 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -357,6 +357,8 @@ static int xlate_chain_set(struct nft_handle *h, cons=
t char *table,
=20
 	if (strcmp(table, "nat") =3D=3D 0)
 		type =3D "nat";
+	else if (strcmp(table, "mangle") =3D=3D 0 && strcmp(chain, "OUTPUT") =3D=
=3D 0)
+		type =3D "route";
=20
 	printf("add chain %s %s %s { type %s ",
 	       family2str[h->family], table, chain, type);
--=20
2.14.1


--------------ABE8A28D34B72243C8F0128F--

--bQiuTjkRbNQ1iDvobVwfuWrPoArxMxxrV--

--p8Vjqvil5K2ltdX5woUGQVUrqFcIarQux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIaYtDDqHEijHS173LN9/2oYrKfsFAlm0idcACgkQLN9/2oYr
KfsfIQgAgYhYDn90RQ8hFUV2mH6/U57XxjQ/3fP+zqOTJRX1mo8dGQqivbbiBNCV
23pmxPEEwSQdITpCsHTAOoU69Xec6odvP0gO315UCJrrhqIarqZjt6lA9jMcFpMU
KW/RV6TYv3EwgHVTP5ANaJRmqFfIpXD3N1IIBpapLj3QFbGatwZJ92U87rtp4+NL
YFQ7eJjJmF3RC/0Mu9ohL/D+VtCNKJi/SQxH1hQyb/oadEdipPKwJ8EGoiUsmC2E
vmP7c19xTilvr8t3e/1rcA702VD5+KmDEQm3u99OzXZ45SqyOB/6S5MxrIs65LIw
xuGqoBNUrkwksGAE/7XFF1mz99uREQ==
=c7eB
-----END PGP SIGNATURE-----

--p8Vjqvil5K2ltdX5woUGQVUrqFcIarQux--
