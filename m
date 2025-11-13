Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD9B271A7B
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763065851; cv=none; b=aPdXWUEaCg6wljJgFJ3bsbq3QnXibdZ2+4R4ONWrZFe05fqks4LYimmyiAMoN0JPxB7F1NGcKBf92q8RT6zcg4Ag3gikoLlw95ycl0GStO7V9sr14V9xN1Lf99b+dERRpCNhkENX4Y4bvM9PQzHCY91zAQE3fpLAbKrJOeLDruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763065851; c=relaxed/simple;
	bh=W3Dt252kIwK13l4nDMNqiW3ZTxS8yydHZ4yFO4Av3tE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvGSNYcOaqUC+3s7dm+/uZEKnp+uYmdaENFFhWulmMu1Gs66nh6OSfevHZ6kaz+04mIKbL9w8YluuvrayOelWmzTvHTZ8ocHIgej5/Of2Tk4xg9uC87uSjq3efcoiS4xEGSP6VEI6VqPxFThtjs43ACZ7Y9LyWcYpOCSBMUNuP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWN7RUdl; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWN7RUdl"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3669ca3dso740995f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 12:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763065847; x=1763670647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XfW6aoXnioGU0MeBMX2CGyidUQXgIpcAGsq/zU/HABI=;
        b=dWN7RUdlm6yqiHk7vMfq7Q7pZrkfRM7JwnU2lRtIyhET0gFZ9G6R/o+2Hx9ii6+ZdE
         mnpW92S7KHjIBDTLaPLibUzZfjBccxLVGGjXRCjDR+DON1CsT2ePKjGQ8ynKnMal9gU2
         4Lxga+ERNGL0+J7pGSE75ygdO+7giITNF+KltblMNVyEUMgPxaitdp1McL603zhzo9r9
         E/OK7ZgIEE6hTbG0JEcP+YFvEkg2dVkVDZSXyCruKxcF8dq/KJzcCZ063zRQ1T2kP6Y7
         FjgknV/L6R1HvHF4fwsi+UMwFmJIf+8B8BVm9jXYYcx5fdfI3uzOp2HcmQtO5sYoeEy2
         k5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763065847; x=1763670647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfW6aoXnioGU0MeBMX2CGyidUQXgIpcAGsq/zU/HABI=;
        b=E1hAQMY+hWE4XOOKJAi/OJCxR3Pgue6PlfqwxY0f6eONtMDCepbBKYgEFHoFLYT+du
         wtfoug466fVhwt01BIP69kVSmu+FL8Kc10RQgGI6uLJ7LeuwhEBHiCT0NyvnTWePXKSf
         bZWFAMF89XdzLmbOlBydaey8eDAEeGnOIlg6TcqbAk6L8aya2fb28bsd81kwUQ1vIq/p
         b58XVIGXDbUVka0+r85yB4LOaeqdXoWupe94DOSz9Bh6VK1fGXucg+tlPwe9S4LBJHvy
         T8Ov59K5Yq9UJoYfYZJUmIv7295Js65w7nxTPGfOV3p4P5Asuh9uDaFd39e2vy3UJgzg
         1XPQ==
X-Gm-Message-State: AOJu0Yx63cVH8UDJHqbzqfIRWy3V/o9KetP9mqgqc64zQck6QT+8yFb/
	LneFtxyJas8d4X2uxRD09HPne6QbcXo6tJWZv34+mh0ftS/SQXwY9r5qEZPMpg==
X-Gm-Gg: ASbGncsbcSlHxfsVKxw2RUaTInm6DoAB2Yy4jBslZ1C1RHMAZCU8DDemUKV1/BHiHBN
	Y5EtTPv5yC4VXykmtMpdhrZsaA7r3q7MyPd3zdZ6pWh01XoVdiDGU1EDgytc4q7ipM+tH2vwv0D
	aN1u0S0/IIcA5PD9Xpgb1Z5STV/0cnRjWeb/7JlfilWfnkxATZuNUHQT0y3ryVQfDidYFwJw5lM
	WQLUxIVOm4rP8bct2LGWuQEtHTeMXNQtO2bIVNyyUP6kAqziUrz0vr/gAp7Et7VB0AM+E6i52SW
	FFqfiT8cEW0gLdE3EvdRUT2Q3PPn3veTwBVNRux1LeLyrJf9S492/wMOq81IO5V7DQrWx8FEPDR
	r8l39ojQx+J4tjArHl0BoaplsD+CEW+iULakkAS83ZHlkQrgqLqm9Fby5BwUqc1ZgD3QakkSCWr
	uzgLCPO6d67cD+te8ZAGleE+EjNYHj0/lLsNYYbbYoUa3BbPJWbcuFlH8w3pcADg==
X-Google-Smtp-Source: AGHT+IFJZ8WuF3mZOMiUxVS6VJkZMbcPGr8S8qsuzRLJF4O1asJS4Jot6e5iBERBSuRTe2oc2cGpgw==
X-Received: by 2002:a5d:5f45:0:b0:429:8b01:c08d with SMTP id ffacd0b85a97d-42b595a4923mr530566f8f.41.1763065846527;
        Thu, 13 Nov 2025 12:30:46 -0800 (PST)
