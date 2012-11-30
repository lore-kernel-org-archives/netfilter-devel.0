From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Fri, 30 Nov 2012 14:58:06 +0100
Message-ID: <20121130135806.GA7955@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab2K3N6K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:58:10 -0500
Content-Disposition: inline
In-Reply-To: <20121127142433.GE14156@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 03:24:33PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I was thinking on the case in which we are setting bits via the
> > connlabel extension and modifying this from ctnetlink at the same
> > time.
> 
> Indeed, in that case we might scribble over a bit that has been set
> the instant before.
> 
> And yes, this might be a problem.
> The only way to fix it (AFAICS) would be to add a new interface to
> allow (un)setting specific bits from userspace, so that userspace
> could request "set this bit" or "clear that bit", rather than the
> current "dump/modify/replace" cycle.

I see. That replacement operation still seems useful to me though.

Quick idea: I think we can also support atomic replacement at word
size using xchg, so the replacement operation can still happen at word
level. Setting many bits at once would be also faster with that.
