Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46E4C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjKIPGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjKIPGJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:06:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEDB35A1
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:06:06 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r16bc-00060t-S2; Thu, 09 Nov 2023 16:06:04 +0100
Date:   Thu, 9 Nov 2023 16:06:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH v3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZUz1XEsTJD4fnEGX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20231102145953.2467-1-phil@nwl.cc>
 <ZUQWJIzaW2RddJo2@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUQWJIzaW2RddJo2@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 10:35:32PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 03:59:53PM +0100, Phil Sutter wrote:
> > Set expressions' dump callbacks are not concurrency-safe per-se with
> > reset bit set. If two CPUs reset the same element at the same time,
> > values may underrun at least with element-attached counters and quotas.
> > 
> > Prevent this by introducing dedicated callbacks for nfnetlink and the
> > asynchronous dump handling to serialize access.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v2:
> > - Move the audit_log_nft_set_reset() call into the critical section to
> >   protect the table pointer dereference.
> > - Drop unused nelems variable from (non-reset) nf_tables_getsetelem().
> > ---
> >  net/netfilter/nf_tables_api.c | 109 +++++++++++++++++++++++++++++-----
> >  1 file changed, 94 insertions(+), 15 deletions(-)
> 
> Adds quite a bit of code: I guess because of the copy and paste to add
> nf_tables_getsetelem_reset().

Having to sort the locking issue mentioned below allowed for a bit of
code deduplication, I hope v4 looks better in this regard.

[...]
> > @@ -6093,17 +6105,84 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
> >  		return -EINVAL;
> >  
> >  	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
> > -		err = nft_get_set_elem(&ctx, set, attr, reset);
> > +		err = nft_get_set_elem(&ctx, set, attr, false);
> > +		if (err < 0) {
> > +			NL_SET_BAD_ATTR(extack, attr);
> > +			break;
> > +		}
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static int nf_tables_getsetelem_reset(struct sk_buff *skb,
> > +				      const struct nfnl_info *info,
> > +				      const struct nlattr * const nla[])
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(info->net);
> > +	struct netlink_ext_ack *extack = info->extack;
> > +	u8 genmask = nft_genmask_cur(info->net);
> > +	u8 family = info->nfmsg->nfgen_family;
> > +	int rem, err = 0, nelems = 0;
> > +	struct net *net = info->net;
> > +	struct nft_table *table;
> > +	struct nft_set *set;
> > +	struct nlattr *attr;
> > +	struct nft_ctx ctx;
> > +
> > +	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
> > +				 genmask, 0);
> > +	if (IS_ERR(table)) {
> > +		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
> > +		return PTR_ERR(table);
> > +	}
> > +
> > +	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
> > +	if (IS_ERR(set))
> > +		return PTR_ERR(set);
> > +
> > +	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
> > +
> > +	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> > +		struct netlink_dump_control c = {
> > +			.start = nf_tables_dump_set_start,
> > +			.dump = nf_tables_dumpreset_set,
> > +			.done = nf_tables_dump_set_done,
> > +			.module = THIS_MODULE,
> > +		};
> > +		struct nft_set_dump_ctx dump_ctx = {
> > +			.set = set,
> > +			.ctx = ctx,
> > +			.reset = true,
> > +		};
> > +
> > +		c.data = &dump_ctx;
> > +		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> > +	}
> > +
> > +	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
> > +		return -EINVAL;
> > +
> > +	if (!try_module_get(THIS_MODULE))
> > +		return -EINVAL;
> > +	rcu_read_unlock();
> 
> Existing table and set pointer get invalid from here on, after leaving
> rcu read side lock.

You're right. I just submitted v4 which should fix that by performing
the needed lookups inside the critical section.

> > +	mutex_lock(&nft_net->commit_mutex);
> > +	rcu_read_lock();
> 
> grab mutex and rcu at the same time, back again?

Yes, this is required AFAICT because the lookup callback of
nft_set_rhash_type wants to be called with RCU read lock held.

Cheers, Phil
