From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 40/52] netfilter: meta: secpath support
Date: Mon,  8 Jan 2018 21:19:48 +0100
Message-ID: <20180108202000.12989-41-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbeAHUUm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93AB1E7B8A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85CF6664B
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:40 +0100 (CET)
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

replacement for iptables "-m policy --dir in --policy {ipsec,none}".

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 43 ++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a3ee277b17a1..2efbf9744c2a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -777,6 +777,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
+ * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -804,6 +805,7 @@ enum nft_meta_keys {
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
+	NFT_META_SECPATH,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5a60eb23a7ed..1a91e676f13e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -210,6 +210,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = prandom_u32_state(state);
 		break;
 	}
+#ifdef CONFIG_XFRM
+	case NFT_META_SECPATH:
+		nft_reg_store8(dest, !!skb->sp);
+		break;
+#endif
 	default:
 		WARN_ON(1);
 		goto err;
@@ -308,6 +313,11 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
+#ifdef CONFIG_XFRM
+	case NFT_META_SECPATH:
+		len = sizeof(u8);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -318,6 +328,38 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
+static int nft_meta_get_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
+{
+#ifdef CONFIG_XFRM
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	if (priv->key != NFT_META_SECPATH)
+		return 0;
+
+	switch (ctx->afi->family) {
+	case NFPROTO_NETDEV:
+		hooks = 1 << NF_NETDEV_INGRESS;
+		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+#else
+	return 0;
+#endif
+}
+
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data)
@@ -434,6 +476,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.eval		= nft_meta_get_eval,
 	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
+	.validate	= nft_meta_get_validate,
 };
 
 static const struct nft_expr_ops nft_meta_set_ops = {
-- 
2.11.0

