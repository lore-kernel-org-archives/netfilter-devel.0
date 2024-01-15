Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477C17544
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rPMzr-0006Aa-9M; Mon, 15 Jan 2024 14:27:23 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: fix sym refcount assertion
Date: Mon, 15 Jan 2024 14:27:15 +0100
Message-ID: <20240115132718.24150-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Scope release must happen last.
afl provided a reproducer where policy is a define, because
scope is released too early we get:
nft: src/rule.c:559: scope_release: Assertion `sym->refcnt == 1' failed.

... because chain->policy is EXPR_SYMBOL.

Fixes: 627c451b2351 ("src: allow variables in the chain priority specification")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                                              | 6 +++++-
 tests/shell/testcases/bogons/nft-f/define_policy_assert | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/define_policy_assert

diff --git a/src/rule.c b/src/rule.c
index 4138c21b81bc..68b19c211b8a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -729,7 +729,6 @@ void chain_free(struct chain *chain)
 	list_for_each_entry_safe(rule, next, &chain->rules, list)
 		rule_free(rule);
 	handle_free(&chain->handle);
-	scope_release(&chain->scope);
 	free_const(chain->type.str);
 	expr_free(chain->dev_expr);
 	for (i = 0; i < chain->dev_array_len; i++)
@@ -738,6 +737,11 @@ void chain_free(struct chain *chain)
 	expr_free(chain->priority.expr);
 	expr_free(chain->policy);
 	free_const(chain->comment);
+
+	/* MUST be released after all expressions, they could
+	 * hold refcounts.
+	 */
+	scope_release(&chain->scope);
 	free(chain);
 }
 
diff --git a/tests/shell/testcases/bogons/nft-f/define_policy_assert b/tests/shell/testcases/bogons/nft-f/define_policy_assert
new file mode 100644
index 000000000000..f1e58b551304
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/define_policy_assert
@@ -0,0 +1,3 @@
+chain y x { priority filter
+define p = foo
+policy $p
-- 
2.43.0

