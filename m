Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203B5C76195
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 19:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA49D2084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 19:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="XQ7EqZK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfGUTY3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 15:24:29 -0400
Received: from mx1.riseup.net ([198.252.153.129]:53732 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGUTY3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 15:24:29 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 59B6A1A1203
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 12:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563737068; bh=V1QzeGrARp5u+1vUTLdXvZbPbhuoKf9b33vORsvROY0=;
        h=From:To:Cc:Subject:Date:From;
        b=XQ7EqZK7IbGED2ueAHFInkTwxBoHHvxl4+ZPB0G1INS5oEq7t66SNU94EmwriDQvF
         n96rJxJ2AD9TPvOHVcHDIE5htYzUy6DjGCP426H6njALBvdYQGcNm9cdPS64nTQVBG
         s+zx230SxuixBvxRuW+MU+3WZayMd1qvs+y4E/L0=
X-Riseup-User-ID: C636B11A3A4F70ACC9A1F7895C64E1CDB317F169D781B63E02F9F250DB9E03B1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 0B7DF22248B;
        Sun, 21 Jul 2019 12:24:26 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH iptables] nfnl_osf: fix snprintf -Wformat-truncation warning
Date:   Sun, 21 Jul 2019 21:24:15 +0200
Message-Id: <20190721192415.12204-1-ffmancera@riseup.net>
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

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 utils/nfnl_osf.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/utils/nfnl_osf.c b/utils/nfnl_osf.c
index 0ea33fce..4ea9d2b3 100644
--- a/utils/nfnl_osf.c
+++ b/utils/nfnl_osf.c
@@ -343,31 +343,34 @@ static int osf_load_line(char *buffer, int len, int del)
 	pend = xt_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		snprintf(obuf, sizeof(obuf), "%s,", pbeg);
+		i = sizeof(obuf);
+		snprintf(obuf, i, "%.*s,", i - 2, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = xt_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
+		i = sizeof(f.genre);
 		if (pbeg[0] == '@' || pbeg[0] == '*')
-			snprintf(f.genre, sizeof(f.genre), "%s", pbeg + 1);
-		else
-			snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
+			pbeg++;
+		snprintf(f.genre, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = xt_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		snprintf(f.version, sizeof(f.version), "%s", pbeg);
+		i = sizeof(f.version);
+		snprintf(f.version, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = xt_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
+		i = sizeof(subtype);
+		snprintf(f.subtype, i, "%.*s", i - 1, pbeg);
 	}
 
 	xt_osf_parse_opt(f.opt, &f.opt_num, obuf, sizeof(obuf));
-- 
2.20.1

