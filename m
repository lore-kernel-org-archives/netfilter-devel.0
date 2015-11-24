From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 11:33:41 +0000
Message-ID: <20151124113341.GO2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45083 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbbKXLdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:33:45 -0500
Content-Disposition: inline
In-Reply-To: <20151124111029.GH1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On more thing to consider it interaction with other netfilter subsystems.
> > 
> > F.i. I think it would be very useful to have per connection tracing, so
> > we'd store a flag in the nfct and transfer it to every packet. This would
> > make them show up in the nft ruleset,
> 
> I'd prefer to complete set support for labels for this, so we can do
> something like
>  chain ct_trace {
> 	 type filter hook prerouting priority 0;
> 	 tcp dport 22 ct state new label set trace
> 	 ct label trace meta set nftrace 1
>  }
> 
>  chain ct_trace_out {
> 	 type filter hook output priority 0;
> 	 ct label trace meta set nftrace 1
>  }
> 
> Which would do in/out tracing without any additional code
> (except the label set support, of course).

That's of course one possibilty but it lacks one important point, we could
not trace the first packet going through conntrack.

> > but what about tracing in specific
> > points of conntrack/NAT itself? Can we send them to the same group and
> > make them integrate with ruleset tracing?
> 
> Good point.
> 
> I think we would first have to identify possible interesting tracing points.
> Did you have anything specific in mind?

I guess the hooks themselves, probably helper invocation and/or results,
possibly interesting points within helpers, errors in protocol tracking,
basically I think a good starting point would be what we now have as global
tracing points.
