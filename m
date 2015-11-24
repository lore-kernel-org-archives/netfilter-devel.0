From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 10:35:26 +0000
Message-ID: <20151124103526.GH2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124101705.GB2683@salvia>
 <20151124102707.GC1740@breakpoint.cc>
 <20151124103045.GA2947@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44633 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699AbbKXKfa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:35:30 -0500
Content-Disposition: inline
In-Reply-To: <20151124103045.GA2947@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 11:27:07AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Do you think we can place all this new netlink code in
> > > net/netfilter/nf_tables_trace.c ? So we leave in the core file only
> > > our classifier engine.
> > > 
> > > I like the attribute definition rename in nf_tables.h, but this code
> > > we can probably place it away from here.
> > 
> > Ok, I'll see if this is doable without exporting half a dozen of
> > symbols.
> 
> If you place this in this core, we should need to export any symbol.
> 
> nf_tables-objs += nf_tables_core.o nf_tables_api.o nf_tables_trace.o
> 
> And I would expect probably only functions to enable/disabling tracing
> and to notify the trace via netlink.

I think we can also avoid the enable/disable exports. Having meta optional
doesn't make too much sense to me, it provides very fundamental features
like interface matching which I don't think anyone can reasonably disable.
