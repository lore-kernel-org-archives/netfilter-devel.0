Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39382C158A
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2025 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753097777; cv=none; b=eOmV48Tcbsn+GAWd+1JggY5c7LlkJbrIPljgIu6ckQMAvy0muN4SRL9XncfkjWFJLxhrPv8QMd2EDzcXguhfbbgzC9wdjgTpp3XuP9m+yUI3u8D0VQdRityRtW7JdAgYnCF1+PS0l8u/H7DKnf4WeXL+rMAAcm/lWb7TcpeN3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753097777; c=relaxed/simple;
	bh=rh/npJhlg2aieL8kkLbmbbB+LTcppHXcshts5ThPe3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fYdt3y/sLbQwDLprNzBvnhr2M2qQNa56vHOZs8Uun+P9CSHoAXtvvWMcdIvSM418vzYMyfB+c/kpig7cAgCFdj/6dxJUfmV3fVJlfY/GooFzKwkKLpmB6DJvz2GDyxmkJep/ry4OKqvglLmZLrh7I3f9uArKsQb3eb+X3EjVTWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 258AA60329; Mon, 21 Jul 2025 13:36:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_json: fix assert due to empty interface name
Date: Mon, 21 Jul 2025 13:36:03 +0200
Message-ID: <20250721113607.11522-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
nft: src/mnl.c:744: nft_dev_add: Assertion `ifname_len > 0' failed.

After:
internal:0:0-0: Error: empty interface name

Bison checks this upfront, do same in json.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                             | 34 +++++++++++++------
 .../mnl_nft_dev_add_ifname_len_0_assert       | 19 +++++++++++
 2 files changed, 42 insertions(+), 11 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/mnl_nft_dev_add_ifname_len_0_assert

diff --git a/src/parser_json.c b/src/parser_json.c
index a6f142c68756..be0de69837d8 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2959,6 +2959,25 @@ static struct expr *parse_policy(const char *policy)
 				   sizeof(int) * BITS_PER_BYTE, &policy_num);
 }
 
+static struct expr *ifname_expr_alloc(struct json_ctx *ctx,
+				      const char *name)
+{
+	size_t length = strlen(name);
+
+	if (length == 0) {
+		json_error(ctx, "empty interface name");
+		return NULL;
+	}
+
+	if (length >= IFNAMSIZ) {
+		json_error(ctx, "Device name %s too long", name);
+		return NULL;
+	}
+
+	return constant_expr_alloc(int_loc, &ifname_type, BYTEORDER_HOST_ENDIAN,
+				   length * BITS_PER_BYTE, name);
+}
+
 static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 {
 	struct expr *tmp, *expr = compound_expr_alloc(int_loc, EXPR_LIST);
@@ -2967,15 +2986,12 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 	size_t index;
 
 	if (!json_unpack(root, "s", &dev)) {
-		if (strlen(dev) >= IFNAMSIZ) {
-			json_error(ctx, "Device name %s too long", dev);
+		tmp = ifname_expr_alloc(ctx, dev);
+		if (!tmp) {
 			expr_free(expr);
 			return NULL;
 		}
 
-		tmp = constant_expr_alloc(int_loc, &ifname_type,
-					  BYTEORDER_HOST_ENDIAN,
-					  strlen(dev) * BITS_PER_BYTE, dev);
 		compound_expr_add(expr, tmp);
 		return expr;
 	}
@@ -2992,15 +3008,11 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 			return NULL;
 		}
 
-		if (strlen(dev) >= IFNAMSIZ) {
-			json_error(ctx, "Device name %s too long at index %zu", dev, index);
+		tmp = ifname_expr_alloc(ctx, dev);
+		if (!tmp) {
 			expr_free(expr);
 			return NULL;
 		}
-
-		tmp = constant_expr_alloc(int_loc, &ifname_type,
-					  BYTEORDER_HOST_ENDIAN,
-					  strlen(dev) * BITS_PER_BYTE, dev);
 		compound_expr_add(expr, tmp);
 	}
 	return expr;
diff --git a/tests/shell/testcases/bogons/nft-j-f/mnl_nft_dev_add_ifname_len_0_assert b/tests/shell/testcases/bogons/nft-j-f/mnl_nft_dev_add_ifname_len_0_assert
new file mode 100644
index 000000000000..3be394c1fee8
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/mnl_nft_dev_add_ifname_len_0_assert
@@ -0,0 +1,19 @@
+{
+  "nftables": [
+    {
+  "table": { "family": "netdev", "name": "test", "ha": 0,
+    "flags": "dormant"   } },
+{
+  "chain": {
+    "family": "netdev",
+    "table": "test",
+"name": "ingress",
+    "le": 0,
+"dev": "", "ha": 0,
+    "flags": "dormy1", "type": "fi",
+    "hook": "ingress",
+    "prio": 0, "policy": "drop"
+  }
+    }
+  ]
+}
-- 
2.49.1

