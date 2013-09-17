From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v2 3/4] netfilter: nfnetlink: add batch support and use it from nf_tables
Date: Tue, 17 Sep 2013 12:43:12 +0200
Message-ID: <1379414593-17956-4-git-send-email-pablo@netfilter.org>
References: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52646 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3IQKnb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:31 -0400
In-Reply-To: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds batch support for nfnetlink, this allows you
to atomically handle a batch of netlink messages. This is used
by nf_tables to improve the existing atomic rule-set update
approach.

Two new nfnetlink control messages are added for this purpose,
they are:

* NFNL_MSG_BATCH_BEGIN, that indicates the beginning of a batch,
  the nfgenmsg->res_id indicates the nfnetlink subsystem ID.

* NFNL_MSG_BATCH_END, that results in the invocation of the
  ss->commit callback function. If not specified or an error
  ocurred in the batch, the ss->abort function is invoked
  instead.

This allows us to get rid of the NFT_MSG_COMMIT and NFT_MSG_ABORT
nf_tables message types.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h      |    2 +
 include/net/netfilter/nf_tables.h        |    2 +
 include/uapi/linux/netfilter/nf_tables.h |    2 -
 include/uapi/linux/netfilter/nfnetlink.h |    4 +
 net/netfilter/nf_tables_api.c            |   25 ++---
 net/netfilter/nfnetlink.c                |  171 +++++++++++++++++++++++++++++-
 6 files changed, 182 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index cadb740..0aab055 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -23,6 +23,8 @@ struct nfnetlink_subsystem {
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
 	__u8 cb_count;			/* number of callbacks */
 	const struct nfnl_callback *cb;	/* callback for individual types */
+	int (*commit)(struct sk_buff *skb);
+	int (*abort)(struct sk_buff *skb);
 };
 
 extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6b644c2..54c4a5c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -344,6 +344,7 @@ struct nft_rule {
  *	@rule: rule that needs to be updated
  *	@chain: chain that this rule belongs to
  *	@table: table for which this chain applies
+ *	@nlh: netlink header of the message that contain this update
  *	@family: family expressesed as AF_*
  */
 struct nft_rule_trans {
@@ -351,6 +352,7 @@ struct nft_rule_trans {
 	struct nft_rule			*rule;
 	const struct nft_chain		*chain;
 	const struct nft_table		*table;
+	const struct nlmsghdr		*nlh;
 	u8				family;
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d9bf8ea..cbb5c75 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,8 +48,6 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
-	NFT_MSG_COMMIT,
-	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 2889594..596ddd4 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -57,4 +57,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_NFT_COMPAT		11
 #define NFNL_SUBSYS_COUNT		12
 
+/* Reserved control nfnetlink messages */
+#define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
+#define NFNL_MSG_BATCH_END		NLMSG_MIN_TYPE+1
+
 #endif /* _UAPI_NFNETLINK_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c78d36..ec2a566 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1548,6 +1548,7 @@ static int nf_tables_trans_add(struct nft_rule *rule, const struct nft_ctx *ctx)
 	rupd->table = ctx->table;
 	rupd->rule = rule;
 	rupd->family = ctx->afi->family;
+	rupd->nlh = ctx->nlh;
 	list_add(&rupd->list, &ctx->net->nft.commit_list);
 
 	return 0;
@@ -1772,9 +1773,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return err;
 }
 
-static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
-			    const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[])
+static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_trans *rupd, *tmp;
@@ -1800,7 +1799,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 		 */
 		if (nft_rule_is_active(net, rupd->rule)) {
 			nft_rule_clear(net, rupd->rule);
-			nf_tables_rule_notify(skb, nlh, rupd->table,
+			nf_tables_rule_notify(skb, rupd->nlh, rupd->table,
 					      rupd->chain, rupd->rule,
 					      NFT_MSG_NEWRULE, 0,
 					      rupd->family);
@@ -1810,7 +1809,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 
 		/* This rule is in the past, get rid of it */
 		list_del_rcu(&rupd->rule->list);
-		nf_tables_rule_notify(skb, nlh, rupd->table, rupd->chain,
+		nf_tables_rule_notify(skb, rupd->nlh, rupd->table, rupd->chain,
 				      rupd->rule, NFT_MSG_DELRULE, 0,
 				      rupd->family);
 		nf_tables_rule_destroy(rupd->rule);
@@ -1820,9 +1819,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
-			   const struct nlmsghdr *nlh,
-			   const struct nlattr * const nla[])
+static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_trans *rupd, *tmp;
@@ -2804,16 +2801,6 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
-	[NFT_MSG_COMMIT] = {
-		.call		= nf_tables_commit,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_rule_policy,
-	},
-	[NFT_MSG_ABORT] = {
-		.call		= nf_tables_abort,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_rule_policy,
-	},
 };
 
 static const struct nfnetlink_subsystem nf_tables_subsys = {
@@ -2821,6 +2808,8 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.subsys_id	= NFNL_SUBSYS_NFTABLES,
 	.cb_count	= NFT_MSG_MAX,
 	.cb		= nf_tables_cb,
+	.commit		= nf_tables_commit,
+	.abort		= nf_tables_abort,
 };
 
 /*
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 572d87d..8dde792 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -147,9 +147,6 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	const struct nfnetlink_subsystem *ss;
 	int type, err;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
 	/* All the messages must at least contain nfgenmsg */
 	if (nlmsg_len(nlh) < sizeof(struct nfgenmsg))
 		return 0;
@@ -217,9 +214,175 @@ replay:
 	}
 }
 
