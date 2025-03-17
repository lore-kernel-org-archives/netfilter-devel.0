Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083C627701
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2025 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742212647; cv=none; b=mDGGidKg79EpAkaw/M3tX14V2denpVq3iNfY3a3I17Xvsshs/rkQhwNixGluX3h2vQzkCb/3Wqaduf9T2owr30yAEVhOoqTw2BENaZ5aKgG9jow+o3015eYeo7+9io2S+GPpRPVu0deJoA2+dUWYrOu941Dli/bYtrKU6HozA9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742212647; c=relaxed/simple;
	bh=FHq8vXmcpasy8RhYdtOciCjltExwEKtL/3cvwEY/FV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ucyAGw+TRkPGSUWI5ll+0/ZuVYgQqLH7ZFBDCLqg5NU13llFcRSD9UzN2ZgawyvnZjXjgJYqJL4tkf4XEb2CA0ufZxqV5jtRL70Kr2OYYfdzPzmD5I7xog5RGkFnyNZa+3MAtYpd/INqNAJioYgK3dhIBr0yYqYH7ggGBPgpupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tu95p-0000uD-2d; Mon, 17 Mar 2025 12:57:17 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: move interval flag compat check after set key evaluation
Date: Mon, 17 Mar 2025 12:56:36 +0100
Message-ID: <20250317115639.19393-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without this, included bogon asserts with:
BUG: unhandled key type 13
nft: src/intervals.c:73: setelem_expr_to_range: Assertion `0' failed.

... because we no longer evaluate set->key/data.

Move the check to the tail of the function, right before assiging
set->existing_set, so that set->key has been evaluated.

Fixes: ceab53cee499 ("evaluate: don't allow merging interval set/map with non-interval one")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                      |  6 +++---
 .../invalid_data_expr_type_range_value_2_assert     | 13 +++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index d59993dcdd4e..f1f7ddaab991 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5088,9 +5088,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 				if (existing_flags == new_flags)
 					set->flags |= NFT_SET_EVAL;
 			}
-
-			if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
-				return set_error(ctx, set, "existing %s lacks interval flag", type);
 		} else {
 			set_cache_add(set_get(set), table);
 		}
@@ -5181,6 +5178,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return 0;
 	}
 
+	if (existing_set && set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
+		return set_error(ctx, set, "existing %s lacks interval flag", type);
+
 	set->existing_set = existing_set;
 
 	return 0;
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert
new file mode 100644
index 000000000000..56f541a61e45
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert
@@ -0,0 +1,13 @@
+table inet t {
+        map m2 {
+                typeof udp length . @ih,32,32 : verdict
+                elements = {
+                             1-10 . 0xa : drop }
+        }
+
+	map m2 {
+                typeof udp length . @ih,32,32 : verdict
+                flags interval
+                elements = { 20-80 . 0x14 : accept }
+        }
+}
-- 
2.48.1

