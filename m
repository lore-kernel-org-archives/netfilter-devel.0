From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/3] segtree: Introduce flag for half-open range elements
Date: Wed, 19 Jul 2017 15:05:27 +0200
Message-ID: <20170719130529.25398-2-phil@nwl.cc>
References: <20170719130529.25398-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49391 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbdGSNFn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 09:05:43 -0400
In-Reply-To: <20170719130529.25398-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This flag is required by userspace only, so can live within userdata.
It's sole purpose is for 'nft monitor' to detect half-open ranges (which
are comprised of a single element only).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Introduce dedicated EXPR_SET_ELEM field 'elem_flags' to hold userdata
  flags.
- Drop now unused function parse_udata_cb().
---
 include/expression.h |  1 +
 include/rule.h       | 16 +++++++++++++++
 src/netlink.c        | 55 ++++++++++++++++++++++++++++++++--------------------
 src/segtree.c        |  5 +++++
 4 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 68a36e8af792a..828dbaee63383 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -256,6 +256,7 @@ struct expr {
 			uint64_t		expiration;
 			const char		*comment;
 			struct stmt		*stmt;
+			uint32_t		elem_flags;
 		};
 		struct {
 			/* EXPR_UNARY */
diff --git a/include/rule.h b/include/rule.h
index ddad6d40470e4..a25e99bdf4cfd 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -506,4 +506,20 @@ enum udata_set_type {
 };
 #define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
 
+enum udata_set_elem_type {
+	UDATA_SET_ELEM_COMMENT,
+	UDATA_SET_ELEM_FLAGS,
+	__UDATA_SET_ELEM_MAX,
+};
+#define UDATA_SET_ELEM_MAX (__UDATA_SET_ELEM_MAX - 1)
+
+/**
+ * enum udata_set_elem_flags - meaning of bits in UDATA_SET_ELEM_FLAGS
+ *
+ * @SET_ELEM_F_INTERVAL_OPEN:	set element denotes a half-open range
+ */
+enum udata_set_elem_flags {
+	SET_ELEM_F_INTERVAL_OPEN	= 0x1,
+};
+
 #endif /* NFTABLES_RULE_H */
diff --git a/src/netlink.c b/src/netlink.c
index e3c90dac8c7a6..159588edd612d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -213,7 +213,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	const struct expr *elem, *key, *data;
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
-	struct nftnl_udata_buf *udbuf;
+	struct nftnl_udata_buf *udbuf = NULL;
 
 	nlse = nftnl_set_elem_alloc();
 	if (nlse == NULL)
@@ -234,13 +234,22 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	if (elem->timeout)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
 				       elem->timeout);
-	if (elem->comment) {
+	if (elem->comment || expr->elem_flags) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
 			memory_allocation_error();
-		if (!nftnl_udata_put_strz(udbuf, UDATA_TYPE_COMMENT,
+	}
+	if (elem->comment) {
+		if (!nftnl_udata_put_strz(udbuf, UDATA_SET_ELEM_COMMENT,
 					  elem->comment))
 			memory_allocation_error();
+	}
+	if (expr->elem_flags) {
+		if (!nftnl_udata_put_u32(udbuf, UDATA_SET_ELEM_FLAGS,
+					 expr->elem_flags))
+			memory_allocation_error();
+	}
+	if (udbuf) {
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_USERDATA,
 				   nftnl_udata_buf_data(udbuf),
 				   nftnl_udata_buf_len(udbuf));
@@ -1586,18 +1595,22 @@ static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
 	return concat;
 }
 
-static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+static int set_elem_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 {
+	const struct nftnl_udata **tb = data;
 	unsigned char *value = nftnl_udata_get(attr);
 	uint8_t type = nftnl_udata_type(attr);
 	uint8_t len = nftnl_udata_len(attr);
-	const struct nftnl_udata **tb = data;
 
 	switch (type) {
-	case UDATA_TYPE_COMMENT:
+	case UDATA_SET_ELEM_COMMENT:
 		if (value[len - 1] != '\0')
 			return -1;
 		break;
+	case UDATA_SET_ELEM_FLAGS:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
 	default:
 		return 0;
 	}
@@ -1605,17 +1618,22 @@ static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
-static char *udata_get_comment(const void *data, uint32_t data_len)
+static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
+				 struct expr *expr)
 {
-	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
-
-	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) < 0)
-		return NULL;
+	const struct nftnl_udata *ud[UDATA_SET_ELEM_MAX + 1] = {};
+	const void *data;
+	uint32_t len;
 
-	if (!tb[UDATA_TYPE_COMMENT])
-		return NULL;
+	data = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_USERDATA, &len);
+	if (nftnl_udata_parse(data, len, set_elem_parse_udata_cb, ud))
+		return;
 
-	return xstrdup(nftnl_udata_get(tb[UDATA_TYPE_COMMENT]));
+	if (ud[UDATA_SET_ELEM_COMMENT])
+		expr->comment =
+			xstrdup(nftnl_udata_get(ud[UDATA_SET_ELEM_COMMENT]));
+	if (ud[UDATA_SET_ELEM_FLAGS])
+		expr->elem_flags = nftnl_udata_get_u32(ud[UDATA_SET_ELEM_FLAGS]);
 }
 
 static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
@@ -1649,13 +1667,8 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPIRATION))
 		expr->expiration = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_EXPIRATION);
-	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_USERDATA)) {
-		const void *data;
-		uint32_t len;
-
-		data = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_USERDATA, &len);
-		expr->comment = udata_get_comment(data, len);
-	}
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_USERDATA))
+		set_elem_parse_udata(nlse, expr);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPR)) {
 		const struct nftnl_expr *nle;
 
diff --git a/src/segtree.c b/src/segtree.c
index f53536210018d..34a001613eaba 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -37,6 +37,7 @@ struct seg_tree {
 
 enum elementary_interval_flags {
 	EI_F_INTERVAL_END	= 0x1,
+	EI_F_INTERVAL_OPEN	= 0x2,
 };
 
 /**
@@ -512,6 +513,8 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 		mpz_bitmask(q, tree->keylen);
 		nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
 		list_add_tail(&nei->list, list);
+	} else {
+		prev->flags |= EI_F_INTERVAL_OPEN;
 	}
 
 	mpz_clear(p);
@@ -538,6 +541,8 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 
 	if (ei->flags & EI_F_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
+	if (ei->flags & EI_F_INTERVAL_OPEN)
+		expr->elem_flags |= SET_ELEM_F_INTERVAL_OPEN;
 
 	compound_expr_add(set, expr);
 }
-- 
2.13.1

