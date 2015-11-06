From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 1/3] netfilter: nfnetlink_queue: remove duplicated
 obsolete commands handling
Date: Fri, 6 Nov 2015 09:49:47 +0900
Message-ID: <20151106004947.GB11266@gmail.com>
References: <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35071 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030611AbbKFAtw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 19:49:52 -0500
Received: by pasz6 with SMTP id z6so107403358pas.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2015 16:49:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151106004640.GA11266@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7d81d28..f85a3d3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1116,21 +1116,10 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
 	struct nfqnl_instance *queue;
-	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct net *net = sock_net(ctnl);
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
 	int ret = 0;
 
-	if (nfqa[NFQA_CFG_CMD]) {
-		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
-
-		/* Obsolete commands without queue context */
-		switch (cmd->command) {
-		case NFQNL_CFG_CMD_PF_BIND: return 0;
-		case NFQNL_CFG_CMD_PF_UNBIND: return 0;
-		}
-	}
-
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
 	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {
@@ -1138,7 +1127,9 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		goto err_out_unlock;
 	}
 
-	if (cmd != NULL) {
+	if (nfqa[NFQA_CFG_CMD]) {
+		struct nfqnl_msg_config_cmd *cmd = nla_data(nfqa[NFQA_CFG_CMD]);
+
 		switch (cmd->command) {
 		case NFQNL_CFG_CMD_BIND:
 			if (queue) {
@@ -1161,7 +1152,8 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			break;
 		case NFQNL_CFG_CMD_PF_BIND:
 		case NFQNL_CFG_CMD_PF_UNBIND:
-			break;
+			/* Obsolete commands without queue context */
+			goto err_out_unlock;
 		default:
 			ret = -ENOTSUPP;
 			break;
-- 
1.7.10.4
