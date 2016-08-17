From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 v5 libnftnl] Implement rule comparison
Date: Wed, 17 Aug 2016 16:10:48 +0200
Message-ID: <20160817141048.GA8692@salvia>
References: <20160817110010.28943-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbcHQOLP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:11:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 02EC5D1622
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:11:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E76E8CE156
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:10:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E7774DA3B0
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:10:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160817110010.28943-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 17, 2016 at 01:00:08PM +0200, Carlos Falgueras García wrote:
> This patch implements the function 'bool nftnl_rule_cmp(const struct
> nftnl_rule *r, const struct nftnl_rule *r2)' for rule comparison.
> 
> Expressions within rules need to be compared, so also has been created the
> function 'nftnl_expr_cmp' which calls new field within
> 'nfntl_expr_<expression>': a function pointer to a comparator.

Applied, thanks.

I made some slight changes, see below.

> diff --git a/src/expr.c b/src/expr.c
> index e5c1dd3..1f57fb2 100644
> --- a/src/expr.c
> +++ b/src/expr.c
> @@ -203,6 +203,17 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_expr_get_str, nft_rule_expr_get_str);
>  
> +bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
> +{
> +	if (e1->flags != e2->flags || strcmp(e1->ops->name, e2->ops->name))
> +		return false;
> +	if (e1->ops->cmp)
> +		return e1->ops->cmp(e1, e2);
> +
> +	return false;
> +}
> +EXPORT_SYMBOL(nftnl_expr_cmp);

_cmp() is now mandatory, so I have simplified this:

bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
{
	if (e1->flags != e2->flags ||
            strcmp(e1->ops->name, e2->ops->name) != 0)
		return false;

	return e1->ops->cmp(e1, e2);
}
EXPORT_SYMBOL(nftnl_expr_cmp);

> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index 2fd4b74..1cfef0f 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -310,10 +310,32 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
>  	return -1;
>  }
>  
> +static bool nftnl_expr_bitwise_cmp(const struct nftnl_expr *e1,
> +				   const struct nftnl_expr *e2)
> +{
> +	struct nftnl_expr_bitwise *b1 = nftnl_expr_data(e1);
> +	struct nftnl_expr_bitwise *b2 = nftnl_expr_data(e2);
> +	bool eq = true;
> +
> +	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_SREG))
> +		eq &= b1->sreg == b2->sreg;

I have wrapped all this comparisons with parens.

		eq &= (b1->sreg == b2->sreg);

Not that the compiler was asking for this here, but I think it makes
it a bit more readable for this specific case.
