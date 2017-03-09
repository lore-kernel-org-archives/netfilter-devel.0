From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: bridge: honor frag_max_size when refragmenting
Date: Thu,  9 Mar 2017 23:22:30 +0100
Message-ID: <20170309222230.2190-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44612 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753110AbdCIWWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 17:22:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

consider a bridge with mtu 9000, but end host sending smaller
packets to another host with mtu < 9000.

In this case, after reassembly, bridge+defrag would refragment,
and then attempt to send the reassembled packet as long as it
was below 9k.

Instead we have to cap by the largest fragment size seen.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 changes since v1:
  only use nonzero frag_max_size, else non-fragmented packets won't
  be forwarded anymore.

 tested in kvm with both ipv4 and ipv6 and following setup:
 client (mtu 1500)  --- bridge(mtu 9k) --- client (mtu 1500)
 bridge (incl. all ports) have 9k mtu.

 I tested ping & ping6 with sizes of 64, 8000, 32000.
 Without patch, 8000-sized packets are dropped on the bridge.
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 95087e6e8258..3c5185021c1c 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -721,18 +721,20 @@ static unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
 
 static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge;
-	unsigned int mtu_reserved;
+	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	unsigned int mtu, mtu_reserved;
 
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
+	mtu = skb->dev->mtu;
+
+	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
+		mtu = nf_bridge->frag_max_size;
 
-	if (skb_is_gso(skb) || skb->len + mtu_reserved <= skb->dev->mtu) {
+	if (skb_is_gso(skb) || skb->len + mtu_reserved <= mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(net, sk, skb);
 	}
 
-	nf_bridge = nf_bridge_info_get(skb);
-
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
-- 
2.10.2

