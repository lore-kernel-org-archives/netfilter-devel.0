From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink_delinearize: restore listing of host
 byteorder set elements
Date: Thu, 4 Jun 2015 04:23:40 +0200
Message-ID: <20150604022340.GA13221@acer.localdomain>
References: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43780 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbFDCXn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2015 22:23:43 -0400
Content-Disposition: inline
In-Reply-To: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03.06, Pablo Neira Ayuso wrote:
> before:
> 
> table ip filter {
>         chain test {
>                 cpu { 67108864, 50331648, 33554432}
>         }
> }
> 
> after:
> 
> table ip filter {
>         chain test {
>                 cpu { 4, 3, 2 }
>         }
> }
> 
> Related to 525323352904 ("expr: add set_elem_expr as container for set element
> attributes").
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Note: This patch applies to the next-4.1 branch.
> 
>  src/netlink_delinearize.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index b1ce911..ea60c86 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -824,6 +824,10 @@ static void integer_type_postprocess(struct expr *expr)
>  			integer_type_postprocess(i);
>  		}
>  		break;
> +	case EXPR_SET_ELEM:
> +		expr_set_type(expr->key, expr->dtype, expr->byteorder);
> +		integer_type_postprocess(expr->key);


The fundamental problem is that this is that integers are a special case where
we don't always have enough context to properly restore. Literal sets can work
because we by definition have a LHS, but it is impossible to fix for named sets.

IMO the correct solution is to use endian encoding for integers. Special case
the special case, basically. By that I don't mean internally using be_integer
and le_integer, but to only do it on the lowest possible level, set type
declarations. Our default encoding is BE, so we add a LE integer type and *only*
use it for set type declarations and immediately when delinearizing map it back
to a regular integer, but adjust the byteorder appropriately.

This will fix both problems, and we can (need to) get rid of the
integer_type_postprocess(), which can only work for literal sets.
