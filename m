Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB59C76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 19:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0857E2083B
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 19:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="sthl54V3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfGUTHy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 15:07:54 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50028 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfGUTHy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 15:07:54 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9C12B1A1203;
        Sun, 21 Jul 2019 12:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563736073; bh=02npZRDBi56UliPgI3Ih05DqMQLTWlArtx/FvB8xoYM=;
        h=From:To:Cc:Subject:Date:From;
        b=sthl54V3I734zG9Oq9eLttCPkwCGVWdLURiMWGnVpQkEcNtheVJ58BDsZwqg1F7Ny
         ji0jBz7P1F3t1gAb4ReMrVpjgts5bGH9YIv7oRPDitW6WqHfUQrWAyCdEAXESbHltK
         0WGKO5e1sqmDvLxzoGOW34BvIENcEJryqBmrHqZk=
X-Riseup-User-ID: 3614025F0ED5FE7AB98C76AA1A0DCDE1152EB8FA907E4FE9D23AD83F5052F284
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 1A5C5120390;
        Sun, 21 Jul 2019 12:07:51 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] src: osf: fix snprintf -Wformat-truncation warning
Date:   Sun, 21 Jul 2019 21:07:37 +0200
Message-Id: <20190721190737.4333-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fedora 30 uses very recent gcc (version 9.1.1 20190503 (Red Hat 9.1.1-1)),
osf produces following warnings:

-Wformat-truncation warning have been introduced in the version 7.1 of gcc.
Also, remove a unneeded address check of "tmp + 1" in nf_osf_strchr().

nfnl_osf.c: In function ‘nfnl_osf_load_fingerprints’:
nfnl_osf.c:292:39: warning: ‘%s’ directive output may be truncated writing
up to 1023 bytes into a region of size 128 [-Wformat-truncation=]
  292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
      |                                       ^~
nfnl_osf.c:292:9: note: ‘snprintf’ output between 2 and 1025 bytes into a
destination of size 128
  292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nfnl_osf.c:302:46: warning: ‘%s’ directive output may be truncated writing
up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
  302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
      |                                              ^~
nfnl_osf.c:302:10: note: ‘snprintf’ output between 1 and 1024 bytes into a
destination of size 32
  302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nfnl_osf.c:309:49: warning: ‘%s’ directive output may be truncated writing
up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
  309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
      |                                                 ^~
nfnl_osf.c:309:9: note: ‘snprintf’ output between 1 and 1024 bytes into a
destination of size 32
  309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nfnl_osf.c:317:47: warning: ‘%s’ directive output may be truncated writing
up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
  317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
      |                                               ^~
nfnl_osf.c:317:7: note: ‘snprintf’ output between 1 and 1024 bytes into a
destination of size 32
  317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/nfnl_osf.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index be3fd81..d8284dd 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -81,7 +81,7 @@ static char *nf_osf_strchr(char *ptr, char c)
 	if (tmp)
 		*tmp = '\0';
 
-	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
+	while (tmp && isspace(*(tmp + 1)))
 		tmp++;
 
 	return tmp;
@@ -289,32 +289,34 @@ static int osf_load_line(char *buffer, int len, int del,
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
+		i = sizeof(obuf);
+		cnt = snprintf(obuf, i, "%.*s,", i - 2, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
+		i = sizeof(f.genre);
 		if (pbeg[0] == '@' || pbeg[0] == '*')
-			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg + 1);
-		else
-			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
+			pbeg++;
+		cnt = snprintf(f.genre, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
+		i = sizeof(f.version);
+		cnt = snprintf(f.version, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt =
-		    snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
+		i = sizeof(f.subtype);
+		cnt = snprintf(f.subtype, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
-- 
2.20.1

