From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/6] netfilter: nfnetlink_queue: do not free skb on
 error
Date: Wed, 12 Jan 2011 21:50:45 +0100
Message-ID: <20110112205045.GB10801@Chamillionaire.breakpoint.cc>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
 <1293407904-31464-4-git-send-email-fw@strlen.de>
 <4D2DFAA6.7070401@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47325 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203Ab1ALUuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:50:46 -0500
Content-Disposition: inline
In-Reply-To: <4D2DFAA6.7070401@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -179,8 +179,11 @@ next_hook:
> >  		if (ret == 0)
> >  			ret = -EPERM;
> >  	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
> > -		nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> > +		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> >  			       verdict >> NF_VERDICT_BITS);
> > +		if (ret < 0)
> > +			kfree_skb(skb);
> > +		ret = 0;
> >  	}
> 
> Suggestion: Better put this patch on top of the pile. In the previous,
> you remove the return value of nf_queue, and again you reintroduce it.

Yes, I'll either rebase this or just merge the two patches into one
to avoid this confusion.  Sorry about that.
