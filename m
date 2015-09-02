From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] src: add compat header file definitions
Date: Wed,  2 Sep 2015 16:44:43 +0200
Message-ID: <1441205083-9275-2-git-send-email-pablo@netfilter.org>
References: <1441205083-9275-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbbIBOi0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Sep 2015 10:38:26 -0400
In-Reply-To: <1441205083-9275-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch restores the original nft_* definitions from the header files to
avoid sudden compilation breakage of the existing clients of this library.

Then, moving forward the idea is to deprecate the old nft_* symbols anytime
soon using __attribute__((deprecated)) from the header files to warn our users
that they need to update their code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/batch.h   |   16 +++++
 include/libnftnl/chain.h   |   77 ++++++++++++++++++++
 include/libnftnl/common.h  |   53 ++++++++++++++
 include/libnftnl/expr.h    |  168 ++++++++++++++++++++++++++++++++++++++++++++
 include/libnftnl/gen.h     |   36 ++++++++++
 include/libnftnl/rule.h    |   83 ++++++++++++++++++++++
 include/libnftnl/ruleset.h |   61 ++++++++++++++++
 include/libnftnl/set.h     |  136 +++++++++++++++++++++++++++++++++++
 include/libnftnl/table.h   |   65 +++++++++++++++++
 include/utils.h            |    2 +-
 10 files changed, 696 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/batch.h b/include/libnftnl/batch.h
index ea1ea66..bd18733 100644
--- a/include/libnftnl/batch.h
+++ b/include/libnftnl/batch.h
@@ -15,4 +15,20 @@ uint32_t nftnl_batch_buffer_len(struct nftnl_batch *batch);
 int nftnl_batch_iovec_len(struct nftnl_batch *batch);
 void nftnl_batch_iovec(struct nftnl_batch *batch, struct iovec *iov, uint32_t iovlen);
 
+/*
+ * Compat
+ */
+
+struct nft_batch;
+
+struct nft_batch *nft_batch_alloc(uint32_t pg_size, uint32_t pg_overrun_size);
+int nft_batch_update(struct nft_batch *batch);
+void nft_batch_free(struct nft_batch *batch);
+
+void *nft_batch_buffer(struct nft_batch *batch);
+uint32_t nft_batch_buffer_len(struct nft_batch *batch);
+
+int nft_batch_iovec_len(struct nft_batch *batch);
+void nft_batch_iovec(struct nft_batch *batch, struct iovec *iov, uint32_t iovlen);
+
 #endif
diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 1f426f7..d952ce9 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -85,6 +85,83 @@ struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(struct nftnl_chain_li
 struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *iter);
 void nftnl_chain_list_iter_destroy(struct nftnl_chain_list_iter *iter);
 
