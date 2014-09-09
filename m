From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v4 1/5] netfilter: nft_nat: include a flag
 attribute
Date: Tue, 9 Sep 2014 11:50:03 +0200
Message-ID: <20140909095003.GA9128@salvia>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59925 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbaIIJtP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:49:15 -0400
Content-Disposition: inline
In-Reply-To: <20140904120518.5971.77791.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 02:06:14PM +0200, Arturo Borrero Gonzalez wrote:
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

Not sure this comment is relevant. Of course, userspace should select
the flags accordingly :-). Let me know if the intention was other than
insisting on the fact that the flags alter the way the NAT is done.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: address Florian Westphal's comments: check all flag bits to be known.
> v3: style cleanup requested by Pablo Neira. Mask name shortened.
> v4: nf-next rebase.
> 
>  include/uapi/linux/netfilter/nf_nat.h    |    5 +++++
>  include/uapi/linux/netfilter/nf_tables.h |    2 ++
>  net/netfilter/nft_nat.c                  |   16 ++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
> index 1ad3659..898db2d 100644
> --- a/include/uapi/linux/netfilter/nf_nat.h
> +++ b/include/uapi/linux/netfilter/nf_nat.h
> @@ -13,6 +13,11 @@
>  #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
>  	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
>  
> +#define NF_NAT_RANGE_MASK					\
> +	(NF_NAT_RANGE_MAP_IPS|NF_NAT_RANGE_PROTO_SPECIFIED	\
> +	 |NF_NAT_RANGE_PROTO_RANDOM|NF_NAT_RANGE_PERSISTENT	\
> +	 |NF_NAT_RANGE_PROTO_RANDOM_FULLY)

I'm going to make the following comestic change:

#define NF_NAT_RANGE_MASK                                      \
     (NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |    \
      NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |    \
      NF_NAT_RANGE_PROTO_RANDOM_FULLY)

Next time, place the '|' '&' and so on after at the end of the line.

If no more comments, I'll push this to nf-next. Thanks.
