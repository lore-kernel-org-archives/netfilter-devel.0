Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317C221D9E
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743434648; cv=none; b=AIMtRNIY65eh/O4WqcicRBv4+YJR+IcFKgFZ/YSeYMs9pHWmO/QXuW2/wuJy9arpzegV7grbZDC5pGkzdMCLINUBvgcAaunrGvQQPEQVppFJ70dlBCFAYyixLtG2UbzamqtEW8jevqfhcQxE5PSuGv35vSRnxkY8cPeiNsaCPsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743434648; c=relaxed/simple;
	bh=qwbvQOhjMYHpW+PaIypnuWKzrKLi/AgUVZ2yWfKUxv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr2s6xwsT6+jUJMmLoXVsBX7FPwdx2F3hbyQSwQlOHfnD80Rzcf9Gv60kBVQr0y9T2vzQhuB6/D3/gaIS3fklHdGVISeg2RAoqb8Vi6bsEdAEWmcVACezyUAPaIx9aXIcTW50+xo4ftJoRI8r8T1BDrv/PsP0W6t/W6gtKUyYnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzGzb-000508-QK; Mon, 31 Mar 2025 17:24:03 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] evaluate: only allow stateful statements in set and map definitions
Date: Mon, 31 Mar 2025 17:23:20 +0200
Message-ID: <20250331152323.31093-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331152323.31093-1-fw@strlen.de>
References: <20250331152323.31093-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bison parser doesn't allow this to happen due to grammar
restrictions, but the json input has no such issues.

The bogon input assigns 'notrack' which triggers:
BUG: unknown stateful statement type 19
nft: src/netlink_linearize.c:1061: netlink_gen_stmt_stateful: Assertion `0' failed.

After patch, we get:
Error: map statement must be stateful

Fixes: 07958ec53830 ("json: add set statement list support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                |  5 ++-
 .../unkown_stateful_statement_type_19_assert  | 34 +++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/unkown_stateful_statement_type_19_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index e9ab829b6bbb..f73edc916406 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5157,8 +5157,11 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (set->timeout)
 		set->flags |= NFT_SET_TIMEOUT;
 
-	list_for_each_entry(stmt, &set->stmt_list, list)
+	list_for_each_entry(stmt, &set->stmt_list, list) {
+		if (stmt_evaluate_stateful(ctx, stmt,type) < 0)
+			return -1;
 		num_stmts++;
+	}
 
 	if (num_stmts > 1)
 		set->flags |= NFT_SET_EXPR;
diff --git a/tests/shell/testcases/bogons/nft-j-f/unkown_stateful_statement_type_19_assert b/tests/shell/testcases/bogons/nft-j-f/unkown_stateful_statement_type_19_assert
new file mode 100644
index 000000000000..e8a0f768d754
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/unkown_stateful_statement_type_19_assert
@@ -0,0 +1,34 @@
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
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "mark",
+        "stmt": [
+          {
+            "notrack": null
+          }
+        ]
+      }
+    }
+  ]
+}
+
-- 
2.49.0

