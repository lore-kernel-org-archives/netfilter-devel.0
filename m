From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Wed, 4 Mar 2015 16:26:13 +0000
Message-ID: <20150304162612.GS29506@acer.localdomain>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-2-git-send-email-kaber@trash.net>
 <20150304161801.GA3878@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52699 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789AbbCDQ0R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 11:26:17 -0500
Content-Disposition: inline
In-Reply-To: <20150304161801.GA3878@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.03, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2015 at 08:04:18PM +0000, Patrick McHardy wrote:
> > A race condition exists in the rule transaction code for rules that
> > get added and removed within the same transaction.
> > 
> > The new rule starts out as inactive in the current and active in the
> > next generation and is inserted into the ruleset. When it is deleted,
> > it is additionally set to inactive in the next generation as well.
> > 
> > On commit the next generation is begun, then the actions are finalized.
> > For the new rule this would mean clearing out the inactive bit for
> > the previously current, now next generation.
> > 
> > However nft_rule_clear() clears out the bits for *both* generations,
> > activating the rule in the current generation, where it should be
> > deactivated due to being deleted. The rule will thus be active until
> > the deletion is finalized, removing the rule from the ruleset.
> > 
> > Similarly, when aborting a transaction for the same case, the undo
> > of insertion will remove it from the RCU protected rule list, the
> > deletion will clear out all bits. However until the next RCU
> > synchronization after all operations have been undone, the rule is
> > active on CPUs which can still see the rule on the list.
> > 
> > Generally, there may never be any modifications of the current
> > generations' inactive bit since this defeats the entire purpose of
> > atomicity. Change nft_rule_clear() to only touch the next generations
> > bit to fix this.
> 
> I think we can get rid of the nft_rule_clear() call from the error
> path of nf_tables_newrule() too.

I don't think so, we deactivate the old rule for NLM_F_REPLACE and
need to undo that on error.

Or are you talking about getting rid of the entire error handling
for NLM_F_REPLACE and have it taken care of by the abort() path?
