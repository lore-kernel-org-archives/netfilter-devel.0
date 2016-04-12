From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] NFQUEUE: Fix bug with order of fanout and bypass
Date: Tue, 12 Apr 2016 19:28:37 +0200
Message-ID: <20160412172837.GA4311@breakpoint.cc>
References: <20160412171857.GA9814@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37457 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933141AbcDLR2k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 13:28:40 -0400
Content-Disposition: inline
In-Reply-To: <20160412171857.GA9814@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> NFQUEUE had a bug with the ordering of fanout and bypass options which
> was arising due to same and odd values for flags and bypass when used
> together. Because of this, during bitwise ANDing of flags and
> NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
> NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
> whenever it was used before bypass because then flags would be 1.
> 
> Before this patch,
> 
> $ sudo iptables -A FORWARD -j NFQUEUE -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout --queue-bypass
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass
> 
> After this patch,
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass cpu-fanout
 
> Closes bugzilla entry: http://bugzilla.netfilter.org/show_bug.cgi?id=939

Ugh, good catch!

> diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
> index 8115457..0b5becc 100644
> --- a/extensions/libxt_NFQUEUE.c
> +++ b/extensions/libxt_NFQUEUE.c
> @@ -99,7 +99,7 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
>  	NFQUEUE_parse_v1(cb);
>  	switch (cb->entry->id) {
>  	case O_QUEUE_BYPASS:
> -		info->bypass = 1;
> +		info->bypass |= NFQ_FLAG_BYPASS;
>  		break;

I don't like this mix of v2 and v3 layout.

Could you try to create an alternate patch that changes
NFQUEUE_parse_v3 to call NFQUEUE_parse_v1 and then add
	case O_QUEUE_BYPASS:
		info->bypass |= NFQ_FLAG_BYPASS;

to NFQUEUE_parse_v3?

I think that this would make it a bit clearer and
it also avoids the v3/v2/v1 stacking.

Thanks!
