From: Linmujia <linmujia@huawei.com>
Subject: [PATCH nft]evaluate function should have a explicitly return value
Date: Fri, 27 Nov 2015 09:16:49 +0000
Message-ID: <0A900C78B9F2324AB7F4F7A51D1A2F8577978450@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "pablo@netfilter.org" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:9798 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbbK0JRP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:17:15 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

evaluate function should have a explicitly return value,otherwise the return value is random.

Signed-off-by: linmujia <linmujia@huawei.com>
---
 src/evaluate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7aab6aa..df4bf17 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1319,6 +1319,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	default:
 		BUG("unknown expression type %s\n", (*expr)->ops->name);
 	}
+	return 0;
 }
 
 static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
@@ -1446,6 +1447,7 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 		ret = reject_payload_gen_dependency_family(ctx, stmt, &payload);
 		break;
 	default:
+		ret = 1;
 		BUG("cannot generate reject dependency for type %d",
 		    stmt->reject.type);
 	}
@@ -1960,6 +1962,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
+	return 0;
 }
 
 static struct table *table_lookup_global(struct eval_ctx *ctx)
@@ -2218,6 +2221,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+	return 0;
 }
 
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
@@ -2233,6 +2237,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+	return 0;
 }
 
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
@@ -2274,6 +2279,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+	return 0;
 }
 
 static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
@@ -2401,4 +2407,5 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
 	};
+	return 0;
 }
-- 
2.5.1.windows.1

