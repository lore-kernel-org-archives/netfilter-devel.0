From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFQUEUE balancing extension (userspace changes)
Date: Fri, 05 Jun 2009 13:28:30 +0200
Message-ID: <4A29015E.5020307@trash.net>
References: <1244164679-11032-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55344 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZFEL2a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:28:30 -0400
In-Reply-To: <1244164679-11032-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Hello list,
> 
> this adds a new revision of the NFQUEUE target.
> 
> In particular, a new "--queue-balance" option, which allows to
> specify a range of queues to use.
> Packets are then balanced across the given queues by the kernel.
> 
> This is useful for multicore systems:
> start multiple instances of the userspace program on queues
> x, x+1, .. x+n and use "--queue-balance x:x+n".
> 
> As for naming, if you'd prefer a different name (or just extend
> the existing --queue-num option to accept "firstid:lastid" instead),
> please let me know and I'll be happy to change it.
> 
> Both paches can also be pulled from
> git://git.breakpoint.cc/fw/iptables.git nfq-balance

Thanks, I'll wait with pulling these until we've made the iptables
release for 2.6.30.

