Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7D3B8413
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789154423; cv=none; b=rBWOn0Tv0BzUpFCCkPoUfkQclM29fFsi4hL0ZSg1YMU/N0hk2d+7GLwV0+JRRIK6y4M65TCCTe1Kddypy53N4d7XUXG0/cfn6p8UwVAh2XRpOAh0Znx8DlQNsAllSDQ/huIeWcdyrpJsPeprKjuWrNGfQJ069ViZSkDxfRdxZfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789154423; c=relaxed/simple;
	bh=S7kT94gyWHWbRJUXlP+n5VOhNPdwJZ9KetYD4zW3obk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SclKNkoRF3VhP+JlL5H55DJnQjBaAS2suEEmb5ZfhSDSrHBBnkm0BdoqK5FddB4TFOskffXa9RNSHF31ri8pIX6B2YatcuPCszyvXYq8Qf/RXVyH9vqOhEoPvvOWgk6pJ+C4DfucYQOtQxxYj0Wv2yC/DJqZZQeFRPUgts9E91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOHkME6s; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOHkME6s"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc149372c14so1004931a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 12:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789154414; x=1789759214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Ltn9QsACl3W1ghNoImkrkU5bUSxgLkJUPq5HsL+RRs=;
        b=pOHkME6s5Tu5FWP/ViZCLA9qEsFtzDD1SCngn14Ocx1bG+5s7EWKZ0Isj9X5iY9veZ
         jA5Yp7frfzWHDDp9wwfCFBtAueZ+xqyH7Hv13ZTZiK5XFUpSvt6nUyGhKfEksfB7mjNc
         I8UKnAa7bSThYuRRpA2vMzUprC0xX3kfWyPTSg7J+dHw/KSy3VIYzZZc0fZCg7INL/XC
         ahZOqb0/pIQ5sp4y4yVn8lqWwxozgPLcGjryVYq0KrzQTj7fMhKy+jzjtEDvJx5eqzNT
         u7YDh/P4Ce8KSdf5ORvls7qUVPMeqvphmpOCzIz1txn3mU6Ve0yI1tNfIlgx/Z1xkt1m
         qoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789154414; x=1789759214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Ltn9QsACl3W1ghNoImkrkU5bUSxgLkJUPq5HsL+RRs=;
        b=VKBHuFU9b6bm8gEuEcxC/DYQOV9agej30iO7qaTdVsVuHAry8Q4YJ2VnbN50d1zO8R
         8/zoVt0Oquc7BIzMwJtiQZ6CNRHMxBcYXqwZLSPeDb1ReGPVGLyv/s2W0Wujs4dBCpnZ
         EGN1I0g9GLgCf7eo6bQqAXeCSeZGMtsBF27AF0YSgjZuKqfKr6EsOv/mmCIZezBDBaf0
         Rp8tZbwS5JlcJBOGapZf+mtPAaE30VqTXOrJQNpBxFRNTkgU432z0wcyAuhSk10ENohC
         hpYjqellwSCFR+uV7e4u/OmNtIVzoyDPf2U9VHMJg9PdnCiD5A52o2Vv2ZpsnBjlVXL/
         FzEw==
X-Gm-Message-State: AFuF++k84RNsdDp23Gwnq84pqgQRSEbgo69rujY9JySrCiOJQgE0edNr
	2MDSeg3DJr3dUz7lL321ZMr+TEhZF/BzCm31l3Rolzhh557vkiYnZHZunfAXDn+M
X-Gm-Gg: AYBFou2uRPn4/fQxsw6OktJyqbcdri9mw2NJCPldJWwlAPdyL9axIQc3lia9InPjQqX
	uIx+Ban2XAJT9c/baQ2j+ZY5oltSTPNePJ+aFEU5YDgfND615rbcWwBlX2AAT9n8IN+N7PTXJYJ
	nmtctMEN8RVrBvNdZcaUQuCQH593Fnsc+7HiwsbUtGWNaY+bVejJzko4uKtuE/fABd84sVGAt5U
	tIf219U5yMW44e2kcS8lFZyWW1VyKQxVtMhPBzZ6pRvOKmTh2yia5WJ82mDXti86e7UK3omuq/V
	hROHy+SpC/957K6kTw2WuIOYr8nloXLxV3zZfLS1OhC+z1ScACg/Uir771hVcZe5prL2wnJ+rpJ
	KtOaFnbMpbiI32fKFCquz1H95nE6nB1ZVtvGeynVDkzqWHXuJSKpBKM0lK5LYgQdvRi1OFWamVF
	vOnngmd6zNOXdZXm0mkjKuropm9gG2yzv+LmeLgLEiNCgiIwIeE3ojXaRJ15FYXNYF18EF3QIgz
	d+Bt5TKTFu2XWZ+MF2aTxFvJzty45Yr
