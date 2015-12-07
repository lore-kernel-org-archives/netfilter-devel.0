From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: connlabels: move helpers to xt_connlabel
Date: Mon,  7 Dec 2015 13:05:06 +0100
Message-ID: <1449489908-10205-2-git-send-email-fw@strlen.de>
References: <1449489908-10205-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37329 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbbLGMFP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Dec 2015 07:05:15 -0500
In-Reply-To: <1449489908-10205-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently labels can only be set either by iptables connlabel
match or via ctnetlink.

Before adding nftables set support, clean up the clabel core and move
helpers that nft will not need after all to the xtables module.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_labels.h |  3 ---
 net/netfilter/nf_conntrack_labels.c         | 34 --------------------------
 net/netfilter/xt_connlabel.c                | 38 +++++++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 7e2b1d0..d2ac647 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -45,9 +45,6 @@ static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
 #endif
 }
 
-bool nf_connlabel_match(const struct nf_conn *ct, u16 bit);
-int nf_connlabel_set(struct nf_conn *ct, u16 bit);
-
 int nf_connlabels_replace(struct nf_conn *ct,
 			  const u32 *data, const u32 *mask, unsigned int words);
 
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 3ce5c31..005ddf6 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -16,40 +16,6 @@
 
 static spinlock_t nf_connlabels_lock;
 
-static unsigned int label_bits(const struct nf_conn_labels *l)
-{
-	unsigned int longs = l->words;
-	return longs * BITS_PER_LONG;
-}
-
-bool nf_connlabel_match(const struct nf_conn *ct, u16 bit)
-{
-	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
-
-	if (!labels)
-		return false;
-
-	return bit < label_bits(labels) && test_bit(bit, labels->bits);
-}
-EXPORT_SYMBOL_GPL(nf_connlabel_match);
-
-int nf_connlabel_set(struct nf_conn *ct, u16 bit)
-{
-	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
-
-	if (!labels || bit >= label_bits(labels))
-		return -ENOSPC;
-
-	if (test_bit(bit, labels->bits))
-		return 0;
-
-	if (!test_and_set_bit(bit, labels->bits))
-		nf_conntrack_event_cache(IPCT_LABEL, ct);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_connlabel_set);
-
 static void replace_u32(u32 *address, u32 mask, u32 new)
 {
 	u32 old, tmp;
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index bb9cbeb..e0679c4 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_labels.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
@@ -18,6 +19,39 @@ MODULE_DESCRIPTION("Xtables: add/match connection trackling labels");
 MODULE_ALIAS("ipt_connlabel");
 MODULE_ALIAS("ip6t_connlabel");
 
+static unsigned int label_bits(const struct nf_conn_labels *l)
+{
+	unsigned int longs = l->words;
+
+	return longs * BITS_PER_LONG;
+}
+
+static bool connlabel_match(const struct nf_conn *ct, u16 bit)
+{
+	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
+
+	if (!labels)
+		return false;
+
+	return bit < label_bits(labels) && test_bit(bit, labels->bits);
+}
+
+static int connlabel_set(struct nf_conn *ct, u16 bit)
+{
+	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
+
+	if (!labels || bit >= label_bits(labels))
+		return -ENOSPC;
+
+	if (test_bit(bit, labels->bits))
+		return 0;
+
+	if (!test_and_set_bit(bit, labels->bits))
+		nf_conntrack_event_cache(IPCT_LABEL, ct);
+
+	return 0;
+}
+
 static bool
 connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -31,9 +65,9 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return invert;
 
 	if (info->options & XT_CONNLABEL_OP_SET)
-		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
+		return (connlabel_set(ct, info->bit) == 0) ^ invert;
 
-	return nf_connlabel_match(ct, info->bit) ^ invert;
+	return connlabel_match(ct, info->bit) ^ invert;
 }
 
 static int connlabel_mt_check(const struct xt_mtchk_param *par)
-- 
2.4.10

