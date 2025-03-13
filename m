Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5572698B9
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 16:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741884039; cv=none; b=ReQ6jIW4RDPpOi1PDkK6TMdvhruPvjIh+PB2q+fgG5OsxG+h+Xym2HZbzbUHYeAj5lCnFezFWbrLYGRl8uhyiSHllBI+FJtoAmZqNhVP9C6+ivK03Qh2T00h73Y9F3NhN/b+tQP85lMbHTfesovwHDaMy2lIBXOpA8jQmUsEfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741884039; c=relaxed/simple;
	bh=Zs7uF0TlPB23vcdhsEMnMBDxLOBOQ1ElhtEhHpzkbyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mvw3uVFzRGvK8qER7VwVQ4Vc7RPYxb6qd7Gk7KPXNFZVMHAXagIFTogJD6J9sSzh95c/SSYrfwkjDLi9sb9+zxfcPyy4/JlWATUH3DbLnpJs3GstayCNt0vzysBULA5H8eQKHY7VHhKUfZgYFh+nDpXq5/wBKj3fJ5hHYqeNU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tslbn-0004nZ-6o; Thu, 13 Mar 2025 17:40:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expression: tolerate named set protocol dependency
Date: Thu, 13 Mar 2025 17:39:51 +0100
Message-ID: <20250313163955.13487-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included test will fail with:
/dev/stdin:8:38-52: Error: Transparent proxy support requires transport protocol match
   meta l4proto @protos tproxy to :1088
                        ^^^^^^^^^^^^^^^
Tolerate a set reference too.  Because the set can be empty (or there
can be removals later), add a fake 0-rhs value.

This will make pctx_update assign proto_unknown as the transport protocol
in use, Thats enough to avoid 'requires transport protocol' error.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1686
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c                              | 10 +++
 .../dumps/named_set_as_protocol_dep.json-nft  | 75 +++++++++++++++++++
 .../nft-f/dumps/named_set_as_protocol_dep.nft | 11 +++
 .../testcases/nft-f/named_set_as_protocol_dep |  5 ++
 4 files changed, 101 insertions(+)
 create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
 create mode 100755 tests/shell/testcases/nft-f/named_set_as_protocol_dep

diff --git a/src/expression.c b/src/expression.c
index 8a90e09dd1c5..38d3ad6d6a4b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -945,6 +945,16 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 				    i->key->etype == EXPR_VALUE)
 					ops->pctx_update(ctx, &expr->location, left, i->key);
 			}
+		} else if (right->etype == EXPR_SET_REF) {
+			const struct expr *key = right->set->key;
+			struct expr *tmp;
+
+			tmp = constant_expr_alloc(&expr->location, key->dtype,
+						  key->byteorder, key->len,
+						  NULL);
+
+			ops->pctx_update(ctx, &expr->location, left, tmp);
+			expr_free(tmp);
 		}
 	}
 }
diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
new file mode 100644
index 000000000000..4bc24aa319ab
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
@@ -0,0 +1,75 @@
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
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "test",
+        "name": "prerouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -150,
+        "policy": "accept"
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "protos",
+        "table": "test",
+        "type": {
+          "typeof": {
+            "meta": {
+              "key": "l4proto"
+            }
+          }
+        },
+        "handle": 0,
+        "elem": [
+          "tcp",
+          "udp"
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "test",
+        "chain": "prerouting",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "l4proto"
+                }
+              },
+              "right": "@protos"
+            }
+          },
+          {
+            "tproxy": {
+              "port": 1088
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
new file mode 100644
index 000000000000..2bc0c2adb38c
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
@@ -0,0 +1,11 @@
+table inet test {
+	set protos {
+		typeof meta l4proto
+		elements = { tcp, udp }
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority mangle; policy accept;
+		meta l4proto @protos tproxy to :1088
+	}
+}
diff --git a/tests/shell/testcases/nft-f/named_set_as_protocol_dep b/tests/shell/testcases/nft-f/named_set_as_protocol_dep
new file mode 100755
index 000000000000..5c516e421cd6
--- /dev/null
+++ b/tests/shell/testcases/nft-f/named_set_as_protocol_dep
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile" || exit 1
-- 
2.45.3

