From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: check tprot_set first when we use xt.thoff
Date: Sat, 17 Sep 2016 14:31:20 +0800
Message-ID: <1474093880-21022-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:37978 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752001AbcIQGcC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Sep 2016 02:32:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

pkt->xt.thoff is not always set properly, but we use it without any check.
For payload expr, it will cause wrong results. For nftrace, we may notify
the wrong network or transport header to the user space, furthermore,
input the following nft rules, warning message will be printed out:
  # nft add rule arp filter output meta nftrace set 1

  WARNING: CPU: 0 PID: 13428 at net/netfilter/nf_tables_trace.c:263
  nft_trace_notify+0x4a3/0x5e0 [nf_tables]
  Call Trace:
  [<ffffffff813d58ae>] dump_stack+0x63/0x85
  [<ffffffff810a4c0b>] __warn+0xcb/0xf0
  [<ffffffff810a4d3d>] warn_slowpath_null+0x1d/0x20
  [<ffffffffa0589703>] nft_trace_notify+0x4a3/0x5e0 [nf_tables]
  [ ... ]
  [<ffffffffa05690a8>] nft_do_chain_arp+0x78/0x90 [nf_tables_arp]
  [<ffffffff816f4aa2>] nf_iterate+0x62/0x80
  [<ffffffff816f4b33>] nf_hook_slow+0x73/0xd0
  [<ffffffff81732bbf>] arp_xmit+0x8f/0xb0
  [ ... ]
  [<ffffffff81732d36>] arp_solicit+0x106/0x2c0

So before we use pkt->xt.thoff, check the tprot_set first.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_core.c  |  5 ++++-
 net/netfilter/nf_tables_trace.c | 20 +++++++++++---------
 net/netfilter/nft_payload.c     |  4 ++++
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 36ba4e5..67259ce 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -93,8 +93,11 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
 		ptr = skb_network_header(skb);
-	else
+	else {
+		if (!pkt->tprot_set)
+			return false;
 		ptr = skb_network_header(skb) + pkt->xt.thoff;
+	}
 
 	ptr += priv->offset;
 
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 39eb1cc..696fe8f 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -113,20 +113,22 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 				  const struct nft_pktinfo *pkt)
 {
 	const struct sk_buff *skb = pkt->skb;
-	unsigned int len = min_t(unsigned int,
-				 pkt->xt.thoff - skb_network_offset(skb),
-				 NFT_TRACETYPE_NETWORK_HSIZE);
 	int off = skb_network_offset(skb);
+	unsigned int len, nh_end;
 
+	nh_end = pkt->tprot_set ? pkt->xt.thoff : skb->len;
+	len = min_t(unsigned int, nh_end - skb_network_offset(skb),
+		    NFT_TRACETYPE_NETWORK_HSIZE);
 	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
 		return -1;
 
-	len = min_t(unsigned int, skb->len - pkt->xt.thoff,
-		    NFT_TRACETYPE_TRANSPORT_HSIZE);
-
-	if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
-			      pkt->xt.thoff, len))
-		return -1;
+	if (pkt->tprot_set) {
+		len = min_t(unsigned int, skb->len - pkt->xt.thoff,
+			    NFT_TRACETYPE_TRANSPORT_HSIZE);
+		if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
+				      pkt->xt.thoff, len))
+			return -1;
+	}
 
 	if (!skb_mac_header_was_set(skb))
 		return 0;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 12cd4bf..b2f8861 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -92,6 +92,8 @@ static void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		if (!pkt->tprot_set)
+			goto err;
 		offset = pkt->xt.thoff;
 		break;
 	default:
@@ -184,6 +186,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		if (!pkt->tprot_set)
+			goto err;
 		offset = pkt->xt.thoff;
 		break;
 	default:
-- 
2.5.5


