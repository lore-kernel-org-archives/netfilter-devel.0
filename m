Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9841CC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7453B21D7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLRLFz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:05:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35996 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbfLRLFz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:05:55 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX9N-00078M-Dv; Wed, 18 Dec 2019 12:05:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/9] netfilter: nft_meta: move all interface related keys to helper
Date:   Wed, 18 Dec 2019 12:05:18 +0100
Message-Id: <20191218110521.14048-7-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reduces repetiveness and reduces size of meta eval function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 95 +++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 2f7cc64b0c15..022f1473ddd1 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -199,13 +199,79 @@ static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
 	return true;
 }
 
+static void nft_meta_store_ifindex(u32 *dest, const struct net_device *dev)
+{
+	*dest = dev ? dev->ifindex : 0;
+}
+
+static void nft_meta_store_ifname(u32 *dest, const struct net_device *dev)
+{
+	strncpy((char *)dest, dev ? dev->name : "", IFNAMSIZ);
+}
+
+static bool nft_meta_store_iftype(u32 *dest, const struct net_device *dev)
+{
+	if (!dev)
+		return false;
+
+	nft_reg_store16(dest, dev->type);
+	return true;
+}
+
+static bool nft_meta_store_ifgroup(u32 *dest, const struct net_device *dev)
+{
+	if (!dev)
+		return false;
+
+	*dest = dev->group;
+	return true;
+}
+
+static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
+				     const struct nft_pktinfo *pkt)
+{
+	switch (key) {
+	case NFT_META_IIFNAME:
+		nft_meta_store_ifname(dest, nft_in(pkt));
+		break;
+	case NFT_META_OIFNAME:
+		nft_meta_store_ifname(dest, nft_out(pkt));
+		break;
+	case NFT_META_IIF:
+		nft_meta_store_ifindex(dest, nft_in(pkt));
+		break;
+	case NFT_META_OIF:
+		nft_meta_store_ifindex(dest, nft_out(pkt));
+		break;
+	case NFT_META_IIFTYPE:
+		if (!nft_meta_store_iftype(dest, nft_in(pkt)))
+			return false;
+		break;
+	case NFT_META_OIFTYPE:
+		if (!nft_meta_store_iftype(dest, nft_out(pkt)))
+			return false;
+		break;
+	case NFT_META_IIFGROUP:
+		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+			return false;
+		break;
+	case NFT_META_OIFGROUP:
+		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	u32 *dest = &regs->data[priv->dreg];
 
 	switch (priv->key) {
@@ -230,26 +296,15 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->mark;
 		break;
 	case NFT_META_IIF:
-		*dest = in ? in->ifindex : 0;
-		break;
 	case NFT_META_OIF:
-		*dest = out ? out->ifindex : 0;
-		break;
 	case NFT_META_IIFNAME:
-		strncpy((char *)dest, in ? in->name : "", IFNAMSIZ);
-		break;
 	case NFT_META_OIFNAME:
-		strncpy((char *)dest, out ? out->name : "", IFNAMSIZ);
-		break;
 	case NFT_META_IIFTYPE:
-		if (in == NULL)
-			goto err;
-		nft_reg_store16(dest, in->type);
-		break;
 	case NFT_META_OIFTYPE:
-		if (out == NULL)
+	case NFT_META_IIFGROUP:
+	case NFT_META_OIFGROUP:
+		if (!nft_meta_get_eval_ifname(priv->key, dest, pkt))
 			goto err;
-		nft_reg_store16(dest, out->type);
 		break;
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
@@ -283,16 +338,6 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_CPU:
 		*dest = raw_smp_processor_id();
 		break;
-	case NFT_META_IIFGROUP:
-		if (in == NULL)
-			goto err;
-		*dest = in->group;
-		break;
-	case NFT_META_OIFGROUP:
-		if (out == NULL)
-			goto err;
-		*dest = out->group;
-		break;
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
 		if (!nft_meta_get_eval_cgroup(dest, pkt))
-- 
2.24.1

