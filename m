From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl] libnftnl: constify object arguments to various functions
Date: Tue, 26 Apr 2016 14:16:58 +0100
Message-ID: <1461676618-22732-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61358 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcDZNRG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 09:17:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

flow table support needs constant object arguments to printing functions
to avoid ugly casts. While at it, also constify object arguments to message
construction, destructor and a few helper functions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/data_reg.h         |  8 +++++---
 include/expr_ops.h         |  6 +++---
 include/libnftnl/chain.h   |  8 ++++----
 include/libnftnl/expr.h    |  4 ++--
 include/libnftnl/gen.h     | 14 ++++++-------
 include/libnftnl/rule.h    | 10 ++++-----
 include/libnftnl/ruleset.h |  2 +-
 include/libnftnl/set.h     | 24 +++++++++++-----------
 include/libnftnl/table.h   | 22 ++++++++++----------
 include/libnftnl/trace.h   |  2 +-
 include/libnftnl/udata.h   |  2 +-
 include/utils.h            |  8 +++++---
 src/chain.c                | 29 +++++++++++++-------------
 src/common.c               | 12 +++++------
 src/expr.c                 |  6 +++---
 src/expr/bitwise.c         |  8 ++++----
 src/expr/byteorder.c       |  8 ++++----
 src/expr/cmp.c             |  8 ++++----
 src/expr/counter.c         | 10 ++++-----
 src/expr/ct.c              | 10 +++++----
 src/expr/data_reg.c        | 27 +++++++++++++++---------
 src/expr/dup.c             | 12 ++++++-----
 src/expr/dynset.c          |  8 ++++----
 src/expr/exthdr.c          |  8 ++++----
 src/expr/fwd.c             | 12 ++++++-----
 src/expr/immediate.c       | 13 ++++++------
 src/expr/limit.c           |  8 ++++----
 src/expr/log.c             | 10 ++++-----
 src/expr/lookup.c          |  8 ++++----
 src/expr/masq.c            |  8 ++++----
 src/expr/match.c           |  8 ++++----
 src/expr/meta.c            |  8 ++++----
 src/expr/nat.c             |  8 ++++----
 src/expr/payload.c         |  6 +++---
 src/expr/queue.c           |  8 ++++----
 src/expr/redir.c           |  8 ++++----
 src/expr/reject.c          |  8 ++++----
 src/expr/target.c          |  8 ++++----
 src/gen.c                  | 32 +++++++++++++++--------------
 src/rule.c                 | 40 ++++++++++++++++++++----------------
 src/ruleset.c              |  2 +-
 src/set.c                  | 51 ++++++++++++++++++++++++----------------------
 src/set_elem.c             | 24 +++++++++++++---------
 src/table.c                | 44 ++++++++++++++++++++-------------------
 src/trace.c                |  2 +-
 src/udata.c                |  4 ++--
 src/utils.c                |  8 +++++---
 47 files changed, 310 insertions(+), 274 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 0f2ae9a..e749b5b 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -23,11 +23,13 @@ union nftnl_data_reg {
 	};
 };
 
-int nftnl_data_reg_snprintf(char *buf, size_t size, union nftnl_data_reg *reg,
-                        uint32_t output_format, uint32_t flags, int reg_type);
+int nftnl_data_reg_snprintf(char *buf, size_t size,
+			    const union nftnl_data_reg *reg,
+			    uint32_t output_format, uint32_t flags,
+			    int reg_type);
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
-void nftnl_free_verdict(union nftnl_data_reg *data);
+void nftnl_free_verdict(const union nftnl_data_reg *data);
 
 #endif
diff --git a/include/expr_ops.h b/include/expr_ops.h
index cecad95..3c0cb18 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -12,12 +12,12 @@ struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
 	int	max_attr;
-	void	(*free)(struct nftnl_expr *e);
+	void	(*free)(const struct nftnl_expr *e);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
-	void	(*build)(struct nlmsghdr *nlh, struct nftnl_expr *e);
-	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, struct nftnl_expr *e);
+	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
+	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_expr *e);
 	int	(*xml_parse)(struct nftnl_expr *e, mxml_node_t *tree,
 			     struct nftnl_parse_err *err);
 	int	(*json_parse)(struct nftnl_expr *e, json_t *data,
diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 9ac8830..4c0d071 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -15,7 +15,7 @@ extern "C" {
 struct nftnl_chain;
 
 struct nftnl_chain *nftnl_chain_alloc(void);
-void nftnl_chain_free(struct nftnl_chain *);
+void nftnl_chain_free(const struct nftnl_chain *);
 
 enum nftnl_chain_attr {
 	NFTNL_CHAIN_NAME	= 0,
@@ -62,8 +62,8 @@ int nftnl_chain_parse(struct nftnl_chain *c, enum nftnl_parse_type type,
 		    const char *data, struct nftnl_parse_err *err);
 int nftnl_chain_parse_file(struct nftnl_chain *c, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err);
-int nftnl_chain_snprintf(char *buf, size_t size, struct nftnl_chain *t, uint32_t type, uint32_t flags);
-int nftnl_chain_fprintf(FILE *fp, struct nftnl_chain *c, uint32_t type, uint32_t flags);
+int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *t, uint32_t type, uint32_t flags);
+int nftnl_chain_fprintf(FILE *fp, const struct nftnl_chain *c, uint32_t type, uint32_t flags);
 
 #define nftnl_chain_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *t);
@@ -72,7 +72,7 @@ struct nftnl_chain_list;
 
 struct nftnl_chain_list *nftnl_chain_list_alloc(void);
 void nftnl_chain_list_free(struct nftnl_chain_list *list);
-int nftnl_chain_list_is_empty(struct nftnl_chain_list *list);
+int nftnl_chain_list_is_empty(const struct nftnl_chain_list *list);
 int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list, int (*cb)(struct nftnl_chain *t, void *data), void *data);
 
 void nftnl_chain_list_add(struct nftnl_chain *r, struct nftnl_chain_list *list);
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index da6a251..f192103 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -17,7 +17,7 @@ enum {
 };
 
 struct nftnl_expr *nftnl_expr_alloc(const char *name);
-void nftnl_expr_free(struct nftnl_expr *expr);
+void nftnl_expr_free(const struct nftnl_expr *expr);
 
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type);
 void nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void *data, uint32_t data_len);
@@ -36,7 +36,7 @@ uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type);
 uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type);
 const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
 
-int nftnl_expr_snprintf(char *buf, size_t buflen, struct nftnl_expr *expr, uint32_t type, uint32_t flags);
+int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
 enum {
 	NFTNL_EXPR_PAYLOAD_DREG	= NFTNL_EXPR_BASE,
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index 3eb8470..d0f638f 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -15,7 +15,7 @@ extern "C" {
 struct nftnl_gen;
 
 struct nftnl_gen *nftnl_gen_alloc(void);
-void nftnl_gen_free(struct nftnl_gen *);
+void nftnl_gen_free(const struct nftnl_gen *);
 
 enum {
 	NFTNL_GEN_ID 	= 0,
@@ -28,18 +28,18 @@ void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr);
 void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data);
 void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 			     const void *data, uint32_t data_len);
-const void *nftnl_gen_get(struct nftnl_gen *gen, uint16_t attr);
-const void *nftnl_gen_get_data(struct nftnl_gen *gen, uint16_t attr,
-				    uint32_t *data_len);
+const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr);
+const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
+			       uint32_t *data_len);
 
 void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t data);
-uint32_t nftnl_gen_get_u32(struct nftnl_gen *gen, uint16_t attr);
+uint32_t nftnl_gen_get_u32(const struct nftnl_gen *gen, uint16_t attr);
 
 struct nlmsghdr;
 int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen);
 
-int nftnl_gen_snprintf(char *buf, size_t size, struct nftnl_gen *gen, uint32_t type, uint32_t flags);
-int nftnl_gen_fprintf(FILE *fp, struct nftnl_gen *gen, uint32_t type, uint32_t flags);
+int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen, uint32_t type, uint32_t flags);
+int nftnl_gen_fprintf(FILE *fp, const struct nftnl_gen *gen, uint32_t type, uint32_t flags);
 
 #define nftnl_gen_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index d5b50ad..6f9d8c1 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -16,7 +16,7 @@ struct nftnl_rule;
 struct nftnl_expr;
 
 struct nftnl_rule *nftnl_rule_alloc(void);
