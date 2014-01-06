From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon,  6 Jan 2014 17:57:56 +0100
Message-ID: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52381 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFQ6F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:58:05 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so7916795eaj.37
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 08:58:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch enables connmark to be set/retrieved using meta
expressions/statements.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 34 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa86a152..05eaeb9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -531,6 +531,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_NFTRACE: packet nftrace bit
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
+ * @NFT_META_CONNMARK: used to get/set the connection mark
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -548,6 +549,7 @@ enum nft_meta_keys {
 	NFT_META_NFTRACE,
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
+	NFT_META_CONNMARK,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 1ceaaa6..07ae212 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -18,6 +18,8 @@
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 struct nft_meta {
 	enum nft_meta_keys	key:8;
@@ -35,6 +37,10 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 	const struct sk_buff *skb = pkt->skb;
 	const struct net_device *in = pkt->in, *out = pkt->out;
 	struct nft_data *dest = &data[priv->dreg];
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+#endif
 
 	switch (priv->key) {
 	case NFT_META_LEN:
@@ -125,6 +131,15 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 		dest->data[0] = skb->secmark;
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_META_CONNMARK:
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct != NULL)
+			dest->data[0] = ct->mark;
+		else
+			dest->data[0] = 0;
+		break;
+#endif
 	default:
 		WARN_ON(1);
 		goto err;
@@ -142,6 +157,10 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 	u32 value = data[meta->sreg].data[0];
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+#endif
 
 	switch (meta->key) {
 	case NFT_META_MARK:
@@ -153,6 +172,15 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 	case NFT_META_NFTRACE:
 		skb->nf_trace = 1;
 		break;
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_META_CONNMARK:
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct != NULL && ct->mark != value) {
+			ct->mark = value;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+#endif
 	default:
 		WARN_ON(1);
 	}
@@ -170,6 +198,9 @@ static int nft_meta_init_validate_set(uint32_t key)
 	case NFT_META_MARK:
 	case NFT_META_PRIORITY:
 	case NFT_META_NFTRACE:
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_META_CONNMARK:
+#endif
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -197,6 +228,9 @@ static int nft_meta_init_validate_get(uint32_t key)
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_META_CONNMARK:
+#endif
 		return 0;
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.3.2

