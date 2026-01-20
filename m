Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691253A4AD9
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768938804; cv=none; b=ax9lslUHFrENE5bzJPIqtvuTmXW5/UeVvWJbvwbsJeFEFoWZKn452maNn384wXadITOA6iGHH9Tj0ayiEzyOOS4zq3QYu7KnsEcPGnuYZc4qhpqr/zOxx8J1Y2P1a3yN10cGwUnkR+a/dkbkmBCZzdDGdZIhlTby+xhJRrpiPOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768938804; c=relaxed/simple;
	bh=Wc0zOQESfE5s5ecNdG6NBVdoEN3SMMcN/yL4E4wazq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwKRvHSrZbp4V8TA4aO2jSjNsAYTC6gRgs4H61P9zCke2cghlrGHNJFzwgtkDfpRPPRXtFvR97WL581hSTQ93mAbTvTXXKzHhHM5279Vlt6JkarIZR+GejdKPwr4PIqsp7IVALLx7VIdSiteBdFHgDsvfuAjBSb7Z7vxFYNLYzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdvIKvsQ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdvIKvsQ"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so38334955e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 11:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768938800; x=1769543600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNBIGa1MHbrQfLi7mQ/sZTBMUnQSbSCoiwS9SfLj2Sg=;
        b=jdvIKvsQcPY9NG/EloPDdQxCcgA7XQsW+yQoC+dPsr6A6NdMnDqPzP0d0eNYT8dXg3
         oop3gQkG0c6JM/WaOSiYFsz3vewzjtb+urdrPBWnh1pZaYAOQOceQ2g/S6AuuFV5M3Mb
         EymsGdm4pz7jrCoUeUXa9f4QdVyYtQRbDSF5h81phOCsG+eiU22mh45DYDGtC1gYU48Y
         9evNqArpP0wm4OSgHFK4196ClCMbbZtvfur60dehXCBBXtjvIHM69OSIL9K13E01hi8Y
         sr48+P9R1pjQj2AR4QZhQ9c0DGwhLmFJDNE/2ssZ1Tr/uKQAPvtigundPkSbuDRPdpja
         JiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768938800; x=1769543600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HNBIGa1MHbrQfLi7mQ/sZTBMUnQSbSCoiwS9SfLj2Sg=;
        b=L6qjcWNDC0pZtb2Kyc/5AxHpk7/zvuWx1LEjVYk4cdbEi/dgSz8AopjTBfXfMMhi4i
         lmU/3915nU+j12qSYMJEkS2D+g7f09gSflEC6fzD9Xm4YSITweipxPaqNHHvrBQ1uGDD
         CdDA1RyOq9w0YrlZrdzPZAaay/5EotozpjH6GDxxpuAZwH98x9JkLa+7fz6FQKdwBNr9
         Hk++D4cRvMCUQ6/li0gHduOMpRkgmmSY5h8j+JwXdE6+nfppaQFnwEYekZ0unmKQmY8E
         FsHOVXi5EHIH4n6GE02AbLybmfqDwWMlOaHPAW4XrZb7QE2tmnkaqXC88UUn0MvqP6iw
         TLeQ==
X-Gm-Message-State: AOJu0YyRR+F3al+2ty8umWH9Z5e/zH5Y2jQAOCpGYoEmVTHg+v0+11JV
	58szWC4Vvw7T/Gk+ZEE/G9xWgIn4CYcLNPu4fG1rtjk7JCh4Se6V9wGsBblV0Q==
X-Gm-Gg: AY/fxX7SG+fSNDi3zCB9hvxdooN/u9viddoRgBh0hZJTwM2tI4IesIPd96QVtB12vns
	W5xPFlOADdYOzCer1feOPW5yOvxC16abToCejK80jgPur3y+oPdWhZNdE1OM+WiykoWXC7hHBq0
	LIAebLsFTjK/FzQv8X8HsjTkXjB21TqmJXPijotXODnEW5MKJOShAWGRIpS/jdRWAM54RnVHvHk
	7bU2NDN0lDq/t/Hygic1K0gKN22+hecZN8uSx5Qx441+8UneDIkhOwSTiL2F/cy8nw/CvIPIrkf
	pHsKKaOXLt6BolMncrlU1bB+khAO8dF7R+zog6ox6MivCcVyS0Y2SuxRO5BhyshdHbaPhZKKRfu
	OTELpBssQNVxjEI1xPw997kDe6a/oNfzX+bELl2bPJ1K9Zaunl0fYZg1i0Ulrd996AmWXsbOHwH
	mmA5bqjAmcyotp/CMvzvKrsK4me36WvlI=
X-Received: by 2002:a05:600c:34d3:b0:479:1348:c614 with SMTP id 5b1f17b1804b1-4803e7f03fdmr41967325e9.26.1768938799963;
        Tue, 20 Jan 2026 11:53:19 -0800 (PST)
Received: from bluefin ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b789sm320114165e9.1.2026.01.20.11.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 11:53:19 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v6 3/3] tests: shell: add JSON test for handle-based rule positioning
Date: Tue, 20 Jan 2026 20:53:03 +0100
Message-ID: <20260120195303.1987192-4-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260120195303.1987192-1-knecht.alexandre@gmail.com>
References: <20260120195303.1987192-1-knecht.alexandre@gmail.com>
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

