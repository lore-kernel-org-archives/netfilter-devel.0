From: Florian Westphal <fw@strlen.de>
Subject: Re: [v3 PATCH 1/1] netfilter: Add fail-open support.
Date: Tue, 22 May 2012 16:38:58 +0200
Message-ID: <20120522143858.GB14029@breakpoint.cc>
References: <20120522121037.880.44203.sendpatchset@localhost.localdomain>
 <20120522121048.880.22605.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, pablo@netfilter.org, vivk@us.ibm.com,
	svajipay@in.ibm.com, fw@strlen.de, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55833 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab2EVOjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 10:39:12 -0400
Content-Disposition: inline
In-Reply-To: <20120522121048.880.22605.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar <krkumar2@in.ibm.com> wrote:
> Implement a new "fail-open" mode where packets are not dropped
> upon queue-full condition. This mode can be individually enabled
> or disabled per queue using netlink NFAQ_CFG_FLAGS & NFAQ_CFG_MASK
> attributes.
> 
>  	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
> +	NFQA_CFG_MASK,			/* identify which flags to change */
> +	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */

__be32?
I see that QUEUE_MAXLEN gets ntohl treatment, too....

>  	__NFQA_CFG_MAX
>  };
>  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
>  
> +/* Flags for NFQA_CFG_FLAGS */
> +#define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
> +
>  #endif /* _NFNETLINK_QUEUE_H */
> diff -ruNp org/net/netfilter/core.c new/net/netfilter/core.c
> --- org/net/netfilter/core.c	2012-05-22 08:45:32.651608253 +0530
> +++ new/net/netfilter/core.c	2012-05-22 17:35:51.294216873 +0530
> @@ -163,6 +163,31 @@ repeat:
>  	return NF_ACCEPT;
>  }
>  
> +/*
> + * Handler was not able to enqueue the packet, and returned ENOSPC
> + * since "fail-open" was enabled. We temporarily accept the skb, or
> + * each segment for a segmented skb, and then free up the header.
> + */
> +static void handle_fail_open(struct sk_buff *skb,
> +			     int (*okfn)(struct sk_buff *))
> +{
> +	struct sk_buff *segs;
> +	bool gso;
> +
> +	segs = skb->next ? : skb;
> +	gso = skb->next != NULL;
> +
> +	do {
> +		struct sk_buff *nskb = segs->next;
> +
> +		segs->next = NULL;
> +		okfn(segs);
> +		segs = nskb;
> +	} while (segs);
> +
> +	if (gso)
> +		kfree_skb(skb);
> +}

I don't understand why this is needed at all.
Conceptually, what you're doing is identical to the
--nfqueue-bypass feature, so it should be enough to change

> @@ -199,10 +226,18 @@ next_hook:
>  			if (err == -ESRCH &&
>  			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
>  				goto next_hook;
> +			if (err == -ENOSPC) {
> +				failopen = 1;
> +				goto next_hook;
> +			}
>  			kfree_skb(skb);

to

 if (err == -ENOSPC || (err == -ESRCH && (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
  	goto next_hook;

[ or, take advantage of the existing -ECANCELED and have the queueing
  backend return that if queue is full and fail-open is enabled ]

Yes, that means that if the userspace ruleset is
-j NFQUEUE
-j DROP

then your packets will be dropped even if the userspace application
enables failopen.

But thats a feature, since you could also do
-j NFQUEUE
-m limt ... -j LOG --log-prefix "queue overflow"

or play extra games wrt. "drop if established, CONNMARK
for future bypass if --ctstate NEW", etc.

If its a requirment for you that userspace can force ACCEPT
regardless of ruleset, then perhaps it might be better to
add a separate "default verdict" option and invoke
nf_reinject() directly from the qeueueing backend instead
of passing the fail-open information back to nf_hook_slow?

> +		flags = nla_data(nfqa[NFQA_CFG_FLAGS]);
> +		mask = nla_data(nfqa[NFQA_CFG_MASK]);

nla_get_be32()?
[ _u32 would make more sense to me, but other attributes are be32 too,
  so I'm ok with it ]

> -		if (err == 0)
> +
> +		if (err == 0) {
>  			queued++;
> -		else
> +		} else if (err == -ENOSPC) {
> +			/* Queue failed due to queue-full and handler is
> +			 * in "fail-open" mode.
> +			 */
> +			segs->next = nskb;
> +			skb->next = segs;
> +			break;
> +		} else {
>  			kfree_skb(segs);
> +		}
>  		segs = nskb;
>  	} while (segs);
>  
> -	if (queued) {
> +	if (queued && err != -ENOSPC) {
>  		kfree_skb(skb);
>  		return 0;
>  	}

Similarily, this shouldn't be needed either any more since you
no longer need to check for -ENOSPC (existing --queue-bypass behaviour
should handle your case, too).
