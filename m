From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: export rule-set generation ID
Date: Tue,  9 Sep 2014 19:01:45 +0200
Message-ID: <1410282105-12880-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59295 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaIIRA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:00:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the NFT_MSG_GENID command to nf_tables that exposes
the 16-bits ruleset generation ID. This ID is incremented in every
commit. The generation ID is also exposed to userspace through the
nfnetlink res_id header field when dumping object lists.

This generation ID allows a userspace client to detect that an update
has happened between two consecutive object list dumps, so it can
retry from scratch.

This is complementary to the NLM_F_DUMP_INTR approach, which allows
us to detect an interference in the middle one single list dumping.
There is no way to explicitly check that an interference has occurred
between two list dumps from the kernel, since it doesn't know how
many lists the userspace client is actually going to dump.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    2 +
 net/netfilter/nf_tables_api.c            |   64 +++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c000947..351418a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -51,6 +51,7 @@ enum nft_verdicts {
  * @NFT_MSG_NEWSETELEM: create a new set element (enum nft_set_elem_attributes)
  * @NFT_MSG_GETSETELEM: get a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_GENID: get the rule-set generation ID (no attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -68,6 +69,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_GENID,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eac4fab..e5d0e93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -222,6 +222,7 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, u32 portid, u32 seq,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
+	struct net *net = sock_net(skb->sk);
 
 	event |= NFNL_SUBSYS_NFTABLES << 8;
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), flags);
@@ -231,7 +232,7 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, u32 portid, u32 seq,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= 0;
+	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
@@ -690,6 +691,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
+	struct net *net = sock_net(skb->sk);
 
 	event |= NFNL_SUBSYS_NFTABLES << 8;
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), flags);
@@ -699,7 +701,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= 0;
+	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
@@ -1449,6 +1451,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 	struct nlattr *list;
 	const struct nft_rule *prule;
 	int type = event | NFNL_SUBSYS_NFTABLES << 8;
+	struct net *net = sock_net(skb->sk);
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(struct nfgenmsg),
 			flags);
@@ -1458,7 +1461,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= 0;
+	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_RULE_TABLE, table->name))
 		goto nla_put_failure;
@@ -2204,7 +2207,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->afi->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= 0;
+	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -2836,7 +2839,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = ctx.afi->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id       = 0;
+	nfmsg->res_id	    = htons(ctx.net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, ctx.table->name))
 		goto nla_put_failure;
@@ -2917,7 +2920,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->afi->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= 0;
+	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -3204,6 +3207,52 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	return err;
 }
 
+static int nf_tables_fill_genid_info(struct sk_buff *skb, struct net *net,
+				     u32 portid, u32 seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfmsg;
+	int event = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_GENID;
+
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= AF_UNSPEC;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+
+	return nlmsg_end(skb, nlh);
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -EMSGSIZE;
+}
+
+static int nf_tables_getgenid(struct sock *nlsk, struct sk_buff *skb,
+			      const struct nlmsghdr *nlh,
+			      const struct nlattr * const nla[])
+{
+	struct net *net = sock_net(skb->sk);
+	struct sk_buff *skb2;
+	int err;
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb2 == NULL)
+		return -ENOMEM;
+
+	err = nf_tables_fill_genid_info(skb2, net, NETLINK_CB(skb).portid,
+					nlh->nlmsg_seq);
+	if (err < 0)
+		goto err;
+
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+err:
+	kfree_skb(skb2);
+	return err;
+}
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call_batch	= nf_tables_newtable,
@@ -3280,6 +3329,9 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_GENID] = {
+		.call		= nf_tables_getgenid,
+	},
 };
 
 static void nft_chain_commit_update(struct nft_trans *trans)
-- 
1.7.10.4

