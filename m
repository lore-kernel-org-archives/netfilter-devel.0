From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4, libnftnl] rule: Implement internal expression
 iterator
Date: Mon, 8 Aug 2016 13:25:02 +0200
Message-ID: <20160808112502.GA11574@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50690 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbcHHLZL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 07:25:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 18C71186AC3
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:25:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F4187100A63
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:25:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A879D114D61
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:25:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808111758.4062-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 01:17:55PM +0200, Carlos Falgueras García wrote:
> With 'nftnl_expr_iter_init' we can create an expression iterator without
> dynamic memory allocation.

I'd suggest this description:

Introduce nftnl_expr_iter_init() to allow stack allocated iterators
for internal use.

Another comment below.

> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  include/internal.h |  1 +
>  include/rule.h     | 15 +++++++++++++++
>  src/rule.c         | 23 ++++++++++++-----------
>  3 files changed, 28 insertions(+), 11 deletions(-)
>  create mode 100644 include/rule.h
> 
> diff --git a/include/internal.h b/include/internal.h
> index c74e2bf..f1b6511 100644
> --- a/include/internal.h
> +++ b/include/internal.h
> @@ -12,6 +12,7 @@
>  #include "set.h"
>  #include "set_elem.h"
>  #include "expr.h"
> +#include "rule.h"
>  #include "expr_ops.h"
>  #include "buffer.h"
>  
> diff --git a/include/rule.h b/include/rule.h
> new file mode 100644
> index 0000000..e2ea578
> --- /dev/null
> +++ b/include/rule.h
> @@ -0,0 +1,15 @@
> +#ifndef _LIBNFTNL_RULE_INTERNAL_H_
> +#define _LIBNFTNL_RULE_INTERNAL_H_
> +
> +#include <libnftnl/rule.h>
> +#include <libnftnl/expr.h>
> +
> +struct nftnl_expr_iter {
> +	const struct nftnl_rule	*r;
> +	struct nftnl_expr	*cur;
> +};
> +
> +void nftnl_expr_iter_init(const struct nftnl_rule *r,
> +			  struct nftnl_expr_iter *iter);

If nftnl_expr_iter_init() is only used from src/rule.c, then there is
no need to expose this rule include/rule.h

> +
> +#endif
> diff --git a/src/rule.c b/src/rule.c
> index a0edca7..0cfddf2 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1025,10 +1025,17 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
>  
> -struct nftnl_expr_iter {
> -	struct nftnl_rule		*r;
> -	struct nftnl_expr	*cur;
> -};
> +void nftnl_expr_iter_init(const struct nftnl_rule *r,
> +			  struct nftnl_expr_iter *iter)
> +{
> +	iter->r = r;
> +	if (list_empty(&r->expr_list))
> +		iter->cur = NULL;
> +	else
> +		iter->cur = list_entry(r->expr_list.next, struct nftnl_expr,
> +				       head);
> +}
> +EXPORT_SYMBOL(nftnl_expr_iter_init);
>  
>  struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r)
>  {
> @@ -1037,13 +1044,7 @@ struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r)
>  	iter = calloc(1, sizeof(struct nftnl_expr_iter));
>  	if (iter == NULL)
>  		return NULL;
> -
> -	iter->r = r;
> -	if (list_empty(&r->expr_list))
> -		iter->cur = NULL;
> -	else
> -		iter->cur = list_entry(r->expr_list.next, struct nftnl_expr,
> -				       head);
> +	nftnl_expr_iter_init(r, iter);
>  
>  	return iter;
>  }
> -- 
> 2.8.3
> 