+/*
+ * Compat
+ */
+
+struct nft_chain;
+
+struct nft_chain *nft_chain_alloc(void);
+void nft_chain_free(struct nft_chain *);
+
+enum {
+	NFT_CHAIN_ATTR_NAME	= 0,
+	NFT_CHAIN_ATTR_FAMILY,
+	NFT_CHAIN_ATTR_TABLE,
+	NFT_CHAIN_ATTR_HOOKNUM,
+	NFT_CHAIN_ATTR_PRIO	= 4,
+	NFT_CHAIN_ATTR_POLICY,
+	NFT_CHAIN_ATTR_USE,
+	NFT_CHAIN_ATTR_BYTES,
+	NFT_CHAIN_ATTR_PACKETS	= 8,
+	NFT_CHAIN_ATTR_HANDLE,
+	NFT_CHAIN_ATTR_TYPE,
+	NFT_CHAIN_ATTR_DEV,
+	__NFT_CHAIN_ATTR_MAX
+};
+#define NFT_CHAIN_ATTR_MAX (__NFT_CHAIN_ATTR_MAX - 1)
+
+bool nft_chain_attr_is_set(const struct nft_chain *c, uint16_t attr);
+void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
+void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const void *data);
+void nft_chain_attr_set_data(struct nft_chain *t, uint16_t attr,
+			     const void *data, uint32_t data_len);
+void nft_chain_attr_set_u8(struct nft_chain *t, uint16_t attr, uint8_t data);
+void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uint32_t data);
+void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int32_t data);
+void nft_chain_attr_set_u64(struct nft_chain *t, uint16_t attr, uint64_t data);
+void nft_chain_attr_set_str(struct nft_chain *t, uint16_t attr, const char *str);
+
+const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr);
+const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
+				    uint32_t *data_len);
+const char *nft_chain_attr_get_str(struct nft_chain *c, uint16_t attr);
+uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr);
+uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr);
+int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr);
+uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr);
+
+struct nlmsghdr;
+
+void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
+
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err);
+int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err);
+int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
+int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
+
+#define nft_chain_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *t);
+
+struct nft_chain_list;
+
+struct nft_chain_list *nft_chain_list_alloc(void);
+void nft_chain_list_free(struct nft_chain_list *list);
+int nft_chain_list_is_empty(struct nft_chain_list *list);
+int nft_chain_list_foreach(struct nft_chain_list *chain_list, int (*cb)(struct nft_chain *t, void *data), void *data);
+
+void nft_chain_list_add(struct nft_chain *r, struct nft_chain_list *list);
+void nft_chain_list_add_tail(struct nft_chain *r, struct nft_chain_list *list);
+void nft_chain_list_del(struct nft_chain *c);
+
+struct nft_chain_list_iter;
+
+struct nft_chain_list_iter *nft_chain_list_iter_create(struct nft_chain_list *l);
+struct nft_chain *nft_chain_list_iter_next(struct nft_chain_list_iter *iter);
+void nft_chain_list_iter_destroy(struct nft_chain_list_iter *iter);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index b9c6ff3..a40688c 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -52,4 +52,57 @@ int nftnl_batch_is_supported(void);
 void nftnl_batch_begin(char *buf, uint32_t seq);
 void nftnl_batch_end(char *buf, uint32_t seq);
 
+/*
+ * Compat
+ */
+
+enum {
+	NFT_PARSE_EBADINPUT	= 0,
+	NFT_PARSE_EMISSINGNODE,
+	NFT_PARSE_EBADTYPE,
+	NFT_PARSE_EOPNOTSUPP,
+};
+
+enum nft_output_type {
+	NFT_OUTPUT_DEFAULT	= 0,
+	NFT_OUTPUT_XML,
+	NFT_OUTPUT_JSON,
+};
+
+enum nft_output_flags {
+	NFT_OF_EVENT_NEW	= (1 << 0),
+	NFT_OF_EVENT_DEL	= (1 << 1),
+	NFT_OF_EVENT_ANY	= (NFT_OF_EVENT_NEW | NFT_OF_EVENT_DEL),
+};
+
+enum nft_cmd_type {
+	NFT_CMD_UNSPEC		= 0,
+	NFT_CMD_ADD,
+	NFT_CMD_INSERT,
+	NFT_CMD_DELETE,
+	NFT_CMD_REPLACE,
+	NFT_CMD_FLUSH,
+	NFT_CMD_MAX,
+};
+
+enum nft_parse_type {
+	NFT_PARSE_NONE		= 0,
+	NFT_PARSE_XML,
+	NFT_PARSE_JSON,
+	NFT_PARSE_MAX,
+};
+
+struct nft_parse_err;
+
+struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
+				     uint16_t type, uint32_t seq);
+
+struct nft_parse_err *nft_parse_err_alloc(void);
+void nft_parse_err_free(struct nft_parse_err *);
+int nft_parse_perror(const char *str, struct nft_parse_err *err);
+
+int nft_batch_is_supported(void);
+void nft_batch_begin(char *buf, uint32_t seq);
+void nft_batch_end(char *buf, uint32_t seq);
+
 #endif
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 1ca1d8b..c0c8259 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -173,6 +173,174 @@ enum {
 	NFTNL_EXPR_REDIR_FLAGS,
 };
 
