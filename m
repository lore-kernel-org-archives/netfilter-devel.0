From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] netfilter: nf_tables: Report transactions' process info to user space
Date: Mon, 15 May 2017 16:51:49 +0200
Message-ID: <20170515145149.26114-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45301 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965547AbdEOOwC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 10:52:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When committing a transaction, report PID and name of user space process
which initiated it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 16 +++++++++++
 net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 683f6f88fcace..7c012690a5f02 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -90,6 +90,7 @@ enum nft_verdicts {
  * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_PROC_INFO: get info about user space process which initiated the transaction
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -114,6 +115,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_GETOBJ,
 	NFT_MSG_DELOBJ,
 	NFT_MSG_GETOBJ_RESET,
+	NFT_MSG_PROC_INFO,
 	NFT_MSG_MAX,
 };
 
@@ -1375,4 +1377,18 @@ enum nft_ng_types {
 };
 #define NFT_NG_MAX	(__NFT_NG_MAX - 1)
 
+/**
+ * enum nft_proc_info_attributes - nf_tables process information netlink attributes
+ *
+ * @NFTA_PROC_PID: process id (NLA_U32)
+ * @NFTA_PROC_NAME: process name (NLA_STRING)
+ */
+enum nft_proc_info_attributes {
+	NFTA_PROC_UNSPEC,
+	NFTA_PROC_PID,
+	NFTA_PROC_NAME,
+	__NFTA_PROC_MAX
+};
+#define NFTA_PROC_MAX	(__NFTA_PROC_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c6482d2c4dcf..7cdfbecbcd542 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
@@ -4748,6 +4749,49 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void nf_tables_proc_notify(const struct nft_ctx *ctx)
+{
+	char buf[TASK_COMM_LEN];
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	int event;
+
+	if (!ctx->report &&
+	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
+		return;
+
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_PROC_INFO);
+	nlh = nlmsg_put(skb, ctx->portid, ctx->seq,
+			event, sizeof(struct nfgenmsg), 0);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+
+	if (nla_put_be32(skb, NFTA_PROC_PID, htonl(task_pid_nr(current))) ||
+	    nla_put_string(skb, NFTA_PROC_NAME, get_task_comm(buf, current)))
+		goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+	nfnetlink_send(skb, ctx->net, ctx->portid,
+		       NFNLGRP_NFTABLES, ctx->report, GFP_KERNEL);
+	return;
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	kfree_skb(skb);
+err:
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
@@ -4764,6 +4808,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	 */
 	synchronize_rcu();
 
+	trans = list_first_entry_or_null(&net->nft.commit_list,
+					 struct nft_trans, list);
+	if (trans)
+		nf_tables_proc_notify(&trans->ctx);
+
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
-- 
2.11.0

