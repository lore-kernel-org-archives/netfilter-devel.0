From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Thu, 13 Oct 2016 14:38:21 +0200
Message-ID: <20161013123821.GC14002@breakpoint.cc>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753673AbcJMMjS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:39:18 -0400
Content-Disposition: inline
In-Reply-To: <1476360171-2991-9-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Export a new nf_queue() function that translates the NF_QUEUE verdict
> depending on the scenario:
> 
> 1) Drop packet if queue is full.
> 2) Accept packet if bypass is enabled.
> 3) Return stolen if packet is enqueued.
> 
> We can call this function from xt_NFQUEUE and nft_queue. Thus, we
> move packet queuing to userspace away from the core path.
> 
> We still have to handle the old QUEUE standard target for
> {ip,ip6}_tables, which points to queue number zero. Just in case we
> still have any user relying on this behaviour. No need to handle this
> from arp and ebtables, they never got a native queue target.
> 
> After this patch, we have to inconditionally set state->hook_entries
> before calling the hook since nf_iterate() since we need this to know
> from what hook the packet is escaping to userspace in nf_queue.
> 
> From nft_verdict_init(), disallow NF_QUEUE as verdict since we always
> use the nft_queue expression for this and we don't have any userspace
> code using this since the beginning.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_queue.h |  3 +++
>  net/ipv4/netfilter/arp_tables.c  |  1 +
>  net/ipv4/netfilter/ip_tables.c   |  4 ++++
>  net/ipv6/netfilter/ip6_tables.c  |  4 ++++
>  net/netfilter/core.c             | 14 ++---------
>  net/netfilter/nf_internals.h     |  2 --
>  net/netfilter/nf_queue.c         | 51 ++++++++++++++++++++++++++--------------
>  net/netfilter/nf_tables_api.c    |  3 +--
>  net/netfilter/nf_tables_core.c   |  3 +--
>  net/netfilter/nft_queue.c        |  6 ++---
>  net/netfilter/xt_NFQUEUE.c       | 29 ++++++++++++-----------
>  11 files changed, 67 insertions(+), 53 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index 2280cfe86c56..807b9de72b43 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -29,6 +29,9 @@ struct nf_queue_handler {
>  
>  void nf_register_queue_handler(struct net *net, const struct nf_queue_handler *qh);
>  void nf_unregister_queue_handler(struct net *net);
> +
> +int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
> +	     unsigned int queuenum, bool bypass);
>  void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
>  
>  void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index e76ab23a2deb..83d82f6be8dd 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -28,6 +28,7 @@
>  
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter_arp/arp_tables.h>
> +#include <net/netfilter/nf_queue.h>
>  #include "../../netfilter/xt_repldata.h"
>  
>  MODULE_LICENSE("GPL");

This include looks unneeded.

> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index de4fa03f46f3..7040842c34f4 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -29,6 +29,7 @@
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter_ipv4/ip_tables.h>
>  #include <net/netfilter/nf_log.h>
> +#include <net/netfilter/nf_queue.h>
>  #include "../../netfilter/xt_repldata.h"
>  
>  MODULE_LICENSE("GPL");
> @@ -329,6 +330,9 @@ ipt_do_table(struct sk_buff *skb,
>  				/* Pop from stack? */
>  				if (v != XT_RETURN) {
>  					verdict = (unsigned int)(-v) - 1;
> +					if (verdict == NF_QUEUE)
> +						verdict = nf_queue(skb, state,
> +								   0, false);

Any reason why this is needed?
AFAICS xt_NFQUEUE will never return NF_QUEUE after this patch.

> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 2b3b2f8e39c4..9ae2febd86e3 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -309,6 +309,7 @@ unsigned int nf_iterate(struct sk_buff *skb,
>  	unsigned int verdict;
>  
>  	while (*entryp) {
> +		RCU_INIT_POINTER(state->hook_entries, *entryp);
>  repeat:
>  		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
>  		if (verdict != NF_ACCEPT) {
> @@ -331,9 +332,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
>  	int ret;
>  
>  	entry = rcu_dereference(state->hook_entries);
> -next_hook:
>  	verdict = nf_iterate(skb, state, &entry);
> -	switch (verdict & NF_VERDICT_MASK) {
> +	switch (verdict) {

This looks buggy, verdict might encode errno for NF_DROP case.

What you could do is:

switch (verdict) {
case NF_ACCEPT:
       	/* something */
	break;
case NF_STOLEN:
	break;
case NF_DROP: /* fallthrough */
default: /* drop with error? */
	kfree_skb(skb);
	errno = ...
}

