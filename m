Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C468264614
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741858753; cv=none; b=rLKDl84azIPEmEPXIxQe9aDpqOnPdqTidGkwnymJ4oo1R7MMH9n1jy2u6zvSto9ouGDG9OgT1pKTTJKitgqzRgMN7wJWqHpeI4NJvC0D95RaTRN9oTGQcgfvuZeOzg+05CMHRpa7y/SynhrYJDsBmAqNP2+fhMnJZdA2oLmmncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741858753; c=relaxed/simple;
	bh=809aD9/HuoVkn3c1rnTeupN7OZFbRO+VHUi1lA1BiAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F15nlx3u6L+lnQaNnJJeyhKKSz6YoBmN/A/MIge3CbkDEpD5JQD5HB5BuFANwmWvxhWCQubvDunmoVqBgr/5zF2uNLksl9N6xPFqrX3PNDDNuNreVa3tWTXuUWjnoGhBKvvJGgm/Gm4/10etp70W1KhATH5R+wiM7dOuTWRH7BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tsf1x-0000Tx-6k; Thu, 13 Mar 2025 10:39:09 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't allow merging interval set/map with non-interval one
Date: Thu, 13 Mar 2025 10:38:25 +0100
Message-ID: <20250313093828.736-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon asserts with:
BUG: invalid data expression type range_value

Pablo says: "Reject because flags interval is lacking".
Make it so.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                 | 18 +++++++++++-------
 .../invalid_data_expr_type_range_value_assert  | 12 ++++++++++++
 2 files changed, 23 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 7fc210fd3b12..d59993dcdd4e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5080,15 +5080,19 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return table_not_found(ctx);
 
 		existing_set = set_cache_find(table, set->handle.set.name);
-		if (!existing_set)
-			set_cache_add(set_get(set), table);
+		if (existing_set) {
+			if (existing_set->flags & NFT_SET_EVAL) {
+				uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
+				uint32_t new_flags = set->flags & ~NFT_SET_EVAL;
 
-		if (existing_set && existing_set->flags & NFT_SET_EVAL) {
-			uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
-			uint32_t new_flags = set->flags & ~NFT_SET_EVAL;
+				if (existing_flags == new_flags)
+					set->flags |= NFT_SET_EVAL;
+			}
 
-			if (existing_flags == new_flags)
-				set->flags |= NFT_SET_EVAL;
+			if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
+				return set_error(ctx, set, "existing %s lacks interval flag", type);
+		} else {
+			set_cache_add(set_get(set), table);
 		}
 	}
 
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert
new file mode 100644
index 000000000000..4637a4f9b9df
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert
@@ -0,0 +1,12 @@
+table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		elements = { 1.168.0.4 }
+	}
+
+        map y {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { 10.141.3.0/24 : 192.8.0.3 }
+	}
+}
-- 
2.45.3

