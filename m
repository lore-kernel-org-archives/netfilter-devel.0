From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/5]: Save a level of indentation in
	icmp_reply_translation
Date: Mon, 29 Nov 2004 00:28:48 +0100
Message-ID: <41AA5F30.4010800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020607010407080309020304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------020607010407080309020304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Trivial cleanup: Save a level of indentation in icmp_reply_translation.



--------------020607010407080309020304
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/27 13:15:30+01:00 kaber@coreworks.de 
#   [NETFILTER]: Save a level of indentation in icmp_reply_translation
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/11/27 13:15:22+01:00 kaber@coreworks.de +25 -29
#   [NETFILTER]: Save a level of indentation in icmp_reply_translation
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:44 +01:00
@@ -877,37 +877,33 @@
 		if (info->manips[i].direction != dir)
 			continue;
 
-		/* Mapping the inner packet is just like a normal
-		   packet, except it was never src/dst reversed, so
-		   where we would normally apply a dst manip, we apply
-		   a src, and vice versa. */
-		if (info->manips[i].hooknum == hooknum) {
-			DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
-			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-			       ? "DST" : "SRC",
-			       NIPQUAD(info->manips[i].manip.ip),
-			       ntohs(info->manips[i].manip.u.udp.port));
-			if (!manip_pkt(inside->ip.protocol, pskb,
-				       (*pskb)->nh.iph->ihl*4
-				       + sizeof(inside->icmp),
-				       &info->manips[i].manip,
-				       !info->manips[i].maniptype))
-				goto unlock_fail;
+		/* Mapping the inner packet is just like a normal packet, except
+		 * it was never src/dst reversed, so where we would normally
+		 * apply a dst manip, we apply a src, and vice versa. */
+		if (info->manips[i].hooknum != hooknum)
+			continue;
 
-			/* Outer packet needs to have IP header NATed like
-	                   it's a reply. */
+		DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
+		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
+		       ? "DST" : "SRC", NIPQUAD(info->manips[i].manip.ip),
+		       ntohs(info->manips[i].manip.u.udp.port));
+		if (!manip_pkt(inside->ip.protocol, pskb,
+			       (*pskb)->nh.iph->ihl*4 + sizeof(inside->icmp),
+			       &info->manips[i].manip,
+			       !info->manips[i].maniptype))
+			goto unlock_fail;
 
-			/* Use mapping to map outer packet: 0 give no
-                           per-proto mapping */
-			DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
-			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-			       ? "SRC" : "DST",
-			       NIPQUAD(info->manips[i].manip.ip));
-			if (!manip_pkt(0, pskb, 0,
-				       &info->manips[i].manip,
-				       info->manips[i].maniptype))
-				goto unlock_fail;
-		}
+		/* Outer packet needs to have IP header NATed like
+                   it's a reply. */
+
+		/* Use mapping to map outer packet: 0 give no
+                          per-proto mapping */
+		DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
+		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
+		       ? "SRC" : "DST", NIPQUAD(info->manips[i].manip.ip));
+		if (!manip_pkt(0, pskb, 0, &info->manips[i].manip,
+			       info->manips[i].maniptype))
+			goto unlock_fail;
 	}
 	READ_UNLOCK(&ip_nat_lock);
 

--------------020607010407080309020304--
