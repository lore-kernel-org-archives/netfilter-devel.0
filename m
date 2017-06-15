From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Thu, 15 Jun 2017 11:46:06 +0200
Message-ID: <20170615094606.GA8817@salvia>
References: <59418f32.1623620a.a2188.374c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46606 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbdFOJq0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 05:46:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5A3AE1228
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:46:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3B07202A0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:46:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7D08100799
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 11:46:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <59418f32.1623620a.a2188.374c@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 15, 2017 at 01:01:57AM +0530, Varsha Rao wrote:
> diff --git a/include/datatype.h b/include/datatype.h
> index 04b7d88..748688e 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -145,7 +145,8 @@ struct datatype {
>  	const char			*desc;
>  	const struct datatype		*basetype;
>  	const char			*basefmt;
> -	void				(*print)(const struct expr *expr);
> +	void				(*print)(const struct expr *expr,
> +						 struct print_ctx *ct);

Could you use:

        struct print_ctx *pctx

instead?

'ct' usually refers to the connection tracking system (ct) in our
codebase, so I would prefer we have a different variable name.

This applies everywhere in this patch.

>  	struct error_record		*(*parse)(const struct expr *sym,
>  						  struct expr **res);
>  	const struct symbol_table	*sym_tbl;
> @@ -157,7 +158,7 @@ extern const struct datatype *datatype_lookup_byname(const char *name);
>  
>  extern struct error_record *symbol_parse(const struct expr *sym,
>  					 struct expr **res);
> -extern void datatype_print(const struct expr *expr);
> +extern void datatype_print(const struct expr *expr, struct print_ctx *ct);
>  
>  static inline bool datatype_equal(const struct datatype *d1,
>  				  const struct datatype *d2)
> @@ -205,7 +206,8 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
>  						    const struct symbol_table *tbl,
>  						    struct expr **res);
>  extern void symbolic_constant_print(const struct symbol_table *tbl,
> -				    const struct expr *expr, bool quotes);
> +				    const struct expr *expr, bool quotes,
> +				    struct print_ctx *ct);
>  extern void symbol_table_print(const struct symbol_table *tbl,
>  			       const struct datatype *dtype,
>  			       enum byteorder byteorder);
> diff --git a/include/expression.h b/include/expression.h
> index 9ba87e8..80f91d0 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -157,7 +157,8 @@ struct expr_ops {
>  	void			(*set_type)(const struct expr *expr,
>  					    const struct datatype *dtype,
>  					    enum byteorder byteorder);
> -	void			(*print)(const struct expr *expr);
> +	void			(*print)(const struct expr *expr,
> +					 struct print_ctx *ct);
>  	bool			(*cmp)(const struct expr *e1,
>  				       const struct expr *e2);
>  	void			(*pctx_update)(struct proto_ctx *ctx,
> @@ -330,7 +331,7 @@ extern struct expr *expr_alloc(const struct location *loc,
>  extern struct expr *expr_clone(const struct expr *expr);
>  extern struct expr *expr_get(struct expr *expr);
>  extern void expr_free(struct expr *expr);
> -extern void expr_print(const struct expr *expr);
> +extern void expr_print(const struct expr *expr, struct print_ctx *ct);
>  extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
>  extern void expr_describe(const struct expr *expr);
>  
> @@ -410,7 +411,7 @@ extern struct expr *list_expr_alloc(const struct location *loc);
>  
>  extern struct expr *set_expr_alloc(const struct location *loc);
>  extern int set_to_intervals(struct list_head *msgs, struct set *set,
> -			    struct expr *init, bool add);
> +			    struct expr *init, bool add, struct print_ctx *ct);

Why do we need this? I think we only need print_ctx for *_print()
functions.

>  extern void interval_map_decompose(struct expr *set);
>  
>  extern struct expr *mapping_expr_alloc(const struct location *loc,
> diff --git a/include/netlink.h b/include/netlink.h
> index 81538ff..0c7cd90 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -213,6 +213,7 @@ struct netlink_mon_handler {
>  	struct netlink_ctx	*ctx;
>  	const struct location	*loc;
>  	bool			cache_needed;
> +	struct print_ctx	*ct;

I think you can place this in 'struct netlink_ctx', see more detailed
comment below.

> diff --git a/include/nftables.h b/include/nftables.h
> index 6f54155..1c747d6 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -24,12 +24,16 @@ enum debug_level {
>  
>  #define INCLUDE_PATHS_MAX	16
>  
> +struct print_ctx {
> +	unsigned int numeric_output;
> +	unsigned int stateless_output;
> +	unsigned int ip2name_output;
> +	unsigned int handle_output;

You can probably remove the trailing "_output" now that this is inside
struct print_ctx, it is obvious they refer to printing toggles.

> +};
> +
>  extern unsigned int max_errors;
> -extern unsigned int numeric_output;
> -extern unsigned int stateless_output;
> -extern unsigned int ip2name_output;
> -extern unsigned int handle_output;
>  extern unsigned int debug_level;
> +
>  extern const char *include_paths[INCLUDE_PATHS_MAX];
>  
>  enum nftables_exit_codes {
> @@ -107,6 +111,7 @@ struct input_descriptor {
>  
>  struct parser_state;
>  
> -int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs);
> +int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
> +	     struct print_ctx *ct);
>  
>  #endif /* NFTABLES_NFTABLES_H */
> diff --git a/include/rule.h b/include/rule.h
> index fb46064..48cb5f1 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -195,7 +195,7 @@ struct rule {
>  extern struct rule *rule_alloc(const struct location *loc,
>  			       const struct handle *h);
>  extern void rule_free(struct rule *rule);
> -extern void rule_print(const struct rule *rule);
> +extern void rule_print(const struct rule *rule, struct print_ctx *ct);
>  extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
>  
>  /**
> @@ -244,7 +244,7 @@ extern void set_add_hash(struct set *set, struct table *table);
>  extern struct set *set_lookup(const struct table *table, const char *name);
>  extern struct set *set_lookup_global(uint32_t family, const char *table,
>  				     const char *name);
> -extern void set_print(const struct set *set);
> +extern void set_print(const struct set *set, struct print_ctx *ct);
>  extern void set_print_plain(const struct set *s);
>  
>  #include <statement.h>
> @@ -292,7 +292,7 @@ void obj_free(struct obj *obj);
>  void obj_add_hash(struct obj *obj, struct table *table);
>  struct obj *obj_lookup(const struct table *table, const char *name,
>  		       uint32_t type);
> -void obj_print(const struct obj *n);
> +void obj_print(const struct obj *n, struct print_ctx *ct);
>  void obj_print_plain(const struct obj *obj);
>  const char *obj_type_name(uint32_t type);
>  
> @@ -475,7 +475,8 @@ extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
>  extern struct error_record *rule_postprocess(struct rule *rule);
>  
>  struct netlink_ctx;
> -extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
> +extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd,
> +		       struct print_ctx *ct);

You can place this in netlink_ctx so...

struct netlink_ctx {
        ...
        struct print_ctx        *pctx;
};

So we can make this patch smaller, you don't need to update that many
functions.

>  extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
>  extern void cache_flush(void);
> diff --git a/include/statement.h b/include/statement.h
> index 317d53e..d6ebc01 100644
> --- a/include/statement.h
> +++ b/include/statement.h
> @@ -261,7 +261,8 @@ struct stmt_ops {
>  	enum stmt_types		type;
>  	const char		*name;
>  	void			(*destroy)(struct stmt *stmt);
> -	void			(*print)(const struct stmt *stmt);
> +	void			(*print)(const struct stmt *stmt,
> +					 struct print_ctx *ct);
>  };
>  
>  enum stmt_flags {
> @@ -312,7 +313,7 @@ extern struct stmt *stmt_alloc(const struct location *loc,
>  int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
>  extern void stmt_free(struct stmt *stmt);
>  extern void stmt_list_free(struct list_head *list);
> -extern void stmt_print(const struct stmt *stmt);
> +extern void stmt_print(const struct stmt *stmt, struct print_ctx *ct);
>  
>  const char *get_rate(uint64_t byte_rate, uint64_t *rate);
>  
> diff --git a/src/cli.c b/src/cli.c
> index a74411a..c91eced 100644
> --- a/src/cli.c
> +++ b/src/cli.c
> @@ -129,7 +129,7 @@ static void cli_complete(char *line)
>  
>  	parser_init(state, &msgs);
>  	scanner_push_buffer(scanner, &indesc_cli, line);
> -	nft_run(scanner, state, &msgs);
> +	nft_run(scanner, state, &msgs, NULL);

I suggest you pass it here as global. Look, the cli code (interactive
mode that you exercise via -i) will not go into libnftables, so it's
fine to to keep it global.
