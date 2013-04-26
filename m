From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netfilter: nfnetlink_queue: avoid peer_portid test
Date: Fri, 26 Apr 2013 03:19:33 +0200
Message-ID: <20130426011933.GA4427@localhost>
References: <1366383507-16633-1-git-send-email-fw@strlen.de>
 <1366383507-16633-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33162 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442Ab3DZBTi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:19:38 -0400
Content-Disposition: inline
In-Reply-To: <1366383507-16633-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Apr 19, 2013 at 04:58:24PM +0200, Florian Westphal wrote:
> The portid is the netlink port id of the skb that created the queue.
> 
> Add test to ensure the portid cannot be 0 at create time, and
> the check at enqueue time will always be false.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nfnetlink_queue_core.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> index 5e280b3..94e2e4f 100644
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -107,6 +107,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num,
>  	unsigned int h;
>  	int err;
>  
> +	if (portid == 0)
> +		return ERR_PTR(-EINVAL);

The instance_create function takes NETLINK_CB(skb).portid. IIRC,
netlink always sets that for us to non zero, so I think we would never
hit that error.

> +
>  	spin_lock(&q->instances_lock);
>  	if (instance_lookup(q, queue_num)) {
>  		err = -EEXIST;
> @@ -506,10 +509,6 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  	}
>  	spin_lock_bh(&queue->lock);
>  
> -	if (!queue->peer_portid) {
> -		err = -EINVAL;
> -		goto err_out_free_nskb;
> -	}

I'm trying to remember under what circunstances the queue portid can
be left unset, but I don't find any. Will check again this tomorrow
with fresh mind.

>  	if (queue->queue_total >= queue->queue_maxlen) {
>  		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
>  			failopen = 1;
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
