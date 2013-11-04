From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: introduce l2tp match extension
Date: Mon, 4 Nov 2013 16:49:13 +0000
Message-ID: <20131104164912.GA4370@macbook.localnet>
References: <1383582980-26317-1-git-send-email-jchapman@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDQtR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:49:17 -0500
Content-Disposition: inline
In-Reply-To: <1383582980-26317-1-git-send-email-jchapman@katalix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 04, 2013 at 04:36:20PM +0000, James Chapman wrote:
> Introduce an xtables add-on for matching L2TP packets. Supports L2TPv2
> and L2TPv3 over IPv4 and IPv6. As well as filtering on L2TP tunnel-id
> and session-id, the filtering decision can also include the L2TP
> packet type (control or data), protocol version (2 or 3) and
> encapsulation type (UDP or IP).
> 
> The most common use for this will likely be to filter L2TP data
> packets of individual L2TP tunnels or sessions. While a u32 match can
> be used, the L2TP protocol headers are such that field offsets differ
> depending on bits set in the header, making rules for matching generic
> L2TP connections cumbersome. This match extension takes care of all
> that.
> 
> +enum {
> +	XT_L2TP_TID	= (1 << 0),	/* match L2TP tunnel id */
> +	XT_L2TP_SID	= (1 << 1),	/* match L2TP session id */
> +	XT_L2TP_VERSION	= (1 << 2),	/* match L2TP protocol version */
> +	XT_L2TP_ENCAP	= (1 << 3),	/* match L2TP encapsulation type */
> +	XT_L2TP_TYPE	= (1 << 4),	/* match L2TP packet type */
> +};
> +

> +static struct xt_match l2tp_mt_reg[] __read_mostly = {
> +	{
> +		.name      = "l2tp",
> +		.revision  = 0,
> +		.family    = NFPROTO_IPV4,
> +		.match     = l2tp_mt4,
> +		.matchsize = XT_ALIGN(sizeof(struct xt_l2tp_info)),
> +		.hooks     = ((1 << NF_INET_PRE_ROUTING) |
> +			      (1 << NF_INET_LOCAL_IN) |
> +			      (1 << NF_INET_LOCAL_OUT) |
> +			      (1 << NF_INET_FORWARD)),
> +		.me        = THIS_MODULE,
> +	},

Plase add a checkentry function and verify that no unknown flags are passed
to the kernel.
