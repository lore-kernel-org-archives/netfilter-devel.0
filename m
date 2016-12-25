From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/2] netfilter: nft_ct: add average bytes per packet support
Date: Sun, 25 Dec 2016 19:58:59 +0800
Message-ID: <1482667139-63731-2-git-send-email-zlpnobody@163.com>
References: <1482667139-63731-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:55828 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753235AbcLYMAA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Dec 2016 07:00:00 -0500
In-Reply-To: <1482667139-63731-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Similar to xt_connbytes, user can match how many average bytes per packet
a connection has transferred so far.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_ct.c                   | 22 +++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5726f90..b00a05d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -863,6 +863,7 @@ enum nft_rt_attributes {
  * @NFT_CT_LABELS: conntrack labels
  * @NFT_CT_PKTS: conntrack packets
  * @NFT_CT_BYTES: conntrack bytes
+ * @NFT_CT_AVGPKT: conntrack average bytes per packet
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -881,6 +882,7 @@ enum nft_ct_keys {
 	NFT_CT_LABELS,
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
+	NFT_CT_AVGPKT,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index e6baeae..d774d78 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -129,6 +129,22 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		memcpy(dest, &count, sizeof(count));
 		return;
 	}
+	case NFT_CT_AVGPKT: {
+		const struct nf_conn_acct *acct = nf_conn_acct_find(ct);
+		u64 avgcnt = 0, bcnt = 0, pcnt = 0;
+
+		if (acct) {
+			pcnt = nft_ct_get_eval_counter(acct->counter,
+						       NFT_CT_PKTS, priv->dir);
+			bcnt = nft_ct_get_eval_counter(acct->counter,
+						       NFT_CT_BYTES, priv->dir);
+			if (pcnt != 0)
+				avgcnt = div64_u64(bcnt, pcnt);
+		}
+
+		memcpy(dest, &avgcnt, sizeof(avgcnt));
+		return;
+	}
 	case NFT_CT_L3PROTOCOL:
 		*dest = nf_ct_l3num(ct);
 		return;
@@ -316,6 +332,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		break;
 	case NFT_CT_BYTES:
 	case NFT_CT_PKTS:
+	case NFT_CT_AVGPKT:
 		/* no direction? return sum of original + reply */
 		if (tb[NFTA_CT_DIRECTION] == NULL)
 			priv->dir = IP_CT_DIR_MAX;
@@ -346,7 +363,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (priv->key == NFT_CT_BYTES || priv->key == NFT_CT_PKTS)
+	if (priv->key == NFT_CT_BYTES ||
+	    priv->key == NFT_CT_PKTS  ||
+	    priv->key == NFT_CT_AVGPKT)
 		nf_ct_set_acct(ctx->net, true);
 
 	return 0;
@@ -445,6 +464,7 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		break;
 	case NFT_CT_BYTES:
 	case NFT_CT_PKTS:
+	case NFT_CT_AVGPKT:
 		if (priv->dir < IP_CT_DIR_MAX &&
 		    nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
 			goto nla_put_failure;
-- 
2.5.5


