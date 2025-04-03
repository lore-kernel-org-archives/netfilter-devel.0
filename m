Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07024DFE8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Apr 2025 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743687360; cv=none; b=S3o1Yn/Xrr6Bi52jNbuN7WDCclRrHFZQZlaJaHPnAkPKssEcmKdXTUh7Ak+v8QTKwRoi9UslBO/gb1PErjaOOQUjoJ9Qpes+DKp3/AlVyCVBZSB431Cz2tCrRBzCaxs5I1eYcnf0RDt4OsotIiDKsXsWY0SAnr34d7IA+boAqmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743687360; c=relaxed/simple;
	bh=KyaoDpaRP/VVOhC4J72K/50fwcnsU1cPuYwrIRn11YY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TgQbwUFL2RtRO4RaG0kesWTBQnOch2Ilg+SDGGltjhWrckCOhwb7TXmjixLV9gMKl6f9Ls0iki5W4m7RuWrmc31lJJ6ME+PDpzTzXEwvXAqKAo+YIJVcvXDp+jNiM2TyRLcMstFZzvP0Z7NC7iIcyMIvlKEwgjeJj+5eMYD82yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0Kjb-0005n8-Km; Thu, 03 Apr 2025 15:35:55 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: bail out early if referenced set is invalid
Date: Thu,  3 Apr 2025 15:31:26 +0200
Message-ID: <20250403133143.19273-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bogon causes:
BUG: Internal error: Unexpected alteration of l4 expressionnft: src/evaluate.c:4112: stmt_evaluate_nat_map: Assertion `0' failed.

After fix:
Error: can not use variable sized data types (invalid) in concat expressions
 typeof numgen inc mod 2 : ip daddr . 0
                           ~~~~~~~~~~~^

This error is emitted during evaluation of the set, so
stmt_evaluate_nat_map is operating on a partially evaluated set.
set->key, set->data etc. may or may not have been evaluated or
could be absent entirely.

Tag set as erronous, then bail out in stmt_evaluate_nat_map,
any errors we could emit here are followup-errors anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                       | 12 +++++++++++-
 .../invalid_set_key_stmt_evaluate_nat_map_assert     | 10 ++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_set_key_stmt_evaluate_nat_map_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index d6bb18ba2aa0..9fd4f6d7ddfa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4273,6 +4273,11 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 		goto out;
 	}
 
+	if (stmt->nat.addr->mappings->set->errors) {
+		err = -1;
+		goto out;
+	}
+
 	data = stmt->nat.addr->mappings->set->data;
 	if (data->flags & EXPR_F_INTERVAL)
 		stmt->nat.type_flags |= STMT_NAT_F_INTERVAL;
@@ -5690,12 +5695,17 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	int ret;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, cmd);
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
-		return set_evaluate(ctx, cmd->set);
+		ret = set_evaluate(ctx, cmd->set);
+		if (ret < 0)
+			cmd->set->errors = true;
+		return ret;
 	case CMD_OBJ_SETELEMS:
 		return elems_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_set_key_stmt_evaluate_nat_map_assert b/tests/shell/testcases/bogons/nft-f/invalid_set_key_stmt_evaluate_nat_map_assert
new file mode 100644
index 000000000000..d73dce8e5ce1
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_set_key_stmt_evaluate_nat_map_assert
@@ -0,0 +1,10 @@
+table ip t {
+	map t2 {
+		typeof numgen inc mod 2 : ip daddr . 0
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2
+	}
+}
-- 
2.49.0

