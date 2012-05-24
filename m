From: Florian Westphal <fw@strlen.de>
Subject: Re: [v4 PATCH 1/1] netfilter: Add fail-open support
Date: Thu, 24 May 2012 11:30:43 +0200
Message-ID: <20120524093043.GA30569@breakpoint.cc>
References: <20120524082518.13146.25740.sendpatchset@localhost.localdomain>
 <20120524082531.13146.347.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, pablo@netfilter.org, vivk@us.ibm.com,
	svajipay@in.ibm.com, fw@strlen.de, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59771 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab2EXJav (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 05:30:51 -0400
Content-Disposition: inline
In-Reply-To: <20120524082531.13146.347.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar <krkumar2@in.ibm.com> wrote:
> diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
> --- org/net/netfilter/nfnetlink_queue.c	2012-05-23 09:52:54.742661899 +0530
> +++ new/net/netfilter/nfnetlink_queue.c	2012-05-24 13:42:24.155860334 +0530
> @@ -52,6 +52,7 @@ struct nfqnl_instance {
>  
>  	u_int16_t queue_num;			/* number of this queue */
>  	u_int8_t copy_mode;
> +	u_int32_t flags;			/* Set using NFQA_CFG_FLAGS */
>  /*
>   * Following fields are dirtied for each queued packet,
>   * keep them in same cache line if possible.
> @@ -431,9 +432,13 @@ nfqnl_enqueue_packet(struct nf_queue_ent
>  		goto err_out_free_nskb;
>  	}
>  	if (queue->queue_total >= queue->queue_maxlen) {
> -		queue->queue_dropped++;
> -		net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
> -				     queue->queue_total);
> +		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
> +			err = -ENOSPC;
> +		} else {
> +			queue->queue_dropped++;
> +			net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
> +					     queue->queue_total);
> +		}
>  		goto err_out_free_nskb;

What about this:

if (queue->queue_total >= queue->queue_maxlen) {
	if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
		nf_reinject(entry, NF_ACCEPT);
		err = 0;
		goto err_out_free_nskb;
	}
	queue->queue_dropped++;
	net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",

[..]

Do you see any problems with that?

It should do the same as the nf_hook_slow/nf_queue ENOSPC changes while
avoiding modifications outside the queueing backend.

> +	if (nfqa[NFQA_CFG_FLAGS]) {
> +		__be32 flags, mask;

[..]

> +		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
> +		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));

ntohl returns __u32 type.

Thanks,
Florian
