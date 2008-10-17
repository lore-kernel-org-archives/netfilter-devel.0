From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: use NFPROTO_* constants in NF_HOOK callsites
Date: Fri, 17 Oct 2008 10:44:13 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810171043520.30268@fbirervta.pbzchgretzou.qr>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net>
 <48F72BE8.80602@netfilter.org> <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYJQOoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:44:16 -0400
In-Reply-To: <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit cc3e81cbbc8a6977cfe614286de16020f9efa3c6
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Oct 17 10:02:30 2008 -0400

netfilter: use NFPROTO_* constants in NF_HOOK callsites

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/br_forward.c                 |    6 ++--
 net/bridge/br_input.c                   |    6 ++--
 net/bridge/br_netfilter.c               |   14 ++++++------
 net/bridge/br_stp_bpdu.c                |    2 +-
 net/decnet/dn_neigh.c                   |    9 +++++--
 net/decnet/dn_nsp_in.c                  |    3 +-
 net/decnet/dn_route.c                   |   27 ++++++++++++++++------
 net/ipv4/ip_forward.c                   |    4 +-
 net/ipv4/ip_input.c                     |    4 +-
 net/ipv4/ip_output.c                    |    8 +++---
 net/ipv4/ipmr.c                         |    2 +-
 net/ipv4/raw.c                          |    4 +-
 net/ipv4/xfrm4_input.c                  |    2 +-
 net/ipv6/ip6_input.c                    |    4 +-
 net/ipv6/ip6_output.c                   |   12 +++++-----
 net/ipv6/ip6mr.c                        |    2 +-
 net/ipv6/mcast.c                        |    4 +-
 net/ipv6/ndisc.c                        |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 +-
 net/ipv6/raw.c                          |    4 +-
 net/ipv6/xfrm6_input.c                  |    2 +-
 net/ipv6/xfrm6_output.c                 |    4 +-
 net/netfilter/ipvs/ip_vs_xmit.c         |   16 ++++++------
 23 files changed, 80 insertions(+), 65 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index bdd9cce..a69e565 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -51,7 +51,7 @@ int br_dev_queue_push_xmit(struct sk_buff *skb)
 
 int br_forward_finish(struct sk_buff *skb)
 {
-	return NF_HOOK(PF_BRIDGE, NF_BR_POST_ROUTING, skb, NULL, skb->dev,
+	return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING, skb, NULL, skb->dev,
 		       br_dev_queue_push_xmit);
 
 }
@@ -59,7 +59,7 @@ int br_forward_finish(struct sk_buff *skb)
 static void __br_deliver(const struct net_bridge_port *to, struct sk_buff *skb)
 {
 	skb->dev = to->dev;
-	NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
 			br_forward_finish);
 }
 
@@ -71,7 +71,7 @@ static void __br_forward(const struct net_bridge_port *to, struct sk_buff *skb)
 	skb->dev = to->dev;
 	skb_forward_csum(skb);
 
-	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, indev, skb->dev,
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, skb, indev, skb->dev,
 			br_forward_finish);
 }
 
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 30b8877..9eba95b 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -30,7 +30,7 @@ static void br_pass_frame_up(struct net_bridge *br, struct sk_buff *skb)
 	indev = skb->dev;
 	skb->dev = brdev;
 
-	NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, indev, NULL,
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_IN, skb, indev, NULL,
 		netif_receive_skb);
 }
 
@@ -134,7 +134,7 @@ struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 		if (skb->protocol == htons(ETH_P_PAUSE))
 			goto drop;
 
-		if (NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, skb->dev,
+		if (NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_IN, skb, skb->dev,
 			    NULL, br_handle_local_finish))
 			return NULL;	/* frame consumed by filter */
 		else
@@ -154,7 +154,7 @@ struct sk_buff *br_handle_frame(struct net_bridge_port *p, struct sk_buff *skb)
 		if (!compare_ether_addr(p->br->dev->dev_addr, dest))
 			skb->pkt_type = PACKET_HOST;
 
