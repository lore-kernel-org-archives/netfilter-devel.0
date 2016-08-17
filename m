From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/4] evaluate: Avoid undefined behaviour in
 concat_subtype_id()
Date: Wed, 17 Aug 2016 16:51:27 +0200
Message-ID: <20160817145127.GD10362@salvia>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
 <1471017610-3473-5-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59384 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbcHQOvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:51:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8983ED163F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:51:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72B0E9EBAD
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:51:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 66C69FC61C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:51:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471017610-3473-5-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 06:00:10PM +0200, Phil Sutter wrote:
> Looking at expr_evaluate_concat(), 'off' might be zero and the error
> checks not triggering (by having dtype != NULL and i->dtype->size > 0).
> Decrementing it will then lead to casting -1 to unsigned during the call
> to concat_subtype_lookup() will lead to bit-shifting in
> concat_subtype_id() by a value bigger than the number of bits in 'type'
> (which is 32bit).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This patch is just an ugly sanitization hack and should probably be
> substituted by  an additional error check in expr_evaluate_concat()
> giving an explanation of what went wrong.

I agree. It would be good to look back and see what condition can
indeed trigger this instead of papering the problem with this check.

Thanks!

>  src/evaluate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 523eedabe84ac..c8568690f6338 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -950,7 +950,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  						 "expressions",
>  						 i->dtype->name);
>  
> -		tmp = concat_subtype_lookup(type, --off);
> +		tmp = concat_subtype_lookup(type, off > 0 ? --off : 0);
>  		expr_set_context(&ctx->ectx, tmp, tmp->size);
>  
>  		if (list_member_evaluate(ctx, &i) < 0)
> -- 
> 2.8.2
> 
