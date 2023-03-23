Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C31C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 00:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCWAA0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 20:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCWAA0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 20:00:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9970393F3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 17:00:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pf8NR-0004s5-AX; Thu, 23 Mar 2023 01:00:21 +0100
Date:   Thu, 23 Mar 2023 01:00:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     eric_sage@apple.com
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@netfilter.org, pablo@netfilter.org
Subject: Re: [PATCH] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Message-ID: <20230323000021.GG4453@breakpoint.cc>
References: <20230322223329.48949-1-eric_sage@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322223329.48949-1-eric_sage@apple.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

eric_sage@apple.com <eric_sage@apple.com> wrote:
> From: Eric Sage <eric_sage@apple.com>
> 
> This enables associating a socket with a v1 net_cls cgroup. Useful for
> applying a per-cgroup policy when processing packets in userspace.
> 
> Signed-off-by: Eric Sage <eric_sage@apple.com>
> ---
>  .../uapi/linux/netfilter/nfnetlink_queue.h    |  4 ++-
>  net/netfilter/nfnetlink_queue.c               | 27 +++++++++++++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index ef7c97f21a15..9fbc8c49bd6d 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -62,6 +62,7 @@ enum nfqnl_attr_type {
>  	NFQA_VLAN,			/* nested attribute: packet vlan info */
>  	NFQA_L2HDR,			/* full L2 header */
>  	NFQA_PRIORITY,			/* skb->priority */
> +	NFQA_CLASSID,			/* __u32 cgroup classid */
>  
>  	__NFQA_MAX
>  };
> @@ -116,7 +117,8 @@ enum nfqnl_attr_config {
>  #define NFQA_CFG_F_GSO				(1 << 2)
>  #define NFQA_CFG_F_UID_GID			(1 << 3)
>  #define NFQA_CFG_F_SECCTX			(1 << 4)
> -#define NFQA_CFG_F_MAX				(1 << 5)
> +#define NFQA_CFG_F_CLASSID			(1 << 5)
> +#define NFQA_CFG_F_MAX				(1 << 6)
>  
>  /* flags for NFQA_SKB_INFO */
>  /* packet appears to have wrong checksums, but they are ok */
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 87a9009d5234..8c513a2e0e30 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -301,6 +301,25 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
>  	return -1;
>  }
>  
> +static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
> +{
> +	u32 classid;
> +
> +	if (!sk_fullsock(sk))
> +		return 0;
> +
> +	read_lock_bh(sk->sk_callback_lock);

I don't think there is a need for this lock here.

> +	if (nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
> +		goto nla_put_failure;
> +	read_unlock_bh(sk->sk_callback_lock);

I think this can be something like:

static int nfqnl_put_sk_classid(struct sk_buff *skb, const struct sock *sk)
{
#if CONFIG_CGROUP_NET_CLASSID
	if (sk && sk_fullsock(sk)) {
		u32 classid = htonl(sock_cgroup_classid(&sk->sk_cgrp_data);

		if (classid && nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
			return -1;
	}
#endif
	return 0;
}

> +	if (queue->flags & NFQA_CFG_F_CLASSID) {
> +		size += nla_total_size(sizeof(u_int32_t));	/* classid */
> +	}

Not sure its worth adding a new queue flag for this.  Uid and gid is a
bit of extra work but I'd guess that the sk deref isn't that noticeable compared
to the nfnetlink cost.

So probably just include the size unconditionally in the initial
calculation and then just:

	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
		goto nla_put_failure;

What do you think?

Other than that this seems fine.
