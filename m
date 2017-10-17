From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH v3] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 15:17:41 +0200
Message-ID: <20171017131741.2026-1-phil@nwl.cc>
References: <20171017121145.GA18793@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40492 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752600AbdJQNRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:17:52 -0400
In-Reply-To: <20171017121145.GA18793@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Implement expression printing into a FILE pointer analogous to
nftnl_rule_fprintf().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Fix src/libnftnl.map update.

Changes since v1:
- Update src/libnftnl.map.
---
 include/libnftnl/expr.h |  1 +
 src/expr.c              | 14 ++++++++++++++
 src/libnftnl.map        |  4 ++++
 3 files changed, 19 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 76f28fee7b5f7..f37f50963d6c3 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -39,6 +39,7 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
 bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
 
 int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
+int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
 enum {
 	NFTNL_EXPR_PAYLOAD_DREG	= NFTNL_EXPR_BASE,
diff --git a/src/expr.c b/src/expr.c
index c5fcf06492ae2..1eae70787209d 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -293,3 +293,17 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 	return offset;
 }
 EXPORT_SYMBOL(nftnl_expr_snprintf);
+
+static int nftnl_expr_do_snprintf(char *buf, size_t size, const void *e,
+				  uint32_t cmd, uint32_t type, uint32_t flags)
+{
+	return nftnl_expr_snprintf(buf, size, e, type, flags);
+}
+
+int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
+		       uint32_t flags)
+{
+	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
+			     nftnl_expr_do_snprintf);
+}
+EXPORT_SYMBOL(nftnl_expr_fprintf);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 1892c983eb504..d59e80269604c 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -307,3 +307,7 @@ global:
 
 local: *;
 };
+
+LIBNFTNL_6 {
+  nftnl_expr_fprintf;
+} LIBNFTNL_5;
-- 
2.13.1

