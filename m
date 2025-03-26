Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B121A08BC
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743020613; cv=none; b=HVT7qLE2arK8JNr9uMkDoV61yuUN8qOxARmrKhYqmrcgKZRpNe+WScUDLDnxL1hA8Vh/V5Ejcz23HIid9giFLUF5OQZ3NJgbXyWsi97m0mLZZgJyFPM7fSYSLf2aKM2nn8PkA2e7LyJXs5YvvkJmX2ZXXD4dmOpvmgoNIG/LS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743020613; c=relaxed/simple;
	bh=TEAvcYHijMGL7jxCW1CfQKRPZnlA87Pn9oztErFpzSA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tXfL0Npn9c8h4aN1OJS55iUgspwfR4xcNCkJ93zBFLe8jYhJM8Ju6yhwhpLE0KtNnxmEmUBKdiWmAplj59S5z25c15tGyiR18w3WotbKuYDyzfz5nCMatyPD8rBLIiEJYAn1sFqqw+Xf2AAQW/1OPhG8X4ZaViNFp3ExOIWWpiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WfOTmHQf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WfOTmHQf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WfOTmHQf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WfOTmHQf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6D6D0607C9; Wed, 26 Mar 2025 21:23:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020602;
	bh=VorUdMlzHdifVtz71H08znVGfnjxFZvaT4gfEpr69mE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WfOTmHQfG5SdKm1hQ4ZMAcGHFNXVdg1YsVNwLxJgNq4RMyvApxfYmUtPRkrRLj/gW
	 wtN1fw7C+HYAhNYy8iKoPuHSnQsXPjm3b+6cVXLf7D09idQHWxe88lse1RQuqDAm9J
	 yOlxW47nZY8n+Qcu/YxeOYCeEIDHiUh8pe+nOhT//yVoyZxg7iAxeT4SJCiWntv+ic
	 0bmE7Y9nbrK+92AjtdhgBrThJTex/Iok2OcMcXkl0/aCYPO1loJ5t39nV+64ACfp3f
	 f3S02LxCqpGw+uRkSXYZm+tazXV7oZJXoUS/Mqw+CbqFqGcERR7k0EzP0zeiL7xbMs
	 yjUGpmzpfVV3Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5BA5606B5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:23:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020602;
	bh=VorUdMlzHdifVtz71H08znVGfnjxFZvaT4gfEpr69mE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WfOTmHQfG5SdKm1hQ4ZMAcGHFNXVdg1YsVNwLxJgNq4RMyvApxfYmUtPRkrRLj/gW
	 wtN1fw7C+HYAhNYy8iKoPuHSnQsXPjm3b+6cVXLf7D09idQHWxe88lse1RQuqDAm9J
	 yOlxW47nZY8n+Qcu/YxeOYCeEIDHiUh8pe+nOhT//yVoyZxg7iAxeT4SJCiWntv+ic
	 0bmE7Y9nbrK+92AjtdhgBrThJTex/Iok2OcMcXkl0/aCYPO1loJ5t39nV+64ACfp3f
	 f3S02LxCqpGw+uRkSXYZm+tazXV7oZJXoUS/Mqw+CbqFqGcERR7k0EzP0zeiL7xbMs
	 yjUGpmzpfVV3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] optimize: compact bitmask matching in set/map
Date: Wed, 26 Mar 2025 21:23:01 +0100
Message-Id: <20250326202303.20396-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250326202303.20396-1-pablo@netfilter.org>
References: <20250326202303.20396-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if right hand side of relational is a bitmask, ie.

     relational
       /   \
    ...     or
           /  \
       value   or
              /  \
         value    value

then, if left hand side is a binop expression, compare left and right
hand sides (not only left hand of this binop expression) to check for
redundant matches in consecutive rules, ie.

        relational
          /   \
       and     ...
      /   \
 payload  value

before this patch, only payload in the binop expression was compared.

