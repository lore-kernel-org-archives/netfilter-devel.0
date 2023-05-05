Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2024AC77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjEEPbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjEEPbv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:31:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FDE118902
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 03/12] netfilter: nf_tables: update nft_copy_data() to take struct nft_regs
Date:   Fri,  5 May 2023 17:31:21 +0200
Message-Id: <20230505153130.2385-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass registers and index to nft_copy_data() in preparation of further
updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 8 ++++++--
 net/netfilter/nft_immediate.c     | 2 +-
 net/netfilter/nft_lookup.c        | 8 ++++----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1bc9e6571231..ac95b704cd70 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -243,11 +243,15 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 	return get_unaligned((u64 *)sreg);
 }
 
-static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
-				 unsigned int len)
+static inline void nft_data_copy(struct nft_regs *regs,
+				 const struct nft_data *src,
+				 u32 dreg, unsigned int len)
 {
+	u32 *dst = &regs->data[dreg];
+
 	if (len % NFT_REG32_SIZE)
 		dst[len / NFT_REG32_SIZE] = 0;
+
 	memcpy(dst, src, len);
 }
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index c9d2f7c29f53..ad8393253d33 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -21,7 +21,7 @@ void nft_immediate_eval(const struct nft_expr *expr,
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
-	nft_data_copy(&regs->data[priv->dreg], &priv->data, priv->dlen);
+	nft_data_copy(regs, &priv->data, priv->dreg, priv->dlen);
 }
 
 static const struct nla_policy nft_immediate_policy[NFTA_IMMEDIATE_MAX + 1] = {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cecf8ab90e58..3e3c20e42385 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -75,10 +75,10 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	}
 
 	if (ext) {
-		if (set->flags & NFT_SET_MAP)
-			nft_data_copy(&regs->data[priv->dreg],
-				      nft_set_ext_data(ext), set->dlen);
-
+		if (set->flags & NFT_SET_MAP) {
+			nft_data_copy(regs, nft_set_ext_data(ext), priv->dreg,
+				      set->dlen);
+		}
 		nft_set_elem_update_expr(ext, regs, pkt);
 	}
 }
-- 
2.30.2

