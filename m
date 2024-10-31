Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36A21CC8A8
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412266; cv=none; b=MJQg9lPQcsKaK835ApBakjhJVYQBSF7DTaQpcUItj8wMzG5hiFVo3VUezvkG2s+xIc5ws1VR22v8hSMbA6Ncncwd9aTj43Uctn4uZ4x3Ve887K9glpKJkO2cOgsug25n+TDqxzQc5J5rWeg1BOAkKvTrJw+0JfFgAHuQsmX3xWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412266; c=relaxed/simple;
	bh=XxnIei9ISJf1VNFh9E+9TXMqBkrcNpcqG3JEcdT52Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A69YGQ1H4KSoaWJ0ci1B2LzDfBOh7ByTue4uMY0YQmn+TbiVyotgGBQHBjFpKO4Mbkex4CltipJD59rjHl/SJY/Th7ObR6n8d/k5BgXVsyC/4ax7hAC8JqvfbYadjgfoZQwNGvRZIJqMY1wuBqrygkuu6YEQ7F5bBqmCAp3aDHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	eric@garver.life
Subject: [PATCH nft] json: collapse set element commands from parser
Date: Thu, 31 Oct 2024 23:04:11 +0100
Message-Id: <20241031220411.165942-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update json parser to collapse {add,create} element commands to reduce
memory consumption in the case of large sets defined by one element per
command:

{"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
"y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}

Add CTX_F_COLLAPSED flag to report that command has been collapsed.

This patch reduces memory consumption by ~32% this case.

Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Side note: While profiling, I can still see lots json objects, this
results in memory consumption that is 5 times than native
representation. Error reporting is also lagging behind, it should be
possible to add a json_t pointer to struct location to relate
expressions and json objects.

 src/parser_json.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 37ec34cb7796..68c0600df085 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -18,6 +18,7 @@
 #include <netlink.h>
 #include <parser.h>
 #include <rule.h>
+#include <cmd.h>
 #include <sctp_chunk.h>
 #include <socket.h>
 
@@ -49,6 +50,7 @@
 #define CTX_F_SES	(1 << 6)	/* set_elem_expr_stmt */
 #define CTX_F_MAP	(1 << 7)	/* LHS of map_expr */
 #define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
+#define CTX_F_COLLAPSED	(1 << 9)
 
 struct json_ctx {
 	struct nft_ctx *nft;
@@ -3490,6 +3492,15 @@ static struct cmd *json_parse_cmd_add_element(struct json_ctx *ctx,
 		handle_free(&h);
 		return NULL;
 	}
+
+	if ((op == CMD_CREATE || op == CMD_ADD) &&
+	    nft_cmd_collapse_elems(op, ctx->cmds, &h, expr)) {
+		handle_free(&h);
+		expr_free(expr);
+		ctx->flags |= CTX_F_COLLAPSED;
+		return NULL;
+	}
+
 	return cmd_alloc(op, cmd_obj, &h, int_loc, expr);
 }
 
@@ -4319,6 +4330,11 @@ static int __json_parse(struct json_ctx *ctx)
 		cmd = json_parse_cmd(ctx, value);
 
 		if (!cmd) {
+			if (ctx->flags & CTX_F_COLLAPSED) {
+				ctx->flags &= ~CTX_F_COLLAPSED;
+				continue;
+			}
+
 			json_error(ctx, "Parsing command array at index %zd failed.", index);
 			return -1;
 		}
-- 
2.30.2

