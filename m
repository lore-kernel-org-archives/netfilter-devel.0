Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58621DE899
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742401404; cv=none; b=j4XuVeRCfIwbExvQU7u7JCvxWrUOw4v83iNZs2/VzKAjH4qVDtDxuOuN0D/vXld/SwwOAXPg7h9km/htdykauK3pQjRipye+vQLzdr2uEWnRR0n8cAToejEqh+ALHP0oWOeOm8EQ04GZz1JbmeCCQMWUoyF6gBvo+M5uWtS9QLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742401404; c=relaxed/simple;
	bh=PHV5XdEJQIRjIxC4xV3DwjZrpJQnUO86oDOnvrbe16g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DIK/4Zku+hdFXCxsTluD1rglRSUyr5Wt/dt43IJelLFpFL1s5YvrY9ufk8SL9mZBUbbyds9TaDckeon4VMzf4uKsD8ZokFZwxi0nO+yBhTGikvgXE6C6e5BnRprmcCNnOgG35tQbw9H6csC8gByRnNG5UOL1hL+9NNPUNDOMUhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tuwCO-0001uf-Pl; Wed, 19 Mar 2025 17:23:20 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: reject non-serializeable typeof expressions
Date: Wed, 19 Mar 2025 17:22:40 +0100
Message-ID: <20250319162244.884-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon asserts with:
BUG: unhandled key type 13
nft: src/intervals.c:73: setelem_expr_to_range: Assertion `0' failed.

This should be rejected at parser stage, but the check for udata
support was only done on the first item in a concatenation.

After fix, parser rejects this with:
Error: primary expression type 'symbol' lacks typeof serialization

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                 | 14 ++++++++++----
 .../nft-f/typeof_map_with_plain_integer_assert     |  7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4d4d39342bf7..cc3c908593a0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -816,8 +816,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
-%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
-%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
+%type <expr>			primary_expr shift_expr and_expr primary_typeof_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
+%destructor { expr_free($$); }	primary_expr shift_expr and_expr primary_typeof_expr typeof_expr typeof_data_expr typeof_key_expr typeof_verdict_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
@@ -2142,7 +2142,7 @@ typeof_data_expr	:	INTERVAL	typeof_expr
 			}
 			;
 
-typeof_expr		:	primary_expr
+primary_typeof_expr	:	primary_expr
 			{
 				if (expr_ops($1)->build_udata == NULL) {
 					erec_queue(error(&@1, "primary expression type '%s' lacks typeof serialization", expr_ops($1)->name),
@@ -2153,7 +2153,13 @@ typeof_expr		:	primary_expr
 
 				$$ = $1;
 			}
-			|	typeof_expr		DOT		primary_expr
+			;
+
+typeof_expr		:	primary_typeof_expr
+			{
+				$$ = $1;
+			}
+			|	typeof_expr		DOT		primary_typeof_expr
 			{
 				struct location rhs[] = {
 					[1]	= @2,
diff --git a/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert b/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert
new file mode 100644
index 000000000000..f1dc12f699ec
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/typeof_map_with_plain_integer_assert
@@ -0,0 +1,7 @@
+table ip t {
+        map m {
+                typeof ip saddr . meta mark  . 0: verdict
+                flags interval
+                elements = { 127.0.0.1-127.0.0.4 . 0x00123434-0x00b00122 : accept }
+        }
+}
-- 
2.48.1

