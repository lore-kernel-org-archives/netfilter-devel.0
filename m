From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv2 1/4] netfilter: bridge: refactor frag_max_size
Date: Sat, 30 May 2015 15:28:28 +0200
Message-ID: <1432992508-4092-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.135]:32487 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbbE3N26 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 May 2015 09:28:58 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 531131107EEC
	for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2015 15:28:57 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently frag_max_size is member of br_input_skb_cb and copied back and
forth using IPCB(skb) and BR_INPUT_SKB_CB(skb) each time it is changed or
used.

Attach frag_max_size to nf_bridge_info and set value in pre_routing and
forward functions. Use its value in forward and xmit functions.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v2
* put this patch in front of patch series about IPv6 fragmentation

 include/linux/skbuff.h    |    1 +
 net/bridge/br_netfilter.c |   20 +++++++-------------
 net/bridge/br_private.h   |    1 -
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5b57cee..90b62a2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -174,6 +174,7 @@ struct nf_bridge_info {
 		BRNF_PROTO_PPPOE
 	} orig_proto:8;
 	bool			pkt_otherhost;
+	__u16			frag_max_size;
 	unsigned int		mask;
 	struct net_device	*physindev;
 	union {
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 9ac0c64..1f30b28 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -440,10 +440,8 @@ static int br_nf_pre_routing_finish(struct sock *sk, struct sk_buff *skb)
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct rtable *rt;
 	int err;
-	int frag_max_size;
 
-	frag_max_size = IPCB(skb)->frag_max_size;
-	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+	nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
 
 	if (nf_bridge->pkt_otherhost) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -738,11 +736,9 @@ static int br_nf_forward_finish(struct sock *sk, struct sk_buff *skb)
 	struct net_device *in;
 
 	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
-		int frag_max_size;
 
 		if (skb->protocol == htons(ETH_P_IP)) {
-			frag_max_size = IPCB(skb)->frag_max_size;
-			BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
 		}
 
 		in = nf_bridge->physindev;
@@ -806,12 +802,9 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	}
 
 	if (pf == NFPROTO_IPV4) {
-		int frag_max = BR_INPUT_SKB_CB(skb)->frag_max_size;
-
 		if (br_parse_ip_options(skb))
 			return NF_DROP;
-
-		IPCB(skb)->frag_max_size = frag_max;
+		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 	}
 
 	nf_bridge->physoutdev = skb->dev;
@@ -904,7 +897,7 @@ static int br_nf_ip_fragment(struct sock *sk, struct sk_buff *skb,
 static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 {
 	int ret;
-	int frag_max_size;
+	struct nf_bridge_info *nf_bridge;
 	unsigned int mtu_reserved;
 
 	if (skb_is_gso(skb) || skb->protocol != htons(ETH_P_IP)) {
@@ -913,17 +906,18 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 	}
 
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
+	nf_bridge = nf_bridge_info_get(skb);
 	/* This is wrong! We should preserve the original fragment
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
 	if (skb->len + mtu_reserved > skb->dev->mtu) {
 		struct brnf_frag_data *data;
 
-		frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
 		if (br_parse_ip_options(skb))
 			/* Drop invalid packet */
 			return NF_DROP;
-		IPCB(skb)->frag_max_size = frag_max_size;
+
+		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
 		nf_bridge_update_protocol(skb);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f36fa7..8cde96e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -304,7 +304,6 @@ struct br_input_skb_cb {
 	int mrouters_only;
 #endif
 
-	u16 frag_max_size;
 	bool proxyarp_replied;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-- 
1.7.10.4

