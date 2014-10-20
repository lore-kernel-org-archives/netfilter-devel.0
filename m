From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4 v2] evaluate: fix a crash if we check the
 transport protocol
Date: Mon, 20 Oct 2014 10:59:06 +0200
Message-ID: <20141020085906.GA4578@salvia>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
 <1413548677-10287-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbaJTI5g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:57:36 -0400
Content-Disposition: inline
In-Reply-To: <1413548677-10287-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 17, 2014 at 02:24:35PM +0200, Alvaro Neira Ayuso wrote:
> Example:
> 
> nft add rule inet filter input meta l4proto udp reject with tcp reset
> 
> When we check if the transport protocol is tcp, we use the network context.
> If we don't have this network context, we have a crash.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [no changes in v2]
> 
>  src/evaluate.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 4b7bda9..2f71e9b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1339,6 +1339,13 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
>  	if (desc == NULL)
>  		return 0;
>  
> +	if (base == NULL) {
> +		if (strcmp(desc->name, "tcp") == 0)
> +			return 0;
> +		else
> +			return stmt_error(ctx, stmt,
> +				 "you cannot use tcp reset with this protocol");
> +	}

Can you give a try to this?

        if (base == NULL &&
            ctx->table.handle.family == NFPROTO_INET)
                base = &proto_inet_service;

>  	protonum = proto_find_num(base, desc);
>  	switch (protonum) {
>  	case IPPROTO_TCP:
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
