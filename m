From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: [PATCH] ROUTE target fixes for --iif
Date: Tue, 4 May 2004 16:01:51 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040504200151.GA30514@ti64.telemetry-investments.com>
Reply-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Transfer-Encoding: 7bit
Cc: =?iso-8859-1?Q?C=E9dric?= de Launois <delaunois@info.ucl.ac.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I mailed several ROUTE target fixes to C=E9dric de Launois about two
weeks ago, but they weren't ACK'd, so I'm posting a combined patch agains=
t
patch-o-matic-ng here.

Fixes:

  o Insert missing dev_put() following dev_get_by_name().

  o Don't decrement TTL on packets re-injected with route_iif().

  o Fix cut-n-paste error in route_iif() debug message().

  o Dead code removal and a few cleanups.

I'm using the ROUTE target --iif functionality, in combination with the
teql round-robin packet scheduler, to remap incoming packets on multiple
interfaces (in this case hdlc[0-3]) to teql0.  [teql only schedules outgo=
ing
packets; incoming packets appear on the underlying interfaces.]

I'm (so far successfully)  using the following rule,

    iptables -t mangle -A PREROUTING -i hdlc\+ -j ROUTE --iif teql0

to workaround Quagga's neighbor logic, which is otherwise confused
by the asymmetry between sending on teql0, and receiving on hdlc*.

Regards,

	Bill Rugolsky

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="netfilter-route-target-iif-fixes.patch"

--- patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c.iif	2003-12-18 13:47:54.000000000 -0500
+++ patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-04 15:09:35.000000000 -0400
@@ -203,25 +203,21 @@
 static unsigned int route_iif(const struct ipt_route_target_info *route_info,
 			      struct sk_buff *skb) 
 {
-	struct net_device *dev_out = NULL;
-	unsigned int ifindex = 0;
+	struct net_device *dev_in = NULL;
 
 	/* Getting the current interface index. */
-	if ((dev_out = dev_get_by_name(route_info->iif)))
-		ifindex = dev_out->ifindex;
-	else {
-		/* Unknown interface name : packet dropped */
+	if (!(dev_in = dev_get_by_name(route_info->iif))) {
 		if (net_ratelimit()) 
-			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
+			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->iif);
 		return NF_DROP;
 	}
 
-	skb->dev = dev_out;
+	skb->dev = dev_in;
 	dst_release(skb->dst);
 	skb->dst = NULL;
 		
 	netif_rx(skb);
-
+	dev_put(dev_in);
 	return NF_STOLEN;
 }
 
@@ -253,8 +249,8 @@
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
 	 */
-	if (hooknum == NF_IP_PRE_ROUTING ||
-	    hooknum == NF_IP_LOCAL_IN) {
+	if (route_info->iif[0] == '\0' && (hooknum == NF_IP_PRE_ROUTING ||
+	    hooknum == NF_IP_LOCAL_IN)) {
 
 		struct iphdr *iph = skb->nh.iph;
 
@@ -297,10 +293,10 @@
 #endif
 	}
 
-	if (route_info->oif[0]) 
+	if (route_info->oif[0] != '\0') 
 		return route_oif(route_info, *pskb);
 	
-	if (route_info->iif[0]) 
+	if (route_info->iif[0] != '\0') 
 		return route_iif(route_info, *pskb);
 
 	if (route_info->gw) 
--- patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c.iif	2004-02-22 12:29:10.000000000 -0500
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-04 15:11:07.000000000 -0400
@@ -205,25 +205,21 @@
 static unsigned int route_iif(const struct ipt_route_target_info *route_info,
 			      struct sk_buff *skb) 
 {
-	struct net_device *dev_out = NULL;
-	unsigned int ifindex = 0;
+	struct net_device *dev_in = NULL;
 
 	/* Getting the current interface index. */
-	if ((dev_out = dev_get_by_name(route_info->iif)))
-		ifindex = dev_out->ifindex;
-	else {
-		/* Unknown interface name : packet dropped */
+	if (!(dev_in = dev_get_by_name(route_info->iif))) {
 		if (net_ratelimit()) 
-			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->oif);
+			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->iif);
 		return NF_DROP;
 	}
 
-	skb->dev = dev_out;
+	skb->dev = dev_in;
 	dst_release(skb->dst);
 	skb->dst = NULL;
 		
 	netif_rx(skb);
-
+	dev_put(dev_in);
 	return NF_STOLEN;
 }
 
@@ -255,8 +251,8 @@
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
 	 */
-	if (hooknum == NF_IP_PRE_ROUTING ||
-	    hooknum == NF_IP_LOCAL_IN) {
+	if (route_info->iif[0] == '\0' && (hooknum == NF_IP_PRE_ROUTING ||
+	    hooknum == NF_IP_LOCAL_IN)) {
 
 		struct iphdr *iph = skb->nh.iph;
 
@@ -299,10 +295,10 @@
 #endif
 	}
 
-	if (route_info->oif[0]) 
+	if (route_info->oif[0] != '\0') 
 		return route_oif(route_info, *pskb);
 	
-	if (route_info->iif[0]) 
+	if (route_info->iif[0] != '\0') 
 		return route_iif(route_info, *pskb);
 
 	if (route_info->gw) 

--wac7ysb48OaltWcw--
