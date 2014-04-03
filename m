From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Thu, 3 Apr 2014 12:19:03 +0200
Message-ID: <20140403101903.GA15176@localhost>
References: <20140401120606.4305.13228.stgit@nfdev.cica.es>
 <20140403100730.GA11139@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45892 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaDCKTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:19:10 -0400
Content-Disposition: inline
In-Reply-To: <20140403100730.GA11139@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 12:07:30PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 01, 2014 at 02:06:07PM +0200, Arturo Borrero Gonzalez wrote:
> > This patch adds set_elems notifications.
> > 
> > When a set_elem is added/deleted, all listening peers in userspace will
> > receive the corresponding notification.
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> >  net/netfilter/nf_tables_api.c |   82 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 82 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 33045a5..9791c49 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -2723,6 +2723,85 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > +static int nf_tables_fill_setelem_info(const struct nft_ctx *ctx,
> > +				       struct sk_buff *skb;
>                                                           ^
> 
> Did you send me the final patch version?

Just revamped your patch to make it compile. I need it to rebase my
transaction infrastructure upon it.

Find it attached, compile tested only. Please, put a bit more care
next time. Thanks.

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-add-set_elem-notifications.patch"

>From 112423d94f59ae850fc891e442cae882fc75d656 Mon Sep 17 00:00:00 2001
From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Date: Tue, 1 Apr 2014 14:06:07 +0200
Subject: [PATCH] netfilter: nf_tables: add set_elem notifications

This patch adds set_elems notifications. When a set_elem is
added/deleted, all listening peers in userspace will receive the
corresponding notification.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>
---
 net/netfilter/nf_tables_api.c |   83 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bd3381e..0dcc99c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2807,6 +2807,86 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int nf_tables_fill_setelem_info(struct sk_buff *skb,
+				       const struct nft_ctx *ctx, u32 portid,
+				       int event, u32 flags,
+				       const struct nft_set *set,
+				       const struct nft_set_elem *elem)
+{
+	u32 seq = ctx->nlh->nlmsg_seq;
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
+
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
+	err = nf_tables_fill_setelem_info(skb, ctx, 0, event, flags, set, elem);
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
@@ -2887,6 +2967,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 		goto err3;
 	set->nelems++;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
 	return 0;
 
 err3:
@@ -2957,6 +3038,8 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 	set->ops->remove(set, &elem);
 	set->nelems--;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);
-- 
1.7.10.4


--ZGiS0Q5IWpPtfppv--
