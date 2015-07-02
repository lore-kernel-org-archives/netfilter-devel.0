From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Thu, 2 Jul 2015 13:30:44 +0200
Message-ID: <20150702113044.GA21930@salvia>
References: <1435695660-26048-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbGBLZO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 07:25:14 -0400
Content-Disposition: inline
In-Reply-To: <1435695660-26048-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 30, 2015 at 10:21:00PM +0200, Florian Westphal wrote:
> commit 482cfc318559 ("netfilter: xtables: avoid percpu ruleset duplication")
> 
> Unlike ip and ip6tables, arp tables were never converted to use the percpu
> jump stack.
> 
> It still uses the rule blob to store return address, which isn't safe
> anymore since we now share this blob among all processors.
> 
> Because there is no TEE support for arptables, we don't need to cope
> with reentrancy, so we can use loocal variable to hold stack offset.
> 
> Fixes: 482cfc318559 ("netfilter: xtables: avoid percpu ruleset duplication")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/arp_tables.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index 95c9b6e..0fbe1a6 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -254,9 +254,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
>  	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
>  	unsigned int verdict = NF_DROP;
>  	const struct arphdr *arp;
> -	struct arpt_entry *e, *back;
> +	struct arpt_entry *e, **jumpstack;
>  	const char *indev, *outdev;
>  	const void *table_base;
> +	unsigned int cpu, stackidx = 0;
>  	const struct xt_table_info *private;
>  	struct xt_action_param acpar;
>  	unsigned int addend;
> @@ -270,15 +271,16 @@ unsigned int arpt_do_table(struct sk_buff *skb,
>  	local_bh_disable();
>  	addend = xt_write_recseq_begin();
>  	private = table->private;
> +	cpu     = smp_processor_id();
>  	/*
>  	 * Ensure we load private-> members after we've fetched the base
>  	 * pointer.
>  	 */
>  	smp_read_barrier_depends();
>  	table_base = private->entries;
> +	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
>  
>  	e = get_entry(table_base, private->hook_entry[hook]);
> -	back = get_entry(table_base, private->underflow[hook]);
>  
>  	acpar.in      = state->in;
>  	acpar.out     = state->out;
> @@ -312,18 +314,23 @@ unsigned int arpt_do_table(struct sk_buff *skb,
>  					verdict = (unsigned int)(-v) - 1;
>  					break;
>  				}
> -				e = back;
> -				back = get_entry(table_base, back->comefrom);
> +				if (stackidx == 0) {
> +					e = get_entry(table_base,
> +						      private->underflow[hook]);
> +				} else {
> +					e = jumpstack[--stackidx];
> +					e = arpt_next_entry(e);
> +				}
>  				continue;
>  			}
>  			if (table_base + v
>  			    != arpt_next_entry(e)) {
> -				/* Save old back ptr in next entry */
> -				struct arpt_entry *next = arpt_next_entry(e);
> -				next->comefrom = (void *)back - table_base;
>  
> -				/* set back pointer to next entry */
> -				back = next;
> +				if (WARN_ON_ONCE(stackidx >= private->stacksize)) {
> +					verdict = NF_DROP;
> +					break;
> +				}

I can see you're getting this in sync with iptables, but I wonder
about this defensive check to make sure we don't go over the allocated
jumpstack area. This was added in f3c5c1bfd43.

If we remove it and things are broken, then this will crash with a
general protection fault when accessing memory out of the jumpstack
boundary. On the other hand, if we keep it, packets will be dropped
and it will keep going until someone checks logs and reports this. If
we hit this then things are really broken so probably being a
agressive in this case makes sense.

Moreover, this is adds another branch in the packet path (not critical
in arptables, but we have in iptables too).

What do you think?

BTW, not related to this patch, Eric Dumazet indicated during the NFWS
that it would be a good idea to make this jumpstack fixed length as in
nftables, so we can place it in the stack and get rid of this percpu
jumpstack that was introduced to cope with reentrancy (only TEE needs
this). I've been checking this but we have no limits at this moment,
so the concerns go in the direction that if we limit this, we may
break some crazy setup with lots of jump to chain outthere. So I
suspect we cannot get rid of this easily :-(.