+/*
+ * Compat
+ */
+
+struct nft_rule_expr;
+
+enum {
+	NFT_RULE_EXPR_ATTR_NAME = 0,
+	NFT_RULE_EXPR_ATTR_BASE,
+};
+
+struct nft_rule_expr *nft_rule_expr_alloc(const char *name);
+void nft_rule_expr_free(struct nft_rule_expr *expr);
+
+bool nft_rule_expr_is_set(const struct nft_rule_expr *expr, uint16_t type);
+void nft_rule_expr_set(struct nft_rule_expr *expr, uint16_t type, const void *data, uint32_t data_len);
+#define nft_rule_expr_set_data nft_rule_expr_set
+void nft_rule_expr_set_u8(struct nft_rule_expr *expr, uint16_t type, uint8_t data);
+void nft_rule_expr_set_u16(struct nft_rule_expr *expr, uint16_t type, uint16_t data);
+void nft_rule_expr_set_u32(struct nft_rule_expr *expr, uint16_t type, uint32_t data);
+void nft_rule_expr_set_u64(struct nft_rule_expr *expr, uint16_t type, uint64_t data);
+void nft_rule_expr_set_str(struct nft_rule_expr *expr, uint16_t type, const char *str);
+
+const void *nft_rule_expr_get(const struct nft_rule_expr *expr, uint16_t type, uint32_t *data_len);
+#define nft_rule_expr_get_data nft_rule_expr_get
+uint8_t nft_rule_expr_get_u8(const struct nft_rule_expr *expr, uint16_t type);
+uint16_t nft_rule_expr_get_u16(const struct nft_rule_expr *expr, uint16_t type);
+uint32_t nft_rule_expr_get_u32(const struct nft_rule_expr *expr, uint16_t type);
+uint64_t nft_rule_expr_get_u64(const struct nft_rule_expr *expr, uint16_t type);
+const char *nft_rule_expr_get_str(const struct nft_rule_expr *expr, uint16_t type);
+
+int nft_rule_expr_snprintf(char *buf, size_t buflen, struct nft_rule_expr *expr, uint32_t type, uint32_t flags);
+
+enum {
+	NFT_EXPR_PAYLOAD_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_PAYLOAD_BASE,
+	NFT_EXPR_PAYLOAD_OFFSET,
+	NFT_EXPR_PAYLOAD_LEN,
+};
+
+enum {
+	NFT_EXPR_META_KEY	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_META_DREG,
+	NFT_EXPR_META_SREG,
+};
+
+enum {
+	NFT_EXPR_CMP_SREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_CMP_OP,
+	NFT_EXPR_CMP_DATA,
+};
+
+enum {
+	NFT_EXPR_IMM_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_IMM_DATA,
+	NFT_EXPR_IMM_VERDICT,
+	NFT_EXPR_IMM_CHAIN,
+};
+
+enum {
+	NFT_EXPR_CTR_PACKETS	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_CTR_BYTES,
+};
+
+enum {
+	NFT_EXPR_BITWISE_SREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_BITWISE_DREG,
+	NFT_EXPR_BITWISE_LEN,
+	NFT_EXPR_BITWISE_MASK,
+	NFT_EXPR_BITWISE_XOR,
+};
+
+enum {
+	NFT_EXPR_TG_NAME	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_TG_REV,
+	NFT_EXPR_TG_INFO,
+};
+
+enum {
+	NFT_EXPR_MT_NAME	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_MT_REV,
+	NFT_EXPR_MT_INFO,
+};
+
+enum {
+	NFT_EXPR_NAT_TYPE		= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_NAT_FAMILY,
+	NFT_EXPR_NAT_REG_ADDR_MIN,
+	NFT_EXPR_NAT_REG_ADDR_MAX,
+	NFT_EXPR_NAT_REG_PROTO_MIN,
+	NFT_EXPR_NAT_REG_PROTO_MAX,
+	NFT_EXPR_NAT_FLAGS,
+};
+
+enum {
+	NFT_EXPR_LOOKUP_SREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_LOOKUP_DREG,
+	NFT_EXPR_LOOKUP_SET,
+	NFT_EXPR_LOOKUP_SET_ID,
+};
+
+enum {
+	NFT_EXPR_DYNSET_SREG_KEY	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_DYNSET_SREG_DATA,
+	NFT_EXPR_DYNSET_OP,
+	NFT_EXPR_DYNSET_TIMEOUT,
+	NFT_EXPR_DYNSET_SET_NAME,
+	NFT_EXPR_DYNSET_SET_ID,
+	NFT_EXPR_DYNSET_EXPR,
+};
+
+enum {
+	NFT_EXPR_LOG_PREFIX	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_LOG_GROUP,
+	NFT_EXPR_LOG_SNAPLEN,
+	NFT_EXPR_LOG_QTHRESHOLD,
+	NFT_EXPR_LOG_LEVEL,
+	NFT_EXPR_LOG_FLAGS,
+};
+
+enum {
+	NFT_EXPR_EXTHDR_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_EXTHDR_TYPE,
+	NFT_EXPR_EXTHDR_OFFSET,
+	NFT_EXPR_EXTHDR_LEN,
+};
+
+enum {
+	NFT_EXPR_CT_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_CT_KEY,
+	NFT_EXPR_CT_DIR,
+	NFT_EXPR_CT_SREG,
+};
+
+enum {
+	NFT_EXPR_BYTEORDER_DREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_BYTEORDER_SREG,
+	NFT_EXPR_BYTEORDER_OP,
+	NFT_EXPR_BYTEORDER_LEN,
+	NFT_EXPR_BYTEORDER_SIZE,
+};
+
+enum {
+	NFT_EXPR_LIMIT_RATE	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_LIMIT_UNIT,
+};
+
+enum {
+	NFT_EXPR_REJECT_TYPE	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_REJECT_CODE,
+};
+
+enum {
+	NFT_EXPR_QUEUE_NUM	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_QUEUE_TOTAL,
+	NFT_EXPR_QUEUE_FLAGS,
+};
+
+enum {
+	NFT_EXPR_MASQ_FLAGS	= NFT_RULE_EXPR_ATTR_BASE,
+};
+
+enum {
+	NFT_EXPR_REDIR_REG_PROTO_MIN	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_REDIR_REG_PROTO_MAX,
+	NFT_EXPR_REDIR_FLAGS,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index eb72d56..1bb2d56 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -44,6 +44,42 @@ int nftnl_gen_fprintf(FILE *fp, struct nftnl_gen *gen, uint32_t type, uint32_t f
 #define nftnl_gen_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen);
 
+/*
+ * Compat
+ */
+
+struct nft_gen;
+
+struct nft_gen *nft_gen_alloc(void);
+void nft_gen_free(struct nft_gen *);
+
+enum {
+	NFT_GEN_ID 	= 0,
+	__NFT_GEN_MAX
+};
+#define NFT_GEN_MAX (__NFT_GEN_MAX - 1)
+
+bool nft_gen_attr_is_set(const struct nft_gen *gen, uint16_t attr);
+void nft_gen_attr_unset(struct nft_gen *gen, uint16_t attr);
+void nft_gen_attr_set(struct nft_gen *gen, uint16_t attr, const void *data);
+void nft_gen_attr_set_data(struct nft_gen *gen, uint16_t attr,
+			     const void *data, uint32_t data_len);
+const void *nft_gen_attr_get(struct nft_gen *gen, uint16_t attr);
+const void *nft_gen_attr_get_data(struct nft_gen *gen, uint16_t attr,
+				    uint32_t *data_len);
+
+void nft_gen_attr_set_u32(struct nft_gen *gen, uint16_t attr, uint32_t data);
+uint32_t nft_gen_attr_get_u32(struct nft_gen *gen, uint16_t attr);
+
+struct nlmsghdr;
+int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen);
+
+int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen, uint32_t type, uint32_t flags);
+int nft_gen_fprintf(FILE *fp, struct nft_gen *gen, uint32_t type, uint32_t flags);
+
+#define nft_gen_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 8aa47ea..c1bfcb6 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -91,6 +91,89 @@ struct nftnl_rule *nftnl_rule_list_iter_cur(struct nftnl_rule_list_iter *iter);
 struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter);
 void nftnl_rule_list_iter_destroy(struct nftnl_rule_list_iter *iter);
 
