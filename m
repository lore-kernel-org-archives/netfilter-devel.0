From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to
 caller
Date: Wed, 12 Jan 2011 21:49:17 +0100
Message-ID: <20110112204917.GA10801@Chamillionaire.breakpoint.cc>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
 <1293407904-31464-3-git-send-email-fw@strlen.de>
 <4D2DF944.8060407@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47323 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203Ab1ALUtS convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:49:18 -0500
Content-Disposition: inline
In-Reply-To: <4D2DF944.8060407@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I've got some questions and comments on this patchset, please see below.

Thank you for spending time on reviewing this patchset!

> On 27/12/10 00:58, Florian Westphal wrote:
> > instead of returning -1 on error, return an error number to allow the
> > caller to handle some errors differently.
> > 
> > To make things simpler try_module_get() failure is no longer special-cased.
> > 
> > The new return values will be used in followup patch.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -179,9 +179,8 @@ next_hook:
> >  		if (ret == 0)
> >  			ret = -EPERM;
> >  	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
> > -		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> > -			      verdict >> NF_VERDICT_BITS))
> > -			goto next_hook;
> > +		nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> > +			       verdict >> NF_VERDICT_BITS);
> 
> You have to remove the next_hook label if you want to do this.
> 
> It's not clear to me why we need to remove the goto jump, could you
> clarify this?

Sure. The only place where nf_queue returns 0 is this snippet in __nf_queue():

> > -	/* If it's going away, ignore hook. */
> > -	if (!try_module_get(entry->elem->owner)) {
> > -		rcu_read_unlock();
> > -		kfree(entry);
> > -		return 0;
> > -	}
> > +	if (!try_module_get(entry->elem->owner))
> > +		goto err_unlock;
> 
> With this change, we're now releasing the skb, is this deliberate?

I think its not necessary to make this a special case (i.e. just
kfree_skb(skb) instead).

An alternative is to decide on a meaningful errno value that
could be used as return value to signal this condition.

> >  #ifdef CONFIG_BRIDGE_NETFILTER
> >  	struct net_device *physindev;
> > @@ -136,8 +136,10 @@ static int __nf_queue(struct sk_buff *skb,
> >  		goto err_unlock;
> 
> here above there's the following:
> 
>         qh = rcu_dereference(queue_handler[pf]);
>         if (!qh)
>                 goto err_unlock;
> 
>         afinfo = nf_get_afinfo(pf);
>         if (!afinfo)
>                 goto err_unlock;
> 
> With your patch, we're returning -EINVAL. I think it's better to return
> -ENOENT.

Agreed.

> > @@ -218,18 +218,26 @@ int nf_queue(struct sk_buff *skb,
> >  	segs = skb_gso_segment(skb, 0);
> >  	kfree_skb(skb);
> >  	if (IS_ERR(segs))
> > -		return 1;
> > +		return -ENOMEM;
> 
> Better propagate the error of skb_gso_segment(...) with PTR_ERR()

The reason I did not do that is because I wanted to limit the number
of code one has to check for possible errno values that can be returned
by nf_queue.

Its probably reasonable to assume that skb_gso_segment() won't return
ESRCH (which I use to determine that qeueuing failed because the queue number did
not exist), so it might be safe to use PTR_ERR here.

What do you think?

> > +	queued = 0;
> >  	do {
> >  		struct sk_buff *nskb = segs->next;
> >  
> >  		segs->next = NULL;
> > -		if (!__nf_queue(segs, elem, pf, hook, indev, outdev, okfn,
> > -				queuenum))
> > -			kfree_skb(segs);
> > +		if (error == 0) {
> > +			error = __nf_queue(segs, elem, pf, hook, indev,
> > +					   outdev, okfn, queuenum);
> > +			if (error == 0)
> > +				queued++;
> > +		}
> > +		kfree_skb(segs);
> 
> Before this patch, segs were only released if try_module_get() failed.
> Now it always release it?

Yes, my bad.
I'll add it to the list of things to fix up. Thanks for catching this.
