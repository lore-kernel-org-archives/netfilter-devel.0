From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: connlabels: Export setting connlabel
 length
Date: Sat, 1 Aug 2015 02:40:34 +0200
Message-ID: <20150801004034.GC20471@breakpoint.cc>
References: <1438386624-52057-1-git-send-email-joestringer@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
To: Joe Stringer <joestringer@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33837 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbbHAAki (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jul 2015 20:40:38 -0400
Content-Disposition: inline
In-Reply-To: <1438386624-52057-1-git-send-email-joestringer@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joe Stringer <joestringer@nicira.com> wrote:
> diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> index bb53f12..00df4e71 100644
> --- a/net/netfilter/nf_conntrack_labels.c
> +++ b/net/netfilter/nf_conntrack_labels.c
> @@ -91,6 +91,30 @@ int nf_connlabels_replace(struct nf_conn *ct,
>  EXPORT_SYMBOL_GPL(nf_connlabels_replace);
>  #endif
>  
> +int nf_connlabels_get(struct net *net, unsigned int n_bits)
> +{
> +	size_t words;
> +
> +	if (n_bits > XT_CONNLABEL_MAXBIT + 1)

Perhaps use

  if (n_bits >= (NF_CT_LABELS_MAX_SIZE * BITS_PER_BYTE)))

To avoid the XT_CONNLABEL_MAXBIT in the nf_* part.

> +		return -ERANGE;
> +
> +	net->ct.labels_used++;
> +	words = BITS_TO_LONGS(n_bits);
> +	if (words > net->ct.label_words)
> +		net->ct.label_words = words;
> +
> +	return 0;
> +}

I think we should add a lock here, currently this is protected by the
xtables mutex -- I'd suggest to just add a spinlock for this.

>  		return ret;
>  	}
>  
> -	par->net->ct.labels_used++;
> -	words = BITS_TO_LONGS(info->bit+1);
> -	if (words > par->net->ct.label_words)
> -		par->net->ct.label_words = words;
> -
> -	return ret;
> +	return nf_connlabels_get(par->net, info->bit + 1);

This can leak the refcnt on l3_proto_module we obtained earlier.

Other than that, this looks good.

Thanks,
Florian
