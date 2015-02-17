From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: split internal.h is smaller files
Date: Tue, 17 Feb 2015 19:24:25 +0100
Message-ID: <1424197465-5262-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbbBQSVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 13:21:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The internal.h file started being a small file with private definitions.
Its size has been increasing over time with more and more definitions,
so let's split this in small header files that map to the corresponding
class where the functions belong to.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am  |   15 ++-
 include/common.h     |   32 +++++++
 include/data_reg.h   |   31 +++++++
 include/expr.h       |   13 +++
 include/expr_ops.h   |   34 +++++++
 include/internal.h   |   18 ++++
 include/json.h       |   58 ++++++++++++
 include/set.h        |   32 +++++++
 include/set_elem.h   |   14 +++
 include/utils.h      |   83 +++++++++++++++++
 include/xml.h        |   58 ++++++++++++
 src/Makefile.am      |    2 -
 src/common.c         |    1 +
 src/expr.c           |    3 -
 src/expr/bitwise.c   |    3 -
 src/expr/byteorder.c |    3 -
 src/expr/cmp.c       |    3 -
 src/expr/counter.c   |    2 -
 src/expr/ct.c        |    2 -
 src/expr/data_reg.c  |   16 +---
 src/expr/data_reg.h  |   38 --------
 src/expr/exthdr.c    |    3 -
 src/expr/immediate.c |    3 -
 src/expr/limit.c     |    2 -
 src/expr/log.c       |    2 -
 src/expr/lookup.c    |    3 -
 src/expr/masq.c      |    2 -
 src/expr/match.c     |    3 -
 src/expr/meta.c      |    2 -
 src/expr/nat.c       |    2 -
 src/expr/payload.c   |    3 -
 src/expr/queue.c     |    2 -
 src/expr/redir.c     |    2 -
 src/expr/reject.c    |    2 -
 src/expr/target.c    |    3 -
 src/expr_ops.h       |   43 ---------
 src/internal.h       |  248 --------------------------------------------------
 src/mxml.c           |    2 +-
 src/rule.c           |    3 -
 src/set.c            |    3 -
 src/set_elem.c       |    3 -
 src/utils.c          |    3 +-
 42 files changed, 392 insertions(+), 408 deletions(-)
 create mode 100644 include/common.h
 create mode 100644 include/data_reg.h
 create mode 100644 include/expr.h
 create mode 100644 include/expr_ops.h
 create mode 100644 include/internal.h
 create mode 100644 include/json.h
 create mode 100644 include/set.h
 create mode 100644 include/set_elem.h
 create mode 100644 include/utils.h
 create mode 100644 include/xml.h
 delete mode 100644 src/expr/data_reg.h
 delete mode 100644 src/expr_ops.h
 delete mode 100644 src/internal.h

diff --git a/include/Makefile.am b/include/Makefile.am
index 102d5ab..be9eb9b 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,4 +1,15 @@
 SUBDIRS = libnftnl linux
 
