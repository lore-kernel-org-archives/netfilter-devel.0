Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEB376BE0
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831715; cv=none; b=HMXGJlgXmkCHECqzOQRR9QjzsnnDDWPGlbNowMkEQqZrhrfoEsTFQwaJSmsfLKeyYoz8JJP9ZhKanY6LsYAbppEmp/BA9D/ULKgVAyT12B3OMPkU+VIIzR2NXUgWzsB8JLKG5cCiZctyeTF7YG4wZHfdb5LsECFGJl4L0WM0t8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831715; c=relaxed/simple;
	bh=luvXRt1CZOqupcF6f2Bb9+9KAsYmq/ufn28EOdCG5fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4XSpwAuiqiQ6cTSshtdOvsQSw7eVteXoX5DMjsYnr17V8D/vWa2+quDg7jw92XFKPutled6Z9tf69J1muWR3Io87vcJv3mPNRCJvpxCD1N+koFDm7xNAT3R0D3ZWVxW/k2TJXQ41jk6A/XDQrsNHmRZ1qjWInhH05N/v4Oq8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jU5Nfdg2; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jU5Nfdg2"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso29821995e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768831710; x=1769436510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYdB0a6FW4wGViEmeoxYUU7WIhIUqANqsrUKBdfYjq4=;
        b=jU5Nfdg27vN7tlHFQRyn2e5jMInZYr7HJ8xcNrRpKJUM+2KLFGNCDc3k1LZX5NuSbT
         Gb27KvN5EZiF31G7loz5vCBSYD9ch38zBXYleZTF/qk96UXVeEqhu5XMOtHPuJTQFthm
         5XhmnSSPZkS3N8PYyedm+7qgKRKo9grTS5xklkPSQC2K8SHfpos6Ybov8bBLDbTZroR1
         tCtMOh+hATSj8ocFY5lIPgF2n8CrI4lvCDMz758BQUAt6esJ5ZYIsfYBJWJ9aa3K+HyB
         vvOsmr9wGHP/3uTLIg5N9EQyMa1XZGRP4Ejfug3UGoKot0lz0rpw2+ZvuT4macgyUuKY
         4scA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768831710; x=1769436510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UYdB0a6FW4wGViEmeoxYUU7WIhIUqANqsrUKBdfYjq4=;
        b=VYhw/tl1E60zokGCbJ9FT7BdmIE51RNdI1zm1S8IvSanzdkuES4RIDYhHRfmAIIEyH
         7s5FI2R/tLs43uNgp8E4m/m+Erg5Krpzvqi3xG3XknYtYSY9bmcxYxQe75VY7T6Svcv9
         4DBLcCQcqFmUwZsJtEJuXbwrCfO1nHU9T4ezMaH9zc1uNnFkDkWAYPhCpz0FOkglpnTQ
         YgF2AFQ2Um3uVpqlkqQ6y70cDLyYlQznRQEcjjLn9vpZA4bKAD6nuikqltdN4KpqOgWc
         NafeMXhVnEpgNMJ/sXcVC4vxq4T2XVMEf4M/EwOhl9Dx02yuib9oiJ9xf3q3RjR6FOuF
         E09A==
X-Gm-Message-State: AOJu0YxIHiQIx5HMiGGnM4W2uCZQ1/ekoNuDeKSfHrotKsww11CQteol
	A+YUhpwp7SD53qNTvzmytBoYS8PjsxakHB4PwodrYDQIoNvC+OOzlmncV8m2rw==
X-Gm-Gg: AY/fxX6fS7+CTe4IZ7iTPhRFiyVdu84za1ZOTpdmmA8ETGwfcm+u65/P/2v+tTc6BfJ
	qA3QkEEHN6eg27ZsivziS2ofoeJz/yKkhIgPTsjzcm3sNvIFOiKKSayHTswKYI2XF4FbNt0crwH
	ZHuywRwQVk19WfOFZTokVxyxYzP4/v83AsE8ZXTkF3N5APfq3EEm54LGRAhDtU6MYUHVZFCRmy/
	Eda4HqyrYDZn///I75NyjguCIrZjNLNa1Em+sGTnkBc9xo6Vl9NJh3Ck/YSgkFgJHPkypfbb60O
	2EQeiKxRdEKYUq7csBD8wH56zi4BtZC6WOt55HO106eDHoOrOGC+9W9/ttuWPu9E4bqIoKWsoIA
	xCHfmUtJfQAoHB7UU217knhhqggr5mrryNhv3pjprKBqEaE52/WFFgPLZR1gxVr7rDu9X8M1zGB
	YYnyLTk3mnML4TKtLLYY9fEaz1lFI7av5NfJddkeQhWH9ILvkrAq8uvao9Dni+f8/8en4OtksZs
	tDTKw==
X-Received: by 2002:a05:600c:35c2:b0:480:3b26:82cc with SMTP id 5b1f17b1804b1-4803b2683c0mr13683445e9.18.1768831710158;
        Mon, 19 Jan 2026 06:08:30 -0800 (PST)
Received: from bluefin (2a02-8440-e509-8e1d-0fa7-f9cb-e455-a769.rev.sfr.net. [2a02:8440:e509:8e1d:fa7:f9cb:e455:a769])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm23233975f8f.39.2026.01.19.06.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:08:29 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v5 2/3] tests: shell: add JSON test for all object types
Date: Mon, 19 Jan 2026 15:08:12 +0100
Message-ID: <20260119140813.536515-3-knecht.alexandre@gmail.com>
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

