Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206631F5F6
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742557666; cv=none; b=dPlxb3nFf8M4thQ1EV+mfBMT6Hoc4BA2iGHM/X1cHuNgeSUaEnw6rh2FezjICDP0j2WnBVrxZrS9/u1JuNuLh3iaRact30DRkmUtyExerMWi8Z7eNptDyexoiWd13n797oZYu4dC9L0PFTfALsnCbWuxz4evmwMQpLcH0M2Fggg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742557666; c=relaxed/simple;
	bh=2ycgP/LmC0CU8NItUzop6lw8L8dE8LH8h4eODwhlZyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B+NcWsjSeN3WP9OTSS27S3TdfLtL7lyCnvhLcnwcBvNTWLLRrf4kR8L9QQiJkp1OD43mZcvP4PyhDhg1hkw/0oZFwrpEUEdu6VtdoR5uB565XFNlMdIybHlLS82qOhgHB86Iucj7tYP9x41lOh+4sEtUM1xm+VmuOxSccXmOtrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvaqe-0003yc-8v; Fri, 21 Mar 2025 12:47:36 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't update cache for anonymous chains
Date: Fri, 21 Mar 2025 12:46:38 +0100
Message-ID: <20250321114641.9510-1-fw@strlen.de>
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

Error: No such file or directory chain c {
Error: No symbol type information a b index 1 10.1.26.a

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                            | 3 +++
 .../bogons/nft-f/null_deref_on_anon_chain_update_crash    | 8 ++++++++
 2 files changed, 11 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index a27961193da5..09df7f158acc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5371,6 +5371,9 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	if (!table)
 		return table_not_found(ctx);
 
+	if (!rule->handle.chain.name)
+		return chain_not_found(ctx);
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

