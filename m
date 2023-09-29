Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B653E7F154
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 11:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjI2LDy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 07:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjI2LDx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 07:03:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDB4199
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 04:03:47 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qmBHd-0007rp-FI; Fri, 29 Sep 2023 13:03:45 +0200
Date:   Fri, 29 Sep 2023 13:03:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZRavEQkFrQ0u2P+C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928174630.GD19098@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 07:46:30PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> > +				   struct netlink_callback *cb)
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> > +	int ret, skip = cb->args[0];
> > +
> > +	mutex_lock(&nft_net->commit_mutex);
> > +	ret = nf_tables_dump_set(skb, cb);
> > +	mutex_unlock(&nft_net->commit_mutex);
> > +
> > +	if (cb->args[0] > skip)
> > +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> > +					cb->args[0] - skip);
> > +
> 
> Once commit_mutex is dropped, parallel user can
> delete table, and ctx.table references garbage.
> 
> So I think this needs to be done under mutex.

OK, will do.

> >  		c.data = &dump_ctx;
> > @@ -6108,18 +6178,25 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
> >  	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
> >  		return -EINVAL;
> >  
> > +	if (!try_module_get(THIS_MODULE))
> > +		return -EINVAL;
> > +	rcu_read_unlock();
> > +	mutex_lock(&nft_net->commit_mutex);
> > +	rcu_read_lock();
> 
> Why do we need to regain the rcu read lock here?
> Are we tripping over a now bogus rcu_derefence check or is there
> another reason?

Yes, I got a lockdep warning because rhashtable_lookup() called from
nft_rhash_get() calls rht_dereference_rcu() which wants either ht->mutex
or RCU read lock held.

Cheers, Phil
