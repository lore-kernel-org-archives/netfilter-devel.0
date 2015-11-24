From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: wrap tracing with a
 static key
Date: Tue, 24 Nov 2015 11:21:23 +0100
Message-ID: <20151124102123.GB1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-3-git-send-email-fw@strlen.de>
 <20151124101332.GC2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58413 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbbKXKVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:21:25 -0500
Content-Disposition: inline
In-Reply-To: <20151124101332.GC2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 24.11, Florian Westphal wrote:
> > diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> > index 29a6ca9..dabf5ed 100644
> > --- a/net/netfilter/nf_tables_core.c
> > +++ b/net/netfilter/nf_tables_core.c
> > @@ -138,7 +144,8 @@ next_rule:
> >  		if (unlikely(rule->genmask & (1 << gencursor)))
> >  			continue;
> >  
> > -		rulenum++;
> > +		if (static_key_false(&nft_trace_enabled))
> > +			rulenum++;
> 
> This API is deprecated, see Documentation/static-keys.txt.

Oh, thats great.  static_branch_unlikely() is a much better name.

I'll update this locally and send a v2 later (I want to give others
time to provide feedback as well).

> I'm also wondering if this introduces a race condition on architectures
> that don't support jump labels. static_key_slow_inc() simply increases
> the ->enabled counter without further synchronization, so this might
> happen while we're executing this function and some of the increments
> might be skipped.

Hmm, adding synchronization for this is braindead.
The new trace infrastructure doesn't need this rulenum, I only kept it
since thats what Pablo asked me to do.

So we have 3 choices:
- ignore this
- don't use static key here
- kill the old nf_log_packet trace part after all

I find it sad that we have to keep this rule counting around :-/

If there are no further comments I'll remove the static key and do
the rule counting unconditinally.

Thanks Patrick.
