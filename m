Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E86930E83D
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2025 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764075841; cv=none; b=PsqXydrseZhcKIHP8Ad5rYfYD2PeZa/SynKX4iTeiRw2ZJzcU5jX/oDRi46n28cjiWMJjtHYn5kp1AoE44ZCAdrvD5ScpbD1o/WIMOuu5ige9g1/X7N+OOSotzjATXz13pWBn0EU7kb+AYWpHOXGB4Q+UvBhCX9idA0hSW21LWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764075841; c=relaxed/simple;
	bh=ipS22481l4G1jcBaZj2Jg/i3RfM/u7AAI/YIszhut7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=afILIGx+Qw5kM0gwqR5U2u5wP9eL9FcUrBf6EmNgyCDVIdHxnwNJpgpxahUQCWtZxspYmLMp9+eiws2NKXo6yMZzd70g7AtGa3PkqvzgKlxMZ8pVqf6D3IOsza9sLmUP87w0a1h3T8FaRYdicxV+apEWRPuqfQHtop9ieJeGVZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 54D5A60466; Tue, 25 Nov 2025 14:03:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: bad_rule_graphs: add chain linked from different hooks
Date: Tue, 25 Nov 2025 14:03:33 +0100
Message-ID: <20251125130338.6858-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a kernel with broken (never upstreamed) patch this fails with:

Accepted bad ruleset with jump from filter type to masquerade (3)
and
Accepted bad ruleset with jump from prerouting to masquerade

... because bogus optimisation suppresses re-validation of 'n2', even
though it becomes reachable from an invalid base chain (filter, but n2
has nat-only masquerade expression).

Another broken corner-case is validation of the different hook types:
When it becomes reachable from nat:prerouting in addition to the allowed
nat:postrouting the validation step must fail.

Improve test coverage to ensure future optimisations catch this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/transactions/bad_rule_graphs    | 68 +++++++++++++
 .../dumps/bad_rule_graphs.json-nft            | 98 +++++++++++++++++--
 .../transactions/dumps/bad_rule_graphs.nft    | 17 +++-
 3 files changed, 173 insertions(+), 10 deletions(-)

diff --git a/tests/shell/testcases/transactions/bad_rule_graphs b/tests/shell/testcases/transactions/bad_rule_graphs
index 53047c3c229f..1f36bad80792 100755
--- a/tests/shell/testcases/transactions/bad_rule_graphs
+++ b/tests/shell/testcases/transactions/bad_rule_graphs
@@ -259,4 +259,72 @@ $NFT "add rule t c9 tcp dport 80 tproxy to :20000 meta mark set 1 accept"
 good_ruleset $? "add tproxy expression to c9"
 check_bad_expr
 
+$NFT -f - <<EOF
+table t {
+	chain n2 {
+		meta oifname "ppp*" masquerade
+	}
+
+	chain n1 {
+		ip saddr 192.168.0.0/16 jump n2
+	}
+
+	chain n0 { type nat hook postrouting priority 0;
+		jump n1
+	}
+}
+EOF
+good_ruleset $? "add nat skeleton"
+
+$NFT -f - <<EOF
+table t {
+	chain c2 {
+		jump n2
+	}
+}
+EOF
+bad_ruleset $? "jump from filter type to masquerade"
+
+$NFT flush chain t n2
+$NFT -f - <<EOF
+table t {
+	chain c2 {
+		jump n2
+	}
+
+	chain n2 { meta oifname "ppp0" masquerade; }
+}
+EOF
+bad_ruleset $? "jump from filter type to masquerade (2)"
+
+$NFT -f - <<EOF
+delete chain t c0
+delete chain t c1
+EOF
+good_ruleset $? "delete c1/c0"
+
+$NFT -f - <<EOF
+table t {
+	chain c1 { }
+
+	chain n2 { masquerade; }
+	chain n1 { goto n2; }
+
+	chain n0 { type nat hook postrouting priority 0;
+		goto n1
+	}
+
+	chain c0 { type filter hook input priority 0;
+		jump c1
+	}
+}
+EOF
+good_ruleset $? "add nat skeleton (2)"
+
+$NFT add rule t c1 goto n2
+bad_ruleset $? "jump from filter type to masquerade (3)"
+
+$NFT add chain 't invalid { type nat hook prerouting priority 0; goto n2; }'
+bad_ruleset $? "jump from prerouting to masquerade"
+
 exit $?
diff --git a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
index 30789211ff4a..7cc731488f16 100644
--- a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
+++ b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
@@ -46,6 +46,34 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "n2",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "n1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "n0",
+        "handle": 0,
+        "type": "nat",
+        "hook": "postrouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "chain": {
         "family": "ip",
@@ -150,13 +178,11 @@
       "rule": {
         "family": "ip",
         "table": "t",
-        "chain": "c1",
+        "chain": "n2",
         "handle": 0,
         "expr": [
           {
-            "jump": {
-              "target": "c2"
-            }
+            "masquerade": null
           }
         ]
       }
@@ -165,18 +191,74 @@
       "rule": {
         "family": "ip",
         "table": "t",
-        "chain": "c1",
+        "chain": "n1",
         "handle": 0,
         "expr": [
           {
-            "vmap": {
-              "key": {
+            "match": {
+              "op": "==",
+              "left": {
                 "payload": {
                   "protocol": "ip",
                   "field": "saddr"
                 }
               },
-              "data": "@m"
+              "right": {
+                "prefix": {
+                  "addr": "192.168.0.0",
+                  "len": 16
+                }
+              }
+            }
+          },
+          {
+            "jump": {
+              "target": "n2"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "n1",
+        "handle": 0,
+        "expr": [
+          {
+            "goto": {
+              "target": "n2"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "n0",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "n1"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "n0",
+        "handle": 0,
+        "expr": [
+          {
+            "goto": {
+              "target": "n1"
             }
           }
         ]
diff --git a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft
index 3a5936500c6e..314809c3ddab 100644
--- a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft
+++ b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft
@@ -18,9 +18,22 @@ table ip t {
 	chain c2 {
 	}
 
+	chain n2 {
+		masquerade
+	}
+
+	chain n1 {
+		ip saddr 192.168.0.0/16 jump n2
+		goto n2
+	}
+
+	chain n0 {
+		type nat hook postrouting priority filter; policy accept;
+		jump n1
+		goto n1
+	}
+
 	chain c1 {
-		jump c2
-		ip saddr vmap @m
 	}
 
 	chain c0 {
-- 
2.51.2

