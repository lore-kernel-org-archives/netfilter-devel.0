From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/7]: Kill nf_debug
Date: Tue, 21 Jun 2005 01:04:12 +0200
Message-ID: <42B74B6C.30407@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Kill nf_debug

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d83d34acca8d7e31aeb226928ba723b4213f7e70
tree 959d2a0aa147350cae94bf986780cda124318f38
parent 707246750b3c516436fae3f37469b76f017e706b
author Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:45:59
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:45:59

 include/linux/netfilter_ipv4.h         |    6 -
 include/linux/skbuff.h                 |   13 ---
 net/bridge/br_forward.c                |    3 -
 net/bridge/br_input.c                  |    4 -
 net/bridge/br_netfilter.c              |   38 ---------
 net/core/netfilter.c                   |  138 --------------------------------
 net/core/skbuff.c                      |    6 -
 net/ipv4/ip_input.c                    |    4 -
 net/ipv4/ip_output.c                   |   11 ---
 net/ipv4/ipvs/ip_vs_xmit.c             |    1 
 net/ipv4/netfilter/ip_conntrack_core.c |    9 --
 net/ipv4/netfilter/ip_nat_helper.c     |    3 -
 net/ipv6/ip6_output.c                  |    3 -
 13 files changed, 0 insertions(+), 239 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -75,12 +75,6 @@ enum nf_ip_hook_priorities {
 #define SO_ORIGINAL_DST 80
 
 #ifdef __KERNEL__
-#ifdef CONFIG_NETFILTER_DEBUG
-void nf_debug_ip_local_deliver(struct sk_buff *skb);
-void nf_debug_ip_loopback_xmit(struct sk_buff *newskb);
-void nf_debug_ip_finish_output2(struct sk_buff *skb);
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 extern int ip_route_me_harder(struct sk_buff **pskb);
 
 /* Call this before modifying an existing IP packet: ensures it is
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -193,7 +193,6 @@ struct skb_shared_info {
  *	@nfcache: Cache info
  *	@nfct: Associated connection, if any
  *	@nfctinfo: Relationship of this skb to the connection
- *	@nf_debug: Netfilter debugging
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *      @private: Data which is private to the HIPPI implementation
  *	@tc_index: Traffic control index
@@ -264,9 +263,6 @@ struct sk_buff {
 	__u32			nfcache;
 	__u32			nfctinfo;
 	struct nf_conntrack	*nfct;
-#ifdef CONFIG_NETFILTER_DEBUG
-        unsigned int		nf_debug;
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct nf_bridge_info	*nf_bridge;
 #endif
@@ -1219,15 +1215,6 @@ static inline void nf_reset(struct sk_bu
 {
 	nf_conntrack_put(skb->nfct);
 	skb->nfct = NULL;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
-}
-static inline void nf_reset_debug(struct sk_buff *skb)
-{
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
 }
 
 #ifdef CONFIG_BRIDGE_NETFILTER
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -57,9 +57,6 @@ int br_forward_finish(struct sk_buff *sk
 static void __br_deliver(const struct net_bridge_port *to, struct sk_buff *skb)
 {
 	skb->dev = to->dev;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
 	NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
 			br_forward_finish);
 }
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -23,11 +23,7 @@ const unsigned char bridge_ula[6] = { 0x
 
 static int br_pass_frame_up_finish(struct sk_buff *skb)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
 	netif_receive_skb(skb);
-
 	return 0;
 }
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -102,10 +102,6 @@ static int br_nf_pre_routing_finish_ipv6
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_PRE_ROUTING);
-#endif
-
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
@@ -182,10 +178,6 @@ static void __br_dnat_complain(void)
  * --Bart, 20021007 (updated) */
 static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug |= (1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_FORWARD);
-#endif
-
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
 		skb->nf_bridge->mask |= BRNF_PKT_TYPE;
@@ -207,10 +199,6 @@ static int br_nf_pre_routing_finish(stru
 	struct iphdr *iph = skb->nh.iph;
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_PRE_ROUTING);
-#endif
-
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
@@ -382,9 +370,6 @@ static unsigned int br_nf_pre_routing_ip
 	if (hdr->nexthdr == NEXTHDR_HOP && check_hbh_len(skb))
 			goto inhdr_error;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_IP6_PRE_ROUTING);
-#endif
 	if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
 		return NF_DROP;
 	setup_pre_routing(skb);
@@ -468,9 +453,6 @@ static unsigned int br_nf_pre_routing(un
 			skb->ip_summed = CHECKSUM_NONE;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_IP_PRE_ROUTING);
