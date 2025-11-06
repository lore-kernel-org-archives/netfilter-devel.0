Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C9242048
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 08:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762418176; cv=none; b=tEyyJYdJXIBvVftfEScgvIWUVcmAuaL2y2mJjZrNpqhXOfgFHwhlKJHGjZ+TDP6/LEYyaL6i83i77Ayiao/LqnwQicXmLjthiDkjATzpish2r936dqTPSltulSdDshuN911tV1Jq0tvgBmh68DzAXpszPHvaWQVdyU/K82noemo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762418176; c=relaxed/simple;
	bh=/6tPGwDlowGp7nIJtY/jDACePlCbBGzxQ+coIqK8cC0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lcuWZ1nLTpMTU0KZeYGz7+wuzat1LnUYuKTrQFLiVH4iCSD8IMYCHAIgbXp7I5NHcWJoVi6NTnjGS8wgSiO74Zw1cICH4ES3V9Z2leAfZHYjh7CWDq2cjmN551GcEndDnPp+Gb0CjcgW5yrocJ5LCHm8u242arbppu+Xvyr9goU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEYUMkBO; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEYUMkBO"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso269735f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Nov 2025 00:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762418172; x=1763022972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hyYjbdG054VxZEIyqRH9SjgK+1/e46zeO8v6yBwik8o=;
        b=MEYUMkBOq/FwAmpEq9+VKK51NM60pMqjJzLJcvIuymsXlqsKHdo592WE8Cxs3M262m
         mlyG2+M6+cUiKrnqI8YKD6iguMrHR17KRv5zWdgNfMfaDL5ihw5efYQDy+m1IHAAnBio
         pOrpaiYKg8+NQTWm3gV2ehAZgAso/xR+i6I6tY0ZFi4ykNNDN2k3WO4AdB5PbNuuyOuQ
         oraIh7wCPQ6xxro+kgzrUt6Qrd1jQCdQrdPt+Yy3S2x38iIARlwvdTE6xiM5nUgI0w0O
         VakcAPqB6j61OSC3OymVfsuNWYJuwd0bIJCsEcJUyfcZyWHfQ7imf0Ts8CCZIG8tHB11
         VwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762418172; x=1763022972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hyYjbdG054VxZEIyqRH9SjgK+1/e46zeO8v6yBwik8o=;
        b=qIA79/Fvc0WUkL1/BTnCpxRpxZtjI9VuGs03BOsUCRng1TrSjBXQoWdDraOECHiE2Y
         MfWEcfh2cS1CX+SMjnQlArD+hj2mcCPBVkdWe35NUbp7Mtv+14E4yShsazl1vJVNmf3O
         tMKII8dDEDMLB80R2pnTt6C9OpTyuwAtckU/ri5W0D9lvpRmrco80tdfSUwahpdIHR66
         pnrm4oF325oQ20T4CKFHeC0xR67nFwV7IYwsQkntildK9JPLumxGb/uINOAmyrfkkkK2
         lzk+zniCek17E9BST0Zd15yduhs8xQh9gWKvF/ojUuBbch3NP8Txvhde6ubx9Hlc27iR
         1QOw==
X-Gm-Message-State: AOJu0YxtUO2uNtOocGsN1cjHARIie4k3Ftfl2cWVayBvSzRWPUJqbMX8
	MWykbOpZKkFdvp25fPE8/mkJtOOvI5JL0HEJv9pMjX+3L+L3MmyvwjzA5RrmuA==
X-Gm-Gg: ASbGncsLDMAy+sh45gGg+tPmjyfF45xAvoBgXoaIXMQx2dhV6yOQajm8Q11Vr3+CdD1
	hW4NalLzPanfmypuNXUoRIFZ9lSWOlR+N8MX6GFRRuHjHYxYdaXSrZYSTb9NLtOg+ssaMLjJO43
	tFkx4Q6HpKk6f8/HF+H/sSGAXm7qypvgePxGqkfzfjTYasyq3LtFmUzgukGxwD//uaqC8Fk+yxp
	A43V1CqPLkM+V6qRb0xdMopvf0zX3luwkQUaHB6TMG4ou2sxDPbJtOE24OJbdnlKrOX6XIu1ALE
	4yZ1eYmXvKA7j0S71wYz4vOfoEea0M6ghYXx+Zm5Py8U5F6V+6h7Xzf4l4lot7nuUx3TNypoZKj
	WaXJkaWfOcvqNPRZz6aNmboNhk5cv8SOOW5Uj6LtFF25yKcqe6lWi5XBzki4xOiXDsyzTWoQv+v
	7frffsvcGhTgq42a9LI1GkUsd+TdCF0vo7gRoBCOu0ALIfbYUeeNsyi2fDOJzTG3qvyeo=
