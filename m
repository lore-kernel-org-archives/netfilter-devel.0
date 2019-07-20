Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E72C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 18:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6012084C
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 18:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGTSwm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 14:52:42 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41202 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfGTSwl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 14:52:41 -0400
Received: from localhost ([::1]:54292 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1houTI-00070i-D3; Sat, 20 Jul 2019 20:52:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] nfnl_osf: Silence string truncation gcc warnings
Date:   Sat, 20 Jul 2019 20:52:26 +0200
Message-Id: <20190720185226.8876-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720185226.8876-1-phil@nwl.cc>
References: <20190720185226.8876-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Albeit a bit too enthusiastic, gcc is right in that these strings may be
truncated since the destination buffer is smaller than the source one.
Get rid of the warnings (and the potential problem) by specifying a
string "precision" of one character less than the destination. This
ensures a terminating nul-character may be written as well.

Fixes: af00174af3ef4 ("src: osf: import nfnl_osf.c to load osf fingerprints")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/nfnl_osf.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index be3fd8100b665..bed9ba64b65c6 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
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
+		cnt = snprintf(f.genre, i, "%.*s", i - 1, pbeg + 1);
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
2.22.0

