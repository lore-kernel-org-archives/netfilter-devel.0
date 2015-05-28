From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters
 from iptables rules
Date: Thu, 28 May 2015 14:54:56 -0700
Message-ID: <1432850096.7456.38.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
	 <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20150528214540.GF23992@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34914 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbbE1Vy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 17:54:58 -0400
Received: by iesa3 with SMTP id a3so49279030ies.2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 14:54:57 -0700 (PDT)
In-Reply-To: <20150528214540.GF23992@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-05-28 at 23:45 +0200, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > +
> > > +	/* pointer to array of counters, one per CPU
> > > +	 * each rule maps 1:1 to an entry in the percpu counter array.
> > > +	 */
> > > +	struct xt_counters **counters;
> > > +
> > 
> > You could avoid using this array, if you use alloc_percpu(struct
> > xt_counter) per counter.
> 
> I used this since it fits with the jumpstack allocation that we already
> have.
> 
> Is there an inherent advantage to alloc_percpu?
> 
> [ I'm asking to see if it makes sense to convert jump stack too ].
> 
> > In the rules, instead of storing the index of each counter, store the
> > percpu address.
> 
> -v
> 
> How?  What address?  You mean relative offset to counter start?

No, the address itself. This is what I coded years ago.

> 
> > This would avoid yet another indirection in iptables.
> 
> I don't see how I can avoid it.
> 
> when rule x matches, I need to increment the corresponding counter
> for that rule.

Right. You have in the rule itself the storage for xt_counter. Thats 16
bytes. You only need 8 bytes (on 64bit arch) to store the percpu
address.

Instead of leaving nothing in it, place the percpu address of the
corresponding counter. access to it is in the cache line needed to
analyze the entry anyway. Its free.

> 
> But there is no 1:1 mapping of addresses, and I found no way to infer
> the correct counter address to use for the rule just by looking at
> ipt_entry address.
> 
> Thats why the entry stores the 'counter' index: to find the counter to
> increment based on current cpu counter array and the rule number.
> 
> > And it would be nice avoiding this stuff on non SMP kernels maybe ?
> 
> Hmm.  Will have to think about this to minimize ifdef kludgery.
> But, yes, I agree.  Will fix it in v3.
> 
> Thanks Eric.


