From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] [PATCH] netfilter: nfnetlink_queue: Don't set random
 flag bits
Date: Wed, 4 Jul 2012 22:57:29 +0200
Message-ID: <20120704205729.GB22228@1984>
References: <20120627105956.26473.95573.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36995 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab2GDU5b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:57:31 -0400
Content-Disposition: inline
In-Reply-To: <20120627105956.26473.95573.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 27, 2012 at 04:29:56PM +0530, Krishna Kumar wrote:
> Allow setting of only supported flag bits in queue->flags.

I have applied this with minor glitches, see below.

> If this is OK, I can send a patch to add this flag to
> libnetfilter_queue too.

Not sure what you mean with the patch for libnetfilter_queue. If you
consider adding some checking in user-space, no need to do it. We have
to fail back on the kernel to report this. So we don't need to update
libnetfilter_queue if we get new flags supported.

Back to your patch...

> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> ---
>  include/linux/netfilter/nfnetlink_queue.h |    2 ++
>  net/netfilter/nfnetlink_queue_core.c      |    6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
> --- org/include/linux/netfilter/nfnetlink_queue.h	2012-06-18 08:36:53.000000000 +0530
> +++ new/include/linux/netfilter/nfnetlink_queue.h	2012-06-27 16:25:54.297619352 +0530
> @@ -96,4 +96,6 @@ enum nfqnl_attr_config {
>  #define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
>  #define NFQA_CFG_F_CONNTRACK			(1 << 1)
>  

removed this extra space above.

> +#define NFQA_CFG_F_FLAGS_MAX			(1 << 2)

removed _FLAGS, it seems redundant to _F.

> +
>  #endif /* _NFNETLINK_QUEUE_H */
> diff -ruNp org/net/netfilter/nfnetlink_queue_core.c new/net/netfilter/nfnetlink_queue_core.c
> --- org/net/netfilter/nfnetlink_queue_core.c	2012-06-27 12:34:02.000000000 +0530
> +++ new/net/netfilter/nfnetlink_queue_core.c	2012-06-27 14:00:46.153670918 +0530
> @@ -910,6 +910,12 @@ nfqnl_recv_config(struct sock *ctnl, str
>  		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
>  		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
>  
> +		if (flags >= NFQA_CFG_F_FLAGS_MAX) {
> +			/* flags has more bits than what is supported */

removed this comment, I think it's more or less evinder to the source
code reader what this does.

> +			ret = -EOPNOTSUPP;
> +			goto err_out_unlock;
> +		}
> +
>  		spin_lock_bh(&queue->lock);
>  		queue->flags &= ~mask;
>  		queue->flags |= flags & mask;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
