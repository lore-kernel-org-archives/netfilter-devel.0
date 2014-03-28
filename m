From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Fri, 28 Mar 2014 11:55:32 +0000
Message-ID: <20140328115532.GA7280@macbook.localnet>
References: <20140328114622.8896.14752.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54881 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaC1Lzg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:55:36 -0400
Content-Disposition: inline
In-Reply-To: <20140328114622.8896.14752.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 12:46:22PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds set_elems notifications.
> 
> When a set_elem is added/deleted, all listening peers in userspace will
> receive the corresponding notification.

So is the oops you observed with anonymous sets already resolved?

> @@ -2712,6 +2712,71 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
> +				    const struct nft_set *set,
> +				    const struct nft_set_elem *elem,
> +				    int event, u16 flags)
> +{
> +	const struct sk_buff *oskb = ctx->skb;
> +	struct sk_buff *skb;
> +	struct net *net;
> +	struct nfgenmsg *nfmsg;
> +	struct nlmsghdr *nlh;
> +	struct nlattr *nest;
> +	bool report;
> +	u32 portid;
> +	u32 seq = ctx->nlh->nlmsg_seq;
> +	int err;
> +
> +	portid = oskb ? NETLINK_CB(oskb).portid : 0;
> +	net = oskb ? sock_net(oskb->sk) : &init_net;
> +
> +	report = ctx->nlh ? nlmsg_report(ctx->nlh) : false;

All these tests seem overly defensive. We only have the codepath using
nfnetlink to add or delete elements, so it should be very clear which
context members are valid and which aren't. Also you're already using
ctx->nlh before that for initialization of seq.

>From what I can tell, all these tests can be removed and the initialization
can be done unconditionally based on the context.

> +	if (!report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
> +		return 0;
> +
> +	err = -ENOBUFS;
> +	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (skb == NULL)
> +		goto err;
> +
> +	event |= NFNL_SUBSYS_NFTABLES << 8;
> +	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
> +			flags);
> +	if (nlh == NULL)
> +		goto err_free;
> +
> +	nfmsg = nlmsg_data(nlh);
> +	nfmsg->nfgen_family	= ctx->afi->family;
> +	nfmsg->version		= NFNETLINK_V0;
> +	nfmsg->res_id		= 0;
> +
> +	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
> +		goto err_free;
> +	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
> +		goto err_free;
> +
> +	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
> +	if (nest == NULL)
> +		goto err_free;
> +
> +	err = nf_tables_fill_setelem(skb, set, elem);
> +	if (err < 0)
> +		goto err_free;

This single element per message is fine for now since we don't do proper
atomic additions/removals, so we might fail mid way. But please make sure
that userspace is able to handle lists containing multiple elements since
this is way more efficient and should be changed once we do have proper
atomic changes for set elements.

> +
> +	nla_nest_end(skb, nest);
> +	nlmsg_end(skb, nlh);
> +
> +	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
> +			     GFP_KERNEL);
> +err_free:
> +	kfree_skb(skb);
> +err:
> +	if (err < 0)
> +		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
> +	return err;
> +}
> +
>  static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
>  			    const struct nlattr *attr)
>  {

Besides the things mentioned above, your patch looks fine to me.
