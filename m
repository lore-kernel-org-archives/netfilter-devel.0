From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4, V3, libnftnl] rule: Implement internal expression
 iterator
Date: Wed, 10 Aug 2016 13:41:40 +0200
Message-ID: <20160810114140.GA9639@salvia>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54126 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbcHJSuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:50:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE94A1878AF
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:41:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADCF8FF2D4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:41:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92B07A8E9
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 13:41:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810094857.14227-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:48:54AM +0200, Carlos Falgueras García wrote:
> Introduce nftnl_expr_iter_init() to allow stack allocated iterators for
> internal use.

Applied with minor changes, see below.
> 
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  src/rule.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 11fceca..69ffc7e 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -29,6 +29,14 @@
>  #include <libnftnl/set.h>
>  #include <libnftnl/expr.h>
>  
> +struct nftnl_expr_iter {
> +	const struct nftnl_rule	*r;
> +	struct nftnl_expr	*cur;
> +};
> +
> +static void nftnl_expr_iter_init(const struct nftnl_rule *r,
> +				 struct nftnl_expr_iter *iter);

No need for this forward declaration. I have removed this.

> +
>  struct nftnl_rule {
>  	struct list_head head;
>  
> @@ -1025,10 +1033,16 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
>  
> -struct nftnl_expr_iter {
> -	const struct nftnl_rule	*r;
> -	struct nftnl_expr	*cur;
> -};

I have kept this structure definition here, we don't have to scroll up
and down to get the context when looking at the iterators code.

After my change, the patch looks even smaller.
