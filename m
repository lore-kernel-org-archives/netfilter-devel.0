Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D34C233151
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765630; cv=none; b=PF0Cr7KDeXA9WJ1qXTAVRRBRHBwQ7IQHIo5yxBV0QFfRbfpLYvdR50zz4FU2bjILn9qYvlY6Jwgj/JuCDCgrA4Kba/QC2/pyIesQ4sWF0wW5t8bRIMWt6DjjPMTHoGx33ivZC3jdzbbDTrrZ2oQ1FMTEep4AfkmNhwv6yfzTU2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765630; c=relaxed/simple;
	bh=+zP3UjAmHUKTkqIhqLcMhAwSnRfhvsauN5615mkUYko=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=H5EribWmO6sPRoHfDI+PiE4tO0Nz3T2wtMXMtsJ4UaVG6mSfDv4PfPiClguhTbXtQ5h6YFu8i6GS6Nw+IaDgJg1jUUQ1Y0vB9+rLRLRqDNu3flSTT2qFGeb1Hd11YIKbFwAZel6fb+5W9cXrDDC+CNZYIgj3hDwICpg2uay6krA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] expression: remove elem_flags from EXPR_SET_ELEM to shrink struct expr size
Date: Mon,  9 Dec 2024 18:33:33 +0100
Message-Id: <20241209173334.512591-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move NFTNL_SET_ELEM_F_INTERVAL_OPEN flag to the existing flags field in
struct expr.

This saves 4 bytes in struct expr, shrinking it to 128 bytes according to
pahole. This reworks:

6089630f54ce ("segtree: Introduce flag for half-open range elements")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
low hanging fruit to shrink struct expr.

 include/expression.h |  2 +-
 src/intervals.c      |  4 ++--
 src/monitor.c        |  2 +-
 src/netlink.c        | 15 ++++++++++-----
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index da2f693e72d3..877887ff1978 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -215,6 +215,7 @@ enum expr_flags {
 	EXPR_F_INTERVAL		= 0x20,
 	EXPR_F_KERNEL		= 0x40,
 	EXPR_F_REMOVE		= 0x80,
+	EXPR_F_INTERVAL_OPEN	= 0x100,
 };
 
 #include <payload.h>
@@ -301,7 +302,6 @@ struct expr {
 			uint64_t		expiration;
 			const char		*comment;
 			struct list_head	stmt_list;
-			uint32_t		elem_flags;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/src/intervals.c b/src/intervals.c
index a93ceedd5a7a..7fd4a576f604 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -740,7 +740,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 			}
 			newelem->flags |= EXPR_F_INTERVAL_END;
 		} else {
-			flags = NFTNL_SET_ELEM_F_INTERVAL_OPEN;
+			flags = EXPR_F_INTERVAL_OPEN;
 		}
 
 		expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
@@ -752,7 +752,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 
 		expr_free(elem->key);
 		elem->key = expr;
-		i->elem_flags |= flags;
+		i->flags |= flags;
 		init->size++;
 		list_move_tail(&i->list, &intervals);
 
diff --git a/src/monitor.c b/src/monitor.c
index a787db8cbf5a..d70bf2957dd3 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -376,7 +376,7 @@ static bool set_elem_is_open_interval(struct expr *elem)
 {
 	switch (elem->etype) {
 	case EXPR_SET_ELEM:
-		return elem->elem_flags & NFTNL_SET_ELEM_F_INTERVAL_OPEN;
+		return elem->flags & EXPR_F_INTERVAL_OPEN;
 	case EXPR_MAPPING:
 		return set_elem_is_open_interval(elem->left);
 	default:
diff --git a/src/netlink.c b/src/netlink.c
index 36140fb63d6f..8e6e2066fe2a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -180,7 +180,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 						netlink_gen_stmt_stateful(stmt));
 		}
 	}
-	if (elem->comment || expr->elem_flags) {
+	if (elem->comment || expr->flags & EXPR_F_INTERVAL_OPEN) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
 			memory_allocation_error();
@@ -190,9 +190,9 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 					  elem->comment))
 			memory_allocation_error();
 	}
-	if (expr->elem_flags) {
+	if (expr->flags & EXPR_F_INTERVAL_OPEN) {
 		if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_ELEM_FLAGS,
-					 expr->elem_flags))
+					 NFTNL_SET_ELEM_F_INTERVAL_OPEN))
 			memory_allocation_error();
 	}
 	if (udbuf) {
@@ -1372,9 +1372,14 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 	if (ud[NFTNL_UDATA_SET_ELEM_COMMENT])
 		expr->comment =
 			xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_ELEM_COMMENT]));
-	if (ud[NFTNL_UDATA_SET_ELEM_FLAGS])
-		expr->elem_flags =
+	if (ud[NFTNL_UDATA_SET_ELEM_FLAGS]) {
+		uint32_t elem_flags;
+
+		elem_flags =
 			nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_ELEM_FLAGS]);
+		if (elem_flags & NFTNL_SET_ELEM_F_INTERVAL_OPEN)
+			expr->flags |= EXPR_F_INTERVAL_OPEN;
+	}
 }
 
 int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-- 
2.30.2

