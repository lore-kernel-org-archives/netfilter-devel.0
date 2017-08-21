From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: Initialize struct stmt in _match and _target
 functions.
Date: Mon, 21 Aug 2017 16:45:32 +0200
Message-ID: <20170821144532.GA6840@salvia>
References: <20170820045512.3232-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56121 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdHUOqB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:46:01 -0400
Content-Disposition: inline
In-Reply-To: <20170820045512.3232-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 20, 2017 at 10:25:12AM +0530, Varsha Rao wrote:
> Initialize structure stmt with stmt_alloc in netlink_parse_target and
> netlink_parse_match functions. This patch fixes the warning:
> 
> ‘stmt’ may be used uninitialized in this function.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
>  src/xt.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/xt.c b/src/xt.c
> index 3bc38ee..9aff414 100644
> --- a/src/xt.c
> +++ b/src/xt.c
> @@ -143,6 +143,7 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
>  	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
>  	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
>  
> +	stmt = stmt_alloc(loc, NULL);

this is partially reverting:

http://git.netfilter.org/nftables/commit/?id=bce55916b51ec1a4c23322781e3b0c698ecc9561

Are you 100% this works? How did you test this?

>  	stmt->xt.name = strdup(name);
>  	stmt->xt.type = NFT_XT_MATCH;
>  	stmt->xt.match = xt_match_clone(mt);
> @@ -179,6 +180,7 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
>  	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
>  	strcpy(t->u.user.name, tg->name);
>  
> +	stmt = stmt_alloc(loc, NULL);
>  	stmt->xt.name = strdup(name);
>  	stmt->xt.type = NFT_XT_TARGET;
>  	stmt->xt.target = xt_target_clone(tg);
> -- 
> 2.13.5
> 
