From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] tproxy: do not assign timewait sockets to skb->sk
Date: Thu, 17 Feb 2011 21:52:49 +0100
Message-ID: <20110217205249.GF8821@Chamillionaire.breakpoint.cc>
References: <1297683874-10188-1-git-send-email-fw@strlen.de>
 <1297972902.2253.51.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, KOVACS Krisztian <hidden@balabit.hu>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35557 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925Ab1BQUwv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:52:51 -0500
Content-Disposition: inline
In-Reply-To: <1297972902.2253.51.camel@Nokia-N900-51-1>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Balazs Scheidler <bazsi@balabit.hu> wrote:
> the only issue I see with this solution is that late packets will not be delivered to the proper socket, and will possibly be going to the fwd chain, which might be unexpected.

Why?
They'll get the proper nfmark, so they will be routed to the local
machine. The tcp stack should find the tw socket via normal sk lookup.

Or am i missing something?
