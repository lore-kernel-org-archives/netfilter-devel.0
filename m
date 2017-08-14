From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v4 2/3] Implement --echo option
Date: Mon, 14 Aug 2017 12:50:33 +0200
Message-ID: <20170814105033.GA22717@salvia>
References: <20170809111643.18906-1-phil@nwl.cc>
 <20170809111643.18906-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:46214 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbdHNKu7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 06:50:59 -0400
Content-Disposition: inline
In-Reply-To: <20170809111643.18906-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 09, 2017 at 01:16:42PM +0200, Phil Sutter wrote:
> diff --git a/include/nftables.h b/include/nftables.h
> index 640d3c7e715d8..ca609015274a9 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -29,6 +29,7 @@ struct output_ctx {
>  	unsigned int stateless;
>  	unsigned int ip2name;
>  	unsigned int handle;
> +	unsigned int echo;
>  };
>  
>  struct nft_ctx {
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d24526fef2954..477fb54d51f26 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2962,6 +2962,9 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
>  		handle_merge(&cmd->set->handle, &cmd->handle);
>  		return set_evaluate(ctx, cmd->set);
>  	case CMD_OBJ_RULE:
> +		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
> +		if (ret < 0)
> +			return ret;

Wow. And this is going to slow down rule updates *a lot*.

Please, revisit this...

>  		handle_merge(&cmd->rule->handle, &cmd->handle);
>  		return rule_evaluate(ctx, cmd->rule);
>  	case CMD_OBJ_CHAIN:
> @@ -2975,6 +2978,10 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_COUNTER:
>  	case CMD_OBJ_QUOTA:
>  	case CMD_OBJ_CT_HELPER:
> +		ret = cache_update(ctx->nf_sock, cmd->op, ctx->msgs);
> +		if (ret < 0)
> +			return ret;
> +
>  		return 0;
>  	default:
>  		BUG("invalid command object type %u\n", cmd->obj);
