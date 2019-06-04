Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF0BC282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61681208E3
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFDRcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:06 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56440 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfFDRcG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:06 -0400
Received: from localhost ([::1]:41296 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDI5-0000jJ-1K; Tue, 04 Jun 2019 19:32:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 09/10] include: Collect __stmt_binary_error() wrapper macros
Date:   Tue,  4 Jun 2019 19:31:57 +0200
Message-Id: <20190604173158.1184-10-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
References: <20190604173158.1184-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At least cmd_error() is useful outside of evaluate.c, so collect all
these macros into erec.h.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/erec.h | 6 ++++++
 src/evaluate.c | 7 -------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 79a162902304b..fc512a622947f 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -75,5 +75,11 @@ extern int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define stmt_binary_error(ctx, s1, s2, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
+#define chain_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define monitor_error(ctx, s1, fmt, args...) \
+	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define cmd_error(ctx, loc, fmt, args...) \
+	__stmt_binary_error(ctx, loc, NULL, fmt, ## args)
 
 #endif /* NFTABLES_EREC_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 09bb1fd37a301..358f5b7152634 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -42,13 +42,6 @@ static const char * const byteorder_names[] = {
 	[BYTEORDER_BIG_ENDIAN]		= "big endian",
 };
 
-#define chain_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
-#define monitor_error(ctx, s1, fmt, args...) \
-	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
-#define cmd_error(ctx, loc, fmt, args...) \
-	__stmt_binary_error(ctx, loc, NULL, fmt, ## args)
-
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
 				       const char *fmt, ...)
-- 
2.21.0