X-Google-Smtp-Source: AGHT+IGig//5D9nJ5aMxIRjF4tB0l52Qk5wA2XAXmxQW0vOrbdiFIZJHeZZp+tSrv6yP+g3PqE3juw==
X-Received: by 2002:a05:6000:2301:b0:429:d391:642e with SMTP id ffacd0b85a97d-429e3305da1mr5106900f8f.30.1762418172265;
        Thu, 06 Nov 2025 00:36:12 -0800 (PST)
Received: from pc-111.home ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb403800sm3525546f8f.7.2025.11.06.00.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 00:36:11 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH nf v3] parser_json: support handle for rule positioning in JSON add rule
Date: Thu,  6 Nov 2025 09:35:51 +0100
Message-ID: <20251106083551.137310-1-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch enables handle-based rule positioning for JSON commands by
distinguishing between explicit and implicit "add" operations:

- Explicit commands ({"add": {"rule": ...}}) route through
  json_parse_cmd_replace, which converts the handle field to position,
  enabling rules to be inserted at specific locations
- Implicit commands ({"rule": ...} from export/import) continue
  using json_parse_cmd_add, which ignores handles for backward
  compatibility

The semantics are:
  ADD with handle:    inserts rule AFTER the specified handle
  INSERT with handle: inserts rule BEFORE the specified handle

This maintains export/import compatibility while enabling programmatic
rule positioning via the JSON API.

