From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: move ip_ct_sctp away from UAPI
Date: Thu, 12 Nov 2015 06:33:08 -0500
Message-ID: <20151112113308.GA10933@hmsreliant.think-freely.org>
References: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45229 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbbKLLdU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Nov 2015 06:33:20 -0500
Content-Disposition: inline
In-Reply-To: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 11, 2015 at 08:17:37PM -0200, Marcelo Ricardo Leitner wrote:
> ip_ct_sctp is an internal structure, embedded by the union
> nf_conntrack_proto to store sctp-specific information at conntrack
> entries. It has no business with UAPI.
> 
> This patch moves it from UAPI to a saner place, together with similar
> structs for other protocols.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> No need to update MAINTAINERS.
> New header is pulled in automatically due to path preference.
> 
>  include/linux/netfilter/nf_conntrack_sctp.h      | 13 +++++++++++++
>  include/uapi/linux/netfilter/nf_conntrack_sctp.h | 12 +++---------
>  2 files changed, 16 insertions(+), 9 deletions(-)
>  create mode 100644 include/linux/netfilter/nf_conntrack_sctp.h
> 
> diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..22a16a23cd8a7e3d6d000ee7249477a3fef11604
> --- /dev/null
> +++ b/include/linux/netfilter/nf_conntrack_sctp.h
> @@ -0,0 +1,13 @@
> +#ifndef _NF_CONNTRACK_SCTP_H
> +#define _NF_CONNTRACK_SCTP_H
> +/* SCTP tracking. */
> +
> +#include <uapi/linux/netfilter/nf_conntrack_sctp.h>
> +
> +struct ip_ct_sctp {
> +	enum sctp_conntrack state;
> +
> +	__be32 vtag[IP_CT_DIR_MAX];
> +};
> +
> +#endif /* _NF_CONNTRACK_SCTP_H */
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> index ed4e776e1242f586cf1062646903e9afc7bb1af6..2cbc366c3fb4725d06a2def46ac0d54d0dc184f6 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> @@ -1,5 +1,5 @@
> -#ifndef _NF_CONNTRACK_SCTP_H
> -#define _NF_CONNTRACK_SCTP_H
> +#ifndef _UAPI_NF_CONNTRACK_SCTP_H
> +#define _UAPI_NF_CONNTRACK_SCTP_H
>  /* SCTP tracking. */
>  
>  #include <linux/netfilter/nf_conntrack_tuple_common.h>
> @@ -18,10 +18,4 @@ enum sctp_conntrack {
>  	SCTP_CONNTRACK_MAX
>  };
>  
> -struct ip_ct_sctp {
> -	enum sctp_conntrack state;
> -
> -	__be32 vtag[IP_CT_DIR_MAX];
> -};
> -
> -#endif /* _NF_CONNTRACK_SCTP_H */
> +#endif /* _UAPI_NF_CONNTRACK_SCTP_H */
> -- 
> 2.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

