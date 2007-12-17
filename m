From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 48/64]: nfnetlink_log: fix checks in nfulnl_recv_config
Date: Tue, 18 Dec 2007 00:47:18 +0100 (MET)
Message-ID: <20071217234718.23601.90304.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39028 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbXLQXrT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:19 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: fix checks in nfulnl_recv_config

Similar to the nfnetlink_queue fixes:

The peer_pid must be checked in all cases when a logging instance exists,
additionally we must check whether an instance exists before attempting
to configure it to avoid NULL ptr dereferences.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5860f7b62d7a9dcdb1ea33f24e2adb621087ff96
tree 76c14d2a2d94309020b84b7ffaf6786d98cae16a
parent b004f3f365c301797f4c40382faed4a4c220aeb1
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:39 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 net/netfilter/nfnetlink_log.c |   49 +++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 02e6357..3dcc6f5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -753,9 +753,15 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	UDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
 	inst = instance_lookup_get(group_num);
+	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
+		ret = -EPERM;
+		goto out_put;
+	}
+
 	if (nfula[NFULA_CFG_CMD]) {
 		u_int8_t pf = nfmsg->nfgen_family;
 		struct nfulnl_msg_config_cmd *cmd;
+
 		cmd = nla_data(nfula[NFULA_CFG_CMD]);
 		UDEBUG("found CFG_CMD for\n");
 
@@ -779,11 +785,6 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				goto out;
 			}
 
-			if (inst->peer_pid != NETLINK_CB(skb).pid) {
-				ret = -EPERM;
-				goto out_put;
-			}
-
 			instance_destroy(inst);
 			goto out;
 		case NFULNL_CFG_CMD_PF_BIND:
@@ -800,29 +801,16 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			ret = -EINVAL;
 			break;
 		}
-
-		if (!inst)
-			goto out;
-	} else {
-		if (!inst) {
-			UDEBUG("no config command, and no instance for "
-				"group=%u pid=%u =>ENOENT\n",
-				group_num, NETLINK_CB(skb).pid);
-			ret = -ENOENT;
-			goto out;
-		}
-
-		if (inst->peer_pid != NETLINK_CB(skb).pid) {
-			UDEBUG("no config command, and wrong pid\n");
-			ret = -EPERM;
-			goto out_put;
-		}
 	}
 
 	if (nfula[NFULA_CFG_MODE]) {
 		struct nfulnl_msg_config_mode *params;
 		params = nla_data(nfula[NFULA_CFG_MODE]);
 
+		if (!inst) {
+			ret = -ENODEV;
+			goto out;
+		}
 		nfulnl_set_mode(inst, params->copy_mode,
 				ntohl(params->copy_range));
 	}
@@ -831,6 +819,10 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		__be32 timeout =
 			*(__be32 *)nla_data(nfula[NFULA_CFG_TIMEOUT]);
 
+		if (!inst) {
+			ret = -ENODEV;
+			goto out;
+		}
 		nfulnl_set_timeout(inst, ntohl(timeout));
 	}
 
@@ -838,6 +830,10 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		__be32 nlbufsiz =
 			*(__be32 *)nla_data(nfula[NFULA_CFG_NLBUFSIZ]);
 
+		if (!inst) {
+			ret = -ENODEV;
+			goto out;
+		}
 		nfulnl_set_nlbufsiz(inst, ntohl(nlbufsiz));
 	}
 
@@ -845,12 +841,21 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		__be32 qthresh =
 			*(__be32 *)nla_data(nfula[NFULA_CFG_QTHRESH]);
 
+		if (!inst) {
+			ret = -ENODEV;
+			goto out;
+		}
 		nfulnl_set_qthresh(inst, ntohl(qthresh));
 	}
 
 	if (nfula[NFULA_CFG_FLAGS]) {
 		__be16 flags =
 			*(__be16 *)nla_data(nfula[NFULA_CFG_FLAGS]);
+
+		if (!inst) {
+			ret = -ENODEV;
+			goto out;
+		}
 		nfulnl_set_flags(inst, ntohs(flags));
 	}
 
