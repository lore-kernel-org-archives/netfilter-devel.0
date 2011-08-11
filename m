From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH] netfilter: nf_queue: fix NF_STOLEN skb leak redux
Date: Fri, 12 Aug 2011 00:58:48 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1108120052050.1494@ja.ssi.bg>
References: <1313095621-2015-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:48372 "EHLO ja.ssi.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab1HKVxz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:53:55 -0400
In-Reply-To: <1313095621-2015-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

On Thu, 11 Aug 2011, Florian Westphal wrote:

> A userspace listener may send (bogus) NF_STOLEN verdict, which causes
> skb leak.
> 
> This problem was previously fixed via
> 64507fdbc29c3a622180378210ecea8659b14e40 (netfilter:
> nf_queue: fix NF_STOLEN skb leak) but this had to be reverted
> because NF_STOLEN can also be returned by a netfilter hook when
> iterating the rules in nf_reinject.
> 
> This is complementary to commit fad54440438a7c231a6ae347738423cbabc936d9
> (netfilter: avoid double free in nf_reinject).
> 
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  One alternative would be to change ip(6)queue and nfqueue
>  to fail with -EINVAL if userspace gives NF_STOLEN verdict.
>  Thoughts?
> 
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 5b466cd..dd2d014 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -267,6 +267,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	const struct nf_afinfo *afinfo;
>  	int err;
>  
> +	/* NF_STOLEN from userspace makes no sense, we must free packet */
> +	if (WARN_ONCE(verdict == NF_STOLEN, "bogus verdict NF_STOLEN\n"))
> +		verdict = NF_DROP;
> +

	Good catch, thanks! Can you add some prefix to this
message such as KERN_WARNING "nf_queue: " ?

>  	rcu_read_lock();
>  
>  	nf_queue_entry_release_refs(entry);

Regards

--
Julian Anastasov <ja@ssi.bg>
