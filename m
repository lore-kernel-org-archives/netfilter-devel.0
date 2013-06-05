From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] expect: consider all expect attributes when
 comparing
Date: Wed, 5 Jun 2013 09:35:29 +0200
Message-ID: <20130605073529.GA15131@breakpoint.cc>
References: <1370091571-23140-1-git-send-email-fw@strlen.de>
 <1370091571-23140-3-git-send-email-fw@strlen.de>
 <20130605025111.GA17004@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39211 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab3FEHfc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:35:32 -0400
Content-Disposition: inline
In-Reply-To: <20130605025111.GA17004@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +static int
> > +cmp_exp_timeout(const struct nf_expect *exp1, const struct nf_expect *exp2,
> > +		unsigned int flags)
> > +{
> > +	return exp1->timeout == exp2->timeout;
> > +}
> 
> The timeout comparison needs to implement the __NFCT_CMP_TIMEOUT
> logic, similar to nfct_cmp. Otherwise nfexp_cmp will break in
> conntrackd with expect sync mode.

You're right of course.  I'll implement this and send a v2 of this
patch.

Thanks for catching this!
