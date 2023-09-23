Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9083BCE7A89
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 15:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjIWPDX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Sep 2023 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjIWPDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2023 11:03:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4B5194
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2023 08:03:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qk4A4-0001F6-8K; Sat, 23 Sep 2023 17:03:12 +0200
Date:   Sat, 23 Sep 2023 17:03:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923110437.GB22532@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 23, 2023 at 01:04:37PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> >  	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
> >  	if (IS_ERR(table)) {
> >  		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
> > -		return PTR_ERR(table);
> > +		return ERR_CAST(table);
> >  	}
> 
> Can you split that into another patch?

You mean the whole creation of nf_tables_getrule_single()? Because the
above change is only required due to the changed return type.

> > +	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> > +		struct netlink_dump_control c = {
> > +			.start= nf_tables_dumpreset_rules_start,
> > +			.dump = nf_tables_dumpreset_rules,
> > +			.done = nf_tables_dump_rules_done,
> > +			.module = THIS_MODULE,
> > +			.data = (void *)nla,
> > +		};
> > +
> > +		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> > +	}
> > +
> > +	if (!nla[NFTA_RULE_TABLE])
> > +		return -EINVAL;
> > +
> > +	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
> > +	if (!tablename)
> > +		return -ENOMEM;
> > +	spin_lock(&nft_net->reset_lock);
> 
> Hmm. Stupid question.  Why do we need a spinlock to serialize?
> This is now a distinct function, so:

On Tue, Sep 05, 2023 at 11:11:07PM +0200, Phil Sutter wrote:
[...]
> I guess NFNL_CB_MUTEX is a no go because it locks down the whole
> subsystem, right?

But he didn't get a reply. :(

What is the relation to this being a distinct function? Can't one have
the same callback function once with type CB_RCU and once as CB_MUTEX?
nfnetlink doesn't seem to care.

> > +	spin_unlock(&nft_net->reset_lock);
> > +	if (IS_ERR(skb2))
> > +		return PTR_ERR(skb2);
> 
> MIssing kfree(tablename)

Thanks! 

Cheers, Phil
