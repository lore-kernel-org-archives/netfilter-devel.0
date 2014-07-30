From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix overquota output result
Date: Wed, 30 Jul 2014 19:01:15 +0200
Message-ID: <20140730170115.GA6364@salvia>
References: <1406733925-5344-1-git-send-email-a.perevalov@samsung.com>
 <1406733925-5344-2-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35989 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaG3RBK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:01:10 -0400
Content-Disposition: inline
In-Reply-To: <1406733925-5344-2-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 30, 2014 at 07:25:25PM +0400, Alexey Perevalov wrote:
> Current implementation shows "packet" for none byte quota type.
> It means "packet" was used for overquota counter as well and it
> wasn't so informative.
> 
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  src/libnetfilter_acct.c |   22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
> index 7f539b6..9ed50c9 100644
> --- a/src/libnetfilter_acct.c
> +++ b/src/libnetfilter_acct.c
> @@ -266,15 +266,23 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
>  		SNPRINTF_CHECK(ret, rem, offset, len);
>  
>  		if (nfacct->flags) {
> -			uint32_t mode;
> -
> -			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
> -
> +			const uint32_t mode = nfacct_attr_get_u64(nfacct,
> +				NFACCT_ATTR_FLAGS);
> +			char *mode_name = NULL, *overquota = NULL;
> +			printf("mode %u", mode);

I guess this just accidentally slipped through.

> +			if (mode & NFACCT_F_QUOTA_PKTS)
> +				mode_name = "packet";
> +			else if (mode & NFACCT_F_QUOTA_BYTES)
> +				mode_name = "byte";
> +
> +			if (mode & NFACCT_F_OVERQUOTA)
> +				overquota = " overquota";
> +			else
> +				overquota = "";
>  			ret = snprintf(buf + offset, rem,
> -				", quota = %.20"PRIu64", mode = %s",
> +				", quota = %.20"PRIu64", mode = %s%s",
>  				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
> -				mode == NFACCT_F_QUOTA_BYTES ?
> -				"byte" : "packet");
> +				mode_name, overquota);
>  			SNPRINTF_CHECK(ret, rem, offset, len);

I prefer if this is represented in this way:

quota = ..., mode = ..., overquota = yes }

or

overquota = no

depending on the result. If there is some people parsing this CSV
already, if they are doing it in some sane way they will just skip
unknown keys.

Thanks.
