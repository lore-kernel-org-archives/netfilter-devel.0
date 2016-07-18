From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/3] meta: add random expression key
Date: Tue, 19 Jul 2016 00:09:10 +0200
Message-ID: <20160718220910.GA29897@breakpoint.cc>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-2-git-send-email-fw@strlen.de>
 <20160718193421.GA4275@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52013 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbcGRWJS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 18:09:18 -0400
Content-Disposition: inline
In-Reply-To: <20160718193421.GA4275@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jul 05, 2016 at 09:35:33AM +0200, Florian Westphal wrote:
> > meta random fills a 32bit register with a pseudo-random number.
> > 
> > For instance one can now use
> > 
> > meta random <= 2147483647
> > 
> > ... to match every 2nd packet, on average.
> > 
> > A followup patch will add a short-hand version ('probability 0.5') so
> > that users do not have to deal with details.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Please, apply this patch.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> We can later on revisit the probability scaling, so keep 2/3 and 3/3
> back by now.

Done, I pushed a slightly amended version (no additional #include, only
needed in followup changes, I also edited the changelog to not mention
probability anymore.
