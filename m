Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477137418D
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831717; cv=none; b=lLTfCX4glqoCYMgMjZ9z0ObkxEmc681uF3gKKOvkaceFzIjTqv1kEiPVa/3WNmRUXOF06pnjxhPsF12Dk8tulQsg79rxmnTkC4GALy8MOEPpBO7YiJwzTYzHASZKfuzTuwsTsrNsLIBeAo0XeqJNkKtSguCRCRilMkX2XnVLjmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831717; c=relaxed/simple;
	bh=Wc0zOQESfE5s5ecNdG6NBVdoEN3SMMcN/yL4E4wazq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCF0ay66NwT1uAlaqse3wMyFxah5H20tcuwed0vplSymBExbZ8170yyr342GCxdT78wOYS95PepSddlA36kfuQJxDZ2qizHHxGMFxqinlTgrMRNml2GxhiEufnutK7lFpbd1vBDoDwILXaNeALQSviNNki4aR0gPfyI/MYci3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DH+hNWdz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DH+hNWdz"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801c314c84so25420565e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768831713; x=1769436513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNBIGa1MHbrQfLi7mQ/sZTBMUnQSbSCoiwS9SfLj2Sg=;
        b=DH+hNWdzFog5b+w6lOUwK+N4aE6pmo+YI00S2r5oi9xafyRHX9O9UxygzHb4H6Kpc2
         SDDDRQRvpyusl9kp5+ShcMJVWr7v63HrlJo+Q7s52HuTsCzo3kXuCY6od5Bwo6NtAcFS
         PxOTa4vswzEjZJSJqrvlhsDE8VnAPWnVnwsrZJ5E6GB6h8ZWaZKKQZtmHszVC1I535F4
         PRYHKkaoCYoJsds+kii5AaGgkgjmo5iC8st/s167ZC/L+TimrgAL9aRmlSchmUh62wOL
         PhdGL6YblLht/3ziacEaI3WJ1m8xTL3t5pqBBvqnnybXJN5cxcQzJVWA+zj57zi/uyQj
         2XFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768831713; x=1769436513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HNBIGa1MHbrQfLi7mQ/sZTBMUnQSbSCoiwS9SfLj2Sg=;
        b=lRpbzeqt9bwXRSh/SLq+cFKKT9HinSLnemKF/PREV1My2SjmH+G2nlHCbLV66nOgo4
         PXnLnE27h9yqzkFDiUq9tmZlwLQkEhsyTMk3juPjDLSPCl1zq9sEm+89a5z5En5Jffu8
         ihpGsZOzlJvuUMjdLRz/dF3ae+6+XSgk4bLOT3SEQEcNGFEgUBWHdNaj0NQebHSk21hF
         IAKF6CWLXVmTMGuig+LJzs2e4/XOB5+6DE1tGX23FYPTYw3tD1TRgozSNVdkVAS9iIJk
         uLLrSF3O8EdyPMBbjkhQIwUU5zT7LNSB69IUXIh+nt0lfpHlzx6kUK2skWEemgZHTdt8
         rx/w==
X-Gm-Message-State: AOJu0YxwBJHrSCiBrofG9NI91w5otjF15yq1q2DyIccRSVkj3Lbq6j42
	CsLjSSC9pBQRhKco37HpLHXZGm+l8yIG7mmm4goRaC6mco/S/VWfXVjC2mCvew==
X-Gm-Gg: AY/fxX67BqUy4uv5OhRdaUkeCqCQrKVL5AZh8yKFB4oF0NybEEQL31sJ2r59vRbbLSy
	NcdU3AXFXpav+bQWmitEPzpupAotaybSPp/LdTB/5Rf1DaFsfijkb1qHbr97fv0yJogxfTOXbMz
	tk33rAAcbkWJuOqpi+VdZkNbByylcW9vYkN/levhazWKC/y1oZBZ4d1OoHMERpFP08yKo4mP9uq
	aNVpPm7iDmSoke2yEsDoEymegw7eAdfKGApH5Z0JrOMCKFvjg3V+JSiCvlNsU/QCQZNPIHPdhQ8
	/VvNJY0HmYYUayAATRQLpWc+yKzMgqmFBageaMHYR5ORPIilWDOnuBU1EVv0Lm82R3x28V1LW1b
	tQgzZu3PHr0UfyZP++bLlN598CEvommzmH6AaLyLA4HMMw28TingVdCRXn1uGKDOUt3/L4TW4PV
	cugapVmgj15puhI3brnvd0CADocaQ9G4X5uBfmb7BOAQBOY9okwkuNLLmywWzThvGMN78pEtJao
	IaEfg==
