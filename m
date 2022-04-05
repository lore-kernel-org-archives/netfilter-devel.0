Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0485DC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 21:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiDEVQQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457773AbiDEQpp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 12:45:45 -0400
Received: from mout.web.de (mout.web.de [212.227.15.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43115C63
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1649177021;
        bh=+ZuyFIoGpVA6ci57r4J134RBz37mxW2y9sBADTI3Fk4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=LsZSh9kexHPQ9zN/uftG2ryGz2NqPT2pbh2s90tn6QmMMv7aA7S6Qx42Lqi6XN1cX
         amDA+Pu4CcNB9jx/fejj3Xe6oizEkC/sqfHdltb5XWQtrtEZzDmK8Tab6WfipuvIqE
         wAfkIao11eAJjF7/JsbdxH7x7VEm8KigKKQkcxac=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.228]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N14pS-1o0ZS312j4-012S2B; Tue, 05
 Apr 2022 18:43:41 +0200
Date:   Tue, 5 Apr 2022 16:43:30 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] meta.c: fix compiler warning in date_type_parse()
Message-ID: <20220405164330.0a0be0d3@gecko>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ivJa3Ei+UyyulSqzxreI7Q7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:Loh0a1bdDquXGakFAFbx1yaSRDhxWxALp2odwWjqmj/PepcxHa9
 CODCJlPJiq/KGFYmd2vKbcB8db7qpLwCbYso8x3n9y2aPpj6NBNq9YQYUD4ZnY7U8dGIxCl
 Nw0HfavFb+I0IIM6fHIUzTKu7hIcjyDFjw5W8UDYT0Yu41aoYJ6NGvZfGtBQUkJIl7TaBE3
 R9FydMQM0bzeV3sxfhtKQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:C+f/PSUX+so=:60oYqhIRaXAUCO8QUxoaCC
 C0TKLLULTsMOYPsWkU7vh46d+3D9s+AdIjUJ/tDtXm0So5X/dp5M7mxl05yQb3Ze60ANw0bIf
 GRoC6olkzdNqOuBhUIfJINSJXtFdfiqKhl3e34scsCikE84j9Gqktq5+r4xjgttK5dUh5VtFU
 yvcRoBZMJOTmdBWB8XTuFRIoZmTiSB7gyugPJBejXv5AV+5mEtFOe6+NobgEUgfLRWVkWE6Pa
 pP0ZRlYabtN4lhbZS+O55EoQdH4Yy21t3q4aun2nPs3ZHbPGB1i3bMsdQA3SyeqDnoid67l8y
 m5jkXY7EVKOaVoNblHyp894hwHLtWOqs2fgGE4diQJAKVcoUkFF7wxIAot+PSxuCSb8uEwcqh
 Cxsm5lp403VJJk0yqBEDT+mwpNJtvj1+HF/Lrg5ArTcpAFFg5rvdcrqgfGiLhO8AYNcSAZOi0
 UoXwwpYEtRU1wPomdEN0usQAghEcfr8iZKHUL9bNz4Jk2XpjaNS424yNBMBb5UHr+/yV+5oZa
 p/c4uFduodNRggjRmqJKVwC5JEkAzUpP2MDjzov1f3XAIDO+ecwXJyeVkfS7Ij5S7DdLFZ7c6
 6+gPcuLoZ9a4LgFwNC0XAzXscSel5J/evIiaiGQlcFFYKDoDNlS+Kfjw7jQgvnyPDOqa2hUbG
 E+wxjLYG6N7ZT3k8Wufn8vNyWOPt3Lt5xwAAUooq4IdB+vsMWDHk+AuR3h+Ydos5M+l7Y75LN
 qnBRjyszPsA9uA0Z1Bqzmn8551DX3NOOZ6UWZlaTlm8S7ccwtmPRvUBDT2wfkXmW2rqjR/Us5
 el/X89a/V+QubSS2Zmq7G0MKOD5fuW9GOxfxueHQfpqFV8L52H3BczzdNsIszutSEoZL5e9d4
 qo+4GgBg5wv1leKzS6Xd+C5geqrM0K1lCx0D6JHvhF5XpEpq7QGu/rNm8oadPUwKqbJ6rP/QV
 Zjx9O98Riv2ZR+w8uFGmQ1YeSsQdM7lt1becz/0Pgv4hgrUI7mGJ38wKRNNJiCfmhxIjhBQJr
 zo+lDanQy9SgJ6NK3vH3gVaHrLHRHjXlt6gM0qeTw9xkTXemEiwM9S/Oa4icHJFV2zIIdulQD
 p6lXXX5SXNZ5co=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/ivJa3Ei+UyyulSqzxreI7Q7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

