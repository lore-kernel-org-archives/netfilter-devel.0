From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: bridge netfilter: consolidate header
	pushing/pulling code
Date: Thu,  3 May 2007 03:26:01 +0200 (MEST)
Message-ID: <20070503012443.12818.98754.sendpatchset@localhost.localdomain>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: bridge netfilter: consolidate header pushing/pulling code

Consolidate the common push/pull sequences into a few helper functions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e439550c01bb8fa2eff00a2dfb4cfd26a966e8ce
tree 43331213cbcf138328638dce0075cbedb20e5ba3
parent 63ce4c4edbf300cf7c5b1d219feca1e687bdbc4b
author Patrick McHardy <kaber@trash.net> Wed, 02 May 2007 16:17:51 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 03 May 2007 02:51:50 +0200

 include/linux/netfilter_bridge.h |   25 ++++---
 net/bridge/br_netfilter.c        |  138 +++++++++++---------------------------
 2 files changed, 56 insertions(+), 107 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 1906003..533ee35 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -55,18 +55,25 @@ static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
   	return 0;
 }
 
+static inline unsigned int nf_bridge_encap_header_len(const struct sk_buff *skb)
+{
+	switch (skb->protocol) {
+	case __constant_htons(ETH_P_8021Q):
+		return VLAN_HLEN;
+	case __constant_htons(ETH_P_PPP_SES):
+		return PPPOE_SES_HLEN;
+	default:
+		return 0;
+	}
+}
+
 /* This is called by the IP fragmenting code and it ensures there is
  * enough room for the encapsulating header (if there is one). */
-static inline int nf_bridge_pad(const struct sk_buff *skb)
+static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
 {
-	int padding = 0;
-
-	if (skb->nf_bridge && skb->protocol == htons(ETH_P_8021Q))
-		padding = VLAN_HLEN;
-	else if (skb->nf_bridge && skb->protocol == htons(ETH_P_PPP_SES))
-		padding = PPPOE_SES_HLEN;
-
-	return padding;
+	if (skb->nf_bridge)
+		return nf_bridge_encap_header_len(skb);
+	return 0;
 }
 
 struct bridge_skb_cb {
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 9b2986b..fa77987 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -142,14 +142,33 @@ static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 	return skb->nf_bridge;
 }
 
-static inline void nf_bridge_save_header(struct sk_buff *skb)
+static inline void nf_bridge_push_encap_header(struct sk_buff *skb)
+{
+	unsigned int len = nf_bridge_encap_header_len(skb);
+
+	skb_push(skb, len);
+	skb->network_header -= len;
+}
+
+static inline void nf_bridge_pull_encap_header(struct sk_buff *skb)
 {
-	int header_size = ETH_HLEN;
+	unsigned int len = nf_bridge_encap_header_len(skb);
+
+	skb_pull(skb, len);
+	skb->network_header += len;
+}
 
-	if (skb->protocol == htons(ETH_P_8021Q))
-		header_size += VLAN_HLEN;
-	else if (skb->protocol == htons(ETH_P_PPP_SES))
-		header_size += PPPOE_SES_HLEN;
+static inline void nf_bridge_pull_encap_header_rcsum(struct sk_buff *skb)
+{
+	unsigned int len = nf_bridge_encap_header_len(skb);
+
+	skb_pull_rcsum(skb, len);
+	skb->network_header += len;
+}
+
+static inline void nf_bridge_save_header(struct sk_buff *skb)
+{
+	int header_size = ETH_HLEN + nf_bridge_encap_header_len(skb);
 
 	skb_copy_from_linear_data_offset(skb, -header_size,
 					 skb->nf_bridge->data, header_size);
@@ -162,12 +181,7 @@ static inline void nf_bridge_save_header(struct sk_buff *skb)
 int nf_bridge_copy_header(struct sk_buff *skb)
 {
 	int err;
-	int header_size = ETH_HLEN;
-
-	if (skb->protocol == htons(ETH_P_8021Q))
-		header_size += VLAN_HLEN;
-	else if (skb->protocol == htons(ETH_P_PPP_SES))
-		header_size += PPPOE_SES_HLEN;
+	int header_size = ETH_HLEN + nf_bridge_encap_header_len(skb);
 
 	err = skb_cow(skb, header_size);
 	if (err)
@@ -175,11 +189,7 @@ int nf_bridge_copy_header(struct sk_buff *skb)
 
 	skb_copy_to_linear_data_offset(skb, -header_size,
 				       skb->nf_bridge->data, header_size);
-
-	if (skb->protocol == htons(ETH_P_8021Q))
-		__skb_push(skb, VLAN_HLEN);
-	else if (skb->protocol == htons(ETH_P_PPP_SES))
-		__skb_push(skb, PPPOE_SES_HLEN);
+	__skb_push(skb, nf_bridge_encap_header_len(skb));
 	return 0;
 }
 
@@ -200,13 +210,7 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 	dst_hold(skb->dst);
 
 	skb->dev = nf_bridge->physindev;
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, VLAN_HLEN);
-		skb->network_header -= VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_push(skb, PPPOE_SES_HLEN);
-		skb->network_header -= PPPOE_SES_HLEN;
-	}
+	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
 
