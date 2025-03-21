Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DCBA34
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567469; cv=none; b=kAJLrAw0cHvMBG8sTyKE2bl4zjSLZZtMwdexEA2exp227MT+7Jum6I7oE5E8qsJVHyFJaNZQl8AQjKHB4EA5zd2MJXiWA/ULpcUyXafgK/rvyU+ugP1XHd+8QPgFWTDkSM3W1Crzy9oL8CA+UG0zXm0bYY3YSw0qPDWDTl8wEx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567469; c=relaxed/simple;
	bh=JzwBahzxnEgKqSxG48ChLUQ4rdPqP0+iQZsZRmKLWxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kde14iWhhxuuGW/lO+kM4E2iQBmqUR8EO9zqFgcfKoiDlKcegKivbW6hzDMOsOuYJSCFdmJgOZNve1NiOP/Nt8UcFi4iKwbohZ3PXxx3b+XdvzRpN82pSKNKot5GU+aZwSK1MNeRBM8vvDcgs5cFc/XrNGMwdvJ+jmJo4j2Vo1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvdOr-0005It-91; Fri, 21 Mar 2025 15:31:05 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] evaluate: don't update cache for anonymous chains
Date: Fri, 21 Mar 2025 15:30:05 +0100
Message-ID: <20250321143008.7980-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Chain lookup needs a name, not a numerical id.
After patch, loading bogon gives following errors:

Error: No symbol type information a b index 1 10.1.26.a

v2: Don't return an error, just make it a no-op (Pablo Neira Ayuso)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                            | 7 +++++++
 .../bogons/nft-f/null_deref_on_anon_chain_update_crash    | 8 ++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index a27961193da5..26aa0ef53241 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5371,6 +5371,13 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	if (!table)
 		return table_not_found(ctx);
 
+	/* chain is anonymous: no update needed, rules cannot be added
+	 * or removed from anon chains after the chain was committed to
+	 * kernel.
+	 */
+	if (!rule->handle.chain.name)
+		return 0;
+
 	chain = chain_cache_find(table, rule->handle.chain.name);
 	if (!chain)
 		return chain_not_found(ctx);
diff --git a/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash b/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
new file mode 100644
index 000000000000..310486c59ee0
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
@@ -0,0 +1,8 @@
+table ip f {
+        chain c {
+                jump {
+                        accept
+                }
+        }
+}
+a b index 1 10.1.26.a
-- 
2.48.1

