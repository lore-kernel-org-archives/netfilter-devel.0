Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A5AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 21:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjKBVfr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 17:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjKBVfr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 17:35:47 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5702184
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 14:35:40 -0700 (PDT)
Received: from [78.30.35.151] (port=37188 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyfLh-00BA1O-1a; Thu, 02 Nov 2023 22:35:38 +0100
Date:   Thu, 2 Nov 2023 22:35:32 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH v3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZUQWJIzaW2RddJo2@calendula>
References: <20231102145953.2467-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231102145953.2467-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 03:59:53PM +0100, Phil Sutter wrote:
> Set expressions' dump callbacks are not concurrency-safe per-se with
> reset bit set. If two CPUs reset the same element at the same time,
> values may underrun at least with element-attached counters and quotas.
> 
> Prevent this by introducing dedicated callbacks for nfnetlink and the
> asynchronous dump handling to serialize access.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v2:
> - Move the audit_log_nft_set_reset() call into the critical section to
>   protect the table pointer dereference.
> - Drop unused nelems variable from (non-reset) nf_tables_getsetelem().
> ---
>  net/netfilter/nf_tables_api.c | 109 +++++++++++++++++++++++++++++-----
>  1 file changed, 94 insertions(+), 15 deletions(-)

Adds quite a bit of code: I guess because of the copy and paste to add
nf_tables_getsetelem_reset().

More comments below.

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 245a2c5be082..fbf18a3b0915 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5816,10 +5816,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  	nla_nest_end(skb, nest);
>  	nlmsg_end(skb, nlh);
>  
> -	if (dump_ctx->reset && args.iter.count > args.iter.skip)
> -		audit_log_nft_set_reset(table, cb->seq,
> -					args.iter.count - args.iter.skip);
> -
>  	rcu_read_unlock();
>  
>  	if (args.iter.err && args.iter.err != -EMSGSIZE)
> @@ -5835,6 +5831,26 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  	return -ENOSPC;
>  }
>  
> +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> +				   struct netlink_callback *cb)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> +	int ret, skip = cb->args[0];
> +
> +	mutex_lock(&nft_net->commit_mutex);
> +
> +	ret = nf_tables_dump_set(skb, cb);
> +
> +	if (cb->args[0] > skip)
> +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> +					cb->args[0] - skip);
> +
> +	mutex_unlock(&nft_net->commit_mutex);
> +
> +	return ret;
> +}
> +
>  static int nf_tables_dump_set_start(struct netlink_callback *cb)
>  {
>  	struct nft_set_dump_ctx *dump_ctx = cb->data;
> @@ -6046,13 +6062,12 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  	struct netlink_ext_ack *extack = info->extack;
>  	u8 genmask = nft_genmask_cur(info->net);
>  	u8 family = info->nfmsg->nfgen_family;
> -	int rem, err = 0, nelems = 0;
>  	struct net *net = info->net;
>  	struct nft_table *table;
>  	struct nft_set *set;
>  	struct nlattr *attr;
>  	struct nft_ctx ctx;
> -	bool reset = false;
> +	int rem, err = 0;
>  
>  	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
>  				 genmask, 0);
> @@ -6069,9 +6084,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  
>  	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
>  
> -	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
> -		reset = true;
> -
>  	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
>  		struct netlink_dump_control c = {
>  			.start = nf_tables_dump_set_start,
> @@ -6082,7 +6094,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  		struct nft_set_dump_ctx dump_ctx = {
>  			.set = set,
>  			.ctx = ctx,
> -			.reset = reset,
> +			.reset = false,
>  		};
>  
>  		c.data = &dump_ctx;
> @@ -6093,17 +6105,84 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  		return -EINVAL;
>  
>  	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
> -		err = nft_get_set_elem(&ctx, set, attr, reset);
> +		err = nft_get_set_elem(&ctx, set, attr, false);
> +		if (err < 0) {
> +			NL_SET_BAD_ATTR(extack, attr);
> +			break;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +static int nf_tables_getsetelem_reset(struct sk_buff *skb,
> +				      const struct nfnl_info *info,
> +				      const struct nlattr * const nla[])
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(info->net);
> +	struct netlink_ext_ack *extack = info->extack;
> +	u8 genmask = nft_genmask_cur(info->net);
> +	u8 family = info->nfmsg->nfgen_family;
> +	int rem, err = 0, nelems = 0;
> +	struct net *net = info->net;
> +	struct nft_table *table;
> +	struct nft_set *set;
> +	struct nlattr *attr;
> +	struct nft_ctx ctx;
> +
> +	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
> +				 genmask, 0);
> +	if (IS_ERR(table)) {
> +		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
> +		return PTR_ERR(table);
> +	}
> +
> +	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
> +	if (IS_ERR(set))
> +		return PTR_ERR(set);
> +
> +	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
> +
> +	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> +		struct netlink_dump_control c = {
> +			.start = nf_tables_dump_set_start,
> +			.dump = nf_tables_dumpreset_set,
> +			.done = nf_tables_dump_set_done,
> +			.module = THIS_MODULE,
> +		};
> +		struct nft_set_dump_ctx dump_ctx = {
> +			.set = set,
> +			.ctx = ctx,
> +			.reset = true,
> +		};
> +
> +		c.data = &dump_ctx;
> +		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> +	}
> +
> +	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
> +		return -EINVAL;
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return -EINVAL;
> +	rcu_read_unlock();

Existing table and set pointer get invalid from here on, after leaving
rcu read side lock.

> +	mutex_lock(&nft_net->commit_mutex);
> +	rcu_read_lock();

grab mutex and rcu at the same time, back again?

> +	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
> +		err = nft_get_set_elem(&ctx, set, attr, true);
>  		if (err < 0) {
>  			NL_SET_BAD_ATTR(extack, attr);
>  			break;
>  		}
>  		nelems++;
>  	}
> +	audit_log_nft_set_reset(table, nft_net->base_seq, nelems);
>  
> -	if (reset)
> -		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
> -					nelems);
> +	rcu_read_unlock();
> +	mutex_unlock(&nft_net->commit_mutex);
> +	rcu_read_lock();
> +	module_put(THIS_MODULE);
>  
>  	return err;
>  }
> @@ -9128,7 +9207,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
>  		.policy		= nft_set_elem_list_policy,
>  	},
>  	[NFT_MSG_GETSETELEM_RESET] = {
> -		.call		= nf_tables_getsetelem,
> +		.call		= nf_tables_getsetelem_reset,
>  		.type		= NFNL_CB_RCU,
>  		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
>  		.policy		= nft_set_elem_list_policy,
> -- 
> 2.41.0
> 
