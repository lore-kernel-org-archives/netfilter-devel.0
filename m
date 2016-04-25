From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 22:35:19 +0100
Message-ID: <20160425213519.GA29318@macbook.localdomain>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
 <20160425170541.GC9987@macbook.localdomain>
 <20160425211937.GB17538@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57867 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbcDYVf3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 17:35:29 -0400
Content-Disposition: inline
In-Reply-To: <20160425211937.GB17538@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On 25.04, Florian Westphal wrote:
> > > We could go for a 3rd alternative, namely:
> > > 
> > > u16 bit = regs->data[priv->sreg];
> > > set_bit(bit, ct->labels);
> > > 
> > > i.e. have userspace place the _bit_ that we want to set in the
> > > source register.
> > > 
> > > If we go for sreg that would be my favored solution.
> > > 
> > > The only drawback vs #1 is that get and set work differently
> > > (get places all labels into dreg, set expects bit to set).
> > 
> > That seems like a problem. I agree that #3 would generally be fine, but
> > we should also really have "ct labels set ct labels" not change the labels,
> > that would be highly counterintuitive.
> 
> Right.  What about just re-working this approach:
> 
> https://patchwork.ozlabs.org/patch/613136/
> 
> (sans the CT_IMM part)?  We'd reject all expressions other than
> EXPR_VALUE in the eval phase -- 'ct labels set ct labels' would yield
> 'label expected' error message.
> 
> Does that seem acceptable to you?

Well, that pretty much defeats the use of the sreg since we can't use maps
or any other way to derive the label.

> If not, I see no choice other than resubmitting the original V1 kernel
> patch that simply copied the entire sreg into the label area, this way
> no userspace changes are needed.

I have to follow up on the previous discussion. Just wondering, what's wrong
with simply memcpy'ing and supplying the full set of labels?
