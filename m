From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 2/3] netfilter: bridge: pass L2 header and
 VLAN as netlink attributes in queues to userspace
Date: Mon, 29 Feb 2016 13:40:32 +0100
Message-ID: <20160229124032.GA15467@salvia>
References: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455959230-3680-2-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcB2Mkp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:40:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 715084B9E5
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:40:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 56F9EDA8F8
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:40:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBB23DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:40:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1455959230-3680-2-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 20, 2016 at 10:07:09AM +0100, Stephane Bryant wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> -this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
> -these are filled up for the PF_BRIDGE family on the way to userspace
> 
> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_queue.h |  7 ++++
>  net/netfilter/nfnetlink_queue.c                | 53 ++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
> index b67a853..211fcdc 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -30,6 +30,11 @@ struct nfqnl_msg_packet_timestamp {
>  	__aligned_be64	usec;
>  };
>  
> +struct nfqnl_msg_vlan {
> +	__be16                  proto;
> +	__u16                   tci;
> +} __attribute__ ((packed));

Stephane, I'm very looking forward to having this update pushed
mainstream.

However, this I think it would be good if you can translate this to
use nested attributes.

See nla_nest_start() and nla_nest_end(). Then, add a new vlan
attributes for this:

        enum nfqnl_vlan_attr {
                NFQA_VLAN_UNSPEC,
                NFQA_VLAN_PROTO,
                NFQA_VLAN_TCI,
                __NFQA_VLAN_MAX,
        };
        #define NFQA_VLAN_MAX   (__NFQA_VLAN_MAX + 1)

Using structure to encapsulate netlink data is highly discouraged. I
know we're doing this already in old attribute but that we cannot
change since it's part of the ABI. But I would like that we start
doing this the right way for new attributes.

Let me know,
Thanks!

> +
>  enum nfqnl_attr_type {
>  	NFQA_UNSPEC,
>  	NFQA_PACKET_HDR,
> @@ -50,6 +55,8 @@ enum nfqnl_attr_type {
>  	NFQA_UID,			/* __u32 sk uid */
>  	NFQA_GID,			/* __u32 sk gid */
>  	NFQA_SECCTX,			/* security context string */
> +	NFQA_VLAN,                      /* packet vlan info */
> +	NFQA_L2HDR,                     /* full L2 header */
>  
>  	__NFQA_MAX
>  };
