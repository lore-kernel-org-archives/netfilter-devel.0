From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] nfqueue message is on a diet
Date: Mon, 13 Feb 2006 03:41:48 +0100
Message-ID: <43EFF1EC.2070701@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020905040704050307080609"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020905040704050307080609
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

[NFNETLINK_QUEUE] nfqueue message is on a diet

Fix oversized message, use NLMSG_SPACE just one since it reserves space
for the netlink header.

Sign-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020905040704050307080609
Content-Type: text/plain;
 name="nfqueue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfqueue.patch"

[NFNETLINK_QUEUE] nfqueue message is on a diet

Fix oversized message, use NLMSG_SPACE just one since it reserves space
for the netlink header.

Sign-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink_queue.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink_queue.c	2006-02-09 17:34:01.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink_queue.c	2006-02-13 01:10:12.000000000 +0100
@@ -354,16 +354,17 @@ nfqnl_build_packet_message(struct nfqnl_
 	QDEBUG("entered\n");
 
 	/* all macros expand to constant values at compile time */
-	size =    NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_hdr))
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
+		+ NLMSG_ALIGN(sizeof(struct nfqnl_msg_packet_hdr))
+		+ NLMSG_ALIGN(sizeof(u_int32_t))	/* ifindex */
+		+ NLMSG_ALIGN(sizeof(u_int32_t))	/* ifindex */
 #ifdef CONFIG_BRIDGE_NETFILTER
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ NLMSG_ALIGN(sizeof(u_int32_t))	/* ifindex */
+		+ NLMSG_ALIGN(sizeof(u_int32_t))	/* ifindex */
 #endif
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* mark */
-		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_hw))
-		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
+		+ NLMSG_ALIGN(sizeof(u_int32_t))	/* mark */
+		+ NLMSG_ALIGN(sizeof(struct nfqnl_msg_packet_hw))
+		+ NLMSG_ALIGN(sizeof(struct nfqnl_msg_packet_timestamp));
 
 	outdev = entinf->outdev;
 

--------------020905040704050307080609--
