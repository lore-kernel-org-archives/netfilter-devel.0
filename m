From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] [NFQUEUE_NETLINK] Fix nfnetlink message size
Date: Mon, 27 Feb 2006 03:10:24 +0100
Message-ID: <44025F90.2090205@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080402090804030905090007"
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
--------------080402090804030905090007
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Fix oversized message, use NLMSG_SPACE just one since it reserves space
for the netlink header and NFA_SPACE for every attribute.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------080402090804030905090007
Content-Type: text/plain;
 name="queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="queue.patch"

[NFQUEUE_NETLINK] Fix nfnetlink message size

Fix oversized message, use NLMSG_SPACE just one since it reserves space
for the netlink header and NFA_SPACE for every attribute.

Thanks to Harald Welte for the feedback

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink_queue.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink_queue.c	2006-02-25 17:35:11.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink_queue.c	2006-02-25 17:35:15.000000000 +0100
@@ -354,16 +354,17 @@ nfqnl_build_packet_message(struct nfqnl_
 	QDEBUG("entered\n");
 
 	/* all macros expand to constant values at compile time */
-	size =    NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_hdr))
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg)) +
+		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_hdr))
+		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
 #ifdef CONFIG_BRIDGE_NETFILTER
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
+		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
 #endif
-		+ NLMSG_SPACE(sizeof(u_int32_t))	/* mark */
-		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_hw))
-		+ NLMSG_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
+		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
+		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_hw))
+		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
 
 	outdev = entinf->outdev;
 
@@ -388,7 +389,7 @@ nfqnl_build_packet_message(struct nfqnl_
 		else
 			data_len = queue->copy_range;
 		
-		size += NLMSG_SPACE(data_len);
+		size += NFA_SPACE(data_len);
 		break;
 	
 	default:

--------------080402090804030905090007--
