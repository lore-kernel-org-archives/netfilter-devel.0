Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C8A3A63ED
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 19:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768938803; cv=none; b=IKzSafPDy/F2JoX/dftGNxHGCZFYbZ2Qlyw9lYM2UVkkR0MHOijgcrQkQ2vyxehINakk5pQORyNEvYbn0+3y6DrA0Smc5/gXLepWs1rDGYETkNOGNycD2eo8+Skt24/5bQc6nRKeR1xrfJOPXLXfYlPpxRR4aHwEGaLvAvcePRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768938803; c=relaxed/simple;
	bh=8AEy9rZVBNHQrqTkD+gFqDbnExKTZSjnpgNOZgAkGGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KorBFc4tdaRLXITyh1eIBR+SWHM/teXLd1vl2ptxvsPMRweNg52oc71NuQ1Md4hsUKjY+NP2uTmWGSyzrSP3hXbhORjb0f0ml4wNKB6yWs3pY9QG09mC0oQl7BbkocC/HAEbO9wbKFEFJWCT1igyOBH7oiOg6AtWloK+uTvuyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqaO5eVD; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqaO5eVD"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4801d7c72a5so31670165e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 11:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768938799; x=1769543599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7KVsSM3pHMXm/nbt8Ynbr+vKa5xbjo2TcX4/+wos5c=;
        b=HqaO5eVD1pXexRDQS5jdyqEVFELtkLH0PEU5hgilYVupNZt2rrUf2opsfn6DEVr07f
         rMhcz/7IbG7YTqH8NqGkwM5vlh2GNBauuxjbSERiC2NwNl/WwyqwDLy4Oke+l66EuMEN
         MOt8ybfIJs49NHFG+adAS74cm8SMa51RUX/07b2U3iLx89doE20TSImeVi0YUYYSjXQd
         j77AJKumbqrd4Jn7iPSqBlO6KoY0ix2W9m1nfyTGCpvdAY7oSjSkJu47rhhitsKGLF/9
         z0ncNDFoDEwancQPVA6siuQDV4MKCHHZv8jOR22KJBnmeE3hO8RWBtccCxvWwZbYO4aM
         ob9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768938799; x=1769543599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i7KVsSM3pHMXm/nbt8Ynbr+vKa5xbjo2TcX4/+wos5c=;
        b=cTCTsqCpYPZBQsotUjULYBW6cjS3DtVdBe4An64amZ+S1u6uhwWFuHoIHzsmcNiZXs
         1CXKJJbKo+27xjkk9aJ04LFw6+aWYwgmrUnr3MV18pazdq0wpEo4fkuledKl22j8YGe0
         yYEnrD3YJqqlWs6X5LMci1THcC8Y156NmnigOM+8ahoHUHA5gpjle5A2z8LR+1QtoPng
         p5x0fIgrKM9ho4LEdmlYnl0ABCKSpOy0A5RiuEQvDEhQu+8xF4tROfwX5Bphk7K4FfSx
         OUPrALqyeeVkfjD7dp9iJLPp69HvaNFC3khCJ7HsUEWfkauFuiAMzhLUcAnSq180HmeG
         lwCA==
X-Gm-Message-State: AOJu0Yw0wyfCHW95+koug4hoo8w3fHhgp+4BrWXEbDOFIJ0eNlgjoH8o
	JVqTDTKHw83HOSC2/agdkdzB/KVTs+/tgmBHJVUzWY6Y5CwgoGs6vfR0+rwihw==
X-Gm-Gg: AY/fxX5aWeQGTqlGB0mNP8wlTcfRLsbZyAORyQQjztWYPKzKjYgsKPoVOcxUzYr2BBF
	ZjPE7TW9lWjTwe6nAQyC8XFq+shQzezuWGwQhOTJmKqhapgCYFaMQsGCg7UMZJ12h6veY8guR+p
	Ow0B2+7Q2dHDvY8UuAFVEnt4q+txsYRQtLwV3zVRTwsUmLkIfc3ucmZW16LMcQgfb6MNOeVedUs
	EVUlX/w5uBQqAc5qMFIUJXHEBj56LAQTdw/MQlNTJcEXia4FDipb2r8XWQNAdVZJfH9n9DT4nnU
	mAVmKRjy6h7KkkgH+378Kk/Py4jXdqXld6iZZQ/wA0Dazhg7bhKivdDrs3+Zdn1EX/R6GHxy9iY
	ywdiJCn0j1gUNgW1onT1iKoTgULmAUdSvj8jYw5cHhkI2ETZmSVcqE3wcH0xcZF/hTH7r0aMEpl
	QKke7mBHRHkMP/QkzpMPTt
X-Received: by 2002:a05:600c:a03:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-4803d88aa32mr52295305e9.10.1768938799136;
        Tue, 20 Jan 2026 11:53:19 -0800 (PST)
Received: from bluefin ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b789sm320114165e9.1.2026.01.20.11.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 11:53:18 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v6 2/3] tests: shell: add JSON test for all object types
Date: Tue, 20 Jan 2026 20:53:02 +0100
Message-ID: <20260120195303.1987192-3-knecht.alexandre@gmail.com>
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
 .../json/0007add_insert_delete_objects_0      | 163 ++++++++++++++++++
 .../0007add_insert_delete_objects_0.json-nft  |  18 ++
 .../dumps/0007add_insert_delete_objects_0.nft |   2 +
 3 files changed, 183 insertions(+)
 create mode 100755 tests/shell/testcases/json/0007add_insert_delete_objects_0
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0007add_insert_delete_objects_0.nft

diff --git a/tests/shell/testcases/json/0007add_insert_delete_objects_0 b/tests/shell/testcases/json/0007add_insert_delete_objects_0
new file mode 100755
index 00000000..2f548dbc
--- /dev/null
+++ b/tests/shell/testcases/json/0007add_insert_delete_objects_0
@@ -0,0 +1,163 @@
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
+EXPECT='table inet test {
+	counter test_counter {
+		packets 0 bytes 0
+	}
+
+	quota test_quota {
+		1000000 bytes
+	}
+
+	set test_set {
+		type ipv4_addr
+	}
+
+	chain input_chain {
+		type filter hook input priority filter; policy accept;
+		tcp dport 22 accept
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT list ruleset) || { echo "Failed to verify ruleset after add operations"; exit 1; }
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

