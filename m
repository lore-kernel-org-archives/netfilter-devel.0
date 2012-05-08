From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v2 PATCH 5/6] netfilter: GSO packet handling
Date: Tue, 8 May 2012 14:28:28 +0200
Message-ID: <20120508122828.GA12801@1984>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
 <20120508094442.19531.56563.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, vivk@us.ibm.com, svajipay@in.ibm.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org, sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50618 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2EHM2b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 08:28:31 -0400
Content-Disposition: inline
In-Reply-To: <20120508094442.19531.56563.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 08, 2012 at 03:14:42PM +0530, Krishna Kumar wrote:
> Handle >0 return value from outfn in __nf_queue(). This value
> is not passed up the stack but intercepted by nf_queue(), which
> returns 0 to upper layers.
> 
> Also add support for GSO skb. If __nf_queue() returns >0 to
> indicate fail-open, we call okfn() immediately.
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
> Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
> ---
>  net/netfilter/nf_queue.c |   33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff -ruNp org/net/netfilter/nf_queue.c new/net/netfilter/nf_queue.c
> --- org/net/netfilter/nf_queue.c	2012-05-08 13:02:18.163816400 +0530
> +++ new/net/netfilter/nf_queue.c	2012-05-08 15:08:11.028555335 +0530
> @@ -189,7 +189,7 @@ static int __nf_queue(struct sk_buff *sk
>  
>  	rcu_read_unlock();
>  
> -	if (status < 0) {
> +	if (status) {
>  		nf_queue_entry_release_refs(entry);
>  		goto err;
>  	}
> @@ -236,9 +236,18 @@ int nf_queue(struct sk_buff *skb,
>  	int err = -EINVAL;
>  	unsigned int queued;
>  
> -	if (!skb_is_gso(skb))
> -		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> +	if (!skb_is_gso(skb)) {
> +		err = __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
>  				  queuenum);
> +		if (err > 0) {
> +			/* Queue failed due to queue-full and handler
> +			 * returned >0 indicating fail-open - temporarily
> +			 * accept packets.
> +			 */
> +			err = okfn(skb);

You cannot invoke okfn here. If you do so, you'll skip the remaining
hooks.

Return the error and handle the -ENOSPC in nf_hook_slow.

(Note that the -ENOSPC is the error value I'm proposing you to use for
this special case).

> +		}
> +		return err;
> +	}
>  
>  	switch (pf) {
>  	case NFPROTO_IPV4:
> @@ -268,14 +277,26 @@ int nf_queue(struct sk_buff *skb,
>  			err = __nf_queue(segs, elem, pf, hook, indev,
>  					   outdev, okfn, queuenum);
>  		}
> -		if (err == 0)
> +
> +		if (err == 0) {
>  			queued++;
> -		else
> +		} else if (err > 0) {
> +			/* Queue failed due to queue-full and handler
> +			 * returned >0 indicating fail-open - accept
> +			 * this and remaining segments.
> +			 */
> +			okfn(segs);
> +		} else {
> +			/* Queue failed due to queue-full and handler
> +			 * returned <0 - free this and remaining skb
> +			 * segments.
> +			 */
>  			kfree_skb(segs);
> +		}
>  		segs = nskb;
>  	} while (segs);
>  
> -	if (queued) {
> +	if (queued || err > 0) {
>  		kfree_skb(skb);
>  		return 0;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
