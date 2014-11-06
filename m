From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: nfnetlink_log: improve error handling on __build_packet_message()
Date: Thu,  6 Nov 2014 12:32:29 +0100
Message-ID: <1415273550-3526-2-git-send-email-pablo@netfilter.org>
References: <1415273550-3526-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, mleitner@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41342 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFLa4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:30:56 -0500
In-Reply-To: <1415273550-3526-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1) If there's no enough room in the netlink skbuff, then we have a size
   miscalculation bug that needs to be fixed, so warn on this. Kill
   PRINTR macro now that this is unused.

2) Cancel the netlink message that didn't fit into the skbuff, so we still
   have the chance to deliver what is already included in the batch.

3) Don't increment inst->qlen inconditionally. Otherwise, this will not
   show the real number of messages in the log batch on error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cd99294..551142f 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -46,9 +46,6 @@
 /* max packet size is limited by 16-bit struct nfattr nfa_len field */
 #define NFULNL_COPY_RANGE_MAX	(0xFFFF - NLA_HDRLEN)
 
-#define PRINTR(x, args...)	do { if (net_ratelimit()) \
-				     printk(x, ## args); } while (0);
-
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
@@ -402,7 +399,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	struct nfulnl_msg_packet_hdr pmsg;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	sk_buff_data_t old_tail = inst->skb->tail;
 	struct sock *sk;
 	const unsigned char *hwhdrp;
 
@@ -578,11 +574,15 @@ __build_packet_message(struct nfnl_log_net *log,
 			BUG();
 	}
 
-	nlh->nlmsg_len = inst->skb->tail - old_tail;
+	nlmsg_end(inst->skb, nlh);
+	inst->qlen++;
+
 	return 0;
 
 nla_put_failure:
-	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
+	WARN_ONCE(1, "bad nlskb size: %u, tailroom %d\n",
+		  inst->skb->len, skb_tailroom(inst->skb));
+	nlmsg_cancel(inst->skb, nlh);
 	return -1;
 }
 
@@ -702,8 +702,6 @@ nfulnl_log_packet(struct net *net,
 			goto alloc_failure;
 	}
 
-	inst->qlen++;
-
 	__build_packet_message(log, inst, skb, data_len, pf,
 				hooknum, in, out, prefix, plen);
 
-- 
1.7.10.4

