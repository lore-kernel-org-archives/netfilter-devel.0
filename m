From: Horms <horms@verge.net.au>
Subject: [patch 3/3] Replace reverse_route() with a call to
	ip_route_me_harder()
Date: Tue, 19 Sep 2006 11:45:10 +0900
Message-ID: <20060919025203.875028000@tabatha.lab.ultramonkey.org>
References: <20060919024507.458115000@tabatha.lab.ultramonkey.org>
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline;
	filename=ip_route_me_harder-reverse_route-merge.patch
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

*** Please review this patch carefully, I'm not sure that it is correct ***

ip_route_me_harder() can now be passed the address type,
which means that inet_addr_type() is not called internally,
and thus ip_route_me_harder() is now reasonably cheap.

Make use of this by replacing ipt_REJECT's the reverse route,
which is largely a duplication of ip_route_me_harder().

Signed-Off-By: Simon Horman <horms@verge.net.au>

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index b81821e..bfbeb37 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -38,13 +38,9 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-static inline struct rtable *route_reverse(struct sk_buff *skb, 
-					   struct tcphdr *tcph, int hook)
+static inline send_reset_route(struct sk_buff **pskb)
 {
-	struct iphdr *iph = skb->nh.iph;
-	struct dst_entry *odst;
-	struct flowi fl = {};
-	struct rtable *rt;
+	int addr_type;
 
 	/* We don't require ip forwarding to be enabled to be able to
 	 * send a RST reply for bridged traffic. */
@@ -52,49 +48,12 @@ static inline struct rtable *route_rever
 #ifdef CONFIG_BRIDGE_NETFILTER
 	    || (skb->nf_bridge && skb->nf_bridge->mask & BRNF_BRIDGED)
 #endif
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
+	   )
+		addr_type = 1;
+	} else
+		addr_type = 2;
 
-	return rt;
+	return ip_route_me_harder(pskb, addr_type);
 }
 
 /* Send RST reply */
@@ -107,7 +66,6 @@ static void send_reset(struct sk_buff *o
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
 	int needs_ack;
-	int hh_len;
 
 	/* IP header checks: fragment. */
 	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET))
@@ -129,12 +87,12 @@ static void send_reset(struct sk_buff *o
 	if ((rt = route_reverse(oldskb, oth, hook)) == NULL)
 		return;
 
-	hh_len = LL_RESERVED_SPACE(rt->u.dst.dev);
-
 	/* We need a linear, writeable skb.  We also need to expand
 	   headroom in case hh_len of incoming interface < hh_len of
-	   outgoing interface */
-	nskb = skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
+	   outgoing interface. As routing happens later, using
+	   ip_route_me_harder(), LL_MAX_HEADER is used as hh_len,
+	   to ensure there will always be enough space. */
+	nskb = skb_copy_expand(oldskb, LL_MAX_HEADER, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
 	if (!nskb) {
 		dst_release(&rt->u.dst);
@@ -204,6 +162,10 @@ static void send_reset(struct sk_buff *o
 	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
 					   nskb->nh.iph->ihl);
 
+	/* Route - this may not need to be so late */
+	if (ip_route_me_harder(nskb) < 0)
+		goto free_nskb;
+
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(nskb->dst))
 		goto free_nskb;

--

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
