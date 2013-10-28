From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] src: add fprintf API functions
Date: Mon, 28 Oct 2013 11:57:52 +0100
Message-ID: <20131028105752.32691.40691.stgit@nfdev.cica.es>
References: <20131028105747.32691.93153.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34296 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754529Ab3J1K6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:58:03 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B258651ECCB
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 10:58:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGLzFMpuDKo7 for <netfilter-devel@vger.kernel.org>;
	Mon, 28 Oct 2013 11:57:56 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id DE58651ED51
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 11:57:55 +0100 (CET)
In-Reply-To: <20131028105747.32691.93153.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now it's possible to print directly from libnftables to a file or other stream.
In order to don't force any format, the caller must print any trailing '\n'.

The error reporting of fprintf (< 0) is respected.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftables/chain.h   |    1 
 include/libnftables/rule.h    |    1 
 include/libnftables/ruleset.h |    1 
 include/libnftables/set.h     |    2 
 include/libnftables/table.h   |    1 
 src/chain.c                   |   13 +++
 src/internal.h                |    4 +
 src/libnftables.map           |    6 +
 src/rule.c                    |   13 +++
 src/ruleset.c                 |  203 +++++++++++++++++++++++++++++++++++++++++
 src/set.c                     |   13 +++
 src/set_elem.c                |   13 +++
 src/table.c                   |   13 +++
 src/utils.c                   |   27 +++++
 14 files changed, 311 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index d85a2a2..4ca0105 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -60,6 +60,7 @@ enum nft_chain_parse_type {
 
 int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type, const char *data);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
+int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *t);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index a501d2d..5fb70d3 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -58,6 +58,7 @@ enum nft_rule_parse_type {
 
 int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, const char *data);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
+int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *t);
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index a4a1279..980276d 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -37,6 +37,7 @@ enum nft_ruleset_parse_type {
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse_type type, const char *data);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 14a6327..2e22a82 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -38,6 +38,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 
 int nft_set_snprintf(char *buf, size_t size, struct nft_set *s, uint32_t type, uint32_t flags);
+int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type, uint32_t flags);
 
 struct nft_set_list;
 
@@ -108,6 +109,7 @@ int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s)
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type type, const char *data);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
+int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
 
 int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 42a4aa7..ec3a769 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -48,6 +48,7 @@ enum nft_table_parse_type {
 
 int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type, const char *data);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
+int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t);
diff --git a/src/chain.c b/src/chain.c
index 6179f68..cdb398f 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -851,6 +851,19 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 }
 EXPORT_SYMBOL(nft_chain_snprintf);
 
+static inline int nft_chain_do_snprintf(char *buf, size_t size, void *c,
+					uint32_t type, uint32_t flags)
+{
+	return nft_chain_snprintf(buf, size, c, type, flags);
+}
+
+int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type,
+		      uint32_t flags)
+{
+	return nft_fprintf(fp, c, type, flags, nft_chain_do_snprintf);
+}
+EXPORT_SYMBOL(nft_chain_fprintf);
+
 struct nft_chain_list {
 	struct list_head list;
 };
diff --git a/src/internal.h b/src/internal.h
index b29288a..6449a9f 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -17,6 +17,8 @@
 #define BASE_DEC 10
 #define BASE_HEX 16
 
+#define NFT_SNPRINTF_BUFSIZ 4096
+
 enum nft_type {
 	NFT_TYPE_U8,
 	NFT_TYPE_U16,
@@ -88,6 +90,8 @@ const char *nft_verdict2str(uint32_t verdict);
 int nft_str2verdict(const char *verdict);
 int nft_get_value(enum nft_type type, void *val, void *out);
 
+int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+
 void xfree(const void *ptr);
 
 struct expr_ops;
diff --git a/src/libnftables.map b/src/libnftables.map
index 1223403..aa47714 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -12,6 +12,7 @@ global:
   nft_table_attr_get_str;
   nft_table_parse;
   nft_table_snprintf;
+  nft_table_fprintf;
   nft_table_nlmsg_build_hdr;
   nft_table_nlmsg_build_payload;
   nft_table_nlmsg_parse;
@@ -42,6 +43,7 @@ global:
   nft_chain_attr_get_str;
   nft_chain_parse;
   nft_chain_snprintf;
+  nft_chain_fprintf;
   nft_chain_nlmsg_build_hdr;
   nft_chain_nlmsg_build_payload;
   nft_chain_nlmsg_parse;
@@ -71,6 +73,7 @@ global:
   nft_rule_attr_get_str;
   nft_rule_parse;
   nft_rule_snprintf;
+  nft_rule_fprintf;
   nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
   nft_rule_nlmsg_parse;
@@ -126,6 +129,7 @@ global:
   nft_set_nlmsg_parse;
   nft_set_parse;
   nft_set_snprintf;
+  nft_set_fprintf;
 
   nft_set_list_alloc;
   nft_set_list_free;
@@ -157,6 +161,7 @@ global:
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
   nft_set_elem_snprintf;
+  nft_set_elem_fprinf;
 
   nft_set_elems_nlmsg_build_payload;
   nft_set_elems_nlmsg_parse;
@@ -176,6 +181,7 @@ global:
   nft_ruleset_attr_get;
   nft_ruleset_parse;
   nft_ruleset_snprintf;
+  nft_ruleset_fprintf;
 
 local: *;
 };
