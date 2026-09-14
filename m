Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04D413785
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375454; cv=none; b=Z6SkOqWBL7qTyw1Oj+iQt9u1GfY7jkGNhFkYB3gx/zs13AoXhmcop5u49PXO2rVK7RtDpcr1T5c0Dxsr8HmmyYNnhAQJenl/sQKdyaLNx2DDB/tVHidb/KITMipb5/buimef5xwqQL6M6DdO3p2pgN96EAzCh7lrdMWzBSKibP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375454; c=relaxed/simple;
	bh=ORHzjd0KShgV+5tLUXmIjWkDdB5AN78qdB4PvCm/mQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jRDd/Z7Dg5LW6bnv3H7SiNMK+O//e3yAesyqukTKdElKcu2OjKwWy7uirOWiaEM3Q6ZPOnk1EhgxZu/EVwvyV/YsCS4Nzph1iRMdt3ypba5fHdoxv/Jvisg12PKMMMb7MpLUSKzHYiSIpOnc5dgkwHykPf4I0b2P1iuSI45suNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3642660456; Mon, 14 Sep 2026 10:44:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add packetpath test for timeout policy overrides
Date: Mon, 14 Sep 2026 10:33:17 +0200
Message-ID: <20260914083331.19866-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exercise the timeout assigment codepath and check that state disappears
after the assigned timeout.

Also:
- check that non-matching tcp flow is still present
- check that udp policy is ignored, even if it lacks
  'meta l4proto udp'.
- check icmp (which has no policy) doesn't pick up the
  udp timeout either.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/packetpath/ct_timeout_policy    | 85 ++++++++++++++++
 .../dumps/ct_timeout_policy.json-nft          | 96 +++++++++++++++++++
 .../packetpath/dumps/ct_timeout_policy.nft    | 19 ++++
 3 files changed, 200 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/ct_timeout_policy
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_timeout_policy.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_timeout_policy.nft

diff --git a/tests/shell/testcases/packetpath/ct_timeout_policy b/tests/shell/testcases/packetpath/ct_timeout_policy
new file mode 100755
index 000000000000..b153dc9355f3
--- /dev/null
+++ b/tests/shell/testcases/packetpath/ct_timeout_policy
@@ -0,0 +1,85 @@
+#!/bin/bash
+# nftables ct timeout test for tcp.
+# Defines ct timeout policies (1s) and verifies they expire for matching flows
+# while non matching flow stay alive >2s
+
+. "$NFT_TEST_LIBRARY_FILE"
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table inet t {
+	ct timeout tcp-test {
+		protocol tcp;
+		policy = { syn_sent: 1s, established: 1s }
+	}
+
+	ct timeout udp-test {
+		protocol udp;
+		policy = { unreplied: 120s, replied: 130s }
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+
+		# matching rules - only packets that hit these rules receive the
+		# corresponding ct-timeout policy
+		tcp dport 12345 ct timeout set "tcp-test"
+
+		# check kernel doesn't assign this to icmp/tcp etc.
+		ct timeout set "udp-test"
+	}
+}
+EOF
+
+assert_pass "ruleset load"
+
+# ----------------------------------------------------------------------
+# 1. TCP matching test
+# Listener on 12345 (matches tcp-test), initiator connects to it.
+# After the connection becomes ESTABLISHED we sleep so the ct timeout
+# expires and the conntrack entry should disappear.
+
+# start listener (responder)
+timeout  9 socat -u TCP-LISTEN:12345,reuseaddr STDOUT &
+LISTENER_PID=$!
+timeout 10 socat -u TCP-LISTEN:12346,reuseaddr STDOUT &
+LISTENER2_PID=$!
+sleep 1
+
+# start initiator (client)
+sleep 6 | socat -u STDIN TCP:127.0.0.1:12345  &
+
+conntrack -L -s 127.0.0.1 -d 127.0.0.1 -p tcp --dport 12345 | grep .
+assert_pass "TCP matching flow"
+# wait long enough for the 1s ESTABLISHED timeout
+
+sleep 2
+
+conntrack -L -s 127.0.0.1 -d 127.0.0.1 -p tcp --dport 12345 | grep .
+assert_fail "TCP matching flow timed out as expected"
+
+# ----------------------------------------------------------------------
+# 2. TCP non-matching test
+#    Listener on 12346 (no matching rule default ct timeout, which is long).
+
+# start initiator for port 12346
+sleep 5 | socat -u STDIN TCP:127.0.0.1:12346 &
+sleep 2
+
+# check that a TCP entry for our non-matching port is present
+conntrack -L -s 127.0.0.1 -d 127.0.0.1 -p tcp --dport 12346 | grep .
+assert_pass "TCP flow with standard timeout present"
+
+sysctl net.netfilter.nf_conntrack_icmp_timeout=2
+ping -c 1 127.0.0.1
+assert_pass "ping localhost"
+sleep 3
+
+conntrack -L -s 127.0.0.1 -d 127.0.0.1 -p icmp | grep .
+assert_fail "ICMP expired"
+
+# wait for "timeout"s.
+wait
+
+$NFT list ruleset
diff --git a/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.json-nft b/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.json-nft
new file mode 100644
index 000000000000..52a5426e8cf9
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.json-nft
@@ -0,0 +1,96 @@
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
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "ct timeout": {
+        "family": "inet",
+        "name": "tcp-test",
+        "table": "t",
+        "handle": 0,
+        "protocol": "tcp",
+        "l3proto": "inet",
+        "policy": {
+          "syn_sent": 1,
+          "established": 1
+        }
+      }
+    },
+    {
+      "ct timeout": {
+        "family": "inet",
+        "name": "udp-test",
+        "table": "t",
+        "handle": 0,
+        "protocol": "udp",
+        "l3proto": "inet",
+        "policy": {
+          "unreplied": 120,
+          "replied": 130
+        }
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
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
+              "right": 12345
+            }
+          },
+          {
+            "ct timeout": "tcp-test"
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
+        "chain": "output",
+        "handle": 0,
+        "expr": [
+          {
+            "ct timeout": "udp-test"
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.nft b/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.nft
new file mode 100644
index 000000000000..bd9f810e25e8
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/ct_timeout_policy.nft
@@ -0,0 +1,19 @@
+table inet t {
+	ct timeout tcp-test {
+		protocol tcp
+		l3proto inet
+		policy = { syn_sent : 1s, established : 1s }
+	}
+
+	ct timeout udp-test {
+		protocol udp
+		l3proto inet
+		policy = { unreplied : 2m, replied : 2m10s }
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+		tcp dport 12345 ct timeout set "tcp-test"
+		ct timeout set "udp-test"
+	}
+}
-- 
2.55.0

