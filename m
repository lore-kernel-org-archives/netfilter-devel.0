From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 39/49]: nfnetlink_queue: fix checks in nfqnl_recv_config
Date: Tue,  4 Dec 2007 13:02:50 +0100 (MET)
Message-ID: <20071204120250.2442.82341.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62222 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXLDMCv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:51 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: fix checks in nfqnl_recv_config

The peer_pid must be checked in all cases when a queue exists, currently
it is not checked if for NFQA_CFG_QUEUE_MAXLEN when a NFQA_CFG_CMD
attribute exists in some cases. Same for the queue existance check,
which can cause a NULL pointer dereference.

Also consistently return -ENODEV for "queue not found". -ENOENT would
be better, but that is already used to indicate a queued skb id doesn't
exist.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f7f606b9d4ede9a47a3fd61e40b6b688f845f8d7
tree fc59720bd96f97ec7c1457f97ed782921776e67b
parent e237561545ccdb708967d2c5ae4030e5ef05bffc
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:06 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:33 +0100

 net/netfilter/nfnetlink_queue.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index bd18de7..4abf62a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -781,8 +781,14 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	QDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
 	queue = instance_lookup_get(queue_num);
+	if (queue && queue->peer_pid != NETLINK_CB(skb).pid) {
+		ret = -EPERM;
+		goto out_put;
+	}
+
 	if (nfqa[NFQA_CFG_CMD]) {
 		struct nfqnl_msg_config_cmd *cmd;
+
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
 		QDEBUG("found CFG_CMD\n");
 
@@ -798,12 +804,6 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		case NFQNL_CFG_CMD_UNBIND:
 			if (!queue)
 				return -ENODEV;
-
-			if (queue->peer_pid != NETLINK_CB(skb).pid) {
-				ret = -EPERM;
-				goto out_put;
-			}
-
 			instance_destroy(queue);
 			break;
 		case NFQNL_CFG_CMD_PF_BIND:
@@ -820,25 +820,13 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			ret = -EINVAL;
 			break;
 		}
-	} else {
-		if (!queue) {
-			QDEBUG("no config command, and no instance ENOENT\n");
-			ret = -ENOENT;
-			goto out_put;
-		}
-
-		if (queue->peer_pid != NETLINK_CB(skb).pid) {
-			QDEBUG("no config command, and wrong pid\n");
-			ret = -EPERM;
-			goto out_put;
-		}
 	}
 
 	if (nfqa[NFQA_CFG_PARAMS]) {
 		struct nfqnl_msg_config_params *params;
 
 		if (!queue) {
-			ret = -ENOENT;
+			ret = -ENODEV;
 			goto out_put;
 		}
 		params = nla_data(nfqa[NFQA_CFG_PARAMS]);
@@ -848,6 +836,11 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 	if (nfqa[NFQA_CFG_QUEUE_MAXLEN]) {
 		__be32 *queue_maxlen;
+
+		if (!queue) {
+			ret = -ENODEV;
+			goto out_put;
+		}
 		queue_maxlen = nla_data(nfqa[NFQA_CFG_QUEUE_MAXLEN]);
 		spin_lock_bh(&queue->lock);
 		queue->queue_maxlen = ntohl(*queue_maxlen);
