From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nft_ct: allow to set ctnetlink event types of a connection
Date: Sat, 15 Apr 2017 10:45:03 +0200
Message-ID: <20170415084505.26176-2-fw@strlen.de>
References: <20170415084505.26176-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdDOIov (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 04:44:51 -0400
In-Reply-To: <20170415084505.26176-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

by default the kernel emits all ctnetlink events for a connection.
This allows to select the types of events to generate for a connection.

This allows to e.g. only send DESTROY events but no NEW/UPDATE ones.

This was already possible via iptables' CT target.
The nft version has the advantage that it can also be used with
already-established conntracks.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_ct.c                   | 19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8f3842690d17..683f6f88fcac 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -901,6 +901,7 @@ enum nft_rt_attributes {
  * @NFT_CT_BYTES: conntrack bytes
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
  * @NFT_CT_ZONE: conntrack zone
+ * @NFT_CT_EVENTMASK: ctnetlink events to be generated for this conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -921,6 +922,7 @@ enum nft_ct_keys {
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
 	NFT_CT_ZONE,
+	NFT_CT_EVENTMASK,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 6e23dbbedd7f..4f642977f8a5 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -264,7 +264,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
+	if (ct == NULL || nf_ct_is_template(ct))
 		return;
 
 	switch (priv->key) {
@@ -284,6 +284,16 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 				      NF_CT_LABELS_MAX_SIZE / sizeof(u32));
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	case NFT_CT_EVENTMASK: {
+		struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
+		u16 ctmask = (u16)regs->data[priv->sreg];
+
+		if (e && e->ctmask != ctmask)
+			e->ctmask = ctmask;
+		break;
+	}
+#endif
 	default:
 		break;
 	}
@@ -539,6 +549,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		len = sizeof(u16);
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	case NFT_CT_EVENTMASK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+		len = sizeof(u32);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.10.2