X-Received: by 2002:a05:600c:c178:b0:477:a977:b8c5 with SMTP id 5b1f17b1804b1-4801e34cd0emr159832385e9.31.1768831712319;
        Mon, 19 Jan 2026 06:08:32 -0800 (PST)
Received: from bluefin (2a02-8440-e509-8e1d-0fa7-f9cb-e455-a769.rev.sfr.net. [2a02:8440:e509:8e1d:fa7:f9cb:e455:a769])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm23233975f8f.39.2026.01.19.06.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:08:31 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v5 3/3] tests: shell: add JSON test for handle-based rule positioning
Date: Mon, 19 Jan 2026 15:08:13 +0100
Message-ID: <20260119140813.536515-4-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260119140813.536515-1-knecht.alexandre@gmail.com>
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add comprehensive test for JSON handle-based rule positioning to verify
the handle field correctly positions rules with explicit add/insert
commands while being ignored in implicit format.

Test coverage:
1. ADD with handle positions AFTER the specified handle
2. INSERT with handle positions BEFORE the specified handle
3. INSERT without handle positions at beginning
4. Multiple commands in single transaction (batch behavior)
5. Implicit format ignores handle field for portability

The test uses sed for handle extraction and nft -f format for setup
as suggested in code review. Final state is a table with two rules
from the implicit format test.

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 .../testcases/json/0008rule_position_handle_0 | 162 ++++++++++++++++++
 .../dumps/0008rule_position_handle_0.json-nft |  76 ++++++++
 .../json/dumps/0008rule_position_handle_0.nft |   6 +
 3 files changed, 244 insertions(+)
 create mode 100755 tests/shell/testcases/json/0008rule_position_handle_0
 create mode 100644 tests/shell/testcases/json/dumps/0008rule_position_handle_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0008rule_position_handle_0.nft

