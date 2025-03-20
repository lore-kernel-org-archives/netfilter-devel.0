Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41594322E
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477628; cv=none; b=k7isK7DVaC7uvERkhfng4nTq9y0gcZ1vTDYwOFAtrnihrdhQUfKji45mgBv3VJ09UULn9lXqvcJkAHhhvk+FekT6cWdKw0L8q0s9QFDs0XTE+eobsiRM+YJrK4VZ/W3iKs1bN6Pqj+Uefy1b1OG4ftogL9iSPQ1WjEE51N2HD6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477628; c=relaxed/simple;
	bh=2qGjeFCTHnMGshSU4Qf4jIrfYCfuG7ZAqQxTF15Idps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SjPZuJL83v/cEG1z0QKaY4djTQ7Mo2fbcg2yqTYcEbGA0VR+rSBizttqfoY4bGKsxOY1Jt6+ol5GbRU53MvSE84HYx6HTXlsO678HibRQG4XZb76gOZXc565jfj8Esmj9EDuJNqqMWpZ+HUO4PD9i435d6eQkZxFI6RX5w7kF+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvG1o-0002aP-JO; Thu, 20 Mar 2025 14:33:44 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix assertion failure with malformed map definitions
Date: Thu, 20 Mar 2025 14:33:05 +0100
Message-ID: <20250320133308.31925-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon triggers:
nft: src/evaluate.c:2267: expr_evaluate_mapping: Assertion `set->data != NULL' failed.

After this fix, following errors will be shown:
Error: unqualified type invalid specified in map definition. Try "typeof expression" instead of "type datatype".
map m {
    ^
map m {
    ^
Error: map has no mapping data

Fixes: 343a51702656 ("src: store expr, not dtype to track data in sets")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                              | 5 ++++-
 .../bogons/nft-f/malformed_map_expr_evaluate_mapping_assert | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 5b7a9b863cd5..a22cabb615e9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2323,7 +2323,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 				  "Key must be a constant");
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
-	assert(set->data != NULL);
+	/* This can happen for malformed map definitions */
+	if (!set->data)
+		return set_error(ctx, set, "map has no mapping data");
+
 	if (!set_is_anonymous(set->flags) &&
 	    set->data->flags & EXPR_F_INTERVAL)
 		datalen = set->data->len / 2;
diff --git a/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert b/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert
new file mode 100644
index 000000000000..c77a9c33e0ad
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert
@@ -0,0 +1,6 @@
+table ip x {
+        map m {
+                typeof ct saddr :ct expectation
+                elements = { * : none}
+        }
+}
-- 
2.48.1