+/*
+ * Compat
+ */
+
+struct nft_rule;
+struct nft_rule_expr;
+
+struct nft_rule *nft_rule_alloc(void);
+void nft_rule_free(struct nft_rule *);
+
+enum {
+	NFT_RULE_ATTR_FAMILY	= 0,
+	NFT_RULE_ATTR_TABLE,
+	NFT_RULE_ATTR_CHAIN,
+	NFT_RULE_ATTR_HANDLE,
+	NFT_RULE_ATTR_COMPAT_PROTO,
+	NFT_RULE_ATTR_COMPAT_FLAGS,
+	NFT_RULE_ATTR_POSITION,
+	NFT_RULE_ATTR_USERDATA,
+	__NFT_RULE_ATTR_MAX
+};
+#define NFT_RULE_ATTR_MAX (__NFT_RULE_ATTR_MAX - 1)
+
+void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
+bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr);
+void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data);
+void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
+			    const void *data, uint32_t data_len);
+void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val);
+void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val);
+void nft_rule_attr_set_str(struct nft_rule *r, uint16_t attr, const char *str);
+
+const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr);
+const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
+				   uint32_t *data_len);
+const char *nft_rule_attr_get_str(const struct nft_rule *r, uint16_t attr);
+uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr);
+uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr);
+uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr);
+
+void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr);
+
+struct nlmsghdr;
+
+void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
+
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
+		   const char *data, struct nft_parse_err *err);
+int nft_rule_parse_file(struct nft_rule *r, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err);
+int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
+int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
+
+#define nft_rule_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *t);
+
+int nft_rule_expr_foreach(struct nft_rule *r,
+			  int (*cb)(struct nft_rule_expr *e, void *data),
+			  void *data);
+
+struct nft_rule_expr_iter;
+
+struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r);
+struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter);
+void nft_rule_expr_iter_destroy(struct nft_rule_expr_iter *iter);
+
+struct nft_rule_list;
+
+struct nft_rule_list *nft_rule_list_alloc(void);
+void nft_rule_list_free(struct nft_rule_list *list);
+int nft_rule_list_is_empty(struct nft_rule_list *list);
+void nft_rule_list_add(struct nft_rule *r, struct nft_rule_list *list);
+void nft_rule_list_add_tail(struct nft_rule *r, struct nft_rule_list *list);
+void nft_rule_list_del(struct nft_rule *r);
+int nft_rule_list_foreach(struct nft_rule_list *rule_list, int (*cb)(struct nft_rule *t, void *data), void *data);
+
+struct nft_rule_list_iter;
+
+struct nft_rule_list_iter *nft_rule_list_iter_create(struct nft_rule_list *l);
+struct nft_rule *nft_rule_list_iter_cur(struct nft_rule_list_iter *iter);
+struct nft_rule *nft_rule_list_iter_next(struct nft_rule_list_iter *iter);
+void nft_rule_list_iter_destroy(struct nft_rule_list_iter *iter);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index 12e2495..6c304dc 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -70,6 +70,67 @@ int nftnl_ruleset_parse_file(struct nftnl_ruleset *rs, enum nftnl_parse_type typ
 int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs, uint32_t type, uint32_t flags);
 int nftnl_ruleset_fprintf(FILE *fp, const struct nftnl_ruleset *rs, uint32_t type, uint32_t flags);
 
