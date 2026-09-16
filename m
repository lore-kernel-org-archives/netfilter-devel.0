Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FADE442380
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 07:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543167; cv=none; b=le6OIxRqIut+CemALmTVFc3uCIsTE2pPkf5WukOSIUb+EHBMvZyZ/JGtb1iMwdm1oaLAOyMGl0eUfOXxwFqeRx9Ji29re+IxhHpoWQ9QCTZkdHMXOA/olzczY5LaxVeseLforDvedi/JGenXpoJ1GAlXFNYNrnXY7TeMFm+PgXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543167; c=relaxed/simple;
	bh=FMHFiNhRlmsEmbYjxHKfPC7a10Yr5XcxwKJrxt/Gbrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HvPS6QBlOIwko0LkxDjkdDY/sU4KcxJx6u6lrDE+4H/kpMUaBWTE6nezeEIx8PtEvMpVmddppLQMYASXo8H48pDZUdSo/yN6WD3tQFSPUD96y+Iji+yCyyuf1l+SeWlwCwVrXumBKxeMhpIhOtlBnTSd1DCA+qQ2XhL82DJgfJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C241960380; Wed, 16 Sep 2026 09:19:01 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add packetpath test for nat on loopback
Date: Wed, 16 Sep 2026 09:18:47 +0200
Message-ID: <20260916071853.23560-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Esoteric use case, but legal: NAT port rewrite over loopback.
Also add drop rule to ensure that the packet is still tracked
in input.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../packetpath/dumps/nat_lo.json-nft          | 152 ++++++++++++++++++
 .../testcases/packetpath/dumps/nat_lo.nft     |  14 ++
 tests/shell/testcases/packetpath/nat_lo       |  42 +++++
 3 files changed, 208 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/nat_lo.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/nat_lo.nft
 create mode 100755 tests/shell/testcases/packetpath/nat_lo

diff --git a/tests/shell/testcases/packetpath/dumps/nat_lo.json-nft b/tests/shell/testcases/packetpath/dumps/nat_lo.json-nft
new file mode 100644
index 000000000000..1b8dca338ee0
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/nat_lo.json-nft
@@ -0,0 +1,152 @@
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
+        "name": "nat",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "nat",
+        "name": "output",
+        "handle": 0,
+        "type": "nat",
+        "hook": "output",
+        "prio": -100,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "nat",
+        "chain": "output",
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
+              "right": 1234
+            }
+          },
+          {
+            "redirect": {
+              "port": 12345
+            }
+          }
+        ]
+      }
+    },
+    {
+      "table": {
+        "family": "inet",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "drop"
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "in",
+              "left": {
+                "ct": {
+                  "key": "state"
+                }
+              },
+              "right": [
+                "established",
+                "related",
+                "new"
+              ]
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "input",
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
+              "right": {
+                "set": [
+                  1,
+                  58
+                ]
+              }
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
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
diff --git a/tests/shell/testcases/packetpath/dumps/nat_lo.nft b/tests/shell/testcases/packetpath/dumps/nat_lo.nft
new file mode 100644
index 000000000000..65259ec80242
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/nat_lo.nft
@@ -0,0 +1,14 @@
+table inet nat {
+	chain output {
+		type nat hook output priority dstnat; policy accept;
+		tcp dport 1234 redirect to :12345
+	}
+}
+table inet filter {
+	chain input {
+		type filter hook input priority filter; policy drop;
+		ct state established,related,new accept
+		meta l4proto { 1, 58 } accept
+		counter packets 0 bytes 0 drop
+	}
+}
diff --git a/tests/shell/testcases/packetpath/nat_lo b/tests/shell/testcases/packetpath/nat_lo
new file mode 100755
index 000000000000..862aadc82ef1
--- /dev/null
+++ b/tests/shell/testcases/packetpath/nat_lo
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f - <<EOF
+table inet nat {
+	chain output {
+		type nat hook output priority dstnat; policy accept;
+		tcp dport 1234 redirect to :12345
+	}
+}
+
+table inet filter {
+	chain input {
+		type filter hook input priority filter; policy drop;
+		ct state new,established,related accept
+		meta l4proto { icmp, icmpv6 } accept
+		counter drop
+	}
+}
+EOF
+
+ip link set lo up
+
+# Start listener on the target port
+timeout 5 socat TCP6-LISTEN:12345,ipv6only=1,fork STDOUT &
+PID1=$!
+timeout 5 socat TCP4-LISTEN:12345,fork STDOUT &
+PID2=$!
+
+# Give socat a moment to bind
+sleep 1
+
+# Test IPv4 translation
+echo "Testing IPv4..."
+echo "hello ipv4" | socat -u STDIN TCP:127.0.0.1:1234
+
+# Test IPv6 translation
+echo "Testing IPv6..."
+echo "hello ipv6" | socat -u STDIN TCP:[::1]:1234
+
+kill $PID1 $PID2
-- 
2.55.0

