From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Wed, 27 May 2015 13:48:10 +0200
Message-ID: <20150527114810.GB23992@breakpoint.cc>
References: <5562F661.5000503@samsung.com>
 <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com>
 <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45661 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbbE0LsN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:48:13 -0400
Content-Disposition: inline
In-Reply-To: <5565A4D2.70701@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> This patch adds an additional attribute when sending
> packet information via netlink in netfilter_queue module.
> It will send additional security context data, so that
> userspace applications can verify this context against
> their own security databases.
> 
> Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
> ---
> v2:
> - nfqnl_get_sk_secctx returns seclen now, this changes
> - updated size calculation
> - changed NFQA_SECCTX comment
> - removed duplicate testing of NFQA_CFG_F flags
> 
> v3:
> - NULL is not added to the security context anymore
> - return 0 when socket is invalid in nfqnl_get_sk_secctx
> - small intent change
> - removed ret variable in nfqnl_get_sk_secctx
> ---
>  include/uapi/linux/netfilter/nfnetlink_queue.h |  4 +++-
>  net/netfilter/nfnetlink_queue_core.c           | 31 ++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index 8dd819e..b67a853 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
> +	NFQA_SECCTX,			/* security context string */
>  
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
> index 0b98c74..ae4f520 100644
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -278,6 +278,24 @@ nla_put_failure:
>  	return -1;
>  }
>  
> +static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
> +{
> +	u32 secid = 0;
> +	u32 seclen = 0;
> +
> +	if (!sk || !sk_fullsock(sk))
> +		return 0;

if (!sk) is not needed anymore

>  	bool csum_verify;
> +	char *secdata = NULL;
> +	u32 seclen = 0;
>  
>  	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
>  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> @@ -352,6 +372,12 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
>  	}
>  
> +	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {

... or remove entskb->sk test here (I have no preference where
you test this, either caller or callee is fine with me).

>  	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
>  				  GFP_ATOMIC);
>  	if (!skb) {
> @@ -479,6 +505,11 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
>  		goto nla_put_failure;
>  
> +	if (seclen) {
> +		if (nla_put(skb, NFQA_SECCTX, seclen, secdata))
> +			goto nla_put_failure;
> +	}
> +

Nit: can be written as

	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
		goto nla_put_failure;

Otherwise I think this looks good.  Please consider sending v4 _after_
security_sk_getsecid situation is resolved.

It would be good to note in the --- section in case there is a
dependency; we always want to avoid "it won't build (without change
x from tree y)."

Thanks.
