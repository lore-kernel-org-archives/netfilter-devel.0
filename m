From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_queue: Implement API to set per-queue
 flags
Date: Sat, 14 Jul 2012 16:01:51 +0200
Message-ID: <20120714140151.GA2392@1984>
References: <20120606105900.32466.56533.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, kaber@trash.net, vivk@us.ibm.com,
	svajipay@in.ibm.com, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48519 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2GNOBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:01:53 -0400
Content-Disposition: inline
In-Reply-To: <20120606105900.32466.56533.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 06, 2012 at 04:29:00PM +0530, Krishna Kumar wrote:
> Implement API to set per-queue flags. This is initially used
> to implement fail-open support in NFQUEUE.

Applied with minor spots (see below), thanks.

> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h    |    3 
>  include/libnetfilter_queue/linux_nfnetlink_queue.h |    5 +
>  src/libnetfilter_queue.c                           |   42 +++++++++++
>  3 files changed, 50 insertions(+)
> 
> diff -ruNp org/include/libnetfilter_queue/libnetfilter_queue.h new/include/libnetfilter_queue/libnetfilter_queue.h
> --- org/include/libnetfilter_queue/libnetfilter_queue.h	2012-06-06 10:07:21.863540677 +0530
> +++ new/include/libnetfilter_queue/libnetfilter_queue.h	2012-06-06 10:08:17.629962800 +0530
> @@ -56,6 +56,9 @@ extern int nfq_set_mode(struct nfq_q_han
>  int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
>  			u_int32_t queuelen);
>  
> +extern int nfq_set_queue_flags(struct nfq_q_handle *qh,
> +			       uint32_t mask, uint32_t flags);
> +
>  extern int nfq_set_verdict(struct nfq_q_handle *qh,
>  			     u_int32_t id,
>  			     u_int32_t verdict,
> diff -ruNp org/include/libnetfilter_queue/linux_nfnetlink_queue.h new/include/libnetfilter_queue/linux_nfnetlink_queue.h
> --- org/include/libnetfilter_queue/linux_nfnetlink_queue.h	2012-06-06 10:07:21.874538295 +0530
> +++ new/include/libnetfilter_queue/linux_nfnetlink_queue.h	2012-06-06 15:41:51.912636134 +0530
> @@ -87,8 +87,13 @@ enum nfqnl_attr_config {
>  	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
>  	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
>  	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
> +	NFQA_CFG_MASK,			/* identify which flags to change */
> +	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
>  	__NFQA_CFG_MAX
>  };
>  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
>  
> +/* Flags/options for NFQA_CFG_FLAGS */
> +#define NFQA_CFG_F_FAIL_OPEN		(1 << 0)

added NFQA_CFG_F_CONNTRACK and _MAX.

I've also bumped LIBVERSION.
