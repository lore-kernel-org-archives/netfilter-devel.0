From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/19]: nfnetlink_queue: use netlink policy
Date: Fri, 28 Sep 2007 18:30:47 +0200 (MEST)
Message-ID: <20070928163047.8394.96579.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbXI1Qas (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:48 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_queue: use netlink policy

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 697cfea5ad56bc42a46706acd713cdad23f55f27
tree 5d2a14298de067a6f480349c4f0da7a13bf21e6a
parent 66650816a6da2ae78bb68487e894922b7ba39942
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:14 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:14 +0200

 net/netfilter/nfnetlink_queue.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1c34668..48e095a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -777,10 +777,10 @@ static struct notifier_block nfqnl_rtnl_notifier = {
 	.notifier_call	= nfqnl_rcv_nl_event,
 };
 
-static const int nfqa_verdict_min[NFQA_MAX+1] = {
-	[NFQA_VERDICT_HDR]	= sizeof(struct nfqnl_msg_verdict_hdr),
-	[NFQA_MARK]		= sizeof(u_int32_t),
-	[NFQA_PAYLOAD]		= 0,
+static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
+	[NFQA_VERDICT_HDR]	= { .len = sizeof(struct nfqnl_msg_verdict_hdr) },
+	[NFQA_MARK]		= { .type = NLA_U32 },
+	[NFQA_PAYLOAD]		= { .type = NLA_UNSPEC },
 };
 
 static int
@@ -796,11 +796,6 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_queue_entry *entry;
 	int err;
 
-	if (nlattr_bad_size(nfqa, NFQA_MAX, nfqa_verdict_min)) {
-		QDEBUG("bad attribute size\n");
-		return -EINVAL;
-	}
-
 	queue = instance_lookup_get(queue_num);
 	if (!queue)
 		return -ENODEV;
@@ -855,9 +850,9 @@ nfqnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
 	return -ENOTSUPP;
 }
 
-static const int nfqa_cfg_min[NFQA_CFG_MAX+1] = {
-	[NFQA_CFG_CMD]		= sizeof(struct nfqnl_msg_config_cmd),
-	[NFQA_CFG_PARAMS]	= sizeof(struct nfqnl_msg_config_params),
+static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
+	[NFQA_CFG_CMD]		= { .len = sizeof(struct nfqnl_msg_config_cmd) },
+	[NFQA_CFG_PARAMS]	= { .len = sizeof(struct nfqnl_msg_config_params) },
 };
 
 static struct nf_queue_handler nfqh = {
@@ -876,11 +871,6 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 	QDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
-	if (nlattr_bad_size(nfqa, NFQA_CFG_MAX, nfqa_cfg_min)) {
-		QDEBUG("bad attribute size\n");
-		return -EINVAL;
-	}
-
 	queue = instance_lookup_get(queue_num);
 	if (nfqa[NFQA_CFG_CMD]) {
 		struct nfqnl_msg_config_cmd *cmd;
@@ -964,9 +954,11 @@ static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
 	[NFQNL_MSG_PACKET]	= { .call = nfqnl_recv_unsupp,
 				    .attr_count = NFQA_MAX, },
 	[NFQNL_MSG_VERDICT]	= { .call = nfqnl_recv_verdict,
-				    .attr_count = NFQA_MAX, },
+				    .attr_count = NFQA_MAX,
+				    .policy = nfqa_verdict_policy },
 	[NFQNL_MSG_CONFIG]	= { .call = nfqnl_recv_config,
-				    .attr_count = NFQA_CFG_MAX, },
+				    .attr_count = NFQA_CFG_MAX,
+				    .policy = nfqa_cfg_policy },
 };
 
 static const struct nfnetlink_subsystem nfqnl_subsys = {
