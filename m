From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 18:05:41 +0100
Message-ID: <20160425170541.GC9987@macbook.localdomain>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56660 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbcDYRFp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 13:05:45 -0400
Content-Disposition: inline
In-Reply-To: <20160425115622.GD28797@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > The alternative to internally handling it would be to some propagating
> > validation to immediates / sets which invoke the actual user of the data.
> > So in the case of helpers, we could replace the name by references to
> > the helper structures and reverse this during dumping.
> > 
> > Regarding connlabels this doesn't really apply though. We expect userspace
> > to create a reasonable ruleset and anything that does not cause critical
> > errors is validated in userspace.
> 
> Yes.  So we have three choices here (pseudo-code)
> 
> memcpy(ct->labels, regs->data[priv->sreg], sizeof(reg));
> vs.
> set_bit(priv->imm, ct->labels);
> 
> The latter is what the iptables module does, I do not mind if we
> go for #1 (treat the label area just like an 128bit register and
> replace it completely with whatever is in the source register).
> 
> My only problem is that Pablo suggested #2 whereas you recommend #1.
> 
> I don't want to resubmit until there is consensus as to what the
> preferred solution is.
> 
> We could go for a 3rd alternative, namely:
> 
> u16 bit = regs->data[priv->sreg];
> set_bit(bit, ct->labels);
> 
> i.e. have userspace place the _bit_ that we want to set in the
> source register.
> 
> If we go for sreg that would be my favored solution.
> 
> The only drawback vs #1 is that get and set work differently
> (get places all labels into dreg, set expects bit to set).

That seems like a problem. I agree that #3 would generally be fine, but
we should also really have "ct labels set ct labels" not change the labels,
that would be highly counterintuitive.