+/*
+ * Compat
+ */
+
+struct nft_ruleset;
+
+struct nft_ruleset *nft_ruleset_alloc(void);
+void nft_ruleset_free(struct nft_ruleset *r);
+
+enum {
+	NFT_RULESET_ATTR_TABLELIST = 0,
+	NFT_RULESET_ATTR_CHAINLIST,
+	NFT_RULESET_ATTR_SETLIST,
+	NFT_RULESET_ATTR_RULELIST,
+};
+
+enum nft_ruleset_type {
+	NFT_RULESET_UNSPEC = 0,
+	NFT_RULESET_RULESET,
+	NFT_RULESET_TABLE,
+	NFT_RULESET_CHAIN,
+	NFT_RULESET_RULE,
+	NFT_RULESET_SET,
+	NFT_RULESET_SET_ELEMS,
+};
+
+bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr);
+void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
+void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
+void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
+
+enum {
+	NFT_RULESET_CTX_CMD = 0,
+	NFT_RULESET_CTX_TYPE,
+	NFT_RULESET_CTX_TABLE,
+	NFT_RULESET_CTX_CHAIN,
+	NFT_RULESET_CTX_RULE,
+	NFT_RULESET_CTX_SET,
+	NFT_RULESET_CTX_DATA,
+};
+
+struct nft_parse_ctx;
+void nft_ruleset_ctx_free(const struct nft_parse_ctx *ctx);
+bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr);
+void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr);
+uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx,
+				 uint16_t attr);
+
+int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
+			      struct nft_parse_err *err, void *data,
+			      int (*cb)(const struct nft_parse_ctx *ctx));
+int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
+				struct nft_parse_err *err, void *data,
+				int (*cb)(const struct nft_parse_ctx *ctx));
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
+		      const char *data, struct nft_parse_err *err);
+int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
+			   FILE *fp, struct nft_parse_err *err);
+int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index d3958f6..4420d03 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -140,4 +140,140 @@ void nftnl_set_elems_iter_destroy(struct nftnl_set_elems_iter *iter);
 int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 					   struct nftnl_set_elems_iter *iter);
 
