From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [nft PATCH] ct: add support for setting ct mark
Date: Wed, 12 Mar 2014 22:36:19 +0100
Message-ID: <CAKfDRXjH75sbSYpHRbTb6oqb4PUw9bUcc9mm=gG2MHDQ+JntqQ@mail.gmail.com>
References: <20140312180319.5029.59536.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:55000 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaCLVgU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:36:20 -0400
Received: by mail-yh0-f47.google.com with SMTP id 29so149166yhl.6
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2014 14:36:19 -0700 (PDT)
In-Reply-To: <20140312180319.5029.59536.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Thanks for taking the time to implement this!

Acked-by: Kristian Evensen <kristian.evensen@gmail.com>

On Wed, Mar 12, 2014 at 7:03 PM, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> This patch adds the possibility to set ct keys using nft. Currently, the
> connection mark is supported. This functionality enables creating rules
> performing the same action as iptables -j CONNMARK --save-mark. For example:
>
> table ip filter {
>         chain postrouting {
>                 type filter hook postrouting priority 0;
>                 ip protocol icmp ip daddr 8.8.8.8 ct mark set meta mark
>         }
> }
>
> My patch is based on the original http://patchwork.ozlabs.org/patch/307677/
> by Kristian Evensen <kristian.evensen@gmail.com>.
>
> I simply did a rebase and some testing. To test, I added rules like these:
>  counter meta mark set 1 counter
>  counter ct mark set mark counter
>  counter ct mark 1 counter
>
> The last matching worked as expected, which means the second rule is also
> working as expected.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/statement.h       |   14 ++++++++++++++
>  src/ct.c                  |   25 +++++++++++++++++++++++++
>  src/evaluate.c            |   11 +++++++++++
>  src/netlink_delinearize.c |   38 +++++++++++++++++++++++++++++++++++---
>  src/netlink_linearize.c   |   18 ++++++++++++++++++
>  src/parser.y              |    9 +++++++++
>  6 files changed, 112 insertions(+), 3 deletions(-)
>
> diff --git a/include/statement.h b/include/statement.h
> index 14a66df..896b972 100644
> --- a/include/statement.h
> +++ b/include/statement.h
> @@ -67,6 +67,17 @@ struct queue_stmt {
>
>  extern struct stmt *queue_stmt_alloc(const struct location *loc);
>
> +#include <ct.h>
> +struct ct_stmt {
> +       enum nft_ct_keys                key;
> +       const struct ct_template        *tmpl;
> +       struct expr                     *expr;
> +};
> +
> +extern struct stmt *ct_stmt_alloc(const struct location *loc,
> +                                 enum nft_ct_keys key,
> +                                 struct expr *expr);
> +
>  /**
>   * enum stmt_types - statement types
>   *
> @@ -80,6 +91,7 @@ extern struct stmt *queue_stmt_alloc(const struct location *loc);
>   * @STMT_REJECT:       REJECT statement
>   * @STMT_NAT:          NAT statement
>   * @STMT_QUEUE:                QUEUE statement
> + * @STMT_CT:           conntrack statement
>   */
>  enum stmt_types {
>         STMT_INVALID,
> @@ -92,6 +104,7 @@ enum stmt_types {
>         STMT_REJECT,
>         STMT_NAT,
>         STMT_QUEUE,
> +       STMT_CT,
>  };
>
>  /**
> @@ -138,6 +151,7 @@ struct stmt {
>                 struct reject_stmt      reject;
>                 struct nat_stmt         nat;
>                 struct queue_stmt       queue;
> +               struct ct_stmt          ct;
>         };
>  };
>
> diff --git a/src/ct.c b/src/ct.c
> index a27621e..30639b2 100644
> --- a/src/ct.c
> +++ b/src/ct.c
> @@ -27,6 +27,7 @@
>  #include <ct.h>
>  #include <gmputil.h>
>  #include <utils.h>
> +#include <statement.h>
>
>  static const struct symbol_table ct_state_tbl = {
>         .symbols        = {
> @@ -290,6 +291,30 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
>         }
>  }
>
> +static void ct_stmt_print(const struct stmt *stmt)
> +{
> +       printf("ct %s set ", ct_templates[stmt->ct.key].token);
> +       expr_print(stmt->ct.expr);
> +}
> +
> +static const struct stmt_ops ct_stmt_ops = {
> +       .type           = STMT_CT,
> +       .name           = "ct",
> +       .print          = ct_stmt_print,
> +};
> +
> +struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
> +                            struct expr *expr)
> +{
> +       struct stmt *stmt;
> +
> +       stmt = stmt_alloc(loc, &ct_stmt_ops);
> +       stmt->ct.key    = key;
> +       stmt->ct.tmpl   = &ct_templates[key];
> +       stmt->ct.expr   = expr;
> +       return stmt;
> +}
> +
>  static void __init ct_init(void)
>  {
>         datatype_register(&ct_state_type);
> diff --git a/src/evaluate.c b/src/evaluate.c
> index fff8fef..dc4406c 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1170,6 +1170,15 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>         return 0;
>  }
>
> +static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +       expr_set_context(&ctx->ectx, stmt->ct.tmpl->dtype,
> +                        stmt->ct.tmpl->len);
> +       if (expr_evaluate(ctx, &stmt->ct.expr) < 0)
> +               return -1;
> +       return 0;
> +}
> +
>  static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  #ifdef DEBUG
> @@ -1197,6 +1206,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
>                 return stmt_evaluate_nat(ctx, stmt);
>         case STMT_QUEUE:
>                 return 0;
> +       case STMT_CT:
> +               return stmt_evaluate_ct(ctx, stmt);
>         default:
>                 BUG("unknown statement type %s\n", stmt->ops->name);
>         }
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index ca72091..62cbf0e 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -365,9 +365,27 @@ static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
>                 netlink_parse_meta_sreg(ctx, loc, nle);
>  }
>
> -static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
> -                            const struct location *loc,
> -                            const struct nft_rule_expr *nle)
> +static void netlink_parse_ct_sreg(struct netlink_parse_ctx *ctx,
> +                                 const struct location *loc,
> +                                 const struct nft_rule_expr *nle)
> +{
> +       struct stmt *stmt;
> +       struct expr *expr;
> +
> +       expr = netlink_get_register(ctx, loc,
> +                                   nft_rule_expr_get_u32(nle,
> +                                                         NFT_EXPR_CT_SREG));
> +       stmt = ct_stmt_alloc(loc,
> +                            nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY),
> +                            expr);
> +       expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
> +
> +       list_add_tail(&stmt->list, &ctx->rule->stmts);
> +}
> +
> +static void netlink_parse_ct_dreg(struct netlink_parse_ctx *ctx,
> +                                 const struct location *loc,
> +                                 const struct nft_rule_expr *nle)
>  {
>         struct expr *expr;
>
> @@ -377,6 +395,16 @@ static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
>                              expr);
>  }
>
> +static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
> +                            const struct location *loc,
> +                            const struct nft_rule_expr *nle)
> +{
> +       if (nft_rule_expr_is_set(nle, NFT_EXPR_CT_DREG))
> +               netlink_parse_ct_dreg(ctx, loc, nle);
> +       else
> +               netlink_parse_ct_sreg(ctx, loc, nle);
> +}
> +
>  static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
>                                   const struct location *loc,
>                                   const struct nft_rule_expr *nle)
> @@ -858,6 +886,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
>                         if (stmt->meta.expr != NULL)
>                                 expr_postprocess(&rctx, stmt, &stmt->meta.expr);
>                         break;
> +               case STMT_CT:
> +                       if (stmt->ct.expr != NULL)
> +                               expr_postprocess(&rctx, stmt, &stmt->ct.expr);
> +                       break;
>                 case STMT_NAT:
>                         if (stmt->nat.addr != NULL)
>                                 expr_postprocess(&rctx, stmt, &stmt->nat.addr);
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 9d59374..e80646b 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -662,6 +662,22 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
>         nft_rule_add_expr(ctx->nlr, nle);
>  }
>
> +static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
> +                                 const struct stmt *stmt)
> +{
> +       struct nft_rule_expr *nle;
> +       enum nft_registers sreg;
> +
> +       sreg = get_register(ctx);
> +       netlink_gen_expr(ctx, stmt->ct.expr, sreg);
> +       release_register(ctx);
> +
> +       nle = alloc_nft_expr("ct");
> +       nft_rule_expr_set_u32(nle, NFT_EXPR_CT_SREG, sreg);
> +       nft_rule_expr_set_u32(nle, NFT_EXPR_CT_KEY, stmt->ct.key);
> +       nft_rule_add_expr(ctx->nlr, nle);
> +}
> +
>  static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
>                              const struct stmt *stmt)
>  {
> @@ -684,6 +700,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
>                 return netlink_gen_nat_stmt(ctx, stmt);
>         case STMT_QUEUE:
>                 return netlink_gen_queue_stmt(ctx, stmt);
> +       case STMT_CT:
> +               return netlink_gen_ct_stmt(ctx, stmt);
>         default:
>                 BUG("unknown statement type %s\n", stmt->ops->name);
>         }
> diff --git a/src/parser.y b/src/parser.y
> index 0d97ae9..db6f493 100644
> --- a/src/parser.y
> +++ b/src/parser.y
> @@ -392,6 +392,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %destructor { stmt_free($$); } stmt match_stmt verdict_stmt
>  %type <stmt>                   counter_stmt counter_stmt_alloc
>  %destructor { stmt_free($$); } counter_stmt counter_stmt_alloc
> +%type <stmt>                   ct_stmt
> +%destructor { stmt_free($$); } ct_stmt
>  %type <stmt>                   meta_stmt
>  %destructor { stmt_free($$); } meta_stmt
>  %type <stmt>                   log_stmt log_stmt_alloc
> @@ -1069,6 +1071,7 @@ stmt                      :       verdict_stmt
>                         |       reject_stmt
>                         |       nat_stmt
>                         |       queue_stmt
> +                       |       ct_stmt
>                         ;
>
>  verdict_stmt           :       verdict_expr
> @@ -1593,6 +1596,12 @@ ct_key                   :       STATE           { $$ = NFT_CT_STATE; }
>                         |       LABEL           { $$ = NFT_CT_LABEL; }
>                         ;
>
> +ct_stmt                        :       CT      ct_key          SET     expr
> +                       {
> +                               $$ = ct_stmt_alloc(&@$, $2, $4);
> +                       }
> +                       ;
> +
>  payload_expr           :       payload_raw_expr
>                         |       eth_hdr_expr
>                         |       vlan_hdr_expr
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