-noinst_HEADERS = linux_list.h	\
-		 buffer.h
+noinst_HEADERS = internal.h	\
+		 linux_list.h	\
+		 buffer.h	\
+		 data_reg.h	\
+		 expr_ops.h	\
+		 linux_list.h	\
+		 set.h		\
+		 xml.h		\
+		 common.h	\
+		 expr.h		\
+		 json.h		\
+		 set_elem.h	\
+		 utils.h
diff --git a/include/common.h b/include/common.h
new file mode 100644
index 0000000..4b9e2c5
--- /dev/null
+++ b/include/common.h
@@ -0,0 +1,32 @@
+#ifndef _LIBNFTNL_COMMON_INTERNAL_H
+#define _LIBNFTNL_COMMON_INTERNAL_H
+
+#define BASE_DEC 10
+#define BASE_HEX 16
+
+#define NFT_SNPRINTF_BUFSIZ 4096
+
+struct nft_parse_err {
+	int line;
+	int column;
+	int error;
+	const char *node_name;
+};
+
+enum nft_parse_input {
+	NFT_PARSE_BUFFER,
+	NFT_PARSE_FILE,
+};
+
+#include <stdio.h>
+
+int nft_cmd_header_snprintf(char *buf, size_t bufsize, uint32_t cmd,
+			   uint32_t format, uint32_t flags);
+int nft_cmd_header_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
+			  uint32_t flags);
+int nft_cmd_footer_snprintf(char *buf, size_t bufsize, uint32_t cmd,
+			   uint32_t format, uint32_t flags);
+int nft_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
+			  uint32_t flags);
+
+#endif
diff --git a/include/data_reg.h b/include/data_reg.h
new file mode 100644
index 0000000..e7375b8
--- /dev/null
+++ b/include/data_reg.h
@@ -0,0 +1,31 @@
+#ifndef _DATA_H_
+#define _DATA_H_
+
+#include <stdint.h>
+#include <unistd.h>
+
+enum {
+	DATA_NONE,
+	DATA_VALUE,
+	DATA_VERDICT,
+	DATA_CHAIN,
+};
+
+union nft_data_reg {
+	struct {
+		uint32_t	val[4];
+		uint32_t	len;
+	};
+	struct {
+		int		verdict;
+		const char	*chain;
+	};
+};
+
+int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
+                        uint32_t output_format, uint32_t flags, int reg_type);
+struct nlattr;
+
+int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
+
+#endif
diff --git a/include/expr.h b/include/expr.h
new file mode 100644
index 0000000..ed41105
--- /dev/null
+++ b/include/expr.h
@@ -0,0 +1,13 @@
+#ifndef _LIBNFTNL_EXPR_INTERNAL_H_
+#define _LIBNFTNL_EXPR_INTERNAL_H_
+
+struct expr_ops;
+
+struct nft_rule_expr {
+	struct list_head	head;
+	uint32_t		flags;
+	struct expr_ops		*ops;
+	uint8_t			data[];
+};
+
+#endif
diff --git a/include/expr_ops.h b/include/expr_ops.h
new file mode 100644
index 0000000..ea5defd
--- /dev/null
+++ b/include/expr_ops.h
@@ -0,0 +1,34 @@
+#ifndef _EXPR_OPS_H_
+#define _EXPR_OPS_H_
+
+#include <stdint.h>
+#include "internal.h"
+
+struct nlattr;
+struct nlmsghdr;
+struct nft_rule_expr;
+
+struct expr_ops {
+	struct list_head head;
+
+	const char *name;
+	uint32_t alloc_len;
+	int	max_attr;
+	void	(*free)(struct nft_rule_expr *e);
+	int	(*set)(struct nft_rule_expr *e, uint16_t type, const void *data, uint32_t data_len);
+	const void *(*get)(const struct nft_rule_expr *e, uint16_t type, uint32_t *data_len);
+	int 	(*parse)(struct nft_rule_expr *e, struct nlattr *attr);
+	void	(*build)(struct nlmsghdr *nlh, struct nft_rule_expr *e);
+	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, struct nft_rule_expr *e);
+	int	(*xml_parse)(struct nft_rule_expr *e, mxml_node_t *tree,
+			     struct nft_parse_err *err);
+	int	(*json_parse)(struct nft_rule_expr *e, json_t *data,
+			      struct nft_parse_err *err);
+};
+
+void nft_expr_ops_register(struct expr_ops *ops);
+struct expr_ops *nft_expr_ops_lookup(const char *name);
+
+#define nft_expr_data(ops) (void *)ops->data
+
+#endif
diff --git a/include/internal.h b/include/internal.h
new file mode 100644
index 0000000..c74e2bf
--- /dev/null
+++ b/include/internal.h
@@ -0,0 +1,18 @@
+#ifndef _LIBNFTNL_INTERNAL_H_
+#define _LIBNFTNL_INTERNAL_H_
+
+/* The headers below are NOT exposed as part of the API. */
+#include "data_reg.h"
+#include "linux_list.h"
+#include "utils.h"
+#include "common.h"
+#include "xml.h"
+#include "json.h"
+#include "linux_list.h"
+#include "set.h"
+#include "set_elem.h"
+#include "expr.h"
+#include "expr_ops.h"
+#include "buffer.h"
+
+#endif /* _LIBNFTNL_INTERNAL_H_ */
diff --git a/include/json.h b/include/json.h
new file mode 100644
index 0000000..821c15f
--- /dev/null
+++ b/include/json.h
@@ -0,0 +1,58 @@
+#ifndef LIBNFTNL_JSON_INTERNAL_H
+#define LIBNFTNL_JSON_INTERNAL_H
+
+#ifdef JSON_PARSING
+#include <jansson.h>
+#include <stdbool.h>
+#include "common.h"
+
+struct nft_table;
+struct nft_chain;
+struct nft_rule;
+struct nft_set;
+struct nft_set_elem;
+struct nft_set_list;
+union nft_data_reg;
+
+int nft_jansson_parse_val(json_t *root, const char *node_name, int type,
+			  void *out, struct nft_parse_err *err);
+const char *nft_jansson_parse_str(json_t *root, const char *node_name,
+				  struct nft_parse_err *err);
+bool nft_jansson_node_exist(json_t *root, const char *node_name);
+json_t *nft_jansson_create_root(const void *json, json_error_t *error,
+				struct nft_parse_err *err, enum nft_parse_input input);
+json_t *nft_jansson_get_node(json_t *root, const char *node_name,
+			     struct nft_parse_err *err);
+void nft_jansson_free_root(json_t *root);
+int nft_jansson_parse_family(json_t *root, void *out, struct nft_parse_err *err);
+int nft_jansson_str2num(json_t *root, const char *node_name, int base, void *out,
+			enum nft_type type, struct nft_parse_err *err);
+int nft_jansson_parse_reg(json_t *root, const char *node_name, int type,
+			  void *out, struct nft_parse_err *err);
+struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
+					     struct nft_parse_err *err,
+					     struct nft_set_list *set_list);
+int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
+			       union nft_data_reg *data_reg,
+			       struct nft_parse_err *err);
+int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
+			       struct nft_parse_err *err);
+int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
+			    struct nft_parse_err *err);
+int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
+			    struct nft_parse_err *err);
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
+			   struct nft_parse_err *err,
+			   struct nft_set_list *set_list);
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
+			  struct nft_parse_err *err);
+int nft_jansson_parse_elem(struct nft_set *s, json_t *tree,
+			   struct nft_parse_err *err);
+
+int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
+			    struct nft_parse_err *err);
+#else
+#define json_t void
+#endif
+
+#endif /* LIBNFTNL_JSON_INTERNAL_H */
diff --git a/include/set.h b/include/set.h
new file mode 100644
index 0000000..29b9ce5
--- /dev/null
+++ b/include/set.h
@@ -0,0 +1,32 @@
+#ifndef _LIBNFTNL_SET_INTERNAL_H_
+#define _LIBNFTNL_SET_INTERNAL_H_
+
+#include <linux/netfilter/nf_tables.h>
+
+struct nft_set {
+	struct list_head	head;
+
+	uint32_t		family;
+	uint32_t		set_flags;
+	const char		*table;
+	const char		*name;
+	uint32_t		key_type;
+	uint32_t		key_len;
+	uint32_t		data_type;
+	uint32_t		data_len;
+	uint32_t		id;
+	enum nft_set_policies	policy;
+	struct {
+		uint32_t	size;
+	} desc;
+	struct list_head	element_list;
+
+	uint32_t		flags;
+};
+
+struct nft_set_list;
+struct nft_rule_expr;
+int nft_set_lookup_id(struct nft_rule_expr *e, struct nft_set_list *set_list,
+		      uint32_t *set_id);
+
+#endif
diff --git a/include/set_elem.h b/include/set_elem.h
new file mode 100644
index 0000000..467c1a0
--- /dev/null
+++ b/include/set_elem.h
@@ -0,0 +1,14 @@
+#ifndef _LIBNFTNL_SET_ELEM_INTERNAL_H_
+#define _LIBNFTNL_SET_ELEM_INTERNAL_H_
+
+#include <data_reg.h>
+
+struct nft_set_elem {
+	struct list_head	head;
+	uint32_t		set_elem_flags;
+	union nft_data_reg	key;
+	union nft_data_reg	data;
+	uint32_t		flags;
+};
+
+#endif
diff --git a/include/utils.h b/include/utils.h
new file mode 100644
index 0000000..1801108
--- /dev/null
+++ b/include/utils.h
@@ -0,0 +1,83 @@
+#ifndef LIBNFTNL_UTILS_H
+#define LIBNFTNL_UTILS_H 1
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <stdlib.h>
+#include <libnftnl/common.h>
+
+#include "config.h"
+#ifdef HAVE_VISIBILITY_HIDDEN
+#	define __visible	__attribute__((visibility("default")))
+#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#else
+#	define EXPORT_SYMBOL
+#endif
+
+#define __init		__attribute__((constructor))
+#define __noreturn	__attribute__((__noreturn__))
+
+#define xfree(ptr)	free((void *)ptr);
+
+#define div_round_up(n, d)	(((n) + (d) - 1) / (d))
+
+void __noreturn __abi_breakage(const char *file, int line, const char *reason);
+
+#define abi_breakage()	\
+	__abi_breakage(__FILE__, __LINE__, strerror(errno));
+
+void __nft_assert_fail(uint16_t attr, const char *filename, int line);
+
+#define nft_assert(val, attr, expr)			\
+  ((!val || expr)					\
+   ? (void)0						\
+   : __nft_assert_fail(attr, __FILE__, __LINE__))
+
+#define nft_assert_validate(data, _validate_array, _attr, _data_len)		\
+({										\
+	if (!data)								\
+		__nft_assert_fail(attr, __FILE__, __LINE__);			\
+	if (_validate_array[_attr])						\
+		nft_assert(data, attr, _validate_array[_attr] == _data_len);	\
+})
+
+#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
+	if (ret < 0)					\
+		return ret;				\
+	offset += ret;					\
+	if (ret > len)					\
+		ret = len;				\
+	size += ret;					\
+	len -= ret;
+
+const char *nft_family2str(uint32_t family);
+int nft_str2family(const char *family);
+
+enum nft_type {
+	NFT_TYPE_U8,
+	NFT_TYPE_U16,
+	NFT_TYPE_U32,
+	NFT_TYPE_U64,
+	NFT_TYPE_S8,
+	NFT_TYPE_S16,
+	NFT_TYPE_S32,
+	NFT_TYPE_S64,
+};
+
+int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
+int nft_get_value(enum nft_type type, void *val, void *out);
+
+const char *nft_verdict2str(uint32_t verdict);
+int nft_str2verdict(const char *verdict, int *verdict_num);
+
+const char *nft_cmd2tag(enum nft_cmd_type cmd);
+uint32_t nft_str2cmd(const char *cmd);
+
+enum nft_cmd_type nft_flag2cmd(uint32_t flags);
+
+int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type,
+		uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz,
+		void *obj, uint32_t cmd, uint32_t type, uint32_t flags));
+
+#endif
diff --git a/include/xml.h b/include/xml.h
new file mode 100644
index 0000000..5137034
--- /dev/null
+++ b/include/xml.h
@@ -0,0 +1,58 @@
+#ifndef LIBNFTNL_XML_INTERNAL_H
+#define LIBNFTNL_XML_INTERNAL_H
+
+#ifdef XML_PARSING
+#include <mxml.h>
+#include "common.h"
+
+#define NFT_XML_MAND 0
+#define NFT_XML_OPT (1 << 0)
+
+struct nft_table;
+struct nft_chain;
+struct nft_rule;
+struct nft_set;
+struct nft_set_elem;
+struct nft_set_list;
+union nft_data_reg;
+
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
+				 struct nft_parse_err *err, enum nft_parse_input input);
+struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
+					  struct nft_parse_err *err,
+					  struct nft_set_list *set_list);
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
+		       uint32_t mxmlflags, uint32_t flags,
+		       struct nft_parse_err *err);
+int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
+			    union nft_data_reg *data_reg, uint16_t flags,
+			    struct nft_parse_err *err);
+int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
+		       uint32_t mxml_flags, int base, void *number,
+		       enum nft_type type, uint16_t flags,
+		       struct nft_parse_err *err);
+const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name,
+			       uint32_t mxml_flags, uint16_t flags,
+			       struct nft_parse_err *err);
+int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name,
+			  uint32_t mxml_flags, uint16_t flags,
+			  struct nft_parse_err *err);
+int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e,
+			    struct nft_parse_err *err);
+int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
+			 struct nft_parse_err *err);
+int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
+			 struct nft_parse_err *err);
+int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
+			struct nft_parse_err *err,
+			struct nft_set_list *set_list);
+int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
+		       struct nft_parse_err *err);
+
+int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
+			   struct nft_parse_err *err);
+#else
+#define mxml_node_t void
+#endif
+
+#endif /* LIBNFTNL_XML_INTERNAL_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index c77c3cc..266ff33 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,7 +39,5 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/target.c	\
 		      expr/masq.c	\
 		      expr/redir.c	\