-		NF_HOOK(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
+		NF_HOOK(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 			br_handle_frame_finish);
 		break;
 	default:
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fa5cda4..13e8cb3 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -519,7 +519,7 @@ static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 
-	NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
+	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
 
 	return NF_STOLEN;
@@ -592,7 +592,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 		return NF_DROP;
 	store_orig_dstaddr(skb);
 
-	NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
+	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish);
 
 	return NF_STOLEN;
@@ -673,9 +673,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 
 	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
 	    IS_PPPOE_IP(skb))
-		pf = PF_INET;
+		pf = NFPROTO_IPV4;
 	else
-		pf = PF_INET6;
+		pf = NFPROTO_IPV6;
 
 	nf_bridge_pull_encap_header(skb);
 
@@ -768,7 +768,7 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
 	}
 	nf_bridge_push_encap_header(skb);
 
-	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
 		br_forward_finish);
 	return NF_STOLEN;
 }
@@ -815,9 +815,9 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 
 	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
 	    IS_PPPOE_IP(skb))
-		pf = PF_INET;
+		pf = NFPROTO_IPV4;
 	else
-		pf = PF_INET6;
+		pf = NFPROTO_IPV6;
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	if (skb->dst == NULL) {
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 81ae40b..11b0157 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -49,7 +49,7 @@ static void br_send_bpdu(struct net_bridge_port *p,
 
 	llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr);
 
-	NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
 		dev_queue_xmit);
 }
 
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 1ca13b1..3ded3d5 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -265,7 +265,8 @@ static int dn_long_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+	       neigh->dev, dn_neigh_output_packet);
 }
 
 static int dn_short_output(struct sk_buff *skb)
@@ -304,7 +305,8 @@ static int dn_short_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+	       neigh->dev, dn_neigh_output_packet);
 }
 
 /*
@@ -346,7 +348,8 @@ static int dn_phase3_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+	       neigh->dev, dn_neigh_output_packet);
 }
 
 /*
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 4074a6e..40b9cdf 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -816,7 +816,8 @@ free_out:
 
 int dn_nsp_rx(struct sk_buff *skb)
 {
-	return NF_HOOK(PF_DECnet, NF_DN_LOCAL_IN, skb, skb->dev, NULL, dn_nsp_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_IN, skb, skb->dev, NULL,
+	       dn_nsp_rx_packet);
 }
 
 /*
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 821bd1c..7b28758 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -522,7 +522,8 @@ static int dn_route_rx_long(struct sk_buff *skb)
 	ptr++;
 	cb->hops = *ptr++; /* Visit Count */
 
-	return NF_HOOK(PF_DECnet, NF_DN_PRE_ROUTING, skb, skb->dev, NULL, dn_route_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING, skb, skb->dev, NULL,
+	       dn_route_rx_packet);
 
 drop_it:
 	kfree_skb(skb);
@@ -548,7 +549,8 @@ static int dn_route_rx_short(struct sk_buff *skb)
 	ptr += 2;
 	cb->hops = *ptr & 0x3f;
 
-	return NF_HOOK(PF_DECnet, NF_DN_PRE_ROUTING, skb, skb->dev, NULL, dn_route_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING, skb, skb->dev, NULL,
+	       dn_route_rx_packet);
 
 drop_it:
 	kfree_skb(skb);
@@ -650,16 +652,23 @@ int dn_route_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type
 
 		switch(flags & DN_RT_CNTL_MSK) {
 			case DN_RT_PKT_HELO:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_route_ptp_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+				       skb, skb->dev, NULL,
+				       dn_route_ptp_hello);
 
 			case DN_RT_PKT_L1RT:
 			case DN_RT_PKT_L2RT:
