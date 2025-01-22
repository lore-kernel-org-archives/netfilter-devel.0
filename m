Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D318186A
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2025 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737537524; cv=none; b=FUaIacEYjy1VO767fw0GRpykxH+bz54ftzoWA7t1aPfEG/JXXqEzoOPANDHcKYaSp8w7+uAMA7LVdWld/oRoA+e8jt/5k6DSmcIr0mlfmnKXtQVnShNipUUHi9TjGf/3MSUvarBh3Lfs9sZtq49Z3V88p6yolEWAnsH7NvyVjOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737537524; c=relaxed/simple;
	bh=flGj90Dn0iBJ9Q9jWGiwssx7DCo9wNoXG9MN0SiHEe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDfUns/WBx9LbEvCtPfItDJW2Vdbb7Dw/fKtT+MUByqojo9L0WMqdDmVqFKm4NJmCeeTphrjKjkR+O6OsU4wXwfPzLVD1tLGxhZJN8b4tQEXCTI2UAIlVUjtiIpKe8b8K/e1wo7FZvIeuPrBJXQdgyOrCIEinZ3QyUcJDn9xvyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1taWsd-0001Df-Q7; Wed, 22 Jan 2025 10:18:35 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH nft] evaluate: allow to re-use existing metered set
Date: Wed, 22 Jan 2025 10:18:04 +0100
Message-ID: <20250122091830.254604-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121213312.GA16069@breakpoint.cc>
References: <20250121213312.GA16069@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit translates old meter syntax (which used to allocate an
anonymous set) to dynamic sets.

A side effect of this is that re-adding a meter rule after chain was
flushed results in an error, unlike anonymous sets named sets are not
impacted by the flush.

Refine this: if a set of the same name exists and is compatible, then
re-use it instead of returning an error.

Also pick up the reproducer kindly provided by the reporter and place it
in the shell test directory.

Fixes: b8f8ddfff733 ("evaluate: translate meter into dynamic set")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                |  46 ++++++--
 .../sets/dumps/meter_set_reuse.json-nft       | 105 ++++++++++++++++++
 .../testcases/sets/dumps/meter_set_reuse.nft  |  11 ++
 tests/shell/testcases/sets/meter_set_reuse    |  20 ++++
 4 files changed, 173 insertions(+), 9 deletions(-)
 create mode 100644 tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/meter_set_reuse.nft
 create mode 100755 tests/shell/testcases/sets/meter_set_reuse

diff --git a/src/evaluate.c b/src/evaluate.c
index 919ef90707d9..50443df14df4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3356,7 +3356,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct expr *key, *set, *setref;
+	struct expr *key, *setref;
 	struct set *existing_set;
 	struct table *table;
 
@@ -3367,7 +3367,9 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 		return table_not_found(ctx);
 
 	existing_set = set_cache_find(table, stmt->meter.name);
-	if (existing_set)
+	if (existing_set &&
+	    (!set_is_meter_compat(existing_set->flags) ||
+	     set_is_map(existing_set->flags)))
 		return cmd_error(ctx, &stmt->location,
 				 "%s; meter '%s' overlaps an existing %s '%s' in family %s",
 				 strerror(EEXIST),
@@ -3388,17 +3390,43 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 	/* Declare an empty set */
 	key = stmt->meter.key;
-	set = set_expr_alloc(&key->location, NULL);
-	set->set_flags |= NFT_SET_EVAL;
-	if (key->timeout)
-		set->set_flags |= NFT_SET_TIMEOUT;
+	if (existing_set) {
+		if ((existing_set->flags & NFT_SET_TIMEOUT) && !key->timeout)
+			return expr_error(ctx->msgs, stmt->meter.key,
+					  "existing set '%s' has timeout flag",
+					  stmt->meter.name);
+
+		if ((existing_set->flags & NFT_SET_TIMEOUT) == 0 && key->timeout)
+			return expr_error(ctx->msgs, stmt->meter.key,
+					  "existing set '%s' lacks timeout flag",
+					  stmt->meter.name);
+
+		if (stmt->meter.size > 0 && existing_set->desc.size != stmt->meter.size)
+			return expr_error(ctx->msgs, stmt->meter.key,
+					  "existing set '%s' has size %u, meter has %u",
+					  stmt->meter.name, existing_set->desc.size,
+					  stmt->meter.size);
+	}
+
+	if (existing_set) {
+		setref = set_ref_expr_alloc(&key->location, existing_set);
+	} else {
+		struct expr *set;
+
+		set = set_expr_alloc(&key->location, existing_set);
+		if (key->timeout)
+			set->set_flags |= NFT_SET_TIMEOUT;
+
+		set->set_flags |= NFT_SET_EVAL;
+		setref = implicit_set_declaration(ctx, stmt->meter.name,
+						  expr_get(key), NULL, set, 0);
+		if (setref)
+			setref->set->desc.size = stmt->meter.size;
+	}
 
-	setref = implicit_set_declaration(ctx, stmt->meter.name,
-					  expr_get(key), NULL, set, 0);
 	if (!setref)
 		return -1;
 
-	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
 
 	if (stmt_evaluate(ctx, stmt->meter.stmt) < 0)
diff --git a/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
new file mode 100644
index 000000000000..ab4ac06184d0
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
@@ -0,0 +1,105 @@
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
+        "family": "ip",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "input",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "http1",
+        "table": "filter",
+        "type": [
+          "inet_service",
+          "ipv4_addr"
+        ],
+        "handle": 0,
+        "size": 65535,
+        "flags": [
+          "dynamic"
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "filter",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "right": 80
+            }
+          },
+          {
+            "set": {
+              "op": "add",
+              "elem": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  }
+                ]
+              },
+              "set": "@http1",
+              "stmt": [
+                {
+                  "limit": {
+                    "rate": 200,
+                    "burst": 5,
+                    "per": "second",
+                    "inv": true
+                  }
+                }
+              ]
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          },
+          {
+            "drop": null
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/meter_set_reuse.nft b/tests/shell/testcases/sets/dumps/meter_set_reuse.nft
new file mode 100644
index 000000000000..f911acaffb85
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/meter_set_reuse.nft
@@ -0,0 +1,11 @@
+table ip filter {
+	set http1 {
+		type inet_service . ipv4_addr
+		size 65535
+		flags dynamic
+	}
+
+	chain input {
+		tcp dport 80 add @http1 { tcp dport . ip saddr limit rate over 200/second burst 5 packets } counter packets 0 bytes 0 drop
+	}
+}
diff --git a/tests/shell/testcases/sets/meter_set_reuse b/tests/shell/testcases/sets/meter_set_reuse
new file mode 100755
index 000000000000..94eccc1a7b82
--- /dev/null
+++ b/tests/shell/testcases/sets/meter_set_reuse
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+set -e
+
+addrule()
+{
+	$NFT add rule ip filter input tcp dport 80 meter http1 { tcp dport . ip saddr limit rate over 200/second } counter drop
+}
+
+$NFT add table filter
+$NFT add chain filter input
+addrule
+
+$NFT list meters
+
+# This used to remove the anon set, but not anymore
+$NFT flush chain filter input
+
+# This re-add should work.
+addrule
-- 
2.48.1