This allows to compact several rules matching tcp flags in a set/map, eg.

 # nft -c -o -f ruleset.nft
 Merging:
 ruleset.nft:7:17-76:                 tcp flags & (fin | syn | rst | ack | urg) == fin | ack | urg
 ruleset.nft:8:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == fin | ack
 ruleset.nft:9:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == fin
 ruleset.nft:10:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == syn | ack
 ruleset.nft:11:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == syn
 ruleset.nft:12:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == rst | ack
 ruleset.nft:13:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == rst
 ruleset.nft:14:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == ack | urg
 ruleset.nft:15:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == ack
 into:
        tcp flags & (fin | syn | rst | ack | urg) == { fin | ack | urg, fin | ack, fin, syn | ack, syn, rst | ack, rst, ack | urg, ack }
 Merging:
 ruleset.nft:17:17-61:                 tcp flags & (ack | urg) == ack jump ack_chain
 ruleset.bft:18:17-61:                 tcp flags & (ack | urg) == urg jump urg_chain
 into:
        tcp flags & (ack | urg) vmap { ack : jump ack_chain, urg : jump urg_chain }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 35 ++++++++++++++++++-
 tests/shell/testcases/optimizations/bitmask   | 26 ++++++++++++++
 .../testcases/optimizations/dumps/bitmask.nft | 14 ++++++++
 3 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/optimizations/bitmask
 create mode 100644 tests/shell/testcases/optimizations/dumps/bitmask.nft

diff --git a/src/optimize.c b/src/optimize.c
index bb849267d8d9..44010f2bb377 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -127,7 +127,17 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 			return false;
 		break;
 	case EXPR_BINOP:
-		return __expr_cmp(expr_a->left, expr_b->left);
+		if (!__expr_cmp(expr_a->left, expr_b->left))
+			return false;
+
+		return __expr_cmp(expr_a->right, expr_b->right);
+	case EXPR_SYMBOL:
+		if (expr_a->symtype != expr_b->symtype)
+			return false;
+		if (expr_a->symtype != SYMBOL_VALUE)
+			return false;
+
+		return !strcmp(expr_a->identifier, expr_b->identifier);
 	default:
 		return false;
 	}
@@ -135,6 +145,25 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 	return true;
 }
 
+static bool is_bitmask(const struct expr *expr)
+{
+	switch (expr->etype) {
+	case EXPR_BINOP:
+		if (expr->op == OP_OR &&
+		    !is_bitmask(expr->left))
+			return false;
+
+		return is_bitmask(expr->right);
+	case EXPR_VALUE:
+	case EXPR_SYMBOL:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static bool stmt_expr_supported(const struct expr *expr)
 {
 	switch (expr->right->etype) {
@@ -146,6 +175,10 @@ static bool stmt_expr_supported(const struct expr *expr)
 	case EXPR_LIST:
 	case EXPR_VALUE:
 		return true;
+	case EXPR_BINOP:
+		if (is_bitmask(expr->right))
+			return true;
+		break;
 	default:
 		break;
 	}
diff --git a/tests/shell/testcases/optimizations/bitmask b/tests/shell/testcases/optimizations/bitmask
new file mode 100755
index 000000000000..064d95604061
--- /dev/null
+++ b/tests/shell/testcases/optimizations/bitmask
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+set -e
+
+RULESET='table inet t {
+	chain ack_chain {}
+	chain urg_chain {}
+
+        chain c {
+                tcp flags & (syn | rst | ack | urg) == ack | urg
+                tcp flags & (fin | syn | rst | ack | urg) == fin | ack | urg
+                tcp flags & (fin | syn | rst | ack | urg) == fin | ack
+                tcp flags & (fin | syn | rst | ack | urg) == fin
+                tcp flags & (fin | syn | rst | ack | urg) == syn | ack
+                tcp flags & (fin | syn | rst | ack | urg) == syn
+                tcp flags & (fin | syn | rst | ack | urg) == rst | ack
+                tcp flags & (fin | syn | rst | ack | urg) == rst
+                tcp flags & (fin | syn | rst | ack | urg) == ack | urg
+                tcp flags & (fin | syn | rst | ack | urg) == ack
+                tcp flags & (rst | ack | urg) == rst | ack
+                tcp flags & (ack | urg) == ack jump ack_chain
+                tcp flags & (ack | urg) == urg jump urg_chain
+        }
+}'
+
+$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/optimizations/dumps/bitmask.nft b/tests/shell/testcases/optimizations/dumps/bitmask.nft
new file mode 100644
index 000000000000..758b32a374e2
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/bitmask.nft
@@ -0,0 +1,14 @@
+table inet t {
+	chain ack_chain {
+	}
+
+	chain urg_chain {
+	}
+
+	chain c {
+		tcp flags & (syn | rst | ack | urg) == ack | urg
+		tcp flags & (fin | syn | rst | ack | urg) == { fin | ack | urg, fin | ack, fin, syn | ack, syn, rst | ack, rst, ack | urg, ack }
+		tcp flags & (rst | ack | urg) == rst | ack
+		tcp flags & (ack | urg) vmap { ack : jump ack_chain, urg : jump urg_chain }
+	}
+}
-- 
2.30.2

