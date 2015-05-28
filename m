From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters
 from iptables rules
Date: Thu, 28 May 2015 14:33:37 -0700
Message-ID: <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34412 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbbE1Vdj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 17:33:39 -0400
Received: by ieczm2 with SMTP id zm2so48940898iec.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 14:33:38 -0700 (PDT)
In-Reply-To: <1432846296-26396-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-05-28 at 22:51 +0200, Florian Westphal wrote:
> The binary arp/ip/ip6tables ruleset is stored per cpu.
> 
> The only reason left as to why we need percpu duplication are the rule
> counters embedded into ipt_entry et al -- since each cpu has its own copy
> of the rules, all counters can be lockless.
> 
> The downside is that the more cpus are supported, the more memory is
> required.  Rules are not just duplicated per online cpu but for each
> possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
> not for the e.g. 64 cores present.
> 
> To save some memory and also allow cpus with shared caches to make
> better use of available cache size, it would be preferable to only
> store a copy of the rule blob for each numa node.
> 
> So we first need to separate counters and the rule blob.
> 
> We create array of struct xt_counters for each possible cpu and
> index them from the main blob via the (unused after validation)
> ->comefrom member.

Yeah, I remember trying to work on this exact idea some years ago,
but gave up (maybe because nftable was coming)

> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Changes since v1:
>   - add ->comefrom comment in arptables, too
> 
>  include/linux/netfilter/x_tables.h |  6 ++++++
>  net/ipv4/netfilter/arp_tables.c    | 33 +++++++++++++++---------------
>  net/ipv4/netfilter/ip_tables.c     | 31 ++++++++++++++--------------
>  net/ipv6/netfilter/ip6_tables.c    | 32 ++++++++++++++---------------
>  net/netfilter/x_tables.c           | 42 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 95 insertions(+), 49 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 09f3820..e50ba76 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -224,6 +224,12 @@ struct xt_table_info {
>  	unsigned int stacksize;
>  	unsigned int __percpu *stackptr;
>  	void ***jumpstack;
> +
> +	/* pointer to array of counters, one per CPU
> +	 * each rule maps 1:1 to an entry in the percpu counter array.
> +	 */
> +	struct xt_counters **counters;
> +

You could avoid using this array, if you use alloc_percpu(struct
xt_counter) per counter.

In the rules, instead of storing the index of each counter, store the
percpu address.

This would avoid yet another indirection in iptables.

And it would be nice avoiding this stuff on non SMP kernels maybe ?

Thanks !


