Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A804A307483
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750801633; cv=none; b=U6m7LbWt+SIDR3Tm6/It/e6z8Y6aHc03OAmq0skexP80ViHXYQvD49EWXMRoO+r0UxAasBp/xJ7oekNyiU4xqEcS3x81lKgxTx9OmdAHp36bqUX92n1WF9TEIDAs2WB6aLNtAvL8aOA8ovrTJyz+9lu1LiEKGlgtnnhb76XkPTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750801633; c=relaxed/simple;
	bh=TZPdcAIWeoh1wzj5tCp8CVyqblYyMHlYsjma0YWYH4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eb+v8LIW9O+S71OwQfZ+soqg/PjS816BHPuDItFoUs3NqOTP76cM295lX5UkXCp0a+jwZaGTGwB8AJv1t6b1HXSY43zUoOIlHMJqPdPyWwSbS8mYyzromGR2glcLbtUYeNJC1j9U4Sp47ktGMrBuLZsV0+JQ+u7Lv0bX6x39Dvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 94D1A61597; Tue, 24 Jun 2025 23:47:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: reject too long interface names
Date: Tue, 24 Jun 2025 23:46:59 +0200
Message-ID: <20250624214702.25077-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit added a length check on ifnames to the bison parser.
Unfortunately that wasn't enough, json parser has the same issue.

Bogon results in:
BUG: Interface length 44 exceeds limit
nft: src/mnl.c:742: nft_dev_add: Assertion `0' failed.

After patch, included bogon results in:
Error: Invalid device at index 0. name d2345678999999999999999999999999999999012345 too long

I intentionally did not extend evaluate.c to catch this, past sentiment
was that frontends should not send garbage.

I'll send a followup patch to also catch this from eval stage in case there
are further reports for frontends passing in such long names.

Fixes: fa52bc225806 ("parser: reject zero-length interface names")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                             | 17 +++-
 .../nft-j-f/dev_name_parser_overflow_crash    | 90 +++++++++++++++++++
 2 files changed, 105 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/dev_name_parser_overflow_crash

diff --git a/src/parser_json.c b/src/parser_json.c
index e3dd14cda350..3195d529cbbc 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2951,7 +2951,13 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 	size_t index;
 
 	if (!json_unpack(root, "s", &dev)) {
-		tmp = constant_expr_alloc(int_loc, &string_type,
+		if (strlen(dev) >= IFNAMSIZ) {
+			json_error(ctx, "Device name %s too long", dev);
+			expr_free(expr);
+			return NULL;
+		}
+
+		tmp = constant_expr_alloc(int_loc, &ifname_type,
 					  BYTEORDER_HOST_ENDIAN,
 					  strlen(dev) * BITS_PER_BYTE, dev);
 		compound_expr_add(expr, tmp);
@@ -2969,7 +2975,14 @@ static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
 			expr_free(expr);
 			return NULL;
 		}
-		tmp = constant_expr_alloc(int_loc, &string_type,
+
+		if (strlen(dev) >= IFNAMSIZ) {
+			json_error(ctx, "Device name %s too long at index %zu", dev, index);
+			expr_free(expr);
+			return NULL;
+		}
+
+		tmp = constant_expr_alloc(int_loc, &ifname_type,
 					  BYTEORDER_HOST_ENDIAN,
 					  strlen(dev) * BITS_PER_BYTE, dev);
 		compound_expr_add(expr, tmp);
diff --git a/tests/shell/testcases/bogons/nft-j-f/dev_name_parser_overflow_crash b/tests/shell/testcases/bogons/nft-j-f/dev_name_parser_overflow_crash
new file mode 100644
index 000000000000..8303c5c1cad9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/dev_name_parser_overflow_crash
@@ -0,0 +1,90 @@
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
+        "family": "netdev",
+        "name": "filter1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "filter1",
+        "name": "Main_Ingress1",
+        "handle": 0,
+        "dev": "lo",
+        "type": "filter",
+        "hook": "ingress",
+        "prio": -500,
+        "policy": "accept"
+      }
+    },
+    {
+      "table": {
+        "family": "netdev",
+        "name": "filter2",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "filter2",
+        "name": "Main_Ingress2",
+        "handle": 0,
+        "dev": [
+          "d2345678999999999999999999999999999999012345",
+          "lo"
+        ],
+        "type": "filter",
+        "hook": "ingress",
+        "prio": -500,
+        "policy": "accept"
+      }
+    },
+    {
+      "table": {
+        "family": "netdev",
+        "name": "filter3",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "filter3",
+        "name": "Main_Ingress3",
+        "handle": 0,
+        "dev": [
+          "d23456789012345",
+          "lo"
+        ],
+        "type": "filter",
+        "hook": "ingress",
+        "prio": -500,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "filter3",
+        "name": "Main_Egress3",
+        "handle": 0,
+        "dev": "lo",
+        "type": "filter",
+        "hook": "egress",
+        "prio": -500,
+        "policy": "accept"
+      }
+    }
+  ]
+}
-- 
2.49.0

