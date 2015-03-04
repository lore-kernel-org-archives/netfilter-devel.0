From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Wed, 4 Mar 2015 17:36:04 +0000
Message-ID: <20150304173603.GY29506@acer.localdomain>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-2-git-send-email-kaber@trash.net>
 <20150304161801.GA3878@salvia>
 <20150304162612.GS29506@acer.localdomain>
 <20150304170102.GA7589@salvia>
 <20150304170355.GW29506@acer.localdomain>
 <20150304172828.GA9044@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbbCDRgI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 12:36:08 -0500
Content-Disposition: inline
In-Reply-To: <20150304172828.GA9044@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.03, Pablo Neira Ayuso wrote:
> On Wed, Mar 04, 2015 at 05:03:56PM +0000, Patrick McHardy wrote:
> > On 04.03, Pablo Neira Ayuso wrote:
> > > > > I think we can get rid of the nft_rule_clear() call from the error
> > > > > path of nf_tables_newrule() too.
> > > > 
> > > > I don't think so, we deactivate the old rule for NLM_F_REPLACE and
> > > > need to undo that on error.
> > > 
> > > Right.
> > > 
> > > > Or are you talking about getting rid of the entire error handling
> > > > for NLM_F_REPLACE and have it taken care of by the abort() path?
> > > 
> > > Yes, that error handling I think we can get rid of it. It's actually
> > > not correct because it's deleting the old rule.
> > 
> > It does? All I can see is reactivating it?
> > 
> > > In general, if a transaction object is added to the list successfully,
> > > we can rely on the abort path to undo what we've done. This allows us to
> > > simplify the error handling of the rule replacement path in
> > > nf_tables_newrule().
> > > 
> > > This implicitly fixes an unnecessary removal of the old rule removal,
> > > which needs to be left in place if we fail to replace.
> > 
> > I agree on the simplification, but I don't see any problem with this.
> 
> Let me see, from the replacement path:
> 
>        trans = nft_trans_rule_add(&ctx, NFT_MSG_DELRULE,
>                                   old_rule);
>        ...
>        nft_rule_deactivate_next(net, old_rule);
>        chain->use--;
>        list_add_tail_rcu(&rule->list, &old_rule->list);
> 
> So we basically:
> 
> 1) add transaction object to delete the old rule
> 2) deactivate the old rule
> 3) reduce the chain use counter
> 4) add the new rule after the old rule
> 
> Then, if we fail to add the transaction for the new rule, what we have
> in err3 says:
> 
> 1) We remove the new rule from the chain, we couldn't add a
>    transaction object for this, so we have to manually undo this.
> 2) We remove the old rule (but it should actually be left there in
>    place).
> 3) Clear the old rule generation bits, as it needs to be active in the
>    next generation given that we failed (this undoes step2)
> 4) Release the transaction object.
> 5) Restore chain use counter.
> 
> #3, #4 and #5 can be handled from the abort path.
> 
> #2 should not be there I think.

I still don't see where we remove the old rule. We activate it
and remove the transaction object, but that's it.

Where do you see this?
