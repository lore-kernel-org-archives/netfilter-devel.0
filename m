From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Thu, 7 Apr 2016 23:49:42 +0200
Message-ID: <20160407214942.GB731@breakpoint.cc>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57425 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbcDGVtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 17:49:45 -0400
Content-Disposition: inline
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patchset introduces the named stateful expressions for nf_tables,
> that allows userspace to set a name for the stateful expression for
> several reasons:
> 
>  * Provide a unique identifier to fetch and reset it internal state.
>  * Allow to update of their parameters and internal state.
>  * Allow to fetch and reset its internal state.
>  * Refer to the same stateful expression from one or more rules.
>

Can't all of this be achieved via custom chains already...?

> nf_tables currently supports to stateful expressions: limit and counter,
> therefore you can create named instances of this expressions through
> this new infrastructure.

> Several examples on how this would look from userspace:
> 
> * Add the 'tcp-counter' counter to the 'filter' table:
> 
>  # nft add counter filter tcp-counter
> 
> * Delete this counter (only possible if not dereferenced from a rule):
> 
>  # nft delete counter filter tcp-counter
> 
> * List existing named counters:
> 
>  # nft lists counters
>  table ip filter {
>         counter tcp-counter {
>                 packets 6086 bytes 6278052
>         }
>         counter udp-counter {
>                 packets 272 bytes 64690
>         }
>         counter icmp-counter {
>                 packets 10 bytes 840
>         }
>  }

Can't you already create a 'named counter' via

chain tcp-counter {
	counter
}

?

Seems to me we only would have to teach nft list to
allow filtering output on chain names, e.g.

nft list table filter \*-counter

to have something similar using exsiting feature set.

> So far, only counters are supported, but it should be possible to
> support named limits. I have another (imcomplete) patch that allows to
> update the named expressions parameters, this can be useful to
> dynamically update the ratelimiting policies, the command line should
> look like:
> 
>  # nft update limit name user01234 rate 250 mbytes/day

Similar comment here, you could create

chain user01234 {
	limit rate 100 mbytes/day
}

This feature seems strange to me, AFAIU it adds a container for single
expressions, so it just seems to be a subset of what we already have
(namely chains as containers of rules).

What am I missing? :)

Is there something that is too cumbersome to achive with a chain-based
approach?
