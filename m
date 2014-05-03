From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sat, 03 May 2014 11:15:45 +0400
Message-ID: <536497A1.9060708@parallels.com>
References: <20140430092905.GA4318@localhost> <5363BC86.6050608@parallels.com> <20140502225522.GA12404@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:25003 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaECHRT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 May 2014 03:17:19 -0400
In-Reply-To: <20140502225522.GA12404@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/03/2014 02:55 AM, Florian Westphal wrote:
> Vasily Averin <vvs@parallels.com> wrote:
>> I've found defrag user check in ip_expire() -- but it does not take
>> account of zone.
>> Is it a bug in ip_expire() or I missed something?
> 
> Looks like a bug to me.

Thanks, I've submitted separated patch to fix it.

>> ---[patch rfc]---
>> This patch adds per network namespace flag to manage ipv4 defragmentation
>> in bridge.
> 
> Are we sure this is required rather than just removing the skb->nfct
> test in br_nf_dev_queue_xmit() and be done with it?
> Because that seems a lot saner to me, I fail to see how
> 
> if (skb->protocol == htons(ETH_P_IP) &&
>            skb->len + nf_bridge_mtu_reduction(skb) >
> 		    skb->dev->mtu && !skb_is_gso(skb)) {
> 
> Would evaluate as 'true' without nf_defrag_ipv4 module loaded.
> 
> [ its from br_nf_dev_queue_xmit function ]

I think you are right, seems skb->nfct check will be extra anyway.

However my patch fixes wrong processing packets in bridge in case disabled conntracks.
Probably Patrick can elaborate in more details why this is bad.

I have noticed only that currently bridge without conntracks can silently merge 2 small
packets if their common size < mtu. Probably it can be unexpected for processing on destination side.
However if we enable connection tracking -- we'll get the same situation again.

> I wonder who would be responsible to set br_ipv4_defrag_disabled to false
> to enable conntracking on a bridge again?
> 
> Did i miss something in the patch?

I'm sorry, you are right, changes of nf_conntrack_ipv4 pernet_operations was lost 
I'll resend resend updated patch soon.