-void nftnl_rule_free(struct nftnl_rule *);
+void nftnl_rule_free(const struct nftnl_rule *);
 
 enum nftnl_rule_attr {
 	NFTNL_RULE_FAMILY	= 0,
@@ -58,8 +58,8 @@ int nftnl_rule_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 		   const char *data, struct nftnl_parse_err *err);
 int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 			FILE *fp, struct nftnl_parse_err *err);
-int nftnl_rule_snprintf(char *buf, size_t size, struct nftnl_rule *t, uint32_t type, uint32_t flags);
-int nftnl_rule_fprintf(FILE *fp, struct nftnl_rule *r, uint32_t type, uint32_t flags);
+int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *t, uint32_t type, uint32_t flags);
+int nftnl_rule_fprintf(FILE *fp, const struct nftnl_rule *r, uint32_t type, uint32_t flags);
 
 #define nftnl_rule_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *t);
@@ -78,7 +78,7 @@ struct nftnl_rule_list;
 
 struct nftnl_rule_list *nftnl_rule_list_alloc(void);
 void nftnl_rule_list_free(struct nftnl_rule_list *list);
-int nftnl_rule_list_is_empty(struct nftnl_rule_list *list);
+int nftnl_rule_list_is_empty(const struct nftnl_rule_list *list);
 void nftnl_rule_list_add(struct nftnl_rule *r, struct nftnl_rule_list *list);
 void nftnl_rule_list_add_tail(struct nftnl_rule *r, struct nftnl_rule_list *list);
 void nftnl_rule_list_del(struct nftnl_rule *r);
@@ -89,7 +89,7 @@ struct nftnl_rule_list_iter;
 struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(struct nftnl_rule_list *l);
 struct nftnl_rule *nftnl_rule_list_iter_cur(struct nftnl_rule_list_iter *iter);
 struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter);
-void nftnl_rule_list_iter_destroy(struct nftnl_rule_list_iter *iter);
+void nftnl_rule_list_iter_destroy(const struct nftnl_rule_list_iter *iter);
 
 /*
  * Compat
diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index c184af6..83c2334 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -16,7 +16,7 @@ extern "C" {
 struct nftnl_ruleset;
 
 struct nftnl_ruleset *nftnl_ruleset_alloc(void);
-void nftnl_ruleset_free(struct nftnl_ruleset *r);
+void nftnl_ruleset_free(const struct nftnl_ruleset *r);
 
 enum {
 	NFTNL_RULESET_TABLELIST = 0,
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 11243f5..c9a879a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -29,7 +29,7 @@ enum nftnl_set_attr {
 struct nftnl_set;
 
 struct nftnl_set *nftnl_set_alloc(void);
-void nftnl_set_free(struct nftnl_set *s);
+void nftnl_set_free(const struct nftnl_set *s);
 
 struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set);
 
@@ -42,12 +42,12 @@ void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val);
 void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val);
 void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str);
 
-const void *nftnl_set_get(struct nftnl_set *s, uint16_t attr);
-const void *nftnl_set_get_data(struct nftnl_set *s, uint16_t attr,
-				  uint32_t *data_len);
-const char *nftnl_set_get_str(struct nftnl_set *s, uint16_t attr);
-uint32_t nftnl_set_get_u32(struct nftnl_set *s, uint16_t attr);
-uint64_t nftnl_set_get_u64(struct nftnl_set *s, uint16_t attr);
+const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr);
+const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
+			       uint32_t *data_len);
+const char *nftnl_set_get_str(const struct nftnl_set *s, uint16_t attr);
+uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr);
+uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr);
 
 struct nlmsghdr;
 
@@ -56,14 +56,14 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s);
 int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s);
 int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s);
 
-int nftnl_set_snprintf(char *buf, size_t size, struct nftnl_set *s, uint32_t type, uint32_t flags);
-int nftnl_set_fprintf(FILE *fp, struct nftnl_set *s, uint32_t type, uint32_t flags);
+int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s, uint32_t type, uint32_t flags);
+int nftnl_set_fprintf(FILE *fp, const struct nftnl_set *s, uint32_t type, uint32_t flags);
 
 struct nftnl_set_list;
 
 struct nftnl_set_list *nftnl_set_list_alloc(void);
 void nftnl_set_list_free(struct nftnl_set_list *list);
-int nftnl_set_list_is_empty(struct nftnl_set_list *list);
+int nftnl_set_list_is_empty(const struct nftnl_set_list *list);
 void nftnl_set_list_add(struct nftnl_set *s, struct nftnl_set_list *list);
 void nftnl_set_list_add_tail(struct nftnl_set *s, struct nftnl_set_list *list);
 void nftnl_set_list_del(struct nftnl_set *s);
@@ -73,7 +73,7 @@ struct nftnl_set_list_iter;
 struct nftnl_set_list_iter *nftnl_set_list_iter_create(struct nftnl_set_list *l);
 struct nftnl_set *nftnl_set_list_iter_cur(struct nftnl_set_list_iter *iter);
 struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter);
-void nftnl_set_list_iter_destroy(struct nftnl_set_list_iter *iter);
+void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter);
 
 int nftnl_set_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 		  const char *data, struct nftnl_parse_err *err);
@@ -126,7 +126,7 @@ int nftnl_set_elem_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 		       const char *data, struct nftnl_parse_err *err);
 int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 			    FILE *fp, struct nftnl_parse_err *err);
-int nftnl_set_elem_snprintf(char *buf, size_t size, struct nftnl_set_elem *s, uint32_t type, uint32_t flags);
+int nftnl_set_elem_snprintf(char *buf, size_t size, const struct nftnl_set_elem *s, uint32_t type, uint32_t flags);
 int nftnl_set_elem_fprintf(FILE *fp, struct nftnl_set_elem *se, uint32_t type, uint32_t flags);
 
 int nftnl_set_elem_foreach(struct nftnl_set *s, int (*cb)(struct nftnl_set_elem *e, void *data), void *data);
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index c52d579..8972d09 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -15,7 +15,7 @@ extern "C" {
 struct nftnl_table;
 
 struct nftnl_table *nftnl_table_alloc(void);
-void nftnl_table_free(struct nftnl_table *);
+void nftnl_table_free(const struct nftnl_table *);
 
 enum nftnl_table_attr {
 	NFTNL_TABLE_NAME	= 0,
@@ -31,16 +31,16 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr);
 void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data);
 void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
-const void *nftnl_table_get(struct nftnl_table *t, uint16_t attr);
-const void *nftnl_table_get_data(struct nftnl_table *t, uint16_t attr,
-				    uint32_t *data_len);
+const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr);
+const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
+				 uint32_t *data_len);
 
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t data);
 void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t data);
 void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str);
-uint8_t nftnl_table_get_u8(struct nftnl_table *t, uint16_t attr);
-uint32_t nftnl_table_get_u32(struct nftnl_table *t, uint16_t attr);
-const char *nftnl_table_get_str(struct nftnl_table *t, uint16_t attr);
+uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr);
+uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr);
+const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr);
 
 struct nlmsghdr;
 
@@ -50,8 +50,8 @@ int nftnl_table_parse(struct nftnl_table *t, enum nftnl_parse_type type,
 		    const char *data, struct nftnl_parse_err *err);
 int nftnl_table_parse_file(struct nftnl_table *t, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err);
-int nftnl_table_snprintf(char *buf, size_t size, struct nftnl_table *t, uint32_t type, uint32_t flags);
-int nftnl_table_fprintf(FILE *fp, struct nftnl_table *t, uint32_t type, uint32_t flags);
+int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t, uint32_t type, uint32_t flags);
+int nftnl_table_fprintf(FILE *fp, const struct nftnl_table *t, uint32_t type, uint32_t flags);
 
 #define nftnl_table_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t);
@@ -60,7 +60,7 @@ struct nftnl_table_list;
 
 struct nftnl_table_list *nftnl_table_list_alloc(void);
 void nftnl_table_list_free(struct nftnl_table_list *list);
-int nftnl_table_list_is_empty(struct nftnl_table_list *list);
+int nftnl_table_list_is_empty(const struct nftnl_table_list *list);
 int nftnl_table_list_foreach(struct nftnl_table_list *table_list, int (*cb)(struct nftnl_table *t, void *data), void *data);
 
 void nftnl_table_list_add(struct nftnl_table *r, struct nftnl_table_list *list);
@@ -71,7 +71,7 @@ struct nftnl_table_list_iter;
 
 struct nftnl_table_list_iter *nftnl_table_list_iter_create(struct nftnl_table_list *l);
 struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *iter);
-void nftnl_table_list_iter_destroy(struct nftnl_table_list_iter *iter);
+void nftnl_table_list_iter_destroy(const struct nftnl_table_list_iter *iter);
 
 /*
  * Compat
diff --git a/include/libnftnl/trace.h b/include/libnftnl/trace.h
index 674bc16..18ab0c3 100644
--- a/include/libnftnl/trace.h
+++ b/include/libnftnl/trace.h
@@ -35,7 +35,7 @@ enum nftnl_trace_attr {
 struct nftnl_trace;
 
 struct nftnl_trace *nftnl_trace_alloc(void);
-void nftnl_trace_free(struct nftnl_trace *trace);
+void nftnl_trace_free(const struct nftnl_trace *trace);
 
 bool nftnl_trace_is_set(const struct nftnl_trace *trace, uint16_t type);
 
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index 312ce26..d36cef7 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -13,7 +13,7 @@ struct nftnl_udata_buf;
 
 /* nftnl_udata_buf */
 struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size);
