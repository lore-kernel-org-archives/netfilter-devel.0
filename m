From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Security context information added to netfilter_queue
Date: Mon, 25 May 2015 15:13:19 +0200
Message-ID: <20150525131319.GA3529@salvia>
References: <5562F661.5000503@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbbEYNI0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 09:08:26 -0400
Content-Disposition: inline
In-Reply-To: <5562F661.5000503@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 25, 2015 at 12:16:01PM +0200, Roman Kubiak wrote:
> From dccc2ca387d7b4dd16fff537ce2cab280517cab5 Mon Sep 17 00:00:00 2001
> From: Roman Kubiak <r.kubiak@samsung.com>
> Date: Wed, 22 Apr 2015 15:54:20 +0200
> Subject: [PATCH] Security context information added to netfilter_queue
> 
> This patch adds an additional attribute when sending
> packet information via netlink in netfilter_queue module.
> It will send additional security context data, so that
> userspace applications can verify this context against
> their own security databases.

Please prepend the subsystem prefix to the patch title, ie.

        netfilter: nfnetlink_queue: Add security context information

A couple of minor comments on top of Florian's.

> Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_queue.h |  4 ++-
>  net/netfilter/nfnetlink_queue_core.c           | 46 ++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index 8dd819e..313935a 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
> +	NFQA_SECCTX,			/* security context, NL_A_STRING */

I'd suggest for this comment.

/* security context string */

>  	__NFQA_MAX
>  };
> @@ -102,7 +103,8 @@ enum nfqnl_attr_config {
>  #define NFQA_CFG_F_CONNTRACK			(1 << 1)
>  #define NFQA_CFG_F_GSO				(1 << 2)
>  #define NFQA_CFG_F_UID_GID			(1 << 3)
> -#define NFQA_CFG_F_MAX				(1 << 4)
> +#define NFQA_CFG_F_SECCTX			(1 << 4)
> +#define NFQA_CFG_F_MAX				(1 << 5)
>  
>  /* flags for NFQA_SKB_INFO */
>  /* packet appears to have wrong checksums, but they are ok */
> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> index 0b98c74..de3b97a 100644
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -278,6 +278,27 @@ nla_put_failure:
>  	return -1;
>  }
>  
> +static int nfqnl_get_sk_secctx(struct sock *sk, char **secdata, u32 *seclen)
> +{
> +	u32 secid = 0;
> +	int ret = -1;
> +
> +	if (!sk)
> +		return ret;
> +
> +	if (!sk_fullsock(sk))
> +		return ret;

you can collapse these two if's:

        if (!sk || !sk_fullsock(sk))
