From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue: detect when packet has already been checksummed?
Date: Wed, 29 May 2013 14:23:28 +0200
Message-ID: <20130529122328.GA6286@localhost>
References: <20130526204826.GC6578@breakpoint.cc>
 <20130529111423.GA4989@localhost>
 <20130529112542.GE6578@breakpoint.cc>
 <20130529115705.GA5315@localhost>
 <20130529120329.GF6578@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nf-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37420 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965860Ab3E2MXn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 08:23:43 -0400
Content-Disposition: inline
In-Reply-To: <20130529120329.GF6578@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 29, 2013 at 02:03:29PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I agree that the current situation is inconsistent. We have no way to
> > know if the kernel validated the checksum or not from user-space, and
> > I think this needs a fix.
> 
> Good :-)
> 
> > We can add a new NFQA_CFG_F_CSUM flag so user-space explicitly ask for
> > assistance regarding checksumming from the kernel. If user-space tries
> > to set that flag and the kernel does not support it, it will hit
> > -EOPNOTSUPP. Thus, we can skip the feature retrieval thing.
> 
> Yes, but this looks like abuse of the flag semantics to me.
> Unless you mean that setting this feat flag should prompt the kernel
> to explicitly call a valiation function in case skb_csum_unnecessary()
> returns false?

I mean exactly the current behaviour but forcing user-space to ask for
it. So skb info flag regarding checksumming comes from kernel if
explicitly requested from user-space.
