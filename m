Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D140345753
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626814; cv=none; b=kLA+opRisgObt++F4GWExlCZ/6XijkjfmX7mjnfNCw8vswbSxCngkVUtdPsNWLmKQ1kWbhskkv38P16xMqvrGdNrj1JXq01jIvN9OCYtTWLvIcF9tiXOqcf7F2ghRsbYUz1wneOsV+dqmPVNl012vXh+pwV5xApNQaBN7/jJ/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626814; c=relaxed/simple;
	bh=NgJC4wgi01V9CdBc29jyxgOWFJnQiBLWgbpk6mQOWcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYYgjL0yypfOAUON6ac1iHLWryxFK3EISwR8h7ZV+1mY9FZW96Veroiy03Vwz/ozhuxd4ym8mvsKCyfPCYYcwT+CKolqHVc2UiReENdQc8iPIYU/SZMXN3QmSPHJgUmNWFSpGqmS7r45QOBDHQM8QsBovFCkFmZRYaRW/PHW3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CCAB6109E; Thu, 16 Oct 2025 17:00:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] src: tunnel src/dst must be a symbolic expression
Date: Thu, 16 Oct 2025 16:59:34 +0200
Message-ID: <20251016145955.7785-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251016145955.7785-1-fw@strlen.de>
References: <20251016145955.7785-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogons crash with segfault and assertion.  After fix:

tunnel_with_garbage_dst:3:12-14: Error: syntax error, unexpected tcp, expecting string or quoted string or string with a trailing asterisk or '$'
  ip saddr tcp dport { }
           ^^^
The parser change restricts the grammar to no longer allow this,
we would crash here because we enter payload evaluation path that
tries to insert a dependency into the rule, but we don't have one
(ctx->rule and ctx->stmt are NULL as expected here).

The eval stage change makes sure we will reject non-value symbols:

tunnel_with_anon_set_assert:1:12-31: Error: must be a value, not set
define s = { 1.2.3.4, 5.6.7.8 }
           ^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 20 +++++++++++++++++--
 src/parser_bison.y                            |  8 ++++----
 .../bogons/nft-f/tunnel_with_anon_set_assert  |  8 ++++++++
 .../bogons/nft-f/tunnel_with_garbage_dst      |  5 +++++
 4 files changed, 35 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst

diff --git a/src/evaluate.c b/src/evaluate.c
index ac482c83cce2..a5cc41819198 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5851,19 +5851,35 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 	return 0;
 }
 
+static int tunnel_evaluate_addr(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *e;
+	int ret;
+
+	ret = expr_evaluate(ctx, exprp);
+	if (ret < 0)
+		return ret;
+
+	e = *exprp;
+	if (e->etype != EXPR_VALUE)
+		return expr_error(ctx->msgs, e, "must be a value, not %s", expr_name(e));
+
+	return 0;
+}
+
 static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	if (obj->tunnel.src) {
 		expr_set_context(&ctx->ectx, obj->tunnel.src->dtype,
 				 obj->tunnel.src->dtype->size);
-		if (expr_evaluate(ctx, &obj->tunnel.src) < 0)
+		if (tunnel_evaluate_addr(ctx, &obj->tunnel.src) < 0)
 			return -1;
 	}
 
 	if (obj->tunnel.dst) {
 		expr_set_context(&ctx->ectx, obj->tunnel.dst->dtype,
 				 obj->tunnel.dst->dtype->size);
-		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
+		if (tunnel_evaluate_addr(ctx, &obj->tunnel.dst) < 0)
 			return -1;
 
 		if (obj->tunnel.src &&
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 100a5c871e61..b63c7df18a35 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5068,22 +5068,22 @@ tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.id = $2;
 			}
-			|	IP	SADDR	expr	close_scope_ip
+			|	IP	SADDR	symbol_expr	close_scope_ip
 			{
 				$<obj>0->tunnel.src = $3;
 				datatype_set($3, &ipaddr_type);
 			}
-			|	IP	DADDR	expr	close_scope_ip
+			|	IP	DADDR	symbol_expr	close_scope_ip
 			{
 				$<obj>0->tunnel.dst = $3;
 				datatype_set($3, &ipaddr_type);
 			}
-			|	IP6	SADDR	expr	close_scope_ip6
+			|	IP6	SADDR	symbol_expr	close_scope_ip6
 			{
 				$<obj>0->tunnel.src = $3;
 				datatype_set($3, &ip6addr_type);
 			}
-			|	IP6	DADDR	expr	close_scope_ip6
+			|	IP6	DADDR	symbol_expr	close_scope_ip6
 			{
 				$<obj>0->tunnel.dst = $3;
 				datatype_set($3, &ip6addr_type);
diff --git a/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert b/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
new file mode 100644
index 000000000000..6f7b212aefef
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
@@ -0,0 +1,8 @@
+define s = { 1.2.3.4, 5.6.7.8 }
+
+table netdev x {
+	tunnel t {
+		ip saddr $s
+	}
+	}
+
diff --git a/tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst b/tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst
new file mode 100644
index 000000000000..85eb992cec16
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst
@@ -0,0 +1,5 @@
+table netdev x {
+	tunnel t {
+		ip saddr tcp dport { }
+	}
+}
-- 
2.51.0

