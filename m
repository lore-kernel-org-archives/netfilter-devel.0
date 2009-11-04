From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Wed, 04 Nov 2009 20:05:48 +0100
Message-ID: <4AF1D08C.2030907@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020400010200060700060707"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:47565 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZKDTFw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:05:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020400010200060700060707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The attached patch does the following:
1. fix a bug introduced in commit 
9d02002d2dc2c7423e5891b97727fde4d667adf1 (2/10/2006) which made 
ipt_REJECT stop work for bridged traffic (use of nskb instead of oldskb)
2. use the correct source MAC address for the response (bug reported in 
bug 531 of netfilter's bugzilla)

Tested for plain IP traffic and IP traffic encapsulated inside a VLAN 
header (should also work for PPPoE encapsulated IP traffic).


Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be


--------------020400010200060700060707
Content-Type: text/plain;
 name="ipt_REJECT_use_correct_SMAC.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_REJECT_use_correct_SMAC.diff"

--- linux-2.6.31-uml/include/linux/netfilter_bridge.h.ori	2009-11-02 20:58:59.000000000 +0100
+++ linux-2.6.31-uml/include/linux/netfilter_bridge.h	2009-11-02 19:58:09.000000000 +0100
@@ -44,6 +44,7 @@ enum nf_br_hook_priorities {
 #define BRNF_DONT_TAKE_PARENT		0x04
 #define BRNF_BRIDGED			0x08
 #define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_COPY_MAC_SADDR		0x20
 
 
 /* Only used in br_forward.c */
@@ -77,6 +78,15 @@ static inline unsigned int nf_bridge_pad
 	return 0;
 }
 
+static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
+{
+	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (likely(skb->nf_bridge))
+		atomic_set(&(skb->nf_bridge->use), 1);
+
+	return skb->nf_bridge;
+}
+
 struct bridge_skb_cb {
 	union {
 		__be32 ipv4;
--- linux-2.6.31-uml/net/bridge/br_netfilter.c.fixed	2009-11-02 21:22:00.000000000 +0100
+++ linux-2.6.31-uml/net/bridge/br_netfilter.c	2009-11-03 22:18:41.000000000 +0100
@@ -145,15 +145,6 @@ static inline struct net_device *bridge_
 	return port ? port->br->dev : NULL;
 }
 
-static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
-{
-	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
-	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
-
-	return skb->nf_bridge;
-}
-
 static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
@@ -775,6 +766,13 @@ static unsigned int br_nf_local_out(unsi
 		return NF_DROP;
 
 	nf_bridge = skb->nf_bridge;
+	/* Enable complete transparency for e.g. ipt_REJECT */
+	if (nf_bridge->mask & BRNF_COPY_MAC_SADDR) {
+		skb_copy_to_linear_data_offset(skb, -8, nf_bridge->data, 6);
+		nf_bridge_put(nf_bridge);
+		skb->nf_bridge = NULL;
+		return NF_ACCEPT;
+	}
 	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
 		return NF_ACCEPT;
 
--- linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c.ori	2009-10-31 19:31:54.000000000 +0100
+++ linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c	2009-11-03 21:55:08.000000000 +0100
@@ -100,11 +100,19 @@ static void send_reset(struct sk_buff *o
 						    sizeof(struct tcphdr), 0));
 
 	addr_type = RTN_UNSPEC;
-	if (hook != NF_INET_FORWARD
 #ifdef CONFIG_BRIDGE_NETFILTER
-	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
+	if (oldskb->nf_bridge && oldskb->nf_bridge->mask & BRNF_BRIDGED) {
+		int daddr_offset = -14 - nf_bridge_encap_header_len(oldskb);
+
+		addr_type = RTN_LOCAL;
+		if (!nf_bridge_alloc(nskb))
+			goto free_nskb;
+		nskb->nf_bridge->mask |= BRNF_COPY_MAC_SADDR;
+		skb_copy_from_linear_data_offset(oldskb, daddr_offset,
+						 nskb->nf_bridge->data, 6);
+	} else
 #endif
-	   )
+	if (hook != NF_INET_FORWARD)
 		addr_type = RTN_LOCAL;
 
 	/* ip_route_me_harder expects skb->dst to be set */

--------------020400010200060700060707--
