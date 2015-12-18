From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nft] ct expr: make directional keys work
Date: Fri, 18 Dec 2015 18:17:07 +0100
Message-ID: <20151218171707.GA29573@breakpoint.cc>
References: <20151217005533.GA24044@strlen.de>
 <20151217111334.GA1694@salvia>
 <20151217130344.GA3198@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40053 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932287AbbLRRRJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 12:17:09 -0500
Content-Disposition: inline
In-Reply-To: <20151217130344.GA3198@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think this should fit into the grammar that I'm proposing above with
> > no shift/reduce conflicts, ie.
> > 
> > ct packets VALUE
> > ct direction original packets VALUE
> > ct direction reply packets VALUE
> 
> I'll have to check.  I don't want to add any new keywords to the lexer
> since that creates more problems for the grammar.

Drats, it doesn't work.
conflicts: 1 shift/reduce

'ct direction' is already a valid expression, it loads
CTINFO2DIR(ctinfo).

I'll send what I have in a second, but its not great either.