+/*
+ * Compat
+ */
+
+enum {
+	NFT_SET_ATTR_TABLE,
+	NFT_SET_ATTR_NAME,
+	NFT_SET_ATTR_FLAGS,
+	NFT_SET_ATTR_KEY_TYPE,
+	NFT_SET_ATTR_KEY_LEN,
+	NFT_SET_ATTR_DATA_TYPE,
+	NFT_SET_ATTR_DATA_LEN,
+	NFT_SET_ATTR_FAMILY,
+	NFT_SET_ATTR_ID,
+	NFT_SET_ATTR_POLICY,
+	NFT_SET_ATTR_DESC_SIZE,
+	NFT_SET_ATTR_TIMEOUT,
+	NFT_SET_ATTR_GC_INTERVAL,
+	__NFT_SET_ATTR_MAX
+};
+#define NFT_SET_ATTR_MAX (__NFT_SET_ATTR_MAX - 1)
+
+struct nft_set;
+
+struct nft_set *nft_set_alloc(void);
+void nft_set_free(struct nft_set *s);
+
+struct nft_set *nft_set_clone(const struct nft_set *set);
+
+bool nft_set_attr_is_set(const struct nft_set *s, uint16_t attr);
+void nft_set_attr_unset(struct nft_set *s, uint16_t attr);
+void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data);
+void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
+			   uint32_t data_len);
+void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val);
+void nft_set_attr_set_u64(struct nft_set *s, uint16_t attr, uint64_t val);
+void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str);
+
+const void *nft_set_attr_get(struct nft_set *s, uint16_t attr);
+const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
+				  uint32_t *data_len);
+const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr);
+uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
+uint64_t nft_set_attr_get_u64(struct nft_set *s, uint16_t attr);
+
+struct nlmsghdr;
+
+#define nft_set_nlmsg_build_hdr	nft_nlmsg_build_hdr
+void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
+int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
+int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
+
+int nft_set_snprintf(char *buf, size_t size, struct nft_set *s, uint32_t type, uint32_t flags);
+int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type, uint32_t flags);
+
+struct nft_set_list;
+
+struct nft_set_list *nft_set_list_alloc(void);
+void nft_set_list_free(struct nft_set_list *list);
+int nft_set_list_is_empty(struct nft_set_list *list);
+void nft_set_list_add(struct nft_set *s, struct nft_set_list *list);
+void nft_set_list_add_tail(struct nft_set *s, struct nft_set_list *list);
+void nft_set_list_del(struct nft_set *s);
+int nft_set_list_foreach(struct nft_set_list *set_list, int (*cb)(struct nft_set *t, void *data), void *data);
+
+struct nft_set_list_iter;
+struct nft_set_list_iter *nft_set_list_iter_create(struct nft_set_list *l);
+struct nft_set *nft_set_list_iter_cur(struct nft_set_list_iter *iter);
+struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter);
+void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
+
+int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
+		  const char *data, struct nft_parse_err *err);
+int nft_set_parse_file(struct nft_set *s, enum nft_parse_type type,
+		       FILE *fp, struct nft_parse_err *err);
+
+/*
+ * Set elements
+ */
+
+enum {
+	NFT_SET_ELEM_ATTR_FLAGS,
+	NFT_SET_ELEM_ATTR_KEY,
+	NFT_SET_ELEM_ATTR_VERDICT,
+	NFT_SET_ELEM_ATTR_CHAIN,
+	NFT_SET_ELEM_ATTR_DATA,
+	NFT_SET_ELEM_ATTR_TIMEOUT,
+	NFT_SET_ELEM_ATTR_EXPIRATION,
+	NFT_SET_ELEM_ATTR_USERDATA,
+	NFT_SET_ELEM_ATTR_EXPR,
+};
+
+struct nft_set_elem;
+
+struct nft_set_elem *nft_set_elem_alloc(void);
+void nft_set_elem_free(struct nft_set_elem *s);
+
+struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem);
+
+void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem);
+
+void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr);
+void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
+void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t val);
+void nft_set_elem_attr_set_u64(struct nft_set_elem *s, uint16_t attr, uint64_t val);
+void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str);
+
+const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_t *data_len);
+const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr);
+uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr);
+uint64_t nft_set_elem_attr_get_u64(struct nft_set_elem *s, uint16_t attr);
+
+bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
+
+#define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
+void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
+void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem *e);
+
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
+		       const char *data, struct nft_parse_err *err);
+int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
+			    FILE *fp, struct nft_parse_err *err);
+int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
+int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
+
+int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
+
+struct nft_set_elems_iter;
+struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s);
+struct nft_set_elem *nft_set_elems_iter_cur(struct nft_set_elems_iter *iter);
+struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter);
+void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter);
+
+int nft_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
+					   struct nft_set_elems_iter *iter);
+
 #endif /* _LIBNFTNL_SET_H_ */
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 0f0589b..ca9a5c6 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -73,6 +73,71 @@ struct nftnl_table_list_iter *nftnl_table_list_iter_create(struct nftnl_table_li
 struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *iter);
 void nftnl_table_list_iter_destroy(struct nftnl_table_list_iter *iter);
 
