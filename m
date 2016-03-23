From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] src/evaluate.c: improve rule management checks
Date: Wed, 23 Mar 2016 17:08:34 +0100
Message-ID: <20160323160834.GA6981@salvia>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
 <145873749855.10004.10666252455830923605.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32939 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbcCWQIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 12:08:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 658EB73EF
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 17:08:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0C138DA8FA
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 17:08:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BDF9BDA8F9
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 17:08:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145873749855.10004.10666252455830923605.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 23, 2016 at 01:51:38PM +0100, Arturo Borrero Gonzalez wrote:
> Improve checks (and error reporting) for basic rule management operations.
> 
> This includes a fix for netfilter bug #965.

Thanks for working on this.

With a bit more work we can achieve better error reporting:

# nft insert rule x y handle 10 position 10 ip saddr 1.1.1.1
<cmdline>:1:17-25: Error: Wrong combination, use `position' instead
insert rule x y handle 10 position 10 ip saddr 1.1.1.1
                ^^^^^^^^^ ~~~~~~~~~~~

# nft insert rule x y handle 10 ip saddr 1.1.1.1
<cmdline>:1:17-25: Error: Cannot use this, use `position' instead
insert rule x y handle 10 ip saddr 1.1.1.1
                ^^^^^^^^^

You will need to rework this patch applying this patch in first place:

http://patchwork.ozlabs.org/patch/601270/

I'm also attaching a quick patch for the two examples, but remaining
spots are left unchanges. Please feel free to follow up on this.

Thanks.

--vtzGhvizbBRQ85DL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index 473f014..db89a0f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -65,6 +65,12 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define cmd_error(ctx, fmt, args...) \
 	__stmt_binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
+#define handle_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, NULL, fmt, ## args)
+#define position_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.position.location, NULL, fmt, ## args)
+#define handle_position_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, &ctx->cmd->handle.position.location, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -2160,11 +2166,61 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
+static int rule_evaluate_cmd(struct eval_ctx *ctx)
+{
+	struct handle *handle = &ctx->cmd->handle;
+
+	/* allowed:
+	 * - insert [position] (no handle)
+	 * - add [position] (no handle)
+	 * - replace <handle> (no position)
+	 * - delete <handle> (no position)
+	 */
+
+	switch (ctx->cmd->op) {
+	case CMD_INSERT:
+		if (handle->handle.id && handle->position.id)
+			return handle_position_error(ctx, "Wrong combination, use `position' instead");
+
+		if (handle->handle.id != 0)
+			return handle_error(ctx, "Cannot use this, use `position' instead");
+		break;
+	case CMD_ADD:
+		if (handle->handle.id != 0)
+			return cmd_error(ctx, "Could not add rule: handle not "
+					 "allowed.");
+		break;
+	case CMD_REPLACE:
+		if (handle->position.id != 0)
+			return cmd_error(ctx, "Could not replace rule: "
+					 "position not allowed.");
+		if (handle->handle.id == 0)
+			return cmd_error(ctx, "Could not replace rule: missing"
+					 " handle.");
+		break;
+	case CMD_DELETE:
+		if (handle->position.id != 0)
+			return cmd_error(ctx, "Could not delete rule: position"
+					 " not allowed.");
+		if (handle->handle.id == 0)
+			return cmd_error(ctx, "Could not delete rule: missing "
+					 "handle.");
+		break;
+	default:
+		BUG("unkown command type %u\n", ctx->cmd->op);
+	}
+
+	return 0;
+}
+
 static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 {
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
+	if (rule_evaluate_cmd(ctx) < 0)
+		return -1;
+
 	proto_ctx_init(&ctx->pctx, rule->handle.family);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
@@ -2345,8 +2401,11 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
-	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
+		if (rule_evaluate_cmd(ctx) < 0)
+			return -1;
+		/* fall through */
+	case CMD_OBJ_SET:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
 		return 0;

--vtzGhvizbBRQ85DL--
