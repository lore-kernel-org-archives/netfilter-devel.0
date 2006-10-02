From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: ipt_REJECT: remove largely duplicate
	route_reverse function
Date: Mon,  2 Oct 2006 17:46:08 +0200 (MEST)
Message-ID: <20061002154721.13121.67962.sendpatchset@localhost.localdomain>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_REJECT: remove largely duplicate route_reverse function

Use ip_route_me_harder instead, which now allows to specify how we wish
the packet to be routed.

Based on patch by Simon Horman <horms@verge.net.au>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 606add40816396611545a6239c1029a473448d9f
tree 6a1e6e137c44132154b94a60ae10733f174f4ec2
parent 1bc8aeeaf12d73774421e408d7f6461a20cebc5e
author Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:49 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:49 +0200

 net/ipv4/netfilter/ipt_REJECT.c |   97 ++++++++-------------------------------
 1 files changed, 19 insertions(+), 78 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index fd0c05e..ad0312d 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -38,76 +38,16 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-static inline struct rtable *route_reverse(struct sk_buff *skb, 
-					   struct tcphdr *tcph, int hook)
-{
-	struct iphdr *iph = skb->nh.iph;
-	struct dst_entry *odst;
-	struct flowi fl = {};
-	struct rtable *rt;
-
-	/* We don't require ip forwarding to be enabled to be able to
-	 * send a RST reply for bridged traffic. */
-	if (hook != NF_IP_FORWARD
-#ifdef CONFIG_BRIDGE_NETFILTER
-	    || (skb->nf_bridge && skb->nf_bridge->mask & BRNF_BRIDGED)
-#endif
-	   ) {
-		fl.nl_u.ip4_u.daddr = iph->saddr;
-		if (hook == NF_IP_LOCAL_IN)
-			fl.nl_u.ip4_u.saddr = iph->daddr;
-		fl.nl_u.ip4_u.tos = RT_TOS(iph->tos);
-
-		if (ip_route_output_key(&rt, &fl) != 0)
-			return NULL;
-	} else {
-		/* non-local src, find valid iif to satisfy
-		 * rp-filter when calling ip_route_input. */
-		fl.nl_u.ip4_u.daddr = iph->daddr;
-		if (ip_route_output_key(&rt, &fl) != 0)
-			return NULL;
-
-		odst = skb->dst;
-		if (ip_route_input(skb, iph->saddr, iph->daddr,
-		                   RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
-			dst_release(&rt->u.dst);
-			return NULL;
-		}
-		dst_release(&rt->u.dst);
-		rt = (struct rtable *)skb->dst;
-		skb->dst = odst;
-
-		fl.nl_u.ip4_u.daddr = iph->saddr;
-		fl.nl_u.ip4_u.saddr = iph->daddr;
-		fl.nl_u.ip4_u.tos = RT_TOS(iph->tos);
-	}
-
-	if (rt->u.dst.error) {
-		dst_release(&rt->u.dst);
-		return NULL;
-	}
-
-	fl.proto = IPPROTO_TCP;
-	fl.fl_ip_sport = tcph->dest;
-	fl.fl_ip_dport = tcph->source;
-	security_skb_classify_flow(skb, &fl);
-
-	xfrm_lookup((struct dst_entry **)&rt, &fl, NULL, 0);
-
-	return rt;
-}
-
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
 	struct iphdr *iph = oldskb->nh.iph;
 	struct tcphdr _otcph, *oth, *tcph;
-	struct rtable *rt;
 	__be16 tmp_port;
 	__be32 tmp_addr;
 	int needs_ack;
-	int hh_len;
+	unsigned int addr_type;
 
 	/* IP header checks: fragment. */
 	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET))
@@ -126,23 +66,13 @@ static void send_reset(struct sk_buff *o
 	if (nf_ip_checksum(oldskb, hook, iph->ihl * 4, IPPROTO_TCP))
 		return;
 
-	if ((rt = route_reverse(oldskb, oth, hook)) == NULL)
-		return;
-
-	hh_len = LL_RESERVED_SPACE(rt->u.dst.dev);
-
 	/* We need a linear, writeable skb.  We also need to expand
 	   headroom in case hh_len of incoming interface < hh_len of
 	   outgoing interface */
-	nskb = skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
+	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
-	if (!nskb) {
-		dst_release(&rt->u.dst);
+	if (!nskb)
 		return;
-	}
-
-	dst_release(nskb->dst);
-	nskb->dst = &rt->u.dst;
 
 	/* This packet will not be the same as the other: clear nf fields */
 	nf_reset(nskb);
@@ -184,6 +114,21 @@ static void send_reset(struct sk_buff *o
 	tcph->window = 0;
 	tcph->urg_ptr = 0;
 
+	/* Set DF, id = 0 */
+	nskb->nh.iph->frag_off = htons(IP_DF);
+	nskb->nh.iph->id = 0;
+
+	addr_type = RTN_UNSPEC;
+	if (hook != NF_IP_FORWARD
+#ifdef CONFIG_BRIDGE_NETFILTER
+	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
+#endif
+	   )
+		addr_type = RTN_LOCAL;
+
+	if (ip_route_me_harder(&nskb, addr_type))
+		goto free_nskb;
+
 	/* Adjust TCP checksum */
 	nskb->ip_summed = CHECKSUM_NONE;
 	tcph->check = 0;
@@ -192,12 +137,8 @@ static void send_reset(struct sk_buff *o
 				   nskb->nh.iph->daddr,
 				   csum_partial((char *)tcph,
 						sizeof(struct tcphdr), 0));
-
-	/* Adjust IP TTL, DF */
+	/* Adjust IP TTL */
 	nskb->nh.iph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
-	/* Set DF, id = 0 */
-	nskb->nh.iph->frag_off = htons(IP_DF);
-	nskb->nh.iph->id = 0;
 
 	/* Adjust IP checksum */
 	nskb->nh.iph->check = 0;
