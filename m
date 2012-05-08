From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v2 PATCH 4/6] netfilter: Add fail-open support to handler
Date: Tue, 8 May 2012 13:58:55 +0200
Message-ID: <20120508115855.GB11952@1984>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
 <20120508094430.19531.28008.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, vivk@us.ibm.com, svajipay@in.ibm.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org, sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42215 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2EHL7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 07:59:11 -0400
Content-Disposition: inline
In-Reply-To: <20120508094430.19531.28008.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 08, 2012 at 03:14:30PM +0530, Krishna Kumar wrote:
> Change NFQUEUE handler to return >0 value on queue full
> to signify "fail-open".
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
> Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
> ---
>  net/netfilter/nfnetlink_queue.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
> --- org/net/netfilter/nfnetlink_queue.c	2012-05-08 12:57:39.225755227 +0530
> +++ new/net/netfilter/nfnetlink_queue.c	2012-05-08 12:57:55.515816567 +0530
> @@ -433,11 +433,16 @@ nfqnl_enqueue_packet(struct nf_queue_ent
>  		goto err_out_free_nskb;
>  	}
>  	if (queue->queue_total >= queue->queue_maxlen) {
> -		queue->queue_dropped++;
> -		if (net_ratelimit())
> -			  printk(KERN_WARNING "nf_queue: full at %d entries, "
> -				 "dropping packets(s).\n",
> -				 queue->queue_total);
> +		if (queue->fail_open) {
> +			/* Accept the packet temporarily skipping rules */
> +			err = 1;

Please, return -ENOSPC and handle this special case in nf_queue.

> +		} else {
> +			queue->queue_dropped++;
> +			if (net_ratelimit())
> +				  printk(KERN_WARNING "nf_queue: full at %d "
> +					 "entries, dropping packets(s).\n",
> +					 queue->queue_total);
> +		}
>  		goto err_out_free_nskb;
>  	}
>  	entry->id = ++queue->id_sequence;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
