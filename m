Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549D6C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 May 2022 07:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242939AbiEKH1H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 03:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiEKH1D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 03:27:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C256B3BBEB;
        Wed, 11 May 2022 00:27:01 -0700 (PDT)
Date:   Wed, 11 May 2022 09:26:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/17] netfilter: ecache: use dedicated list for
 event redelivery
Message-ID: <YntlQs6xcAJeBwue@salvia>
References: <20220510122150.92533-1-pablo@netfilter.org>
 <20220510122150.92533-2-pablo@netfilter.org>
 <20220510192019.2f02057b@kernel.org>
 <20220511054634.GA4873@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220511054634.GA4873@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 11, 2022 at 07:46:34AM +0200, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 10 May 2022 14:21:34 +0200 Pablo Neira Ayuso wrote:
> > > +next:
> > > +	sent = 0;
> > > +	spin_lock_bh(&cnet->ecache.dying_lock);
> > > +
> > > +	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
> > ...
> > > +		if (sent++ > 16) {
> > > +			spin_unlock_bh(&cnet->ecache.dying_lock);
> > > +			cond_resched();
> > > +			spin_lock_bh(&cnet->ecache.dying_lock);
> > > +			goto next;
> > 
> > sparse seems right, the looking looks off in this function
> 
> Pablo, its probably best to squash this, what do you think?

yes florian, i'll squash it

> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -75,7 +75,6 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
>  		if (sent++ > 16) {
>  			spin_unlock_bh(&cnet->ecache.dying_lock);
>  			cond_resched();
> -			spin_lock_bh(&cnet->ecache.dying_lock);
>  			goto next;
>  		}
>  	}
