Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B082550B3
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684955; cv=none; b=ElYd+8bcTD6boJ0JOBwJRjmXc0Iu5Hw8CBhEH5iqOD5bbOeVAf1C5zj9v8yn4mwREuc8LOF9boeAUvj8Ft9GQPxzbLhGrK/aIKwQBK3nw+/2GNRBWbzrqcOOFHtQkTXtDyjXcQPbbWEmVtUSNXBuNlto3KFSzhm7zcJO4I0FSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684955; c=relaxed/simple;
	bh=K8z1729akH1gG2BwJN6+O1ShrlJp4TiWf6Db6BzDvSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oNEMfGeNiH+nZDYUbI3UkppmNQoGOQknRLjVzexdBfu4HGTW6s2olmBp9DOWh10+prnDDsOs6MHp6rp60gUpN7GKzsvbY0fitLN4OP9I3U5evA3g8eUBPhvoLgK7E0NoIDk40UgxEpDv/3gX8s+59tbOT0n5+KqSWoScdon1ivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 519376030C; Mon, 23 Jun 2025 15:22:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: refuse to merge set and map
Date: Mon, 23 Jun 2025 15:22:13 +0200
Message-ID: <20250623132225.21115-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject maps and sets of the same name:
 BUG: invalid range expression type catch-all set element
 nft: src/expression.c:1704: range_expr_value_low: Assertion `0' failed.

After:
8:6-6: Error: Cannot merge set with existing map of same name
  set z {
      ^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                 | 11 +++++++++--
 ...xpression_type_catch-all_set_element_assert | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index c666705b23be..709580c2fffe 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5273,8 +5273,15 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return 0;
 	}
 
-	if (existing_set && set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
-		return set_error(ctx, set, "existing %s lacks interval flag", type);
+
+	if (existing_set) {
+		if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
+			return set_error(ctx, set,
+					 "existing %s lacks interval flag", type);
+		if (set_is_map(existing_set->flags) != set_is_map(set->flags))
+			return set_error(ctx, set, "Cannot merge %s with existing %s of same name",
+					type, set_is_map(existing_set->flags) ? "map" : "set");
+	}
 
 	set->existing_set = existing_set;
 
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert b/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
new file mode 100644
index 000000000000..3660ac3fda9c
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
@@ -0,0 +1,18 @@
+table ip x {
+	map z {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.0.0.2, * : 192.168.0.4 }
+	}
+
+	set z {
+		type ipv4_addr
+		flags interval
+		counter
+		elements = { 1.1.1.0/24 counter packets 0 bytes 0,
+			 * counter packets 0 bytes 0packets 0 bytes ipv4_addr }
+		flags interval
+		auto-merge
+		elements = { 1.1.1.1 }
+	}
+}
-- 
2.49.0

