From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: bridge: pass L2 header and
 VLAN as netlink attributes in queues to userspace
Date: Mon, 15 Feb 2016 20:45:37 +0100
Message-ID: <20160215194537.GA8411@salvia>
References: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455202396-5334-3-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: stephane.ml.bryant@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57277 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbcBOTpl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2016 14:45:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 262E26C06
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:45:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1513133B1
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:45:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E76291DD
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:45:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1455202396-5334-3-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2016 at 03:53:16PM +0100, stephane.ml.bryant@gmail.com wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> -this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
> -these are filled up for the PF_BRIDGE family on the way to userspace, and
>  used on the way back to modify the original skb accordingly
> 
> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_queue.h |   7 ++
>  net/netfilter/nfnetlink_queue.c                | 130 ++++++++++++++++++++++++-
>  2 files changed, 132 insertions(+), 5 deletions(-)
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

I'd rather use nested attributes instead of passing structures through
netlink.

I'm aware we're using structure in the existing code, that decision
was made long time ago and we cannot change it. But as I said for new
code I'd rather see nested attributes. See nla_nest_start and nla_nest_end.

Thanks.
