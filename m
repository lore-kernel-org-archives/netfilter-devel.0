Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2250C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 11:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B64E2173B
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 11:02:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="DBHth1mI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfGRLCE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 07:02:04 -0400
Received: from mx1.riseup.net ([198.252.153.129]:51928 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfGRLCE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 07:02:04 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2CEB11B93BA;
        Thu, 18 Jul 2019 04:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563447723; bh=H4SToIpaas3hhSWcXdoBvNhaPvPqyYHSOqw2mb1rMCE=;
        h=From:To:Cc:Subject:Date:From;
        b=DBHth1mINAollrfvtVnjm3EEFRSQCQj8hm2AbvaOr6/5jY4LBo7x+bmoN6IZ6gBgo
         Cmc2/j9O5BrriS7g04q6Nn9IzefiXm5GRVCxKK8LHgckAHAs/67aKPKhRYSNgez/77
         K+9uMeKSrLpAwgsjXDa87I8c6UMut4yNgBWd7uN0=
X-Riseup-User-ID: 4DB131B3318C0D5B66C7B9F3EB344FB306A980CE668286AF9970BE1609428CD0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 35D351207A5;
        Thu, 18 Jul 2019 04:02:02 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: osf: fix snprintf -Wformat-truncation warning
Date:   Thu, 18 Jul 2019 13:01:46 +0200
Message-Id: <20190718110145.13361-1-ffmancera@riseup.net>
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
 src/nfnl_osf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index be3fd81..c99f8f3 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -81,7 +81,7 @@ static char *nf_osf_strchr(char *ptr, char c)
 	if (tmp)
 		*tmp = '\0';
 
-	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
+	while (tmp && isspace(*(tmp + 1)))
 		tmp++;
 
 	return tmp;
@@ -212,7 +212,7 @@ static int osf_load_line(char *buffer, int len, int del,
 			 struct netlink_ctx *ctx)
 {
 	int i, cnt = 0;
-	char obuf[MAXOPTSTRLEN];
+	char obuf[MAXOPTSTRLEN + 1];
 	struct nf_osf_user_finger f;
 	char *pbeg, *pend;
 	struct nlmsghdr *nlh;
@@ -289,7 +289,7 @@ static int osf_load_line(char *buffer, int len, int del,
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
+		cnt = snprintf(obuf, sizeof(obuf), "%.128s", pbeg);
 		pbeg = pend + 1;
 	}
 
@@ -297,16 +297,16 @@ static int osf_load_line(char *buffer, int len, int del,
 	if (pend) {
 		*pend = '\0';
 		if (pbeg[0] == '@' || pbeg[0] == '*')
-			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg + 1);
+			cnt = snprintf(f.genre, sizeof(f.genre), "%.31s", pbeg + 1);
 		else
-			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
+			cnt = snprintf(f.genre, sizeof(f.genre), "%.31s", pbeg);
 		pbeg = pend + 1;
 	}
 
 	pend = nf_osf_strchr(pbeg, OSFPDEL);
 	if (pend) {
 		*pend = '\0';
-		cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
+		cnt = snprintf(f.version, sizeof(f.version), "%.31s", pbeg);
 		pbeg = pend + 1;
 	}
 
@@ -314,7 +314,7 @@ static int osf_load_line(char *buffer, int len, int del,
 	if (pend) {
 		*pend = '\0';
 		cnt =
-		    snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
+		    snprintf(f.subtype, sizeof(f.subtype), "%.31s", pbeg);
 		pbeg = pend + 1;
 	}
 
-- 
2.20.1

