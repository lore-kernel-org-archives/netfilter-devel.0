From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 1/2] src: Allow reset single stateful object
Date: Tue, 24 Jan 2017 19:54:08 +0100
Message-ID: <20170124185408.GA9531@salvia>
References: <20170124134117.GA1673@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdAXSyN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:54:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAEDA1EC2D5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:54:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D516EA7DB0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:54:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C4DEA7BF4
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:54:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170124134117.GA1673@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Elise,

comments below.

On Tue, Jan 24, 2017 at 11:41:17AM -0200, Elise Lennion wrote:
> Currently the stateful objects can only be reseted in groups. With this
> patch reseting a single object is allowed:
> 
> $ nft reset counter filter https-traffic
> table ip filter {
> 	counter https-traffic {
> 		packets 8774 bytes 542668
> 	}
> }
> 
> $ nft list counter filter https-traffic
> table ip filter {
> 	counter https-traffic {
> 		packets 0 bytes 0
> 	}
> }
> 
> Only the tables with reseted objects will be listed. Same goes for the
> command list, i.e. tables without quota objects aren't printed on
> 'list quotas', same for counters.
> 
> Heavily based on work from Pablo Neira Ayuso <pablo@netfilter.org>.
> 
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
> 
>  v2: Only list tables with counters and quotas that are reseted, on v1
>  tables without stateful object were listed.
> 
>  include/mnl.h      |  4 ++--
>  include/netlink.h  |  3 ++-
>  src/evaluate.c     | 28 +++++++++++++++++++++++++++-
>  src/mnl.c          |  9 ++++++---
>  src/netlink.c      |  9 +++++----
>  src/parser_bison.y |  8 ++++++++
>  src/rule.c         | 21 ++++++++++++++++-----
>  7 files changed, 66 insertions(+), 16 deletions(-)
> 
> diff --git a/include/mnl.h b/include/mnl.h
> index 4a99972..69dd0b7 100644
> --- a/include/mnl.h
> +++ b/include/mnl.h
> @@ -87,8 +87,8 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
>  int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
>  
>  struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
> -					const char *table, uint32_t type,
> -					bool reset);
> +					const char *table, const char *name,
> +					uint32_t type, bool dump, bool reset);
>  int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
>  			  uint32_t seqnum);
>  int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
> diff --git a/include/netlink.h b/include/netlink.h
> index 450aba5..d3fb8c5 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -172,7 +172,8 @@ extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *
>  extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
>  			     const struct location *loc);
>  extern int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
> -			      const struct location *loc, uint32_t type);
> +			      const struct location *loc, uint32_t type,
> +			      bool dump);
>  extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
>  			   struct obj *obj, bool excl);
>  extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
> diff --git a/src/evaluate.c b/src/evaluate.c
> index bcbced1..9a9927b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2949,6 +2949,31 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
>  	}
>  }
>  
> +static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
> +{
> +	struct table *table;
> +	int ret;
> +
> +	ret = cache_update(cmd->op, ctx->msgs);
> +	if (ret < 0)
> +		return ret;

I think we only need the cache_update() in the _COUNTERS, _QUOTAS
case.

> +
> +	switch (cmd->obj) {
> +	case CMD_OBJ_COUNTER:
> +	case CMD_OBJ_QUOTA:
> +		table = table_lookup(&cmd->handle);
> +		if (table == NULL)
> +			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
> +					 cmd->handle.table);
> +		return 0;
> +	case CMD_OBJ_COUNTERS:
> +	case CMD_OBJ_QUOTAS:
> +		return 0;
> +	default:
> +		BUG("invalid command object type %u\n", cmd->obj);
> +	}
> +}
> +
>  static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
>  {
>  	int ret;
> @@ -3140,8 +3165,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
>  	case CMD_DELETE:
>  		return cmd_evaluate_delete(ctx, cmd);
>  	case CMD_LIST:
> -	case CMD_RESET:
>  		return cmd_evaluate_list(ctx, cmd);
> +	case CMD_RESET:
> +		return cmd_evaluate_reset(ctx, cmd);
>  	case CMD_FLUSH:
>  		return cmd_evaluate_flush(ctx, cmd);
>  	case CMD_RENAME:
> diff --git a/src/mnl.c b/src/mnl.c
> index 1c4b070..295dd84 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -849,8 +849,9 @@ err_free:
>  
>  struct nftnl_obj_list *
>  mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
> -		 uint32_t type, bool reset)
> +		 const char *name,  uint32_t type, bool dump, bool reset)
>  {
> +	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
>  	struct nftnl_obj_list *nln_list;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
>  	struct nftnl_obj *n;
> @@ -867,9 +868,11 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, const char *table,
>  		memory_allocation_error();
>  
>  	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
> -				    NLM_F_DUMP | NLM_F_ACK, seq);
> +				    nl_flags | NLM_F_ACK, seq);
>  	if (table != NULL)
> -		nftnl_obj_set(n, NFTNL_OBJ_TABLE, table);
> +		nftnl_obj_set_str(n, NFTNL_OBJ_TABLE, table);
> +	if (name != NULL)
> +		nftnl_obj_set_str(n, NFTNL_OBJ_NAME, name);
>  	if (type != NFT_OBJECT_UNSPEC)
>  		nftnl_obj_set_u32(n, NFTNL_OBJ_TYPE, type);
>  	nftnl_obj_nlmsg_build_payload(nlh, n);
> diff --git a/src/netlink.c b/src/netlink.c
> index 73ee5c9..0cc3a51 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -1775,8 +1775,8 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
>  	struct nftnl_obj_list *obj_cache;
>  	int err;
>  
> -	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table,
> -				     NFT_OBJECT_UNSPEC, false);
> +	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, NULL,
> +				     0, true, false);
>  	if (obj_cache == NULL) {
>  		if (errno == EINTR)
>  			return -1;
> @@ -1790,12 +1790,13 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
>  }
>  
>  int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
> -		       const struct location *loc, uint32_t type)
> +		       const struct location *loc, uint32_t type, bool dump)
>  {
>  	struct nftnl_obj_list *obj_cache;
>  	int err;
>  
> -	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, type, true);
> +	obj_cache = mnl_nft_obj_dump(nf_sock, h->family, h->table, h->obj,
> +				     type, dump, true);
>  	if (obj_cache == NULL) {
>  		if (errno == EINTR)
>  			return -1;
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 4749c9f..a1b8b08 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -974,6 +974,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
>  			{
>  				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
>  			}
> +			|       COUNTER         obj_spec
> +			{
> +				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTER, &$2,&@$, NULL);
> +			}
>  			|	QUOTAS		ruleset_spec
>  			{
>  				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
> @@ -982,6 +986,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
>  			{
>  				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
>  			}
> +			|       QUOTA           obj_spec
> +			{
> +				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
> +			}
>  			;
>  
>  flush_cmd		:	TABLE		table_spec
> diff --git a/src/rule.c b/src/rule.c
> index b5181a9..cd76983 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1266,24 +1266,30 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
>  	};
>  	struct table *table;
>  	struct obj *obj;
> +	bool print_table;
>  
>  	list_for_each_entry(table, &table_list, list) {
>  		if (cmd->handle.family != NFPROTO_UNSPEC &&
>  		    cmd->handle.family != table->handle.family)
>  			continue;
>  
> -		printf("table %s %s {\n",
> -		       family2str(table->handle.family),
> -		       table->handle.table);
> +		print_table = false;
>  
>  		list_for_each_entry(obj, &table->objs, list) {
>  			if (obj->type != type)
>  				continue;
>  
> +			if (!print_table) {
> +				printf("table %s %s {\n",
> +				       family2str(table->handle.family),
> +				       table->handle.table);
> +				print_table = true;
> +			}

We always print the table, this information is useful so we reload
partial listings via nft -f. Moreover, if the listing is exported to
file, the upper table that acts as container is also included.

Simplify this by printing the table, inconditionally.

>  			obj_print_declaration(obj, &opts);
>  		}
>  
> -		printf("}\n");
> +		if (print_table)
> +			printf("}\n");
>  	}
>  	return 0;
>  }
> @@ -1435,21 +1441,26 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
>  {
>  	struct obj *obj, *next;
>  	struct table *table;
> +	bool dump = false;
>  	uint32_t type;
>  	int ret;
>  
>  	switch (cmd->obj) {
>  	case CMD_OBJ_COUNTERS:
> +		dump = true;
> +	case CMD_OBJ_COUNTER:
>  		type = NFT_OBJECT_COUNTER;
>  		break;
>  	case CMD_OBJ_QUOTAS:
> +		dump = true;
> +	case CMD_OBJ_QUOTA:
>  		type = NFT_OBJECT_QUOTA;
>  		break;
>  	default:
>  		BUG("invalid command object type %u\n", cmd->obj);
>  	}
>  
> -	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type);
> +	ret = netlink_reset_objs(ctx, &cmd->handle, &cmd->location, type, dump);
>  	list_for_each_entry_safe(obj, next, &ctx->list, list) {
>  		table = table_lookup(&obj->handle);
>  		list_move(&obj->list, &table->objs);
> -- 
> 2.7.4
> 
