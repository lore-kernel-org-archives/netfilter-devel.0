From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/6] netfilter: nft_meta: add l4proto support
Date: Fri,  3 Jan 2014 12:16:18 +0000
Message-ID: <1388751378-23272-7-git-send-email-kaber@trash.net>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56525 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaACMQ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:16:28 -0500
In-Reply-To: <1388751378-23272-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For L3-proto independant rules we need to get at the L4 protocol value
directly. Add it to the nft_pktinfo struct and use the meta expression
to retrieve it.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h        | 1 +
 include/net/netfilter/nf_tables_ipv4.h   | 3 ++-
 include/net/netfilter/nf_tables_ipv6.h   | 1 +
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 4 ++++
 5 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f066f25..5d2b703 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -16,6 +16,7 @@ struct nft_pktinfo {
 	const struct nf_hook_ops	*ops;
 	u8				nhoff;
 	u8				thoff;
+	u8				tprot;
 	/* for x_tables compatibility */
 	struct xt_action_param		xt;
 };
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index f7b3a66..cba143f 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -15,8 +15,9 @@ nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
 
 	nft_set_pktinfo(pkt, ops, skb, in, out);
 
-	pkt->xt.thoff = ip_hdrlen(pkt->skb);
 	ip = ip_hdr(pkt->skb);
+	pkt->tprot = ip->protocol;
+	pkt->xt.thoff = ip_hdrlen(pkt->skb);
 	pkt->xt.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 }
 
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 3d8ae48..74d9761 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -21,6 +21,7 @@ nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 	if (protohdr < 0)
 		return -1;
 
+	pkt->tprot = protohdr;
 	pkt->xt.thoff = thoff;
 	pkt->xt.fragoff = frag_off;
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7ec92a9..d557a2c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -530,6 +530,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
  * @NFT_META_NFPROTO: netfilter protocol
+ * @NFT_META_L4PROTO: layer 4 protocol number
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -548,6 +549,7 @@ enum nft_meta_keys {
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
 	NFT_META_NFPROTO,
+	NFT_META_L4PROTO,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 06a4f30..62d8de3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -43,6 +43,9 @@ static void nft_meta_eval(const struct nft_expr *expr,
 	case NFT_META_NFPROTO:
 		dest->data[0] = pkt->ops->pf;
 		break;
+	case NFT_META_L4PROTO:
+		dest->data[0] = pkt->tprot;
+		break;
 	case NFT_META_PRIORITY:
 		dest->data[0] = skb->priority;
 		break;
@@ -155,6 +158,7 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	case NFT_META_LEN:
 	case NFT_META_PROTOCOL:
 	case NFT_META_NFPROTO:
+	case NFT_META_L4PROTO:
 	case NFT_META_PRIORITY:
 	case NFT_META_MARK:
 	case NFT_META_IIF:
-- 
1.8.4.2

