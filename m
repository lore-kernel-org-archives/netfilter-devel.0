From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Wed, 27 May 2015 13:12:42 +0200
Message-ID: <5565A6AA.90908@samsung.com>
References: <5562F661.5000503@samsung.com> <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com> <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com> <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16445 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbE0LMp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:12:45 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP0005SS9T7C0A0@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 27 May 2015 12:12:43 +0100 (BST)
In-reply-to: <5565A4D2.70701@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think i forgot to mention one important thing the function:
security_sk_getsecid
is not in the kernel yet, i posted a patch to add it on the linux-security-module mailing list:
http://marc.info/?t=143254934900006&r=1&w=2

It actually does not do anything it's a definition only, the actual code belong to the currently
active LSM in the kernel.

On 05/27/2015 01:04 PM, Roman Kubiak wrote:
> I removed the part where i was adding NULL, i also changed as per suggestions and slightly
> streamlined the code.
> 
> 
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
> +
> +	read_lock_bh(&sk->sk_callback_lock);
> +	security_sk_getsecid(sk, &secid);
> +
> +	if (secid && security_secid_to_secctx(secid, secdata, &seclen))
> +		seclen = 0;
> +
> +	read_unlock_bh(&sk->sk_callback_lock);
> +	return seclen;
> +}
> +
>  static struct sk_buff *
>  nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  			   struct nf_queue_entry *entry,
> @@ -297,6 +315,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	struct nf_conn *ct = NULL;
>  	enum ip_conntrack_info uninitialized_var(ctinfo);
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
> +		seclen = nfqnl_get_sk_secctx(entskb->sk, &secdata);
> +		if (seclen)
> +			size += nla_total_size(seclen);
> +	}
> +
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
>  	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
>  		goto nla_put_failure;
>  
> 

-- 
--------------
 Roman Kubiak
--------------
