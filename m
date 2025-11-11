Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7FD1AA7BF
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Nov 2025 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883989; cv=none; b=Cq0gjDfM53zk6DCiyJec/XmUWS+qsBEaycdKjY/ijeBhiuII4N+5tqyW6ypXx/DJfQpcgzI5ttC/ltNiP6735ww257w5cZjCEPxloUVp46NK6iuH79qnTy36AsgSDwBSti60xZUeKbwDt+Hf+TNobBLUuNyZeXpgsNdJY/85xgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883989; c=relaxed/simple;
	bh=fFZBqQuyrZsK6NbXAoJjhtbP53If6z+uH2LXtzr9Ark=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrNvysbDShA+1joD3GZWi4f8CgUqXFqOebXSktNRbSS3yqosuS7Z+oHbn8v4R1r9XA7lexlpY8dEahBYA50ZbyOgXy6LijRWvo6K+ykB2QFaKJsjFwghqVOKweTPiikCxxEHqYyST9/q1hulotIw+PrhKrPux9HkHWlA8pMlNvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JLXFwi1Q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JLXFwi1Q"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 05BCC60273;
	Tue, 11 Nov 2025 18:59:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762883981;
	bh=N85cp4uuf6UDVvNe/i9YP21UO+4kdCmv1vT/NJn3rSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLXFwi1QypTKSFTFLqjS83bIRd4BBr9ZqM1do3G5Y3hzkjM8K4uyLtYhVJVpYTJW1
	 cj4DXnwN+BYAN8ZTNBzGKo77eFhuQLDt7a4jWNOGD2tcE5uS8VId/yys5b2eQkBgZF
	 +SZb27PmG/miEH6hWPiXKo7TIPHG2a+gSlGHlOBYsdPyo66KEa72JvCzQ/8QPVtVvS
	 Z+OkuIjG2X8LRyGIoGWg2ljyYMSkF0CVcslCttfxYtin+3c2S407U0xG0sZXWCK4lq
	 ggeYMHwg2zSJzZj9plZvTB6HXd0pUqK4JvWZL0F5yK+oP/uxquDwv6sDAkaAv06Pyu
	 uAPlNxDQPaxGw==
Date: Tue, 11 Nov 2025 18:59:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] src: add connlimit stateful object support
Message-ID: <aRN5iuGxV6aHn6zA@calendula>
References: <20251104171321.29393-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251104171321.29393-1-fmancera@suse.de>

Hi Fernando,

On Tue, Nov 04, 2025 at 06:13:21PM +0100, Fernando Fernandez Mancera wrote:
> Add support for "ct count" stateful object. E.g
> 
> table ip mytable {
> 	ct count ssh-connlimit { over 4 }
> 	ct count http-connlimit { over 1000 }

For the opposite case, maybe could you use?

	ct count http-connlimit { to 1000 }

because this representation limits a bit its extensibility in the
future:

	ct count http-connlimit { 1000 }

parser can do better with a bit of tokens as context.

I am not expecting any extension 'ct count' on this in 2025, but you
never know what future brings.

>         chain mychain {
>                 type filter hook input priority filter; policy accept;
>                 ct count name tcp dport map { 22 : "ssh-connlimit", 80 : "http-connlimit" } meta mark set 0x1
>         }
> }

For the record, there is one more scenario which is not supported and
that needs a kernel + userspace extension, which is:

        ... ct count map { 0-10 : jump a, 11-20 : jump b, * : jump c }

This is because I _deliberately_ implemented the 'ct count VALUE' as a
statement, not as a expression, because at that time I want to add
support for ct count for dynsets, and only statements are supported
there.

This requires to extend connlimit to have a function to return the
count and stores the value in a DREG.

In userspace, there will be an issue to support this because there is
a shift-reduce conflict in the parser which needs a careful look.

That would complete native 'ct count' support for nftables.

