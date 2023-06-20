Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841A0EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 18:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjFTSLV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFTSLV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 14:11:21 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263CC186
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 11:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o9ZSYj8tiBDufK5ePLe1y5P+UyDKaMi/dAJdDA06glQ=; b=bH9pFYQoVFIjPdXBGk0Ir3itxU
        Lw+tmRZna+sMrrj5FItiwmai5lEFwP8bcRHAwQ1BVD2X7LdKRSgjV/OEGk0KFdSnYq0DSb0sLc9Hy
        1thxezhBgmBumfpfqvzGEvWfXvEpZs24Xwj6lGuBew1syrQk9sXFCocYVoNCk4XaLEyfZBmCpf97D
        3WzGuP6uMAKZMvCaa+lgn/QdsCDF12keFWpEyY1UXFEfv3oDMDiONscTYxRsvDE+wE3l+Xh0iwhEG
        VfMuN7WI3wVzqKT5GyaxEnzt6PTV3ZIFB3XntyrWjMN7b0dFb8p4zuSz/NZ8JhR9Far9exSQZflfh
        A2lW2A1w==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBfp0-009DPo-16
        for netfilter-devel@vger.kernel.org;
        Tue, 20 Jun 2023 19:11:18 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2] lib/ts_bm: add helper to reduce indentation and improve readability
Date:   Tue, 20 Jun 2023 19:11:00 +0100
Message-Id: <20230620181100.2010317-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The flow-control of `bm_find` is very deeply nested with a conditional
comparing a ternary expression against the pattern inside a for-loop
inside a while-loop inside a for-loop.

Move the inner for-loop into a helper function to reduce the amount of
indentation and make the code easier to read.

Fix indentation and trailing white-space in preceding debug logging
statement.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
Changes since v1

 * Update `i` in `bm_find`
 * Mention white-space changes for `DEBUGP` statement

 lib/ts_bm.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 1f2234221dd1..8f4ae7826c84 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -55,6 +55,24 @@ struct ts_bm
 	unsigned int	good_shift[];
 };
 
+static unsigned int matchpat(const u8 *pattern, unsigned int patlen,
+			     const u8 *text, bool icase)
+{
+	unsigned int i;
+
+	for (i = 0; i < patlen; i++) {
+		u8 t = *(text-i);
+
+		if (icase)
+			t = toupper(t);
+
+		if (t != *(pattern-i))
+			break;
+	}
+
+	return i;
+}
+
 static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 {
 	struct ts_bm *bm = ts_config_priv(conf);
@@ -70,19 +88,18 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 			break;
 
 		while (shift < text_len) {
-			DEBUGP("Searching in position %d (%c)\n", 
-				shift, text[shift]);
-			for (i = 0; i < bm->patlen; i++) 
-				if ((icase ? toupper(text[shift-i])
-				    : text[shift-i])
-					!= bm->pattern[bm->patlen-1-i])
-				     goto next;
-
-			/* London calling... */
-			DEBUGP("found!\n");
-			return consumed + (shift-(bm->patlen-1));
-
-next:			bs = bm->bad_shift[text[shift-i]];
+			DEBUGP("Searching in position %d (%c)\n",
+			       shift, text[shift]);
+
+			i = matchpat(&bm->pattern[bm->patlen-1], bm->patlen,
+				     &text[shift], icase);
+			if (i == bm->patlen) {
+				/* London calling... */
+				DEBUGP("found!\n");
+				return consumed + (shift-(bm->patlen-1));
+			}
+
+			bs = bm->bad_shift[text[shift-i]];
 
 			/* Now jumping to... */
 			shift = max_t(int, shift-i+bs, shift+bm->good_shift[i]);
-- 
2.40.1

