From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Kill lockhelp.h
Date: Fri, 06 May 2005 02:01:22 +0200
Message-ID: <427AB3D2.7080409@trash.net>
References: <427AADED.8050301@trash.net>
	<20050505164523.0d9d5cf7.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080709060302000705000202"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050505164523.0d9d5cf7.davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080709060302000705000202
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

David S. Miller wrote:
> Is there a nf_debug death patch coming as well?

Yes, I thought I'd hold onto it until 2.6.13 because there are no
problems with the code, but here it is.


--------------080709060302000705000202
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Kill nf_debug

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c9ca82490e436ed4b0aaa8e0df0ceb1792dc5440
tree 2cfdb1827d9c176f4df42619c693e7b990a61963
parent 8a351130c36dcfb76fcdd69c974e7023f0519948
author Patrick McHardy <kaber@trash.net> 1115306852 +0200
committer Patrick McHardy <kaber@trash.net> 1115306852 +0200

Index: include/linux/netfilter_ipv4.h
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/include/linux/netfilter_ipv4.h  (mode:100644 sha1:9e5750079e09abc0956bc0617e16d282840ea07d)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/include/linux/netfilter_ipv4.h  (mode:100644 sha1:3ebc36afae1a4746be0994d709b0f4e4f6f96ba7)
@@ -75,12 +75,6 @@
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
Index: include/linux/skbuff.h
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/include/linux/skbuff.h  (mode:100644 sha1:cc04f5cd2286953a16a66dbfd89fe96211b0026c)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/include/linux/skbuff.h  (mode:100644 sha1:d7c839a21842ca03f360a0e16320bab6c8253f76)
@@ -193,7 +193,6 @@
  *	@nfcache: Cache info
  *	@nfct: Associated connection, if any
  *	@nfctinfo: Relationship of this skb to the connection
- *	@nf_debug: Netfilter debugging
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *      @private: Data which is private to the HIPPI implementation
  *	@tc_index: Traffic control index
@@ -264,9 +263,6 @@
 	__u32			nfcache;
 	__u32			nfctinfo;
 	struct nf_conntrack	*nfct;
-#ifdef CONFIG_NETFILTER_DEBUG
-        unsigned int		nf_debug;
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct nf_bridge_info	*nf_bridge;
 #endif
@@ -1219,15 +1215,6 @@
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
Index: net/bridge/br_forward.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/bridge/br_forward.c  (mode:100644 sha1:ef9f2095f96e37dae664786b70638b46befd88da)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/bridge/br_forward.c  (mode:100644 sha1:069253f830c10cd777d22662e976c89a593a2547)
@@ -57,9 +57,6 @@
 static void __br_deliver(const struct net_bridge_port *to, struct sk_buff *skb)
 {
 	skb->dev = to->dev;
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
 	NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
 			br_forward_finish);
 }
Index: net/bridge/br_input.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/bridge/br_input.c  (mode:100644 sha1:2b1cce46cab42f71faee654e91c9fdfc2a224551)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/bridge/br_input.c  (mode:100644 sha1:fba022bc5f423b3c7b32cfb7b9c3720f55289ef4)
@@ -23,11 +23,7 @@
 
 static int br_pass_frame_up_finish(struct sk_buff *skb)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug = 0;
-#endif
 	netif_rx(skb);
-
 	return 0;
 }
 
Index: net/bridge/br_netfilter.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/bridge/br_netfilter.c  (mode:100644 sha1:be03d3ad264849f1e726b2e3ab76de1d0c44527d)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/bridge/br_netfilter.c  (mode:100644 sha1:03ae4edddac35bf6dbfa8773f9031279b9aa4dd1)
@@ -102,10 +102,6 @@
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_PRE_ROUTING);
-#endif
-
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
@@ -182,10 +178,6 @@
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
@@ -207,10 +199,6 @@
 	struct iphdr *iph = skb->nh.iph;
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_PRE_ROUTING);
-#endif
-
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
@@ -382,9 +370,6 @@
 	if (hdr->nexthdr == NEXTHDR_HOP && check_hbh_len(skb))
 			goto inhdr_error;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_IP6_PRE_ROUTING);