-				return NF_HOOK(PF_DECnet, NF_DN_ROUTE, skb, skb->dev, NULL, dn_route_discard);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_ROUTE,
+				       skb, skb->dev, NULL, dn_route_discard);
 			case DN_RT_PKT_ERTH:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_neigh_router_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+				       skb, skb->dev, NULL,
+				       dn_neigh_router_hello);
 
 			case DN_RT_PKT_EEDH:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_neigh_endnode_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+				       skb, skb->dev, NULL,
+				       dn_neigh_endnode_hello);
 		}
 	} else {
 		if (dn->parms.state != DN_DEV_S_RU)
@@ -708,7 +717,8 @@ static int dn_output(struct sk_buff *skb)
 	cb->rt_flags |= DN_RT_F_IE;
 	cb->hops = 0;
 
-	return NF_HOOK(PF_DECnet, NF_DN_LOCAL_OUT, skb, NULL, dev, neigh->output);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_OUT, skb, NULL, dev,
+	       neigh->output);
 
 error:
 	if (net_ratelimit())
@@ -757,7 +767,8 @@ static int dn_forward(struct sk_buff *skb)
 	if (rt->rt_flags & RTCF_DOREDIRECT)
 		cb->rt_flags |= DN_RT_F_IE;
 
-	return NF_HOOK(PF_DECnet, NF_DN_FORWARD, skb, dev, skb->dev, neigh->output);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_FORWARD, skb, dev, skb->dev,
+	       neigh->output);
 
 drop:
 	kfree_skb(skb);
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 450016b..31afcfd 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -111,8 +111,8 @@ int ip_forward(struct sk_buff *skb)
 
 	skb->priority = rt_tos2priority(iph->tos);
 
-	return NF_HOOK(PF_INET, NF_INET_FORWARD, skb, skb->dev, rt->u.dst.dev,
-		       ip_forward_finish);
+	return NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD, skb, skb->dev,
+	       rt->u.dst.dev, ip_forward_finish);
 
 sr_failed:
 	/*
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 861978a..791360c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -257,7 +257,7 @@ int ip_local_deliver(struct sk_buff *skb)
 			return 0;
 	}
 
-	return NF_HOOK(PF_INET, NF_INET_LOCAL_IN, skb, skb->dev, NULL,
+	return NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_IN, skb, skb->dev, NULL,
 		       ip_local_deliver_finish);
 }
 
@@ -431,7 +431,7 @@ int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 
-	return NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, dev, NULL,
+	return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip_rcv_finish);
 
 inhdr_error:
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d2a8f8b..798b91c 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -269,8 +269,8 @@ int ip_mc_output(struct sk_buff *skb)
 		) {
 			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
 			if (newskb)
-				NF_HOOK(PF_INET, NF_INET_POST_ROUTING, newskb,
-					NULL, newskb->dev,
+				NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING,
+					newskb, NULL, newskb->dev,
 					ip_dev_loopback_xmit);
 		}
 
@@ -285,8 +285,8 @@ int ip_mc_output(struct sk_buff *skb)
 	if (rt->rt_flags&RTCF_BROADCAST) {
 		struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
 		if (newskb)
-			NF_HOOK(PF_INET, NF_INET_POST_ROUTING, newskb, NULL,
-				newskb->dev, ip_dev_loopback_xmit);
+			NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, newskb,
+				NULL, newskb->dev, ip_dev_loopback_xmit);
 	}
 
 	return NF_HOOK_COND(PF_INET, NF_INET_POST_ROUTING, skb, NULL, skb->dev,
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b42e082..5c0389a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1282,7 +1282,7 @@ static void ipmr_queue_xmit(struct sk_buff *skb, struct mfc_cache *c, int vifi)
 	 * not mrouter) cannot join to more than one interface - it will
 	 * result in receiving multiple packets.
 	 */
