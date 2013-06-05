From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] expect: consider all expect attributes when
 comparing
Date: Wed, 5 Jun 2013 22:33:40 +0200
Message-ID: <20130605203340.GD15131@breakpoint.cc>
References: <1370091571-23140-1-git-send-email-fw@strlen.de>
 <1370091571-23140-3-git-send-email-fw@strlen.de>
 <20130605025111.GA17004@localhost>
 <20130605073529.GA15131@breakpoint.cc>
 <20130605154101.GC15131@breakpoint.cc>
 <20130605174619.GB3553@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42181 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222Ab3FEUdl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:33:41 -0400
Content-Disposition: inline
In-Reply-To: <20130605174619.GB3553@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 05, 2013 at 05:41:01PM +0200, Florian Westphal wrote:
> > Hrm, I think a better option is to not compare the expectation timeout
> > in the first place.  I think the timeout is an irrelevant meta detail;
> > if the actual expectations are identical, nfexp_cmp should say so even
> > if they happen to have different timeouts.
> 
> That's fine with me, we don't have any requirement for such feature at
> this moment. So just skip it. Probably adding a short comment in the
> code would be a good idea as placeholder.

Perfect!
I've pushed all three patches, with ATTR_TIMEOUT compare replaced by a
comment. 
