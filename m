Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0F6C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 13:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiFWNFn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiFWNFn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 09:05:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8518F403D1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 06:05:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4MWj-0005ZP-2S; Thu, 23 Jun 2022 15:05:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/6] netfilter: nf_tables: add and use BE register load-store helpers
Date:   Thu, 23 Jun 2022 15:05:12 +0200
Message-Id: <20220623130514.13775-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623130514.13775-1-fw@strlen.de>
References: <20220623130514.13775-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as the existing ones, no conversions. This is just for sparse sake
only so that we no longer mix be16/u16 and be32/u32 types.

Alternative is to add __force __beX in various places, but this
seems nicer.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h      | 15 +++++++++++++++
 net/bridge/netfilter/nft_meta_bridge.c |  2 +-
 net/netfilter/nft_tproxy.c             |  6 +++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 279ae0fff7ad..e6a16663cf82 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -157,11 +157,26 @@ static inline void nft_reg_store16(u32 *dreg, u16 val)
 	*(u16 *)dreg = val;
 }
 
+static inline void nft_reg_store_be16(u32 *dreg, __be16 val)
+{
+	nft_reg_store16(dreg, (__force __u16)val);
+}
+
 static inline u16 nft_reg_load16(const u32 *sreg)
 {
 	return *(u16 *)sreg;
 }
 
+static inline __be16 nft_reg_load_be16(const u32 *sreg)
+{
+	return (__force __be16)nft_reg_load16(sreg);
+}
+
+static inline __be32 nft_reg_load_be32(const u32 *sreg)
+{
+	return *(__force __be32 *)sreg;
+}
+
 static inline void nft_reg_store64(u32 *dreg, u64 val)
 {
 	put_unaligned(val, (u64 *)dreg);
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 8c3eaba87ad2..c3ecd77e25cb 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -53,7 +53,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store16(dest, htons(p_proto));
+		nft_reg_store_be16(dest, htons(p_proto));
 		return;
 	}
 	default:
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 801f013971df..68b2eed742df 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -52,11 +52,11 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
 
 	if (priv->sreg_addr)
-		taddr = regs->data[priv->sreg_addr];
+		taddr = nft_reg_load_be32(&regs->data[priv->sreg_addr]);
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -124,7 +124,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
+		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.35.1

