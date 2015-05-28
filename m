From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters from
 iptables rules
Date: Thu, 28 May 2015 23:45:40 +0200
Message-ID: <20150528214540.GF23992@breakpoint.cc>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
 <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49790 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321AbbE1Vpl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 17:45:41 -0400
Content-Disposition: inline
In-Reply-To: <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +
> > +	/* pointer to array of counters, one per CPU
> > +	 * each rule maps 1:1 to an entry in the percpu counter array.
> > +	 */
> > +	struct xt_counters **counters;
> > +
> 
> You could avoid using this array, if you use alloc_percpu(struct
> xt_counter) per counter.

I used this since it fits with the jumpstack allocation that we already
have.

Is there an inherent advantage to alloc_percpu?

[ I'm asking to see if it makes sense to convert jump stack too ].

> In the rules, instead of storing the index of each counter, store the
> percpu address.

-v

How?  What address?  You mean relative offset to counter start?

> This would avoid yet another indirection in iptables.

I don't see how I can avoid it.

when rule x matches, I need to increment the corresponding counter
for that rule.

But there is no 1:1 mapping of addresses, and I found no way to infer
the correct counter address to use for the rule just by looking at
ipt_entry address.

Thats why the entry stores the 'counter' index: to find the counter to
increment based on current cpu counter array and the rule number.

> And it would be nice avoiding this stuff on non SMP kernels maybe ?

Hmm.  Will have to think about this to minimize ifdef kludgery.
But, yes, I agree.  Will fix it in v3.

Thanks Eric.
