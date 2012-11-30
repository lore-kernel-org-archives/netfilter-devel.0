From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Fri, 30 Nov 2012 15:02:54 +0100
Message-ID: <20121130140254.GB31969@breakpoint.cc>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
 <20121130135806.GA7955@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33830 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297Ab2K3OCz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:02:55 -0500
Content-Disposition: inline
In-Reply-To: <20121130135806.GA7955@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Quick idea: I think we can also support atomic replacement at word
> size using xchg, so the replacement operation can still happen at word
> level. Setting many bits at once would be also faster with that.

Unfortunately, no -- the interface is too rudimentary.
Example: You want to set bis 0, 2, 6; but leave all other
bit that are set intact.

So you first need to make a dump to fetch the current labels set.
Then, you set bits 0, 2, 6 and send the new state to the kernel.

But between the dump and the set operation, a new bit might
have been set.  So even when using xchg it will be un-set again...