-	NF_HOOK(PF_INET, NF_INET_FORWARD, skb, skb->dev, dev,
+	NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD, skb, skb->dev, dev,
 		ipmr_forward_finish);
 	return;
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index cd97574..c5e36ce 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -372,8 +372,8 @@ static int raw_send_hdrinc(struct sock *sk, void *from, size_t length,
 		icmp_out_count(net, ((struct icmphdr *)
 			skb_transport_header(skb))->type);
 
-	err = NF_HOOK(PF_INET, NF_INET_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		      dst_output);
+	err = NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, skb, NULL,
+	      rt->u.dst.dev, dst_output);
 	if (err > 0)
 		err = inet->recverr ? net_xmit_errno(err) : 0;
 	if (err)
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index 390dcb1..63b21ff 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -60,7 +60,7 @@ int xfrm4_transport_finish(struct sk_buff *skb, int async)
 	iph->tot_len = htons(skb->len);
 	ip_send_check(iph);
 
-	NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
+	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		xfrm4_rcv_encap_finish);
 	return 0;
 }
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 936f489..6cb5ac9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -140,7 +140,7 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 
 	rcu_read_unlock();
 
-	return NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, dev, NULL,
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, dev, NULL,
 		       ip6_rcv_finish);
 err:
 	IP6_INC_STATS_BH(net, idev, IPSTATS_MIB_INHDRERRORS);
@@ -235,7 +235,7 @@ discard:
 
 int ip6_input(struct sk_buff *skb)
 {
-	return NF_HOOK(PF_INET6, NF_INET_LOCAL_IN, skb, skb->dev, NULL,
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN, skb, skb->dev, NULL,
 		       ip6_input_finish);
 }
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c77db0b..51f446d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -146,8 +146,8 @@ static int ip6_output2(struct sk_buff *skb)
 			   is not supported in any case.
 			 */
 			if (newskb)
-				NF_HOOK(PF_INET6, NF_INET_POST_ROUTING, newskb,
-					NULL, newskb->dev,
+				NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING,
+					newskb, NULL, newskb->dev,
 					ip6_dev_loopback_xmit);
 
 			if (ipv6_hdr(skb)->hop_limit == 0) {
@@ -161,7 +161,7 @@ static int ip6_output2(struct sk_buff *skb)
 		IP6_INC_STATS(dev_net(dev), idev, IPSTATS_MIB_OUTMCASTPKTS);
 	}
 
-	return NF_HOOK(PF_INET6, NF_INET_POST_ROUTING, skb, NULL, skb->dev,
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, skb->dev,
 		       ip6_output_finish);
 }
 
@@ -276,8 +276,8 @@ int ip6_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 	if ((skb->len <= mtu) || skb->local_df || skb_is_gso(skb)) {
 		IP6_INC_STATS(net, ip6_dst_idev(skb->dst),
 			      IPSTATS_MIB_OUTREQUESTS);
-		return NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, skb, NULL, dst->dev,
-				dst_output);
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, skb, NULL,
+		       dst->dev, dst_output);
 	}
 
 	if (net_ratelimit())
@@ -549,7 +549,7 @@ int ip6_forward(struct sk_buff *skb)
 	hdr->hop_limit--;
 
 	IP6_INC_STATS_BH(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTFORWDATAGRAMS);
-	return NF_HOOK(PF_INET6, NF_INET_FORWARD, skb, skb->dev, dst->dev,
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD, skb, skb->dev, dst->dev,
 		       ip6_forward_finish);
 
 error:
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 182f8a1..ee6d871 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1457,7 +1457,7 @@ static int ip6mr_forward2(struct sk_buff *skb, struct mfc6_cache *c, int vifi)
 
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
-	return NF_HOOK(PF_INET6, NF_INET_FORWARD, skb, skb->dev, dev,
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD, skb, skb->dev, dev,
 		       ip6mr_forward2_finish);
 
 out_free:
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d7b3c6d..0afbdfa 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1470,7 +1470,7 @@ static void mld_sendpack(struct sk_buff *skb)
 	if (err)
 		goto err_out;
 