-#endif
 	if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
 		return NF_DROP;
 	setup_pre_routing(skb);
@@ -468,9 +453,6 @@
 			skb->ip_summed = CHECKSUM_NONE;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_IP_PRE_ROUTING);
-#endif
 	if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
 		return NF_DROP;
 	setup_pre_routing(skb);
@@ -517,10 +499,6 @@
 	struct net_device *in;
 	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
-
 	if (skb->protocol != __constant_htons(ETH_P_ARP) && !IS_VLAN_ARP) {
 		in = nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
@@ -566,9 +544,6 @@
 		(*pskb)->nh.raw += VLAN_HLEN;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
 	nf_bridge = skb->nf_bridge;
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
@@ -605,10 +580,6 @@
 		(*pskb)->nh.raw += VLAN_HLEN;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug ^= (1 << NF_BR_FORWARD);
-#endif
-
 	if (skb->nh.arph->ar_pln != 4) {
 		if (IS_VLAN_ARP) {
 			skb_push(*pskb, VLAN_HLEN);
@@ -627,9 +598,6 @@
 /* PF_BRIDGE/LOCAL_OUT ***********************************************/
 static int br_nf_local_out_finish(struct sk_buff *skb)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-	skb->nf_debug &= ~(1 << NF_BR_LOCAL_OUT);
-#endif
 	if (skb->protocol == __constant_htons(ETH_P_8021Q)) {
 		skb_push(skb, VLAN_HLEN);
 		skb->nh.raw -= VLAN_HLEN;
@@ -731,10 +699,6 @@
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
@@ -779,8 +743,6 @@
 		printk(KERN_CRIT "br_netfilter: skb->dst == NULL.");
 		goto print_error;
 	}
-
-	skb->nf_debug ^= (1 << NF_IP_POST_ROUTING);
 #endif
 
 	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
Index: net/core/netfilter.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/core/netfilter.c  (mode:100644 sha1:22a8f127c4aad9821e5f3294aa518807165ee8b7)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/core/netfilter.c  (mode:100644 sha1:076c156d5eda98345230d52b7d0f75a34cb0141b)
@@ -141,136 +141,6 @@
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
@@ -488,14 +358,6 @@
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
Index: net/core/skbuff.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/core/skbuff.c  (mode:100644 sha1:f65b3de590a96ff2ecc7df6b7a4b9020a641e549)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/core/skbuff.c  (mode:100644 sha1:6d68c03bc0516291f71a3b98030d72ee8f71297f)
@@ -365,9 +365,6 @@
 	C(nfct);
 	nf_conntrack_get(skb->nfct);
 	C(nfctinfo);
-#ifdef CONFIG_NETFILTER_DEBUG
-	C(nf_debug);
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	C(nf_bridge);
 	nf_bridge_get(skb->nf_bridge);
@@ -432,9 +429,6 @@
 	new->nfct	= old->nfct;
 	nf_conntrack_get(old->nfct);
 	new->nfctinfo	= old->nfctinfo;
-#ifdef CONFIG_NETFILTER_DEBUG
-	new->nf_debug	= old->nf_debug;
-#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	new->nf_bridge	= old->nf_bridge;
 	nf_bridge_get(old->nf_bridge);
Index: net/ipv4/ip_input.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv4/ip_input.c  (mode:100644 sha1:a0d0833034be70703a8b9f6c184394cd55079f7a)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv4/ip_input.c  (mode:100644 sha1:a793b62acc117353c849ac73b437a8aa9951ffda)
@@ -200,10 +200,6 @@
 {
 	int ihl = skb->nh.iph->ihl*4;
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	nf_debug_ip_local_deliver(skb);
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 	__skb_pull(skb, ihl);
 
 	/* Free reference early: we don't need it any more, and it may
Index: net/ipv4/ip_output.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv4/ip_output.c  (mode:100644 sha1:24fe3e00b42b0bb673be5a6d8ceb15defb192974)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv4/ip_output.c  (mode:100644 sha1:036e4e5e659aaab5d983e7cc20d0e27ee3cf9a0e)
@@ -107,10 +107,6 @@
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
@@ -192,10 +188,6 @@
 		skb = skb2;
 	}
 
-#ifdef CONFIG_NETFILTER_DEBUG
-	nf_debug_ip_finish_output2(skb);
-#endif /*CONFIG_NETFILTER_DEBUG*/
-
 	nf_reset(skb);
 
 	if (hh) {
@@ -415,9 +407,6 @@
 	to->nf_bridge = from->nf_bridge;
 	nf_bridge_get(to->nf_bridge);
 #endif
-#ifdef CONFIG_NETFILTER_DEBUG
-	to->nf_debug = from->nf_debug;
-#endif
 #endif
 }
 
Index: net/ipv4/ipvs/ip_vs_xmit.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv4/ipvs/ip_vs_xmit.c  (mode:100644 sha1:faa6176bbeb195eb37329964d092c377a2489890)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv4/ipvs/ip_vs_xmit.c  (mode:100644 sha1:d42f9ec84ba314833b73ccc988c899fae65cd481)
@@ -127,7 +127,6 @@
 
 #define IP_VS_XMIT(skb, rt)				\
 do {							\
-	nf_reset_debug(skb);				\
 	(skb)->nfcache |= NFC_IPVS_PROPERTY;		\
 	(skb)->ip_summed = CHECKSUM_NONE;		\
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, (skb), NULL,	\
Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644 sha1:28d9425d5c390dac7601953e65043e973833e7aa)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644 sha1:1b1b2ec78ed3497c6b47b3c72951bc3c7ae9b221)
@@ -941,9 +941,6 @@
 ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
 	struct sock *sk = skb->sk;
-#ifdef CONFIG_NETFILTER_DEBUG
-	unsigned int olddebug = skb->nf_debug;
-#endif
 
 	if (sk) {
 		sock_hold(sk);
@@ -967,10 +964,6 @@
 
 	ip_send_check(skb->nh.iph);
 	skb->nfcache |= NFC_ALTERED;
-#ifdef CONFIG_NETFILTER_DEBUG
-	/* Packet path as if nothing had happened. */
-	skb->nf_debug = olddebug;
-#endif
 	return skb;
 }
 
Index: net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644 sha1:1637b96d8c0110c155efd1fe7492570cfdb34650)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644 sha1:d667e7ff3e8f21923a8eb3ee92f67fdbeeb64e0d)
@@ -142,9 +142,6 @@
 	/* Transfer socket to new skb. */
 	if ((*pskb)->sk)
 		skb_set_owner_w(nskb, (*pskb)->sk);
-#ifdef CONFIG_NETFILTER_DEBUG
-	nskb->nf_debug = (*pskb)->nf_debug;
-#endif
 	kfree_skb(*pskb);
 	*pskb = nskb;
 	return 1;
Index: net/ipv6/ip6_output.c
===================================================================
--- 146f2a6d02fa64ea36e0e9cf2d9bfeeb1e0d2c83/net/ipv6/ip6_output.c  (mode:100644 sha1:0f0711417c9da71d7595e6019033b8976d479b03)
+++ 2cfdb1827d9c176f4df42619c693e7b990a61963/net/ipv6/ip6_output.c  (mode:100644 sha1:6ad7f47678e2a4662e47f524425c789846423881)
@@ -484,9 +484,6 @@
 	to->nf_bridge = from->nf_bridge;
 	nf_bridge_get(to->nf_bridge);
 #endif
-#ifdef CONFIG_NETFILTER_DEBUG
-	to->nf_debug = from->nf_debug;
-#endif
 #endif
 }
 

--------------080709060302000705000202--
