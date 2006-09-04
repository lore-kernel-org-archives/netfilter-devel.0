From: Horms <horms@verge.net.au>
Subject: Re: LVS-NAT and source routing
Date: Mon, 4 Sep 2006 12:37:57 +0900
Message-ID: <20060904033754.GA13845@verge.net.au>
References: <20060829073751.GB23278@verge.net.au> <44F4039D.2060909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44F4039D.2060909@trash.net>
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

On Tue, Aug 29, 2006 at 11:06:37AM +0200, Patrick McHardy wrote:
> Horms wrote:
> > Hi,
> > 
> > sorry that this is a little off-topic, but I'm hoping for some
> > advice in relation to a problem with LVS.
> > 
> > When LVS-NAT is in use (basically load-balancing using DNAT)
> > then the return packets need to honour any source routing rules
> > on the linux-director (machine runing LVS). If you think it as
> > if the packets originate from the linux-director then this makes
> > sense (if you think about it other ways it doesn't, but I'm pretty
> > convinced that this is the right way to think about it.
> > 
> > A long time ago Ken Brownfield sent a patch that resolves this problem
> > by using an old variant of ip_route_me_harder() in ip_vs_out(),
> > the return patch for LVS-NATed packets.
> > 
> > http://archive.linuxvirtualserver.org/html/lvs-users/2006-03/msg00106.html
> > 
> > I ported this to net-2.6.19 this afternoon, and it seems to
> > fall out to a call to ip_route_me_harder() . (Nevermind the skb = *pskb,
> > I'd like to clean that up, but its a separate issue.)
> > 
> > I spoke breifly with Dave Miller about whether calling
> > ip_route_me_harder() was apprpriate here. His answer was yes, but try
> > and call it as infrequently as possible as it is expensive. He pointed
> > me at nf_ip_reroute() and how this is used to minimise calls to
> > ip_route_me_harder(). However I'm not entirely sure if that techinque is
> > applicable to LVS, as the need for ip_route_me_harder() seems to be
> > based on the presance of applicable source routing rules and nothing
> > else. So here I am.
> > 
> 
> > + 	/* For policy routing, packets originating from this
> > + 	 * machine itself may be routed differently to packets
> > + 	 * passing through.  We want this packet to be routed as
> > + 	 * if it came from this machine itself.  So re-compute
> > + 	 * the routing information.
> 
> 
> ip_route_me_harder is meant for the opposite case, rerouting locally
> originating packets as if they were forwarded (if the source is
> non-local). For your case just calling ip_route_output_key should be
> faster since it saves the inet_addr_type call. I think nf_ip_reroute
> doesn't help much since you always seem to change the source address,
> but you could make the whole thing depend on CONFIG_IP_MULTIPLE_TABLES.

Hi,

I took a look into this. It seems that the real key is to avoid
uneccesary calls to inet_addr_type(). But it seems that the rest
of ip_route_me_harder() really is needed for ip_vs. If that isn't
correct, please set me straight.

But if it is correct, it really does mean a fair ammount of duplicated
code going into ip_vs_core.c. I wonder if a better option would be
to allow the addr_type to be passed to ip_route_me_harder(). I have
a patch below which expresses this idea. It has the nice advantage
of offering the scope for other callers to supply the addr_type if it
is known, though I am not sure that this can be the case.

An alternate idea, which would offer the current API to current callers
is to move most of the logic of ip_route_me_harder() into a variant 
which accepts addr_type, and simply have ip_route_me_harder() calculate 
addr_type and pass it and the **pskb onto that function.

I'm happy to come up with a patch that expresses that idea,
I find it hard to exrpess code in words.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index ce02c98..5b63a23 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -77,7 +77,7 @@ enum nf_ip_hook_priorities {
 #define SO_ORIGINAL_DST 80
 
 #ifdef __KERNEL__
-extern int ip_route_me_harder(struct sk_buff **pskb);
+extern int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type);
 extern int ip_xfrm_me_harder(struct sk_buff **pskb);
 extern unsigned int nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 				   unsigned int dataoff, u_int8_t protocol);
diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 3f47ad8..1b5701e 100644
--- a/net/ipv4/ipvs/ip_vs_core.c
+++ b/net/ipv4/ipvs/ip_vs_core.c
@@ -813,6 +813,16 @@ ip_vs_out(unsigned int hooknum, struct s
 	skb->nh.iph->saddr = cp->vaddr;
 	ip_send_check(skb->nh.iph);
 
+ 	/* For policy routing, packets originating from this
+ 	 * machine itself may be routed differently to packets
+ 	 * passing through.  We want this packet to be routed as
+ 	 * if it came from this machine itself.  So re-compute
+ 	 * the routing information.
+ 	 */
+ 	if (ip_route_me_harder(pskb, RTN_LOCAL) != 0)
+ 		goto drop;
+	skb = *pskb;
+ 
 	IP_VS_DBG_PKT(10, pp, skb, 0, "After SNAT");
 
 	ip_vs_out_stats(cp, skb);
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index f88347d..3b66f87 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -8,7 +8,7 @@ #include <net/xfrm.h>
 #include <net/ip.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
-int ip_route_me_harder(struct sk_buff **pskb)
+int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct rtable *rt;
@@ -16,10 +16,13 @@ int ip_route_me_harder(struct sk_buff **
 	struct dst_entry *odst;
 	unsigned int hh_len;
 
+	if (addr_type == RTN_UNSPEC)
+		addr_type = inet_addr_type(iph->saddr);
+
 	/* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
 	 * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
 	 */
-	if (inet_addr_type(iph->saddr) == RTN_LOCAL) {
+	if (addr_type == RTN_LOCAL) {
 		fl.nl_u.ip4_u.daddr = iph->daddr;
 		fl.nl_u.ip4_u.saddr = iph->saddr;
 		fl.nl_u.ip4_u.tos = RT_TOS(iph->tos);
@@ -156,7 +159,7 @@ static int nf_ip_reroute(struct sk_buff 
 		if (!(iph->tos == rt_info->tos
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(pskb);
+			return ip_route_me_harder(pskb, RTN_UNSPEC);
 	}
 	return 0;
 }
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index f3b7783..7f5ceac 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -269,7 +269,8 @@ #ifdef CONFIG_XFRM
 		       ct->tuplehash[!dir].tuple.src.u.all
 #endif
 		    )
-			return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+			return ip_route_me_harder(pskb, RTN_UNSPEC) == 0 ?
+				ret : NF_DROP;
 	}
 	return ret;
 }
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 79336cb..62da663 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -157,7 +157,8 @@ #ifdef CONFIG_IP_ROUTE_FWMARK
 		|| (*pskb)->nfmark != nfmark
 #endif
 		|| (*pskb)->nh.iph->tos != tos))
-		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
+		return ip_route_me_harder(pskb, RTN_UNSPEC) == 0 ?
+			ret : NF_DROP;
 
 	return ret;
 }
