From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 13:20:03 +0100
Message-ID: <20151125122003.GI23215@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
 <20151125083907.GF23215@breakpoint.cc>
 <20151125093554.GA31023@macbook.localdomain>
 <20151125101329.GH23215@breakpoint.cc>
 <20151125115103.GB31023@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33265 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbbKYMUF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:20:05 -0500
Content-Disposition: inline
In-Reply-To: <20151125115103.GB31023@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > Sorry, could you be more specific?
> > How would you tell userspace where the jump/goto is going to?
> 
> We have nft_verdict_dump(), which encodes the verdict as nested attribute.
> I'd suggest to simply use that one since we also already have parsing
> functions for that in both nft and libnftnl and we can use the regular
> data structures.

Thanks for clarifying, I'll switch NFTA_TRACE_VERDICT to nested attr.
