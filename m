From: Florian Westphal <fw@strlen.de>
Subject: Re: [linux PATCH 1/5] netfilter: nft_nat: include a flag attribute
Date: Thu, 26 Jun 2014 14:26:54 +0200
Message-ID: <20140626122654.GF6328@breakpoint.cc>
References: <20140626121823.3985.22905.stgit@nfdev.cica.es>
 <20140626121954.3985.35005.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59641 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaFZM04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:26:56 -0400
Content-Disposition: inline
In-Reply-To: <20140626121954.3985.35005.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> Both SNAT and DNAT (and the upcoming masquerade) can have additional
> configuration parameters, such as port randomization or NAT addressing
> persistence.
> We can cover these scenarios by simply adding a flag attribute for
> userspace to fill when needed.
> 
> The flags to use are defined in include/uapi/linux/netfilter/nf_nat.h,
>  NF_NAT_RANGE_MAP_IPS
>  NF_NAT_RANGE_PROTO_SPECIFIED
>  NF_NAT_RANGE_PROTO_RANDOM
>  NF_NAT_RANGE_PERSISTENT
>  NF_NAT_RANGE_PROTO_RANDOM_FULLY
>  NF_NAT_RANGE_PROTO_RANDOM_ALL
> 
> The caller must take care of not messing up with the flags, as they are
> added unconditionally to the final resulting nf_nat_range.

I dont think that this is desirable.
When userspace knows about NF_NAT_RANGE_FOO but the kernel does not
userspace should be ablre to detect that kernel is too old.

IOW,
>  static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> @@ -149,6 +153,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	} else
>  		priv->sreg_proto_max = priv->sreg_proto_min;
>  
> +	if (tb[NFTA_NAT_FLAGS])
> +		priv->flags = ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
> +
>  	return 0;
>  }

I think that NFTA_NAT_FLAGS desevers further validation that all
flags/bits are known.