-void nftnl_udata_buf_free(struct nftnl_udata_buf *buf);
+void nftnl_udata_buf_free(const struct nftnl_udata_buf *buf);
 uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf);
 void *nftnl_udata_buf_data(const struct nftnl_udata_buf *buf);
 void nftnl_udata_buf_put(struct nftnl_udata_buf *buf, const void *data,
diff --git a/include/utils.h b/include/utils.h
index 0087dbb..46ff18a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -77,8 +77,10 @@ uint32_t nftnl_str2cmd(const char *cmd);
 
 enum nftnl_cmd_type nftnl_flag2cmd(uint32_t flags);
 
-int nftnl_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type,
-		uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz,
-		void *obj, uint32_t cmd, uint32_t type, uint32_t flags));
+int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
+		  uint32_t flags,
+		  int (*snprintf_cb)(char *buf, size_t bufsiz, const void *obj,
+			  	     uint32_t cmd, uint32_t type,
+				     uint32_t flags));
 
 #endif
diff --git a/src/chain.c b/src/chain.c
index abfc58f..c988bdd 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -93,7 +93,7 @@ struct nftnl_chain *nftnl_chain_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_chain_alloc, nft_chain_alloc);
 
-void nftnl_chain_free(struct nftnl_chain *c)
+void nftnl_chain_free(const struct nftnl_chain *c)
 {
 	if (c->table != NULL)
 		xfree(c->table);
@@ -833,8 +833,8 @@ int nftnl_chain_parse_file(struct nftnl_chain *c, enum nftnl_parse_type type,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_chain_parse_file, nft_chain_parse_file);
 
-static int nftnl_chain_export(char *buf, size_t size, struct nftnl_chain *c,
-			    int type)
+static int nftnl_chain_export(char *buf, size_t size,
+			      const struct nftnl_chain *c, int type)
 {
 	NFTNL_BUF_INIT(b, buf, size);
 
@@ -873,7 +873,7 @@ static int nftnl_chain_export(char *buf, size_t size, struct nftnl_chain *c,
 }
 
 static int nftnl_chain_snprintf_default(char *buf, size_t size,
-				      struct nftnl_chain *c)
+					const struct nftnl_chain *c)
 {
 	int ret, len = size, offset = 0;
 
@@ -899,8 +899,9 @@ static int nftnl_chain_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
-static int nftnl_chain_cmd_snprintf(char *buf, size_t size, struct nftnl_chain *c,
-				  uint32_t cmd, uint32_t type, uint32_t flags)
+static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
+				    const struct nftnl_chain *c, uint32_t cmd,
+				    uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
@@ -927,23 +928,23 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size, struct nftnl_chain *
 	return offset;
 }
 
-int nftnl_chain_snprintf(char *buf, size_t size, struct nftnl_chain *c,
-		       uint32_t type, uint32_t flags)
+int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *c,
+			 uint32_t type, uint32_t flags)
 {
 	return nftnl_chain_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags), type,
 				      flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_chain_snprintf, nft_chain_snprintf);
 
-static inline int nftnl_chain_do_snprintf(char *buf, size_t size, void *c,
-					uint32_t cmd, uint32_t type,
-					uint32_t flags)
+static inline int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
+					  uint32_t cmd, uint32_t type,
+					  uint32_t flags)
 {
 	return nftnl_chain_snprintf(buf, size, c, type, flags);
 }
 
-int nftnl_chain_fprintf(FILE *fp, struct nftnl_chain *c, uint32_t type,
-		      uint32_t flags)
+int nftnl_chain_fprintf(FILE *fp, const struct nftnl_chain *c, uint32_t type,
+			uint32_t flags)
 {
 	return nftnl_fprintf(fp, c, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_chain_do_snprintf);
@@ -980,7 +981,7 @@ void nftnl_chain_list_free(struct nftnl_chain_list *list)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_chain_list_free, nft_chain_list_free);
 
-int nftnl_chain_list_is_empty(struct nftnl_chain_list *list)
+int nftnl_chain_list_is_empty(const struct nftnl_chain_list *list)
 {
 	return list_empty(&list->list);
 }
diff --git a/src/common.c b/src/common.c
index 5dda52f..bf4176c 100644
--- a/src/common.c
+++ b/src/common.c
@@ -109,9 +109,9 @@ int nftnl_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t typ
 	return nftnl_buf_done(&b);
 }
 
-static int nftnl_cmd_header_fprintf_cb(char *buf, size_t size, void *obj,
-				     uint32_t cmd, uint32_t type,
-				     uint32_t flags)
+static int nftnl_cmd_header_fprintf_cb(char *buf, size_t size, const void *obj,
+				       uint32_t cmd, uint32_t type,
+				       uint32_t flags)
 {
 	return nftnl_cmd_header_snprintf(buf, size, cmd, type, flags);
 }
@@ -142,9 +142,9 @@ int nftnl_cmd_footer_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t typ
 	return nftnl_buf_done(&b);
 }
 
-static int nftnl_cmd_footer_fprintf_cb(char *buf, size_t size, void *obj,
-				     uint32_t cmd, uint32_t type,
-				     uint32_t flags)
+static int nftnl_cmd_footer_fprintf_cb(char *buf, size_t size, const void *obj,
+				       uint32_t cmd, uint32_t type,
+				       uint32_t flags)
 {
 	return nftnl_cmd_footer_snprintf(buf, size, cmd, type, flags);
 }
diff --git a/src/expr.c b/src/expr.c
index 16d40d6..ed07dc4 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -45,7 +45,7 @@ struct nftnl_expr *nftnl_expr_alloc(const char *name)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_expr_alloc, nft_rule_expr_alloc);
 
-void nftnl_expr_free(struct nftnl_expr *expr)
+void nftnl_expr_free(const struct nftnl_expr *expr)
 {
 	if (expr->ops->free)
 		expr->ops->free(expr);
@@ -262,8 +262,8 @@ err1:
 	return NULL;
 }
 
-int nftnl_expr_snprintf(char *buf, size_t size, struct nftnl_expr *expr,
-			   uint32_t type, uint32_t flags)
+int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
+			uint32_t type, uint32_t flags)
 {
 	int ret;
 	unsigned int offset = 0, len = size;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index a18aad5..2fd4b74 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -112,7 +112,7 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_bitwise_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 
@@ -251,7 +251,7 @@ nftnl_expr_bitwise_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_bitwise_export(char *buf, size_t size,
-					struct nftnl_expr *e, int type)
+				     const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -271,7 +271,7 @@ static int nftnl_expr_bitwise_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
-						  struct nftnl_expr *e)
+					       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
@@ -296,7 +296,7 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
-			       uint32_t flags, struct nftnl_expr *e)
+			    uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index f16bbf7..ca697cf 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -107,7 +107,7 @@ static int nftnl_expr_byteorder_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_byteorder_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_byteorder_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 
@@ -277,7 +277,7 @@ nftnl_expr_byteorder_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_byteorder_export(char *buf, size_t size,
-					  struct nftnl_expr *e, int type)
+				       const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -297,7 +297,7 @@ static int nftnl_expr_byteorder_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
-						    struct nftnl_expr *e)
+						 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
@@ -312,7 +312,7 @@ static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
-				 uint32_t flags, struct nftnl_expr *e)
+			      uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 4125689..f3dd62c 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -96,7 +96,7 @@ static int nftnl_expr_cmp_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_cmp_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_cmp_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 
@@ -245,7 +245,7 @@ static int nftnl_expr_cmp_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_cmp_export(char *buf, size_t size,
-				    struct nftnl_expr *e, int type)
+				 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -261,7 +261,7 @@ static int nftnl_expr_cmp_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
-					      struct nftnl_expr *e)
+					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
@@ -279,7 +279,7 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, struct nftnl_expr *e)
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 4b5fb3f..1f818c4 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -84,7 +84,7 @@ static int nftnl_expr_counter_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_counter_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_counter_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_counter *ctr = nftnl_expr_data(e);
 
