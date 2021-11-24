Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401C7C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbhKXR0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR0w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1903DC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:43 -0800 (PST)
Received: from localhost ([::1]:44862 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzh-000183-CV; Wed, 24 Nov 2021 18:23:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 02/15] exthdr: Fix for segfault with unknown exthdr
Date:   Wed, 24 Nov 2021 18:22:38 +0100
Message-Id: <20211124172251.11539-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unknown exthdr type with NFT_EXTHDR_F_PRESENT flag set caused
NULL-pointer deref. Fix this by moving the conditional exthdr.desc deref
atop the function and use the result in all cases.

Fixes: e02bd59c4009b ("exthdr: Implement existence check")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/exthdr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 22a08b0c9c2bf..7a29e63d4d536 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -46,6 +46,9 @@ static const struct exthdr_desc *exthdr_find_desc(enum exthdr_desc_id desc_id)
 
 static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
+	const char *name = expr->exthdr.desc ?
+		expr->exthdr.desc->name : "unknown-exthdr";
+
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
 		/* Offset calculation is a bit hacky at this point.
 		 * There might be a tcp option one day with another
@@ -65,14 +68,14 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 			return;
 		}
 
-		nft_print(octx, "tcp option %s", expr->exthdr.desc->name);
+		nft_print(octx, "tcp option %s", name);
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
 		if (offset)
 			nft_print(octx, "%d", offset);
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
 	} else if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
-		nft_print(octx, "ip option %s", expr->exthdr.desc->name);
+		nft_print(octx, "ip option %s", name);
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
@@ -83,10 +86,9 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, " %s", expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-			nft_print(octx, "exthdr %s", expr->exthdr.desc->name);
+			nft_print(octx, "exthdr %s", name);
 		else {
-			nft_print(octx, "%s %s",
-				  expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
+			nft_print(octx, "%s %s", name,
 				  expr->exthdr.tmpl->token);
 		}
 	}
-- 
2.33.0