-		      expr/data_reg.h	\
 		      libnftnl.map	\
-		      expr_ops.h	\
 		      internal.h
diff --git a/src/common.c b/src/common.c
index 139be55..7fce48e 100644
--- a/src/common.c
+++ b/src/common.c
@@ -12,6 +12,7 @@
 #include <time.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
diff --git a/src/expr.c b/src/expr.c
index 55557da..79782fa 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -9,7 +9,6 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
-#include "expr_ops.h"
 
 #include <time.h>
 #include <endian.h>
@@ -24,8 +23,6 @@
 
 #include <libnftnl/expr.h>
 
-#include "linux_list.h"
-
 struct nft_rule_expr *nft_rule_expr_alloc(const char *name)
 {
 	struct nft_rule_expr *expr;
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index a299cd4..3c4a2e4 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -20,9 +20,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "data_reg.h"
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_bitwise {
 	enum nft_registers	sreg;
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 77680d2..a16b145 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -20,9 +20,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "data_reg.h"
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_byteorder {
 	enum nft_registers	sreg;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 3ca4b08..ea51b83 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -21,9 +21,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include "data_reg.h"
-#include <buffer.h>
 
 struct nft_expr_cmp {
 	union nft_data_reg	data;
diff --git a/src/expr/counter.c b/src/expr/counter.c
index e9abc5b..a190863 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -21,8 +21,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_counter {
 	uint64_t	pkts;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 12d96d5..c15bf42 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -20,8 +20,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_ct {
 	enum nft_ct_keys        key;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 33b3346..b4e553e 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -22,8 +22,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include "data_reg.h"
 #include "internal.h"
 
 #ifdef JSON_PARSING
@@ -77,12 +75,10 @@ static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json_t *data,
 
 	return DATA_VALUE;
 }
-#endif
 
 int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
 			    struct nft_parse_err *err)
 {
-#ifdef JSON_PARSING
 
 	const char *type;
 
@@ -97,11 +93,8 @@ int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
 		return nft_data_reg_verdict_json_parse(reg, data, err);
 
 	return DATA_NONE;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
 }
+#endif
 
 #ifdef XML_PARSING
 static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
@@ -160,12 +153,10 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg,
 
 	return DATA_VALUE;
 }
-#endif
 
 int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
 			   struct nft_parse_err *err)
 {
-#ifdef XML_PARSING
 	const char *type;
 	mxml_node_t *node;
 
@@ -190,11 +181,8 @@ err:
 	err->node_name = "reg";
 	err->error = NFT_PARSE_EMISSINGNODE;
 	return DATA_NONE;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
 }
+#endif
 
 static int
 nft_data_reg_value_snprintf_json(char *buf, size_t size,
diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
deleted file mode 100644
index 5258051..0000000
--- a/src/expr/data_reg.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#ifndef _DATA_H_
-#define _DATA_H_
-
-enum {
-	DATA_NONE,
-	DATA_VALUE,
-	DATA_VERDICT,
-	DATA_CHAIN,
-};
-
-union nft_data_reg {
-	struct {
-		uint32_t	val[4];
-		uint32_t	len;
-	};
-	struct {
-		int		verdict;
-		const char	*chain;
-	};
-};
-
-#ifndef JSON_PARSING
-#define json_t void
-#endif
-
-#ifndef XML_PARSING
-#define mxml_node_t void
-#endif
-
-int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
-                        uint32_t output_format, uint32_t flags, int reg_type);
-int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
-			   struct nft_parse_err *err);
-int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
-int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
-			    struct nft_parse_err *err);
-
-#endif
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 2135148..615fec6 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -24,9 +24,6 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 
-#include "expr_ops.h"
-#include <buffer.h>
-
 #ifndef IPPROTO_MH
 #define IPPROTO_MH 135
 #endif
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 3d4e48c..b6cde0a 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -19,9 +19,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include "data_reg.h"
-#include <buffer.h>
 
 struct nft_expr_immediate {
 	union nft_data_reg	data;
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 375e6e0..f9331b3 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -21,8 +21,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_limit {
 	uint64_t		rate;
diff --git a/src/expr/log.c b/src/expr/log.c
index 0a324c4..776c7fc 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -20,8 +20,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_log {
 	uint32_t		snaplen;
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 29daa30..57eba1b 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -20,9 +20,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
-#include "data_reg.h"
-#include "expr_ops.h"
-#include <buffer.h>
 
 #ifndef IFNAMSIZ
 #define IFNAMSIZ	16
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 869fd45..79f5185 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -19,8 +19,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_masq {
 	uint32_t	flags;
diff --git a/src/expr/match.c b/src/expr/match.c
index 26a368f..45e7caf 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -24,9 +24,6 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 
-#include "expr_ops.h"
-#include <buffer.h>
-
 /* From include/linux/netfilter/x_tables.h */
 #define XT_EXTENSION_MAXNAMELEN 29
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index d1a6bbb..2f5cddc 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -20,8 +20,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 #ifndef NFT_META_MAX
 #define NFT_META_MAX (NFT_META_CGROUP + 1)
diff --git a/src/expr/nat.c b/src/expr/nat.c
index c9e05af..e36d023 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -23,8 +23,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_nat {
 	enum nft_registers sreg_addr_min;
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 1aa20bd..61e88a9 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -24,9 +24,6 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 
-#include "expr_ops.h"
-#include <buffer.h>
-
 struct nft_expr_payload {
 	enum nft_registers	dreg;
 	enum nft_payload_bases	base;
diff --git a/src/expr/queue.c b/src/expr/queue.c
index a4f0b88..dbae701 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -19,8 +19,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_queue {
 	uint16_t		queuenum;
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 02cd3a6..a1be181 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -19,8 +19,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_redir {
 	enum nft_registers sreg_proto_min;
diff --git a/src/expr/reject.c b/src/expr/reject.c
index fe18368..cd62cbe 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -20,8 +20,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
-#include "expr_ops.h"
-#include <buffer.h>
 
 struct nft_expr_reject {
 	uint32_t		type;
diff --git a/src/expr/target.c b/src/expr/target.c
index a79bc9e..16e9e83 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -24,9 +24,6 @@
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 
-#include "expr_ops.h"
-#include <buffer.h>
-
 /* From include/linux/netfilter/x_tables.h */
 #define XT_EXTENSION_MAXNAMELEN 29
 
diff --git a/src/expr_ops.h b/src/expr_ops.h
deleted file mode 100644
index b06f575..0000000
--- a/src/expr_ops.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifndef _EXPR_OPS_H_
-#define _EXPR_OPS_H_
-
-#include "internal.h"
-#include <stdlib.h>
-#include <stdint.h>
-
-struct nlattr;
-struct nlmsghdr;
-struct nft_rule_expr;
-
-#ifndef XML_PARSING
-#define mxml_node_t void
-#endif
-
-#ifndef JSON_PARSING
-#define json_t void
-#endif
-
-struct expr_ops {
-	struct list_head head;
-
-	const char *name;
-	uint32_t alloc_len;
-	int	max_attr;
-	void	(*free)(struct nft_rule_expr *e);
-	int	(*set)(struct nft_rule_expr *e, uint16_t type, const void *data, uint32_t data_len);
-	const void *(*get)(const struct nft_rule_expr *e, uint16_t type, uint32_t *data_len);
-	int 	(*parse)(struct nft_rule_expr *e, struct nlattr *attr);
-	void	(*build)(struct nlmsghdr *nlh, struct nft_rule_expr *e);
-	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, struct nft_rule_expr *e);
-	int	(*xml_parse)(struct nft_rule_expr *e, mxml_node_t *tree,
-			     struct nft_parse_err *err);
-	int	(*json_parse)(struct nft_rule_expr *e, json_t *data,
-			      struct nft_parse_err *err);
-};
-
-void nft_expr_ops_register(struct expr_ops *ops);
-struct expr_ops *nft_expr_ops_lookup(const char *name);
-
-#define nft_expr_data(ops) (void *)ops->data
-
-#endif
diff --git a/src/internal.h b/src/internal.h
deleted file mode 100644
index 9ebf7d7..0000000
--- a/src/internal.h
+++ /dev/null
@@ -1,248 +0,0 @@
-#ifndef INTERNAL_H
-#define INTERNAL_H 1
-
-#include "config.h"
-#ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
-#else
-#	define EXPORT_SYMBOL
-#endif
-
-#include "linux_list.h"
-
-#include <stdint.h>
-#include <stdbool.h>
-#include <libnftnl/common.h>
-#include <linux/netfilter/nf_tables.h>
-
-#define xfree(ptr)	free((void *)ptr);
-
-#define BASE_DEC 10
-#define BASE_HEX 16
-
-#define NFT_SNPRINTF_BUFSIZ 4096
-
-enum nft_type {
-	NFT_TYPE_U8,
-	NFT_TYPE_U16,
-	NFT_TYPE_U32,
-	NFT_TYPE_U64,
-	NFT_TYPE_S8,
-	NFT_TYPE_S16,
-	NFT_TYPE_S32,
-	NFT_TYPE_S64,
-};
-
-struct nft_parse_err {
-	int line;
-	int column;
-	int error;
-	const char *node_name;
-};
-
-enum nft_parse_input {
-	NFT_PARSE_BUFFER,
-	NFT_PARSE_FILE,
-};
-
-#ifdef XML_PARSING
-#include <mxml.h>
-#define NFT_XML_MAND 0
-#define NFT_XML_OPT (1 << 0)
-mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
-				 struct nft_parse_err *err, enum nft_parse_input input);
-struct nft_set_list;
-struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
-					  struct nft_parse_err *err,
-					  struct nft_set_list *set_list);
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
-		       uint32_t mxmlflags, uint32_t flags,
-		       struct nft_parse_err *err);
-union nft_data_reg;
-int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
-			    union nft_data_reg *data_reg, uint16_t flags,
-			    struct nft_parse_err *err);
-int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
-		       uint32_t mxml_flags, int base, void *number,
-		       enum nft_type type, uint16_t flags,
-		       struct nft_parse_err *err);
-const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name,
-			       uint32_t mxml_flags, uint16_t flags,
-			       struct nft_parse_err *err);
-int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name,
-			  uint32_t mxml_flags, uint16_t flags,
-			  struct nft_parse_err *err);
-
-struct nft_set_elem;
-int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e,
-			    struct nft_parse_err *err);
-struct nft_table;
-int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
-			 struct nft_parse_err *err);
-struct nft_chain;
-int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
-			 struct nft_parse_err *err);
-struct nft_rule;
-int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
-			struct nft_parse_err *err,
-			struct nft_set_list *set_list);
-struct nft_set;
-int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
-		       struct nft_parse_err *err);
-#endif
-
-struct nft_set_list;
-struct nft_rule_expr;
-int nft_set_lookup_id(struct nft_rule_expr *e, struct nft_set_list *set_list,
-		      uint32_t *set_id);
-
-#ifdef JSON_PARSING
-#include <jansson.h>
-
-int nft_jansson_parse_val(json_t *root, const char *node_name, int type,
-			  void *out, struct nft_parse_err *err);
-const char *nft_jansson_parse_str(json_t *root, const char *node_name,
-				  struct nft_parse_err *err);
-bool nft_jansson_node_exist(json_t *root, const char *node_name);
-json_t *nft_jansson_create_root(const void *json, json_error_t *error,
-				struct nft_parse_err *err, enum nft_parse_input input);
-json_t *nft_jansson_get_node(json_t *root, const char *node_name,
-			     struct nft_parse_err *err);
-void nft_jansson_free_root(json_t *root);
-int nft_jansson_parse_family(json_t *root, void *out, struct nft_parse_err *err);
-int nft_jansson_str2num(json_t *root, const char *node_name, int base, void *out,
-			enum nft_type type, struct nft_parse_err *err);
-int nft_jansson_parse_reg(json_t *root, const char *node_name, int type,
-			  void *out, struct nft_parse_err *err);
-struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
-					     struct nft_parse_err *err,
-					     struct nft_set_list *set_list);
-union nft_data_reg;
-int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
-			       union nft_data_reg *data_reg,
-			       struct nft_parse_err *err);
-struct nft_set_elem;
-int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
-			       struct nft_parse_err *err);
-struct nft_table;
-int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
-			    struct nft_parse_err *err);
-struct nft_chain;
-int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
-			    struct nft_parse_err *err);
-struct nft_rule;
-struct nft_set_list;
-int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
-			   struct nft_parse_err *err,
-			   struct nft_set_list *set_list);
-struct nft_set;
-int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
-			  struct nft_parse_err *err);
-int nft_jansson_parse_elem(struct nft_set *s, json_t *tree,
-			   struct nft_parse_err *err);
-#endif
-
-const char *nft_family2str(uint32_t family);
-int nft_str2family(const char *family);
-int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
-const char *nft_verdict2str(uint32_t verdict);
-int nft_str2verdict(const char *verdict, int *verdict_num);
-int nft_get_value(enum nft_type type, void *val, void *out);
-enum nft_cmd_type nft_flag2cmd(uint32_t flags);
-const char *nft_cmd2tag(enum nft_cmd_type cmd);
-uint32_t nft_str2cmd(const char *cmd);
-
-#include <stdio.h>
-int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type,
-		uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz,
-		void *obj, uint32_t cmd, uint32_t type, uint32_t flags));
-int nft_cmd_header_snprintf(char *buf, size_t bufsize, uint32_t cmd,
-			    uint32_t format, uint32_t flags);
-int nft_cmd_header_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
-			   uint32_t flags);
-int nft_cmd_footer_snprintf(char *buf, size_t bufsize, uint32_t cmd,
-			    uint32_t format, uint32_t flags);
-int nft_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t format,
-			   uint32_t flags);
-
-struct expr_ops;
-
-struct nft_rule_expr {
-	struct list_head head;
-	uint32_t	flags;
-	struct expr_ops	*ops;
-	uint8_t		data[];
-};
-
-struct nlattr;
-
-struct nft_set {
-	struct list_head	head;
-
-	uint32_t		family;
-	uint32_t		set_flags;
-	const char		*table;
-	const char		*name;
-	uint32_t		key_type;
-	uint32_t		key_len;
-	uint32_t		data_type;
-	uint32_t		data_len;
-	uint32_t		id;
-	enum nft_set_policies	policy;
-	struct {
-		uint32_t		size;
-	} desc;
-	struct list_head	element_list;
-
-	uint32_t		flags;
-};
-
-#include "expr/data_reg.h"
-
-struct nft_set_elem {
-	struct list_head head;
-	uint32_t	set_elem_flags;
-	union nft_data_reg key;
-	union nft_data_reg data;
-	uint32_t	flags;
-};
-
-#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
-	if (ret < 0)					\
-		return ret;				\
-	offset += ret;					\
-	if (ret > len)					\
-		ret = len;				\
-	size += ret;					\
-	len -= ret;
-
-#define div_round_up(n, d)	(((n) + (d) - 1) / (d))
-
-#define __init __attribute__((constructor))
-
-void __nft_assert_fail(uint16_t attr, const char *filename, int line);
-
-#define nft_assert(val, attr, expr)			\
-  ((!val || expr)					\
-   ? (void)0						\
-   : __nft_assert_fail(attr, __FILE__, __LINE__))
-
-#define nft_assert_validate(data, _validate_array, _attr, _data_len)		\
-({										\
-	if (!data)								\
-		__nft_assert_fail(attr, __FILE__, __LINE__);			\
-	if (_validate_array[_attr])						\
-		nft_assert(data, attr, _validate_array[_attr] == _data_len);	\
-})
-
-#define __noreturn	__attribute__((__noreturn__))
-
-void __noreturn __abi_breakage(const char *file, int line, const char *reason);
-
-#include <string.h>
-
-#define abi_breakage()	\
-	__abi_breakage(__FILE__, __LINE__, strerror(errno));
-
-#endif
diff --git a/src/mxml.c b/src/mxml.c
index a97d380..0001ba0 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -10,7 +10,7 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
-#include "expr_ops.h"
+
 #include <stdint.h>
 #include <limits.h>
 
diff --git a/src/rule.c b/src/rule.c
index 028dc2e..3feb337 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -29,9 +29,6 @@
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
 
-#include "linux_list.h"
-#include "expr_ops.h"
-
 struct nft_rule {
 	struct list_head head;
 
diff --git a/src/set.c b/src/set.c
index c6c3301..f810fce 100644
--- a/src/set.c
+++ b/src/set.c
@@ -26,9 +26,6 @@
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
 
-#include "linux_list.h"
-#include "expr/data_reg.h"
-
 struct nft_set *nft_set_alloc(void)
 {
 	struct nft_set *s;
diff --git a/src/set_elem.c b/src/set_elem.c
index 5794f3a..25cd951 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -25,9 +25,6 @@
 #include <libnftnl/set.h>
 #include <libnftnl/rule.h>
 
-#include "linux_list.h"
-#include "expr/data_reg.h"
-
 struct nft_set_elem *nft_set_elem_alloc(void)
 {
 	struct nft_set_elem *s;
diff --git a/src/utils.c b/src/utils.c
index c201004..728ae30 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -16,7 +16,8 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <inttypes.h>
-#include <buffer.h>
+
+#include <libnftnl/common.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
-- 
1.7.10.4

