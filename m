From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: bridge netfilter: deal with martians correctly
Date: Mon,  4 Dec 2006 11:56:03 +0100 (MET)
Message-ID: <20061204105913.6456.38138.sendpatchset@localhost.localdomain>
References: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
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

[NETFILTER]: bridge netfilter: deal with martians correctly

The attached patch resolves an issue where a IP DNATed packet with a
martian source is forwarded while it's better to drop it. It also
resolves messages complaining about ip forwarding being disabled while
it's actually enabled. Thanks to lepton <ytht.net@gmail.com> for
reporting this problem.

This is probably a candidate for the -stable release.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a2c49af72d2edaa200fed12d840e9b2a37e266f5
tree dab62da592c8991515a487687aebf5da0696b48d
parent b7c3fd1079bf21b37b3135466418a2576d7d5fa1
author Bart De Schuymer <bdschuym@pandora.be> Mon, 04 Dec 2006 11:42:25 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 04 Dec 2006 11:42:25 +0100

 net/bridge/br_netfilter.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ac47ba2..bd221ad 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -34,6 +34,7 @@ #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_arp.h>
 #include <linux/in_route.h>
+#include <linux/inetdevice.h>
 
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -221,10 +222,14 @@ static void __br_dnat_complain(void)
  *
  * Otherwise, the packet is considered to be routed and we just
  * change the destination MAC address so that the packet will
- * later be passed up to the IP stack to be routed.
+ * later be passed up to the IP stack to be routed. For a redirected
+ * packet, ip_route_input() will give back the localhost as output device,
+ * which differs from the bridge device.
  *
  * Let us now consider the case that ip_route_input() fails:
  *
+ * This can be because the destination address is martian, in which case
+ * the packet will be dropped.
  * After a "echo '0' > /proc/sys/net/ipv4/ip_forward" ip_route_input()
  * will fail, while __ip_route_output_key() will return success. The source
  * address for __ip_route_output_key() is set to zero, so __ip_route_output_key
@@ -237,7 +242,8 @@ static void __br_dnat_complain(void)
  *
  * --Lennert, 20020411
  * --Bart, 20020416 (updated)
- * --Bart, 20021007 (updated) */
+ * --Bart, 20021007 (updated)
+ * --Bart, 20062711 (updated) */
 static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 {
 	if (skb->pkt_type == PACKET_OTHERHOST) {
@@ -264,15 +270,15 @@ static int br_nf_pre_routing_finish(stru
 	struct net_device *dev = skb->dev;
 	struct iphdr *iph = skb->nh.iph;
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	int err;
 
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
 	}
 	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
-
 	if (dnat_took_place(skb)) {
-		if (ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev)) {
+		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct rtable *rt;
 			struct flowi fl = {
 				.nl_u = {
@@ -283,19 +289,33 @@ static int br_nf_pre_routing_finish(stru
 				},
 				.proto = 0,
 			};
+			struct in_device *in_dev = in_dev_get(dev);
+
+			/* If err equals -EHOSTUNREACH the error is due to a
+			 * martian destination or due to the fact that
+			 * forwarding is disabled. For most martian packets,
+			 * ip_route_output_key() will fail. It won't fail for 2 types of
+			 * martian destinations: loopback destinations and destination
+			 * 0.0.0.0. In both cases the packet will be dropped because the
+			 * destination is the loopback device and not the bridge. */
+			if (err != -EHOSTUNREACH || !in_dev || IN_DEV_FORWARD(in_dev))
+				goto free_skb;
 
 			if (!ip_route_output_key(&rt, &fl)) {
 				/* - Bridged-and-DNAT'ed traffic doesn't
-				 *   require ip_forwarding.
-				 * - Deal with redirected traffic. */
-				if (((struct dst_entry *)rt)->dev == dev ||
-				    rt->rt_type == RTN_LOCAL) {
+				 *   require ip_forwarding. */
+				if (((struct dst_entry *)rt)->dev == dev) {
 					skb->dst = (struct dst_entry *)rt;
 					goto bridged_dnat;
 				}
+				/* we are sure that forwarding is disabled, so printing
+				 * this message is no problem. Note that the packet could
+				 * still have a martian destination address, in which case
+				 * the packet could be dropped even if forwarding were enabled */
 				__br_dnat_complain();
 				dst_release((struct dst_entry *)rt);
 			}
+free_skb:
 			kfree_skb(skb);
 			return 0;
 		} else {