diff --git a/src/rule.c b/src/rule.c
index d135f38..3b45dc7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -819,6 +819,19 @@ int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
 }
 EXPORT_SYMBOL(nft_rule_snprintf);
 
+static inline int nft_rule_do_snprintf(char *buf, size_t size, void *r,
+				       uint32_t type, uint32_t flags)
+{
+	return nft_rule_snprintf(buf, size, r, type, flags);
+}
+
+int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type,
+		     uint32_t flags)
+{
+	return nft_fprintf(fp, r, type, flags, nft_rule_do_snprintf);
+}
+EXPORT_SYMBOL(nft_rule_fprintf);
+
 int nft_rule_expr_foreach(struct nft_rule *r,
                           int (*cb)(struct nft_rule_expr *e, void *data),
                           void *data)
diff --git a/src/ruleset.c b/src/ruleset.c
index 24b849b..ee2c60a 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -813,3 +813,206 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 	}
 }
 EXPORT_SYMBOL(nft_ruleset_snprintf);
+
+static int nft_ruleset_fprintf_tables(FILE *fp, const struct nft_ruleset *rs,
+				      uint32_t type, uint32_t flags)
+{
+	int len = 0, ret = 0;
+	struct nft_table *t;
+	struct nft_table_list_iter *ti;
+
+	ti = nft_table_list_iter_create(rs->table_list);
+	if (ti == NULL)
+		return -1;
+
+	t = nft_table_list_iter_next(ti);
+	while (t != NULL) {
+		ret = nft_table_fprintf(fp, t, type, flags);
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+
+		t = nft_table_list_iter_next(ti);
+
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(t, type));
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+	}
+	nft_table_list_iter_destroy(ti);
+
+	return len;
+err:
+	nft_table_list_iter_destroy(ti);
+	return -1;
+}
+
+static int nft_ruleset_fprintf_chains(FILE *fp, const struct nft_ruleset *rs,
+				      uint32_t type, uint32_t flags)
+{
+	int len = 0, ret = 0;
+	struct nft_chain *o;
+	struct nft_chain_list_iter *i;
+
+	i = nft_chain_list_iter_create(rs->chain_list);
+	if (i == NULL)
+		return -1;
+
+	o = nft_chain_list_iter_next(i);
+	while (o != NULL) {
+		ret = nft_chain_fprintf(fp, o, type, flags);
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+
+		o = nft_chain_list_iter_next(i);
+
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(o, type));
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+	}
+	nft_chain_list_iter_destroy(i);
+
+	return len;
+err:
+	nft_chain_list_iter_destroy(i);
+	return -1;
+}
+
+static int nft_ruleset_fprintf_sets(FILE *fp, const struct nft_ruleset *rs,
+				    uint32_t type, uint32_t flags)
+{
+	int len = 0, ret = 0;
+	struct nft_set *o;
+	struct nft_set_list_iter *i;
+
+	i = nft_set_list_iter_create(rs->set_list);
+	if (i == NULL)
+		return -1;
+
+	o = nft_set_list_iter_next(i);
+	while (o != NULL) {
+		ret = nft_set_fprintf(fp, o, type, flags);
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+
+		o = nft_set_list_iter_next(i);
+
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(o, type));
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+	}
+	nft_set_list_iter_destroy(i);
+
+	return len;
+err:
+	nft_set_list_iter_destroy(i);
+	return -1;
+}
+
+static int nft_ruleset_fprintf_rules(FILE *fp, const struct nft_ruleset *rs,
+				    uint32_t type, uint32_t flags)
+{
+	int len = 0, ret = 0;
+	struct nft_rule *o;
+	struct nft_rule_list_iter *i;
+
+	i = nft_rule_list_iter_create(rs->rule_list);
+	if (i == NULL)
+		return -1;
+
+	o = nft_rule_list_iter_next(i);
+	while (o != NULL) {
+		ret = nft_rule_fprintf(fp, o, type, flags);
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+
+		o = nft_rule_list_iter_next(i);
+
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(o, type));
+		if (ret < 0)
+			goto err;
+
+		len += ret;
+	}
+	nft_rule_list_iter_destroy(i);
+
+	return len;
+err:
+	nft_rule_list_iter_destroy(i);
+	return -1;
+}
+
+#define NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len)	\
+	if (ret < 0)				\
+		return -1;			\
+	len += ret;
+
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
+			uint32_t flags)
+{
+	int len = 0, ret = 0;
+	void *prev = NULL;
+
+	ret = fprintf(fp, "%s", nft_ruleset_o_opentag(type));
+	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
+	    (!nft_table_list_is_empty(rs->table_list))) {
+		ret = nft_ruleset_fprintf_tables(fp, rs, type, flags);
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		if (ret > 0)
+			prev = rs->table_list;
+	}
+
+	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) &&
+	    (!nft_chain_list_is_empty(rs->chain_list))) {
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		ret = nft_ruleset_fprintf_chains(fp, rs, type, flags);
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		if (ret > 0)
+			prev = rs->chain_list;
+	}
+
+	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) &&
+	    (!nft_set_list_is_empty(rs->set_list))) {
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		ret = nft_ruleset_fprintf_sets(fp, rs, type, flags);
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		if (ret > 0)
+			prev = rs->set_list;
+	}
+
+	if ((nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)) &&
+	    (!nft_rule_list_is_empty(rs->rule_list))) {
+		ret = fprintf(fp, "%s", nft_ruleset_o_separator(prev, type));
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+		ret = nft_ruleset_fprintf_rules(fp, rs, type, flags);
+		NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+	}
+
+	ret = fprintf(fp, "%s", nft_ruleset_o_closetag(type));
+	NFT_FPRINTF_RETURN_OR_FIXLEN(ret, len);
+
+	return len;
+}
+EXPORT_SYMBOL(nft_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index 2c6e6a6..9620006 100644
--- a/src/set.c
+++ b/src/set.c
@@ -668,6 +668,19 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 }
 EXPORT_SYMBOL(nft_set_snprintf);
 
