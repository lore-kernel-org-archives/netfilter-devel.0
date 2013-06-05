From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] expect: consider all expect attributes when comparing
Date: Wed, 5 Jun 2013 19:46:19 +0200
Message-ID: <20130605174619.GB3553@localhost>
References: <1370091571-23140-1-git-send-email-fw@strlen.de>
 <1370091571-23140-3-git-send-email-fw@strlen.de>
 <20130605025111.GA17004@localhost>
 <20130605073529.GA15131@breakpoint.cc>
 <20130605154101.GC15131@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945Ab3FERqj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:46:39 -0400
Content-Disposition: inline
In-Reply-To: <20130605154101.GC15131@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 05, 2013 at 05:41:01PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > +static int
> > > > +cmp_exp_timeout(const struct nf_expect *exp1, const struct nf_expect *exp2,
> > > > +		unsigned int flags)
> > > > +{
> > > > +	return exp1->timeout == exp2->timeout;
> > > > +}
> > > 
> > > The timeout comparison needs to implement the __NFCT_CMP_TIMEOUT
> > > logic, similar to nfct_cmp. Otherwise nfexp_cmp will break in
> > > conntrackd with expect sync mode.
> > 
> > You're right of course.  I'll implement this and send a v2 of this
> > patch.
> 
> Hrm, I think a better option is to not compare the expectation timeout
> in the first place.  I think the timeout is an irrelevant meta detail;
> if the actual expectations are identical, nfexp_cmp should say so even
> if they happen to have different timeouts.

That's fine with me, we don't have any requirement for such feature at
this moment. So just skip it. Probably adding a short comment in the
code would be a good idea as placeholder.
