Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91CFC00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 13:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiHAN47 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiHAN46 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 09:56:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74FB6175
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 06:56:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIVui-0000hi-GH; Mon, 01 Aug 2022 15:56:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 4/8] debug: dump the l2 protocol stack
Date:   Mon,  1 Aug 2022 15:56:29 +0200
Message-Id: <20220801135633.5317-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801135633.5317-1-fw@strlen.de>
References: <20220801135633.5317-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously we used to print the cumulative size of the headers,
update this to print the tracked l2 stack.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: no changes.
 src/proto.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index 2663f216860b..c49648275e12 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -154,6 +154,12 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
 	if (!(debug_mask & NFT_DEBUG_PROTO_CTX))
 		return;
 
+	if (base == PROTO_BASE_LL_HDR && ctx->stacked_ll_count) {
+		pr_debug(" saved ll headers:");
+		for (i = 0; i < ctx->stacked_ll_count; i++)
+			pr_debug(" %s", ctx->stacked_ll[i]->name);
+	}
+
 	pr_debug("update %s protocol context:\n", proto_base_names[base]);
 	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
 		pr_debug(" %-20s: %s",
-- 
2.35.1

