Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0EE17A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743107484; cv=none; b=mseFJRqiCRDvmx3XWQnJQ8/UKCXm/Hz1uty6dOEFTdVIU4Qm4knZkxTbwhTLp5+2YzHX5LvigWbx8kZ+Xb4yVY2M2EcJAc4POhycbc0Eh3YDghEtcmAqsRXOT9E3eBb1p1i//lvEKwZHle808KWOuxb/XmE9+OqHiIZYmg/xu+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743107484; c=relaxed/simple;
	bh=gooWf8gkxeavLt5mZ3Q12gCEuiimUn4sNi1z2RyqwNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8azma992VuZf9SVz2jYagFEcaKUybxg355DzgyN6bMVa+LibOpDBKm45PPiHDauO4TTSLL9CNGIl7Xcyps9/DRRA8IDKpbbsg4wUdD76Mrykzs/x2tCS5/oGZskdst9fQgxnI1LrHdej1qJo4SktRbkt1o2PDB/vUDHDwkXhdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mzgPK5Nu; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=StnSyFmT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mzgPK5Nu";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="StnSyFmT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6A859605D7; Thu, 27 Mar 2025 21:31:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743107473;
	bh=0ZghTgE7HmD53z4iwi8VPSYBY5KDK9zUNV631NQwt6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mzgPK5NuIe9Ity99+Cu5t2SdW8iyfGy6EbWIn2J/fpKpyj3IekbfeC/r2K63HDoto
	 K9x5eqC+z07B8G060knHJk6mQIhqp3ecfPVxIj5JDsfuiwnm5D+8VO6hbY0nDrIbHt
	 u6TOpWCNhbKneESZllbHP8YV4rJy6J4UBcGiAKUdj5Ooyg8uzY1uaZakfKkEV8TXHJ
	 QHwzfGDNRSb57eMs3NSJSTj8qVJZHkPjBhIu+C1TKLWzHQTcmoPzwECrXW/mWoJN27
	 yC5bALtFM27k7+z2MCJUUKxBukgADJCuSR/nZReoAHXSd2UV3Vx4mzMidgt4aQdykv
	 c+i7BdKj04rig==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 50888605C8;
	Thu, 27 Mar 2025 21:31:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743107471;
	bh=0ZghTgE7HmD53z4iwi8VPSYBY5KDK9zUNV631NQwt6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=StnSyFmT7gy5VkSINcLqTFFyrqnM/fmmmVB7tfRBzTqS10C+Ql6/Ge+XnLy4PoXRt
	 fM/OoXO1CNe801VokL1jdnQCev+0EPIA4WCq6afO6hx2bAg+x4S8dq6qaKym5NzP1A
	 tGyAmBI+aI4ud+ZM138lyH7f5fJDNnGEPweiTmubIJG3A4ZGH4TgN2AvBlTvjPZqM1
	 974mqLsDlqDV5Qn0zPiShD0XM9pBab7LbyndDbZQVelVn+0JH//9myzuw9bhnxVcdM
	 Clvql5tXsLn8dRbGm2fR2WiqIAJm4gO3jnLFOIq9kWlYQ/452Nh8G8hBQdirDhl/q3
	 zBWtEcIlroHjw==
Date: Thu, 27 Mar 2025 21:31:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] json: don't BUG when asked to list synproxies
Message-ID: <Z-W1jGIb0wGDQ0nL@calendula>
References: <20250327163203.26366-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250327163203.26366-1-fw@strlen.de>

On Thu, Mar 27, 2025 at 05:32:00PM +0100, Florian Westphal wrote:
> "-j list synproxys" triggers a BUG().
> 
> Rewrite this so that all enum values are handled so the compiler can alert
> us to a missing value in case there are more commands in the future.
> 
> While at it, implement a few low-hanging fruites as well.
> 
> Not-yet-supported cases are simply ignored.
> 
> v2: return EOPNOTSUPP for unsupported commands (Pablo Neira Ayuso)
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  src/evaluate.c |  6 ++++--
>  src/json.c     | 26 ++++++++++++++++++++++++--
>  src/rule.c     | 12 ++++++++++--
>  3 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index bd99e33971f7..a6b08cf3b1b5 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -6329,7 +6329,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
>  		return cmd_evaluate_monitor(ctx, cmd);
>  	case CMD_IMPORT:
>  		return cmd_evaluate_import(ctx, cmd);
> -	default:
> -		BUG("invalid command operation %u\n", cmd->op);
> +	case CMD_INVALID:
> +		break;
>  	};
> +
> +	BUG("invalid command operation %u\n", cmd->op);
>  }
> diff --git a/src/json.c b/src/json.c
> index 831bc90f0833..adebe47980b9 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1971,7 +1971,7 @@ static json_t *generate_json_metainfo(void)
>  int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  {
>  	struct table *table = NULL;
> -	json_t *root;
> +	json_t *root = NULL;
>  
>  	if (cmd->handle.table.name) {
>  		table = table_cache_find(&ctx->nft->cache.table_cache,
> @@ -2031,6 +2031,13 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_CT_HELPERS:
>  		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_HELPER);
>  		break;
> +	case CMD_OBJ_CT_TIMEOUT:
> +	case CMD_OBJ_CT_TIMEOUTS:
> +		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
> +	case CMD_OBJ_CT_EXPECT:
> +	case CMD_OBJ_CT_EXPECTATIONS:
> +		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_EXPECT);
> +		break;
>  	case CMD_OBJ_LIMIT:
>  	case CMD_OBJ_LIMITS:
>  		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_LIMIT);
> @@ -2039,14 +2046,29 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_SECMARKS:
>  		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SECMARK);
>  		break;
> +	case CMD_OBJ_SYNPROXY:
> +	case CMD_OBJ_SYNPROXYS:
> +		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SYNPROXY);
> +		break;
>  	case CMD_OBJ_FLOWTABLE:
>  		root = do_list_flowtable_json(ctx, cmd, table);
>  		break;
>  	case CMD_OBJ_FLOWTABLES:
>  		root = do_list_flowtables_json(ctx, cmd);
>  		break;
> -	default:
> +	case CMD_OBJ_HOOKS:
> +		return 0;
> +	case CMD_OBJ_MONITOR:
> +	case CMD_OBJ_MARKUP:
> +	case CMD_OBJ_SETELEMS:
> +	case CMD_OBJ_RULE:
> +	case CMD_OBJ_EXPR:
> +	case CMD_OBJ_ELEMENTS:
> +		errno = EOPNOTSUPP;
> +		return -1;
> +	case CMD_OBJ_INVALID:
>  		BUG("invalid command object type %u\n", cmd->obj);
> +		break;
>  	}
>  
>  	if (!json_is_array(root)) {
> diff --git a/src/rule.c b/src/rule.c
> index 00fbbc4c080a..80315837baf0 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -2445,10 +2445,18 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
>  		return do_list_flowtables(ctx, cmd);
>  	case CMD_OBJ_HOOKS:
>  		return do_list_hooks(ctx, cmd);
> -	default:
> -		BUG("invalid command object type %u\n", cmd->obj);
> +	case CMD_OBJ_MONITOR:
> +	case CMD_OBJ_MARKUP:
> +	case CMD_OBJ_SETELEMS:
> +	case CMD_OBJ_EXPR:
> +	case CMD_OBJ_ELEMENTS:
> +		errno = EOPNOTSUPP;
> +		return -1;
> +	case CMD_OBJ_INVALID:
> +		break;
>  	}
>  
> +	BUG("invalid command object type %u\n", cmd->obj);
>  	return 0;
>  }
>  
> -- 
> 2.48.1
> 
> 
