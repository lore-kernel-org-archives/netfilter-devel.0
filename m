From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nfnetlink_acct: add filter support to
 nfacct counter list/reset
Date: Wed, 20 Aug 2014 15:34:01 +0200
Message-ID: <20140820133401.GA7422@salvia>
References: <20140805155135.GA3666@salvia>
 <1407321662-4536-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaHTNd2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:33:28 -0400
Content-Disposition: inline
In-Reply-To: <1407321662-4536-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 06, 2014 at 02:41:02PM +0400, Alexey Perevalov wrote:
> +enum nfnl_attr_filter_type {
> +	NFACCT_FILTER_ATTR_UNSPEC,
> +	NFACCT_FILTER_ATTR_MASK,
> +	NFACCT_FILTER_ATTR_VALUE,
> +	__NFACCT_FILTER_ATTR_MAX
> +};

Minor nitpick: Could you remove the _ATTR so we get smaller name?

> +#define NFACCT_FILTER_ATTR_MAX (__NFACCT_FILTER_ATTR_MAX - 1)
>  
>  #endif /* _UAPI_NFNL_ACCT_H_ */
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 3ea0eac..94a47c4 100644
[...]
> +static struct nfacct_filter *
> +init_filter(const struct nlattr * const nla)

Rename this to nfacct_filter_alloc(), this fits in one line of
80-chars, no need to split it..

> +	struct nfacct_filter *filter = NULL;
> +	struct nlattr *attrs[NFACCT_FILTER_ATTR_MAX + 1];
> +
> +	if (!nla)
> +		return NULL;
> +
> +	if (nla_parse_nested(attrs, NFACCT_FILTER_ATTR_MAX,
> +			nla, filter_policy) != 0)
> +		return NULL;

        err = nla_parse_nested(...);
        if (err < 0)
                return ERR_PTR(err),

> +
> +	filter = kzalloc(sizeof(struct nfacct_filter), GFP_KERNEL);
> +	if (!filter)
> +		return NULL;

                return ERR_PTR(-ENOMEM);
> +
> +	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_ATTR_MASK]);
> +	filter->value = nla_get_be32(attrs[NFACCT_FILTER_ATTR_VALUE]);
> +
> +	return filter;
> +}
> +
> +static int
>  nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
>  	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
>  {
> @@ -220,9 +265,13 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
>  	char *acct_name;
>  
>  	if (nlh->nlmsg_flags & NLM_F_DUMP) {
> +		/* using filters only for dump/list operation */
>  		struct netlink_dump_control c = {
>  			.dump = nfnl_acct_dump,
> +			.done = nfnl_acct_done,
>  		};
> +		c.data = init_filter(tb[NFACCT_FILTER]);

I need better a bit error handling here, I suggest:

                if (tb[NFACCT_FILTER]) {
                        filter = nfacct_filter_alloc(tb[NFACCT_FILTER]);
                        if (IS_ERR(filter))
                                return PTR_ERR(filter);
                }

Currently, if we fail to allocate the filter, it silently ignores the
user request and it is not exactly doing what he requested.

Please, address this and resubmit. Thanks!