+/*
+ * Compat
+ */
+
+struct nft_table;
+
+struct nft_table *nft_table_alloc(void);
+void nft_table_free(struct nft_table *);
+
+enum {
+	NFT_TABLE_ATTR_NAME	= 0,
+	NFT_TABLE_ATTR_FAMILY,
+	NFT_TABLE_ATTR_FLAGS,
+	NFT_TABLE_ATTR_USE,
+	__NFT_TABLE_ATTR_MAX
+};
+#define NFT_TABLE_ATTR_MAX (__NFT_TABLE_ATTR_MAX - 1)
+
+bool nft_table_attr_is_set(const struct nft_table *t, uint16_t attr);
+void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
+void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data);
+void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
+			     const void *data, uint32_t data_len);
+const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
+const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
+				    uint32_t *data_len);
+
+void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t data);
+void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t data);
+void nft_table_attr_set_str(struct nft_table *t, uint16_t attr, const char *str);
+uint8_t nft_table_attr_get_u8(struct nft_table *t, uint16_t attr);
+uint32_t nft_table_attr_get_u32(struct nft_table *t, uint16_t attr);
+const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr);
+
+struct nlmsghdr;
+
+void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t);
+
+int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err);
+int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err);
+int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
+int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
+
+#define nft_table_nlmsg_build_hdr	nft_nlmsg_build_hdr
+int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t);
+
+struct nft_table_list;
+
+struct nft_table_list *nft_table_list_alloc(void);
+void nft_table_list_free(struct nft_table_list *list);
+int nft_table_list_is_empty(struct nft_table_list *list);
+int nft_table_list_foreach(struct nft_table_list *table_list, int (*cb)(struct nft_table *t, void *data), void *data);
+
+void nft_table_list_add(struct nft_table *r, struct nft_table_list *list);
+void nft_table_list_add_tail(struct nft_table *r, struct nft_table_list *list);
+void nft_table_list_del(struct nft_table *r);
+
+struct nft_table_list_iter;
+
+struct nft_table_list_iter *nft_table_list_iter_create(struct nft_table_list *l);
+struct nft_table *nft_table_list_iter_next(struct nft_table_list_iter *iter);
+void nft_table_list_iter_destroy(struct nft_table_list_iter *iter);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/utils.h b/include/utils.h
index 7a46725..f7436fa 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -10,7 +10,7 @@
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
 #	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x, y)	typeof(x) (x) __visible; __typeof (x) y __attribute ((alias (#x), visibility ("default")))
+#	define EXPORT_SYMBOL(x, y)	typeof(x) (x) __visible; __typeof (y) y __attribute ((alias (#x), visibility ("default")))
 #else
 #	define EXPORT_SYMBOL
 #endif
-- 
1.7.10.4

