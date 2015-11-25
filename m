From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 09:48:55 +0100
Message-ID: <20151125084855.GG23215@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
 <20151125083907.GF23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60971 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbbKYIs5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 03:48:57 -0500
Content-Disposition: inline
In-Reply-To: <20151125083907.GF23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > It would be nice to have the full verdict available, IOW also the jump target.
> > 
> > You could simply pass struct nft_verdict to this function and adapt
> > nft_verdict_dump() to take the attribute value as parameter.
> 
> Will add NFTA_TRACE_JUMP/NFTA_TRACE_GOTO for that, ok?

Scratch that, I'll add NFTA_TRACE_JUMP_TARGET (NLA_STRING) containing
name of the jump target (if any).

GOTO case can be inferred from the verdict attribute.
