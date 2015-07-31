From: Joe Stringer <joestringer@nicira.com>
Subject: [PATCH nf-next] netfilter: connlabels: Export setting connlabel length
Date: Fri, 31 Jul 2015 16:50:24 -0700
Message-ID: <1438386624-52057-1-git-send-email-joestringer@nicira.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34636 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbGaXui (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jul 2015 19:50:38 -0400
Received: by pacan13 with SMTP id an13so48853034pac.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2015 16:50:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add functions to change connlabel length into nf_conntrack_labels.c so
they may be reused by other modules like OVS and nftables without
needing to jump through xt_match_check() hoops.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 include/net/netfilter/nf_conntrack_labels.h |  4 ++++
 net/netfilter/nf_conntrack_labels.c         | 24 ++++++++++++++++++++++++
 net/netfilter/xt_connlabel.c                | 15 ++-------------
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index dec6336..7e2b1d0 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -54,7 +54,11 @@ int nf_connlabels_replace(struct nf_conn *ct,
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 int nf_conntrack_labels_init(void);
 void nf_conntrack_labels_fini(void);
+int nf_connlabels_get(struct net *net, unsigned int n_bits);
+void nf_connlabels_put(struct net *net);
 #else
 static inline int nf_conntrack_labels_init(void) { return 0; }
 static inline void nf_conntrack_labels_fini(void) {}
+static inline int nf_connlabels_get(struct net *net, unsigned int n_bits) { return 0; }
+static inline void nf_connlabels_put(struct net *net) {}
 #endif
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index bb53f12..00df4e71 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -91,6 +91,30 @@ int nf_connlabels_replace(struct nf_conn *ct,
 EXPORT_SYMBOL_GPL(nf_connlabels_replace);
 #endif
 
+int nf_connlabels_get(struct net *net, unsigned int n_bits)
+{
+	size_t words;
+
+	if (n_bits > XT_CONNLABEL_MAXBIT + 1)
+		return -ERANGE;
+
+	net->ct.labels_used++;
+	words = BITS_TO_LONGS(n_bits);
+	if (words > net->ct.label_words)
+		net->ct.label_words = words;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_connlabels_get);
+
+void nf_connlabels_put(struct net *net)
+{
+	net->ct.labels_used--;
+	if (net->ct.labels_used == 0)
+		net->ct.label_words = 0;
+}
+EXPORT_SYMBOL_GPL(nf_connlabels_put);
+
 static struct nf_ct_ext_type labels_extend __read_mostly = {
 	.len    = sizeof(struct nf_conn_labels),
 	.align  = __alignof__(struct nf_conn_labels),
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 9f8719d..f8bb936 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -42,10 +42,6 @@ static int connlabel_mt_check(const struct xt_mtchk_param *par)
 			    XT_CONNLABEL_OP_SET;
 	struct xt_connlabel_mtinfo *info = par->matchinfo;
 	int ret;
-	size_t words;
-
-	if (info->bit > XT_CONNLABEL_MAXBIT)
-		return -ERANGE;
 
 	if (info->options & ~options) {
 		pr_err("Unknown options in mask %x\n", info->options);
@@ -59,19 +55,12 @@ static int connlabel_mt_check(const struct xt_mtchk_param *par)
 		return ret;
 	}
 
-	par->net->ct.labels_used++;
-	words = BITS_TO_LONGS(info->bit+1);
-	if (words > par->net->ct.label_words)
-		par->net->ct.label_words = words;
-
-	return ret;
+	return nf_connlabels_get(par->net, info->bit + 1);
 }
 
 static void connlabel_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	par->net->ct.labels_used--;
-	if (par->net->ct.labels_used == 0)
-		par->net->ct.label_words = 0;
+	nf_connlabels_put(par->net);
 	nf_ct_l3proto_module_put(par->family);
 }
 
-- 
2.1.4

