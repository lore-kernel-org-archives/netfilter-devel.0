From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Tue, 22 Mar 2011 22:26:39 +0100
Message-ID: <20110322212639.GA16534@Chamillionaire.breakpoint.cc>
References: <1300746341-18011-2-git-send-email-fw@strlen.de>
 <1300747149.2837.22.camel@edumazet-laptop>
 <1300747379.2837.23.camel@edumazet-laptop>
 <20110321.165829.28821319.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric.dumazet@gmail.com, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41876 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab1CVV0n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20110321.165829.28821319.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller <davem@davemloft.net> wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 21 Mar 2011 23:42:59 +0100
> 
> > Ah sorry, I missed the "static const". Maybe I should just sleep now ;)
> 
> Well, I would really prefer if ip6_route_output() and friends mark
> their 'sk' argument as 'const'.
> 
> Otherwise someone is going to read this code and be really concerned
> that "sk" really might be modified in some way by this code path,
> thus making parallel access to this static const 'sk' illegal.

good point.
Its just a two-line change, so I guess its okay if I make this
change in this patch, too.

If you object and think it should be a new patch, please let me
know.
