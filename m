Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6712367A6
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753352541; cv=none; b=YHtsMZqWxYDhqFSsJbzEplIyNdrxWslHccT1VG77Hl2Itx0Plc/wKKKIFnhFoFGCLW5YdRACVfOZgZIBIZMi2Zac3gzwIXE7tExTkEXkIovgn+OQQIgg/GB5IRFSMTrOBsXLV9ahIPhj8/VZMQyK66ZeeowBg0YGwMpVpQHrNKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753352541; c=relaxed/simple;
	bh=PkcxghNwj+BvJrzPdsk/1jMDaS8YL9ypW8z/1gI+qGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r6Wqpf4Xm16Bmukcia4vpM3th2c8oSLjK1PM+ENjABZmeGB8bBB4xFTRA8ySvgRHo5G7OmA5bWgZ7pLKshTMLxaaWG/Ceq+kZ6Az5sj8KCTb+EpFZTTp9gP46erFeOGQ86jRmgdlmKHyAifVkv4i+N+EGAlU/Z5H16nIzk/FFrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A1484604EE; Thu, 24 Jul 2025 12:22:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: fix memory leak in anon chain error handling
Date: Thu, 24 Jul 2025 12:22:02 +0200
Message-ID: <20250724102205.4663-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chain_stmt_destroy is called from bison destructor, but it turns out
this function won't free the associated chain.

There is no memory leak when bison can parse the input because the chain
statement evaluation step queues the embedded anon chain via cmd_alloc.
Then, a later cmd_free() releases the chain and the embedded statements.

In case of a parser error, the evaluation step is never reached and the
chain object leaks, e.g. in

  foo bar jump { return }

Bison calls the right destructor but the anonon chain and all
statements/expressions in it are not released:

HEAP SUMMARY:
    in use at exit: 1,136 bytes in 4 blocks
  total heap usage: 98 allocs, 94 frees, 840,255 bytes allocated

1,136 (568 direct, 568 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
   at: calloc (vg_replace_malloc.c:1675)
   by: xzalloc (in libnftables.so.1.1.0)
   by: chain_alloc (in libnftables.so.1.1.0)
   by: nft_parse (in libnftables.so.1.1.0)
   by: __nft_run_cmd_from_filename (in libnftables.so.1.1.0)
   by: nft_run_cmd_from_filename (in libnftables.so.1.1.0)

To resolve this, make chain_stmt_destroy also release the embedded
chain.  This in turn requires chain refcount increases whenever a chain
is assocated with a chain statement, else we get double-free of the
chain.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 All tests pass with this, but we can also defer this until after
 v1.1.4 -- its not urgent.

 src/evaluate.c                                            | 2 +-
 src/netlink_delinearize.c                                 | 2 +-
 src/statement.c                                           | 1 +
 .../bogons/nft-f/rule-parse-error-with-anon-chain-leak    | 8 ++++++++
 4 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/rule-parse-error-with-anon-chain-leak

diff --git a/src/evaluate.c b/src/evaluate.c
index c20a1d526c1e..f5105396b3a8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4577,7 +4577,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 
 static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct chain *chain = stmt->chain.chain;
+	struct chain *chain = chain_get(stmt->chain.chain);
 	struct cmd *cmd;
 
 	chain->flags |= CHAIN_F_BINDING;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b4d4a3da3b37..b97962a30ca2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -235,7 +235,7 @@ static void netlink_parse_chain_verdict(struct netlink_parse_ctx *ctx,
 	}
 
 	if (chain) {
-		ctx->stmt = chain_stmt_alloc(loc, chain, verdict);
+		ctx->stmt = chain_stmt_alloc(loc, chain_get(chain), verdict);
 		expr_free(expr);
 	} else {
 		ctx->stmt = verdict_stmt_alloc(loc, expr);
diff --git a/src/statement.c b/src/statement.c
index 695b57a6cc65..2bfed4ac982f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -140,6 +140,7 @@ static void chain_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 static void chain_stmt_destroy(struct stmt *stmt)
 {
 	expr_free(stmt->chain.expr);
+	chain_free(stmt->chain.chain);
 }
 
 static const struct stmt_ops chain_stmt_ops = {
diff --git a/tests/shell/testcases/bogons/nft-f/rule-parse-error-with-anon-chain-leak b/tests/shell/testcases/bogons/nft-f/rule-parse-error-with-anon-chain-leak
new file mode 100644
index 000000000000..03a0df3710e0
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/rule-parse-error-with-anon-chain-leak
@@ -0,0 +1,8 @@
+table inet x {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		foo bar jump {
+			return
+		}
+	}
+}
-- 
2.49.1

