From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] nftables: ct: add byte/packet counter support
Date: Thu,  7 Jan 2016 21:34:24 +0100
Message-ID: <1452198864-10134-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46181 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbcAGUlY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 15:41:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the accounting extension isn't present, we'll return a counter
value of 0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 WARNING: It doesn't work, but AFAIU the bug is in nft_cmp which
 doesn't work with u64 and gt/lt test.  Following is true after 1st packet
 is sent with enabled accounting:

 nft add rule filter input ct original packets gt 10

 Seems like it only works for mark, skuid etc because those are u32 and
 thus use the _fast_ops version.

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 22043ce..535576e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -755,6 +755,8 @@ enum nft_ct_keys {
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
 	NFT_CT_LABELS,
+	NFT_CT_PKTS,
+	NFT_CT_BYTES,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8cbca34..dc7a3c6 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
@@ -30,6 +31,19 @@ struct nft_ct {
 	};
 };
 
+static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
+				   enum nft_ct_keys k,
+				   enum ip_conntrack_dir d)
+{
+	if (d == IP_CT_DIR_ORIGINAL ||
+	    d == IP_CT_DIR_REPLY)
+		return k == NFT_CT_BYTES ? atomic64_read(&c[d].bytes) :
+					   atomic64_read(&c[d].packets);
+
+	return nft_ct_get_eval_counter(c, k, IP_CT_DIR_ORIGINAL) +
+	       nft_ct_get_eval_counter(c, k, IP_CT_DIR_REPLY);
+}
+
 static void nft_ct_get_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -114,6 +128,17 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			       NF_CT_LABELS_MAX_SIZE - size);
 		return;
 	}
+	case NFT_CT_BYTES: /* fallthrough */
+	case NFT_CT_PKTS: {
+		const struct nf_conn_acct *acct = nf_conn_acct_find(ct);
+		u64 count = 0;
+
+		if (acct)
+			count = nft_ct_get_eval_counter(acct->counter,
+							priv->key, priv->dir);
+		memcpy(dest, &count, sizeof(count));
+		return;
+	}
 #endif
 	default:
 		break;
@@ -291,6 +316,13 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u.all);
 		break;
+	case NFT_CT_BYTES:
+	case NFT_CT_PKTS:
+		/* no direction? return sum of original + reply */
+		if (tb[NFTA_CT_DIRECTION] == NULL)
+			priv->dir = IP_CT_DIR_MAX;
+		len = sizeof(u64);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -366,6 +398,13 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 
 	switch (priv->key) {
+	case NFT_CT_BYTES:
+	case NFT_CT_PKTS:
+		if ((priv->dir == IP_CT_DIR_ORIGINAL ||
+		     priv->dir == IP_CT_DIR_REPLY) &&
+		     nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
+			goto nla_put_failure;
+		break;
 	case NFT_CT_PROTOCOL:
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-- 
2.4.10

