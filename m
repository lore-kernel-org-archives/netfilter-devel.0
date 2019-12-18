Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBA1C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA6AC21D7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLRLGI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:06:08 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36008 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfLRLGI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:06:08 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX9Z-00078w-V7; Wed, 18 Dec 2019 12:06:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Willi <martin@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>
Subject: [PATCH nf-next 9/9] netfilter: nft_meta: add support for slave device ifindex matching
Date:   Wed, 18 Dec 2019 12:05:21 +0100
Message-Id: <20191218110521.14048-10-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to match on vrf slave ifindex or name.

In case there was no slave interface involved, store 0 in the
destination register just like existing iif/oif matching.

sdif(name) is restricted to the ipv4/ipv6 input and forward hooks,
as it depends on ip(6) stack parsing/storing info in skb->cb[].

Cc: Martin Willi <martin@strongswan.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Shrijeet Mukherjee <shrijeet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_meta.c                 | 76 +++++++++++++++++++++---
 2 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049310df..e237ecbdcd8a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -805,6 +805,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
  * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
+ * @NFT_META_SDIF: slave device interface index
+ * @NFT_META_SDIFNAME: slave device interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -840,6 +842,8 @@ enum nft_meta_keys {
 	NFT_META_TIME_NS,
 	NFT_META_TIME_DAY,
 	NFT_META_TIME_HOUR,
+	NFT_META_SDIF,
+	NFT_META_SDIFNAME,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fb1a571db924..951b6e87ed5d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -17,6 +17,7 @@
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
+#include <net/ip.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
@@ -287,6 +288,28 @@ nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 }
 #endif
 
+static noinline u32 nft_meta_get_eval_sdif(const struct nft_pktinfo *pkt)
+{
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		return inet_sdif(pkt->skb);
+	case NFPROTO_IPV6:
+		return inet6_sdif(pkt->skb);
+	}
+
+	return 0;
+}
+
+static noinline void
+nft_meta_get_eval_sdifname(u32 *dest, const struct nft_pktinfo *pkt)
+{
+	u32 sdif = nft_meta_get_eval_sdif(pkt);
+	const struct net_device *dev;
+
+	dev = sdif ? dev_get_by_index_rcu(nft_net(pkt), sdif) : NULL;
+	nft_meta_store_ifname(dest, dev);
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -379,6 +402,12 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_TIME_HOUR:
 		nft_meta_get_eval_time(priv->key, dest);
 		break;
+	case NFT_META_SDIF:
+		*dest = nft_meta_get_eval_sdif(pkt);
+		break;
+	case NFT_META_SDIFNAME:
+		nft_meta_get_eval_sdifname(dest, pkt);
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -459,6 +488,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_MARK:
 	case NFT_META_IIF:
 	case NFT_META_OIF:
+	case NFT_META_SDIF:
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -480,6 +510,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_OIFNAME:
 	case NFT_META_IIFKIND:
 	case NFT_META_OIFKIND:
+	case NFT_META_SDIFNAME:
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
@@ -510,16 +541,28 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
-static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+static int nft_meta_get_validate_sdif(const struct nft_ctx *ctx)
 {
-#ifdef CONFIG_XFRM
-	const struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
-	if (priv->key != NFT_META_SECPATH)
-		return 0;
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
+static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
+{
+#ifdef CONFIG_XFRM
+	unsigned int hooks;
 
 	switch (ctx->family) {
 	case NFPROTO_NETDEV:
@@ -542,6 +585,25 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 #endif
 }
 
+static int nft_meta_get_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	switch (priv->key) {
+	case NFT_META_SECPATH:
+		return nft_meta_get_validate_xfrm(ctx);
+	case NFT_META_SDIF:
+	case NFT_META_SDIFNAME:
+		return nft_meta_get_validate_sdif(ctx);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data)
-- 
2.24.1

