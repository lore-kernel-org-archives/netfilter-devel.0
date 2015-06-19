From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 3/3] rule: fix use of intervals in set declarations
Date: Fri, 19 Jun 2015 15:13:36 +0200
Message-ID: <20150619131336.GH22946@acer.localdomain>
References: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
 <1434719718-10371-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, admin@rollinix.net,
	niels@kristensen.io, tom@compton.nu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56368 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbFSNNk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:13:40 -0400
Content-Disposition: inline
In-Reply-To: <1434719718-10371-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>  static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
> -			   const struct expr *expr)
> +			   const struct location *loc, struct expr *expr)
>  {
> -	if (netlink_add_setelems(ctx, h, expr) < 0)
> +	struct set *set;
> +
> +	if (netlink_get_set(ctx, h, loc) < 0)

I think we should get it from the internal list and not from the
kernel. We can't add intervals to existing sets so far anyways,
and this would allow it, but it wouldn't work.

>  		return -1;
> +
> +	list_for_each_entry(set, &ctx->list, list) {
> +		if (set->flags & SET_F_INTERVAL &&
> +		    set_to_intervals(ctx->msgs, set, expr) < 0)
> +			return -1;
> +
> +		if (netlink_add_setelems(ctx, h, expr) < 0)
> +			return -1;
> +	}
>  	return 0;
>  }
>  
> @@ -756,7 +767,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
>  	case CMD_OBJ_SET:
>  		return do_add_set(ctx, &cmd->handle, cmd->set);
>  	case CMD_OBJ_SETELEM:
> -		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
> +		return do_add_setelems(ctx, &cmd->handle, &cmd->location,
> +				       cmd->expr);
>  	default:
>  		BUG("invalid command object type %u\n", cmd->obj);
>  	}
> -- 
> 1.7.10.4
> 
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
