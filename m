From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/09]: nfnetlink_log: use netlink policy
Date: Thu, 27 Sep 2007 15:46:08 +0200 (MEST)
Message-ID: <20070927134608.10198.294.sendpatchset@localhost.localdomain>
References: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58749 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXI0NqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:09 -0400
In-Reply-To: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: use netlink policy

Also remove unused nfula_min array.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4436902570bdf8c76f313ddacd3ce643e4727bdb
tree a386be61be1d43907d695204e9f9004f9f47ee9c
parent 5ee4018ae6360a2d6aad8068e7a91c82851dc8ec
author Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:23:54 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:23:54 +0200

 net/netfilter/nfnetlink_log.c |   38 +++++++++-----------------------------
 1 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0c25d02..ce4f6bb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -732,29 +732,13 @@ static struct nf_logger nfulnl_logger = {
 	.me	= THIS_MODULE,
 };
 
-static const int nfula_min[NFULA_MAX+1] = {
-	[NFULA_PACKET_HDR]	= sizeof(struct nfulnl_msg_packet_hdr),
-	[NFULA_MARK]		= sizeof(u_int32_t),
-	[NFULA_TIMESTAMP]	= sizeof(struct nfulnl_msg_packet_timestamp),
-	[NFULA_IFINDEX_INDEV]	= sizeof(u_int32_t),
-	[NFULA_IFINDEX_OUTDEV]	= sizeof(u_int32_t),
-	[NFULA_IFINDEX_PHYSINDEV]	= sizeof(u_int32_t),
-	[NFULA_IFINDEX_PHYSOUTDEV]	= sizeof(u_int32_t),
-	[NFULA_HWADDR]		= sizeof(struct nfulnl_msg_packet_hw),
-	[NFULA_PAYLOAD]		= 0,
-	[NFULA_PREFIX]		= 0,
-	[NFULA_UID]		= sizeof(u_int32_t),
-	[NFULA_SEQ]		= sizeof(u_int32_t),
-	[NFULA_SEQ_GLOBAL]	= sizeof(u_int32_t),
-};
-
-static const int nfula_cfg_min[NFULA_CFG_MAX+1] = {
-	[NFULA_CFG_CMD]		= sizeof(struct nfulnl_msg_config_cmd),
-	[NFULA_CFG_MODE]	= sizeof(struct nfulnl_msg_config_mode),
-	[NFULA_CFG_TIMEOUT]	= sizeof(u_int32_t),
-	[NFULA_CFG_QTHRESH]	= sizeof(u_int32_t),
-	[NFULA_CFG_NLBUFSIZ]	= sizeof(u_int32_t),
-	[NFULA_CFG_FLAGS]	= sizeof(u_int16_t),
+static const struct nla_policy nfula_cfg_policy[NFULA_CFG_MAX+1] = {
+	[NFULA_CFG_CMD]		= { .len = sizeof(struct nfulnl_msg_config_cmd) },
+	[NFULA_CFG_MODE]	= { .len = sizeof(struct nfulnl_msg_config_mode) },
+	[NFULA_CFG_TIMEOUT]	= { .type = NLA_U32 },
+	[NFULA_CFG_QTHRESH]	= { .type = NLA_U32 },
+	[NFULA_CFG_NLBUFSIZ]	= { .type = NLA_U32 },
+	[NFULA_CFG_FLAGS]	= { .type = NLA_U16 },
 };
 
 static int
@@ -768,11 +752,6 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 	UDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
-	if (nlattr_bad_size(nfula, NFULA_CFG_MAX, nfula_cfg_min)) {
-		UDEBUG("bad attribute size\n");
-		return -EINVAL;
-	}
-
 	inst = instance_lookup_get(group_num);
 	if (nfula[NFULA_CFG_CMD]) {
 		u_int8_t pf = nfmsg->nfgen_family;
@@ -885,7 +864,8 @@ static const struct nfnl_callback nfulnl_cb[NFULNL_MSG_MAX] = {
 	[NFULNL_MSG_PACKET]	= { .call = nfulnl_recv_unsupp,
 				    .attr_count = NFULA_MAX, },
 	[NFULNL_MSG_CONFIG]	= { .call = nfulnl_recv_config,
-				    .attr_count = NFULA_CFG_MAX, },
+				    .attr_count = NFULA_CFG_MAX,
+				    .policy = nfula_cfg_policy },
 };
 
 static const struct nfnetlink_subsystem nfulnl_subsys = {