-#endif
 	if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
 		return NF_DROP;
 	setup_pre_routing(skb);
@@ -517,10 +499,6 @@ static int br_nf_forward_finish(struct s
 	struct net_device *in;
 	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
-
 	if (skb->protocol != __constant_htons(ETH_P_ARP) && !IS_VLAN_ARP) {
 		in = nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
@@ -566,9 +544,6 @@ static unsigned int br_nf_forward_ip(uns
 		(*pskb)->nh.raw += VLAN_HLEN;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
 	nf_bridge = skb->nf_bridge;
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
@@ -605,10 +580,6 @@ static unsigned int br_nf_forward_arp(un
 		(*pskb)->nh.raw += VLAN_HLEN;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
-
 	if (skb->nh.arph->ar_pln != 4) {
 		if (IS_VLAN_ARP) {
 			skb_push(*pskb, VLAN_HLEN);
@@ -627,9 +598,6 @@ static unsigned int br_nf_forward_arp(un
 /* PF_BRIDGE/LOCAL_OUT ***********************************************/
 static int br_nf_local_out_finish(struct sk_buff *skb)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug &= ~(1 << NF_BR_LOCAL_OUT);
-#endif
 	if (skb->protocol == __constant_htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->nh.raw -= VLAN_HLEN;
@@ -731,10 +699,6 @@ static unsigned int br_nf_local_out(unsi
 			       realoutdev, br_nf_local_out_finish,
 			       NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD + 1);
 	} else {
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug ^= (1 << NF_IP_LOCAL_OUT);
-#endif
-
 		NF_HOOK_THRESH(pf, NF_IP_LOCAL_OUT, skb, realindev,
 			       realoutdev, br_nf_local_out_finish,
 			       NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT + 1);
@@ -779,8 +743,6 @@ static unsigned int br_nf_post_routing(u
 		printk(KERN_CRIT "br_netfilter: skb->dst == NULL.");
 		goto print_error;
 	}
-
-	skb->nf_debug ^= (1 << NF_IP_POST_ROUTING);
 #endif
 
 	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
diff --git a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c
+++ b/net/core/netfilter.c
@@ -141,136 +141,6 @@ void nf_unregister_sockopt(struct nf_soc
 	up(&nf_sockopt_mutex);
 }
 
-#ifdef CONFIG_NETFILTER_DEBUG
-#include <net/ip.h>
-#include <net/tcp.h>
-#include <linux/netfilter_ipv4.h>
-
-static void debug_print_hooks_ip(unsigned int nf_debug)
-{
-	if (nf_debug & (1 << NF_IP_PRE_ROUTING)) {
-		printk("PRE_ROUTING ");
-		nf_debug ^= (1 << NF_IP_PRE_ROUTING);
-	}
-	if (nf_debug & (1 << NF_IP_LOCAL_IN)) {
-		printk("LOCAL_IN ");
-		nf_debug ^= (1 << NF_IP_LOCAL_IN);
-	}
-	if (nf_debug & (1 << NF_IP_FORWARD)) {
-		printk("FORWARD ");
-		nf_debug ^= (1 << NF_IP_FORWARD);
-	}
-	if (nf_debug & (1 << NF_IP_LOCAL_OUT)) {
-		printk("LOCAL_OUT ");
-		nf_debug ^= (1 << NF_IP_LOCAL_OUT);
-	}
-	if (nf_debug & (1 << NF_IP_POST_ROUTING)) {
-		printk("POST_ROUTING ");
-		nf_debug ^= (1 << NF_IP_POST_ROUTING);
-	}
-	if (nf_debug)
-		printk("Crap bits: 0x%04X", nf_debug);
-	printk("\n");
-}
-
-static void nf_dump_skb(int pf, struct sk_buff *skb)
-{
-	printk("skb: pf=%i %s dev=%s len=%u\n", 
-	       pf,
-	       skb->sk ? "(owned)" : "(unowned)",
-	       skb->dev ? skb->dev->name : "(no dev)",
-	       skb->len);
-	switch (pf) {
-	case PF_INET: {
-		const struct iphdr *ip = skb->nh.iph;
-		__u32 *opt = (__u32 *) (ip + 1);
-		int opti;
-		__u16 src_port = 0, dst_port = 0;
-
-		if (ip->protocol == IPPROTO_TCP
-		    || ip->protocol == IPPROTO_UDP) {
-			struct tcphdr *tcp=(struct tcphdr *)((__u32 *)ip+ip->ihl);
-			src_port = ntohs(tcp->source);
-			dst_port = ntohs(tcp->dest);
-		}
-	
-		printk("PROTO=%d %u.%u.%u.%u:%hu %u.%u.%u.%u:%hu"
-		       " L=%hu S=0x%2.2hX I=%hu F=0x%4.4hX T=%hu",
-		       ip->protocol, NIPQUAD(ip->saddr),
-		       src_port, NIPQUAD(ip->daddr),
-		       dst_port,
-		       ntohs(ip->tot_len), ip->tos, ntohs(ip->id),
-		       ntohs(ip->frag_off), ip->ttl);
-
-		for (opti = 0; opti < (ip->ihl - sizeof(struct iphdr) / 4); opti++)
-			printk(" O=0x%8.8X", *opt++);
-		printk("\n");
-	}
-	}
-}
-
-void nf_debug_ip_local_deliver(struct sk_buff *skb)
-{
-	/* If it's a loopback packet, it must have come through
-	 * NF_IP_LOCAL_OUT, NF_IP_RAW_INPUT, NF_IP_PRE_ROUTING and
-	 * NF_IP_LOCAL_IN.  Otherwise, must have gone through
-	 * NF_IP_RAW_INPUT and NF_IP_PRE_ROUTING.  */
-	if (!skb->dev) {
-		printk("ip_local_deliver: skb->dev is NULL.\n");
-	} else {
-		if (skb->nf_debug != ((1<<NF_IP_PRE_ROUTING)
-				      | (1<<NF_IP_LOCAL_IN))) {
-			printk("ip_local_deliver: bad skb: ");
-			debug_print_hooks_ip(skb->nf_debug);
-			nf_dump_skb(PF_INET, skb);
-		}
-	}
-}
-
-void nf_debug_ip_loopback_xmit(struct sk_buff *newskb)
-{
-	if (newskb->nf_debug != ((1 << NF_IP_LOCAL_OUT)
-				 | (1 << NF_IP_POST_ROUTING))) {
-		printk("ip_dev_loopback_xmit: bad owned skb = %p: ", 
-		       newskb);
-		debug_print_hooks_ip(newskb->nf_debug);
-		nf_dump_skb(PF_INET, newskb);
-	}
-}
-
-void nf_debug_ip_finish_output2(struct sk_buff *skb)
-{
-	/* If it's owned, it must have gone through the
-	 * NF_IP_LOCAL_OUT and NF_IP_POST_ROUTING.
-	 * Otherwise, must have gone through
-	 * NF_IP_PRE_ROUTING, NF_IP_FORWARD and NF_IP_POST_ROUTING.
-	 */
-	if (skb->sk) {
-		if (skb->nf_debug != ((1 << NF_IP_LOCAL_OUT)
-				      | (1 << NF_IP_POST_ROUTING))) {
-			printk("ip_finish_output: bad owned skb = %p: ", skb);
-			debug_print_hooks_ip(skb->nf_debug);
-			nf_dump_skb(PF_INET, skb);
-		}
-	} else {
-		if (skb->nf_debug != ((1 << NF_IP_PRE_ROUTING)
-				      | (1 << NF_IP_FORWARD)
-				      | (1 << NF_IP_POST_ROUTING))) {
-			/* Fragments, entunnelled packets, TCP RSTs
-                           generated by ipt_REJECT will have no
-                           owners, but still may be local */
-			if (skb->nf_debug != ((1 << NF_IP_LOCAL_OUT)
-					      | (1 << NF_IP_POST_ROUTING))){
-				printk("ip_finish_output:"
-				       " bad unowned skb = %p: ",skb);
-				debug_print_hooks_ip(skb->nf_debug);
-				nf_dump_skb(PF_INET, skb);
-			}
-		}
-	}
-}
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 /* Call get/setsockopt() */
 static int nf_sockopt(struct sock *sk, int pf, int val, 
 		      char __user *opt, int *len, int get)
@@ -488,14 +358,6 @@ int nf_hook_slow(int pf, unsigned int ho
 	/* We may already have this, but read-locks nest anyway */
 	rcu_read_lock();
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	if (unlikely((*pskb)->nf_debug & (1 << hook))) {
-		printk("nf_hook: hook %i already set.\n", hook);
-		nf_dump_skb(pf, *pskb);
-	}
-	(*pskb)->nf_debug |= (1 << hook);
-#endif
-
 	elem = &nf_hooks[pf][hook];
 next_hook:
 	verdict = nf_iterate(&nf_hooks[pf][hook], pskb, hook, indev,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -365,9 +365,6 @@ struct sk_buff *skb_clone(struct sk_buff
 	C(nfct);
 	nf_conntrack_get(skb->nfct);
 	C(nfctinfo);
-#ifdef CONFIG_NETFILTER_DEBUG
-	C(nf_debug);
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	C(nf_bridge);
 	nf_bridge_get(skb->nf_bridge);
@@ -432,9 +429,6 @@ static void copy_skb_header(struct sk_bu
 	new->nfct	= old->nfct;
 	nf_conntrack_get(old->nfct);
 	new->nfctinfo	= old->nfctinfo;
-#ifdef CONFIG_NETFILTER_DEBUG
-	new->nf_debug	= old->nf_debug;
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	new->nf_bridge	= old->nf_bridge;
 	nf_bridge_get(old->nf_bridge);
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -200,10 +200,6 @@ static inline int ip_local_deliver_finis
 {
 	int ihl = skb->nh.iph->ihl*4;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	nf_debug_ip_local_deliver(skb);
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 	__skb_pull(skb, ihl);
 
 	/* Free reference early: we don't need it any more, and it may
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -107,10 +107,6 @@ static int ip_dev_loopback_xmit(struct s
 	newskb->pkt_type = PACKET_LOOPBACK;
 	newskb->ip_summed = CHECKSUM_UNNECESSARY;
 	BUG_TRAP(newskb->dst);
-
-#ifdef CONFIG_NETFILTER_DEBUG
-	nf_debug_ip_loopback_xmit(newskb);
-#endif
 	nf_reset(newskb);
 	netif_rx(newskb);
 	return 0;
@@ -192,10 +188,6 @@ static inline int ip_finish_output2(stru
 		skb = skb2;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	nf_debug_ip_finish_output2(skb);
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 	nf_reset(skb);
 
 	if (hh) {
@@ -415,9 +407,6 @@ static void ip_copy_metadata(struct sk_b
 	to->nf_bridge = from->nf_bridge;
 	nf_bridge_get(to->nf_bridge);
 #endif
-#ifdef CONFIG_NETFILTER_DEBUG
-	to->nf_debug = from->nf_debug;
-#endif
 #endif
 }
 
diff --git a/net/ipv4/ipvs/ip_vs_xmit.c b/net/ipv4/ipvs/ip_vs_xmit.c
--- a/net/ipv4/ipvs/ip_vs_xmit.c
+++ b/net/ipv4/ipvs/ip_vs_xmit.c
@@ -127,7 +127,6 @@ ip_vs_dst_reset(struct ip_vs_dest *dest)
 
 #define IP_VS_XMIT(skb, rt)				\
 do {							\
-	nf_reset_debug(skb);				\
 	(skb)->nfcache |= NFC_IPVS_PROPERTY;		\
 	(skb)->ip_summed = CHECKSUM_NONE;		\
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, (skb), NULL,	\
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -940,10 +940,6 @@ void ip_ct_refresh_acct(struct ip_conntr
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	unsigned int olddebug = skb->nf_debug;
-#endif
-
 	skb_orphan(skb);
 
 	local_bh_disable(); 
@@ -953,12 +949,7 @@ ip_ct_gather_frags(struct sk_buff *skb, 
 	if (skb) {
 		ip_send_check(skb->nh.iph);
 		skb->nfcache |= NFC_ALTERED;
-#ifdef CONFIG_NETFILTER_DEBUG
-		/* Packet path as if nothing had happened. */
-		skb->nf_debug = olddebug;
-#endif
 	}
-
 	return skb;
 }
 
diff --git a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c
+++ b/net/ipv4/netfilter/ip_nat_helper.c
@@ -142,9 +142,6 @@ static int enlarge_skb(struct sk_buff **
 	/* Transfer socket to new skb. */
 	if ((*pskb)->sk)
 		skb_set_owner_w(nskb, (*pskb)->sk);
-#ifdef CONFIG_NETFILTER_DEBUG
-	nskb->nf_debug = (*pskb)->nf_debug;
-#endif
 	kfree_skb(*pskb);
 	*pskb = nskb;
 	return 1;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -484,9 +484,6 @@ static void ip6_copy_metadata(struct sk_
 	to->nf_bridge = from->nf_bridge;
 	nf_bridge_get(to->nf_bridge);
 #endif
-#ifdef CONFIG_NETFILTER_DEBUG
-	to->nf_debug = from->nf_debug;
-#endif
 #endif
 }
 