@@ -160,7 +160,7 @@ nftnl_expr_counter_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_counter_export(char *buf, size_t size,
-					struct nftnl_expr *e, int type)
+				     const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_counter *ctr = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -174,7 +174,7 @@ static int nftnl_expr_counter_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_counter_snprintf_default(char *buf, size_t len,
-						  struct nftnl_expr *e)
+					       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_counter *ctr = nftnl_expr_data(e);
 
@@ -183,8 +183,8 @@ static int nftnl_expr_counter_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
-					  uint32_t flags,
-					  struct nftnl_expr *e)
+				       uint32_t flags,
+				       const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/ct.c b/src/expr/ct.c
index a38f40c..87cece2 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -109,7 +109,7 @@ static int nftnl_expr_ct_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_ct_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_ct_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 
@@ -311,7 +311,8 @@ err:
 }
 
 static int
-nftnl_expr_ct_export(char *buf, size_t size, struct nftnl_expr *e, int type)
+nftnl_expr_ct_export(char *buf, size_t size, const struct nftnl_expr *e, 
+		     int type)
 {
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -329,7 +330,8 @@ nftnl_expr_ct_export(char *buf, size_t size, struct nftnl_expr *e, int type)
 }
 
 static int
-nftnl_expr_ct_snprintf_default(char *buf, size_t size, struct nftnl_expr *e)
+nftnl_expr_ct_snprintf_default(char *buf, size_t size,
+			       const struct nftnl_expr *e)
 {
 	int ret, len = size, offset = 0;
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
@@ -357,7 +359,7 @@ nftnl_expr_ct_snprintf_default(char *buf, size_t size, struct nftnl_expr *e)
 
 static int
 nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nftnl_expr *e)
+		       uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index b85d2ef..2a23285 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -186,8 +186,8 @@ err:
 
 static int
 nftnl_data_reg_value_snprintf_json(char *buf, size_t size,
-					   union nftnl_data_reg *reg,
-					   uint32_t flags)
+				   const union nftnl_data_reg *reg,
+				   uint32_t flags)
 {
 	int len = size, offset = 0, ret, i, j;
 	uint32_t utemp;
@@ -223,7 +223,8 @@ nftnl_data_reg_value_snprintf_json(char *buf, size_t size,
 
 static
 int nftnl_data_reg_value_snprintf_xml(char *buf, size_t size,
-				    union nftnl_data_reg *reg, uint32_t flags)
+				      const union nftnl_data_reg *reg,
+				      uint32_t flags)
 {
 	int len = size, offset = 0, ret, i, j;
 	uint32_t be;
@@ -259,7 +260,8 @@ int nftnl_data_reg_value_snprintf_xml(char *buf, size_t size,
 
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
-				    union nftnl_data_reg *reg, uint32_t flags)
+				      const union nftnl_data_reg *reg,
+				      uint32_t flags)
 {
 	int len = size, offset = 0, ret, i;
 
@@ -273,7 +275,8 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
-				  union nftnl_data_reg *reg, uint32_t flags)
+				    const union nftnl_data_reg *reg,
+				    uint32_t flags)
 {
 	int len = size, offset = 0, ret = 0;
 
@@ -290,7 +293,8 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 
 static int
 nftnl_data_reg_verdict_snprintf_xml(char *buf, size_t size,
-				  union nftnl_data_reg *reg, uint32_t flags)
+				    const union nftnl_data_reg *reg,
+				    uint32_t flags)
 {
 	int len = size, offset = 0, ret = 0;
 
@@ -312,7 +316,8 @@ nftnl_data_reg_verdict_snprintf_xml(char *buf, size_t size,
 
 static int
 nftnl_data_reg_verdict_snprintf_json(char *buf, size_t size,
-				   union nftnl_data_reg *reg, uint32_t flags)
+				     const union nftnl_data_reg *reg,
+				     uint32_t flags)
 {
 	int len = size, offset = 0, ret = 0;
 
@@ -332,8 +337,10 @@ nftnl_data_reg_verdict_snprintf_json(char *buf, size_t size,
 	return offset;
 }
 
-int nftnl_data_reg_snprintf(char *buf, size_t size, union nftnl_data_reg *reg,
-			  uint32_t output_format, uint32_t flags, int reg_type)
+int nftnl_data_reg_snprintf(char *buf, size_t size,
+			    const union nftnl_data_reg *reg,
+			    uint32_t output_format, uint32_t flags,
+			    int reg_type)
 {
 	switch(reg_type) {
 	case DATA_VALUE:
@@ -499,7 +506,7 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 	return ret;
 }
 
-void nftnl_free_verdict(union nftnl_data_reg *data)
+void nftnl_free_verdict(const union nftnl_data_reg *data)
 {
 	switch(data->verdict) {
 	case NFT_JUMP:
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 046751e..694db32 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -80,7 +80,8 @@ static int nftnl_expr_dup_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static void nftnl_expr_dup_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+static void nftnl_expr_dup_build(struct nlmsghdr *nlh,
+				 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 
@@ -152,8 +153,8 @@ static int nftnl_expr_dup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nftnl_expr_dup_export(char *buf, size_t size, struct nftnl_expr *e,
-				 int type)
+static int nftnl_expr_dup_export(char *buf, size_t size,
+				 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -167,7 +168,8 @@ static int nftnl_expr_dup_export(char *buf, size_t size, struct nftnl_expr *e,
 }
 
 static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
-					   struct nftnl_expr *e, uint32_t flags)
+					   const struct nftnl_expr *e,
+					   uint32_t flags)
 {
 	int size = len, offset = 0, ret;
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
@@ -186,7 +188,7 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
-				   uint32_t flags, struct nftnl_expr *e)
+				   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index ec8f2d3..a019612 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -135,7 +135,7 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_dynset_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_dynset_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nlattr *nest;
@@ -278,7 +278,7 @@ nftnl_expr_dynset_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 
 static int
 nftnl_expr_dynset_export(char *buf, size_t size,
-			    struct nftnl_expr *e, int type)
+			 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -307,7 +307,7 @@ static const char *op2str(enum nft_dynset_ops op)
 
 static int
 nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
-				      struct nftnl_expr *e)
+				   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nftnl_expr *expr;
@@ -346,7 +346,7 @@ nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
-			      uint32_t flags, struct nftnl_expr *e)
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 
 	switch (type) {
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 2e9b0b0..6489a48 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -109,7 +109,7 @@ static int nftnl_expr_exthdr_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_exthdr_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_exthdr_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
 
@@ -261,7 +261,7 @@ nftnl_expr_exthdr_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_exthdr_export(char *buf, size_t len,
-				       struct nftnl_expr *e, int type)
+				    const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, len);
@@ -279,7 +279,7 @@ static int nftnl_expr_exthdr_export(char *buf, size_t len,
 }
 
 static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
-						 struct nftnl_expr *e)
+					      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
 
@@ -290,7 +290,7 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 
 static int
 nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
-			       uint32_t flags, struct nftnl_expr *e)
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 1131c10..8fa6d66 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -72,7 +72,8 @@ static int nftnl_expr_fwd_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static void nftnl_expr_fwd_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+static void nftnl_expr_fwd_build(struct nlmsghdr *nlh,
+				 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
 
@@ -132,8 +133,8 @@ static int nftnl_expr_fwd_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 #endif
 }
 
-static int nftnl_expr_fwd_export(char *buf, size_t size, struct nftnl_expr *e,
-				 int type)
+static int nftnl_expr_fwd_export(char *buf, size_t size,
+				 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -145,7 +146,8 @@ static int nftnl_expr_fwd_export(char *buf, size_t size, struct nftnl_expr *e,
 }
 
 static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
-					   struct nftnl_expr *e, uint32_t flags)
+					   const struct nftnl_expr *e,
+					   uint32_t flags)
 {
 	int size = len, offset = 0, ret;
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
@@ -159,7 +161,7 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
-				   uint32_t flags, struct nftnl_expr *e)
+				   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index c2fb9ad..eb2ca0f 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -101,7 +101,7 @@ static int nftnl_expr_immediate_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_immediate_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_immediate_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 
@@ -246,8 +246,8 @@ nftnl_expr_immediate_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int
-nftnl_expr_immediate_export(char *buf, size_t size, struct nftnl_expr *e,
-			       int type)
+nftnl_expr_immediate_export(char *buf, size_t size, const struct nftnl_expr *e,
+			    int type)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -266,7 +266,8 @@ nftnl_expr_immediate_export(char *buf, size_t size, struct nftnl_expr *e,
 
 static int
 nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
-				struct nftnl_expr *e, uint32_t flags)
+				      const struct nftnl_expr *e,
+				      uint32_t flags)
 {
 	int size = len, offset = 0, ret;
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
@@ -295,7 +296,7 @@ nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 
 static int
 nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
-				 uint32_t flags, struct nftnl_expr *e)
+			      uint32_t flags, const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -309,7 +310,7 @@ nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
-static void nftnl_expr_immediate_free(struct nftnl_expr *e)
+static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 2c21eb5..4bd096e 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -111,7 +111,7 @@ static int nftnl_expr_limit_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_limit_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_limit_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 
@@ -231,7 +231,7 @@ static const char *get_unit(uint64_t u)
 }
 
 static int nftnl_expr_limit_export(char *buf, size_t size,
-				      struct nftnl_expr *e, int type)
+				   const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -263,7 +263,7 @@ static const char *limit_to_type(enum nft_limit_type type)
 }
 
 static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