+static inline int nft_set_do_snprintf(char *buf, size_t size, void *s,
+				      uint32_t type, uint32_t flags)
+{
+	return nft_set_snprintf(buf, size, s, type, flags);
+}
+
+int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type,
+		    uint32_t flags)
+{
+	return nft_fprintf(fp, s, type, flags, nft_set_do_snprintf);
+}
+EXPORT_SYMBOL(nft_set_fprintf);
+
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)
 {
 	list_add_tail(&elem->head, &s->element_list);
diff --git a/src/set_elem.c b/src/set_elem.c
index 5ef46f2..516905d 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -577,6 +577,19 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 }
 EXPORT_SYMBOL(nft_set_elem_snprintf);
 
+static inline int nft_set_elem_do_snprintf(char *buf, size_t size, void *e,
+					   uint32_t type, uint32_t flags)
+{
+	return nft_set_elem_snprintf(buf, size, e, type, flags);
+}
+
+int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type,
+			 uint32_t flags)
+{
+	return nft_fprintf(fp, se, type, flags, nft_set_elem_do_snprintf);
+}
+EXPORT_SYMBOL(nft_set_elem_fprintf);
+
 int nft_set_elem_foreach(struct nft_set *s,
 			 int (*cb)(struct nft_set_elem *e, void *data),
 			 void *data)
diff --git a/src/table.c b/src/table.c
index d3ff188..d1acc7c 100644
--- a/src/table.c
+++ b/src/table.c
@@ -388,6 +388,19 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 }
 EXPORT_SYMBOL(nft_table_snprintf);
 
+static inline int nft_table_do_snprintf(char *buf, size_t size, void *t,
+					uint32_t type, uint32_t flags)
+{
+	return nft_table_snprintf(buf, size, t, type, flags);
+}
+
+int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type,
+		      uint32_t flags)
+{
+	return nft_fprintf(fp, t, type, flags, nft_table_do_snprintf);
+}
+EXPORT_SYMBOL(nft_table_fprintf);
+
 struct nft_table_list {
 	struct list_head list;
 };
diff --git a/src/utils.c b/src/utils.c
index 9a0bcfe..2415917 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -174,3 +174,30 @@ void xfree(const void *ptr)
 {
 	free((void *)ptr);
 }
+
+int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
+		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
+				   uint32_t type, uint32_t flags))
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}

