From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 4/18]: Apply PRE_ROUTING manips in LOCAL_OUT for locally
 generated icmp errors
Date: Mon, 20 Dec 2004 08:14:19 +0100
Message-ID: <41C67BCB.8070700@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090104050701090107070307"
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
--------------090104050701090107070307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Locally generated ICMP errors never hit PRE_ROUTING,
apply their manips in LOCAL_OUT. Fixes invalid
addressed ICMP errors for SNATed packets.


--------------090104050701090107070307
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 22:15:40+01:00 kaber@coreworks.de 
#   [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally generated icmp errors
#   
#   Locally generated ICMP errors never hit PRE_ROUTING. Fixes invalid
#   addressed ICMP errors for SNATed packets.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/12/05 22:15:39+01:00 kaber@coreworks.de +8 -0
#   [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally generated icmp errors
#   
#   Locally generated ICMP errors never hit PRE_ROUTING. Fixes invalid
#   addressed ICMP errors for SNATed packets.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:28 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:28 +01:00
@@ -918,6 +918,14 @@
 		/* Mapping the inner packet is just like a normal packet, except
 		 * it was never src/dst reversed, so where we would normally
 		 * apply a dst manip, we apply a src, and vice versa. */
+
+		/* Only true for forwarded packets, locally generated packets
+		 * never hit PRE_ROUTING, we need to apply their PRE_ROUTING
+		 * manips in LOCAL_OUT. */
+		if (hooknum == NF_IP_LOCAL_OUT &&
+		    info->manips[i].hooknum == NF_IP_PRE_ROUTING)
+			hooknum = info->manips[i].hooknum;
+
 		if (info->manips[i].hooknum != hooknum)
 			continue;
 

--------------090104050701090107070307--
