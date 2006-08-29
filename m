From: Horms <horms@verge.net.au>
Subject: LVS-NAT and source routing
Date: Tue, 29 Aug 2006 16:37:53 +0900
Message-ID: <20060829073751.GB23278@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	David Miller <davem@davemloft.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

sorry that this is a little off-topic, but I'm hoping for some
advice in relation to a problem with LVS.

When LVS-NAT is in use (basically load-balancing using DNAT)
then the return packets need to honour any source routing rules
on the linux-director (machine runing LVS). If you think it as
if the packets originate from the linux-director then this makes
sense (if you think about it other ways it doesn't, but I'm pretty
convinced that this is the right way to think about it.

A long time ago Ken Brownfield sent a patch that resolves this problem
by using an old variant of ip_route_me_harder() in ip_vs_out(),
the return patch for LVS-NATed packets.

http://archive.linuxvirtualserver.org/html/lvs-users/2006-03/msg00106.html

I ported this to net-2.6.19 this afternoon, and it seems to
fall out to a call to ip_route_me_harder() . (Nevermind the skb = *pskb,
I'd like to clean that up, but its a separate issue.)

I spoke breifly with Dave Miller about whether calling
ip_route_me_harder() was apprpriate here. His answer was yes, but try
and call it as infrequently as possible as it is expensive. He pointed
me at nf_ip_reroute() and how this is used to minimise calls to
ip_route_me_harder(). However I'm not entirely sure if that techinque is
applicable to LVS, as the need for ip_route_me_harder() seems to be
based on the presance of applicable source routing rules and nothing
else. So here I am.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 3f47ad8..4c05182 100644
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
+ 	if (ip_route_me_harder(pskb) != 0)
+ 		goto drop;
+	skb = *pskb;
+ 
 	IP_VS_DBG_PKT(10, pp, skb, 0, "After SNAT");
 
 	ip_vs_out_stats(cp, skb);
