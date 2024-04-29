Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F2E13F006
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2024 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714421190; cv=none; b=aHgaZ5nLp8bwVXUG9ooiLdkgy/jb0mP+1fG2p3NiDKcN9+16caPHPaTtMXdo8Q73IkRrKcs9o+PxOQlgWNo3NN4RMytyJLecGWcgN5Vh7q8MfF+MSo3xG4B2118IooMYtM0ZHwN5Hl+6ycbffe+pKwmGL1SRZhQ+malWgVkpIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714421190; c=relaxed/simple;
	bh=QVIz+n9yIquE9bpQ/1NPnWUmebsax9vEk0muGtYNy3M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxcJQ5P2unhIZbRm7V3XeDn2eEvGRZ9YiSFVm4NTclO+avpyF3Igw08wXgUsKrTdh3Y3IO/uVFBZQHmSXcGduU+nU3fzmVGubd+lhJlnJgrg0pCQFV64OtYDYb1o2/48TcgxqPYMAJSVUPb3bLDLje0/ZYwtPMb989iNGFWjYT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Kg9xbh1O; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Kg9xbh1O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e2pVW6hPb684842msrV/Q65HRmbTXusZxaQ8sFG3cxc=; b=Kg9xbh1OnPtJZ1PQWQUJxpwgvv
	s8kcBSpwOHNNTVMg1h507lZ9e8MAD1sutnZ3m+zE0zW9X3IWn3ULtSdk/OuJum9vrVTBsVi9Pzwxz
	69zT4S68l1pvkCIkLOddNe3EGiy489fAw2Naf1R6XS9ZRee+J3qT+5hx4iXMkiHvxmeyHYCLwe8BT
	TJ5vP4mlsh0JHBTD82ThZPtlCbEgboxsJBRYdgTWgBZBAFOIZcKtreRzbWOCaK7MmDmQl+S99jJTb
	HlH1HSHHQFW0JKRUvBB4GhcwQcwFnaFUiWpUNKnnKvqFdAzwZxGhaw/ICqof7RLkDTpb2atRnf2qK
	doiXJefw==;
Received: from dreamlands.azazel.net ([81.187.231.252] helo=ulthar.dreamlands.azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1s1WfP-00G8U5-2g
	for netfilter-devel@vger.kernel.org;
	Mon, 29 Apr 2024 20:27:59 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 2/2] evaluate: add support for variables in map expressions
Date: Mon, 29 Apr 2024 20:27:53 +0100
Message-ID: <20240429192756.1347369-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240429192756.1347369-1-jeremy@azazel.net>
References: <20240429192756.1347369-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 81.187.231.252
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

It is possible to use a variable to initialize a map, which is then used
in a map statement:

  define dst_map = { ::1234 : 5678 }

  table ip6 nat {
    map dst_map {
      typeof ip6 daddr : tcp dport;
      elements = $dst_map
    }
    chain prerouting {
      ip6 nexthdr tcp redirect to ip6 daddr map @dst_map
    }
  }

However, if one tries to use the variable directly in the statement:

  define dst_map = { ::1234 : 5678 }

  table ip6 nat {
    chain prerouting {
      ip6 nexthdr tcp redirect to ip6 daddr map $dst_map
    }
  }

nft rejects it:

  /space/azazel/tmp/ruleset.1067161.nft:5:47-54: Error: invalid mapping expression variable
      ip6 nexthdr tcp redirect to ip6 daddr map $dst_map
                                  ~~~~~~~~~     ^^^^^^^^
It also rejects variables in stateful object statements:

  define quota_map = { 192.168.10.123 : "user123", 192.168.10.124 : "user124" }

  table ip nat {
    quota user123 { over 20 mbytes }
    quota user124 { over 20 mbytes }
    chain prerouting {
      quota name ip saddr map $quota_map
    }
  }

thus:

  /space/azazel/tmp/ruleset.1067161.nft:15:29-38: Error: invalid mapping expression variable
      quota name ip saddr map $quota_map
                 ~~~~~~~~     ^^^^^^^^^^

