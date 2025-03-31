Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650920298A
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743425068; cv=none; b=AUt2DtPHAjDZAd2UTIUdZrbkIGYoXLPeVpsh4IZQfWwjox+NgxU1aczHEPW+sqpMjLAfXvpfhNm1vJc5yWYBj70k1ucJzfnFeVyT/+Kge4UjKPbvJVqbdALn/QFQrSoJdGCJrSvcpCK3NRXPDxaRsHMKazhxaGaSGCcwrG0OT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743425068; c=relaxed/simple;
	bh=7P3v3QcrCo+xBWOgR+D95HLliaDvxXjdEU581EbaDRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq+36jV2oQHhAFr2T3WnMwPvj8wDpehF1lEuNaJbZURJz3R4GkEzOoCi/FAyZz2WoSNvs9nHzPJ+bmchLr3S9HQwNQ26SsvXfckRQ1pK6P760GjqALmM5TkZ1TLsl52nolYyfP4nqB8FxKhtHfziL4y6bvWhZAHPcMvnHxaZt18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzEV6-0003Qp-P3; Mon, 31 Mar 2025 14:44:24 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] evaluate: fix crash when generating reject statement error
Date: Mon, 31 Mar 2025 14:43:34 +0200
Message-ID: <20250331124341.12151-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331124341.12151-1-fw@strlen.de>
References: <20250331124341.12151-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After patch, this gets rejected with:
internal:0:0-0: Error: conflicting protocols specified: ip vs ip6

Without patch, we crash with a NULL dereference: we cannot use
reject.expr->location unconditionally.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 16 ++++++++--
 .../reject_stmt_with_no_expression_crash      | 32 +++++++++++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index 507b1c86cafc..e4a7b5ceaafa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3791,6 +3791,18 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_reject_error(struct eval_ctx *ctx,
+			     const struct stmt *stmt,
+			     const char *msg)
+{
+	struct expr *e = stmt->reject.expr;
+
+	if (e)
+		return stmt_binary_error(ctx, e, stmt, "%s", msg);
+
+	return stmt_error(ctx, stmt, "%s", msg);
+}
+
 static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
@@ -3806,12 +3818,12 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt)
 				return -1;
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
+			return stmt_reject_error(ctx, stmt,
 				   "abstracted ICMP unreachable not supported");
 		case NFT_REJECT_ICMP_UNREACH:
 			if (stmt->reject.family == pctx->family)
 				break;
-			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
+			return stmt_reject_error(ctx, stmt,
 				  "conflicting protocols specified: ip vs ip6");
 		}
 		break;
diff --git a/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash b/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash
new file mode 100644
index 000000000000..04c01aa77a29
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash
@@ -0,0 +1,32 @@
+{
+  "nftables": [
+    {
+      "table": { "family": "ip", "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "c",
+             "expr": [
+          {
+            "reject": {
+              "type": "icmpv6",
+              "exprlimit": "port-unreachable"
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
-- 
2.49.0

