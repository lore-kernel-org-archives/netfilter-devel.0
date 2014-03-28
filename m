From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem notifications
Date: Fri, 28 Mar 2014 12:46:22 +0100
Message-ID: <20140328114622.8896.14752.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56500 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761AbaC1Lqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:46:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds set_elems notifications.

When a set_elem is added/deleted, all listening peers in userspace will
receive the corresponding notification.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nf_tables_api.c |   68 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..33b1585 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2712,6 +2712,71 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
+				    const struct nft_set *set,
+				    const struct nft_set_elem *elem,
+				    int event, u16 flags)
+{
+	const struct sk_buff *oskb = ctx->skb;
+	struct sk_buff *skb;
+	struct net *net;
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	bool report;
+	u32 portid;
+	u32 seq = ctx->nlh->nlmsg_seq;
+	int err;
+
+	portid = oskb ? NETLINK_CB(oskb).portid : 0;
+	net = oskb ? sock_net(oskb->sk) : &init_net;
+
+	report = ctx->nlh ? nlmsg_report(ctx->nlh) : false;
+	if (!report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
+	if (nlh == NULL)
+		goto err_free;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= 0;
+
+	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
+		goto err_free;
+	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
+		goto err_free;
+
+	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	if (nest == NULL)
+		goto err_free;
+
+	err = nf_tables_fill_setelem(skb, set, elem);
+	if (err < 0)
+		goto err_free;
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+
+	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
+			     GFP_KERNEL);
+err_free:
+	kfree_skb(skb);
+err:
+	if (err < 0)
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
+	return err;
+}
+
 static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -2788,6 +2853,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err3;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
 	return 0;
 
 err3:
@@ -2857,6 +2923,8 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 
 	set->ops->remove(set, &elem);
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);