After commit 0210097879 ("meta: time: use uint64_t instead of time_t")
there is a compiler warning due to comparison of the return value from
parse_iso_date with -1, which is now implicitly cast to uint64_t.

Fix this by making parse_iso_date take a pointer to the tstamp and
return bool instead.

Fixes: 0210097879 ("meta: time: use uint64_t instead of time_t")
Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 src/meta.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index c0e2608d..80ace25b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -405,7 +405,7 @@ static void date_type_print(const struct expr *expr, st=
ruct output_ctx *octx)
 		nft_print(octx, "Error converting timestamp to printed time");
 }
=20
-static time_t parse_iso_date(const char *sym)
+static bool parse_iso_date(uint64_t *tstamp, const char *sym)
 {
 	struct tm tm, *cur_tm;
 	time_t ts;
@@ -419,7 +419,7 @@ static time_t parse_iso_date(const char *sym)
 	if (strptime(sym, "%F", &tm))
 		goto success;
=20
-	return -1;
+	return false;
=20
 success:
 	/*
@@ -436,7 +436,9 @@ success:
 		return ts;
=20
 	/* Substract tm_gmtoff to get the current time */
-	return ts - cur_tm->tm_gmtoff;
+	*tstamp =3D ts - cur_tm->tm_gmtoff;
+
+	return true;
 }
=20
 static struct error_record *date_type_parse(struct parse_ctx *ctx,
@@ -446,7 +448,7 @@ static struct error_record *date_type_parse(struct pars=
e_ctx *ctx,
 	const char *endptr =3D sym->identifier;
 	uint64_t tstamp;
=20
-	if ((tstamp =3D parse_iso_date(sym->identifier)) !=3D -1)
+	if (parse_iso_date(&tstamp, sym->identifier))
 		goto success;
=20
 	tstamp =3D strtoul(sym->identifier, (char **) &endptr, 10);
--=20
2.35.1

--Sig_/ivJa3Ei+UyyulSqzxreI7Q7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmJMcbIACgkQNasLKJxd
slhXBQ/9EfJdFVVU0TeS3qSmGaNj36S5NksET9Q4p3Vn5AIPpF8Yez9+FJtV3Ex/
EW7nz8rfcwh9GB6WaFNUjNuKdMap6Zm0Tu9ZkYwZaih85ZZI9LNzSQJ74e4alB4x
vQIhY7V3euWaKXmNsz5E9BlRNNjCImymydTQh/L5AvGB0r2FzhgaiNAiFMi5jx6M
7dfyCQfewGZ0zSRkirdth142opP+BVmnnBGFMkhR7++15YEC2xxggmWF2DOrN/Vd
lRxSY3/7syJe8maZuDyboz4660filP+x7PjkEw3PxmepaNg27I23dWcAADe+Jgfs
NwH3qkVoLVnAL2Lofxb8F7DFJbZF790DYwTto1Z5IUL9LSOhGhrVu4kfv/aZFNNq
UZri+ihbXQ1/d8krf+6WAsKCQ4S+WzQkYXglYn18N73PtZIWFwpSHtHpyOcl5v4n
rqlW2RkWZK6arq6v+lB/G4cTQjl8lZKLMZb9pCFCvwINPbLJkYR/fLOKxfxWb0C1
h/WIpBoGeiIidVemCXaO1+BRyQWLVfkyRmXvuAJGu56BksP5UhXYni0QRs84SxaJ
qAKFLcR1sx5cFfGHT8t39KCWLYrQwCitx0E9xkQJarq3qL4AJ22L5KfNpyyR+3+e
6QzWksNgZrdvW+YxARsanzZHeNFl0gWaOMkX9jUpaDQCP0gjmtw=
=v9Ex
-----END PGP SIGNATURE-----

--Sig_/ivJa3Ei+UyyulSqzxreI7Q7--
