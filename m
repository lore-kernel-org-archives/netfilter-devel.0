From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2] netfilter: nft: add queue module
Date: Wed, 4 Dec 2013 12:31:43 +0100
Message-ID: <20131204113143.GC2767@breakpoint.cc>
References: <20131130122657.GG2067@breakpoint.cc>
 <1385824444-4506-1-git-send-email-eric@regit.org>
 <20131204110021.GA11380@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60112 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543Ab3LDLbp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:31:45 -0500
Content-Disposition: inline
In-Reply-To: <20131204110021.GA11380@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	while (jhash_initval == 0)
> > +		jhash_initval = prandom_u32();
> 
> Different initialization approach with regards to xt_NFQUEUE, any
> reason for that change?

I suggested this -- get_random_bytes is overkill for nfqueue
purposes.

In fact, I think xt_NFQUEUE should be switched to prandom interface
as well.