-						struct nftnl_expr *e)
+					     const struct nftnl_expr *e)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
 
@@ -274,7 +274,7 @@ static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
 
 static int
 nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nftnl_expr *e)
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/log.c b/src/expr/log.c
index f615d8e..c3dc0a6 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -123,7 +123,7 @@ static int nftnl_expr_log_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_log_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_log_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 
@@ -265,7 +265,7 @@ static int nftnl_expr_log_xml_parse(struct nftnl_expr *e,
 }
 
 static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
-					      struct nftnl_expr *e)
+					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 	int ret, offset = 0, len = size;
@@ -288,7 +288,7 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 }
 
 static int nftnl_expr_log_export(char *buf, size_t size,
-				    struct nftnl_expr *e, int type)
+				 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -311,7 +311,7 @@ static int nftnl_expr_log_export(char *buf, size_t size,
 
 static int
 nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nftnl_expr *e)
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
@@ -325,7 +325,7 @@ nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
-static void nftnl_expr_log_free(struct nftnl_expr *e)
+static void nftnl_expr_log_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index d911cb6..0c1f6a8 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -105,7 +105,7 @@ static int nftnl_expr_lookup_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_lookup_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_lookup_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_lookup *lookup = nftnl_expr_data(e);
 
@@ -207,7 +207,7 @@ nftnl_expr_lookup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 
 static int
 nftnl_expr_lookup_export(char *buf, size_t size,
-			    struct nftnl_expr *e, int type)
+			 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_lookup *l = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -224,7 +224,7 @@ nftnl_expr_lookup_export(char *buf, size_t size,
 
 static int
 nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
-				      struct nftnl_expr *e)
+				   const struct nftnl_expr *e)
 {
 	int len = size, offset = 0, ret;
 	struct nftnl_expr_lookup *l = nftnl_expr_data(e);
@@ -243,7 +243,7 @@ nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
-			       uint32_t flags, struct nftnl_expr *e)
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 
 	switch(type) {
diff --git a/src/expr/masq.c b/src/expr/masq.c
index ff72e2d..7296590 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -90,7 +90,7 @@ static int nftnl_expr_masq_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_masq_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_masq_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
@@ -182,7 +182,7 @@ nftnl_expr_masq_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 #endif
 }
 static int nftnl_expr_masq_export(char *buf, size_t size,
-				     struct nftnl_expr *e, int type)
+				  const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -198,7 +198,7 @@ static int nftnl_expr_masq_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
-					       struct nftnl_expr *e)
+					    const struct nftnl_expr *e)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
@@ -214,7 +214,7 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags, struct nftnl_expr *e)
+				    uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/match.c b/src/expr/match.c
index ddecb43..2929b43 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -109,7 +109,7 @@ static int nftnl_expr_match_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_match_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_match_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_match *mt = nftnl_expr_data(e);
 
@@ -203,7 +203,7 @@ static int nftnl_expr_match_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_match_export(char *buf, size_t size,
-				      struct nftnl_expr *e, int type)
+				   const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_match *mt = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -216,7 +216,7 @@ static int nftnl_expr_match_export(char *buf, size_t size,
 
 static int
 nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
-			     uint32_t flags, struct nftnl_expr *e)
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
@@ -233,7 +233,7 @@ nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
-static void nftnl_expr_match_free(struct nftnl_expr *e)
+static void nftnl_expr_match_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 060c704..a478a89 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -95,7 +95,7 @@ static int nftnl_expr_meta_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_meta_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_meta_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 
@@ -249,7 +249,7 @@ static int nftnl_expr_meta_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 
 static int
 nftnl_expr_meta_snprintf_default(char *buf, size_t len,
-				    struct nftnl_expr *e)
+				 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 
@@ -265,7 +265,7 @@ nftnl_expr_meta_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_meta_export(char *buf, size_t size,
-				     struct nftnl_expr *e, int type)
+				  const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -282,7 +282,7 @@ static int nftnl_expr_meta_export(char *buf, size_t size,
 
 static int
 nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nftnl_expr *e)
+			 uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 421983f..1ae7f77 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -172,7 +172,7 @@ nftnl_expr_nat_parse(struct nftnl_expr *e, struct nlattr *attr)
 }
 
 static void
-nftnl_expr_nat_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_nat_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
 
@@ -330,7 +330,7 @@ static int nftnl_expr_nat_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_nat_export(char *buf, size_t size,
-				    struct nftnl_expr *e, int type)
+				 const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -355,7 +355,7 @@ static int nftnl_expr_nat_export(char *buf, size_t size,
 
 static int
 nftnl_expr_nat_snprintf_default(char *buf, size_t size,
-				   struct nftnl_expr *e)
+				const struct nftnl_expr *e)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
 	int len = size, offset = 0, ret = 0;
@@ -390,7 +390,7 @@ nftnl_expr_nat_snprintf_default(char *buf, size_t size,
 
 static int
 nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
-			   uint32_t flags, struct nftnl_expr *e)
+			uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 508f11a..b4fd9c5 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -126,7 +126,7 @@ static int nftnl_expr_payload_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_payload_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_payload_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
@@ -291,7 +291,7 @@ nftnl_expr_payload_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_payload_export(char *buf, size_t size, uint32_t flags,
-					struct nftnl_expr *e, int type)
+				     const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -310,7 +310,7 @@ static int nftnl_expr_payload_export(char *buf, size_t size, uint32_t flags,
 
 static int
 nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
-			       uint32_t flags, struct nftnl_expr *e)
+			    uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 21126ed..a2e6ed5 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -89,7 +89,7 @@ static int nftnl_expr_queue_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_queue_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_queue_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
 
@@ -181,7 +181,7 @@ nftnl_expr_queue_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
-						struct nftnl_expr *e)
+					     const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
 	int ret, size = len, offset = 0;
