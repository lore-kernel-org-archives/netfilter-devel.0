From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_acct: add filter support to nfacct
 counter list/reset
Date: Tue, 5 Aug 2014 17:51:35 +0200
Message-ID: <20140805155135.GA3666@salvia>
References: <20140729163208.GA3739@salvia>
 <1407167548-2883-2-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56977 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaHEPv0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:51:26 -0400
Content-Disposition: inline
In-Reply-To: <1407167548-2883-2-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2014 at 07:52:28PM +0400, Alexey Perevalov wrote:
> Filtering covers following cases:
> 	1. no filter specified. In this case client will get old
> behaviour
> 	2. filter is specified for getting just counters:
> 		in this case mask should be NFACCT_F_QUOTAS and value 0
> 	3. filter is specified for getting quotas:
> 		for packet based quota mask should be
> NFACCT_F_QUOTA_PKTS and value - the same as mask,
> 		for byte based quota mask should be
> NFACCT_F_QUOTA_BYTES and value - the same as mask.
> 	There is no support for listening/reseting quota of any available type
> per one request. In case of NFACCT_F_QUOTA two list/reset request is necessary.

If no filter is specified, any of the available types is reset. So no
need for the two requests.

> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_acct.h |   12 +++++
>  net/netfilter/Kconfig                         |    9 ++++
>  net/netfilter/nfnetlink_acct.c                |   61 +++++++++++++++++++++++++
>  3 files changed, 82 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
> index 51404ec..1683edb 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
> @@ -28,9 +28,21 @@ enum nfnl_acct_type {
>  	NFACCT_USE,
>  	NFACCT_FLAGS,
>  	NFACCT_QUOTA,
> +#ifdef CONFIG_NF_ACCT_FILTER

Please, remove the ifdef and the Kconfig switch.

> +	NFACCT_FILTER,
> +#endif
>  	__NFACCT_MAX
>  };
>  #define NFACCT_MAX (__NFACCT_MAX - 1)
>  
> +#ifdef CONFIG_NF_ACCT_FILTER
> +enum nfnl_attr_filter_type {
> +	NFACCT_FILTER_ATTR_UNSPEC,
> +	NFACCT_FILTER_ATTR_MASK,
> +	NFACCT_FILTER_ATTR_VALUE,
> +	__NFACCT_FILTER_ATTR_MAX
> +};
> +#define NFACCT_FILTER_ATTR_MAX (__NFACCT_FILTER_ATTR_MAX - 1)
> +#endif /* CONFIG_NF_ACCT_FILTER */
>  
>  #endif /* _UAPI_NFNL_ACCT_H_ */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index ad751fe..8e3f882 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -12,6 +12,15 @@ tristate "Netfilter NFACCT over NFNETLINK interface"
>  	  If this option is enabled, the kernel will include support
>  	  for extended accounting via NFNETLINK.
>  
> +if NETFILTER_NETLINK_ACCT
> +config NF_ACCT_FILTER
> +	bool  'Filter support for nfacct netlink protocol'
> +	depends on NETFILTER_ADVANCED
> +	help
> +	 If this option is enabled, nfacct framework will be able to list
> +	 counters by filter.
> +endif
> +
>  config NETFILTER_NETLINK_QUEUE
>  	tristate "Netfilter NFQUEUE over NFNETLINK interface"
>  	depends on NETFILTER_ADVANCED
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 3ea0eac..53293a4 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -40,6 +40,13 @@ struct nf_acct {
>  	char			data[0];
>  };
>  
> +#ifdef CONFIG_NF_ACCT_FILTER
> +struct nfacct_filter {
> +	u32 value;
> +	u32 mask;
> +};
> +#endif
> +
>  #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
>  #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
>  
> @@ -181,6 +188,9 @@ static int
>  nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  {
>  	struct nf_acct *cur, *last;
> +#ifdef CONFIG_NF_ACCT_FILTER
> +	const struct nfacct_filter *filter = cb->data;
> +#endif
>  
>  	if (cb->args[2])
>  		return 0;
> @@ -197,6 +207,12 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  			last = NULL;
>  		}
> +
> +#ifdef CONFIG_NF_ACCT_FILTER
> +		if (filter && (cur->flags & filter->mask) != filter->value)
> +			continue;
> +#endif
> +
>  		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
>  				       cb->nlh->nlmsg_seq,
>  				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
> @@ -211,6 +227,44 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  	return skb->len;
>  }
>  
> +#ifdef CONFIG_NF_ACCT_FILTER
> +static int
> +nfnl_acct_done(struct netlink_callback *cb)
> +{
> +	if (cb->data)

You can remove this branch above, kfree already handles NULL pointers
for us.

Apart from those, this looks good to me. Thanks.
