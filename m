From: Michal Ludvig <mludvig@suse.cz>
Subject: NAT before IPsec with 2.6
Date: Wed, 21 Jan 2004 13:29:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400E7095.9040709@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000904020509070106080906"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000904020509070106080906
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

with the native IPsec stack in 2.6.1 kernel it's impossible to do SNAT 
on outgoing packets that are leaving through an IPsec link. The problem 
is that the forwarded packets are encapsulated (with IPSec ESP/AH) yet 
before the POSTROUTING chain is reached.

So I hacked up this simple solution - I understand that it won't be 
accepted as-is, because now the POSTROUTING chain is reached twice (once 
from ip_forward and once from ip_output). But anyways - is this a 
correct approach and should I go this way with some cleanups?

Or is there another approach? I was thinking about extending the FORWARD 
chain and let it do SNAT/MASQUERADE. That would be cleaner, but more 
intrusive than my patch and would probably also require some changes in 
the userspace.

Comments, opinions, ...?

(Please Cc me on replies, thanks!)

Michal Ludvig
-- 
SUSE Labs                    mludvig@suse.cz | Cray is the only computer
(+420) 296.545.373        http://www.suse.cz | that runs an endless loop
Personal homepage http://www.logix.cz/michal | in just four hours.

--------------000904020509070106080906
Content-Type: text/plain;
 name="kernel-nat-before-ipsec.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-nat-before-ipsec.diff"

diff -rup linux-2.6.1.orig/net/ipv4/ip_forward.c linux-2.6.1.naga/net/ipv4/ip_forward.c
--- linux-2.6.1.orig/net/ipv4/ip_forward.c	2004-01-16 14:28:39.000000000 +0100
+++ linux-2.6.1.naga/net/ipv4/ip_forward.c	2004-01-20 16:11:09.904466001 +0100
@@ -46,12 +46,30 @@ static inline int ip_forward_finish(stru
 {
 	struct ip_options * opt	= &(IPCB(skb)->opt);
 
+	if (!xfrm4_route_forward(skb))
+		goto drop;
+
+#ifdef CONFIG_NETFILTER_DEBUG
+	skb->nf_debug &= ~(1 << NF_IP_POST_ROUTING);
+#endif
+
 	IP_INC_STATS_BH(IpForwDatagrams);
 
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
 	return dst_output(skb);
+
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static inline int ip_forward_postroute(struct sk_buff *skb)
+{
+	struct rtable *rt = (struct rtable*)skb->dst;
+
+	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, skb->dev, rt->u.dst.dev, ip_forward_finish);
 }
 
 int ip_forward(struct sk_buff *skb)
@@ -109,7 +131,7 @@ int ip_forward(struct sk_buff *skb)
 	skb->priority = rt_tos2priority(iph->tos);
 
 	return NF_HOOK(PF_INET, NF_IP_FORWARD, skb, skb->dev, rt->u.dst.dev,
-		       ip_forward_finish);
+		       ip_forward_postroute);
 
 sr_failed:
         /*

--------------000904020509070106080906--
