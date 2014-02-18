From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3 -next] netfilter: nft_ct: labels get support
Date: Tue, 18 Feb 2014 10:27:22 +0100
Message-ID: <1392715644-4458-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52421 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbaBRJbR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:31:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Takes advantage of the fact that the number of labels is currently
restricted to 2**128, ie. the extension area will always fit into
nft register.

Patrick says the kernel registers need to be changed anyway to
deal with concatentations so we will probably not run into issues
when the number of labels increases in a future kernel release.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_ct.c                   | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 83c985a..c84c452 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -601,6 +601,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
+	NFT_CT_LABELS,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 917052e..cb0ffd2 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_labels.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -97,6 +98,24 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest->data, helper->name, sizeof(dest->data));
 		return;
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS: {
+		struct nf_conn_labels *labels = nf_ct_labels_find(ct);
+		unsigned int size;
+
+		if (!labels)
+			goto err;
+		size = labels->words * sizeof(long);
+		if (size > sizeof(dest->data))
+			goto err;
+		memcpy(dest->data, labels->bits, size);
+
+		if (size < sizeof(dest->data))
+			memset(((char *) dest->data) + size, 0,
+			       sizeof(dest->data) - size);
+		return;
+	}
+#endif
 	}
 
 	tuple = &ct->tuplehash[priv->dir].tuple;
@@ -221,6 +240,9 @@ static int nft_ct_init_validate_get(const struct nft_expr *expr,
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	case NFT_CT_SECMARK:
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+#endif
 	case NFT_CT_EXPIRATION:
 	case NFT_CT_HELPER:
 		if (tb[NFTA_CT_DIRECTION] != NULL)
-- 
1.8.1.5