> The kernel code has been there for a long time but never used.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  include/rule.h                | 10 ++++
>  src/cache.c                   |  7 +++
>  src/evaluate.c                |  6 +++
>  src/json.c                    | 13 +++++
>  src/mnl.c                     |  6 +++
>  src/netlink.c                 |  6 +++
>  src/parser_bison.y            | 93 +++++++++++++++++++++++++++++++++--
>  src/parser_json.c             | 34 ++++++++++---
>  src/rule.c                    | 24 +++++++++
>  src/scanner.l                 |  4 +-
>  src/statement.c               |  1 +
>  tests/py/ip/objects.t         |  7 +++
>  tests/py/ip/objects.t.json    | 35 +++++++++++++
>  tests/py/ip/objects.t.payload | 12 +++++
>  tests/py/nft-test.py          |  4 ++
>  15 files changed, 251 insertions(+), 11 deletions(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index e8b3c037..dac6996a 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -489,6 +489,11 @@ struct synproxy {
>  	uint32_t	flags;
>  };
>  
> +struct connlimit {
> +	uint32_t	count;
> +	uint32_t	flags;
> +};
> +
>  struct secmark {
>  	char		ctx[NFT_SECMARK_CTX_MAXLEN];
>  };
> @@ -566,6 +571,7 @@ struct obj {
>  		struct ct_expect	ct_expect;
>  		struct synproxy		synproxy;
>  		struct tunnel		tunnel;
> +		struct connlimit	connlimit;
>  	};
>  };
>  
> @@ -677,6 +683,8 @@ enum cmd_ops {
>   * @CMD_OBJ_TUNNEL:	tunnel
>   * @CMD_OBJ_TUNNELS:	multiple tunnels
>   * @CMD_OBJ_HOOKS:	hooks, used only for dumping
> + * @CMD_OBJ_CONNLIMIT:	connlimit
> + * @CMD_OBJ_CONNLIMITS: connlimits
>   */
>  enum cmd_obj {
>  	CMD_OBJ_INVALID,
> @@ -718,6 +726,8 @@ enum cmd_obj {
>  	CMD_OBJ_TUNNEL,
>  	CMD_OBJ_TUNNELS,
>  	CMD_OBJ_HOOKS,
> +	CMD_OBJ_CONNLIMIT,
> +	CMD_OBJ_CONNLIMITS
>  };
>  
>  struct markup {
> diff --git a/src/cache.c b/src/cache.c
> index 09aa20bf..ccb290c9 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -47,6 +47,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
>  	case CMD_OBJ_CT_EXPECT:
>  	case CMD_OBJ_SYNPROXY:
>  	case CMD_OBJ_FLOWTABLE:
> +	case CMD_OBJ_CONNLIMIT:
>  		flags |= NFT_CACHE_TABLE;
>  		break;
>  	case CMD_OBJ_ELEMENTS:
> @@ -296,6 +297,10 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
>  	case CMD_OBJ_SYNPROXYS:
>  		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_SYNPROXY);
>  		break;
> +	case CMD_OBJ_CONNLIMIT:
> +	case CMD_OBJ_CONNLIMITS:
> +		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_CONNLIMIT);
> +		break;
>  	case CMD_OBJ_RULESET:
>  	default:
>  		flags |= NFT_CACHE_FULL;
> @@ -445,6 +450,8 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
>  	case CMD_OBJ_CT_EXPECTATIONS:
>  	case CMD_OBJ_TUNNEL:
>  	case CMD_OBJ_TUNNELS:
> +	case CMD_OBJ_CONNLIMIT:
> +	case CMD_OBJ_CONNLIMITS:
>  		if (h->table.name &&
>  		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
>  			loc = &h->table.location;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 5a5e6cb5..9d5ec303 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5974,6 +5974,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_CT_EXPECT:
>  	case CMD_OBJ_SYNPROXY:
>  	case CMD_OBJ_TUNNEL:
> +	case CMD_OBJ_CONNLIMIT:
>  		handle_merge(&cmd->object->handle, &cmd->handle);
>  		return obj_evaluate(ctx, cmd->object);
>  	default:
> @@ -6147,6 +6148,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_TUNNEL:
>  		obj_del_cache(ctx, cmd, NFT_OBJECT_TUNNEL);
>  		return 0;
> +	case CMD_OBJ_CONNLIMIT:
> +		obj_del_cache(ctx, cmd, NFT_OBJECT_CONNLIMIT);
>  	default:
>  		BUG("invalid command object type %u", cmd->obj);
>  	}
> @@ -6279,6 +6282,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
>  		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
>  	case CMD_OBJ_SYNPROXY:
>  		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
> +	case CMD_OBJ_CONNLIMIT:
> +		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CONNLIMIT);
>  	case CMD_OBJ_COUNTERS:
>  	case CMD_OBJ_QUOTAS:
>  	case CMD_OBJ_CT_HELPERS:
> @@ -6287,6 +6292,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_FLOWTABLES:
>  	case CMD_OBJ_SECMARKS:
>  	case CMD_OBJ_SYNPROXYS:
> +	case CMD_OBJ_CONNLIMITS:
>  	case CMD_OBJ_CT_TIMEOUTS:
>  	case CMD_OBJ_CT_EXPECTATIONS:
>  		if (cmd->handle.table.name == NULL)
> diff --git a/src/json.c b/src/json.c
> index 9fb6d715..968a932c 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -572,6 +572,15 @@ static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj,
>  		json_object_update(root, tmp);
>  		json_decref(tmp);
>  		break;
> +	case NFT_OBJECT_CONNLIMIT:
> +		tmp = json_pack("{s:i}", "val", obj->connlimit.count);
> +
> +		if (obj->connlimit.flags & NFT_CONNLIMIT_F_INV)
> +			json_object_set_new(root, "inv", json_true());
> +
> +		json_object_update(root, tmp);
> +		json_decref(tmp);
> +		break;
>  	}
>  
>  out:
> @@ -2132,6 +2141,10 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_TUNNELS:
>  		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_TUNNEL);
>  		break;
> +	case CMD_OBJ_CONNLIMIT:
> +	case CMD_OBJ_CONNLIMITS:
> +		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CONNLIMIT);
> +		break;
>  	case CMD_OBJ_FLOWTABLE:
>  		root = do_list_flowtable_json(ctx, cmd, table);
>  		break;
> diff --git a/src/mnl.c b/src/mnl.c
> index 0a445189..0de122a3 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -1733,6 +1733,12 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  		}
>  		obj_tunnel_add_opts(nlo, &obj->tunnel);
>  		break;
> +	case NFT_OBJECT_CONNLIMIT:
> +		nftnl_obj_set_u32(nlo, NFTNL_OBJ_CONNLIMIT_COUNT,
> +				  obj->connlimit.count);
> +		nftnl_obj_set_u32(nlo, NFTNL_OBJ_CONNLIMIT_FLAGS,
> +				  obj->connlimit.flags);
> +		break;
>  	default:
>  		BUG("Unknown type %d", obj->type);
>  		break;
> diff --git a/src/netlink.c b/src/netlink.c
> index 26cf07c3..8a0482c6 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -2051,6 +2051,12 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
>  			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
>  		}
>  		break;
> +	case NFT_OBJECT_CONNLIMIT:
> +		obj->connlimit.count =
> +			nftnl_obj_get_u32(nlo, NFTNL_OBJ_CONNLIMIT_COUNT);
> +		obj->connlimit.flags =
> +			nftnl_obj_get_u32(nlo, NFTNL_OBJ_CONNLIMIT_FLAGS);
> +		break;
>  	default:
>  		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
>  		obj_free(obj);
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 52730f71..8dbe0010 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -634,6 +634,7 @@ int nft_lex(void *, void *, void *);
>  %token LIMITS			"limits"
>  %token TUNNELS			"tunnels"
>  %token SYNPROXYS		"synproxys"
> +%token COUNTS			"counts"
>  %token HELPERS			"helpers"
>  
>  %token LOG			"log"
> @@ -786,7 +787,7 @@ int nft_lex(void *, void *, void *);
>  %type <flowtable>		flowtable_block_alloc flowtable_block
>  %destructor { flowtable_free($$); }	flowtable_block_alloc
>  
> -%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc
> +%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc connlimit_block
>  %destructor { obj_free($$); }	obj_block_alloc
>  
>  %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
> @@ -905,8 +906,8 @@ int nft_lex(void *, void *, void *);
>  %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
>  %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
>  
> -%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
> -%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
> +%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj connlimit_obj
> +%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj connlimit_obj
>  
>  %type <expr>			relational_expr
>  %destructor { expr_free($$); }	relational_expr
> @@ -1330,6 +1331,10 @@ add_cmd			:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TUNNEL, &$2, &@$, $3);
>  			}
> +			|	CT	COUNT	obj_spec	connlimit_obj	'{' connlimit_block '}' close_scope_ct
> +			{
> +				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CONNLIMIT, &$3, &@$, $4);
> +			}
>  			;
>  
>  replace_cmd		:	RULE		ruleid_spec	rule
> @@ -1437,6 +1442,10 @@ create_cmd		:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TUNNEL, &$2, &@$, $3);
>  			}
> +			|	CT	COUNT	obj_spec	connlimit_obj	'{' connlimit_block '}' close_scope_ct
> +			{
> +				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_CONNLIMIT, &$3, &@$, $4);
> +			}
>  			;
>  
>  insert_cmd		:	RULE		rule_position	rule
> @@ -1538,6 +1547,10 @@ delete_cmd		:	TABLE		table_or_id_spec
>  			{
>  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
>  			}
> +			|	CT	COUNT	obj_or_id_spec	close_scope_ct
> +			{
> +				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
> +			}
>  			;
>  
>  destroy_cmd		:	TABLE		table_or_id_spec
> @@ -1609,6 +1622,10 @@ destroy_cmd		:	TABLE		table_or_id_spec
>  			{
>  				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
>  			}
> +			|	CT	COUNT	obj_or_id_spec	close_scope_ct
> +			{
> +				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
> +			}
>  			;
>  
>  
> @@ -1737,6 +1754,15 @@ list_cmd		:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_HOOKS, &$2, &@$, NULL);
>  			}
> +			|	CT	COUNT	obj_spec	close_scope_ct
> +			{
> +				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
> +			}
> +			|	CT	COUNTS	list_cmd_spec_any
> +			{
> +
> +				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CONNLIMITS, &$3, &@$, NULL);
> +			}
>  			;
>  
>  basehook_device_name	:	DEVICE STRING
> @@ -2099,6 +2125,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
>  				list_add_tail(&$4->list, &$1->objs);
>  				$$ = $1;
>  			}
> +			|	table_block	CT	COUNT	obj_identifier
> +					obj_block_alloc '{'	connlimit_block	 '}'
> +					stmt_separator	close_scope_ct
> +			{
> +				$5->location = @4;
> +				$5->type = NFT_OBJECT_CONNLIMIT;
> +				handle_merge(&$5->handle, &$4);
> +				handle_free(&$4);
> +				list_add_tail(&$5->list, &$1->objs);
> +				$$ = $1;
> +			}
>  			;
>  
>  chain_block_alloc	:	/* empty */
> @@ -2328,6 +2365,7 @@ map_block_alloc		:	/* empty */
>  
>  ct_obj_type_map		: 	TIMEOUT		{ $$ = NFT_OBJECT_CT_TIMEOUT; }
>  			|	EXPECTATION	{ $$ = NFT_OBJECT_CT_EXPECT; }
> +			|	COUNT		{ $$ = NFT_OBJECT_CONNLIMIT; }
>  			;
>  
>  map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
> @@ -2670,6 +2708,23 @@ ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
>  			}
>  			;
>  
> +connlimit_block		:	/* empty */	{ $$ = $<obj>-1; }
> +			|       connlimit_block     common_block
> +			|       connlimit_block     stmt_separator
> +			|       connlimit_block     connlimit_config
> +			{
> +				$$ = $1;
> +			}
> +			|       connlimit_block     comment_spec
> +			{
> +				if (already_set($<obj>1->comment, &@2, state)) {
> +					free_const($2);
> +					YYERROR;
> +				}
> +				$<obj>1->comment = $2;
> +			}
> +			;
> +
>  limit_block		:	/* empty */	{ $$ = $<obj>-1; }
>  			|       limit_block     common_block
>  			|       limit_block     stmt_separator
> @@ -3236,6 +3291,12 @@ objref_stmt_ct		:	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
>  				$$->objref.type = NFT_OBJECT_CT_EXPECT;
>  				$$->objref.expr = $4;
>  			}
> +			|	CT	COUNT	NAME	stmt_expr	close_scope_ct
> +			{
> +				$$ = objref_stmt_alloc(&@$);
> +				$$->objref.type = NFT_OBJECT_CONNLIMIT;
> +				$$->objref.expr = $4;
> +			}
>  			;
>  
>  objref_stmt		:	objref_stmt_counter
> @@ -3351,6 +3412,32 @@ ct_limit_stmt_alloc	:	CT	COUNT
>  			}
>  			;
>  
> +connlimit_obj		:	/* empty */
> +			{
> +				$$ = obj_alloc(&@$);
> +				$$->type = NFT_OBJECT_CONNLIMIT;
> +			}
> +			;
> +
> +connlimit_config	:	NUM
> +			{
> +				struct connlimit *connlimit;
> +
> +				connlimit = &$<obj>0->connlimit;
> +				connlimit->count = $1;
> +				connlimit->flags = 0;
> +
> +			}
> +			|	OVER	NUM
> +			{
> +				struct connlimit *connlimit;
> +
> +				connlimit = &$<obj>0->connlimit;
> +				connlimit->count = $2;
> +				connlimit->flags = NFT_CONNLIMIT_F_INV;
> +			}
> +			;
> +
>  connlimit_stmt		:	ct_limit_stmt_alloc	ct_limit_args
>  			;
>  
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 7b4f3384..987d8781 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -2835,17 +2835,26 @@ static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
>  					      const char *key, json_t *value)
>  {
>  	struct stmt *stmt = connlimit_stmt_alloc(int_loc);
> +	uint32_t tmp;
> +
> +	if (!json_unpack(value, "{s:i}", "val", &tmp)) {
> +		stmt = connlimit_stmt_alloc(int_loc);
> +		stmt->connlimit.count = tmp;
> +		json_unpack(value, "{s:b}", "inv", &stmt->connlimit.flags);
> +		if (stmt->connlimit.flags)
> +			stmt->connlimit.flags = NFT_CONNLIMIT_F_INV;
> +		return stmt;
> +	}
>  
> -	if (json_unpack_err(ctx, value, "{s:i}",
> -			    "val", &stmt->connlimit.count)) {
> +	stmt = objref_stmt_alloc(int_loc);
> +	stmt->objref.type = NFT_OBJECT_CONNLIMIT;
> +	stmt->objref.expr = json_parse_stmt_expr(ctx, value);
> +	if (!stmt->objref.expr) {
> +		json_error(ctx, "Invalid connlimit reference.");
>  		stmt_free(stmt);
>  		return NULL;
>  	}
>  
> -	json_unpack(value, "{s:b}", "inv", &stmt->connlimit.flags);
> -	if (stmt->connlimit.flags)
> -		stmt->connlimit.flags = NFT_CONNLIMIT_F_INV;
> -
>  	return stmt;
>  }
>  
> @@ -3249,6 +3258,7 @@ static int string_to_nft_object(const char *str)
>  		[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
>  		[NFT_OBJECT_SYNPROXY]	= "synproxy",
>  		[NFT_OBJECT_TUNNEL]	= "tunnel",
> +		[NFT_OBJECT_CONNLIMIT]	= "ct count",
>  	};
>  	unsigned int i;
>  
> @@ -3946,6 +3956,15 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
>  			break;
>  		}
>  		break;
> +	case CMD_OBJ_CONNLIMIT:
> +		obj->type = NFT_OBJECT_CONNLIMIT;
> +		if (json_unpack_err(ctx, root, "{s:i}", "val", &obj->connlimit.count))
> +			goto err_free_obj;
> +
> +		json_unpack(root, "{s:b}", "inv", &obj->connlimit.flags);
> +		if (obj->connlimit.flags)
> +			obj->connlimit.flags = NFT_CONNLIMIT_F_INV;
> +		break;
>  	default:
>  		BUG("Invalid CMD '%d'", cmd_obj);
>  	}
> @@ -3985,7 +4004,8 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
>  		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
>  		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
>  		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
> -		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
> +		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object },
> +		{ "ct count", CMD_OBJ_CONNLIMIT, json_parse_cmd_add_object },
>  	};
>  	unsigned int i;
>  	json_t *tmp;
> diff --git a/src/rule.c b/src/rule.c
> index bb6f62c8..c5ef0cdd 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1454,6 +1454,7 @@ void cmd_free(struct cmd *cmd)
>  		case CMD_OBJ_SECMARK:
>  		case CMD_OBJ_SYNPROXY:
>  		case CMD_OBJ_TUNNEL:
> +		case CMD_OBJ_CONNLIMIT:
>  			obj_free(cmd->object);
>  			break;
>  		case CMD_OBJ_FLOWTABLE:
> @@ -1555,6 +1556,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
>  	case CMD_OBJ_SECMARK:
>  	case CMD_OBJ_SYNPROXY:
>  	case CMD_OBJ_TUNNEL:
> +	case CMD_OBJ_CONNLIMIT:
>  		return mnl_nft_obj_add(ctx, cmd, flags);
>  	case CMD_OBJ_FLOWTABLE:
>  		return mnl_nft_flowtable_add(ctx, cmd, flags);
> @@ -1637,6 +1639,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
>  		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SYNPROXY);
>  	case CMD_OBJ_TUNNEL:
>  		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_TUNNEL);
> +	case CMD_OBJ_CONNLIMIT:
> +		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CONNLIMIT);
>  	case CMD_OBJ_FLOWTABLE:
>  		return mnl_nft_flowtable_del(ctx, cmd);
>  	default:
> @@ -2140,6 +2144,21 @@ static void obj_print_data(const struct obj *obj,
>  			break;
>  		}
>  
> +		nft_print(octx, "%s", opts->stmt_separator);
> +		break;
> +	case NFT_OBJECT_CONNLIMIT:
> +		nft_print(octx, " %s {", obj->handle.obj.name);
> +		if (nft_output_handle(octx))
> +			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
> +
> +		obj_print_comment(obj, opts, octx);
> +
> +		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
> +		if (obj->connlimit.flags & NFT_CONNLIMIT_F_INV)
> +			nft_print(octx, "over %u", obj->connlimit.count);
> +		else
> +			nft_print(octx, "%u", obj->connlimit.count);
> +
>  		nft_print(octx, "%s", opts->stmt_separator);
>  		break;
>  	default:
> @@ -2158,6 +2177,7 @@ static const char * const obj_type_name_array[] = {
>  	[NFT_OBJECT_SYNPROXY]	= "synproxy",
>  	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
>  	[NFT_OBJECT_TUNNEL]	= "tunnel",
> +	[NFT_OBJECT_CONNLIMIT]	= "ct count"
>  };
>  
>  const char *obj_type_name(unsigned int type)
> @@ -2177,6 +2197,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
>  	[NFT_OBJECT_SYNPROXY]	= CMD_OBJ_SYNPROXY,
>  	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
>  	[NFT_OBJECT_TUNNEL]	= CMD_OBJ_TUNNEL,
> +	[NFT_OBJECT_CONNLIMIT]	= CMD_OBJ_CONNLIMIT,
>  };
>  
>  enum cmd_obj obj_type_to_cmd(uint32_t type)
> @@ -2651,6 +2672,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
>  	case CMD_OBJ_TUNNEL:
>  	case CMD_OBJ_TUNNELS:
>  		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
> +	case CMD_OBJ_CONNLIMIT:
> +	case CMD_OBJ_CONNLIMITS:
> +		return do_list_obj(ctx, cmd, NFT_OBJECT_CONNLIMIT);
>  	case CMD_OBJ_FLOWTABLE:
>  		return do_list_flowtable(ctx, cmd, table);
>  	case CMD_OBJ_FLOWTABLES:
> diff --git a/src/scanner.l b/src/scanner.l
> index 8085c93b..824413bf 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -406,11 +406,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  	"synproxys"		{ return SYNPROXYS; }
>  	"tunnel"		{ return TUNNEL; }
>  	"tunnels"		{ return TUNNELS; }
> +	"count"			{ return COUNT; }
> +	"counts"		{ return COUNTS; }
>  	"hooks"			{ return HOOKS; }
>  }
>  
>  "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
> -<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"			{ return NAME; }
> +<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL,SCANSTATE_CT>"name"	{ return NAME; }
>  <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
>  <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
>  
> diff --git a/src/statement.c b/src/statement.c
> index d0993dde..9cfbe9b3 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -295,6 +295,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
>  	[NFT_OBJECT_SECMARK]	= "secmark",
>  	[NFT_OBJECT_SYNPROXY]	= "synproxy",
>  	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
> +	[NFT_OBJECT_CONNLIMIT]	= "ct count",
>  };
>  
>  const char *objref_type_name(uint32_t type)
> diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
> index 71d5ffe4..fb4a5e3e 100644
> --- a/tests/py/ip/objects.t
> +++ b/tests/py/ip/objects.t
> @@ -56,3 +56,10 @@ ct expectation set "ctexpect1";ok
>  %synproxy2 type synproxy mss 1460 wscale 7 timestamp sack-perm;ok
>  
>  synproxy name tcp dport map {443 : "synproxy1", 80 : "synproxy2"};ok
> +
> +# connlimit
> +%connlimit1 type ct count { over 5 };ok
> +%connlimit2 type ct count { 4 };ok
> +
> +ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"};ok
> +ct count name "connlimit1";ok
> diff --git a/tests/py/ip/objects.t.json b/tests/py/ip/objects.t.json
> index a70dd9e2..1cc16376 100644
> --- a/tests/py/ip/objects.t.json
> +++ b/tests/py/ip/objects.t.json
> @@ -227,3 +227,38 @@
>          }
>      }
>  ]
> +
> +# ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"}
> +[
> +    {
> +        "ct count": {
> +            "map": {
> +                "data": {
> +                    "set": [
> +                        [
> +                            22,
> +                            "connlimit1"
> +                        ],
> +                        [
> +                            80,
> +                            "connlimit2"
> +                        ]
> +                    ]
> +                },
> +                "key": {
> +                    "payload": {
> +                        "field": "dport",
> +                        "protocol": "tcp"
> +                    }
> +                }
> +            }
> +        }
> +    }
> +]
> +
> +# ct count name "connlimit1"
> +[
> +    {
> +        "ct count": "connlimit1"
> +    }
> +]
> diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
> index 3da4b285..cce99a45 100644
> --- a/tests/py/ip/objects.t.payload
> +++ b/tests/py/ip/objects.t.payload
> @@ -77,3 +77,15 @@ ip test-ip4 input
>    [ cmp eq reg 1 0x00000006 ]
>    [ payload load 2b @ transport header + 2 => reg 1 ]
>    [ objref sreg 1 set __objmap%d ]
> +
> +# ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"}
> +        element 00001600  : 0 [end]     element 00005000  : 0 [end]
> +ip test-ip4 input
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ objref sreg 1 set __objmap%d ]
> +
> +# ct count name "connlimit1"
> +ip test-ip4 input
> +  [ objref type 5 name connlimit1 ]
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index ff2412ac..de4860f8 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1254,6 +1254,10 @@ def obj_process(obj_line, filename, lineno):
>         obj_type = "ct expectation"
>         tokens[3] = ""
>  
> +    if obj_type == "ct" and tokens[3] == "count":
> +       obj_type = "ct count"
> +       tokens[3] = ""
> +
>      if len(tokens) > 3:
>          obj_spcf = " ".join(tokens[3:])
>  
> -- 
> 2.51.0
> 
> 
