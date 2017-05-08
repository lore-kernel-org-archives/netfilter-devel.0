From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] netlink_delinearize: don't kill dependencies accross
 statements
Date: Mon, 8 May 2017 21:54:26 +0200
Message-ID: <20170508195426.GB9660@breakpoint.cc>
References: <20170508081750.28093-1-fw@strlen.de>
 <20170508175657.GA7955@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41022 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755234AbdEHTyw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 15:54:52 -0400
Content-Disposition: inline
In-Reply-To: <20170508175657.GA7955@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 08, 2017 at 10:17:50AM +0200, Florian Westphal wrote:
> > nft currently translates
> > ip protocol tcp meta mark set 1 tcp dport 22
> > to
> > mark set 0x00000001 tcp dport 22
> > 
> > This is wrong, the latter form is same as
> > 
> > mark set 0x00000001 ip protocol tcp tcp dport 22
> > 
> > and thats not correct (original rule sets mark for tcp packets only).
> > 
> > We need to clear the dependency stack whenever we see a statement other
> > than stmt_expr, as these will have side effects (counter, payload
> > mangling, logging and the like).
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Could you add a test for this? Thanks.

Yes, I'll push that too soon, thanks!
