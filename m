From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v2] Subject: netfilter: nf_tables: add set_elem
	notifications
Date: Thu, 03 Apr 2014 15:58:58 +0200
Message-ID: <20140403135836.2769.2196.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53854 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbaDCN7C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:59:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds set_elems notifications. When a set_elem is
added/deleted, all listening peers in userspace will receive the
corresponding notification.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>
---
v2: rebased and fixed by Pablo. Tested again by myself.

 net/netfilter/nf_tables_api.c |   82 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bd3381e..60feca9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2807,6 +2807,85 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int nf_tables_fill_setelem_info(struct sk_buff *skb,
+				       const struct nft_ctx *ctx, u32 seq,
+				       u32 portid, int event, u16 flags,
+				       const struct nft_set *set,
+				       const struct nft_set_elem *elem)
+{
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	int err;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= 0;
+
+	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
+		goto nla_put_failure;
+	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
+		goto nla_put_failure;
+
+	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	err = nf_tables_fill_setelem(skb, set, elem);
+	if (err < 0)
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return nlmsg_end(skb, nlh);
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -1;
+}
+
+static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
+				    const struct nft_set *set,
+				    const struct nft_set_elem *elem,
+				    int event, u16 flags)
+{
+	const struct sk_buff *oskb = ctx->skb;
+	struct net *net = sock_net(oskb->sk);
+	u32 portid = NETLINK_CB(oskb).portid;
+	bool report = nlmsg_report(ctx->nlh);
+	struct sk_buff *skb;
+	int err;
+
+	if (!report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
+					  set, elem);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto err;
+	}
+
+	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
+			     GFP_KERNEL);
+err:
+	if (err < 0)
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
+	return err;
+}
+
 static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -2887,6 +2966,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 		goto err3;
 	set->nelems++;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
 	return 0;
 
 err3:
@@ -2957,6 +3037,8 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 	set->ops->remove(set, &elem);
 	set->nelems--;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);

