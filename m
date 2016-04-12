From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v5 nf-next 1/4] netfilter: connlabels: move helpers to xt_connlabel
Date: Tue, 12 Apr 2016 18:14:23 +0200
Message-ID: <1460477666-17823-2-git-send-email-fw@strlen.de>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37352 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbcDLQOR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 12:14:17 -0400
In-Reply-To: <1460477666-17823-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently labels can only be set either by iptables connlabel
match or via ctnetlink.

Before adding nftables set support, clean up the clabel core and move
helpers that nft will not need after all to the xtables module.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since last iteration.

 include/net/netfilter/nf_conntrack_labels.h |  1 -
 net/netfilter/nf_conntrack_labels.c         | 19 +------------------
 net/netfilter/xt_connlabel.c                | 12 +++++++++++-
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 7e2b1d0..5167818 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -45,7 +45,6 @@ static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
 #endif
 }
 
-bool nf_connlabel_match(const struct nf_conn *ct, u16 bit);
 int nf_connlabel_set(struct nf_conn *ct, u16 bit);
 
 int nf_connlabels_replace(struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 3ce5c31..3a30900 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -16,28 +16,11 @@
 
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
 int nf_connlabel_set(struct nf_conn *ct, u16 bit)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
 
-	if (!labels || bit >= label_bits(labels))
+	if (!labels || BIT_WORD(bit) >= labels->words)
 		return -ENOSPC;
 
 	if (test_bit(bit, labels->bits))
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index bb9cbeb..d9b3e53 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -18,6 +18,16 @@ MODULE_DESCRIPTION("Xtables: add/match connection trackling labels");
 MODULE_ALIAS("ipt_connlabel");
 MODULE_ALIAS("ip6t_connlabel");
 
+static bool connlabel_match(const struct nf_conn *ct, u16 bit)
+{
+	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
+
+	if (!labels)
+		return false;
+
+	return BIT_WORD(bit) < labels->words && test_bit(bit, labels->bits);
+}
+
 static bool
 connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -33,7 +43,7 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (info->options & XT_CONNLABEL_OP_SET)
 		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
 
-	return nf_connlabel_match(ct, info->bit) ^ invert;
+	return connlabel_match(ct, info->bit) ^ invert;
 }
 
 static int connlabel_mt_check(const struct xt_mtchk_param *par)
-- 
2.7.3

