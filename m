From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 0/8] rework dependency removal
Date: Fri, 27 Oct 2017 14:46:49 +0200
Message-ID: <20171027124649.GN19457@breakpoint.cc>
References: <20171026230611.14269-1-fw@strlen.de>
 <20171027103916.GA21822@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752549AbdJ0MrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 08:47:07 -0400
Content-Disposition: inline
In-Reply-To: <20171027103916.GA21822@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> What I don't still is why patch 1/8 is expanding icmp type
> echo-request to show explicit "ether type ip icmp type echo-request"
> when listing the ruleset.
> 
> I mean:
> 
> -icmp type echo-request;ok
> +icmp type echo-request;ok;ether type ip icmp type echo-request

Correct, this is redundant, the 'ether type ip' could be removed
here.

But it would need more work to achive this, f.e. by
tracking not the last but all seen dependencies per-base and doing
the removal only after seeing all consecutive expression statements.

At the moment, when 'remove ether type ip' decision is made, we only
know that the next expression is 'meta l4proto'.

But that is not enough to know if the dependency is implicit or not.
Another soltution would be to pass the relational expression, and
then extract rhs too. That would allow to see the 'icmp' in
'meta l4proto icmp' (and then remove the dep because icmp implies ipv4).

However, as icmp is the only case where we can do the removal I think
its currently not super urgent to make these changes.

Does that explanation help?

I would re-word the commit message accordingly.
