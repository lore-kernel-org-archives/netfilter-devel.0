From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 7/7] netfilter: x_tables: use pr ratelimiting in all
 remaining spots
Date: Wed, 7 Feb 2018 20:23:23 +0100
Message-ID: <20180207192323.GG14261@breakpoint.cc>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-8-fw@strlen.de>
 <20180207170052.x6n6kod2zld7wuqd@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40090 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753995AbeBGT02 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:26:28 -0500
Content-Disposition: inline
In-Reply-To: <20180207170052.x6n6kod2zld7wuqd@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > --- a/net/bridge/netfilter/ebt_among.c
> > +++ b/net/bridge/netfilter/ebt_among.c
> > @@ -187,17 +187,17 @@ static int ebt_among_mt_check(const struct xt_mtchk_param *par)
> >  	expected_length += ebt_mac_wormhash_size(wh_src);
> >  
> >  	if (em->match_size != EBT_ALIGN(expected_length)) {
> > -		pr_info("wrong size: %d against expected %d, rounded to %zd\n",
> > -			em->match_size, expected_length,
> > -			EBT_ALIGN(expected_length));
> > +		pr_info_ratelimited("wrong size: %d against expected %d, rounded to %zd\n",
> 
> Shouldn't all these be pr_err_ratelimited instead?

Don't know.

This could even be pr_debug actually since this message is
useless unless you're doing ebtables development work.

> Probably this is a good chance to homogeneize all error reporting in
> xtables.

Yes.

> >  	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
> > -		pr_info("dst integrity fail: %x\n", -err);
> > +		pr_info_ratelimited("dst integrity fail: %x\n", -err);
> >  		return -EINVAL;
> >  	}
> >  	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
> > -		pr_info("src integrity fail: %x\n", -err);
> > +		pr_info_ratelimited("src integrity fail: %x\n", -err);
> >  		return -EINVAL;

Same for these two, I'll convert all to pr_debug instead.

> >  	if (info->queues_total == 0) {
> > -		pr_err("NFQUEUE: number of total queues is 0\n");
>                         ^^^^^^^^
> 
> We can probably add this all over the place in the same go?
 
>         #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Yes.

> >  	if (index == IPSET_INVALID_ID) {
> > -		pr_warn("Cannot find set identified by id %u to match\n",
> > -			info->match_set.index);
> > +		pr_warn_ratelimited("Cannot find set identified by id %u to match\n",
> > +				    info->match_set.index);
> 
> Use pr_err_ratelimited instead?

I think we should settle on a single pr_foo, i suggest
pr_info(_ratelimited).

This is not an error condition, we only have these
printks because we can't return a proper error to userspace.

If this was netlink, it would be converted to extack instead...