@@ -211,7 +211,7 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_queue_export(char *buf, size_t size,
-				      struct nftnl_expr *e, int type)
+				   const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -228,7 +228,7 @@ static int nftnl_expr_queue_export(char *buf, size_t size,
 
 static int
 nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
-			      uint32_t flags, struct nftnl_expr *e)
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 
 	switch (type) {
diff --git a/src/expr/redir.c b/src/expr/redir.c
index b8fb1fe..c6eedfb 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -90,7 +90,7 @@ static int nftnl_expr_redir_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_redir_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_redir_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
@@ -184,7 +184,7 @@ nftnl_expr_redir_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_redir_export(char *buf, size_t size,
-				      struct nftnl_expr *e, int type)
+				   const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
         NFTNL_BUF_INIT(b, buf, size);
@@ -200,7 +200,7 @@ static int nftnl_expr_redir_export(char *buf, size_t size,
 }
 
 static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
-						struct nftnl_expr *e)
+					     const struct nftnl_expr *e)
 {
 	int ret, size = len, offset = 0;
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
@@ -228,7 +228,7 @@ static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
 
 static int
 nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
-			     uint32_t flags, struct nftnl_expr *e)
+			  uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 979817a..1953328 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -85,7 +85,7 @@ static int nftnl_expr_reject_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_reject_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_reject_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_reject *reject = nftnl_expr_data(e);
 
@@ -161,7 +161,7 @@ nftnl_expr_reject_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
-						 struct nftnl_expr *e)
+					      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_reject *reject = nftnl_expr_data(e);
 
@@ -170,7 +170,7 @@ static int nftnl_expr_reject_snprintf_default(char *buf, size_t len,
 }
 
 static int nftnl_expr_reject_export(char *buf, size_t size,
-				       struct nftnl_expr *e, int type)
+				    const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_reject *reject = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -185,7 +185,7 @@ static int nftnl_expr_reject_export(char *buf, size_t size,
 
 static int
 nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
-			      uint32_t flags, struct nftnl_expr *e)
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/target.c b/src/expr/target.c
index cbbee60..68a7d8a 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -109,7 +109,7 @@ static int nftnl_expr_target_cb(const struct nlattr *attr, void *data)
 }
 
 static void
-nftnl_expr_target_build(struct nlmsghdr *nlh, struct nftnl_expr *e)
+nftnl_expr_target_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_target *tg = nftnl_expr_data(e);
 
@@ -204,7 +204,7 @@ nftnl_expr_target_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 }
 
 static int nftnl_rule_exp_target_export(char *buf, size_t size,
-				      struct nftnl_expr *e, int type)
+				        const struct nftnl_expr *e, int type)
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 	NFTNL_BUF_INIT(b, buf, size);
@@ -217,7 +217,7 @@ static int nftnl_rule_exp_target_export(char *buf, size_t size,
 
 static int
 nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
-			      uint32_t flags, struct nftnl_expr *e)
+			   uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
@@ -234,7 +234,7 @@ nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
-static void nftnl_expr_target_free(struct nftnl_expr *e)
+static void nftnl_expr_target_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
diff --git a/src/gen.c b/src/gen.c
index f864333..1f94603 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -35,7 +35,7 @@ struct nftnl_gen *nftnl_gen_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_alloc, nft_gen_alloc);
 
-void nftnl_gen_free(struct nftnl_gen *gen)
+void nftnl_gen_free(const struct nftnl_gen *gen)
 {
 	xfree(gen);
 }
@@ -93,8 +93,8 @@ void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t val)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_set_u32, nft_gen_attr_set_u32);
 
-const void *nftnl_gen_get_data(struct nftnl_gen *gen, uint16_t attr,
-				  uint32_t *data_len)
+const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
+			       uint32_t *data_len)
 {
 	if (!(gen->flags & (1 << attr)))
 		return NULL;
@@ -107,14 +107,14 @@ const void *nftnl_gen_get_data(struct nftnl_gen *gen, uint16_t attr,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_get_data, nft_gen_attr_get_data);
 
-const void *nftnl_gen_get(struct nftnl_gen *gen, uint16_t attr)
+const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_gen_get_data(gen, attr, &data_len);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_get, nft_gen_attr_get);
 
-uint32_t nftnl_gen_get_u32(struct nftnl_gen *gen, uint16_t attr)
+uint32_t nftnl_gen_get_u32(const struct nftnl_gen *gen, uint16_t attr)
 {
 	const void *ret = nftnl_gen_get(gen, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
@@ -156,13 +156,15 @@ int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_nlmsg_parse, nft_gen_nlmsg_parse);
 
-static int nftnl_gen_snprintf_default(char *buf, size_t size, struct nftnl_gen *gen)
+static int nftnl_gen_snprintf_default(char *buf, size_t size,
+				      const struct nftnl_gen *gen)
 {
 	return snprintf(buf, size, "ruleset generation ID %u", gen->id);
 }
 
-static int nftnl_gen_cmd_snprintf(char *buf, size_t size, struct nftnl_gen *gen,
-				uint32_t cmd, uint32_t type, uint32_t flags)
+static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
+				  const struct nftnl_gen *gen, uint32_t cmd,
+				  uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
@@ -184,23 +186,23 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size, struct nftnl_gen *gen,
 	return offset;
 }
 
-int nftnl_gen_snprintf(char *buf, size_t size, struct nftnl_gen *gen, uint32_t type,
-		     uint32_t flags)
+int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen,
+		       uint32_t type, uint32_t flags)
 {;
 	return nftnl_gen_cmd_snprintf(buf, size, gen, nftnl_flag2cmd(flags), type,
 				    flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_snprintf, nft_gen_snprintf);
 
-static inline int nftnl_gen_do_snprintf(char *buf, size_t size, void *gen,
-				      uint32_t cmd, uint32_t type,
-				      uint32_t flags)
+static inline int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
+					uint32_t cmd, uint32_t type,
+					uint32_t flags)
 {
 	return nftnl_gen_snprintf(buf, size, gen, type, flags);
 }
 
-int nftnl_gen_fprintf(FILE *fp, struct nftnl_gen *gen, uint32_t type,
-		    uint32_t flags)
+int nftnl_gen_fprintf(FILE *fp, const struct nftnl_gen *gen, uint32_t type,
+		      uint32_t flags)
 {
 	return nftnl_fprintf(fp, gen, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_gen_do_snprintf);
diff --git a/src/rule.c b/src/rule.c
index 9c09127..31c0658 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -64,7 +64,7 @@ struct nftnl_rule *nftnl_rule_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_alloc, nft_rule_alloc);
 
-void nftnl_rule_free(struct nftnl_rule *r)
+void nftnl_rule_free(const struct nftnl_rule *r)
 {
 	struct nftnl_expr *e, *tmp;
 
@@ -716,8 +716,9 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_parse_file, nft_rule_parse_file);
 
-static int nftnl_rule_snprintf_json(char *buf, size_t size, struct nftnl_rule *r,
-					 uint32_t type, uint32_t flags)
+static int nftnl_rule_snprintf_json(char *buf, size_t size,
+				    const struct nftnl_rule *r,
+				    uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	struct nftnl_expr *expr;
@@ -794,8 +795,9 @@ static int nftnl_rule_snprintf_json(char *buf, size_t size, struct nftnl_rule *r
 	return offset;
 }
 
-static int nftnl_rule_snprintf_xml(char *buf, size_t size, struct nftnl_rule *r,
-				 uint32_t type, uint32_t flags)
+static int nftnl_rule_snprintf_xml(char *buf, size_t size,
+				   const struct nftnl_rule *r,
+				   uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	struct nftnl_expr *expr;
@@ -860,8 +862,9 @@ static int nftnl_rule_snprintf_xml(char *buf, size_t size, struct nftnl_rule *r,
 	return offset;
 }
 
-static int nftnl_rule_snprintf_default(char *buf, size_t size, struct nftnl_rule *r,
-				     uint32_t type, uint32_t flags)
+static int nftnl_rule_snprintf_default(char *buf, size_t size,
+				       const struct nftnl_rule *r,
+				       uint32_t type, uint32_t flags)
 {
 	struct nftnl_expr *expr;
 	int ret, len = size, offset = 0, i;
@@ -930,8 +933,9 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size, struct nftnl_rule
 	return offset;
 }
 
-static int nftnl_rule_cmd_snprintf(char *buf, size_t size, struct nftnl_rule *r,
-				 uint32_t cmd, uint32_t type, uint32_t flags)
+static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
+				   const struct nftnl_rule *r, uint32_t cmd,
+				   uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	uint32_t inner_flags = flags;
@@ -966,23 +970,23 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size, struct nftnl_rule *r,
 	return offset;
 }
 
-int nftnl_rule_snprintf(char *buf, size_t size, struct nftnl_rule *r,
-		      uint32_t type, uint32_t flags)
+int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
+			uint32_t type, uint32_t flags)
 {
 	return nftnl_rule_cmd_snprintf(buf, size, r, nftnl_flag2cmd(flags), type,
 				     flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_snprintf, nft_rule_snprintf);
 
-static inline int nftnl_rule_do_snprintf(char *buf, size_t size, void *r,
-				       uint32_t cmd, uint32_t type,
-				       uint32_t flags)
+static inline int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
+					 uint32_t cmd, uint32_t type,
+					 uint32_t flags)
 {
 	return nftnl_rule_snprintf(buf, size, r, type, flags);
 }
 
