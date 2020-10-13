Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81799C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 10:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47F42207C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 10:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgJMKIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgJMKIF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 06:08:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67C5C0613D0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 03:08:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kSHDv-0007eo-5w; Tue, 13 Oct 2020 12:08:03 +0200
Date:   Tue, 13 Oct 2020 12:08:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201013100803.GW13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
 <20201012125450.GA26934@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012125450.GA26934@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 02:54:50PM +0200, Pablo Neira Ayuso wrote:
[...]
> > -	if (h->family == NFPROTO_BRIDGE)
> > -		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
> > +		list = nft_chain_list_get(h, table, chain);
> > +		if (list)
> > +			nftnl_chain_list_add(c, list);
> > +	} else {
> > +		/* If the chain should vanish meanwhile, kernel genid changes
> > +		 * and the transaction is refreshed enabling the chain add
> > +		 * object. With the handle still set, kernel interprets it as a
> > +		 * chain replace job and errors since it is not found anymore.
> > +		 */
> > +		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
> > +	}
> >  
> > -	if (!created)
> > -		return 1;
> > +	__nft_rule_flush(h, table, chain, false, created);
> 
> I like this trick.
> 
> If I understood correct, you always place an "add chain" command in
> first place before the flush, whether the chain exists or not, so the
> flush always succeeds.

Yes, this was already done for "add table". So I'm "merely" extending
Florian's refresh transaction logic with regards to 'skip' flag.

> > -	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
> > +	obj = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
> > +	if (!obj)
> >  		return 0;
> >  
> > -	list = nft_chain_list_get(h, table, chain);
> > -	if (list)
> > -		nftnl_chain_list_add(c, list);
> > +	obj->skip = !created;
> >  
> >  	/* the core expects 1 for success and 0 for error */
> >  	return 1;
> > @@ -2649,11 +2649,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
> >  	h->error.lineno = 0;
> >  
> >  	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
> > -		if (n->implicit) {
> > -			batch_obj_del(h, n);
> > -			continue;
> > -		}
> > -
> >  		switch (n->type) {
> >  		case NFT_COMPAT_TABLE_FLUSH:
> >  			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
> > @@ -2679,14 +2674,22 @@ static void nft_refresh_transaction(struct nft_handle *h)
> >  
> >  			c = nft_chain_find(h, tablename, chainname);
> >  			if (c) {
> > -				/* -restore -n flushes existing rules from redefined user-chain */
> > -				__nft_rule_flush(h, tablename,
> > -						 chainname, false, true);
> >  				n->skip = 1;
> >  			} else if (!c) {
> >  				n->skip = 0;
> >  			}
> >  			break;
> > +		case NFT_COMPAT_RULE_FLUSH:
> > +			tablename = nftnl_rule_get_str(n->rule, NFTNL_RULE_TABLE);
> > +			if (!tablename)
> > +				continue;
> > +
> > +			chainname = nftnl_rule_get_str(n->rule, NFTNL_RULE_CHAIN);
> > +			if (!chainname)
> > +				continue;
> > +
> > +			n->skip = !nft_chain_find(h, tablename, chainname);
> 
> So n->skip equals true if the chain does not exists in the cache, so
> this flush does not fail (after this chain is gone because someone
> else have remove it).

Yes, the tricky bit is being able to adjust the batch object list no
matter how kernel ruleset changes. The only way is to assume the most
overhead and temporary disable individual jobs if not needed. This way
we can enable/disable while refreshing the transaction.

> Patch LGTM, thanks Phil.
> 
> What I don't clearly see yet is what scenario is triggering the bug in
> the existing code, if you don't mind to explain.

See the test case attached to the patch: An other iptables-restore
process may add references (i.e., jumps) to a chain the own
iptables-restore process wants to delete. This should not be a problem
because these references are added to a chain that is being flushed by
the own process as well. But if that chain doesn't exist while the own
process fetches kernel's ruleset, this flush job is not created.

Cheers, Phil
