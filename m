Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2450C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 18:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D108861279
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 18:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGEShP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 14:37:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48522 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGEShP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 14:37:15 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 744A961653;
        Mon,  5 Jul 2021 20:34:27 +0200 (CEST)
Date:   Mon, 5 Jul 2021 20:34:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] include: fix header file name in 3 comments
Message-ID: <20210705183435.GA10889@salvia>
References: <20210705123829.10090-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210705123829.10090-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please, add description to this patch, even one line should be fine,
e.g.

 nf_conntrack_netlink.h does not exist, refer to nfnetlink_netlink.h
 instead.

I suggest a more specific subject, such as:

 netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h

Apart from these nitpicks, patch LGTM.

net-next is still closed (so it is nf-next too), but I'll keep this
patch in patchwork until it opens up again.

Please revamp and send v2, thanks.

On Mon, Jul 05, 2021 at 10:38:29PM +1000, Duncan Roe wrote:
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  include/uapi/linux/netfilter/nfnetlink_log.h   | 2 +-
>  include/uapi/linux/netfilter/nfnetlink_queue.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
> index 45c8d3b027e0..0af9c113d665 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_log.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_log.h
> @@ -61,7 +61,7 @@ enum nfulnl_attr_type {
>  	NFULA_HWTYPE,			/* hardware type */
>  	NFULA_HWHEADER,			/* hardware header */
>  	NFULA_HWLEN,			/* hardware header length */
> -	NFULA_CT,                       /* nf_conntrack_netlink.h */
> +	NFULA_CT,                       /* nfnetlink_conntrack.h */
>  	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
>  	NFULA_VLAN,			/* nested attribute: packet vlan info */
>  	NFULA_L2HDR,			/* full L2 header */
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index bcb2cb5d40b9..aed90c4df0c8 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -51,11 +51,11 @@ enum nfqnl_attr_type {
>  	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
>  	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
>  	NFQA_PAYLOAD,			/* opaque data payload */
> -	NFQA_CT,			/* nf_conntrack_netlink.h */
> +	NFQA_CT,			/* nfnetlink_conntrack.h */
>  	NFQA_CT_INFO,			/* enum ip_conntrack_info */
>  	NFQA_CAP_LEN,			/* __u32 length of captured packet */
>  	NFQA_SKB_INFO,			/* __u32 skb meta information */
> -	NFQA_EXP,			/* nf_conntrack_netlink.h */
> +	NFQA_EXP,			/* nfnetlink_conntrack.h */
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
>  	NFQA_SECCTX,			/* security context string */
> -- 
> 2.17.5
> 