diff --git a/tests/shell/testcases/json/0008rule_position_handle_0 b/tests/shell/testcases/json/0008rule_position_handle_0
new file mode 100755
index 00000000..32a3752c
--- /dev/null
+++ b/tests/shell/testcases/json/0008rule_position_handle_0
@@ -0,0 +1,162 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+# Test JSON handle-based rule positioning
+# Verifies explicit format uses handle for positioning while implicit format ignores it
+
+set -e
+
+$NFT flush ruleset
+
+echo "Test 1: ADD with handle positions AFTER"
+$NFT -f - <<EOF
+table inet test {
+	chain c {
+		tcp dport 22 accept
+		tcp dport 80 accept
+	}
+}
+EOF
+
+# Get handle of first rule (tcp dport 22)
+HANDLE=$($NFT -a list chain inet test c | sed -n 's/.*tcp dport 22 .* handle \([0-9]\+\)/\1/p')
+
+# Add after handle (should be between 22 and 80)
+$NFT -j -f - <<EOF
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify order: 22, 443, 80
+RULES=$($NFT list chain inet test c | grep -o "tcp dport [0-9]*")
+EXPECTED="tcp dport 22
+tcp dport 443
+tcp dport 80"
+
+if [ "$RULES" = "$EXPECTED" ]; then
+	echo "PASS: Rule added after handle"
+else
+	echo "FAIL: Expected order 22,443,80, got:"
+	echo "$RULES"
+	exit 1
+fi
+
+echo "Test 2: INSERT with handle positions BEFORE"
+$NFT flush ruleset
+$NFT -f - <<EOF
+table inet test {
+	chain c {
+		tcp dport 22 accept
+		tcp dport 80 accept
+	}
+}
+EOF
+
+# Get handle of second rule (tcp dport 80)
+HANDLE=$($NFT -a list chain inet test c | sed -n 's/.*tcp dport 80 .* handle \([0-9]\+\)/\1/p')
+
+# Insert before handle
+$NFT -j -f - <<EOF
+{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify order: 22, 443, 80
+RULES=$($NFT list chain inet test c | grep -o "tcp dport [0-9]*")
+if [ "$RULES" = "$EXPECTED" ]; then
+	echo "PASS: Rule inserted before handle"
+else
+	echo "FAIL: Expected order 22,443,80, got:"
+	echo "$RULES"
+	exit 1
+fi
+
+echo "Test 3: INSERT without handle positions at beginning"
+$NFT flush ruleset
+$NFT -f - <<EOF
+table inet test {
+	chain c {
+		tcp dport 22 accept
+		tcp dport 80 accept
+	}
+}
+EOF
+
+# Insert without handle (should go to beginning)
+$NFT -j -f - <<EOF
+{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "c", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify order: 443, 22, 80
+RULES=$($NFT list chain inet test c | grep -o "tcp dport [0-9]*")
+EXPECTED_INSERT="tcp dport 443
+tcp dport 22
+tcp dport 80"
+
+if [ "$RULES" = "$EXPECTED_INSERT" ]; then
+	echo "PASS: Rule inserted at beginning without handle"
+else
+	echo "FAIL: Expected order 443,22,80, got:"
+	echo "$RULES"
+	exit 1
+fi
+
+echo "Test 4: Multiple commands in single transaction"
+$NFT flush ruleset
+$NFT -f - <<EOF
+table inet test {
+	chain c {
+		tcp dport 22 accept
+	}
+}
+EOF
+
+# Get handle
+HANDLE=$($NFT -a list chain inet test c | sed -n 's/.*tcp dport 22 .* handle \([0-9]\+\)/\1/p')
+
+# Add two rules after same handle in single transaction
+$NFT -j -f - <<EOF
+{"nftables": [
+	{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 80}}, {"accept": null}]}}},
+	{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}
+]}
+EOF
+
+# Verify: Both should be after handle 22
+# In a transaction, both position to same handle, so added in reverse order
+# Order should be: 22, then 443, then 80 (last add goes immediately after position)
+RULES=$($NFT list chain inet test c | grep -o "tcp dport [0-9]*")
+EXPECTED_MULTI="tcp dport 22
+tcp dport 443
+tcp dport 80"
+
+if [ "$RULES" = "$EXPECTED_MULTI" ]; then
+	echo "PASS: Multiple rules in transaction positioned correctly"
+else
+	echo "FAIL: Expected order 22,443,80, got:"
+	echo "$RULES"
+	exit 1
+fi
+
+echo "Test 5: Implicit format ignores handle"
+$NFT flush ruleset
+$NFT -f - <<EOF
+table inet test {
+	chain c {
+		tcp dport 22 accept
+	}
+}
+EOF
+
+# Implicit format with non-existent handle should succeed (handle ignored)
+$NFT -j -f - <<EOF
+{"nftables": [{"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 9999, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 80}}, {"accept": null}]}}]}
+EOF
+
+if $NFT list chain inet test c | grep -q "tcp dport 80"; then
+	echo "PASS: Implicit format ignores handle"
+else
+	echo "FAIL: Implicit format should have added rule despite non-existent handle"
+	exit 1
+fi
+
+echo "All positioning tests passed!"
diff --git a/tests/shell/testcases/json/dumps/0008rule_position_handle_0.json-nft b/tests/shell/testcases/json/dumps/0008rule_position_handle_0.json-nft
new file mode 100644
index 00000000..62101fbb
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0008rule_position_handle_0.json-nft
@@ -0,0 +1,76 @@
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
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "test",
+        "chain": "c",
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
+              "right": 22
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
+        "table": "test",
+        "chain": "c",
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
+            "accept": null
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/json/dumps/0008rule_position_handle_0.nft b/tests/shell/testcases/json/dumps/0008rule_position_handle_0.nft
new file mode 100644
index 00000000..d222ad64
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0008rule_position_handle_0.nft
@@ -0,0 +1,6 @@
+table inet test {
+	chain c {
+		tcp dport 22 accept
+		tcp dport 80 accept
+	}
+}
-- 
2.51.1

