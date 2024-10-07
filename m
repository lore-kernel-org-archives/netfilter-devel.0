Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC01E519
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296633; cv=none; b=nBf2OC8JvWkDq9cHQ2nSMkRmlgUHWD6W9Y5HKBeGAxRtZGGgyQxgQjLyAc4hQMXq/v1CJ0AbZs9KeZRQeUeMNg9M1gMwpKK+WXHiB2PryEaMhheDADc+iGYgSQ7y6tvSZ6ucAl1vsl6VWgsJ8oycIjbFpiZ0FwCoklyazge/1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296633; c=relaxed/simple;
	bh=k6I91jaItLlNfp7reVKGB3r+48CeMypGc48SY4IDncs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk5gaAOoYJOZzSWl9wzKapB9pPGjKWd/QQa7oBnxzxrGuoBxU1+UiUziemDuxJIO4OZx/bYddW02bWY3Ae5+ESQYKNT1cVxiQplFVBDj3MRi7+a50gqfEBjE0tQqeIQdM2V683+/Rx4QxgcuxYPwpmFJObs3D6lcVOW34Z7p99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxku5-0006fc-4i; Mon, 07 Oct 2024 12:23:49 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 3/5] libnftnl: add api to query dissection state
Date: Mon,  7 Oct 2024 11:49:36 +0200
Message-ID: <20241007094943.7544-4-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to check if the set / expression was decoded as-expected.

These two functions return false in case libnftl had to ignore
new attributes that it did not expect.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h | 2 ++
 include/libnftnl/set.h  | 1 +
 src/expr.c              | 6 ++++++
 src/libnftnl.map        | 5 +++++
 src/rule.c              | 5 +++++
 src/set.c               | 6 ++++++
 6 files changed, 25 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index fba121062244..d938475394ec 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -47,6 +47,8 @@ int nftnl_expr_expr_foreach(const struct nftnl_expr *e,
 int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
+bool nftnl_expr_complete(const struct nftnl_expr *expr);
+
 enum {
 	NFTNL_EXPR_PAYLOAD_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_PAYLOAD_BASE,
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index e2e5795aa9b4..2e624c3e7e66 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -171,6 +171,7 @@ void nftnl_set_elems_iter_destroy(struct nftnl_set_elems_iter *iter);
 int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 					   struct nftnl_set_elems_iter *iter);
 
+bool nftnl_set_complete(const struct nftnl_set *set);
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/expr.c b/src/expr.c
index 4e32189c6e8d..99078dcd058e 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -311,3 +311,9 @@ int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
 	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
 			     nftnl_expr_do_snprintf);
 }
+
+EXPORT_SYMBOL(nftnl_expr_complete);
+bool nftnl_expr_complete(const struct nftnl_expr *expr)
+{
+	return !expr->incomplete;
+}
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8fffff19eb2e..90eb4a92fca4 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -383,3 +383,8 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_set_complete;
+  nftnl_expr_complete;
+} LIBNFTNL_17;
diff --git a/src/rule.c b/src/rule.c
index c22918a8f352..aa969ad5f876 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -582,6 +582,11 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 					     type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+		if (!nftnl_expr_complete(expr)) {
+			ret = snprintf(buf + offset, remain, "[incomplete]");
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
+
 		ret = snprintf(buf + offset, remain, "]");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
diff --git a/src/set.c b/src/set.c
index 75ad64e03850..40f5e1a955fd 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1051,3 +1051,9 @@ int nftnl_set_lookup_id(struct nftnl_expr *e,
 	*set_id = nftnl_set_get_u32(s, NFTNL_SET_ID);
 	return 1;
 }
+
+EXPORT_SYMBOL(nftnl_set_complete);
+bool nftnl_set_complete(const struct nftnl_set *set)
+{
+	return !set->incomplete;
+}
-- 
2.45.2