-int nftnl_rule_fprintf(FILE *fp, struct nftnl_rule *r, uint32_t type,
-		     uint32_t flags)
+int nftnl_rule_fprintf(FILE *fp, const struct nftnl_rule *r, uint32_t type,
+		       uint32_t flags)
 {
 	return nftnl_fprintf(fp, r, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_rule_do_snprintf);
@@ -1081,7 +1085,7 @@ void nftnl_rule_list_free(struct nftnl_rule_list *list)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_list_free, nft_rule_list_free);
 
-int nftnl_rule_list_is_empty(struct nftnl_rule_list *list)
+int nftnl_rule_list_is_empty(const struct nftnl_rule_list *list)
 {
 	return list_empty(&list->list);
 }
@@ -1166,7 +1170,7 @@ struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_list_iter_next, nft_rule_list_iter_next);
 
-void nftnl_rule_list_iter_destroy(struct nftnl_rule_list_iter *iter)
+void nftnl_rule_list_iter_destroy(const struct nftnl_rule_list_iter *iter)
 {
 	xfree(iter);
 }
diff --git a/src/ruleset.c b/src/ruleset.c
index 641ff99..414b7c4 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -64,7 +64,7 @@ struct nftnl_ruleset *nftnl_ruleset_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_ruleset_alloc, nft_ruleset_alloc);
 
-void nftnl_ruleset_free(struct nftnl_ruleset *r)
+void nftnl_ruleset_free(const struct nftnl_ruleset *r)
 {
 	if (r->flags & (1 << NFTNL_RULESET_TABLELIST))
 		nftnl_table_list_free(r->table_list);
diff --git a/src/set.c b/src/set.c
index 8369f7f..7a92c10 100644
--- a/src/set.c
+++ b/src/set.c
@@ -40,7 +40,7 @@ struct nftnl_set *nftnl_set_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_alloc, nft_set_alloc);
 
-void nftnl_set_free(struct nftnl_set *s)
+void nftnl_set_free(const struct nftnl_set *s)
 {
 	struct nftnl_set_elem *elem, *tmp;
 
@@ -196,8 +196,8 @@ void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);
 
-const void *nftnl_set_get_data(struct nftnl_set *s, uint16_t attr,
-				  uint32_t *data_len)
+const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
+			       uint32_t *data_len)
 {
 	if (!(s->flags & (1 << attr)))
 		return NULL;
@@ -245,20 +245,20 @@ const void *nftnl_set_get_data(struct nftnl_set *s, uint16_t attr,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_get_data, nft_set_attr_get_data);
 
-const void *nftnl_set_get(struct nftnl_set *s, uint16_t attr)
+const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_set_get_data(s, attr, &data_len);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_get, nft_set_attr_get);
 
-const char *nftnl_set_get_str(struct nftnl_set *s, uint16_t attr)
+const char *nftnl_set_get_str(const struct nftnl_set *s, uint16_t attr)
 {
 	return nftnl_set_get(s, attr);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_get_str, nft_set_attr_get_str);
 
-uint32_t nftnl_set_get_u32(struct nftnl_set *s, uint16_t attr)
+uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	const uint32_t *val = nftnl_set_get_data(s, attr, &data_len);
@@ -269,7 +269,7 @@ uint32_t nftnl_set_get_u32(struct nftnl_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_get_u32, nft_set_attr_get_u32);
 
-uint64_t nftnl_set_get_u64(struct nftnl_set *s, uint16_t attr)
+uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	const uint64_t *val = nftnl_set_get_data(s, attr, &data_len);
@@ -771,8 +771,9 @@ int nftnl_set_parse_file(struct nftnl_set *s, enum nftnl_parse_type type,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_parse_file, nft_set_parse_file);
 
-static int nftnl_set_snprintf_json(char *buf, size_t size, struct nftnl_set *s,
-				  uint32_t type, uint32_t flags)
+static int nftnl_set_snprintf_json(char *buf, size_t size,
+				   const struct nftnl_set *s,
+				   uint32_t type, uint32_t flags)
 {
 	int len = size, offset = 0, ret;
 	struct nftnl_set_elem *elem;
@@ -862,8 +863,9 @@ static int nftnl_set_snprintf_json(char *buf, size_t size, struct nftnl_set *s,
 	return offset;
 }
 
-static int nftnl_set_snprintf_default(char *buf, size_t size, struct nftnl_set *s,
-				    uint32_t type, uint32_t flags)
+static int nftnl_set_snprintf_default(char *buf, size_t size,
+				      const struct nftnl_set *s,
+				      uint32_t type, uint32_t flags)
 {
 	int ret;
 	int len = size, offset = 0;
@@ -913,8 +915,8 @@ static int nftnl_set_snprintf_default(char *buf, size_t size, struct nftnl_set *
 	return offset;
 }
 
-static int nftnl_set_snprintf_xml(char *buf, size_t size, struct nftnl_set *s,
-				uint32_t flags)
+static int nftnl_set_snprintf_xml(char *buf, size_t size,
+				  const struct nftnl_set *s, uint32_t flags)
 {
 	int ret;
 	int len = size, offset = 0;
@@ -994,8 +996,9 @@ static int nftnl_set_snprintf_xml(char *buf, size_t size, struct nftnl_set *s,
 	return offset;
 }
 
-static int nftnl_set_cmd_snprintf(char *buf, size_t size, struct nftnl_set *s,
-				uint32_t cmd, uint32_t type, uint32_t flags)
+static int nftnl_set_cmd_snprintf(char *buf, size_t size,
+				  const struct nftnl_set *s, uint32_t cmd,
+				  uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 	uint32_t inner_flags = flags;
@@ -1030,23 +1033,23 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size, struct nftnl_set *s,
 	return offset;
 }
 
-int nftnl_set_snprintf(char *buf, size_t size, struct nftnl_set *s,
-		     uint32_t type, uint32_t flags)
+int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s,
+		       uint32_t type, uint32_t flags)
 {
 	return nftnl_set_cmd_snprintf(buf, size, s, nftnl_flag2cmd(flags), type,
 				    flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_snprintf, nft_set_snprintf);
 
-static inline int nftnl_set_do_snprintf(char *buf, size_t size, void *s,
-				      uint32_t cmd, uint32_t type,
-				      uint32_t flags)
+static inline int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
+					uint32_t cmd, uint32_t type,
+					uint32_t flags)
 {
 	return nftnl_set_snprintf(buf, size, s, type, flags);
 }
 
-int nftnl_set_fprintf(FILE *fp, struct nftnl_set *s, uint32_t type,
-		    uint32_t flags)
+int nftnl_set_fprintf(FILE *fp, const struct nftnl_set *s, uint32_t type,
+		      uint32_t flags)
 {
 	return nftnl_fprintf(fp, s, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_set_do_snprintf);
@@ -1089,7 +1092,7 @@ void nftnl_set_list_free(struct nftnl_set_list *list)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_list_free, nft_set_list_free);
 
-int nftnl_set_list_is_empty(struct nftnl_set_list *list)
+int nftnl_set_list_is_empty(const struct nftnl_set_list *list)
 {
 	return list_empty(&list->list);
 }
@@ -1173,7 +1176,7 @@ struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_next, nft_set_list_iter_next);
 
-void nftnl_set_list_iter_destroy(struct nftnl_set_list_iter *iter)
+void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter)
 {
 	xfree(iter);
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index db367bd..d8c4758 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -599,7 +599,8 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_parse_file, nft_set_elem_parse_file);
 
 static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
-				      struct nftnl_set_elem *e, uint32_t flags)
+					const struct nftnl_set_elem *e,
+					uint32_t flags)
 {
 	int ret, len = size, offset = 0, type = -1;
 
@@ -641,7 +642,7 @@ static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 }
 
 static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
