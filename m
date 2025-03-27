Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41F19B3EE
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090597; cv=none; b=Ya+MD6+N3xXanasGnVQhVjFqC9Z+FHH92Mwmqs4maqJT6vtSESut/gvkegPij/CVBCQyr2rnpIXQFhgYCujUVmov2I1rd+nxC7HzsVQKvYn5uXSxCwdgqizJFkwfeCT2KGudi989W64BUZEhphLHLgBvOUdt7GzHPOZtsnlvH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090597; c=relaxed/simple;
	bh=wxi4LyBmyvIgDkkO/XJVe6UHv5EK/WNdUuqUQMxTwi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAP2PvrN7cGMPlcM9NEpDIkjxNrowerJJrEyU6tV5/dCxrVygmiip9fy8dCd5eepd0M62JQEI10dmZXikyBkObiT3asFnhTMYMEUweW5/EwlWfPUONI7965Y7GZaLGIDeFw01xC39hcucE035AWWj5XqZCldfxWVMI6UK1MLDdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v0qshVRp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v0qshVRp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v0qshVRp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v0qshVRp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C300F606AC; Thu, 27 Mar 2025 16:49:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090593;
	bh=i2Wj/k62XMEB1kZCJng5za/KhWOjRWEzInH6Cs8Vgpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v0qshVRpxc9SrDufbvgBywL6fzUvzczvHNKFbjfFqT0cdu3HZPr0UwOCRBTHRc/nW
	 0y2C3/anjvSwkdJhv5WnHyYBzwDxH8Pmy6K4JbcNuv+V5aUqlxhB5+z5msLCXybba8
	 zBQj/r6d9olwBdWb65Cy98oicnuhaAdDN0f/FJ4tZkcKyU5LFqLFn+XbElLCu4ksv7
	 r1Jr49jhwLvLiuZs/Yui0glwmsmaAP28ILVFWKjR1CwNQN2lng4LytvJJzgmmBOzTD
	 3Rr1PLIE2YIzoXrp0XvKPjGCPYsVuUcp9s65/k0/FfEcieGexda8JR5C1Jgyp8dpQ8
	 fhsLaXSR65frg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 07401606A5;
	Thu, 27 Mar 2025 16:49:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743090593;
	bh=i2Wj/k62XMEB1kZCJng5za/KhWOjRWEzInH6Cs8Vgpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v0qshVRpxc9SrDufbvgBywL6fzUvzczvHNKFbjfFqT0cdu3HZPr0UwOCRBTHRc/nW
	 0y2C3/anjvSwkdJhv5WnHyYBzwDxH8Pmy6K4JbcNuv+V5aUqlxhB5+z5msLCXybba8
	 zBQj/r6d9olwBdWb65Cy98oicnuhaAdDN0f/FJ4tZkcKyU5LFqLFn+XbElLCu4ksv7
	 r1Jr49jhwLvLiuZs/Yui0glwmsmaAP28ILVFWKjR1CwNQN2lng4LytvJJzgmmBOzTD
	 3Rr1PLIE2YIzoXrp0XvKPjGCPYsVuUcp9s65/k0/FfEcieGexda8JR5C1Jgyp8dpQ8
	 fhsLaXSR65frg==
Date: Thu, 27 Mar 2025 16:49:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: don't BUG when asked to list synproxies
Message-ID: <Z-VznsYAZ06V7-EI@calendula>
References: <20250324115339.11642-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250324115339.11642-1-fw@strlen.de>

On Mon, Mar 24, 2025 at 12:53:36PM +0100, Florian Westphal wrote:
> "-j list synproxys" triggers a BUG().
> 
> Rewrite this so that all enum values are handled so the compiler can alert
> us to a missing value in case there are more commands in the future.
> 
> While at it, implement a few low-hanging fruites as well.
> 
> Not-yet-supported cases are simply ignored.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c |  6 ++++--
>  src/json.c     | 24 ++++++++++++++++++++++--
>  src/rule.c     | 11 +++++++++--
>  3 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 785c4fab6b3a..1e7f6f53542b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -6323,7 +6323,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
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
> index 96413d70895a..f92f86bbc974 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1971,7 +1971,7 @@ static json_t *generate_json_metainfo(void)
>  int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  {
>  	struct table *table = NULL;
> -	json_t *root;
> +	json_t *root = NULL;
>  
>  	if (cmd->handle.table.name)
>  		table = table_cache_find(&ctx->nft->cache.table_cache,
> @@ -2026,6 +2026,13 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
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
> @@ -2034,14 +2041,27 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
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
> +	case CMD_OBJ_MONITOR:
> +	case CMD_OBJ_MARKUP:
> +	case CMD_OBJ_SETELEMS:
> +	case CMD_OBJ_RULE:
> +	case CMD_OBJ_EXPR:
> +	case CMD_OBJ_ELEMENTS:
> +		return 0;
> +	case CMD_OBJ_INVALID:
>  		BUG("invalid command object type %u\n", cmd->obj);
> +		break;
>  	}
>  
>  	if (!json_is_array(root)) {
> diff --git a/src/rule.c b/src/rule.c
> index 00fbbc4c080a..cf895a5acf5b 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -2445,10 +2445,17 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
>  		return do_list_flowtables(ctx, cmd);
>  	case CMD_OBJ_HOOKS:
>  		return do_list_hooks(ctx, cmd);
> -	default:
> -		BUG("invalid command object type %u\n", cmd->obj);
> +	case CMD_OBJ_MONITOR:

monitor with list make no sense, maybe report error here instead.

> +	case CMD_OBJ_MARKUP:

CMD_OBJ_MARKUP is obsolete / early xml support that was removed, this
has been deprecated for long time, I can follow up to remove it in a
follow up patch, there is just a few remaining scaffolding around
this.

> +	case CMD_OBJ_SETELEMS:

this is an internal command, it should not ever be seen in this path.

> +	case CMD_OBJ_EXPR:

This is for the describe command, it can never happen with list.

> +	case CMD_OBJ_ELEMENTS:

support for add, get, delete and destroy.

... In summary, I would return here:

                errno = EOPNOTSUPP;
                return -1;

Agreed?

> +		return 0;
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