X-Received: by 2002:a05:6a21:113:b0:3da:7140:da35 with SMTP id adf61e73a8af0-3daed331022mr10233371637.15.1789154413958;
        Fri, 11 Sep 2026 12:20:13 -0700 (PDT)
Received: from r912.4v1.in ([182.70.116.80])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4cf015csm9350289eec.4.2026.09.11.12.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 12:20:13 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Kamil Kwiek <kamil.kwiek@gmail.com>
Subject: [PATCH nft] src: release scope symbols by reference count
Date: Sat, 12 Sep 2026 00:50:09 +0530
Message-ID: <20260911192009.2472193-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft -f aborts when a define in table or chain scope takes its value from
another variable:

  define outer = 111

  table inet t {
          define inner = $outer
  }

  nft: src/rule.c:579: scope_release: Assertion `sym->refcnt == 1' failed.

$outer becomes a variable expression that takes a reference on the
symbol, and it is still holding that reference when the top level scope
is released: the table has gone into the cache, so cmd_free() drops one
of its references rather than freeing it.  Using $inner in a rule does
not release it either, expr_evaluate_variable() shares or clones
sym->expr rather than destroying it.

It happens without the cache too.  When the table already exists,
cmd_free() frees it together with its scope, while the rule commands
that nft_cmd_expand() split out of the same block are still holding
their variable expressions.

scope_release() asserted the count was 1 and then freed the symbol
whatever it was, so on a build with NDEBUG this is a use-after-free
rather than an abort.  The same gap leaks a symbol that is undefined
while a define still refers to it.

Ordering fixes, as in b73298405cda ("rule: fix sym refcount assertion"),
settle one instance at a time.  Make the count own the symbol instead:
scope_release() and variable_expr_destroy() both release through
symbol_put(), so the symbol goes away with its last reference and the
order these run in stops mattering.

Fixes: 12a223ced7f6 ("libnftables: release top level scope")
Reported-by: Kamil Kwiek <kamil.kwiek@gmail.com>
Closes: https://lore.kernel.org/netfilter/20260910190351.38f2aafd@devtravel.lan/
Assisted-by: LLM
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
Both new tests fail without the patch, nft aborts rather than returning, and
pass with it.  The rest of tests/shell is unchanged here: 498 ok, 10 skipped,
and 6 failures that are there with or without the patch.

Built with -DNDEBUG and ASan, both shapes above report a heap-use-after-free
before the patch and are clean after it, as is the whole of tests/shell (no
reports with ASAN_OPTIONS=log_path set).  With LSan, the undefine case leaks
the symbol before and nothing after.

The patch drops the assert from scope_release().  The same check still holds
in scope_free(), which runs once the cache has been released, so I can add it
there in a second patch if you would rather keep it somewhere.

 include/rule.h                                |  1 +
 src/expression.c                              |  3 +-
 src/rule.c                                    |  7 +--
 .../shell/testcases/nft-f/0033define_scope_0  | 22 ++++++++
 .../nft-f/0034define_scope_existing_1         | 25 +++++++++
 .../nft-f/dumps/0033define_scope_0.json-nft   | 53 +++++++++++++++++++
 .../nft-f/dumps/0033define_scope_0.nft        |  5 ++
 .../0034define_scope_existing_1.json-nft      | 18 +++++++
 .../dumps/0034define_scope_existing_1.nft     |  2 +
 9 files changed, 129 insertions(+), 7 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0033define_scope_0
 create mode 100755 tests/shell/testcases/nft-f/0034define_scope_existing_1
 create mode 100644 tests/shell/testcases/nft-f/dumps/0033define_scope_0.json-nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0033define_scope_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.json-nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.nft

diff --git a/include/rule.h b/include/rule.h
index 77023da2..7b7b7eb1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -126,6 +126,7 @@ extern struct symbol *symbol_lookup(const struct scope *scope,
 struct symbol *symbol_lookup_fuzzy(const struct scope *scope,
 				   const char *identifier);
 struct symbol *symbol_get(const struct scope *scope, const char *identifier);
+void symbol_put(struct symbol *sym);
 
 enum table_flags {
 	TABLE_F_DORMANT		= (1 << 0),
diff --git a/src/expression.c b/src/expression.c
index 39221ba8..c450746a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -352,8 +352,7 @@ static void variable_expr_clone(struct expr *new, const struct expr *expr)
 
 static void variable_expr_destroy(struct expr *expr)
 {
-	assert_refcount_safe(expr->sym->refcnt);
-	expr->sym->refcnt--;
+	symbol_put(expr->sym);
 }
 
 static const struct expr_ops variable_expr_ops = {
diff --git a/src/rule.c b/src/rule.c
index 85376e63..0ffe2ca1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -576,11 +576,8 @@ void scope_release(const struct scope *scope)
 	struct symbol *sym, *next;
 
 	list_for_each_entry_safe(sym, next, &scope->symbols, list) {
-		assert(sym->refcnt == 1);
 		list_del(&sym->list);
-		free_const(sym->identifier);
-		expr_free(sym->expr);
-		free(sym);
+		symbol_put(sym);
 	}
 }
 
@@ -616,7 +613,7 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
 	return sym;
 }
 
-static void symbol_put(struct symbol *sym)
+void symbol_put(struct symbol *sym)
 {
 	assert_refcount_safe(sym->refcnt);
 	if (--sym->refcnt == 0) {
diff --git a/tests/shell/testcases/nft-f/0033define_scope_0 b/tests/shell/testcases/nft-f/0033define_scope_0
new file mode 100755
index 00000000..dcb258a7
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0033define_scope_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# a define in table or chain scope holds a reference to the outer variable it
+# expands to.  The table is kept in the cache once the ruleset is committed, so
+# that reference outlives the release of the top-level scope.
+
+set -e
+
+RULESET="define outer = 111
+
+table inet t {
+	define t_unused = \$outer
+	define t_used = \$outer
+
+	chain c {
+		define c_unused = \$outer
+
+		meta iifgroup { \$t_used } counter
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0034define_scope_existing_1 b/tests/shell/testcases/nft-f/0034define_scope_existing_1
new file mode 100755
index 00000000..a14a58dd
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0034define_scope_existing_1
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# Same defines, but the table already exists in the kernel, so table_evaluate()
+# takes no reference on the parsed one.  nft_cmd_expand() has moved the rules
+# into commands of their own, and cmd_free() frees the table and its scope while
+# a rule command still holds the variable expression.  The rule is rejected on
+# purpose, which is what leaves that expression unevaluated.
+#
+# The ruleset must be rejected with 1, not aborted.
+
+set -e
+
+$NFT add table inet t
+
+RULESET="table inet t {
+	define B = 111
+
+	chain c {
+		tcp dport 70000 meta iifgroup \$B counter
+	}
+}"
+
+rc=0
+$NFT -f - <<< "$RULESET" || rc=$?
+[ "$rc" -eq 1 ]
diff --git a/tests/shell/testcases/nft-f/dumps/0033define_scope_0.json-nft b/tests/shell/testcases/nft-f/dumps/0033define_scope_0.json-nft
new file mode 100644
index 00000000..0aa83c42
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0033define_scope_0.json-nft
@@ -0,0 +1,53 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "inet",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "iifgroup"
+                }
+              },
+              "right": 111
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/nft-f/dumps/0033define_scope_0.nft b/tests/shell/testcases/nft-f/dumps/0033define_scope_0.nft
new file mode 100644
index 00000000..d206007a
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0033define_scope_0.nft
@@ -0,0 +1,5 @@
+table inet t {
+	chain c {
+		iifgroup 111 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.json-nft b/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.json-nft
new file mode 100644
index 00000000..10372b0e
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.json-nft
@@ -0,0 +1,18 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "inet",
+        "name": "t",
+        "handle": 0
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.nft b/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.nft
new file mode 100644
index 00000000..17838bdf
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0034define_scope_existing_1.nft
@@ -0,0 +1,2 @@
+table inet t {
+}

base-commit: fcef13a358a0755a0bd980910d47989b064a756d
-- 
2.55.0

