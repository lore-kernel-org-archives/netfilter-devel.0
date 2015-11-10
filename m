From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Tue, 10 Nov 2015 18:22:10 +0000
Message-ID: <20151110182210.GC25929@macbook.localdomain>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
 <20151110165156.GA3227@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:61950 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbbKJSWP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 13:22:15 -0500
Content-Disposition: inline
In-Reply-To: <20151110165156.GA3227@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.11, Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> On Fri, Nov 06, 2015 at 06:34:17PM +0000, Patrick McHardy wrote:
> > The following patches add support for the flow statement, which allows to
> > dynamically instantiate stateful statements fow an arbitrary defined flow
> > key.
> >
> > Currently we have to stateful statements, counter and limit. This example
> > shows some accounting possibilities using the counter statement. Please note
> > that the output format is still WIP and not included in this patchset:
> >
> > # nft filter input flow table test iif . tcp flags counter
> 
> This looks very good to me :-).
> 
> > # nft list flow table filter test
> > iface_index	tcp_flag	statement
> > lo		fin | psh | urg	counter packets 1002 bytes 40080
> > wlp2s0		fin | ack	counter packets 3 bytes 156
> > wlp2s0		ack		counter packets 32 bytes 18440
> > wlp2s0		syn | ack 	counter packets 5 bytes 300
> > wlp2s0		psh | ack	counter packets 57 bytes 13804
> > lo		rst | ack	counter packets 998 bytes 39920
> > 
> > # nft filter output flow table uidacct skuid . oif . ip protocol counter
> > # nft list flow table filter uidacct
> 
> BTW, I can see the content is currently listed (in the non-pretty
> output format) through:
> 
>         nft list set filter test
> 
> so I can see how that flow table gets populated with entries.

Yes, for now this is not explicitly surpressed.

> >From the syntax perspective, I'm aware this the general definition in
> the industry for this is 'flow table' but my only concern here with
> this denomination is that we already have in our own tables with quite
> different semantics.

You mean our rule tables? Yeah, but this is explicitly qualified as
"flow" table. I don't really think there is much room for confusion.

I'm open to suggestions of course.

> Moreover, the fact that we can list this as sets (since they are
> actually using the generic nf_tables set infrastructure) may be
> confusing to users.

That is only until we have explicit listing for these. I'll hide them
from the set view then.

> BTW, should we have implicit and explicit flow tables just like sets?

So far explicit flow tables don't make sense since the kernel enforces
that only a single binding exists. I've added this since the desired
semantics of shared flow tables have to be hashed out first and I didn't
want to commit to something without thinking it through.
