From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 15:24:33 +0100
Message-ID: <20121127142433.GE14156@breakpoint.cc>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50349 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348Ab2K0OYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:24:35 -0500
Content-Disposition: inline
In-Reply-To: <20121127141317.GB9089@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I was thinking on the case in which we are setting bits via the
> connlabel extension and modifying this from ctnetlink at the same
> time.

Indeed, in that case we might scribble over a bit that has been set
the instant before.

And yes, this might be a problem.
The only way to fix it (AFAICS) would be to add a new interface to
allow (un)setting specific bits from userspace, so that userspace
could request "set this bit" or "clear that bit", rather than the
current "dump/modify/replace" cycle.
