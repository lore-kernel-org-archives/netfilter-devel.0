From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 12:18:38 +0100
Message-ID: <20121127111838.GA28064@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60515 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2K0LSr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:18:47 -0500
Content-Disposition: inline
In-Reply-To: <1352994915-3859-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Nov 15, 2012 at 04:55:15PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_conntrack_labels.h |    3 ++
>  net/netfilter/nf_conntrack_labels.c         |   34 +++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c        |   23 ++++++++++++++++++
>  3 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
> index fdd88fb..e058b2b 100644
> --- a/include/net/netfilter/nf_conntrack_labels.h
> +++ b/include/net/netfilter/nf_conntrack_labels.h
> @@ -52,3 +52,6 @@ static inline void nf_conntrack_labels_fini(struct net *net) {}
>  
>  bool nf_connlabel_match(const struct nf_conn *ct, u16 bit);
>  int nf_connlabel_set(struct nf_conn *ct, u16 bit);
> +
> +int nfnetlink_connlabel_set(struct nf_conn *ct, const void *data,
> +			    unsigned int length);
> diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> index fe9c0c6..8bff33c 100644
> --- a/net/netfilter/nf_conntrack_labels.c
> +++ b/net/netfilter/nf_conntrack_labels.c
> @@ -52,6 +52,40 @@ int nf_connlabel_set(struct nf_conn *ct, u16 bit)
>  }
>  EXPORT_SYMBOL_GPL(nf_connlabel_set);
>  
> +#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
> +int nfnetlink_connlabel_set(struct nf_conn *ct, const void *data, unsigned int length)
> +{
> +	const size_t maxblen = (1024 / BITS_PER_LONG) * sizeof(long);
> +	struct nf_conn_labels *labels;
> +	unsigned int size;
> +
> +	if (length > maxblen)
> +		return -EMSGSIZE;
> +
> +	labels = nf_ct_labels_find(ct);
> +	if (!labels)
> +		return -ENOSPC;
> +
> +	size = labels->words * sizeof(long);
> +
> +	if (size < length)
> +		length = size;
> +
> +	if (length)
> +		memcpy(labels->bits, data, length);
> +
> +	if (size > length) {
> +		unsigned int pad = size - length;
> +		char *mem = (void *) labels->bits;
> +		memset(mem + pad, 0, pad);
> +	}
> +
> +	nf_conntrack_event_cache(IPCT_LABEL, ct);
> +	return 0;
> +}

Via ctnetlink_new_conntrack, we should be able to create and set the
connlabel if we want to support state-sync of connlabels.

That requires calling _ext_add(...) to allocate the label, based on
cda[CTA_LABELS], and set it. In that case we're safe to memcpy without
interfering with any ongoing bit testing since that conntrack is not
in the hashes yet.

For the update case, I think we'll have to iterate over the mask and
use xchg to update words, thus, we avoid any interference ongoing bit
testing.

> +EXPORT_SYMBOL_GPL(nfnetlink_connlabel_set);
> +#endif
> +
>  static struct nf_ct_ext_type labels_extend __read_mostly = {
>  	.len    = sizeof(struct nf_conn_labels),
>  	.align  = __alignof__(struct nf_conn_labels),
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 43a1247..834fe99 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1229,6 +1229,16 @@ ctnetlink_change_nat(struct nf_conn *ct, const struct nlattr * const cda[])
>  }
>  
>  static inline int
> +ctnetlink_attach_label(struct nf_conn *ct, const struct nlattr * const cda[])
> +{
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	return nfnetlink_connlabel_set(ct, nla_data(cda[CTA_LABELS]), nla_len(cda[CTA_LABELS]));
> +#else
> +	return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static inline int
>  ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
>  {
>  	struct nf_conntrack_helper *helper;
> @@ -1441,6 +1451,11 @@ ctnetlink_change_conntrack(struct nf_conn *ct,
>  			return err;
>  	}
>  #endif
> +	if (cda[CTA_LABELS]) {
> +		err = ctnetlink_attach_label(ct, cda);
> +		if (err < 0)
> +			return err;
> +	}
>  
>  	return 0;
>  }
> @@ -1649,6 +1664,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
>  			else
>  				events = IPCT_NEW;
>  
> +			if (cda[CTA_LABELS] && ctnetlink_attach_label(ct, cda) == 0)
> +				events |= (1 << IPCT_LABEL);
> +
>  			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
>  						      (1 << IPCT_ASSURED) |
>  						      (1 << IPCT_HELPER) |
> @@ -1946,6 +1964,11 @@ ctnetlink_nfqueue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
>  		if (err < 0)
>  			return err;
>  	}
> +	if (cda[CTA_LABELS]) {
> +		err = ctnetlink_attach_label(ct, cda);
> +		if (err < 0)
> +			return err;
> +	}
>  #if defined(CONFIG_NF_CONNTRACK_MARK)
>  	if (cda[CTA_MARK])
>  		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
