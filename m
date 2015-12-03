From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: meta: add support for setting skb->pkttype
Date: Thu,  3 Dec 2015 16:56:41 +0100
Message-ID: <1449158201-23868-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53836 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbbLCP4w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 10:56:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to redirect bridged packets to local machine.

ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast

Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Hi Patrick,

 as discussed this adds meta set support for pkttype.

 I'm not sure how restricted it should be; this only allows
 changing PACKET_OTHERHOST to something else, but I'm not sure
 if this should do more checks on value (e.g. only allow
 PACKET_HOST?) or even less (e.g. also allow mangling
 mcast and the like?).

 It only allows NETDEV and BRIDGE families but thats mainly
 because the other ones make no sense (PACKET_OTHERHOST
 cannot happen w. IPV4, 6, INET since stack already drops them earlier).

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9dfaf4d..3d64742 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -24,6 +24,8 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
 
+#include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -203,6 +205,10 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 	case NFT_META_PRIORITY:
 		skb->priority = value;
 		break;
+	case NFT_META_PKTTYPE:
+		if (skb->pkt_type == PACKET_OTHERHOST)
+			skb->pkt_type = value;
+		break;
 	case NFT_META_NFTRACE:
 		skb->nf_trace = 1;
 		break;
@@ -271,6 +277,24 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
+static int nft_meta_set_init_pkttype(const struct nft_ctx *ctx)
+{
+	unsigned int hooks;
+
+	switch (ctx->afi->family) {
+	case NFPROTO_BRIDGE:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	case NFPROTO_NETDEV:
+		hooks = 1 << NF_NETDEV_INGRESS;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 int nft_meta_set_init(const struct nft_ctx *ctx,
 		      const struct nft_expr *expr,
 		      const struct nlattr * const tb[])
@@ -288,6 +312,12 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 	case NFT_META_NFTRACE:
 		len = sizeof(u8);
 		break;
+	case NFT_META_PKTTYPE:
+		err = nft_meta_set_init_pkttype(ctx);
+		if (err)
+			return err;
+		len = sizeof(u8);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.4.10

