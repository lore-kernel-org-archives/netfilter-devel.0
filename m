Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65743EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 18:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjFTSJg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjFTSJf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 14:09:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C7C18C
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 11:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dtH/HgPU04v44sfXcmah5GZ7s6G7EaamEj5MCXfefCo=; b=ful0D8OjyUgegi+24eVjmtZ8vH
        7JcNuylIJChNYXHHkZVwNxI6NH1rD2UCiA0kTPpkw1L0kd8q4skk/agmY9peEOPvoIEWISmWgc68l
        GakDrEhwc1uBa750BmSEmgbx+pVhLs6Bg8huRicMuDvEi4GDc2OmvZrDf4boCWRS3Qo08yJjs35er
        7dLlBV1DeRw50wgR4WildVk1l+hHml0f5LENPP7/nus/6bWI97XZWoaVeQtyOfOtzAt8LWNXVtd9D
        2dfxrCMLxfeNMDiJSQO9P+HagNXpDuGle+GU/vmY/kpkypGRiuAWaqkCTsw0TX2qIWiFaY3Ojrw3u
        NqPTzMEA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBfnH-009DOo-1w
        for netfilter-devel@vger.kernel.org;
        Tue, 20 Jun 2023 19:09:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next] lib/ts_bm: add helper to reduce indentation and improve readability
Date:   Tue, 20 Jun 2023 19:09:25 +0100
Message-Id: <20230620180925.2010176-1-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 lib/ts_bm.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 1f2234221dd1..d74fdb87d269 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -55,6 +55,24 @@ struct ts_bm
 	unsigned int	good_shift[];
 };
 
+static bool patmtch(const u8 *pattern, const u8 *text, unsigned int patlen,
+		    bool icase)
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
+			return false;
+	}
+
+	return true;
+}
+
 static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 {
 	struct ts_bm *bm = ts_config_priv(conf);
@@ -70,19 +88,17 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
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
+			if (patmtch(&bm->pattern[bm->patlen-1], &text[shift],
+				    bm->patlen, icase)) {
+				/* London calling... */
+				DEBUGP("found!\n");
+				return consumed + (shift-(bm->patlen-1));
+			}
+
+			bs = bm->bad_shift[text[shift-i]];
 
 			/* Now jumping to... */
 			shift = max_t(int, shift-i+bs, shift+bm->good_shift[i]);
-- 
2.39.2

