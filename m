Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102E412AACD
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814770; cv=none; b=LKuPZk+zo4/q3hQmKRfj+0NdXvkuz0UW0rMshUWlU6QGR3TXtIX3nUyl5gw8A6dI3GVShafm5XEsf0SywUJ/X50UlJfyE6JDRPB9JN11KS5kImQEFCS80ZUegIWFTlbLJb4tsyZqeIfIHtNTF1/J+9js7F4Do01ZF8dyCVaMzV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814770; c=relaxed/simple;
	bh=wGVq12tidZXdihs5zOaiPOP/b9AQTUc/5dAHzVdNMt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkADXthWQ4ZnhK17BmCFYA7gn0aJd5UZFuEGWYKt4tPbiuLea166kU9J13EeSJuk1gZEaLPAxR9d30dxDv3YW0hKV8N14T3oL+q3dkuSDJKDs5rpYsxsnvvGBJhd1XdeFJ0z/FhYgbxDjcFbVdF0WULvR6FawxSsvhIuuBWF8fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvX-000734-H3; Thu, 07 Mar 2024 13:32:47 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Date: Thu,  7 Mar 2024 13:26:32 +0100
Message-ID: <20240307122640.29507-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307122640.29507-1-fw@strlen.de>
References: <20240307122640.29507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing parser cannot handle certain inputs.  Example:

  "map": {
   "family": "ip",
   "name": "testmap",
   "table": "test",
   "type": "ipv4_addr",
   "handle": 2,
   "map": "verdict",
   "elem": [ [ "*", {
        "jump": {
           "target": "testchain"
[..]
    },
    {
      "chain": {
        "family": "ip",
        "table": "test",
        "name": "testchain",
        ...

Problem is that the json input parser does cmd_add at the earliest opportunity.

For a simple input file defining a table, set, set element and chain, we get
following transaction:
 * add table
 * add set
 * add setelem
 * add chain

This is rejected by the kernel, because the set element references a chain
that does (not yet) exist.

Normal input parser only allocates a CMD_ADD request for the table.

Rest of the transactional commands are created much later, via nft_cmd_expand(),
which walks "struct table" and then creates the needed CMD_ADD for the objects
owned by that table.

This transaction will be:
 * add table
 * add chain
 * add set
 * add setelem

This is not fixable with the current json parser.  To make this work, we
will need to let nft_cmd_expand() take care of building the transaction
commands in the right order.

For this, we must suppress the cmd_alloc() and add the object to struct
table (->sets, ->chains, etc).

This preparation patch moves the list_add into json_parse_cmd so that
followup patches are allowed to avoid command allocation completely
and add objects to struct table/chain instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index d4cc2c1e4e9c..7540df59dc8f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4111,7 +4111,7 @@ static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
 	json_cmd_assoc_list = new;
 }
 
-static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
+static int json_parse_cmd(struct json_ctx *ctx, json_t *root)
 {
 	struct {
 		const char *key;
@@ -4132,6 +4132,7 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		//{ "monitor", CMD_MONITOR, json_parse_cmd_monitor },
 		//{ "describe", CMD_DESCRIBE, json_parse_cmd_describe }
 	};
+	struct cmd *cmd;
 	unsigned int i;
 	json_t *tmp;
 
@@ -4140,10 +4141,21 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		if (!tmp)
 			continue;
 
-		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
+		cmd = parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
+		goto out;
 	}
+
 	/* to accept 'list ruleset' output 1:1, try add command */
-	return json_parse_cmd_add(ctx, root, CMD_ADD);
+	cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
+out:
+	if (cmd) {
+		list_add_tail(&cmd->list, ctx->cmds);
+
+		if (nft_output_echo(&ctx->nft->output))
+			json_cmd_assoc_add(root, cmd);
+	}
+
+	return 0;
 }
 
 static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
@@ -4222,10 +4234,8 @@ static int __json_parse(struct json_ctx *ctx)
 	}
 
 	json_array_foreach(tmp, index, value) {
-		/* this is more or less from parser_bison.y:716 */
-		LIST_HEAD(list);
-		struct cmd *cmd;
 		json_t *tmp2;
+		int err;
 
 		if (!json_is_object(value)) {
 			json_error(ctx, "Unexpected command array element of type %s, expected object.", json_typename(value));
@@ -4241,19 +4251,11 @@ static int __json_parse(struct json_ctx *ctx)
 			continue;
 		}
 
-		cmd = json_parse_cmd(ctx, value);
-
-		if (!cmd) {
+		err = json_parse_cmd(ctx, value);
+		if (err < 0) {
 			json_error(ctx, "Parsing command array at index %zd failed.", index);
 			return -1;
 		}
-
-		list_add_tail(&cmd->list, &list);
-
-		list_splice_tail(&list, ctx->cmds);
-
-		if (nft_output_echo(&ctx->nft->output))
-			json_cmd_assoc_add(value, cmd);
 	}
 
 	return 0;
-- 
2.43.0