+static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
+				u_int16_t subsys_id)
+{
+	struct sk_buff *nskb, *oskb = skb;
+	struct net *net = sock_net(skb->sk);
+	const struct nfnetlink_subsystem *ss;
+	const struct nfnl_callback *nc;
+	bool success = true, done = false;
+	int err;
+
+	if (subsys_id >= NFNL_SUBSYS_COUNT)
+		return netlink_ack(skb, nlh, -EINVAL);
+replay:
+	nskb = netlink_skb_clone(oskb, GFP_KERNEL);
+	if (!nskb)
+		return netlink_ack(oskb, nlh, -ENOMEM);
+
+	nskb->sk = oskb->sk;
+	skb = nskb;
+
+	nfnl_lock(subsys_id);
+	ss = rcu_dereference_protected(table[subsys_id].subsys,
+				       lockdep_is_held(&table[subsys_id].mutex));
+	if (!ss) {
+#ifdef CONFIG_MODULES
+		nfnl_unlock(subsys_id);
+		request_module("nfnetlink-subsys-%d", subsys_id);
+		nfnl_lock(subsys_id);
+		ss = rcu_dereference_protected(table[subsys_id].subsys,
+					       lockdep_is_held(&table[subsys_id].mutex));
+		if (!ss)
+#endif
+		{
+			nfnl_unlock(subsys_id);
+			kfree_skb(nskb);
+			return netlink_ack(skb, nlh, -EOPNOTSUPP);
+		}
+	}
+
+	if (!ss->commit || !ss->abort) {
+		nfnl_unlock(subsys_id);
+		kfree_skb(nskb);
+		return netlink_ack(skb, nlh, -EOPNOTSUPP);
+	}
+
+	while (skb->len >= nlmsg_total_size(0)) {
+		int msglen, type;
+
+		nlh = nlmsg_hdr(skb);
+		err = 0;
+
+		if (nlh->nlmsg_len < NLMSG_HDRLEN) {
+			err = -EINVAL;
+			goto ack;
+		}
+
+		/* Only requests are handled by the kernel */
+		if (!(nlh->nlmsg_flags & NLM_F_REQUEST)) {
+			err = -EINVAL;
+			goto ack;
+		}
+
+		type = nlh->nlmsg_type;
+		if (type == NFNL_MSG_BATCH_END) {
+			done = true;
+			goto done;
+		} else if (type < NLMSG_MIN_TYPE) {
+			err = -EINVAL;
+			goto ack;
+		}
+
+		/* We only accept a batch with messages for the same
+		 * subsystem.
+		 */
+		if (NFNL_SUBSYS_ID(type) != subsys_id) {
+			err = -EINVAL;
+			goto ack;
+		}
+
+		nc = nfnetlink_find_client(type, ss);
+		if (!nc) {
+			err = -EINVAL;
+			goto ack;
+		}
+
+		{
+			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
+			u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
+			struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+			struct nlattr *attr = (void *)nlh + min_len;
+			int attrlen = nlh->nlmsg_len - min_len;
+
+			err = nla_parse(cda, ss->cb[cb_id].attr_count,
+					attr, attrlen, ss->cb[cb_id].policy);
+			if (err < 0)
+				goto ack;
+
+			if (nc->call) {
+				err = nc->call(net->nfnl, skb, nlh,
+					       (const struct nlattr **)cda);
+			}
+
+			/* The lock was released to autoload some module, we
+			 * have to abort and start from scratch using the
+			 * original skb.
+			 */
+			if (err == -EAGAIN) {
+				ss->abort(skb);
+				nfnl_unlock(subsys_id);
+				kfree_skb(nskb);
+				goto replay;
+			}
+		}
+ack:
+		if (nlh->nlmsg_flags & NLM_F_ACK || err) {
+			/* We don't stop processing the batch on errors, thus,
+			 * userspace gets all the errors that the batch
+			 * triggers.
+			 */
+			netlink_ack(skb, nlh, err);
+			if (err)
+				success = false;
+		}
+
+		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (msglen > skb->len)
+			msglen = skb->len;
+		skb_pull(skb, msglen);
+	}
+done:
+	if (success && done)
+		ss->commit(skb);
+	else
+		ss->abort(skb);
+
+	nfnl_unlock(subsys_id);
+	kfree_skb(nskb);
+}
+
 static void nfnetlink_rcv(struct sk_buff *skb)
 {
-	netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	struct net *net = sock_net(skb->sk);
+	int msglen;
+
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return netlink_ack(skb, nlh, -EPERM);
+
+	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
+	    skb->len < nlh->nlmsg_len)
+		return;
+
+	if (nlh->nlmsg_type == NFNL_MSG_BATCH_BEGIN) {
+		struct nfgenmsg *nfgenmsg;
+
+		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (msglen > skb->len)
+			msglen = skb->len;
+
+		if (nlh->nlmsg_len < NLMSG_HDRLEN ||
+		    skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
+			return;
+
+		nfgenmsg = nlmsg_data(nlh);
+		skb_pull(skb, msglen);
+		nfnetlink_rcv_batch(skb, nlh, nfgenmsg->res_id);
+	} else {
+		netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
+	}
 }
 
 #ifdef CONFIG_MODULES
-- 
1.7.10.4

