Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6911713CF98
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502656; cv=none; b=G7i2AzirtzgPktAaJyS4nIJEwDQYL1uVAlpXaKPaNRC/IkivEPTEmZLhvBDsljf//iHfdRk37M/saenDJD6iKLXkLlxrBDoVDadE4aQT6JZAwfb6tTUYl53Yh3y90neA216gWPrbS5+VoPPIIrl/0rSCrJHr+Lpk84iLvqgNRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502656; c=relaxed/simple;
	bh=t7bgj/Dtyw0O6j/mlx+gvAQEww7xAADiC2w8zQsk8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DcqnqEY4aUq6K2hC08F0lZkLRyHFrnZt9s/747Esy6MORG13ed/xe+qGsppzYoaZfg95gTbHOvHg4g95qdVpfbh5xCIrUChicakEBhEUSdokNRLQXrpX9mZ9GWEsI3lHjnIfrmXBkjvCuyQ51mO8p2iS262gSob3AzUjXbNpv0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sEStb-0001Na-Hh; Tue, 04 Jun 2024 14:04:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] tests: shell: add test case for reset tcp warning
Date: Tue,  4 Jun 2024 14:01:49 +0200
Message-ID: <20240604120152.27217-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcp reset rule + nftrace 1 triggers (harmless) splat from flow dissector:

 WARNING: CPU: 2 PID: 145809 at net/core/flow_dissector.c:1104 __skb_flow_dissect+0x19d4/0x5cc0
  __skb_get_hash+0xa8/0x220
  nft_trace_init+0x2ff/0x3b0
  nft_do_chain+0xb04/0x1370
  nft_do_chain_inet+0xc5/0x2e0
  nf_hook_slow+0xa0/0x1d0
  ip_local_out+0x14/0x90
  nf_send_reset+0x94e/0xbd0
  nft_reject_inet_eval+0x45e/0x690
  nft_do_chain+0x220/0x1370
  nf_hook_slow+0xa0/0x1d0
  ip_local_deliver+0x23f/0x2d0

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../packetpath/dumps/tcp_reset.json-nft       | 168 ++++++++++++++++++
 .../testcases/packetpath/dumps/tcp_reset.nft  |  13 ++
 tests/shell/testcases/packetpath/tcp_reset    |  31 ++++
 3 files changed, 212 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/tcp_reset.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/tcp_reset.nft
 create mode 100755 tests/shell/testcases/packetpath/tcp_reset

diff --git a/tests/shell/testcases/packetpath/dumps/tcp_reset.json-nft b/tests/shell/testcases/packetpath/dumps/tcp_reset.json-nft
new file mode 100644
index 000000000000..e1367cc1abe1
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/tcp_reset.json-nft
@@ -0,0 +1,168 @@
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
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
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
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "nftrace"
+                }
+              },
+              "value": 1
+            }
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
+                  "field": "daddr"
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
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "right": 5555
+            }
+          },
+          {
+            "reject": {
+              "type": "tcp reset"
+            }
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
+                  "protocol": "ip6",
+                  "field": "daddr"
+                }
+              },
+              "right": "::1"
+            }
+          },
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "right": 5555
+            }
+          },
+          {
+            "reject": {
+              "type": "tcp reset"
+            }
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
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "right": 5555
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
diff --git a/tests/shell/testcases/packetpath/dumps/tcp_reset.nft b/tests/shell/testcases/packetpath/dumps/tcp_reset.nft
new file mode 100644
index 000000000000..fb3df1afe418
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/tcp_reset.nft
@@ -0,0 +1,13 @@
+table inet filter {
+	chain input {
+		type filter hook input priority filter; policy accept;
+		meta nftrace set 1
+		ip daddr 127.0.0.1 tcp dport 5555 reject with tcp reset
+		ip6 daddr ::1 tcp dport 5555 reject with tcp reset
+		tcp dport 5555 counter packets 0 bytes 0
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/packetpath/tcp_reset b/tests/shell/testcases/packetpath/tcp_reset
new file mode 100755
index 000000000000..3dfcdde40c77
--- /dev/null
+++ b/tests/shell/testcases/packetpath/tcp_reset
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+# regression check for kernel commit
+# netfilter: nf_reject: init skb->dev for reset packet
+
+socat -h > /dev/null || exit 77
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table inet filter {
+  chain input {
+    type filter hook input priority filter; policy accept;
+    meta nftrace set 1
+    ip daddr 127.0.0.1 tcp dport 5555 reject with tcp reset
+    ip6 daddr ::1 tcp dport 5555 reject with tcp reset
+    tcp dport 5555 counter
+   }
+   chain output {
+    type filter hook output priority filter; policy accept;
+    # empty chain, so nf_hook_slow is called from ip_local_out.
+   }
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+socat -u STDIN TCP:127.0.0.1:5555,connect-timeout=2 < /dev/null > /dev/null
+socat -u STDIN TCP:[::1]:5555,connect-timeout=2 < /dev/null > /dev/null
+
+$NFT list ruleset |grep -q 'counter packets 0 bytes 0' || exit 1
+exit 0
-- 
2.44.2