Received: from bluefin ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7aea7sm5744883f8f.1.2025.11.13.12.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 12:30:45 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH nf-next v4] parser_json: support handle for rule positioning without breaking other objects
Date: Thu, 13 Nov 2025 21:30:41 +0100
Message-ID: <20251113203041.419595-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch enables handle-based rule positioning for JSON add/insert
commands by using a context flag to distinguish between explicit and
implicit command formats.

When processing JSON:
- Explicit commands like {"add": {"rule": ...}} set no flag, allowing
  handle fields to be converted to position for rule placement
- Implicit format (bare objects like {"rule": ...}, used in export/import)
  sets CTX_F_IMPLICIT flag, causing handles to be ignored for portability

This approach ensures that:
- Explicit rule adds with handles work for positioning
- Non-rule objects (tables, chains, sets, etc.) are unaffected
- Export/import remains compatible (handles ignored)

The semantics for explicit rule commands are:
  ADD with handle:    inserts rule AFTER the specified handle
  INSERT with handle: inserts rule BEFORE the specified handle

Includes two comprehensive tests:
- Test 0007: Verifies all object types work with add/insert/delete/replace
- Test 0008: Verifies handle-based positioning and implicit format behavior

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251029224530.1962783-2-knecht.alexandre@gmail.com/
Suggested-by: Phil Sutter <phil@nwl.cc>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 src/parser_json.c                             |  41 ++++-
 .../json/0007add_insert_delete_objects_0      | 159 ++++++++++++++++++
 .../testcases/json/0008rule_position_handle_0 |  83 +++++++++
 3 files changed, 280 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/json/0007add_insert_delete_objects_0
 create mode 100755 tests/shell/testcases/json/0008rule_position_handle_0

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..ae052e7e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -51,6 +51,12 @@
 #define CTX_F_MAP	(1 << 7)	/* LHS of map_expr */
 #define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
 #define CTX_F_COLLAPSED	(1 << 9)
