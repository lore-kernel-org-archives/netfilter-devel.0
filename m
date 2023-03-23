Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20F2C74A5B
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 17:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCWRyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCWRyx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 13:54:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18352AF07
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 10:54:52 -0700 (PDT)
Date:   Thu, 23 Mar 2023 18:54:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Sage <eric_sage@apple.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, kadlec@netfilter.org
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: enable classid socket
 info retrieval
Message-ID: <ZBySaeEHInfDbdlt@salvia>
References: <20230323172321.33955-1-eric_sage@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230323172321.33955-1-eric_sage@apple.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 23, 2023 at 01:23:22PM -0400, Eric Sage wrote:
> This enables associating a socket with a v1 net_cls cgroup. Useful for
> applying a per-cgroup policy when processing packets in userspace.
> 
> Signed-off-by: Eric Sage <eric_sage@apple.com>
> ---
> v2
> - Remove classid flag, always include with NET_CLASSID.
> - Include cgroup-defs header.
> - Remove lock.
> 
>  .../uapi/linux/netfilter/nfnetlink_queue.h    |  1 +
>  net/netfilter/nfnetlink_queue.c               | 20 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index ef7c97f21a15..12f4eda93758 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -62,6 +62,7 @@ enum nfqnl_attr_type {
>  	NFQA_VLAN,			/* nested attribute: packet vlan info */
>  	NFQA_L2HDR,			/* full L2 header */
>  	NFQA_PRIORITY,			/* skb->priority */
> +	NFQA_CLASSID,			/* __u32 cgroup classid */
        NFAQ_CGROUP_CLASSID,

Nitpick, probably NFQA_CGROUP_CLASSID or too long?

there is classid in tc (actually contained in skb->priority), it might
be confusing.

>  	__NFQA_MAX
>  };
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 87a9009d5234..b0c12aa3e9b0 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -29,6 +29,7 @@
>  #include <linux/netfilter/nfnetlink_queue.h>
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/list.h>
> +#include <linux/cgroup-defs.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h>
>  #include <net/netfilter/nf_queue.h>
> @@ -301,6 +302,19 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
>  	return -1;
>  }
>  
> +static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
> +{
> +#if IS_BUILTIN(CONFIG_CGROUP_NET_CLASSID)

#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)

it seems CONFIG_CGROUP_NET_CLASSID is tristate.

> +	if (sk && sk_fullsock(sk)) {
> +		u32 classid = sock_cgroup_classid(&sk->sk_cgrp_data);
> +
> +		if (classid && nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
> +			return -1;
> +	}
> +#endif
> +	return 0;
> +}
> +
>  static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>  {
>  	u32 seclen = 0;
> @@ -407,6 +421,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
>  		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
>  		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
> +#if IS_BUILTIN(CONFIG_CGROUP_NET_CLASSID)

Same here.

> +		+ nla_total_size(sizeof(u_int32_t));	/* classid */
> +#endif
>  
>  	tstamp = skb_tstamp_cond(entskb, false);
>  	if (tstamp)
> @@ -599,6 +616,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
>  		goto nla_put_failure;
>  
> +	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
> +		goto nla_put_failure;
> +
>  	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
>  		goto nla_put_failure;
>  
> -- 
> 2.37.1
> 
