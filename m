From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] netfilter: nft: add queue module
Date: Wed, 4 Dec 2013 12:39:18 +0100
Message-ID: <20131204113918.GA13246@localhost>
References: <20131130122657.GG2067@breakpoint.cc>
 <1385824444-4506-1-git-send-email-eric@regit.org>
 <20131204110021.GA11380@localhost>
 <20131204113143.GC2767@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46349 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab3LDLjY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:39:24 -0500
Content-Disposition: inline
In-Reply-To: <20131204113143.GC2767@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 04, 2013 at 12:31:43PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	while (jhash_initval == 0)
> > > +		jhash_initval = prandom_u32();
> > 
> > Different initialization approach with regards to xt_NFQUEUE, any
> > reason for that change?
> 
> I suggested this -- get_random_bytes is overkill for nfqueue
> purposes.
> 
> In fact, I think xt_NFQUEUE should be switched to prandom interface
> as well.

I see. For consistency, it would be good to get a patch so both are in
sync.
