From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] evaluate: check for NULL datatype in rhs in
 lookup expr
Date: Fri, 13 May 2016 11:38:56 +0200
Message-ID: <20160513093856.GA4008@salvia>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56775 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbcEMJjD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 05:39:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CFEBD4B9E6
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:38:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BDC362687DC
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:38:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B8C052687DC
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 11:38:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 11, 2016 at 01:30:02PM +0200, Arturo Borrero Gonzalez wrote:
> If we are evaluating an EXPR_SET_REF, check if right->dtype is not NULL.
> We can hit SEGFAULT if for whatever reason the referenced object does not
> exists.
> 
> Using this testfile (note the invalid set syntax):
> 
> % cat test.nft
> flush ruleset
> add table t
> add chain t c
> add set t s {type ipv4_addr\;}
> add rule t c ip saddr @s
> 
> Without this patch:
> 
> % nft -f test.nft
> Segmentation fault
> 
> With this patch:
> 
> % nft -f test.nft
> t.nft:4:28-28: Error: syntax error, unexpected junk, expecting newline or semicolon
> add set t s {type ipv4_addr\;}
>                            ^
> t.nft:4:13-29: Error: set definition does not specify key data type
> add set t s {type ipv4_addr\;}
>             ^^^^^^^^^^^^^^^^^
> t.nft:5:23-24: Error: the referenced object does not exists

I have reworded this to: "the referenced set does not exist"

> add rule t c ip saddr @s
>              ~~~~~~~~ ^^

Applied, thanks Arturo.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/evaluate.c |   35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 7444d09..6840790 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1210,16 +1210,33 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
>  
>  	switch (rel->op) {
>  	case OP_LOOKUP:
> -		/* A literal set expression implicitly declares the set */
> -		if (right->ops->type == EXPR_SET)
> +		switch (right->ops->type) {
> +		case EXPR_SET:
> +			/* A literal set expression implicitly declares
> +			 * the set
> +			 */
>  			right = rel->right =
> -				implicit_set_declaration(ctx, left->dtype, left->len, right);
> -		else if (!datatype_equal(left->dtype, right->dtype))
> -			return expr_binary_error(ctx->msgs, right, left,
> -						 "datatype mismatch, expected %s, "
> -						 "set has type %s",
> -						 left->dtype->desc,
> -						 right->dtype->desc);
> +				implicit_set_declaration(ctx, left->dtype,
> +							 left->len, right);
> +			break;
> +		case EXPR_SET_REF:
> +			if (right->dtype == NULL)
> +				return expr_binary_error(ctx->msgs, right,
> +							 left, "the referenced"
> +							 " object does not "
> +							 "exists");
> +			if (!datatype_equal(left->dtype, right->dtype))
> +				return expr_binary_error(ctx->msgs, right,
> +							 left, "datatype "
> +							 "mismatch, expected "
> +							 "%s, set has type %s",
> +							 left->dtype->desc,
> +							 right->dtype->desc);
> +			break;
> +		default:
> +			BUG("unhandled right expression type %u\n",
> +			    right->ops->type);

I have also replaced this by the typical:

                       BUG("Unknown expression %s\n", right->ops->name);
