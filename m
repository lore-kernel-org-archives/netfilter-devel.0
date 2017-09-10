From: Louis Sautier <sautier.louis@gmail.com>
Subject: Re: [PATCH] xtables-compat-restore: fix translation of mangle's
 OUTPUT
Date: Sun, 10 Sep 2017 20:35:23 +0200
Message-ID: <603ee036-ea61-e797-7828-a7b0bd3a9bd9@gmail.com>
References: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xgX3S7DUtcDSSwPsiDdM9dlG2Kf6i5O4G"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:43681 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdIJSfT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 14:35:19 -0400
Received: by mail-wm0-f48.google.com with SMTP id a137so3417850wma.0
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2017 11:35:18 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec13:b0:3602:86ff:fef0:2ee0? ([2a01:e34:ec13:b0:3602:86ff:fef0:2ee0])
        by smtp.gmail.com with ESMTPSA id b184sm3551028wmf.13.2017.09.10.11.35.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Sep 2017 11:35:16 -0700 (PDT)
In-Reply-To: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xgX3S7DUtcDSSwPsiDdM9dlG2Kf6i5O4G
Content-Type: multipart/mixed; boundary="V7anFS9LH4qgMUMk4ecBkrlGdKagiEAPO";
 protected-headers="v1"
From: Louis Sautier <sautier.louis@gmail.com>
To: netfilter-devel@vger.kernel.org
Message-ID: <603ee036-ea61-e797-7828-a7b0bd3a9bd9@gmail.com>
Subject: Re: [PATCH] xtables-compat-restore: fix translation of mangle's
 OUTPUT
References: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
In-Reply-To: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>

--V7anFS9LH4qgMUMk4ecBkrlGdKagiEAPO
Content-Type: multipart/mixed;
 boundary="------------1C5AD523897D9C2721C953EB"
Content-Language: fr-classic

This is a multi-part message in MIME format.
--------------1C5AD523897D9C2721C953EB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/09/17 02:39, Louis Sautier wrote:
> Hello,
> I noticed that the iptables-restore-translate tool does not properly
> translate the OUTPUT chain from the mangle table. It creates a filter
> chain when it should be creating a route chain.
> Here is a rather simple patch that should fix the issue.
>
> Please CC me, I'm not subscribed.
>
> Kind regards,
>
> Louis

I made a typo in the commit message, it is related to xtables-translate,
not xtables-compat-restore. Here is the fixed patch.


--------------1C5AD523897D9C2721C953EB
Content-Type: text/x-patch;
 name="0001-xtables-translate-fix-translation-of-mangle-s-OUTPUT.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-xtables-translate-fix-translation-of-mangle-s-OUTPUT.pa";
 filename*1="tch"

=46rom d9f0f601e0a8be841650541382787cf80bd28e5f Mon Sep 17 00:00:00 2001
From: Louis Sautier <sautier.louis@gmail.com>
Date: Sun, 10 Sep 2017 02:13:18 +0200
Subject: [PATCH] xtables-translate: fix translation of mangle's OUTPUT ch=
ain

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


--------------1C5AD523897D9C2721C953EB--

--V7anFS9LH4qgMUMk4ecBkrlGdKagiEAPO--

--xgX3S7DUtcDSSwPsiDdM9dlG2Kf6i5O4G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIaYtDDqHEijHS173LN9/2oYrKfsFAlm1hesACgkQLN9/2oYr
Kfto7wf+Jpq67HQCuKmrb9VaATvMBgbptos7hbcLDDoZ8jCQC4iyGaaffbAnDUVq
9lKfItP6QGuBEctqA05GAzCgdb4fKHAMz9B1zdVXlAIVqPxzsQWTZonx67qbwDf7
ve4ioqUktzXrlJQeKfF/B9Y/oT0pYsmUSK1OtGzSVwmr8tS5ff+iAStGZVG4cFTT
7LGkht4Sjn+We1c6ebmWNOORXpRFI0FJOMsYJ0g785kUUgpCbMFtGuBLn47wrEU0
iogT7DAa8rWd9ZEzAIf7JdgHicGnZ2fD5HhJiWYchJeZJSx8qkAefiAOR4wVv8lk
odeO53ZgKnqUuM1AXZwBJqx5j47NAQ==
=TllH
-----END PGP SIGNATURE-----

--xgX3S7DUtcDSSwPsiDdM9dlG2Kf6i5O4G--
