From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Tue, 4 Mar 2014 10:03:07 +0100
Message-ID: <20140304090307.GK9965@breakpoint.cc>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
 <20140304085029.GC5094@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55308 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756711AbaCDJDJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:03:09 -0500
Content-Disposition: inline
In-Reply-To: <20140304085029.GC5094@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On Mon, Mar 03, 2014 at 10:12:26PM +0100, Florian Westphal wrote:
> > reject did not allow to use tcp reset instead of icmp unreach.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  After this patch its possibe to do something like
> > 
> >  rule filter output reject reset
> 
> Actually this looks a lot like "iptables thinking" :)

*ahem* :)

> Why not simply use "reset" as keyword?

Yes, that would work as well.

> >  Which makes kernel generate bogus tcp resets in repsonse
> >  to non-tcp packets.
> > 
> >  In iptables this is avoided by making checkentry fail if -p tcp is not
> >  specified when tcp-reset is requested.
> > 
> >  How should this be handled in nft?
> 
> We could either add some infrastructure to the kernel to mimic the iptables
> check, add runtime fallback to ICMP for non-TCP packets or simply ignore them.
> 
> It shouldn't be difficult to check within the rule for the required matches,
> however I'm not so sure this is really the way to go since it precludes
> optimizations that spawn over multiple rules, f.i. checking for TCP before
> a chain jump and have only TCP-specific rules in that chain.

Good point.

> I'm tending towards simply ignoring non-TCP packets at runtime.

Eric, please let me know if you want to address all of this in your icmp
code patch series, or if you would like me to handle this.

If you want me to handle it I will resubmit this patch with the issues
pointed out by Patrick resolved, plus a small kernel patch to not xmit
reset for non-tcp packets.

Otherwise I'll just mark this patch as "rejected" in patchwork.

> >  %token _REJECT			"reject"
> > +%token REJECT_RESET		"reset"
> > +%token REJECT_UNREACH		"unreach"
> 
> Please don't use expression/statement-specific token names. We're simply
> dealing with tokens, how they're used depends on the remaining grammar.

Makes sense.

Thanks for your help Patrick.
