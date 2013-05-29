From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue: detect when packet has already been checksummed?
Date: Wed, 29 May 2013 15:25:37 +0200
Message-ID: <20130529132537.GH6578@breakpoint.cc>
References: <20130526204826.GC6578@breakpoint.cc>
 <20130529111423.GA4989@localhost>
 <20130529112542.GE6578@breakpoint.cc>
 <20130529115705.GA5315@localhost>
 <20130529120329.GF6578@breakpoint.cc>
 <20130529122328.GA6286@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	nf-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45281 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965613Ab3E2NZi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 09:25:38 -0400
Content-Disposition: inline
In-Reply-To: <20130529122328.GA6286@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, but this looks like abuse of the flag semantics to me.
> > Unless you mean that setting this feat flag should prompt the kernel
> > to explicitly call a valiation function in case skb_csum_unnecessary()
> > returns false?
> 
> I mean exactly the current behaviour but forcing user-space to ask for
> it. So skb info flag regarding checksumming comes from kernel if
> explicitly requested from user-space.

Fair enough, I can resubmit this for -next with this behaviour,
I had hoped to avoid a new flag, since there is no reason for it
OTHER than to figure out if the kernel knows about that checksumming
feature.
