From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] ipt_REJECT fixes
Date: Tue, 22 Apr 2003 12:52:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA51F05.2020800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090207090803060008060805"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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
--------------090207090803060008060805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes routing of tcp-rsts and a memory leak in ipt_REJECT.
it also removes an unnecessary declaration and RTO_CONN.

Best regards,
Patrick

--------------090207090803060008060805
Content-Type: text/plain;
 name="01-reject-fixes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-reject-fixes.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1101  -> 1.1102 
#	net/ipv4/netfilter/ipt_REJECT.c	1.10    -> 1.11   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/21	kaber@trash.net	1.1102
# - fix tcp-rst routing
# - fix memory leak
# - remove unecessary "struct in_device" declaration
# - remove RTO_CONN
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	Mon Apr 21 21:26:34 2003
+++ b/net/ipv4/netfilter/ipt_REJECT.c	Mon Apr 21 21:26:34 2003
@@ -11,7 +11,6 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
-struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
@@ -65,10 +64,9 @@
 		return;
 
 	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
-			    local ? oldskb->nh.iph->saddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
-			    0) != 0)
+	if (ip_route_output(&rt, oldskb->nh.iph->saddr,
+			    local ? oldskb->nh.iph->daddr : 0,
+			    RT_TOS(oldskb->nh.iph->tos), 0) != 0)
 		return;
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
@@ -80,8 +78,10 @@
 	   hh_len of incoming interface < hh_len of outgoing interface */
 	nskb = skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
-	if (!nskb)
+	if (!nskb) {
+		dst_release(&rt->u.dst);
 		return;
+	}
 
 	dst_release(nskb->dst);
 	nskb->dst = &rt->u.dst;

--------------090207090803060008060805--
