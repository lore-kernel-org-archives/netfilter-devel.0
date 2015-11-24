From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Tue, 24 Nov 2015 11:59:43 +0100
Message-ID: <20151124105943.GG1740@breakpoint.cc>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151124102746.GA2917@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58550 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbbKXK7p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:59:45 -0500
Content-Disposition: inline
In-Reply-To: <20151124102746.GA2917@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 23, 2015 at 12:43:17PM +0200, Florian Westphal wrote:
> > Ads section:
> > conntrack+filter + nat table used in init namespace, single TCP_STREAM lo netperf:
> > 87380  16384  16384    30.00    14348.66
> > with patch set, netperf running in net namespace without rules:
> > 87380  16384  16384    30.00    15683.97
> > 
> > routing from ns3 -> ns2, filter + nat table & conntrack in all namespaces:
> > 87380  16384  16384    30.00    5664.46
> > without conntrack+any tables in those namespaces:
> > 87380  16384  16384    30.00    7336.54
> 
> Florian, I didn't have time so far on this but I really expect that
> you follow up on this with a new version adressing or summarizing
> possible solutions for the corner cases that we have discussed
> previously.

Yes, a new version will be coming, adding a new

+       void (*newproto)(void);

To struct nfnl_ct_hook, this allows ct protocol registration
to make ctnetlink aware of new protocols if events are currently in use.

Drawback: once such hooks are registered, they won't go away anymore
unless ns is destroyed or module is unloaded, but I don't think
its a problem.  We can discuss the fine print when next round is sent.

Its ready but untested, and needs another rebase.
I hope I get to it later this week.

Thanks for your patience.