-					 struct nftnl_set_elem *e)
+					   const struct nftnl_set_elem *e)
 {
 	int ret, len = size, offset = 0, i;
 
@@ -684,7 +685,8 @@ static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 }
 
 static int nftnl_set_elem_snprintf_xml(char *buf, size_t size,
-				     struct nftnl_set_elem *e, uint32_t flags)
+				       const struct nftnl_set_elem *e,
+				       uint32_t flags)
 {
 	int ret, len = size, offset = 0, type = DATA_NONE;
 
@@ -735,8 +737,9 @@ static int nftnl_set_elem_snprintf_xml(char *buf, size_t size,
 }
 
 static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
-				     struct nftnl_set_elem *e, uint32_t cmd,
-				     uint32_t type, uint32_t flags)
+				       const struct nftnl_set_elem *e,
+				       uint32_t cmd, uint32_t type,
+				       uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
@@ -765,17 +768,18 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
-int nftnl_set_elem_snprintf(char *buf, size_t size, struct nftnl_set_elem *e,
-			      uint32_t type, uint32_t flags)
+int nftnl_set_elem_snprintf(char *buf, size_t size,
+			    const struct nftnl_set_elem *e,
+			    uint32_t type, uint32_t flags)
 {
 	return nftnl_set_elem_cmd_snprintf(buf, size, e, nftnl_flag2cmd(flags),
 					 type, flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_snprintf, nft_set_elem_snprintf);
 
-static inline int nftnl_set_elem_do_snprintf(char *buf, size_t size, void *e,
-					   uint32_t cmd, uint32_t type,
-					   uint32_t flags)
+static inline int nftnl_set_elem_do_snprintf(char *buf, size_t size,
+					     const void *e, uint32_t cmd,
+					     uint32_t type, uint32_t flags)
 {
 	return nftnl_set_elem_snprintf(buf, size, e, type, flags);
 }
diff --git a/src/table.c b/src/table.c
index 4dffcbc..b7c0045 100644
--- a/src/table.c
+++ b/src/table.c
@@ -42,7 +42,7 @@ struct nftnl_table *nftnl_table_alloc(void)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_alloc, nft_table_alloc);
 
-void nftnl_table_free(struct nftnl_table *t)
+void nftnl_table_free(const struct nftnl_table *t)
 {
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
 		xfree(t->name);
@@ -137,8 +137,8 @@ void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_set_str, nft_table_attr_set_str);
 
-const void *nftnl_table_get_data(struct nftnl_table *t, uint16_t attr,
-				    uint32_t *data_len)
+const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
+				 uint32_t *data_len)
 {
 	if (!(t->flags & (1 << attr)))
 		return NULL;
@@ -160,28 +160,28 @@ const void *nftnl_table_get_data(struct nftnl_table *t, uint16_t attr,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_get_data, nft_table_attr_get_data);
 
-const void *nftnl_table_get(struct nftnl_table *t, uint16_t attr)
+const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_table_get_data(t, attr, &data_len);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_get, nft_table_attr_get);
 
-uint32_t nftnl_table_get_u32(struct nftnl_table *t, uint16_t attr)
+uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_get_u32, nft_table_attr_get_u32);
 
-uint8_t nftnl_table_get_u8(struct nftnl_table *t, uint16_t attr)
+uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint8_t *)ret);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_get_u8, nft_table_attr_get_u8);
 
-const char *nftnl_table_get_str(struct nftnl_table *t, uint16_t attr)
+const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr)
 {
 	return nftnl_table_get(t, attr);
 }
@@ -393,8 +393,8 @@ int nftnl_table_parse_file(struct nftnl_table *t, enum nftnl_parse_type type,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_parse_file, nft_table_parse_file);
 
-static int nftnl_table_export(char *buf, size_t size, struct nftnl_table *t,
-			    int type)
+static int nftnl_table_export(char *buf, size_t size,
+			      const struct nftnl_table *t, int type)
 {
 	NFTNL_BUF_INIT(b, buf, size);
 
@@ -413,15 +413,17 @@ static int nftnl_table_export(char *buf, size_t size, struct nftnl_table *t,
 	return nftnl_buf_done(&b);
 }
 
-static int nftnl_table_snprintf_default(char *buf, size_t size, struct nftnl_table *t)
+static int nftnl_table_snprintf_default(char *buf, size_t size,
+					const struct nftnl_table *t)
 {
 	return snprintf(buf, size, "table %s %s flags %x use %d",
 			t->name, nftnl_family2str(t->family),
 			t->table_flags, t->use);
 }
 
-static int nftnl_table_cmd_snprintf(char *buf, size_t size, struct nftnl_table *t,
-				  uint32_t cmd, uint32_t type, uint32_t flags)
+static int nftnl_table_cmd_snprintf(char *buf, size_t size,
+				    const struct nftnl_table *t, uint32_t cmd,
+				    uint32_t type, uint32_t flags)
 {
 	int ret, len = size, offset = 0;
 
@@ -447,23 +449,23 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size, struct nftnl_table *
 	return offset;
 }
 
-int nftnl_table_snprintf(char *buf, size_t size, struct nftnl_table *t,
-		       uint32_t type, uint32_t flags)
+int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t,
+			 uint32_t type, uint32_t flags)
 {
 	return nftnl_table_cmd_snprintf(buf, size, t, nftnl_flag2cmd(flags), type,
 				      flags);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_snprintf, nft_table_snprintf);
 
-static inline int nftnl_table_do_snprintf(char *buf, size_t size, void *t,
-					uint32_t cmd, uint32_t type,
-					uint32_t flags)
+static inline int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
+					  uint32_t cmd, uint32_t type,
+					  uint32_t flags)
 {
 	return nftnl_table_snprintf(buf, size, t, type, flags);
 }
 
-int nftnl_table_fprintf(FILE *fp, struct nftnl_table *t, uint32_t type,
-		      uint32_t flags)
+int nftnl_table_fprintf(FILE *fp, const struct nftnl_table *t, uint32_t type,
+			uint32_t flags)
 {
 	return nftnl_fprintf(fp, t, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_table_do_snprintf);
@@ -500,7 +502,7 @@ void nftnl_table_list_free(struct nftnl_table_list *list)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_list_free, nft_table_list_free);
 
-int nftnl_table_list_is_empty(struct nftnl_table_list *list)
+int nftnl_table_list_is_empty(const struct nftnl_table_list *list)
 {
 	return list_empty(&list->list);
 }
@@ -579,7 +581,7 @@ struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *ite
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_list_iter_next, nft_table_list_iter_next);
 
-void nftnl_table_list_iter_destroy(struct nftnl_table_list_iter *iter)
+void nftnl_table_list_iter_destroy(const struct nftnl_table_list_iter *iter)
 {
 	xfree(iter);
 }
diff --git a/src/trace.c b/src/trace.c
index 849003b..1171f6a 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -59,7 +59,7 @@ struct nftnl_trace *nftnl_trace_alloc(void)
 }
 
 EXPORT_SYMBOL(nftnl_trace_free);
-void nftnl_trace_free(struct nftnl_trace *t)
+void nftnl_trace_free(const struct nftnl_trace *t)
 {
 	xfree(t->chain);
 	xfree(t->table);
diff --git a/src/udata.c b/src/udata.c
index 03aac63..60c2f34 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -30,9 +30,9 @@ struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size)
 }
 EXPORT_SYMBOL(nftnl_udata_buf_alloc);
 
-void nftnl_udata_buf_free(struct nftnl_udata_buf *buf)
+void nftnl_udata_buf_free(const struct nftnl_udata_buf *buf)
 {
-	free(buf);
+	xfree(buf);
 }
 EXPORT_SYMBOL(nftnl_udata_buf_free);
 
diff --git a/src/utils.c b/src/utils.c
index ba36bc4..089446c 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -233,9 +233,11 @@ uint32_t nftnl_str2cmd(const char *cmd)
 	return NFTNL_CMD_UNSPEC;
 }
 
-int nftnl_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type, uint32_t flags,
-		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
-				   uint32_t cmd, uint32_t type, uint32_t flags))
+int nftnl_fprintf(FILE *fp, const void *obj, uint32_t cmd, uint32_t type,
+		  uint32_t flags,
+		  int (*snprintf_cb)(char *buf, size_t bufsiz, const void *obj,
+				     uint32_t cmd, uint32_t type,
+				     uint32_t flags))
 {
 	char _buf[NFTNL_SNPRINTF_BUFSIZ];
 	char *buf = _buf;
-- 
2.5.5

