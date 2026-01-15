Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A242BFC85
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493121; cv=none; b=C7P9hBd/1n/2y+P8ToJaG+IJmxQ5c51kn324ult9IQhJvVHbF2ViArAGa4jRDHwjgIlfRg9Yln8yHLZm+ImLbttFzqIEaj3xzdWvUJDTbAY7HlhWjjYdvvg4tU3ZGuXLO+J8bSSu9I8ITB9rsTftG9RRinlD+EcCC2qeL0AaN8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493121; c=relaxed/simple;
	bh=8IO7rWP/xf1b1IMwUS4nWViRuPOnpi/+if7DdfVzi5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OEqYDssE/20xWgyBWtQEiYlxyNAg2s/8yl7JTVHnvFOCqHXGBjeNp6D+fqONJ1akD+19NP9yOjKtCvQkckpDiotcB2goiqiIeSe+58hM3L17aFD3OLIw+IDNtQTLIFQoF1gfQ9R4FAF0VCUMzpnJFmGJV4ngZNFh8vAh3f7Xee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F14A3601F4; Thu, 15 Jan 2026 17:05:16 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add small packetpath test for bitmap set type
Date: Thu, 15 Jan 2026 17:05:09 +0100
Message-ID: <20260115160512.20818-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bitmap sets don't support 'counter' flag, so we can only check
'match' vs 'no match', but we can't tell which set element has
matched.

Static test, counter validation via dumps.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../dumps/set_match_nomatch_bitmap.json-nft   | 113 ++++++++++++++++++
 .../dumps/set_match_nomatch_bitmap.nft        |  23 ++++
 .../packetpath/set_match_nomatch_bitmap       |  29 +++++
 3 files changed, 165 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.nft
 create mode 100755 tests/shell/testcases/packetpath/set_match_nomatch_bitmap

diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.json-nft b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.json-nft
new file mode 100644
index 000000000000..ea470053755d
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.json-nft
@@ -0,0 +1,113 @@
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
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "counter": {
+        "family": "ip",
+        "name": "match",
+        "table": "test",
+        "handle": 0,
+        "packets": 8,
+        "bytes": 672
+      }
+    },
+    {
+      "counter": {
+        "family": "ip",
+        "name": "nomatch",
+        "table": "test",
+        "handle": 0,
+        "packets": 6,
+        "bytes": 504
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "test",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "dscp"
+            }
+          }
+        },
+        "handle": 0,
+        "elem": [
+          "lephb",
+          2,
+          4,
+          7
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "dscp"
+                }
+              },
+              "right": "@s"
+            }
+          },
+          {
+            "counter": "match"
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": "nomatch"
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.nft b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.nft
new file mode 100644
index 000000000000..561686e914e2
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/set_match_nomatch_bitmap.nft
@@ -0,0 +1,23 @@
+table ip test {
+	counter match {
+		packets 8 bytes 672
+	}
+
+	counter nomatch {
+		packets 6 bytes 504
+	}
+
+	set s {
+		typeof ip dscp
+		elements = { lephb,
+			     0x02,
+			     0x04,
+			     0x07 }
+	}
+
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip dscp @s counter name "match" accept
+		counter name "nomatch"
+	}
+}
diff --git a/tests/shell/testcases/packetpath/set_match_nomatch_bitmap b/tests/shell/testcases/packetpath/set_match_nomatch_bitmap
new file mode 100755
index 000000000000..c26eb45dbd94
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_match_nomatch_bitmap
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f - <<EOF
+table ip test {
+  counter match { }
+  counter nomatch { }
+  set s {
+    typeof ip dscp
+  }
+
+  chain c {
+    type filter hook output priority filter; policy accept;
+    ip dscp @s counter name match accept
+    counter name nomatch
+  }
+}
+EOF
+
+ip link set lo up
+
+$NFT add element ip test s { 0x1, 0x2, 0x4, 0x7 }
+
+for q in $(seq 1 7);do
+	ping -q -c 1 127.0.0.1 -Q 0x$q
+done
+
+# dump validation checks counters as well.
-- 
2.52.0

