From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH] src: add import operation
Date: Tue, 10 Feb 2015 17:16:30 +0100
Message-ID: <54DA2EDE.40606@gmail.com>
References: <1423570271-17073-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62167 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbBJQQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2015 11:16:12 -0500
Received: by mail-we0-f170.google.com with SMTP id q59so25834253wes.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2015 08:16:10 -0800 (PST)
Received: from [192.168.2.112] (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id g8sm19456163wiy.6.2015.02.10.08.16.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Feb 2015 08:16:09 -0800 (PST)
In-Reply-To: <1423570271-17073-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 10/02/15 a las 13:11, Alvaro Neira Ayuso escribi=F3:
> The import operation reads a XML or JSON file, with syntax:
>   % nft import {xml|json}
>
> A basic way to test this new functionality is:
>   % cat file.json | nft import json
>
> where the file.json is a ruleset exported in json format.
>
> This new operation allows to import ruleset in json and xml and to ma=
ke
> incremental changes using the new parse functions of libnftnl.
>
> Based in a patch of Arturo Borrero.

Sorry for the noise, I have catched some leaks in this patch. I'm going=
=20
to send a v2. Sorry again.

>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>   include/rule.h     |   12 ++
>   src/evaluate.c     |    1 +
>   src/parser_bison.y |   20 +++-
>   src/rule.c         |  321 +++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>   src/scanner.l      |    1 +
>   5 files changed, 352 insertions(+), 3 deletions(-)
>
> diff --git a/include/rule.h b/include/rule.h
> index 491411e..ff39df0 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -224,6 +224,7 @@ extern void set_print_plain(const struct set *s);
>    * @CMD_EXPORT:		export the ruleset in a given format
>    * @CMD_MONITOR:	event listener
>    * @CMD_DESCRIBE:	describe an expression
> + * @CMD_IMPORT:		import a ruleset in a given format
>    */
>   enum cmd_ops {
>   	CMD_INVALID,
> @@ -237,6 +238,7 @@ enum cmd_ops {
>   	CMD_EXPORT,
>   	CMD_MONITOR,
>   	CMD_DESCRIBE,
> +	CMD_IMPORT,
>   };
>
>   /**
> @@ -253,6 +255,7 @@ enum cmd_ops {
>    * @CMD_OBJ_EXPR:	expression
>    * @CMD_OBJ_MONITOR:	monitor
>    * @CMD_OBJ_EXPORT:	export
> + * @CMD_OBJ_IMPORT:	import
>    */
>   enum cmd_obj {
>   	CMD_OBJ_INVALID,
> @@ -266,6 +269,7 @@ enum cmd_obj {
>   	CMD_OBJ_EXPR,
>   	CMD_OBJ_MONITOR,
>   	CMD_OBJ_EXPORT,
> +	CMD_OBJ_IMPORT,
>   };
>
>   struct export {
> @@ -275,6 +279,13 @@ struct export {
>   struct export *export_alloc(uint32_t format);
>   void export_free(struct export *e);
>
> +struct import {
> +	uint32_t	format;
> +};
> +
> +struct import *import_alloc(uint32_t format);
> +void import_free(struct import *i);
> +
>   enum {
>   	CMD_MONITOR_OBJ_ANY,
>   	CMD_MONITOR_OBJ_TABLES,
> @@ -325,6 +336,7 @@ struct cmd {
>   		struct table	*table;
>   		struct monitor	*monitor;
>   		struct export	*export;
> +		struct import	*import;
>   	};
>   	const void		*arg;
>   };
> diff --git a/src/evaluate.c b/src/evaluate.c
> index a3484c6..998a80d 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1968,6 +1968,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct c=
md *cmd)
>   	case CMD_RENAME:
>   	case CMD_EXPORT:
>   	case CMD_DESCRIBE:
> +	case CMD_IMPORT:
>   		return 0;
>   	case CMD_MONITOR:
>   		return cmd_evaluate_monitor(ctx, cmd);
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index fd2407c..ccfbd99 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -190,6 +190,7 @@ static void location_update(struct location *loc,=
 struct location *rhs, int n)
>   %token DESCRIBE			"describe"
>   %token EXPORT			"export"
>   %token MONITOR			"monitor"
> +%token IMPORT			"import"
>
>   %token ACCEPT			"accept"
>   %token DROP			"drop"
> @@ -402,8 +403,8 @@ static void location_update(struct location *loc,=
 struct location *rhs, int n)
>   %type <cmd>			line
>   %destructor { cmd_free($$); }	line
>
> -%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list=
_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
> -%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd=
 delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd descri=
be_cmd
> +%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list=
_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cm=
d
> +%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd=
 delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd descri=
be_cmd import_cmd
>
>   %type <handle>			table_spec tables_spec chain_spec chain_identifier=
 ruleid_spec ruleset_spec
>   %destructor { handle_free(&$$); } table_spec tables_spec chain_spec=
 chain_identifier ruleid_spec ruleset_spec
> @@ -535,7 +536,7 @@ static void location_update(struct location *loc,=
 struct location *rhs, int n)
>   %destructor { expr_free($$); }	ct_expr
>   %type <val>			ct_key
>
> -%type <val>			export_format
> +%type <val>			export_format	import_format
>   %type <string>			monitor_event
>   %destructor { xfree($$); }	monitor_event
>   %type <val>			monitor_object	monitor_format
> @@ -640,6 +641,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ =3D $1; }
>   			|	EXPORT		export_cmd	{ $$ =3D $2; }
>   			|	MONITOR		monitor_cmd	{ $$ =3D $2; }
>   			|	DESCRIBE	describe_cmd	{ $$ =3D $2; }
> +			|	IMPORT		import_cmd	{ $$ =3D $2; }
>   			;
>
>   add_cmd			:	TABLE		table_spec
> @@ -809,6 +811,14 @@ export_cmd		:	export_format
>   			}
>   			;
>
> +import_cmd		:	import_format
> +			{
> +				struct handle h =3D { .family =3D NFPROTO_UNSPEC };
> +				struct import *import =3D import_alloc($1);
> +				$$ =3D cmd_alloc(CMD_IMPORT, CMD_OBJ_IMPORT, &h, &@$, import);
> +			}
> +			;
> +
>   monitor_cmd		:	monitor_event	monitor_object	monitor_format
>   			{
>   				struct handle h =3D { .family =3D NFPROTO_UNSPEC };
> @@ -846,6 +856,10 @@ describe_cmd		:	primary_expr
>   			}
>   			;
>
> +import_format		: 	XML 		{ $$ =3D NFT_PARSE_XML; }
> +			|	JSON		{ $$ =3D NFT_PARSE_JSON; }
> +			;
> +
>   table_block_alloc	:	/* empty */
>   			{
>   				$$ =3D table_alloc();
> diff --git a/src/rule.c b/src/rule.c
> index feafe26..b938433 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -20,6 +20,7 @@
>   #include <rule.h>
>   #include <utils.h>
>   #include <netlink.h>
> +#include <mnl.h>
>
>   #include <libnftnl/common.h>
>   #include <libnftnl/ruleset.h>
> @@ -555,6 +556,21 @@ void export_free(struct export *e)
>   	xfree(e);
>   }
>
> +struct import *import_alloc(uint32_t format)
> +{
> +	struct import *import;
> +
> +	import =3D xmalloc(sizeof(struct import));
> +	import->format =3D format;
> +
> +	return import;
> +}
> +
> +void import_free(struct import *i)
> +{
> +	xfree(i);
> +}
> +
>   struct monitor *monitor_alloc(uint32_t format, uint32_t type, const=
 char *event)
>   {
>   	struct monitor *mon;
> @@ -602,6 +618,9 @@ void cmd_free(struct cmd *cmd)
>   		case CMD_OBJ_EXPORT:
>   			export_free(cmd->export);
>   			break;
> +		case CMD_OBJ_IMPORT:
> +			import_free(cmd->import);
> +			break;
>   		default:
>   			BUG("invalid command object type %u\n", cmd->obj);
>   		}
> @@ -1001,6 +1020,306 @@ static int do_command_describe(struct netlink=
_ctx *ctx, struct cmd *cmd)
>   	return 0;
>   }
>
> +struct ruleset_parse {
> +	struct netlink_ctx *nl_ctx;
> +	struct cmd *cmd;
> +};
> +
> +static int ruleset_parse_step_setelems(const struct nft_parse_ctx *c=
tx,
> +				       uint32_t cmd)
> +{
> +	const struct ruleset_parse *rp;
> +	struct nft_set *set;
> +	int err =3D -1;
> +
> +	set =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	if (set =3D=3D NULL)
> +		return -1;
> +
> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		err =3D mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		err =3D mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	if (err < 0)
> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> +				 "could not import set_elems: %s",
> +				 strerror(errno));
> +
> +	return err;
> +}
> +
> +static int ruleset_parse_step_set(const struct nft_parse_ctx *ctx, u=
int32_t cmd)
> +{
> +	const struct ruleset_parse *rp;
> +	struct nft_set *set;
> +	int err =3D -1;
> +
> +	set =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	if (set =3D=3D NULL)
> +		return -1;
> +
> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		err =3D mnl_nft_set_batch_add(set, NLM_F_EXCL,
> +					    rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		err =3D mnl_nft_set_batch_del(set, 0, rp->nl_ctx->seqnum);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	if (err < 0)
> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> +				 "could not import set: %s", strerror(errno));
> +
> +	err =3D ruleset_parse_step_setelems(ctx, cmd);
> +	if (err < 0)
> +		return -1;
> +
> +	return err;
> +}
> +
> +
> +static int ruleset_parse_step_rule(const struct nft_parse_ctx *ctx,
> +				   uint32_t cmd, struct nft_rule *nlr)
> +{
> +	const struct ruleset_parse *rp;
> +	struct nft_rule *rule;
> +	uint32_t nl_flags;
> +	int err =3D -1;
> +
> +	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_RULE))
> +		rule =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_RULE);
> +	else
> +		rule =3D nlr;
> +
> +	if (rule =3D=3D NULL)
> +		return -1;
> +
> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		nl_flags =3D NLM_F_APPEND|NLM_F_CREATE;
> +		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
> +		err =3D mnl_nft_rule_batch_add(rule, nl_flags,
> +					     rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		err =3D mnl_nft_rule_batch_del(rule, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_REPLACE:
> +		nl_flags =3D NLM_F_REPLACE;
> +		err =3D mnl_nft_rule_batch_add(rule, nl_flags,
> +					     rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_INSERT:
> +		nl_flags =3D NLM_F_CREATE;
> +		nft_rule_attr_unset(rule, NFT_RULE_ATTR_HANDLE);
> +		err =3D mnl_nft_rule_batch_add(rule, nl_flags,
> +					     rp->nl_ctx->seqnum);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	if (err < 0)
> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> +				 "could not import rule: %s", strerror(errno));
> +
> +	return err;
> +}
> +
> +static int ruleset_flush_rules(const struct nft_parse_ctx *ctx)
> +{
> +	struct nft_rule *nlr;
> +	struct nft_table *nlt;
> +	struct nft_chain *nlc;
> +	uint32_t type;
> +
> +	nlr =3D nft_rule_alloc();
> +	if (nlr =3D=3D NULL)
> +		return -1;
> +
> +	type =3D nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
> +	switch (type) {
> +	case NFT_RULESET_TABLE:
> +		nlt =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
> +				  nft_table_attr_get(nlt, NFT_TABLE_ATTR_NAME));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
> +				  nft_table_attr_get(nlt,
> +						     NFT_TABLE_ATTR_FAMILY));
> +		break;
> +	case NFT_RULESET_CHAIN:
> +		nlc =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_TABLE,
> +				  nft_chain_attr_get(nlc,
> +						     NFT_CHAIN_ATTR_TABLE));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_CHAIN,
> +				  nft_chain_attr_get(nlc, NFT_CHAIN_ATTR_NAME));
> +		nft_rule_attr_set(nlr, NFT_RULE_ATTR_FAMILY,
> +				  nft_chain_attr_get(nlc,
> +						     NFT_TABLE_ATTR_FAMILY));
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	return ruleset_parse_step_rule(ctx, NFT_CMD_DELETE, nlr);
> +}
> +
> +static int ruleset_parse_step_chain(const struct nft_parse_ctx *ctx,
> +				    uint32_t cmd)
> +{
> +	const struct ruleset_parse *rp;
> +	struct nft_chain *chain;
> +	int err =3D -1;
> +
> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +	chain =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_CHAIN);
> +	nft_chain_attr_unset(chain, NFT_CHAIN_ATTR_HANDLE);
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		err =3D mnl_nft_chain_batch_add(chain, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		err =3D mnl_nft_chain_batch_del(chain, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_FLUSH:
> +		err =3D ruleset_flush_rules(ctx);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	nft_chain_free(chain);
> +	if (err < 0)
> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> +				 "could not import chain: %s", strerror(errno));
> +
> +	return err;
> +}
> +
> +static int ruleset_parse_step_table(const struct nft_parse_ctx *ctx,
> +				    uint32_t cmd, struct nft_table *nlt)
> +{
> +	struct ruleset_parse *rp;
> +	struct nft_table *table;
> +	int err;
> +
> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +	if (rp =3D=3D NULL)
> +		return -1;
> +
> +	if (nft_ruleset_ctx_is_set(ctx, NFT_RULESET_CTX_TABLE))
> +		table =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_TABLE);
> +	else
> +		table =3D nlt;
> +
> +	if (table =3D=3D NULL)
> +		return -1;
> +
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		err =3D mnl_nft_table_batch_add(table, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		err =3D mnl_nft_table_batch_del(table, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_FLUSH:
> +		err =3D ruleset_flush_rules(ctx);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	if (err < 0)
> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> +				 "could not import table: %s", strerror(errno));
> +
> +	return err;
> +}
> +
> +static int nft_ruleset_flush_ruleset(const struct nft_parse_ctx *ctx=
)
> +{
> +	struct nft_table *nlt;
> +
> +	nlt =3D nft_table_alloc();
> +	if (nlt =3D=3D NULL)
> +		return -1;
> +
> +	return ruleset_parse_step_table(ctx, NFT_CMD_DELETE, nlt);
> +}
> +
> +static int ruleset_parse_step_cb(const struct nft_parse_ctx *ctx)
> +{
> +	uint32_t type, cmd;
> +
> +	type =3D nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_TYPE);
> +	cmd =3D nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
> +	switch (type) {
> +	case NFT_RULESET_TABLE:
> +		ruleset_parse_step_table(ctx, cmd, NULL);
> +		break;
> +	case NFT_RULESET_CHAIN:
> +		ruleset_parse_step_chain(ctx, cmd);
> +		break;
> +	case NFT_RULESET_RULE:
> +		ruleset_parse_step_rule(ctx, cmd, NULL);
> +		break;
> +	case NFT_RULESET_SET:
> +		ruleset_parse_step_set(ctx, cmd);
> +		break;
> +	case NFT_RULESET_SET_ELEMS:
> +		ruleset_parse_step_setelems(ctx, cmd);
> +		break;
> +	case NFT_RULESET_RULESET:
> +		nft_ruleset_flush_ruleset(ctx);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int do_command_import(struct netlink_ctx *ctx, struct cmd *cm=
d)
> +{
> +	int ret;
> +	struct nft_parse_err *err;
> +	struct ruleset_parse rp =3D {
> +		.nl_ctx =3D ctx,
> +		.cmd =3D cmd
> +	};
> +
> +	err =3D nft_parse_err_alloc();
> +	if (err =3D=3D NULL)
> +		return -1;
> +
> +	ret =3D nft_ruleset_parse_file_cb(cmd->import->format, stdin, err, =
&rp,
> +					ruleset_parse_step_cb);
> +	if (ret < 0)
> +		nft_parse_perror("unable to import. Parsing failed", err);
> +
> +	nft_parse_err_free(err);
> +	return ret;
> +}
> +
>   int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
>   {
>   	switch (cmd->op) {
> @@ -1024,6 +1343,8 @@ int do_command(struct netlink_ctx *ctx, struct =
cmd *cmd)
>   		return do_command_monitor(ctx, cmd);
>   	case CMD_DESCRIBE:
>   		return do_command_describe(ctx, cmd);
> +	case CMD_IMPORT:
> +		return do_command_import(ctx, cmd);
>   	default:
>   		BUG("invalid command object type %u\n", cmd->obj);
>   	}
> diff --git a/src/scanner.l b/src/scanner.l
> index 73c4f8b..bf949f8 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -262,6 +262,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>   "flush"			{ return FLUSH; }
>   "rename"		{ return RENAME; }
>   "export"		{ return EXPORT; }
> +"import"		{ return IMPORT; }
>   "monitor"		{ return MONITOR; }
>
>   "position"		{ return POSITION; }
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
