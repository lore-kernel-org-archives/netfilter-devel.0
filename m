From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/09]: nfnetlink_queue: fix nfnetlink message size
Date: Tue, 21 Mar 2006 02:55:53 +0100 (MET)
Message-ID: <20060321015553.11977.21959.sendpatchset@localhost.localdomain>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_queue: fix nfnetlink message size

Fix oversized message, use NLMSG_SPACE just one since it reserves space
for the netlink header and NFA_SPACE for every attribute.

Thanks to Harald Welte for the feedback

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 443b1bf80678fcd789ce5c984a3240108bec4736
tree e73cbb17af7e245958829d4583564c7aa9552cb8
parent daab7149ce33d1782bb37355aea08993219bac99
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 20 Mar 2006 14:06:17 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 20 Mar 2006 14:06:17 +0100

 net/netfilter/nfnetlink_queue.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2cf5fb8..b570166 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
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
