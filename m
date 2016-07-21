From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] netfilter: connlabels: move set helper to xt_connlabel
Date: Thu, 21 Jul 2016 12:51:17 +0200
Message-ID: <1469098277-1227-3-git-send-email-fw@strlen.de>
References: <1469098277-1227-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57283 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbcGUKvH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 06:51:07 -0400
In-Reply-To: <1469098277-1227-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_connlabel is the only user so move it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_labels.h |  2 --
 net/netfilter/nf_conntrack_labels.c         | 17 -----------------
 net/netfilter/xt_connlabel.c                | 29 ++++++++++++++++-------------
 3 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 0fd4989..4988146 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -37,8 +37,6 @@ static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
 #endif
 }
 
-int nf_connlabel_set(struct nf_conn *ct, u16 bit);
-
 int nf_connlabels_replace(struct nf_conn *ct,
 			  const u32 *data, const u32 *mask, unsigned int words);
 
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 7686200..bcab8bd 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -16,23 +16,6 @@
 
 static spinlock_t nf_connlabels_lock;
 
-int nf_connlabel_set(struct nf_conn *ct, u16 bit)
-{
-	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
-
-	if (!labels)
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
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
 	u32 old, tmp;
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index c9fba8a..03d66f1 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <linux/netfilter/x_tables.h>
 
@@ -18,21 +19,12 @@ MODULE_DESCRIPTION("Xtables: add/match connection trackling labels");
 MODULE_ALIAS("ipt_connlabel");
 MODULE_ALIAS("ip6t_connlabel");
 
-static bool connlabel_match(const struct nf_conn *ct, u16 bit)
-{
-	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
-
-	if (!labels)
-		return false;
-
-	return test_bit(bit, labels->bits);
-}
-
 static bool
 connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connlabel_mtinfo *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
+	struct nf_conn_labels *labels;
 	struct nf_conn *ct;
 	bool invert = info->options & XT_CONNLABEL_OP_INVERT;
 
@@ -40,10 +32,21 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ct == NULL || nf_ct_is_untracked(ct))
 		return invert;
 
-	if (info->options & XT_CONNLABEL_OP_SET)
-		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
+	labels = nf_ct_labels_find(ct);
+	if (!labels)
+		return invert;
+
+	if (test_bit(info->bit, labels->bits))
+		return !invert;
+
+	if (info->options & XT_CONNLABEL_OP_SET) {
+		if (!test_and_set_bit(info->bit, labels->bits))
+			nf_conntrack_event_cache(IPCT_LABEL, ct);
+
+		return !invert;
+	}
 
-	return connlabel_match(ct, info->bit) ^ invert;
+	return invert;
 }
 
 static int connlabel_mt_check(const struct xt_mtchk_param *par)
-- 
2.7.3

