Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48B139CEF
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 11:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712142301; cv=none; b=Uxl5isgeZMCuikTbten5byG4dvbs0LpSy1zDMO8QRP/Op5Iq/xBDkeTA6P28j5UcwGggMg94bKBYuqc69ozAae/mYYcHboG07QXkmwq9/tyYPnBcBBBvUobaUMgiVQdioe+bui+rQuLPUspcMY8kEzKj/cJ+ug0eA2Lig0AKq7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712142301; c=relaxed/simple;
	bh=/L6QLWMDxM2OJJS4lUb/mFEjfNQ41DjNnztMx4phAqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uNDE8T+6KR7opj33KJTteyJC4SuRWzTvJNQWWANpOwolcTQDKv+u7rImdfcc8WHxJ9hSFO2ml7Y7zk7k1z0s2EqiJd2eqQ4tuFWccFiMe5x3kPeI0e9+MxqKq2j3I/xwwJDASDNLZjEVZzaEUSom/Nfo+mKtMBThe7ML7rskfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rryQF-0007DP-HF; Wed, 03 Apr 2024 13:04:51 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: packetpath: add check for drop policy
Date: Wed,  3 Apr 2024 13:03:48 +0200
Message-ID: <20240403110351.15039-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check that policy can be changed from accept to drop and that the kernel
acts on this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../packetpath/dumps/policy.json-nft          | 121 ++++++++++++++++++
 .../testcases/packetpath/dumps/policy.nft     |  11 ++
 tests/shell/testcases/packetpath/policy       |  42 ++++++
 3 files changed, 174 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/policy.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/policy.nft
 create mode 100755 tests/shell/testcases/packetpath/policy

diff --git a/tests/shell/testcases/packetpath/dumps/policy.json-nft b/tests/shell/testcases/packetpath/dumps/policy.json-nft
new file mode 100644
index 000000000000..26e8a0525f2b
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/policy.json-nft
@@ -0,0 +1,121 @@
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
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "underflow",
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
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "icmp",
+                  "field": "type"
+                }
+              },
+              "right": "echo-reply"
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
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              "right": "127.0.0.1"
+            }
+          },
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              },
+              "right": "127.0.0.2"
+            }
+          },
+          {
+            "counter": {
+              "packets": 3,
+              "bytes": 252
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
+            "goto": {
+              "target": "underflow"
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/policy.nft b/tests/shell/testcases/packetpath/dumps/policy.nft
new file mode 100644
index 000000000000..e625ea6c82be
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/policy.nft
@@ -0,0 +1,11 @@
+table inet filter {
+	chain underflow {
+	}
+
+	chain input {
+		type filter hook input priority filter; policy drop;
+		icmp type echo-reply accept
+		ip saddr 127.0.0.1 ip daddr 127.0.0.2 counter packets 3 bytes 252 accept
+		goto underflow
+	}
+}
diff --git a/tests/shell/testcases/packetpath/policy b/tests/shell/testcases/packetpath/policy
new file mode 100755
index 000000000000..0bb42a548870
--- /dev/null
+++ b/tests/shell/testcases/packetpath/policy
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table inet filter {
+ chain underflow { }
+
+  chain input {
+    type filter hook input priority filter; policy accept;
+    icmp type echo-reply accept
+    ip saddr 127.0.0.1 ip daddr 127.0.0.2 counter accept
+    goto underflow
+    }
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+ping -q -c 1 127.0.0.2 >/dev/null || exit 2
+
+# should work, polict is accept.
+ping -q -c 1 127.0.0.1 >/dev/null || exit 1
+
+$NFT -f - <<EOF
+table inet filter {
+  chain input {
+    type filter hook input priority filter; policy drop;
+  }
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+$NFT list ruleset
+
+ping -W 1 -q -c 1 127.0.0.2
+
+ping -q -c 1 127.0.0.2 >/dev/null || exit 2
+
+# should fail, policy is set to drop
+ping -W 1 -q -c 1 127.0.0.1 >/dev/null 2>&1 && exit 1
+
+exit 0
-- 
2.43.2

