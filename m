From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/7] Interpret OP_NEQ against a set as OP_LOOKUP
Date: Mon, 28 Nov 2016 12:39:05 +0100
Message-ID: <20161128113905.GC1691@salvia>
References: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754036AbcK1LjL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 06:39:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 709B313C0D4
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:39:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DD4016E3F6
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:39:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D900165CD8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:39:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 24, 2016 at 03:16:20PM +0100, Anatole Denis wrote:
> Now that the support for inverted matching is in the kernel and in libnftnl, add
> it to nftables too.
> 
> This fixes bug #888
> 
> Signed-off-by: Anatole Denis <anatole@rezel.net>
> ---
> This patch is heavily based off those of Yuxuan Shui from 2014
> (https://marc.info/?l=netfilter-devel&m=140682484411296)
> 
>  src/evaluate.c            | 14 ++++++++++++++
>  src/netlink_delinearize.c | 10 ++++++++++
>  src/netlink_linearize.c   | 14 +++++++++-----
>  3 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8b113c8..bb46615 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1541,6 +1541,20 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
>  			if (byteorder_conversion(ctx, &rel->right, left->byteorder) < 0)
>  				return -1;
>  			break;
> +		case EXPR_SET:
> +			assert(rel->op == OP_NEQ);
> +			right = rel->right =
> +				implicit_set_declaration(ctx, "__set%d",
> +							 left->dtype, left->len,
> +							 right);
> +			/* fall through */
> +		case EXPR_SET_REF:
> +			assert(rel->op == OP_NEQ);

Thanks for working on this.

I think we're almost there, we need a bit more code here to catch
these two error cases:

"the referenced set does not exist"

and

"datatype mismatch, expected %s, set has type %s"

See line 1481 in src/evaluate.c for the OP_LOOKUP case.

If I'm on the right track, please also test that these errors cases
work as intended.
