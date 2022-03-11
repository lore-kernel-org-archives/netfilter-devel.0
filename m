Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64176C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Mar 2022 10:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbiCKKzH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 05:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiCKKzG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 05:55:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3501B5105
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Mar 2022 02:54:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nScuH-0002Di-3z; Fri, 11 Mar 2022 11:54:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_meta: extend reduce support to bridge family
Date:   Fri, 11 Mar 2022 11:53:56 +0100
Message-Id: <20220311105356.12028-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

its enough to export the meta get reduce helper and then call it
from nft_meta_bridge too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nft_meta.h       | 2 ++
 net/bridge/netfilter/nft_meta_bridge.c | 1 +
 net/netfilter/nft_meta.c               | 5 +++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 2dce55c736f4..28fb2e9e3e5b 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -43,4 +43,6 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
+bool nft_meta_get_reduce(struct nft_regs_track *track,
+			 const struct nft_expr *expr);
 #endif
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c1ef9cc89b78..c430f2a847d6 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -98,6 +98,7 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
 	.dump		= nft_meta_get_dump,
+	.reduce		= nft_meta_get_reduce,
 };
 
 static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5ab4df56c945..63decbb4737f 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -750,8 +750,8 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
-static bool nft_meta_get_reduce(struct nft_regs_track *track,
-				const struct nft_expr *expr)
+bool nft_meta_get_reduce(struct nft_regs_track *track,
+			 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct nft_meta *meta;
@@ -776,6 +776,7 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 
 	return nft_expr_reduce_bitwise(track, expr);
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_reduce);
 
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
-- 
2.34.1

