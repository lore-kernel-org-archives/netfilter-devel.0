Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29131C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 16:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiI1QXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 12:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbiI1QXS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 12:23:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96CFE21C5
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 09:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZogC2Whk73DZO7anSh9LFMPIPeFKKooeOupTSZhl9CY=; b=Ht7hayB81Hc9c80Vhr1eFSVajK
        k3wemrYyY1kf/bubs4WFNCL+/TMDRvZmK/G2I1AR+nn9wAlPVKEn9iJ8bM7XKgU3EJnjTVfta8el3
        FAqBAWnLJnrPoYPiZJdk7hMxkgkwgSg4h4qXzfqp3e6hjBmEuPRsS82K1hopkEa//BkIUnLvlX9Z0
        lmyzwpUTRDvFWws7bzgsyS4KRX7Bm4/eHpceAGDB9gcHFN9OQRPXpFRrxVXhEU+EYeJ8TShKhHGB6
        t73SA4TA0UV8SuQSktpyYcCcRoFYBVICdYgqEIK4SEOLcPqEikQlzsmWcrVaDET040fAvFBOziNmT
        QwRV7eWw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odZq0-0001ih-Mm; Wed, 28 Sep 2022 18:23:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fwestpha@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix meta statement parsing
Date:   Wed, 28 Sep 2022 18:23:00 +0200
Message-Id: <20220928162300.1055-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function nft_meta_set_to_target() would always bail since nothing
sets 'sreg->meta_sreg.set' to true. This is obvious, as the immediate
expression "filling" the source register does not indicate its purpose.

The whole source register purpose storing in meta_sreg seems to be
pointless, so drop it altogether.

Fixes: f315af1cf8871 ("nft: track each register individually")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 14 +++++++++-----
 iptables/nft-shared.h |  6 ------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 909fe6483205c..996cff996c151 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -503,10 +503,7 @@ static void nft_meta_set_to_target(struct nft_xt_ctx *ctx,
 	if (!sreg)
 		return;
 
-	if (sreg->meta_sreg.set == 0)
-		return;
-
-	switch (sreg->meta_sreg.key) {
+	switch (nftnl_expr_get_u32(e, NFTNL_EXPR_META_KEY)) {
 	case NFT_META_NFTRACE:
 		if ((sreg->type != NFT_XT_REG_IMMEDIATE)) {
 			ctx->errmsg = "meta nftrace but reg not immediate";
@@ -526,8 +523,10 @@ static void nft_meta_set_to_target(struct nft_xt_ctx *ctx,
 	}
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target == NULL)
+	if (target == NULL) {
+		ctx->errmsg = "target TRACE not found";
 		return;
+	}
 
 	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
 
@@ -1303,6 +1302,11 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 		else if (strcmp(name, "range") == 0)
 			nft_parse_range(&ctx, expr);
 
+		if (ctx.errmsg) {
+			fprintf(stderr, "%s", ctx.errmsg);
+			ctx.errmsg = NULL;
+		}
+
 		expr = nftnl_expr_iter_next(iter);
 	}
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c07d3270a407e..3d935d5324b01 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -68,11 +68,6 @@ struct nft_xt_ctx_reg {
 		uint32_t xor[4];
 		bool set;
 	} bitwise;
-
-	struct {
-		uint32_t key;
-		bool set;
-	} meta_sreg;
 };
 
 struct nft_xt_ctx {
@@ -118,7 +113,6 @@ static inline void nft_xt_reg_clear(struct nft_xt_ctx_reg *r)
 {
 	r->type = 0;
 	r->bitwise.set = false;
-	r->meta_sreg.set = false;
 }
 
 static inline struct nft_xt_ctx_reg *nft_xt_ctx_get_dreg(struct nft_xt_ctx *ctx, enum nft_registers reg)
-- 
2.34.1

