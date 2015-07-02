From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Thu, 2 Jul 2015 17:43:30 +0200
Message-ID: <20150702154330.GA4078@salvia>
References: <1435695660-26048-1-git-send-email-fw@strlen.de>
 <20150702113044.GA21930@salvia>
 <20150702114837.GA16529@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbbGBPiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 11:38:03 -0400
Content-Disposition: inline
In-Reply-To: <20150702114837.GA16529@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 02, 2015 at 01:48:37PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > If we remove it and things are broken, then this will crash with a
> > general protection fault when accessing memory out of the jumpstack
> > boundary. On the other hand, if we keep it, packets will be dropped
> > and it will keep going until someone checks logs and reports this. If
> > we hit this then things are really broken so probably being a
> > agressive in this case makes sense.
> > Moreover, this is adds another branch in the packet path (not critical
> > in arptables, but we have in iptables too).
> > 
> > What do you think?
> 
> I will remove it in the nf-next patch series i am currently working on.
> 
> When this happens something is *seriously* wrong with the ruleset
> validation checks that we have in place.

OK. I'm going to apply this, but will remove the WARN_ON_ONCE to get
this in sync with iptables and given that this will be gone soon.

> > BTW, not related to this patch, Eric Dumazet indicated during the NFWS
> > that it would be a good idea to make this jumpstack fixed length as in
> > nftables, so we can place it in the stack and get rid of this percpu
> > jumpstack that was introduced to cope with reentrancy (only TEE needs
> > this). I've been checking this but we have no limits at this moment,
> > so the concerns go in the direction that if we limit this, we may
> > break some crazy setup with lots of jump to chain outthere. So I
> > suspect we cannot get rid of this easily :-(.
> 
> Seems Eric lobbied this to several people ;)
> 
> I'm working on it.
> 
> I agree that using kernel stack with auto-sized variable makes most
> sense BUT since this could theoretically cause userspace breakage I
> decided against it.

Agreed.

> My plan:
> 
> - move tee_active percpu varible to xtables core (suggested by Eric)

I'll need to move this to the netfilter core to support tee both from
iptables and nftables in my next round of patches. Just to avoid
strange problem in case problem mix iptables and nftables. But I think
this patch should come in first place, so I'll rebase, no problem.

> - in do_table, check if we're TEE'd or not
> 
> 1. if no, then just use the jumpstack from offset 0 onwards.
> 2. If yes, then fetch jumpstack, and use the upper half:
> 
> if (__this_cpu_read(xt_tee_active))
>  	jumpstack += private->stacksize;
> 
> (jumpstack is twice the size of 'stacksize' to accompondate this).
> 
> This means that the relative stack offset during table traversal
> always starts at 0 and we do not have to store the old stack location
> when we leave the do_table function anymore.
> 
> The stackptr percpu variable is now unused; i'll unify
> it with the jumpstack so that stack is fetched via
> 
> jumpstack  = (struct ipt_entry **) this_cpu_ptr(private->stackptr);
> 
> I was also planning to compute real needed stack size
> (i.e., track largest callchain seen, should be simple by adding this
>  to 'mark_source_chains' function) rather than just using the number
>  of chains.
> 
> In most rulesets the call chain will not be deep, even when there
> are 100 or so user-defined rules.
>
> I'd guess a percpu jumpstack of < 128 bytes is quite realistic for most
> rulesets.

Sound good. Thanks.
