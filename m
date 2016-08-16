From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 v4 libnftnl] Implement rule comparison
Date: Tue, 16 Aug 2016 13:57:49 +0200
Message-ID: <20160816115749.GA2049@salvia>
References: <20160816102126.28662-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44778 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbcHPL54 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Aug 2016 07:57:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EE6A6186AC1
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:57:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DF600CE156
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:57:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA56ECE155
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 13:57:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160816102126.28662-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 16, 2016 at 12:21:24PM +0200, Carlos Falgueras García wrote:
> diff --git a/src/expr.c b/src/expr.c
> index e5c1dd3..7f32055 100644
> --- a/src/expr.c
> +++ b/src/expr.c
> @@ -203,6 +203,20 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_expr_get_str, nft_rule_expr_get_str);
>  
> +bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
> +{
> +	if (e1->flags != e2->flags)
> +		return false;
> +
> +	if (strcmp(e1->ops->name, e2->ops->name))
> +		return false;
> +	if (e1->ops->cmp)
> +		return e1->ops->cmp(e1, e2);
> +	else
> +		return !memcmp(e1->data, e2->data, e1->ops->alloc_len);

We cannot do memcmp() anymore, we have to add cmp() for each
expression because of we have already discussed wrt. unset attributes.
