From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 14:16:07 +0200
Message-ID: <20160425121607.GA2907@salvia>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58274 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbcDYMSj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 08:18:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C64E71BFAA4
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:18:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA1E19D11C
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:18:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1ECFAFAB52
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:18:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160425115622.GD28797@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 25, 2016 at 01:56:22PM +0200, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On 25.04, Florian Westphal wrote:
> > > Patrick McHardy <kaber@trash.net> wrote:
> > > > On 21.04, Florian Westphal wrote:
> > > > > Pablo suggested to re-use the immediate attributes already used by
> > > > > nft_immediate, nft_bitwise and nft_cmp to re-use as much code as
> > > > > possible.
> > > > > 
> > > > > Just add new NFTA_CT_IMM that contains nested data attributes.
> > > > > We can then use nft_data_init and nft_data_dump for this as well.
> > > > 
> > > > What's the argument against using immediate and a register?
> > > 
> > > http://marc.info/?l=netfilter-devel&m=145800804914781&w=2
> > > 
> > > <quote>
> > > > However, with nft, the input is just a register with arbitrary runtime
> > > > content.
> > > > 
> > > > We therefore ask for the upper ceiling we currently have, which is
> > > > enough room to store 128 bits.
> > > 
> > > We can probably allow passing the label value as attribute to the
> > > nft_ct expression so you don't have to use the upper ceiling. Patrick
> > > suggested something similar for nft_ct set helper support.
> > > </unqote>
> > 
> > Helpers are somewhat special because we need to load the modules and get
> > a reference to the helper structure, so we need the context of what the
> > immediate will be used for. I'd certainly prefer not to use immediates
> > since that means we'll need a single rule per assignment. Especially with
> > helpers it seems a lot nicer to simply use a map.
> 
> Okay, fair enough.
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

I don't think we should go memcpy(). This won't be equivalent to what
iptables does.

Different thing is to indicate the bit number from an immediate, ie.
we use set_bit() based on the register data that we get, so we can use
maps as Patrick suggests.

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

I'm fine with this.

> The only drawback vs #1 is that get and set work differently
> (get places all labels into dreg, set expects bit to set).
> 
> (We also need to validate at eval time but thats not a problem
>  in this case).

You mean a check to make sure we don't go over the boundary, just to
avoid crashing. That seems OK to me.

We can still reuse part of your ct immediate work for the helper setup
anyway.