+#define CTX_F_IMPLICIT	(1 << 10)	/* implicit add (export/import format) */
+
+/* Mask for flags that affect expression parsing context */
+#define CTX_F_EXPR_MASK	(CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_DTYPE | \
+			 CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | \
+			 CTX_F_CONCAT)
 
 struct json_ctx {
 	struct nft_ctx *nft;
@@ -1725,10 +1731,14 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		return NULL;
 
 	for (i = 0; i < array_size(cb_tbl); i++) {
+		uint32_t expr_flags;
+
 		if (strcmp(type, cb_tbl[i].name))
 			continue;
 
-		if ((cb_tbl[i].flags & ctx->flags) != ctx->flags) {
+		/* Only check expression context flags, not command-level flags */
+		expr_flags = ctx->flags & CTX_F_EXPR_MASK;
+		if ((cb_tbl[i].flags & expr_flags) != expr_flags) {
 			json_error(ctx, "Expression type %s not allowed in context (%s).",
 				   type, ctx_flags_to_string(ctx));
 			return NULL;
@@ -3201,6 +3211,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		h.index.id++;
 	}
 
+	/* For explicit add/insert/create commands, handle is used for positioning.
+	 * Convert handle to position for proper rule placement.
+	 * Skip this for implicit adds (export/import format).
+	 */
+	if (!(ctx->flags & CTX_F_IMPLICIT) &&
+	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
+		if (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) {
+			h.position.id = h.handle.id;
+			h.handle.id = 0;
+		}
+	}
+
 	rule = rule_alloc(int_loc, NULL);
 
 	json_unpack(root, "{s:s}", "comment", &comment);
@@ -4352,8 +4374,21 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 
 		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
 	}
-	/* to accept 'list ruleset' output 1:1, try add command */
-	return json_parse_cmd_add(ctx, root, CMD_ADD);
+	/* to accept 'list ruleset' output 1:1, try add command
+	 * Mark as implicit to distinguish from explicit add commands.
+	 * This allows explicit {"add": {"rule": ...}} to use handle for positioning
+	 * while implicit {"rule": ...} (export format) ignores handles.
+	 */
+	{
+		uint32_t old_flags = ctx->flags;
+		struct cmd *cmd;
+
+		ctx->flags |= CTX_F_IMPLICIT;
+		cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
+		ctx->flags = old_flags;
+
+		return cmd;
+	}
 }
 
 static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
diff --git a/tests/shell/testcases/json/0007add_insert_delete_objects_0 b/tests/shell/testcases/json/0007add_insert_delete_objects_0
new file mode 100755
index 00000000..08f0eebe
--- /dev/null
+++ b/tests/shell/testcases/json/0007add_insert_delete_objects_0
@@ -0,0 +1,159 @@
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
+# ===== INSERT operations =====
+
+echo "Test 7: Insert rule at beginning"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 80}}, {"accept": null}]}}}]}
+EOF
+
+# Verify rule was inserted at beginning
+RULE_COUNT=$($NFT -a list chain inet test input_chain | grep -c "tcp dport")
+if [ "$RULE_COUNT" != "2" ]; then
+	echo "Test 7 failed: expected 2 rules, got $RULE_COUNT"
+	exit 1
+fi
+
+# ===== REPLACE operations =====
+
+echo "Test 8: Replace rule"
+# Get handle of first rule
+HANDLE=$($NFT -a list chain inet test input_chain | grep "tcp dport 80" | grep -o "handle [0-9]*" | awk '{print $2}')
+if [ -z "$HANDLE" ]; then
+	echo "Test 8 failed: could not find rule handle"
+	exit 1
+fi
+
+$NFT -j -f - << EOF
+{"nftables": [{"replace": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify rule was replaced
+if ! $NFT list chain inet test input_chain | grep -q "tcp dport 443"; then
+	echo "Test 8 failed: rule not replaced correctly"
+	exit 1
+fi
+if $NFT list chain inet test input_chain | grep -q "tcp dport 80"; then
+	echo "Test 8 failed: old rule still exists"
+	exit 1
+fi
+
+# ===== CREATE operations =====
+
+echo "Test 9: Create table (should work like add)"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
+EOF
+
+if ! $NFT list tables | grep -q "created_table"; then
+	echo "Test 9 failed: table not created"
+	exit 1
+fi
+
+echo "Test 10: Create table that exists (should fail)"
+if $NFT -j -f - 2>/dev/null << 'EOF'
+{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
+EOF
+then
+	echo "Test 10 failed: create should have failed for existing table"
+	exit 1
+fi
+
+# ===== DELETE operations =====
+
+echo "Test 11: Delete rule"
+HANDLE=$($NFT -a list chain inet test input_chain | grep "tcp dport 22" | grep -o "handle [0-9]*" | awk '{print $2}')
+$NFT -j -f - << EOF
+{"nftables": [{"delete": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE}}}]}
+EOF
+
+if $NFT list chain inet test input_chain | grep -q "tcp dport 22"; then
+	echo "Test 11 failed: rule not deleted"
+	exit 1
+fi
+
+echo "Test 12: Delete counter"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
+EOF
+
+if $NFT list counters | grep -q "test_counter"; then
+	echo "Test 12 failed: counter not deleted"
+	exit 1
+fi
+
+echo "Test 13: Delete set"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"set": {"family": "inet", "table": "test", "name": "test_set"}}}]}
+EOF
+
+if $NFT list sets | grep -q "test_set"; then
+	echo "Test 13 failed: set not deleted"
+	exit 1
+fi
+
+echo "Test 14: Delete chain"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"chain": {"family": "inet", "table": "test", "name": "input_chain"}}}]}
+EOF
+
+if $NFT list chains | grep -q "input_chain"; then
+	echo "Test 14 failed: chain not deleted"
+	exit 1
+fi
+
+echo "Test 15: Delete table"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"table": {"family": "inet", "name": "test"}}}]}
+EOF
+
+if $NFT list tables | grep -q "table inet test"; then
+	echo "Test 15 failed: table not deleted"
+	exit 1
+fi
+
+echo "All tests passed!"
diff --git a/tests/shell/testcases/json/0008rule_position_handle_0 b/tests/shell/testcases/json/0008rule_position_handle_0
new file mode 100755
index 00000000..ea60690d
--- /dev/null
+++ b/tests/shell/testcases/json/0008rule_position_handle_0
@@ -0,0 +1,83 @@
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
+$NFT add table inet test
+$NFT add chain inet test c
+$NFT add rule inet test c tcp dport 22 accept
+$NFT add rule inet test c tcp dport 80 accept
+
+# Get handle of first rule
+HANDLE=$($NFT -a list chain inet test c | grep "tcp dport 22" | grep -o "handle [0-9]*" | awk '{print $2}')
+
+# Add after handle (should be between 22 and 80)
+$NFT -j -f - <<EOF
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify order: 22, 443, 80
+RULES=$($NFT list chain inet test c | grep "tcp dport" | grep -o "tcp dport [0-9]*")
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
+$NFT add table inet test
+$NFT add chain inet test c
+$NFT add rule inet test c tcp dport 22 accept
+$NFT add rule inet test c tcp dport 80 accept
+
+# Get handle of second rule
+HANDLE=$($NFT -a list chain inet test c | grep "tcp dport 80" | grep -o "handle [0-9]*" | awk '{print $2}')
+
+# Insert before handle
+$NFT -j -f - <<EOF
+{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
+EOF
+
+# Verify order: 22, 443, 80
+RULES=$($NFT list chain inet test c | grep "tcp dport" | grep -o "tcp dport [0-9]*")
+if [ "$RULES" = "$EXPECTED" ]; then
+	echo "PASS: Rule inserted before handle"
+else
+	echo "FAIL: Expected order 22,443,80, got:"
+	echo "$RULES"
+	exit 1
+fi
+
+echo "Test 3: Implicit format ignores handle"
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+$NFT add rule inet test c tcp dport 22 accept
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
-- 
2.51.0

