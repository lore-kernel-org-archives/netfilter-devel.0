From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nfnetlink_queue: only add CAP_LEN attr
 when needed
Date: Wed, 5 Jun 2013 04:37:39 +0200
Message-ID: <20130605023739.GA12748@localhost>
References: <1369821289-18574-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57500 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab3FEChq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:37:46 -0400
Content-Disposition: inline
In-Reply-To: <1369821289-18574-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, May 29, 2013 at 11:54:49AM +0200, Florian Westphal wrote:
> CAP_LEN contains the size of the network packet we're queueing to
> userspace, i.e. normally it is the same as the NFQA_PAYLOAD attribute length.
> 
> Include it only in the unlikely case when NFQA_PAYLOAD is truncated due
> to copy_range limitations.

Make sense to me, but...

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nfnetlink_queue_core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
>  Tested with examples/nf-queue.c from libnfqueue, it still
>  prints 'truncated packet' on 1st packet sent from tracepath.
> 
> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> index cff4449..49c149b 100644
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -40,6 +40,7 @@
>  #endif
>  
>  #define NFQNL_QMAX_DEFAULT 1024
> +#define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
>  
>  struct nfqnl_instance {
>  	struct hlist_node hlist;		/* global list of queues */
> @@ -122,7 +123,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num,
>  	inst->queue_num = queue_num;
>  	inst->peer_portid = portid;
>  	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
> -	inst->copy_range = 0xffff;
> +	inst->copy_range = NFQNL_MAX_COPY_RANGE;

Could you send me the NFQNL_MAX_COPY_RANGE cleanup and the small code
refactorization in one separated patch? By reading the description,
that does not belong here.

Thanks.

>  	inst->copy_mode = NFQNL_COPY_NONE;
>  	spin_lock_init(&inst->lock);
>  	INIT_LIST_HEAD(&inst->queue_list);
> @@ -333,10 +334,9 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  			return NULL;
>  
>  		data_len = ACCESS_ONCE(queue->copy_range);
> -		if (data_len == 0 || data_len > entskb->len)
> +		if (data_len > entskb->len)
>  			data_len = entskb->len;
>  
> -
>  		if (!entskb->head_frag ||
>  		    skb_headlen(entskb) < L1_CACHE_BYTES ||
>  		    skb_shinfo(entskb)->nr_frags >= MAX_SKB_FRAGS)
> @@ -465,7 +465,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
>  		goto nla_put_failure;
>  
> -	if (cap_len > 0 && nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
> +	if (cap_len > data_len &&
> +	    nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
>  		goto nla_put_failure;
>  
>  	if (nfqnl_put_packet_info(skb, entskb))
> @@ -732,8 +733,8 @@ nfqnl_set_mode(struct nfqnl_instance *queue,
>  		 * length that we support is 65531 bytes. We send truncated
>  		 * packets if the specified length is larger than that.
>  		 */
> -		if (range > 0xffff - NLA_HDRLEN)
> -			queue->copy_range = 0xffff - NLA_HDRLEN;
> +		if (range == 0 || range > NFQNL_MAX_COPY_RANGE)
> +			queue->copy_range = NFQNL_MAX_COPY_RANGE;
>  		else
>  			queue->copy_range = range;
>  		break;
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
