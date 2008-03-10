From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/09]: nfnetlink_log: fix EPERM when binding/unbinding and instance 0 exists
Date: Mon, 10 Mar 2008 19:26:23 +0100 (MET)
Message-ID: <20080310182625.20404.97754.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYCJS0Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:24 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: fix EPERM when binding/unbinding and instance 0 exists

When binding or unbinding to an address family, the res_id is usually set
to zero. When logging instance 0 already exists and is owned by a different
process, this makes nfunl_recv_config return -EPERM without performing
the bind operation.

Since no operation on the foreign logging instance itself was requested,
this is incorrect. Move bind/unbind commands before the queue instance
permissions checks.

Also remove an incorrect comment.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1db33bfdd9496c38b1f3e41b2e6ff72649d99044
tree 9368563942adff2a0fd84a9fe5463af4d4466eb0
parent 2bb076fe75d4f6542d7a769c6430a8332b776896
author Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:11:12 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:11:12 +0100

 net/netfilter/nfnetlink_log.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index be71091..0edacff 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -702,20 +702,30 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t group_num = ntohs(nfmsg->res_id);
 	struct nfulnl_instance *inst;
+	struct nfulnl_msg_config_cmd *cmd = NULL;
 	int ret = 0;
 
+	if (nfula[NFULA_CFG_CMD]) {
+		u_int8_t pf = nfmsg->nfgen_family;
+		cmd = nla_data(nfula[NFULA_CFG_CMD]);
+
+		/* Commands without queue context */
+		switch (cmd->command) {
+		case NFULNL_CFG_CMD_PF_BIND:
+			return nf_log_register(pf, &nfulnl_logger);
+		case NFULNL_CFG_CMD_PF_UNBIND:
+			nf_log_unregister_pf(pf);
+			return 0;
+		}
+	}
+
 	inst = instance_lookup_get(group_num);
 	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
 		ret = -EPERM;
 		goto out_put;
 	}
 
-	if (nfula[NFULA_CFG_CMD]) {
-		u_int8_t pf = nfmsg->nfgen_family;
-		struct nfulnl_msg_config_cmd *cmd;
-
-		cmd = nla_data(nfula[NFULA_CFG_CMD]);
-
+	if (cmd != NULL) {
 		switch (cmd->command) {
 		case NFULNL_CFG_CMD_BIND:
 			if (inst) {
@@ -738,14 +748,6 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 			instance_destroy(inst);
 			goto out;
-		case NFULNL_CFG_CMD_PF_BIND:
-			ret = nf_log_register(pf, &nfulnl_logger);
-			break;
-		case NFULNL_CFG_CMD_PF_UNBIND:
-			/* This is a bug and a feature.  We cannot unregister
-			 * other handlers, like nfnetlink_inst can */
-			nf_log_unregister_pf(pf);
-			break;
 		default:
 			ret = -ENOTSUPP;
 			break;