-	err = NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, skb, NULL, skb->dev,
+	err = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, skb, NULL, skb->dev,
 		      dst_output);
 out:
 	if (!err) {
@@ -1835,7 +1835,7 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 	if (err)
 		goto err_out;
 
-	err = NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, skb, NULL, skb->dev,
+	err = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, skb, NULL, skb->dev,
 		      dst_output);
 out:
 	if (!err) {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 840b157..9ba9db9 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -518,7 +518,7 @@ static void __ndisc_send(struct net_device *dev,
 	idev = in6_dev_get(dst->dev);
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 
-	err = NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, skb, NULL, dst->dev,
+	err = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, skb, NULL, dst->dev,
 		      dst_output);
 	if (!err) {
 		ICMP6MSGOUT_INC_STATS(net, idev, type);
@@ -1582,7 +1582,7 @@ void ndisc_send_redirect(struct sk_buff *skb, struct neighbour *neigh,
 	buff->dst = dst;
 	idev = in6_dev_get(dst->dev);
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
-	err = NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, buff, NULL, dst->dev,
+	err = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, buff, NULL, dst->dev,
 		      dst_output);
 	if (!err) {
 		ICMP6MSGOUT_INC_STATS(net, idev, NDISC_REDIRECT);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 9967ac7..afa1d4b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -652,7 +652,7 @@ void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 		s2 = s->next;
 		s->next = NULL;
 
-		NF_HOOK_THRESH(PF_INET6, hooknum, s, in, out, okfn,
+		NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, s, in, out, okfn,
 			       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
 		s = s2;
 	}
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 2ba04d4..c918c9b 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -639,8 +639,8 @@ static int rawv6_send_hdrinc(struct sock *sk, void *from, int length,
 		goto error_fault;
 
 	IP6_INC_STATS(sock_net(sk), rt->rt6i_idev, IPSTATS_MIB_OUTREQUESTS);
-	err = NF_HOOK(PF_INET6, NF_INET_LOCAL_OUT, skb, NULL, rt->u.dst.dev,
-		      dst_output);
+	err = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, skb, NULL,
+	      rt->u.dst.dev, dst_output);
 	if (err > 0)
 		err = np->recverr ? net_xmit_errno(err) : 0;
 	if (err)
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index a71c7dd..7330b1d 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -42,7 +42,7 @@ int xfrm6_transport_finish(struct sk_buff *skb, int async)
 	ipv6_hdr(skb)->payload_len = htons(skb->len);
 	__skb_push(skb, skb->data - skb_network_header(skb));
 
-	NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
+	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		ip6_rcv_finish);
 	return -1;
 }
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 0af823c..29dc224 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -89,6 +89,6 @@ static int xfrm6_output_finish(struct sk_buff *skb)
 
 int xfrm6_output(struct sk_buff *skb)
 {
-	return NF_HOOK(PF_INET6, NF_INET_POST_ROUTING, skb, NULL, skb->dst->dev,
-		       xfrm6_output_finish);
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL,
+	       skb->dst->dev, xfrm6_output_finish);
 }
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 02ddc2b..e17c145 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -268,7 +268,7 @@ ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV4, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -332,7 +332,7 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET6, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV6, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -408,7 +408,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV4, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -484,7 +484,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET6, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV6, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -782,7 +782,7 @@ ip_vs_dr_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV4, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -835,7 +835,7 @@ ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET6, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV6, skb, rt);
 
 	LeaveFunction(10);
 	return NF_STOLEN;
@@ -909,7 +909,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV4, skb, rt);
 
 	rc = NF_STOLEN;
 	goto out;
@@ -984,7 +984,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
 
-	IP_VS_XMIT(PF_INET6, skb, rt);
+	IP_VS_XMIT(NFPROTO_IPV6, skb, rt);
 
 	rc = NF_STOLEN;
 	goto out;
