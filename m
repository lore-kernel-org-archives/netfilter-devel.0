From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC 3/3] netfilter: nftables: Return preferably given family
 expression if any
Date: Thu, 27 Mar 2014 09:26:38 +0000
Message-ID: <20140327092638.GA3884@macbook.localnet>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1395911972-17259-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43046 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaC0J0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:26:42 -0400
Content-Disposition: inline
In-Reply-To: <1395911972-17259-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 11:19:32AM +0200, Tomasz Bursztyka wrote:
> Currently, when looking up for the proper expression type, what comes
> first is returned. Which might end up to be a non-family tight type.
> Instead, if a specific family type exist, it will be better to return
> this one.

Easier suggestion:

Change nft_register_expr() to appent NFPROTO_UNSPEC to the end of the
list and prepend all others.

> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  net/netfilter/nf_tables_api.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index adce01e..83de6c1 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1117,14 +1117,17 @@ EXPORT_SYMBOL_GPL(nft_unregister_expr);
>  static const struct nft_expr_type *__nft_expr_type_get(u8 family,
>  						       struct nlattr *nla)
>  {
> -	const struct nft_expr_type *type;
> -
> -	list_for_each_entry(type, &nf_tables_expressions, list) {
> -		if (!nla_strcmp(nla, type->name) &&
> -		    (!type->family || type->family == family))
> -			return type;
> +	const struct nft_expr_type *test, *type = NULL;
> +
> +	list_for_each_entry(test, &nf_tables_expressions, list) {
> +		if (!nla_strcmp(nla, test->name)) {
> +			if (test->family == family)
> +				return test;
> +			if (!test->family)
> +				type = test;
> +		}
>  	}
> -	return NULL;
> +	return type;
>  }
>  
>  static const struct nft_expr_type *nft_expr_type_get(u8 family,
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
