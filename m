From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to
 caller
Date: Thu, 13 Jan 2011 01:14:39 +0100
Message-ID: <20110113001439.GF10801@Chamillionaire.breakpoint.cc>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
 <1293407904-31464-3-git-send-email-fw@strlen.de>
 <4D2DF944.8060407@netfilter.org>
 <20110112204917.GA10801@Chamillionaire.breakpoint.cc>
 <4D2E243F.2070508@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55473 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109Ab1AMAOk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:14:40 -0500
Content-Disposition: inline
In-Reply-To: <4D2E243F.2070508@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On 12/01/11 21:49, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>> -	/* If it's going away, ignore hook. */
> >>> -	if (!try_module_get(entry->elem->owner)) {
> >>> -		rcu_read_unlock();
> >>> -		kfree(entry);
> >>> -		return 0;
> >>> -	}
> >>> +	if (!try_module_get(entry->elem->owner))
> >>> +		goto err_unlock;
> >>
> >> With this change, we're now releasing the skb, is this deliberate?
> > 
> > I think its not necessary to make this a special case (i.e. just
> > kfree_skb(skb) instead).
> 
> This case is rare but I'd prefer not to drop packets if the hook is
> going away.

Okay. I used -ECANCELED here, its rarely used in the kernel and
i think it comes closest.

> >> Better propagate the error of skb_gso_segment(...) with PTR_ERR()
> > 
> > The reason I did not do that is because I wanted to limit the number
> > of code one has to check for possible errno values that can be returned
> > by nf_queue.
> > 
> > Its probably reasonable to assume that skb_gso_segment() won't return
> > ESRCH (which I use to determine that qeueuing failed because the queue number did
> > not exist), so it might be safe to use PTR_ERR here.
> 
> Currently, it only return -EINVAL. Anyway, it makes sense what you
> mention. Better use -EINVAL and add a short comment upon it that tells
> why we're doing this.

I added a comment about this and plan to send v2 of the patch set on
sunday.

Thanks again for reviewing,
Florian