Add support for these uses together with some test-cases.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067161
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c                                |  12 ++
 .../shell/testcases/maps/0024named_objects_1  |  31 ++++
 .../shell/testcases/maps/0024named_objects_2  |  23 +++
 .../shell/testcases/maps/anonymous_snat_map_1 |  16 ++
 .../shell/testcases/maps/anonymous_snat_map_2 |  23 +++
 .../maps/dumps/0024named_objects_1.json-nft   | 147 ++++++++++++++++++
 .../maps/dumps/0024named_objects_1.nft        |  23 +++
 .../maps/dumps/anonymous_snat_map_1.json-nft  |  58 +++++++
 .../maps/dumps/anonymous_snat_map_1.nft       |   5 +
 9 files changed, 338 insertions(+)
 create mode 100755 tests/shell/testcases/maps/0024named_objects_1
 create mode 100755 tests/shell/testcases/maps/0024named_objects_2
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_2
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_1.nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index f28ef2aad8f4..f26bc7f9b0ed 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2061,6 +2061,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	mappings->set_flags |= NFT_SET_MAP;
 
 	switch (map->mappings->etype) {
+	case EXPR_VARIABLE:
 	case EXPR_SET:
 		if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
 			key = expr_clone(ctx->ectx.key);
@@ -2104,6 +2105,11 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
 			return -1;
 
+		if (map->mappings->set->init->etype != EXPR_SET) {
+			return expr_error(ctx->msgs, map->mappings->set->init,
+					  "Expression is not a map");
+		}
+
 		if (set_is_interval(map->mappings->set->init->set_flags) &&
 		    !(map->mappings->set->init->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0)
@@ -4576,6 +4582,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 	mappings->set_flags |= NFT_SET_OBJECT;
 
 	switch (map->mappings->etype) {
+	case EXPR_VARIABLE:
 	case EXPR_SET:
 		key = constant_expr_alloc(&stmt->location,
 					  ctx->ectx.dtype,
@@ -4595,6 +4602,11 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
 			return -1;
 
+		if (map->mappings->set->init->etype != EXPR_SET) {
+			return expr_error(ctx->msgs, map->mappings->set->init,
+					  "Expression is not a map");
+		}
+
 		if (set_is_interval(map->mappings->set->init->set_flags) &&
 		    !(map->mappings->set->init->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0)
diff --git a/tests/shell/testcases/maps/0024named_objects_1 b/tests/shell/testcases/maps/0024named_objects_1
new file mode 100755
index 000000000000..a861e9e2d4a0
--- /dev/null
+++ b/tests/shell/testcases/maps/0024named_objects_1
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+# This is the test-case:
+# * creating valid named objects and using map variables in statements
+
+RULESET='
+define counter_map = { 192.168.2.2 : "user123", 1.1.1.1 : "user123", 2.2.2.2 : "user123" }
+define quota_map = { 192.168.2.2 : "user124", 192.168.2.3 : "user124" }
+
+table inet x {
+	counter user123 {
+		packets 12 bytes 1433
+	}
+	counter user321 {
+		packets 12 bytes 1433
+	}
+	quota user123 {
+		over 2000 bytes
+	}
+	quota user124 {
+		over 2000 bytes
+	}
+	chain y {
+		type filter hook input priority 0; policy accept;
+		counter name ip saddr map $counter_map
+		quota name ip saddr map $quota_map drop
+	}
+}'
+
+set -e
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/maps/0024named_objects_2 b/tests/shell/testcases/maps/0024named_objects_2
new file mode 100755
index 000000000000..584b5100f650
--- /dev/null
+++ b/tests/shell/testcases/maps/0024named_objects_2
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+#
+# Test some error conditions for using variables to define maps
+#
+
+set -e
+
+for m in "192.168.2.2" "{ 192.168.2.2, 1.1.1.1, 2.2.2.2 }"; do
+
+    RULESET="
+define m = $m"'
+table inet x {
+	chain y {
+		type filter hook input priority 0; policy accept;
+		counter name ip saddr map $m
+	}
+}'
+
+    $NFT -f - <<< "$RULESET" || rc=$?
+    test $rc = 1
+
+done
diff --git a/tests/shell/testcases/maps/anonymous_snat_map_1 b/tests/shell/testcases/maps/anonymous_snat_map_1
new file mode 100755
index 000000000000..031de0c1a83f
--- /dev/null
+++ b/tests/shell/testcases/maps/anonymous_snat_map_1
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+# Variable containing anonymous map can be added to a snat rule
+
+set -e
+
+RULESET='
+define m = {1.1.1.1 : 2.2.2.2}
+table nat {
+  chain postrouting {
+    snat ip saddr map $m
+  }
+}
+'
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/maps/anonymous_snat_map_2 b/tests/shell/testcases/maps/anonymous_snat_map_2
new file mode 100755
index 000000000000..90e02038093c
--- /dev/null
+++ b/tests/shell/testcases/maps/anonymous_snat_map_2
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+#
+# Test some error conditions for using variables to define maps
+#
+
+set -e
+
+for m in "1.1.1.1" "{1.1.1.1}"; do
+
+    RULESET="
+define m = $m"'
+table nat {
+  chain postrouting {
+    snat ip saddr map $m
+  }
+}
+'
+
+    $NFT -f - <<< "$RULESET" || rc=$?
+    test $rc = 1
+
+done
diff --git a/tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft b/tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft
new file mode 100644
index 000000000000..e3fab16d3337
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0024named_objects_1.json-nft
@@ -0,0 +1,147 @@
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
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "counter": {
+        "family": "inet",
+        "name": "user123",
+        "table": "x",
+        "handle": 0,
+        "packets": 12,
+        "bytes": 1433
+      }
+    },
+    {
+      "counter": {
+        "family": "inet",
+        "name": "user321",
+        "table": "x",
+        "handle": 0,
+        "packets": 12,
+        "bytes": 1433
+      }
+    },
+    {
+      "quota": {
+        "family": "inet",
+        "name": "user123",
+        "table": "x",
+        "handle": 0,
+        "bytes": 2000,
+        "used": 0,
+        "inv": true
+      }
+    },
+    {
+      "quota": {
+        "family": "inet",
+        "name": "user124",
+        "table": "x",
+        "handle": 0,
+        "bytes": 2000,
+        "used": 0,
+        "inv": true
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": {
+              "map": {
+                "key": {
+                  "payload": {
+                    "protocol": "ip",
+                    "field": "saddr"
+                  }
+                },
+                "data": {
+                  "set": [
+                    [
+                      "1.1.1.1",
+                      "user123"
+                    ],
+                    [
+                      "2.2.2.2",
+                      "user123"
+                    ],
+                    [
+                      "192.168.2.2",
+                      "user123"
+                    ]
+                  ]
+                }
+              }
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "quota": {
+              "map": {
+                "key": {
+                  "payload": {
+                    "protocol": "ip",
+                    "field": "saddr"
+                  }
+                },
+                "data": {
+                  "set": [
+                    [
+                      "192.168.2.2",
+                      "user124"
+                    ],
+                    [
+                      "192.168.2.3",
+                      "user124"
+                    ]
+                  ]
+                }
+              }
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
diff --git a/tests/shell/testcases/maps/dumps/0024named_objects_1.nft b/tests/shell/testcases/maps/dumps/0024named_objects_1.nft
new file mode 100644
index 000000000000..a8e99a3ca9a2
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0024named_objects_1.nft
@@ -0,0 +1,23 @@
+table inet x {
+	counter user123 {
+		packets 12 bytes 1433
+	}
+
+	counter user321 {
+		packets 12 bytes 1433
+	}
+
+	quota user123 {
+		over 2000 bytes
+	}
+
+	quota user124 {
+		over 2000 bytes
+	}
+
+	chain y {
+		type filter hook input priority filter; policy accept;
+		counter name ip saddr map { 1.1.1.1 : "user123", 2.2.2.2 : "user123", 192.168.2.2 : "user123" }
+		quota name ip saddr map { 192.168.2.2 : "user124", 192.168.2.3 : "user124" } drop
+	}
+}
diff --git a/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
new file mode 100644
index 000000000000..f4c55706787c
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
@@ -0,0 +1,58 @@
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
+        "name": "nat",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "nat",
+        "name": "postrouting",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "nat",
+        "chain": "postrouting",
+        "handle": 0,
+        "expr": [
+          {
+            "snat": {
+              "addr": {
+                "map": {
+                  "key": {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  "data": {
+                    "set": [
+                      [
+                        "1.1.1.1",
+                        "2.2.2.2"
+                      ]
+                    ]
+                  }
+                }
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft
new file mode 100644
index 000000000000..5009560c9d69
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft
@@ -0,0 +1,5 @@
+table ip nat {
+	chain postrouting {
+		snat to ip saddr map { 1.1.1.1 : 2.2.2.2 }
+	}
+}
-- 
2.43.0

