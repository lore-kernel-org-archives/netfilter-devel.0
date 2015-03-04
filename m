From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Wed, 4 Mar 2015 17:03:56 +0000
Message-ID: <20150304170355.GW29506@acer.localdomain>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-2-git-send-email-kaber@trash.net>
 <20150304161801.GA3878@salvia>
 <20150304162612.GS29506@acer.localdomain>
 <20150304170102.GA7589@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52923 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192AbbCDREB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 12:04:01 -0500
Content-Disposition: inline
In-Reply-To: <20150304170102.GA7589@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.03, Pablo Neira Ayuso wrote:
> > > I think we can get rid of the nft_rule_clear() call from the error
> > > path of nf_tables_newrule() too.
> > 
> > I don't think so, we deactivate the old rule for NLM_F_REPLACE and
> > need to undo that on error.
> 
> Right.
> 
> > Or are you talking about getting rid of the entire error handling
> > for NLM_F_REPLACE and have it taken care of by the abort() path?
> 
> Yes, that error handling I think we can get rid of it. It's actually
> not correct because it's deleting the old rule.

It does? All I can see is reactivating it?

> In general, if a transaction object is added to the list successfully,
> we can rely on the abort path to undo what we've done. This allows us to
> simplify the error handling of the rule replacement path in
> nf_tables_newrule().
> 
> This implicitly fixes an unnecessary removal of the old rule removal,
> which needs to be left in place if we fail to replace.

I agree on the simplification, but I don't see any problem with this.

>  err3:
>  	list_del_rcu(&rule->list);
> -	if (trans) {
> -		list_del_rcu(&nft_trans_rule(trans)->list);
> -		nft_rule_clear(net, nft_trans_rule(trans));
> -		nft_trans_destroy(trans);
> -		chain->use++;
> -	}
>  err2:
>  	nf_tables_rule_destroy(&ctx, rule);
>  err1:
> -- 
> 1.7.10.4
> 

