Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BAEC7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A302B2190F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="BEeomcFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbfGVQeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:34:16 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40914 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbfGVQeP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:34:15 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 465771A3E9E;
        Mon, 22 Jul 2019 09:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563813255; bh=J5acMbMoxSM2v053Tc2uzpxUnHHaYjslfZmMmZuGnIw=;
        h=From:To:Cc:Subject:Date:From;
        b=BEeomcFtDF8/X8/tJd69Zd48udLd4OSm5Cp33jPw0tlyZVVyodTdynW4hBTOEjUGv
         7rTv/NBB9Cqo/YlGR7kRtD9VTAvpuhR6P2B4n+y46AdhfGJRsS5woWi5YtD4MN5oK6
         BjUBZ0PWM1/Tn4IjdVj9CqtrlwLooNVc/6DkDCy0=
X-Riseup-User-ID: BF97727DFDF92B724EA0D1B71E77DF67F3C4170F4FFE70B9663AB48558517E23
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 29430222170;
        Mon, 22 Jul 2019 09:34:12 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3] src: osf: fix snprintf -Wformat-truncation warning
Date:   Mon, 22 Jul 2019 18:34:08 +0200
Message-Id: <20190722163408.17570-1-ffmancera@riseup.net>
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
v1: initial patch
v2: add Phil's changes
v3: get rid of pointless asignments
---
 src/nfnl_osf.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index be3fd81..08e978d 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -81,7 +81,7 @@ static char *nf_osf_strchr(char *ptr, char c)
 	if (tmp)
 		*tmp = '\0';
 
-	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
+	while (tmp && isspace(*(tmp + 1)))
 		tmp++;
 
 	return tmp;
@@ -98,7 +98,6 @@ static void nf_osf_parse_opt(struct nf_osf_opt *opt, __u16 *optnum, char *obuf,
 	i = 0;
 	while (ptr != NULL && i < olen && *ptr != 0) {
 		val = 0;
-		op = 0;
 		wc = OSF_WSS_PLAIN;
 		switch (obuf[i]) {
 		case 'N':
@@ -289,32 +288,34 @@ static int osf_load_line(char *buffer, int len, int del,
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
+		i = sizeof(obuf);
+		snprintf(obuf, i, "%.*s,", i - 2, pbeg);
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
+		snprintf(f.genre, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
+		i = sizeof(f.version);
+		snprintf(f.version, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt =
-		    snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
+		i = sizeof(f.subtype);
+		snprintf(f.subtype, i, "%.*s", i - 1, pbeg);
 		pbeg = pend + 1;
 	}
 
-- 
2.20.1

