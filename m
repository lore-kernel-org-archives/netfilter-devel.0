From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 5/5 v2] src: fix byteorder conversions in sets
Date: Mon, 04 Aug 2014 17:15:00 +0100
Message-ID: <231c40bf-3441-46be-9ce5-8e1b5375a7ab@email.android.com>
References: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com> <1407168011-6424-6-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50897 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaHDQPI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:15:08 -0400
In-Reply-To: <1407168011-6424-6-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4. August 2014 17:00:11 GMT+01:00, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
>In some rules if we use sets, we don't convert the values inside the
>set.
>Usually, rule like the datatype is integer_type. For example:
>
>nft add rule filter input tcp checksum {22-55}
>
>set%d filter 7
>set%d filter 0
>element 00000000:1 [end] element 00000016: 0 [end] element 00000038  :
>1 [end]
>ip filter input
>[ payload load 1b @ network header + 9 => reg 1 ]
>[ cmp eq reg 1 0x00000006 ]
>[ payload load 2b @ transport header + 16 => reg 1 ]
>[ lookup reg 1 set set%d ]
>
>Currently, we are going to do the byteorder conversion the values
>inside the set
>like:
>
>set%d filter 7
>set%d filter 0
>element 00000000 : 1 [end] element 00001600 : 0 [end] element 00003701:
>1 [end]
>ip filter input
>[ payload load 1b @ network header + 9 => reg 1 ]
>[ cmp eq reg 1 0x00000006 ]
>[ payload load 2b @ transport header + 16 => reg 1 ]
>[ lookup reg 1 set set%d ]
>
>Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>---
>[changes in v2]
>* Changed the solution for big endian and host endian cases.

I don't unterstand the problem, you seem to be converting values independently of wether we have a range lookup or not.

Could you please specify a case where we are currently not converting values when necessary?



> src/evaluate.c            |   32 +++++++++++++++++++++++++++-----
> src/netlink_delinearize.c |   12 ++++++++++++
> 2 files changed, 39 insertions(+), 5 deletions(-)
>
>diff --git a/src/evaluate.c b/src/evaluate.c
>index 8aaf1bf..d973cb8 100644
>--- a/src/evaluate.c
>+++ b/src/evaluate.c
>@@ -670,6 +670,29 @@ static int expr_evaluate_list(struct eval_ctx
>*ctx, struct expr **expr)
> 	return 0;
> }
> 
>+static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr
>*expr)
>+{
>+	switch (expr->ops->type) {
>+	case EXPR_VALUE:
>+		if (byteorder_conversion(ctx, &expr,
>+					 BYTEORDER_BIG_ENDIAN) < 0)
>+			return -1;
>+		break;
>+	case EXPR_RANGE:
>+		if (byteorder_conversion(ctx, &expr->right,
>+					 BYTEORDER_BIG_ENDIAN) < 0)
>+			return -1;
>+		if (byteorder_conversion(ctx, &expr->left,
>+					 BYTEORDER_BIG_ENDIAN) < 0)
>+			return -1;
>+		break;
>+	default:
>+		break;
>+	}
>+
>+	return 0;
>+}
>+
> static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
> {
> 	struct expr *set = *expr, *i, *next;
>@@ -691,6 +714,10 @@ static int expr_evaluate_set(struct eval_ctx *ctx,
>struct expr **expr)
> 			expr_free(i);
> 		} else if (!expr_is_singleton(i))
> 			set->set_flags |= SET_F_INTERVAL;
>+
>+		/* Byteorder conversion of the set elements */
>+		if (i->ops->type != EXPR_SET)
>+			expr_evaluate_set_elem(ctx, i);
> 	}
> 
> 	set->dtype = ctx->ectx.dtype;
>@@ -927,11 +954,6 @@ static int expr_evaluate_relational(struct
>eval_ctx *ctx, struct expr **expr)
> 						 left->dtype->desc,
> 						 right->dtype->desc);
> 
>-		/* Data for range lookups needs to be in big endian order */
>-		if (right->set->flags & SET_F_INTERVAL &&
>-		    byteorder_conversion(ctx, &rel->left,
>-					 BYTEORDER_BIG_ENDIAN) < 0)
>-			return -1;
> 		left = rel->left;
> 		break;
> 	case OP_EQ:
>diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>index af18dcc..f7961ad 100644
>--- a/src/netlink_delinearize.c
>+++ b/src/netlink_delinearize.c
>@@ -629,10 +629,20 @@ static void payload_dependency_store(struct
>rule_pp_ctx *ctx,
> 
> static void payload_elem_postprocess(struct expr *expr)
> {
>+	struct expr *i;
>+
> 	switch (expr->ops->type) {
> 	case EXPR_VALUE:
> 		expr_switch_byteorder(expr);
> 		break;
>+	case EXPR_SET_REF:
>+		list_for_each_entry(i, &expr->set->init->expressions, list)
>+			payload_elem_postprocess(i);
>+		break;
>+	case EXPR_RANGE:
>+		payload_elem_postprocess(expr->right);
>+		payload_elem_postprocess(expr->left);
>+		break;
> 	default:
> 		break;
> 	}
>@@ -889,6 +899,8 @@ static void expr_postprocess(struct rule_pp_ctx
>*ctx,
> 		expr_postprocess(ctx, stmt, &expr->right);
> 		break;
> 	case EXPR_SET_REF:
>+		expr_postprocess(ctx, stmt, &expr->set->init);
>+		break;
> 	case EXPR_EXTHDR:
> 	case EXPR_META:
> 	case EXPR_CT:


