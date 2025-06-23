Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BBF19E7F9
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750707470; cv=none; b=jLvWvuzK5BgtHdRAAyZbmrtqSbrFg0n/v9pCWPAn//d++g6rlk/qKhgPpnDUhYVwLCQPkOlliVxcEbIfJG9a2D42k9zzLYyTWKiY80HiQoPmkeuj6vMQ1vsiYBmH7o4PtNuH90BgXxKiz1gH6mt+DICXxL4Bsj7DziK+Cjde7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750707470; c=relaxed/simple;
	bh=XzdxFEUCtdKu81Xoxxv+L1sYanz7Y3rw8TGfwmxnnfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=go06iM7YtgxBvoC+EFBUKPnboxuvHJLM5mmBfleE7mPHpKrvsvUGn5XQunHJ4bGDaQ0LUIzf+WG2ZjV87gsoY0aa31qqmaaJCK6AJBoGCfUvT+cDHJTe9/+ZrOeFNyVyGxi6bYt7/TJQPdIgEi1E2Po52Zq7e8lxZ/uyM+06Xn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 30F69602AA; Mon, 23 Jun 2025 21:37:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] evaluate: check that set type is identical before merging
Date: Mon, 23 Jun 2025 21:37:31 +0200
Message-ID: <20250623193734.8404-1-fw@strlen.de>
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
Error: Cannot merge set with existing datamap of same name
  set z {
      ^

v2:
Pablo points out that we shouldn't merge datamaps (plain value) and objref
maps either, catch this too and add another test:

nft --check -f invalid_transcation_merge_map_and_objref_map
invalid_transcation_merge_map_and_objref_map:9:13-13: Error: Cannot merge objmap with existing datamap of same name

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 34 +++++++++++++++++--
 ...pression_type_catch-all_set_element_assert | 18 ++++++++++
 ...valid_transcation_merge_map_and_objref_map | 13 +++++++
 3 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_transcation_merge_map_and_objref_map

diff --git a/src/evaluate.c b/src/evaluate.c
index 783a373b6268..3c091748f786 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5149,6 +5149,29 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
+static const char *set_type_str(const struct set *set)
+{
+	if (set_is_datamap(set->flags))
+		return "datamap";
+
+	if (set_is_objmap(set->flags))
+		return "objmap";
+
+	return "set";
+}
+
+static bool set_type_compatible(const struct set *set, const struct set *existing_set)
+{
+	if (set_is_datamap(set->flags))
+		return set_is_datamap(existing_set->flags);
+
+	if (set_is_objmap(set->flags))
+		return set_is_objmap(existing_set->flags);
+
+	assert(!set_is_map(set->flags));
+	return !set_is_map(existing_set->flags);
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	struct set *existing_set = NULL;
@@ -5272,8 +5295,15 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return 0;
 	}
 
-	if (existing_set && set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
-		return set_error(ctx, set, "existing %s lacks interval flag", type);
+
+	if (existing_set) {
+		if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
+			return set_error(ctx, set,
+					 "existing %s lacks interval flag", type);
+		if (!set_type_compatible(set, existing_set))
+			return set_error(ctx, set, "Cannot merge %s with existing %s of same name",
+					set_type_str(set), set_type_str(existing_set));
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
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_transcation_merge_map_and_objref_map b/tests/shell/testcases/bogons/nft-f/invalid_transcation_merge_map_and_objref_map
new file mode 100644
index 000000000000..e1fde58553e9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_transcation_merge_map_and_objref_map
@@ -0,0 +1,13 @@
+table ip x {
+        counter a { }
+
+	map m {
+		type ipv4_addr : ipv4_addr
+		elements = { 10.0.0.2 : 192.168.0.4 }
+	}
+
+        map m {
+		type ipv4_addr : counter
+                elements = { 192.168.2.2 : "a" }
+        }
+}
-- 
2.49.0

