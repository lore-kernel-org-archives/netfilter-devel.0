From: =?UTF-8?B?6JeN5oy655GL?= <lantw44@gmail.com>
Subject: Re: [PATCH nft] evaluate: reject: fix dependency generation from
 nft -f
Date: Wed, 07 Jan 2015 16:01:29 +0800
Message-ID: <54ACE7D9.4010709@gmail.com>
References: <1420577415-4619-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42670 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAGIBq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:01:46 -0500
Received: by mail-pd0-f182.google.com with SMTP id p10so3095501pdj.13
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jan 2015 00:01:46 -0800 (PST)
In-Reply-To: <1420577415-4619-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso =E6=96=BC =E8=A5=BF=E5=85=832015=E5=B9=B401=E6=9C=880=
7=E6=97=A5 04:50 =E5=AF=AB=E9=81=93:
> When nft -f is used, ctx->cmd points to the table object, which
> contains the corresponding chain, set and rule lists. The reject
> statement evaluator relies on ctx->cmd->rule to add the payload
> dependencies, which is doesn't point to the rule in that case.
>=20
> This patch adds the rule context to the eval_ctx structure to update
> the rule list of statements when generating dependencies, as the reje=
ct
> statement needs.
>=20
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D993
> Reported-by: Ting-Wei Lan <lantw44@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/rule.h |    2 ++
>  src/evaluate.c |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/rule.h b/include/rule.h
> index 936177b..0c52315 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -344,6 +344,7 @@ extern void cmd_free(struct cmd *cmd);
>   * @msgs:	message queue
>   * @cmd:	current command
>   * @table:	current table
> + * @rule:	current rule
>   * @set:	current set
>   * @stmt:	current statement
>   * @ectx:	expression context
> @@ -353,6 +354,7 @@ struct eval_ctx {
>  	struct list_head	*msgs;
>  	struct cmd		*cmd;
>  	struct table		*table;
> +	struct rule		*rule;
>  	struct set		*set;
>  	struct stmt		*stmt;
>  	struct expr_ctx		ectx;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8f0acf7..2c4e811 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1203,7 +1203,7 @@ static int stmt_reject_gen_dependency(struct ev=
al_ctx *ctx, struct stmt *stmt,
>  	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
>  		return -1;
> =20
> -	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
> +	list_add(&nstmt->list, &ctx->rule->stmts);
>  	return 0;
>  }
> =20
> @@ -1722,6 +1722,7 @@ static int rule_evaluate(struct eval_ctx *ctx, =
struct rule *rule)
>  	proto_ctx_init(&ctx->pctx, rule->handle.family);
>  	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
> =20
> +	ctx->rule =3D rule;
>  	list_for_each_entry(stmt, &rule->stmts, list) {
>  		if (tstmt !=3D NULL)
>  			return stmt_binary_error(ctx, stmt, tstmt,
>=20

This patch fixes the problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
