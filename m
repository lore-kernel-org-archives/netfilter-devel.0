Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3905F20297E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741267752; cv=none; b=CPdYQI9QGikeAATg/WqmKldaPNKYO8hcrRjJWqaom32+F1OL6l/oUFjd2tTFvMDQWz5FDnQ3rg+URmt2yf1GjX7EoxMGRK2NRZZxEKuNjMBRmiLuteh7qvJ8uNv/cdwImCsq8Dh7IW6T78kjtheNSR6NhukYkJVgVTqoLXggo9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741267752; c=relaxed/simple;
	bh=c7yTYFTxdaghwCg1/l7qP34j1jjxurf6uY+7ClKF1Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFk0vMZmaazJZ9Axanh/+5pQcrzMT3myuWb4VfT2JkVjk4S/UWkOquYKBranBKEU1VsZfuENnp6CbU8nFotXwzB8yrH7sS+D+Vvp3ZvyxCzaGKTEqe1+ROhgPlNsgJoROdyJlmaWQtYvwY0IqPc6z0kYy5MLetsQFz0Fi6XVwTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tqBHf-00045J-Um; Thu, 06 Mar 2025 14:29:07 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] src: fix reset element support for rbree set type
Date: Thu,  6 Mar 2025 14:23:30 +0100
Message-ID: <20250306132336.17675-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running reset command yields on an interval (rbtree) set yields:
nft reset element inet filter rbtreeset {1.2.3.4}
BUG: unhandled op 8

This is easy to fix, CMD_RESET doesn't add or remove so it should be
treated like CMD_GET.

Unfortunately, this still doesn't work properly:

nft get element inet filter rbset {1.2.3.4}
returns:
 ... elements = { 1.2.3.4 }

but its expected that "get" and "reset" also return stateful objects
associated with the element.  This works for other set types, but for
rbtree, the list of statements gets lost during segtree processing.

After fix, get/reset returns:
  elements = { 1.2.3.4 counter packets 10 ...

Next patch will add a test case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c |  1 +
 src/segtree.c  | 31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 25c07d90695b..1be09cb23a5d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1946,6 +1946,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 				 ctx->nft->debug_mask);
 		break;
 	case CMD_GET:
+	case CMD_RESET:
 		break;
 	default:
 		BUG("unhandled op %d\n", ctx->cmd->op);
diff --git a/src/segtree.c b/src/segtree.c
index 11cf27c55dcb..0fde39df7940 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -206,6 +206,22 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	return __expr_to_set_elem(e, expr);
 }
 
+static void set_compound_expr_add(struct expr *compound, struct expr *expr, struct expr *orig)
+{
+	struct expr *elem;
+
+	if (expr->etype == EXPR_SET_ELEM) {
+		list_splice_init(&orig->stmt_list, &expr->stmt_list);
+		compound_expr_add(compound, expr);
+		return;
+	}
+
+	elem = set_elem_expr_alloc(&orig->location, expr);
+
+	list_splice_init(&orig->stmt_list, &elem->stmt_list);
+	compound_expr_add(compound, elem);
+}
+
 int get_set_decompose(struct set *cache_set, struct set *set)
 {
 	struct expr *i, *next, *range;
@@ -227,20 +243,23 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 				errno = ENOENT;
 				return -1;
 			}
+
+			set_compound_expr_add(new_init, range, left);
+
 			expr_free(left);
 			expr_free(i);
 
-			compound_expr_add(new_init, range);
 			left = NULL;
 		} else {
 			if (left) {
 				range = get_set_interval_find(cache_set,
 							      left, NULL);
+
 				if (range)
-					compound_expr_add(new_init, range);
+					set_compound_expr_add(new_init, range, left);
 				else
-					compound_expr_add(new_init,
-							  expr_to_set_elem(left));
+					set_compound_expr_add(new_init,
+							      expr_to_set_elem(left), left);
 			}
 			left = i;
 		}
@@ -248,9 +267,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	if (left) {
 		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
-			compound_expr_add(new_init, range);
+			set_compound_expr_add(new_init, range, left);
 		else
-			compound_expr_add(new_init, expr_to_set_elem(left));
+			set_compound_expr_add(new_init, expr_to_set_elem(left), left);
 	}
 
 	expr_free(set->init);
-- 
2.45.3

