From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/5]: Apply PRE_ROUTING manips in LOCAL_OUT for locally
 generated icmp errors
Date: Mon, 29 Nov 2004 00:29:05 +0100
Message-ID: <41AA5F41.4040202@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010607010509010908030009"
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
--------------010607010509010908030009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Locally generated ICMP errors to a non-local IP never hit PRE_ROUTING,
their PRE_ROUTING manips need to be applied in LOCAL_OUT. ICMP errors
for localhost have them applied twice with this patch, but it doesn't
break anything and the next patch avoids it again. Fixes incorrectly
addressed ICMP errors for SNATed packets.



--------------010607010509010908030009
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/27 13:26:24+01:00 kaber@coreworks.de 
#   [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally generated icmp errors
#   
#   Locally generated ICMP errors never hit PRE_ROUTING. Fixes invalid
#   addressed ICMP errors for SNATed packets.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/11/27 13:26:17+01:00 kaber@coreworks.de +8 -0
#   [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally generated icmp errors
#   
#   Locally generated ICMP errors never hit PRE_ROUTING. Fixes invalid
#   addressed ICMP errors for SNATed packets.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:49 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:49 +01:00
@@ -880,6 +880,14 @@
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
 

--------------010607010509010908030009--
