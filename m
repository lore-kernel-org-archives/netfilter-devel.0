From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 3/18]: Save a level of indentation in
	icmp_reply_translation
Date: Mon, 20 Dec 2004 08:14:14 +0100
Message-ID: <41C67BC6.2020200@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090106070804060706020708"
Cc: netfilter-devel@lists.netfilter.org
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
--------------090106070804060706020708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Trivial cleanup: Save a level of indentation in
icmp_reply_translation.


--------------090106070804060706020708
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 22:14:19+01:00 kaber@coreworks.de 
#   [NETFILTER]: Save a level of indentation in icmp_reply_translation
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/12/05 22:14:16+01:00 kaber@coreworks.de +23 -28
#   [NETFILTER]: Save a level of indentation in icmp_reply_translation
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:21 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:21 +01:00
@@ -915,35 +915,30 @@
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
-			manip_pkt(inner->protocol, inner,
-				  skb->len - ((void *)inner - (void *)iph),
-				  &info->manips[i].manip,
-				  !info->manips[i].maniptype,
-				  &skb->nfcache);
-			/* Outer packet needs to have IP header NATed like
-	                   it's a reply. */
+		/* Mapping the inner packet is just like a normal packet, except
+		 * it was never src/dst reversed, so where we would normally
+		 * apply a dst manip, we apply a src, and vice versa. */
+		if (info->manips[i].hooknum != hooknum)
+			continue;
 
-			/* Use mapping to map outer packet: 0 give no
-                           per-proto mapping */
-			DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
-			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
-			       ? "SRC" : "DST",
-			       NIPQUAD(info->manips[i].manip.ip));
-			manip_pkt(0, iph, skb->len,
-				  &info->manips[i].manip,
-				  info->manips[i].maniptype,
-				  &skb->nfcache);
-		}
+		DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
+		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
+		       ? "DST" : "SRC", NIPQUAD(info->manips[i].manip.ip),
+		       ntohs(info->manips[i].manip.u.udp.port));
+		manip_pkt(inner->protocol, inner,
+			  skb->len - ((void *)inner - (void *)iph),
+			  &info->manips[i].manip, !info->manips[i].maniptype,
+			  &skb->nfcache);
+		/* Outer packet needs to have IP header NATed like
+                   it's a reply. */
+
+		/* Use mapping to map outer packet: 0 give no
+                          per-proto mapping */
+		DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
+		       info->manips[i].maniptype == IP_NAT_MANIP_SRC
+		       ? "SRC" : "DST", NIPQUAD(info->manips[i].manip.ip));
+		manip_pkt(0, iph, skb->len, &info->manips[i].manip,
+			  info->manips[i].maniptype, &skb->nfcache);
 	}
 	READ_UNLOCK(&ip_nat_lock);
 

--------------090106070804060706020708--