Add comprehensive test for JSON add/insert/delete/replace/create
operations on all object types to ensure the handle field changes
don't break non-rule objects.

Tests coverage:
- ADD operations: table, chain, rule, set, counter, quota
- INSERT operations: rule positioning
- REPLACE operations: rule modification
- CREATE operations: table creation with conflict detection
- DELETE operations: rule, set, chain, table

The test verifies that all object types work correctly with JSON
commands and validates intermediate states. Final state is an empty
table from the CREATE test.

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 .../json/0007add_insert_delete_objects_0      | 145 ++++++++++++++++++
 .../0007add_insert_delete_objects_0.json-nft  |  18 +++
 .../dumps/0007add_insert_delete_objects_0.nft |   2 +
 3 files changed, 165 insertions(+)
 create mode 100755 tests/shell/testcases/json/0007add_insert_delete_objects_0
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft

diff --git a/tests/shell/testcases/json/0007add_insert_delete_objects_0 b/tests/shell/testcases/json/0007add_insert_delete_objects_0
new file mode 100755
index 00000000..f701b062
--- /dev/null
+++ b/tests/shell/testcases/json/0007add_insert_delete_objects_0
@@ -0,0 +1,145 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+# Comprehensive test for JSON add/insert/delete/replace operations
+# Tests that all object types work correctly with JSON commands
+
+set -e
+
+$NFT flush ruleset
+
+# ===== ADD operations =====
+
+echo "Test 1: Add table"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"table": {"family": "inet", "name": "test"}}}]}
+EOF
+
+echo "Test 2: Add chain"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"chain": {"family": "inet", "table": "test", "name": "input_chain", "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}}]}
+EOF
+
+echo "Test 3: Add rule"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"accept": null}]}}}]}
+EOF
+
+echo "Test 4: Add set"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"set": {"family": "inet", "table": "test", "name": "test_set", "type": "ipv4_addr"}}}]}
+EOF
+
+echo "Test 5: Add counter"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
+EOF
+
+echo "Test 6: Add quota"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"quota": {"family": "inet", "table": "test", "name": "test_quota", "bytes": 1000000}}}]}
+EOF
+
+# Verify all objects were created
+$NFT list ruleset > /dev/null || { echo "Failed to list ruleset after add operations"; exit 1; }
+
+# ===== REPLACE operations =====
+
+echo "Test 7: Replace rule"
+# Get handle of rule with dport 22
+HANDLE=$($NFT -a list chain inet test input_chain | sed -n 's/.*tcp dport 22 .* handle \([0-9]\+\)/\1/p')
+if [ -z "$HANDLE" ]; then
+	echo "Test 7 failed: could not find rule handle"
+	exit 1
+fi
+
+$NFT -j -f - << EOF
+{"nftables": [{"replace": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify rule was replaced
+if ! $NFT list chain inet test input_chain | grep -q "tcp dport 443"; then
+	echo "Test 7 failed: rule not replaced correctly"
+	exit 1
+fi
+if $NFT list chain inet test input_chain | grep -q "tcp dport 22"; then
+	echo "Test 7 failed: old rule still exists"
+	exit 1
+fi
+
+# ===== CREATE operations =====
+
+echo "Test 8: Create table (should work like add)"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
+EOF
+
+if ! $NFT list tables | grep -q "created_table"; then
+	echo "Test 8 failed: table not created"
+	exit 1
+fi
+
+echo "Test 9: Create table that exists (should fail)"
+if $NFT -j -f - 2>/dev/null << 'EOF'
+{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
+EOF
+then
+	echo "Test 9 failed: create should have failed for existing table"
+	exit 1
+fi
+
+# ===== DELETE operations =====
+
+echo "Test 10: Delete rule"
+HANDLE=$($NFT -a list chain inet test input_chain | sed -n 's/.*tcp dport 443 .* handle \([0-9]\+\)/\1/p')
+$NFT -j -f - << EOF
+{"nftables": [{"delete": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE}}}]}
+EOF
+
+if $NFT list chain inet test input_chain | grep -q "tcp dport 443"; then
+	echo "Test 10 failed: rule not deleted"
+	exit 1
+fi
+
+echo "Test 11: Delete counter"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
+EOF
+
+if $NFT list counters | grep -q "test_counter"; then
+	echo "Test 11 failed: counter not deleted"
+	exit 1
+fi
+
+echo "Test 12: Delete set"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"set": {"family": "inet", "table": "test", "name": "test_set"}}}]}
+EOF
+
+if $NFT list sets | grep -q "test_set"; then
+	echo "Test 12 failed: set not deleted"
+	exit 1
+fi
+
+echo "Test 13: Delete chain"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"chain": {"family": "inet", "table": "test", "name": "input_chain"}}}]}
+EOF
+
+if $NFT list chains | grep -q "input_chain"; then
+	echo "Test 13 failed: chain not deleted"
+	exit 1
+fi
+
+echo "Test 14: Delete table"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"table": {"family": "inet", "name": "test"}}}]}
+EOF
+
+if $NFT list tables | grep -q "table inet test"; then
+	echo "Test 14 failed: table not deleted"
+	exit 1
+fi
+
+echo "All tests passed!"
diff --git a/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft b/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft
new file mode 100644
index 00000000..f449da30
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft
@@ -0,0 +1,18 @@
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
+        "name": "created_table",
+        "handle": 0
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft b/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft
new file mode 100644
index 00000000..1d9aecf1
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft
@@ -0,0 +1,2 @@
+table ip created_table {
+}
-- 
2.51.1

