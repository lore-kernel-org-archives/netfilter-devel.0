From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 12:10:29 +0100
Message-ID: <20151124111029.GH1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58603 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbbKXLKc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:10:32 -0500
Content-Disposition: inline
In-Reply-To: <20151124105300.GK2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 24.11, Pablo Neira Ayuso wrote:
> > What I'm trying to avoid is the initial race that we'll have.
> > 
> > I mean, with this approach the user will likely enable the tracing
> > from the rule, then will launch nft trace. In that case, he will be
> > getting traces from the old way for a little while until you get one
> > process subscribed to this.

Right, not nice.

> On more thing to consider it interaction with other netfilter subsystems.
> 
> F.i. I think it would be very useful to have per connection tracing, so
> we'd store a flag in the nfct and transfer it to every packet. This would
> make them show up in the nft ruleset,

I'd prefer to complete set support for labels for this, so we can do
something like
 chain ct_trace {
	 type filter hook prerouting priority 0;
	 tcp dport 22 ct state new label set trace
	 ct label trace meta set nftrace 1
 }

 chain ct_trace_out {
	 type filter hook output priority 0;
	 ct label trace meta set nftrace 1
 }

Which would do in/out tracing without any additional code
(except the label set support, of course).

> but what about tracing in specific
> points of conntrack/NAT itself? Can we send them to the same group and
> make them integrate with ruleset tracing?

Good point.

I think we would first have to identify possible interesting tracing points.
Did you have anything specific in mind?
