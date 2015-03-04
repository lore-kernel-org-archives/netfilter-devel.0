From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Wed, 4 Mar 2015 17:38:37 +0000
Message-ID: <20150304173837.GZ29506@acer.localdomain>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-2-git-send-email-kaber@trash.net>
 <20150304161801.GA3878@salvia>
 <20150304162612.GS29506@acer.localdomain>
 <20150304170102.GA7589@salvia>
 <20150304170355.GW29506@acer.localdomain>
 <20150304172828.GA9044@salvia>
 <20150304173603.GY29506@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53131 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372AbbCDRim (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 12:38:42 -0500
Content-Disposition: inline
In-Reply-To: <20150304173603.GY29506@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.03, Patrick McHardy wrote:
> On 04.03, Pablo Neira Ayuso wrote:
> > On Wed, Mar 04, 2015 at 05:03:56PM +0000, Patrick McHardy wrote:
> > > 
> > > I agree on the simplification, but I don't see any problem with this.
> > 
> > Let me see, from the replacement path:
> > 
> >        trans = nft_trans_rule_add(&ctx, NFT_MSG_DELRULE,
> >                                   old_rule);
> >        ...
> >        nft_rule_deactivate_next(net, old_rule);
> >        chain->use--;
> >        list_add_tail_rcu(&rule->list, &old_rule->list);
> > 
> > So we basically:
> > 
> > 1) add transaction object to delete the old rule
> > 2) deactivate the old rule
> > 3) reduce the chain use counter
> > 4) add the new rule after the old rule
> > 
> > Then, if we fail to add the transaction for the new rule, what we have
> > in err3 says:
> > 
> > 1) We remove the new rule from the chain, we couldn't add a
> >    transaction object for this, so we have to manually undo this.
> > 2) We remove the old rule (but it should actually be left there in
> >    place).
> > 3) Clear the old rule generation bits, as it needs to be active in the
> >    next generation given that we failed (this undoes step2)
> > 4) Release the transaction object.
> > 5) Restore chain use counter.
> > 
> > #3, #4 and #5 can be handled from the abort path.
> > 
> > #2 should not be there I think.
> 
> I still don't see where we remove the old rule. We activate it
> and remove the transaction object, but that's it.
> 
> Where do you see this?

Ok got it, I misread the code and through we'd only delete the
transaction object. Ok, so I agree that this actually fixes a bug :)