@@ -284,13 +288,7 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	if (!skb->dev)
 		kfree_skb(skb);
 	else {
-		if (skb->protocol == htons(ETH_P_8021Q)) {
-			skb_pull(skb, VLAN_HLEN);
-			skb->network_header += VLAN_HLEN;
-		} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-			skb_pull(skb, PPPOE_SES_HLEN);
-			skb->network_header += PPPOE_SES_HLEN;
-		}
+		nf_bridge_pull_encap_header(skb);
 		skb->dst->output(skb);
 	}
 	return 0;
@@ -356,15 +354,7 @@ bridged_dnat:
 				 * bridged frame */
 				nf_bridge->mask |= BRNF_BRIDGED_DNAT;
 				skb->dev = nf_bridge->physindev;
-				if (skb->protocol ==
-				    htons(ETH_P_8021Q)) {
-					skb_push(skb, VLAN_HLEN);
-					skb->network_header -= VLAN_HLEN;
-				} else if(skb->protocol ==
-				    htons(ETH_P_PPP_SES)) {
-					skb_push(skb, PPPOE_SES_HLEN);
-					skb->network_header -= PPPOE_SES_HLEN;
-				}
+				nf_bridge_push_encap_header(skb);
 				NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING,
 					       skb, skb->dev, NULL,
 					       br_nf_pre_routing_finish_bridge,
@@ -380,13 +370,7 @@ bridged_dnat:
 	}
 
 	skb->dev = nf_bridge->physindev;
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, VLAN_HLEN);
-		skb->network_header -= VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_push(skb, PPPOE_SES_HLEN);
-		skb->network_header -= PPPOE_SES_HLEN;
-	}
+	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
 
@@ -536,14 +520,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 #endif
 		if ((skb = skb_share_check(*pskb, GFP_ATOMIC)) == NULL)
 			goto out;
-
-		if (skb->protocol == htons(ETH_P_8021Q)) {
-			skb_pull_rcsum(skb, VLAN_HLEN);
-			skb->network_header += VLAN_HLEN;
-		} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-			skb_pull_rcsum(skb, PPPOE_SES_HLEN);
-			skb->network_header += PPPOE_SES_HLEN;
-		}
+		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
 	}
 #ifdef CONFIG_SYSCTL
@@ -557,14 +534,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff **pskb,
 
 	if ((skb = skb_share_check(*pskb, GFP_ATOMIC)) == NULL)
 		goto out;
-
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_pull_rcsum(skb, VLAN_HLEN);
-		skb->network_header += VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_pull_rcsum(skb, PPPOE_SES_HLEN);
-		skb->network_header += PPPOE_SES_HLEN;
-	}
+	nf_bridge_pull_encap_header_rcsum(skb);
 
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
@@ -642,13 +612,7 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 	} else {
 		in = *((struct net_device **)(skb->cb));
 	}
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, VLAN_HLEN);
-		skb->network_header -= VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_push(skb, PPPOE_SES_HLEN);
-		skb->network_header -= PPPOE_SES_HLEN;
-	}
+	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_FORWARD, skb, in,
 		       skb->dev, br_forward_finish, 1);
 	return 0;
@@ -682,13 +646,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff **pskb,
 	else
 		pf = PF_INET6;
 
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_pull(*pskb, VLAN_HLEN);
-		(*pskb)->network_header += VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_pull(*pskb, PPPOE_SES_HLEN);
-		(*pskb)->network_header += PPPOE_SES_HLEN;
-	}
+	nf_bridge_pull_encap_header(*pskb);
 
 	nf_bridge = skb->nf_bridge;
 	if (skb->pkt_type == PACKET_OTHERHOST) {
@@ -722,15 +680,12 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff **pskb,
 	if (skb->protocol != htons(ETH_P_ARP)) {
 		if (!IS_VLAN_ARP(skb))
 			return NF_ACCEPT;
-		skb_pull(*pskb, VLAN_HLEN);
-		(*pskb)->network_header += VLAN_HLEN;
+		nf_bridge_pull_encap_header(*pskb);
 	}
 
 	if (arp_hdr(skb)->ar_pln != 4) {
-		if (IS_VLAN_ARP(skb)) {
-			skb_push(*pskb, VLAN_HLEN);
-			(*pskb)->network_header -= VLAN_HLEN;
-		}
+		if (IS_VLAN_ARP(skb))
+			nf_bridge_push_encap_header(*pskb);
 		return NF_ACCEPT;
 	}
 	*d = (struct net_device *)in;
@@ -777,13 +732,7 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff **pskb,
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
 	}
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_push(skb, VLAN_HLEN);
-		skb->network_header -= VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_push(skb, PPPOE_SES_HLEN);
-		skb->network_header -= PPPOE_SES_HLEN;
-	}
+	nf_bridge_push_encap_header(skb);
 
 	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
 		br_forward_finish);
@@ -848,14 +797,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
 		nf_bridge->mask |= BRNF_PKT_TYPE;
 	}
 
-	if (skb->protocol == htons(ETH_P_8021Q)) {
-		skb_pull(skb, VLAN_HLEN);
-		skb->network_header += VLAN_HLEN;
-	} else if (skb->protocol == htons(ETH_P_PPP_SES)) {
-		skb_pull(skb, PPPOE_SES_HLEN);
-		skb->network_header += PPPOE_SES_HLEN;
-	}
-
+	nf_bridge_pull_encap_header(skb);
 	nf_bridge_save_header(skb);
 
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