Includes comprehensive test cases covering:
- Multiple additions at the same handle position
- INSERT before handle
- Error handling for deleted handles
- Export/import compatibility (implicit adds ignore handles)

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251029224530.1962783-2-knecht.alexandre@gmail.com/
Suggested-by: Phil Sutter <phil@nwl.cc>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 src/parser_json.c                             |   7 +-
 .../0008rule_add_position_comprehensive_0     | 135 ++++++++++++++++++
 2 files changed, 139 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/json/0008rule_add_position_comprehensive_0

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..b9b3bef0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4045,7 +4045,8 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	if ((op == CMD_INSERT || op == CMD_ADD) && h.handle.id) {
+	if (h.handle.id &&
+	    (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE)) {
 		h.position.id = h.handle.id;
 		h.handle.id = 0;
 	}
@@ -4328,9 +4329,9 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		enum cmd_ops op;
 		struct cmd *(*cb)(struct json_ctx *ctx, json_t *, enum cmd_ops);
 	} parse_cb_table[] = {
-		{ "add", CMD_ADD, json_parse_cmd_add },
+		{ "add", CMD_ADD, json_parse_cmd_replace },
 		{ "replace", CMD_REPLACE, json_parse_cmd_replace },
-		{ "create", CMD_CREATE, json_parse_cmd_add },
+		{ "create", CMD_CREATE, json_parse_cmd_replace },
 		{ "insert", CMD_INSERT, json_parse_cmd_replace },
 		{ "delete", CMD_DELETE, json_parse_cmd_add },
 		{ "list", CMD_LIST, json_parse_cmd_list },
diff --git a/tests/shell/testcases/json/0008rule_add_position_comprehensive_0 b/tests/shell/testcases/json/0008rule_add_position_comprehensive_0
new file mode 100755
index 00000000..171de992
--- /dev/null
+++ b/tests/shell/testcases/json/0008rule_add_position_comprehensive_0
@@ -0,0 +1,135 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+# Comprehensive test for JSON rule positioning with handle parameter
+# Tests the scenarios requested by Florian Westphal
+
+set -e
+
+$NFT flush ruleset
+
+# Setup: create table and chain
+$NFT add table inet test
+$NFT add chain inet test c
+
+# Add 3 initial rules to get handles 2, 3, 4
+$NFT add rule inet test c tcp dport 1111 accept  # will be handle 2
+$NFT add rule inet test c tcp dport 2222 accept  # will be handle 3
+$NFT add rule inet test c tcp dport 3333 accept  # will be handle 4
+
+# Test 1: Positioning at handle 2 should result in: rule2, newRule, rule3, rule4
+echo "Test 1: Add rule after handle 2"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 2, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 9991}}, {"accept": null}]}}}]}
+EOF
+
+EXPECTED="table inet test {
+	chain c {
+		tcp dport 1111 accept
+		tcp dport 9991 accept
+		tcp dport 2222 accept
+		tcp dport 3333 accept
+	}
+}"
+
+GET="$($NFT list ruleset)"
+if [ "$EXPECTED" != "$GET" ]; then
+	echo "Test 1 failed: rule not positioned correctly after handle 2"
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+# Test 2: Positioning at handle 2 again should result in: rule2, newRule2, newRule, rule3, rule4
+echo "Test 2: Add another rule after handle 2 (should be after original handle 2, not the new rule)"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 2, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 9992}}, {"accept": null}]}}}]}
+EOF
+
+EXPECTED="table inet test {
+	chain c {
+		tcp dport 1111 accept
+		tcp dport 9992 accept
+		tcp dport 9991 accept
+		tcp dport 2222 accept
+		tcp dport 3333 accept
+	}
+}"
+
+GET="$($NFT list ruleset)"
+if [ "$EXPECTED" != "$GET" ]; then
+	echo "Test 2 failed: second rule not positioned correctly after handle 2"
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+# Test 3: Positioning at a deleted handle should fail
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+$NFT add rule inet test c tcp dport 1111 accept  # handle 2
+$NFT add rule inet test c tcp dport 2222 accept  # handle 3
+$NFT delete rule inet test c handle 2
+
+echo "Test 3: Positioning at deleted handle should fail"
+if $NFT -j -f - 2>/dev/null << 'EOF'
+{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 2, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 9993}}, {"accept": null}]}}}]}
+EOF
+then
+	echo "Test 3 failed: should have failed when positioning at deleted handle"
+	exit 1
+fi
+
+# Test 4: INSERT before handle
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+$NFT add rule inet test c tcp dport 1111 accept  # handle 2
+$NFT add rule inet test c tcp dport 2222 accept  # handle 3
+$NFT add rule inet test c tcp dport 3333 accept  # handle 4
+
+echo "Test 4: Insert rule before handle 3"
+$NFT -j -f - << 'EOF'
+{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 3, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 9994}}, {"accept": null}]}}}]}
+EOF
+
+EXPECTED="table inet test {
+	chain c {
+		tcp dport 1111 accept
+		tcp dport 9994 accept
+		tcp dport 2222 accept
+		tcp dport 3333 accept
+	}
+}"
+
+GET="$($NFT list ruleset)"
+if [ "$EXPECTED" != "$GET" ]; then
+	echo "Test 4 failed: rule not inserted correctly before handle 3"
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+# Test 5: Verify implicit add (export format) ignores handles
+echo "Test 5: Implicit add should ignore handles (export/import compatibility)"
+$NFT flush ruleset
+
+# This is export format (no "add" wrapper) - handles should be ignored
+$NFT -j -f - << 'EOF'
+{"nftables": [{"table": {"family": "inet", "name": "test"}}, {"chain": {"family": "inet", "table": "test", "name": "c"}}, {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 999, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 5555}}, {"accept": null}]}}]}
+EOF
+
+# Should succeed even though handle 999 doesn't exist (because it's ignored)
+EXPECTED="table inet test {
+	chain c {
+		tcp dport 5555 accept
+	}
+}"
+
+GET="$($NFT list ruleset)"
+if [ "$EXPECTED" != "$GET" ]; then
+	echo "Test 5 failed: implicit add should have ignored handle"
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+echo "All tests passed!"
-- 
2.51.0

