From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 11:51:03 +0000
Message-ID: <20151125115103.GB31023@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
 <20151125083907.GF23215@breakpoint.cc>
 <20151125093554.GA31023@macbook.localdomain>
 <20151125101329.GH23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:56270 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320AbbKYLvH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 06:51:07 -0500
Content-Disposition: inline
In-Reply-To: <20151125101329.GH23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Florian Westphal wrote:
> > > > It would be nice to have the full verdict available, IOW also the jump target.
> > > > 
> > > > You could simply pass struct nft_verdict to this function and adapt
> > > > nft_verdict_dump() to take the attribute value as parameter.
> > > 
> > > Will add NFTA_TRACE_JUMP/NFTA_TRACE_GOTO for that, ok?
> > 
> > Any reason not to use the standard verdict encoding? We even have an almost
> > ready to use function for that.
> 
> Sorry, could you be more specific?
> How would you tell userspace where the jump/goto is going to?

We have nft_verdict_dump(), which encodes the verdict as nested attribute.
I'd suggest to simply use that one since we also already have parsing
functions for that in both nft and libnftnl and we can use the regular
data structures.

> What I am doing now in my local version:
> 
> NFTA_TRACE_VERDICT is the verbatim result of the hook (i.e. might
> contain errno or queue id).
> 
> NFTA_TRACE_JUMP_TARGET is the name of the chain that we goto or jump to,
> set when verdict == NFT_JUMP/_GOTO.
> 
> Alternative suggestions welcome.
> 
> This approach means that userspace must try a bit harder to decode
> the verdict since we cannot use 'verdict & NF_VERDICT_MASK' if we're
> looking at a NFT_* verdict when translating the integer to a string.

With the approach I mentioned we can use the normal decoding functions
which (at least in nft) handle this case fine.
