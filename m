From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] src: introduce nftnl_* aliases for all existing functions
Date: Wed,  2 Sep 2015 16:44:24 +0200
Message-ID: <1441205064-9240-2-git-send-email-pablo@netfilter.org>
References: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58510 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbbIBOiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Sep 2015 10:38:05 -0400
In-Reply-To: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces the nftnl_ symbols as aliases for the existing nft_
symbols through the EXPORT_SYMBOL(...) macro.

We would like to use the nft_* prefix from our upcoming higher level library,
meanwhile with this move we avoid that old binaries break because of missing
symbol dependencies.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h  |    2 +-
 src/batch.c      |   14 +--
 src/chain.c      |   68 +++++++-------
 src/common.c     |   14 +--
 src/expr.c       |   32 +++----
 src/gen.c        |   26 +++---
 src/libnftnl.map |  260 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/rule.c       |   74 ++++++++--------
 src/ruleset.c    |   32 +++----
 src/set.c        |   64 +++++++-------
 src/set_elem.c   |   48 +++++-----
 src/table.c      |   60 ++++++-------
 12 files changed, 477 insertions(+), 217 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 380b020..fad64e8 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -10,7 +10,7 @@
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
 #	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#	define EXPORT_SYMBOL(y, x)	typeof(x) (x) __visible; __typeof (x) y __attribute ((alias (#x), visibility ("default")))
 #else
 #	define EXPORT_SYMBOL
 #endif
diff --git a/src/batch.c b/src/batch.c
index ec9f728..3f53218 100644
--- a/src/batch.c
+++ b/src/batch.c
@@ -80,7 +80,7 @@ err1:
 	free(batch);
 	return NULL;
 }
-EXPORT_SYMBOL(nft_batch_alloc);
+EXPORT_SYMBOL(nftnl_batch_alloc, nft_batch_alloc);
 
 void nft_batch_free(struct nft_batch *batch)
 {
@@ -94,7 +94,7 @@ void nft_batch_free(struct nft_batch *batch)
 
 	free(batch);
 }
-EXPORT_SYMBOL(nft_batch_free);
+EXPORT_SYMBOL(nftnl_batch_free, nft_batch_free);
 
 int nft_batch_update(struct nft_batch *batch)
 {
@@ -119,19 +119,19 @@ int nft_batch_update(struct nft_batch *batch)
 err1:
 	return -1;
 }
-EXPORT_SYMBOL(nft_batch_update);
+EXPORT_SYMBOL(nftnl_batch_update, nft_batch_update);
 
 void *nft_batch_buffer(struct nft_batch *batch)
 {
 	return mnl_nlmsg_batch_current(batch->current_page->batch);
 }
-EXPORT_SYMBOL(nft_batch_buffer);
+EXPORT_SYMBOL(nftnl_batch_buffer, nft_batch_buffer);
 
 uint32_t nft_batch_buffer_len(struct nft_batch *batch)
 {
 	return mnl_nlmsg_batch_size(batch->current_page->batch);
 }
-EXPORT_SYMBOL(nft_batch_buffer_len);
+EXPORT_SYMBOL(nftnl_batch_buffer_len, nft_batch_buffer_len);
 
 int nft_batch_iovec_len(struct nft_batch *batch)
 {
@@ -143,7 +143,7 @@ int nft_batch_iovec_len(struct nft_batch *batch)
 
 	return num_pages;
 }
-EXPORT_SYMBOL(nft_batch_iovec_len);
+EXPORT_SYMBOL(nftnl_batch_iovec_len, nft_batch_iovec_len);
 
 void nft_batch_iovec(struct nft_batch *batch, struct iovec *iov, uint32_t iovlen)
 {
@@ -159,4 +159,4 @@ void nft_batch_iovec(struct nft_batch *batch, struct iovec *iov, uint32_t iovlen
 		i++;
 	}
 }
-EXPORT_SYMBOL(nft_batch_iovec);
+EXPORT_SYMBOL(nftnl_batch_iovec, nft_batch_iovec);
diff --git a/src/chain.c b/src/chain.c
index 4f9c6b7..bb9fe90 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -91,7 +91,7 @@ struct nft_chain *nft_chain_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_chain));
 }
-EXPORT_SYMBOL(nft_chain_alloc);
+EXPORT_SYMBOL(nftnl_chain_alloc, nft_chain_alloc);
 
 void nft_chain_free(struct nft_chain *c)
 {
@@ -104,13 +104,13 @@ void nft_chain_free(struct nft_chain *c)
 
 	xfree(c);
 }
-EXPORT_SYMBOL(nft_chain_free);
+EXPORT_SYMBOL(nftnl_chain_free, nft_chain_free);
 
 bool nft_chain_attr_is_set(const struct nft_chain *c, uint16_t attr)
 {
 	return c->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_chain_attr_is_set);
+EXPORT_SYMBOL(nftnl_chain_attr_is_set, nft_chain_attr_is_set);
 
 void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 {
@@ -153,7 +153,7 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 
 	c->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_chain_attr_unset);
+EXPORT_SYMBOL(nftnl_chain_attr_unset, nft_chain_attr_unset);
 
 static uint32_t nft_chain_attr_validate[NFT_CHAIN_ATTR_MAX + 1] = {
 	[NFT_CHAIN_ATTR_HOOKNUM]	= sizeof(uint32_t),
@@ -222,43 +222,43 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 	}
 	c->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_chain_attr_set_data);
+EXPORT_SYMBOL(nftnl_chain_attr_set_data, nft_chain_attr_set_data);
 
 void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
 {
 	nft_chain_attr_set_data(c, attr, data, nft_chain_attr_validate[attr]);
 }
-EXPORT_SYMBOL(nft_chain_attr_set);
+EXPORT_SYMBOL(nftnl_chain_attr_set, nft_chain_attr_set);
 
 void nft_chain_attr_set_u32(struct nft_chain *c, uint16_t attr, uint32_t data)
 {
 	nft_chain_attr_set_data(c, attr, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_chain_attr_set_u32);
+EXPORT_SYMBOL(nftnl_chain_attr_set_u32, nft_chain_attr_set_u32);
 
 void nft_chain_attr_set_s32(struct nft_chain *c, uint16_t attr, int32_t data)
 {
 	nft_chain_attr_set_data(c, attr, &data, sizeof(int32_t));
 }
-EXPORT_SYMBOL(nft_chain_attr_set_s32);
+EXPORT_SYMBOL(nftnl_chain_attr_set_s32, nft_chain_attr_set_s32);
 
 void nft_chain_attr_set_u64(struct nft_chain *c, uint16_t attr, uint64_t data)
 {
 	nft_chain_attr_set_data(c, attr, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nft_chain_attr_set_u64);
+EXPORT_SYMBOL(nftnl_chain_attr_set_u64, nft_chain_attr_set_u64);
 
 void nft_chain_attr_set_u8(struct nft_chain *c, uint16_t attr, uint8_t data)
 {
 	nft_chain_attr_set_data(c, attr, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nft_chain_attr_set_u8);
+EXPORT_SYMBOL(nftnl_chain_attr_set_u8, nft_chain_attr_set_u8);
 
 void nft_chain_attr_set_str(struct nft_chain *c, uint16_t attr, const char *str)
 {
 	nft_chain_attr_set_data(c, attr, str, strlen(str));
 }
-EXPORT_SYMBOL(nft_chain_attr_set_str);
+EXPORT_SYMBOL(nftnl_chain_attr_set_str, nft_chain_attr_set_str);
 
 const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
 				    uint32_t *data_len)
@@ -303,20 +303,20 @@ const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_chain_attr_get_data);
+EXPORT_SYMBOL(nftnl_chain_attr_get_data, nft_chain_attr_get_data);
 
 const void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
 	return nft_chain_attr_get_data(c, attr, &data_len);
 }
-EXPORT_SYMBOL(nft_chain_attr_get);
+EXPORT_SYMBOL(nftnl_chain_attr_get, nft_chain_attr_get);
 
 const char *nft_chain_attr_get_str(struct nft_chain *c, uint16_t attr)
 {
 	return nft_chain_attr_get(c, attr);
 }
-EXPORT_SYMBOL(nft_chain_attr_get_str);
+EXPORT_SYMBOL(nftnl_chain_attr_get_str, nft_chain_attr_get_str);
 
 uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr)
 {
@@ -327,7 +327,7 @@ uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_chain_attr_get_u32);
+EXPORT_SYMBOL(nftnl_chain_attr_get_u32, nft_chain_attr_get_u32);
 
 int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr)
 {
@@ -338,7 +338,7 @@ int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_chain_attr_get_s32);
+EXPORT_SYMBOL(nftnl_chain_attr_get_s32, nft_chain_attr_get_s32);
 
 uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr)
 {
@@ -349,7 +349,7 @@ uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_chain_attr_get_u64);
+EXPORT_SYMBOL(nftnl_chain_attr_get_u64, nft_chain_attr_get_u64);
 
 uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
 {
@@ -360,7 +360,7 @@ uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_chain_attr_get_u8);
+EXPORT_SYMBOL(nftnl_chain_attr_get_u8, nft_chain_attr_get_u8);
 
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *c)
 {
@@ -397,7 +397,7 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 	if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
 }
-EXPORT_SYMBOL(nft_chain_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload, nft_chain_nlmsg_build_payload);
 
 static int nft_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -571,7 +571,7 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_chain_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_chain_nlmsg_parse, nft_chain_nlmsg_parse);
 
 static inline int nft_str2hooknum(int family, const char *hook)
 {
@@ -823,14 +823,14 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 {
 	return nft_chain_do_parse(c, type, data, err, NFT_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nft_chain_parse);
+EXPORT_SYMBOL(nftnl_chain_parse, nft_chain_parse);
 
 int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
 			 FILE *fp, struct nft_parse_err *err)
 {
 	return nft_chain_do_parse(c, type, fp, err, NFT_PARSE_FILE);
 }
-EXPORT_SYMBOL(nft_chain_parse_file);
+EXPORT_SYMBOL(nftnl_chain_parse_file, nft_chain_parse_file);
 
 static int nft_chain_export(char *buf, size_t size, struct nft_chain *c,
 			    int type)
@@ -932,7 +932,7 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 	return nft_chain_cmd_snprintf(buf, size, c, nft_flag2cmd(flags), type,
 				      flags);
 }
-EXPORT_SYMBOL(nft_chain_snprintf);
+EXPORT_SYMBOL(nftnl_chain_snprintf, nft_chain_snprintf);
 
 static inline int nft_chain_do_snprintf(char *buf, size_t size, void *c,
 					uint32_t cmd, uint32_t type,
@@ -947,7 +947,7 @@ int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type,
 	return nft_fprintf(fp, c, NFT_CMD_UNSPEC, type, flags,
 			   nft_chain_do_snprintf);
 }
-EXPORT_SYMBOL(nft_chain_fprintf);
+EXPORT_SYMBOL(nftnl_chain_fprintf, nft_chain_fprintf);
 
 struct nft_chain_list {
 	struct list_head list;
@@ -965,7 +965,7 @@ struct nft_chain_list *nft_chain_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nft_chain_list_alloc);
+EXPORT_SYMBOL(nftnl_chain_list_alloc, nft_chain_list_alloc);
 
 void nft_chain_list_free(struct nft_chain_list *list)
 {
@@ -977,31 +977,31 @@ void nft_chain_list_free(struct nft_chain_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nft_chain_list_free);
+EXPORT_SYMBOL(nftnl_chain_list_free, nft_chain_list_free);
 
 int nft_chain_list_is_empty(struct nft_chain_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nft_chain_list_is_empty);
+EXPORT_SYMBOL(nftnl_chain_list_is_empty, nft_chain_list_is_empty);
 
 void nft_chain_list_add(struct nft_chain *r, struct nft_chain_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_chain_list_add);
+EXPORT_SYMBOL(nftnl_chain_list_add, nft_chain_list_add);
 
 void nft_chain_list_add_tail(struct nft_chain *r, struct nft_chain_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_chain_list_add_tail);
+EXPORT_SYMBOL(nftnl_chain_list_add_tail, nft_chain_list_add_tail);
 
 void nft_chain_list_del(struct nft_chain *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL(nft_chain_list_del);
+EXPORT_SYMBOL(nftnl_chain_list_del, nft_chain_list_del);
 
 int nft_chain_list_foreach(struct nft_chain_list *chain_list,
 			   int (*cb)(struct nft_chain *r, void *data),
@@ -1017,7 +1017,7 @@ int nft_chain_list_foreach(struct nft_chain_list *chain_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_chain_list_foreach);
+EXPORT_SYMBOL(nftnl_chain_list_foreach, nft_chain_list_foreach);
 
 struct nft_chain_list_iter {
 	struct nft_chain_list	*list;
@@ -1040,7 +1040,7 @@ struct nft_chain_list_iter *nft_chain_list_iter_create(struct nft_chain_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_chain_list_iter_create);
+EXPORT_SYMBOL(nftnl_chain_list_iter_create, nft_chain_list_iter_create);
 
 struct nft_chain *nft_chain_list_iter_next(struct nft_chain_list_iter *iter)
 {
@@ -1056,10 +1056,10 @@ struct nft_chain *nft_chain_list_iter_next(struct nft_chain_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL(nft_chain_list_iter_next);
+EXPORT_SYMBOL(nftnl_chain_list_iter_next, nft_chain_list_iter_next);
 
 void nft_chain_list_iter_destroy(struct nft_chain_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_chain_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_chain_list_iter_destroy, nft_chain_list_iter_destroy);
diff --git a/src/common.c b/src/common.c
index d69b522..27f9177 100644
--- a/src/common.c
+++ b/src/common.c
@@ -40,7 +40,7 @@ struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 
 	return nlh;
 }
-EXPORT_SYMBOL(nft_nlmsg_build_hdr);
+EXPORT_SYMBOL(nftnl_nlmsg_build_hdr, nft_nlmsg_build_hdr);
 
 struct nft_parse_err *nft_parse_err_alloc(void)
 {
@@ -54,13 +54,13 @@ struct nft_parse_err *nft_parse_err_alloc(void)
 
 	return err;
 }
-EXPORT_SYMBOL(nft_parse_err_alloc);
+EXPORT_SYMBOL(nftnl_parse_err_alloc, nft_parse_err_alloc);
 
 void nft_parse_err_free(struct nft_parse_err *err)
 {
 	xfree(err);
 }
-EXPORT_SYMBOL(nft_parse_err_free);
+EXPORT_SYMBOL(nftnl_parse_err_free, nft_parse_err_free);
 
 int nft_parse_perror(const char *msg, struct nft_parse_err *err)
 {
@@ -80,7 +80,7 @@ int nft_parse_perror(const char *msg, struct nft_parse_err *err)
 		return fprintf(stderr, "%s: Undefined error\n", msg);
 	}
 }
-EXPORT_SYMBOL(nft_parse_perror);
+EXPORT_SYMBOL(nftnl_parse_perror, nft_parse_perror);
 
 int nft_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
 			    uint32_t flags)
@@ -178,13 +178,13 @@ void nft_batch_begin(char *buf, uint32_t seq)
 {
 	nft_batch_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, seq);
 }
-EXPORT_SYMBOL(nft_batch_begin);
+EXPORT_SYMBOL(nftnl_batch_begin, nft_batch_begin);
 
 void nft_batch_end(char *buf, uint32_t seq)
 {
 	nft_batch_build_hdr(buf, NFNL_MSG_BATCH_END, seq);
 }
-EXPORT_SYMBOL(nft_batch_end);
+EXPORT_SYMBOL(nftnl_batch_end, nft_batch_end);
 
 int nft_batch_is_supported(void)
 {
@@ -243,4 +243,4 @@ err:
 	mnl_nlmsg_batch_stop(b);
 	return -1;
 }
-EXPORT_SYMBOL(nft_batch_is_supported);
+EXPORT_SYMBOL(nftnl_batch_is_supported, nft_batch_is_supported);
diff --git a/src/expr.c b/src/expr.c
index 4109495..7731a85 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -43,7 +43,7 @@ struct nft_rule_expr *nft_rule_expr_alloc(const char *name)
 
 	return expr;
 }
-EXPORT_SYMBOL(nft_rule_expr_alloc);
+EXPORT_SYMBOL(nftnl_rule_expr_alloc, nft_rule_expr_alloc);
 
 void nft_rule_expr_free(struct nft_rule_expr *expr)
 {
@@ -52,13 +52,13 @@ void nft_rule_expr_free(struct nft_rule_expr *expr)
 
 	xfree(expr);
 }
-EXPORT_SYMBOL(nft_rule_expr_free);
+EXPORT_SYMBOL(nftnl_rule_expr_free, nft_rule_expr_free);
 
 bool nft_rule_expr_is_set(const struct nft_rule_expr *expr, uint16_t type)
 {
 	return expr->flags & (1 << type);
 }
-EXPORT_SYMBOL(nft_rule_expr_is_set);
+EXPORT_SYMBOL(nftnl_rule_expr_is_set, nft_rule_expr_is_set);
 
 void
 nft_rule_expr_set(struct nft_rule_expr *expr, uint16_t type,
@@ -73,42 +73,42 @@ nft_rule_expr_set(struct nft_rule_expr *expr, uint16_t type,
 	}
 	expr->flags |= (1 << type);
 }
-EXPORT_SYMBOL(nft_rule_expr_set);
+EXPORT_SYMBOL(nftnl_rule_expr_set, nft_rule_expr_set);
 
 void
 nft_rule_expr_set_u8(struct nft_rule_expr *expr, uint16_t type, uint8_t data)
 {
 	nft_rule_expr_set(expr, type, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nft_rule_expr_set_u8);
+EXPORT_SYMBOL(nftnl_rule_expr_set_u8, nft_rule_expr_set_u8);
 
 void
 nft_rule_expr_set_u16(struct nft_rule_expr *expr, uint16_t type, uint16_t data)
 {
 	nft_rule_expr_set(expr, type, &data, sizeof(uint16_t));
 }
-EXPORT_SYMBOL(nft_rule_expr_set_u16);
+EXPORT_SYMBOL(nftnl_rule_expr_set_u16, nft_rule_expr_set_u16);
 
 void
 nft_rule_expr_set_u32(struct nft_rule_expr *expr, uint16_t type, uint32_t data)
 {
 	nft_rule_expr_set(expr, type, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_rule_expr_set_u32);
+EXPORT_SYMBOL(nftnl_rule_expr_set_u32, nft_rule_expr_set_u32);
 
 void
 nft_rule_expr_set_u64(struct nft_rule_expr *expr, uint16_t type, uint64_t data)
 {
 	nft_rule_expr_set(expr, type, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nft_rule_expr_set_u64);
+EXPORT_SYMBOL(nftnl_rule_expr_set_u64, nft_rule_expr_set_u64);
 
 void
 nft_rule_expr_set_str(struct nft_rule_expr *expr, uint16_t type, const char *str)
 {
 	nft_rule_expr_set(expr, type, str, strlen(str)+1);
 }
-EXPORT_SYMBOL(nft_rule_expr_set_str);
+EXPORT_SYMBOL(nftnl_rule_expr_set_str, nft_rule_expr_set_str);
 
 const void *nft_rule_expr_get(const struct nft_rule_expr *expr,
 			      uint16_t type, uint32_t *data_len)
@@ -129,7 +129,7 @@ const void *nft_rule_expr_get(const struct nft_rule_expr *expr,
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_rule_expr_get);
+EXPORT_SYMBOL(nftnl_rule_expr_get, nft_rule_expr_get);
 
 uint8_t nft_rule_expr_get_u8(const struct nft_rule_expr *expr, uint16_t type)
 {
@@ -145,7 +145,7 @@ uint8_t nft_rule_expr_get_u8(const struct nft_rule_expr *expr, uint16_t type)
 
 	return *((uint8_t *)data);
 }
-EXPORT_SYMBOL(nft_rule_expr_get_u8);
+EXPORT_SYMBOL(nftnl_rule_expr_get_u8, nft_rule_expr_get_u8);
 
 uint16_t nft_rule_expr_get_u16(const struct nft_rule_expr *expr, uint16_t type)
 {
@@ -161,7 +161,7 @@ uint16_t nft_rule_expr_get_u16(const struct nft_rule_expr *expr, uint16_t type)
 
 	return *((uint16_t *)data);
 }
-EXPORT_SYMBOL(nft_rule_expr_get_u16);
+EXPORT_SYMBOL(nftnl_rule_expr_get_u16, nft_rule_expr_get_u16);
 
 uint32_t nft_rule_expr_get_u32(const struct nft_rule_expr *expr, uint16_t type)
 {
@@ -177,7 +177,7 @@ uint32_t nft_rule_expr_get_u32(const struct nft_rule_expr *expr, uint16_t type)
 
 	return *((uint32_t *)data);
 }
-EXPORT_SYMBOL(nft_rule_expr_get_u32);
+EXPORT_SYMBOL(nftnl_rule_expr_get_u32, nft_rule_expr_get_u32);
 
 uint64_t nft_rule_expr_get_u64(const struct nft_rule_expr *expr, uint16_t type)
 {
@@ -193,7 +193,7 @@ uint64_t nft_rule_expr_get_u64(const struct nft_rule_expr *expr, uint16_t type)
 
 	return *((uint64_t *)data);
 }
-EXPORT_SYMBOL(nft_rule_expr_get_u64);
+EXPORT_SYMBOL(nftnl_rule_expr_get_u64, nft_rule_expr_get_u64);
 
 const char *nft_rule_expr_get_str(const struct nft_rule_expr *expr, uint16_t type)
 {
@@ -201,7 +201,7 @@ const char *nft_rule_expr_get_str(const struct nft_rule_expr *expr, uint16_t typ
 
 	return (const char *)nft_rule_expr_get(expr, type, &data_len);
 }
-EXPORT_SYMBOL(nft_rule_expr_get_str);
+EXPORT_SYMBOL(nftnl_rule_expr_get_str, nft_rule_expr_get_str);
 
 void
 nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr)
@@ -273,4 +273,4 @@ int nft_rule_expr_snprintf(char *buf, size_t size, struct nft_rule_expr *expr,
 
 	return offset;
 }
-EXPORT_SYMBOL(nft_rule_expr_snprintf);
+EXPORT_SYMBOL(nftnl_rule_expr_snprintf, nft_rule_expr_snprintf);
diff --git a/src/gen.c b/src/gen.c
index 10a647a..2c9e561 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -33,19 +33,19 @@ struct nft_gen *nft_gen_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_gen));
 }
-EXPORT_SYMBOL(nft_gen_alloc);
+EXPORT_SYMBOL(nftnl_gen_alloc, nft_gen_alloc);
 
 void nft_gen_free(struct nft_gen *gen)
 {
 	xfree(gen);
 }
-EXPORT_SYMBOL(nft_gen_free);
+EXPORT_SYMBOL(nftnl_gen_free, nft_gen_free);
 
 bool nft_gen_attr_is_set(const struct nft_gen *gen, uint16_t attr)
 {
 	return gen->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_gen_attr_is_set);
+EXPORT_SYMBOL(nftnl_gen_attr_is_set, nft_gen_attr_is_set);
 
 void nft_gen_attr_unset(struct nft_gen *gen, uint16_t attr)
 {
@@ -58,7 +58,7 @@ void nft_gen_attr_unset(struct nft_gen *gen, uint16_t attr)
 	}
 	gen->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_gen_attr_unset);
+EXPORT_SYMBOL(nftnl_gen_attr_unset, nft_gen_attr_unset);
 
 static uint32_t nft_gen_attr_validate[NFT_GEN_MAX + 1] = {
 	[NFT_GEN_ID]	= sizeof(uint32_t),
@@ -79,19 +79,19 @@ void nft_gen_attr_set_data(struct nft_gen *gen, uint16_t attr,
 	}
 	gen->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_gen_attr_set_data);
+EXPORT_SYMBOL(nftnl_gen_attr_set_data, nft_gen_attr_set_data);
 
 void nft_gen_attr_set(struct nft_gen *gen, uint16_t attr, const void *data)
 {
 	nft_gen_attr_set_data(gen, attr, data, nft_gen_attr_validate[attr]);
 }
-EXPORT_SYMBOL(nft_gen_attr_set);
+EXPORT_SYMBOL(nftnl_gen_attr_set, nft_gen_attr_set);
 
 void nft_gen_attr_set_u32(struct nft_gen *gen, uint16_t attr, uint32_t val)
 {
 	nft_gen_attr_set_data(gen, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_gen_attr_set_u32);
+EXPORT_SYMBOL(nftnl_gen_attr_set_u32, nft_gen_attr_set_u32);
 
 const void *nft_gen_attr_get_data(struct nft_gen *gen, uint16_t attr,
 				  uint32_t *data_len)
@@ -105,21 +105,21 @@ const void *nft_gen_attr_get_data(struct nft_gen *gen, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_gen_attr_get_data);
+EXPORT_SYMBOL(nftnl_gen_attr_get_data, nft_gen_attr_get_data);
 
 const void *nft_gen_attr_get(struct nft_gen *gen, uint16_t attr)
 {
 	uint32_t data_len;
 	return nft_gen_attr_get_data(gen, attr, &data_len);
 }
-EXPORT_SYMBOL(nft_gen_attr_get);
+EXPORT_SYMBOL(nftnl_gen_attr_get, nft_gen_attr_get);
 
 uint32_t nft_gen_attr_get_u32(struct nft_gen *gen, uint16_t attr)
 {
 	const void *ret = nft_gen_attr_get(gen, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nft_gen_attr_get_u32);
+EXPORT_SYMBOL(nftnl_gen_attr_get_u32, nft_gen_attr_get_u32);
 
 static int nft_gen_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -154,7 +154,7 @@ int nft_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_gen *gen)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_gen_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_gen_nlmsg_parse, nft_gen_nlmsg_parse);
 
 static int nft_gen_snprintf_default(char *buf, size_t size, struct nft_gen *gen)
 {
@@ -190,7 +190,7 @@ int nft_gen_snprintf(char *buf, size_t size, struct nft_gen *gen, uint32_t type,
 	return nft_gen_cmd_snprintf(buf, size, gen, nft_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL(nft_gen_snprintf);
+EXPORT_SYMBOL(nftnl_gen_snprintf, nft_gen_snprintf);
 
 static inline int nft_gen_do_snprintf(char *buf, size_t size, void *gen,
 				      uint32_t cmd, uint32_t type,
@@ -205,4 +205,4 @@ int nft_gen_fprintf(FILE *fp, struct nft_gen *gen, uint32_t type,
 	return nft_fprintf(fp, gen, NFT_CMD_UNSPEC, type, flags,
 			   nft_gen_do_snprintf);
 }
-EXPORT_SYMBOL(nft_gen_fprintf);
+EXPORT_SYMBOL(nftnl_gen_fprintf, nft_gen_fprintf);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 4cd5982..3e069c8 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -196,6 +196,207 @@ global:
   nft_parse_err_free;
   nft_parse_perror;
 
+#
+# aliases
+#
+
+  nftnl_table_alloc;
+  nftnl_table_free;
+  nftnl_table_attr_is_set;
+  nftnl_table_attr_unset;
+  nftnl_table_attr_set;
+  nftnl_table_attr_get;
+  nftnl_table_attr_set_u8;
+  nftnl_table_attr_set_u32;
+  nftnl_table_attr_set_str;
+  nftnl_table_attr_get_u8;
+  nftnl_table_attr_get_u32;
+  nftnl_table_attr_get_str;
+  nftnl_table_parse;
+  nftnl_table_parse_file;
+  nftnl_table_snprintf;
+  nftnl_table_fprintf;
+  nftnl_table_nlmsg_build_payload;
+  nftnl_table_nlmsg_parse;
+  nftnl_table_list_alloc;
+  nftnl_table_list_free;
+  nftnl_table_list_is_empty;
+  nftnl_table_list_foreach;
+  nftnl_table_list_add;
+  nftnl_table_list_add_tail;
+  nftnl_table_list_del;
+  nftnl_table_list_iter_create;
+  nftnl_table_list_iter_next;
+  nftnl_table_list_iter_destroy;
+
+  nftnl_chain_alloc;
+  nftnl_chain_free;
+  nftnl_chain_attr_is_set;
+  nftnl_chain_attr_unset;
+  nftnl_chain_attr_set;
+  nftnl_chain_attr_set_u8;
+  nftnl_chain_attr_set_u32;
+  nftnl_chain_attr_set_s32;
+  nftnl_chain_attr_set_u64;
+  nftnl_chain_attr_set_str;
+  nftnl_chain_attr_get;
+  nftnl_chain_attr_get_u8;
+  nftnl_chain_attr_get_u32;
+  nftnl_chain_attr_get_s32;
+  nftnl_chain_attr_get_u64;
+  nftnl_chain_attr_get_str;
+  nftnl_chain_parse;
+  nftnl_chain_parse_file;
+  nftnl_chain_snprintf;
+  nftnl_chain_fprintf;
+  nftnl_chain_nlmsg_build_payload;
+  nftnl_chain_nlmsg_parse;
+  nftnl_chain_list_alloc;
+  nftnl_chain_list_free;
+  nftnl_chain_list_is_empty;
+  nftnl_chain_list_add;
+  nftnl_chain_list_add_tail;
+  nftnl_chain_list_del;
+  nftnl_chain_list_foreach;
+  nftnl_chain_list_iter_create;
+  nftnl_chain_list_iter_next;
+  nftnl_chain_list_iter_destroy;
+
+  nftnl_rule_alloc;
+  nftnl_rule_free;
+  nftnl_rule_attr_is_set;
+  nftnl_rule_attr_unset;
+  nftnl_rule_attr_set;
+  nftnl_rule_attr_set_u32;
+  nftnl_rule_attr_set_u64;
+  nftnl_rule_attr_set_str;
+  nftnl_rule_attr_get;
+  nftnl_rule_attr_get_u8;
+  nftnl_rule_attr_get_u32;
+  nftnl_rule_attr_get_u64;
+  nftnl_rule_attr_get_str;
+  nftnl_rule_parse;
+  nftnl_rule_parse_file;
+  nftnl_rule_snprintf;
+  nftnl_rule_fprintf;
+  nftnl_rule_nlmsg_build_payload;
+  nftnl_rule_nlmsg_parse;
+  nftnl_rule_add_expr;
+
+  nftnl_rule_expr_foreach;
+  nftnl_rule_expr_iter_create;
+  nftnl_rule_expr_iter_next;
+  nftnl_rule_expr_iter_destroy;
+
+  nftnl_rule_expr_alloc;
+  nftnl_rule_expr_is_set;
+  nftnl_rule_expr_set;
+  nftnl_rule_expr_set_u8;
+  nftnl_rule_expr_set_u16;
+  nftnl_rule_expr_set_u32;
+  nftnl_rule_expr_set_u64;
+  nftnl_rule_expr_set_str;
+  nftnl_rule_expr_get;
+  nftnl_rule_expr_get_u8;
+  nftnl_rule_expr_get_u16;
+  nftnl_rule_expr_get_u32;
+  nftnl_rule_expr_get_u64;
+  nftnl_rule_expr_get_str;
+  nftnl_rule_expr_snprintf;
+  nftnl_rule_expr_free;
+
+  nftnl_rule_list_alloc;
+  nftnl_rule_list_free;
+  nftnl_rule_list_is_empty;
+  nftnl_rule_list_add;
+  nftnl_rule_list_add_tail;
+  nftnl_rule_list_del;
+  nftnl_rule_list_foreach;
+  nftnl_rule_list_iter_create;
+  nftnl_rule_list_iter_cur;
+  nftnl_rule_list_iter_next;
+  nftnl_rule_list_iter_destroy;
+
+  nftnl_set_alloc;
+  nftnl_set_free;
+  nftnl_set_attr_unset;
+  nftnl_set_attr_is_set;
+  nftnl_set_attr_set;
+  nftnl_set_attr_set_u32;
+  nftnl_set_attr_set_u64;
+  nftnl_set_attr_set_str;
+  nftnl_set_attr_get;
+  nftnl_set_attr_get_str;
+  nftnl_set_attr_get_u32;
+  nftnl_set_attr_get_u64;
+  nftnl_set_nlmsg_build_payload;
+  nftnl_set_nlmsg_parse;
+  nftnl_set_parse;
+  nftnl_set_parse_file;
+  nftnl_set_snprintf;
+  nftnl_set_fprintf;
+
+  nftnl_set_list_alloc;
+  nftnl_set_list_free;
+  nftnl_set_list_add;
+  nftnl_set_list_add_tail;
+  nftnl_set_list_del;
+  nftnl_set_list_is_empty;
+  nftnl_set_list_foreach;
+
+  nftnl_set_list_iter_create;
+  nftnl_set_list_iter_cur;
+  nftnl_set_list_iter_next;
+  nftnl_set_list_iter_destroy;
+
+  nftnl_set_elem_alloc;
+  nftnl_set_elem_free;
+  nftnl_set_elem_add;
+  nftnl_set_elem_foreach;
+  nftnl_set_elem_attr_is_set;
+  nftnl_set_elem_attr_unset;
+  nftnl_set_elem_attr_set;
+  nftnl_set_elem_attr_set_u32;
+  nftnl_set_elem_attr_set_u64;
+  nftnl_set_elem_attr_set_str;
+  nftnl_set_elem_attr_get;
+  nftnl_set_elem_attr_get_str;
+  nftnl_set_elem_attr_get_u32;
+  nftnl_set_elem_attr_get_u64;
+  nftnl_set_elem_nlmsg_build_payload;
+  nftnl_set_elem_parse;
+  nftnl_set_elem_parse_file;
+  nftnl_set_elem_snprintf;
+  nftnl_set_elem_fprinf;
+
+  nftnl_set_elems_nlmsg_build_payload;
+  nftnl_set_elems_nlmsg_parse;
+
+  nftnl_set_elems_foreach;
+
+  nftnl_set_elems_iter_create;
+  nftnl_set_elems_iter_cur;
+  nftnl_set_elems_iter_next;
+  nftnl_set_elems_iter_destroy;
+
+  nftnl_ruleset_alloc;
+  nftnl_ruleset_free;
+  nftnl_ruleset_attr_is_set;
+  nftnl_ruleset_attr_unset;
+  nftnl_ruleset_attr_set;
+  nftnl_ruleset_attr_get;
+  nftnl_ruleset_parse;
+  nftnl_ruleset_parse_file;
+  nftnl_ruleset_snprintf;
+  nftnl_ruleset_fprintf;
+
+  nftnl_nlmsg_build_hdr;
+
+  nftnl_parse_err_alloc;
+  nftnl_parse_err_free;
+  nftnl_parse_perror;
+
+
 local: *;
 };
 
@@ -208,6 +409,20 @@ LIBNFTNL_1.1 {
   nft_rule_attr_get_data;
   nft_set_attr_set_data;
   nft_set_attr_get_data;
+
+#
+# aliases
+#
+
+  nftnl_table_attr_set_data;
+  nftnl_table_attr_get_data;
+  nftnl_chain_attr_set_data;
+  nftnl_chain_attr_get_data;
+  nftnl_rule_attr_set_data;
+  nftnl_rule_attr_get_data;
+  nftnl_set_attr_set_data;
+  nftnl_set_attr_get_data;
+
 } LIBNFTNL_1.0;
 
 LIBNFTNL_1.2 {
@@ -229,6 +444,31 @@ LIBNFTNL_1.2 {
   nft_gen_nlmsg_parse;
   nft_gen_snprintf;
   nft_gen_fprintf;
+
+#
+# aliases
+#
+
+  nftnl_set_elems_nlmsg_build_payload_iter;
+  nftnl_batch_is_supported;
+  nftnl_batch_begin;
+  nftnl_batch_end;
+
+  nftnl_gen_alloc;
+  nftnl_gen_free;
+  nftnl_gen_attr_is_set;
+  nftnl_gen_attr_unset;
+  nftnl_gen_attr_set_data;
+  nftnl_gen_attr_set;
+  nftnl_gen_attr_set_u32;
+  nftnl_gen_attr_get_data;
+  nftnl_gen_attr_get;
+  nftnl_gen_attr_get_u32;
+  nftnl_gen_nlmsg_parse;
+  nftnl_gen_snprintf;
+  nftnl_gen_fprintf;
+
+
 } LIBNFTNL_1.1;
 
 LIBNFTNL_1.2.0 {
@@ -246,4 +486,24 @@ LIBNFTNL_1.2.0 {
   nft_batch_buffer_len;
   nft_batch_iovec_len;
   nft_batch_iovec;
+
+#
+# aliases
+#
+
+  nftnl_ruleset_ctx_is_set;
+  nftnl_ruleset_ctx_get;
+  nftnl_ruleset_ctx_get_u32;
+  nftnl_ruleset_parse_file_cb;
+  nftnl_ruleset_parse_buffer_cb;
+  nftnl_ruleset_ctx_free;
+
+  nftnl_batch_alloc;
+  nftnl_batch_update;
+  nftnl_batch_free;
+  nftnl_batch_buffer;
+  nftnl_batch_buffer_len;
+  nftnl_batch_iovec_len;
+  nftnl_batch_iovec;
+
 } LIBNFTNL_1.2;
diff --git a/src/rule.c b/src/rule.c
index ebaa3ed..d47bc2c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -62,7 +62,7 @@ struct nft_rule *nft_rule_alloc(void)
 
 	return r;
 }
-EXPORT_SYMBOL(nft_rule_alloc);
+EXPORT_SYMBOL(nftnl_rule_alloc, nft_rule_alloc);
 
 void nft_rule_free(struct nft_rule *r)
 {
@@ -78,13 +78,13 @@ void nft_rule_free(struct nft_rule *r)
 
 	xfree(r);
 }
-EXPORT_SYMBOL(nft_rule_free);
+EXPORT_SYMBOL(nftnl_rule_free, nft_rule_free);
 
 bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_rule_attr_is_set);
+EXPORT_SYMBOL(nftnl_rule_attr_is_set, nft_rule_attr_is_set);
 
 void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 {
@@ -115,7 +115,7 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_rule_attr_unset);
+EXPORT_SYMBOL(nftnl_rule_attr_unset, nft_rule_attr_unset);
 
 static uint32_t nft_rule_attr_validate[NFT_RULE_ATTR_MAX + 1] = {
 	[NFT_RULE_ATTR_HANDLE]		= sizeof(uint64_t),
@@ -168,31 +168,31 @@ void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
 	}
 	r->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_rule_attr_set_data);
+EXPORT_SYMBOL(nftnl_rule_attr_set_data, nft_rule_attr_set_data);
 
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 {
 	nft_rule_attr_set_data(r, attr, data, nft_rule_attr_validate[attr]);
 }
-EXPORT_SYMBOL(nft_rule_attr_set);
+EXPORT_SYMBOL(nftnl_rule_attr_set, nft_rule_attr_set);
 
 void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val)
 {
 	nft_rule_attr_set_data(r, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_rule_attr_set_u32);
+EXPORT_SYMBOL(nftnl_rule_attr_set_u32, nft_rule_attr_set_u32);
 
 void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val)
 {
 	nft_rule_attr_set_data(r, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nft_rule_attr_set_u64);
+EXPORT_SYMBOL(nftnl_rule_attr_set_u64, nft_rule_attr_set_u64);
 
 void nft_rule_attr_set_str(struct nft_rule *r, uint16_t attr, const char *str)
 {
 	nft_rule_attr_set_data(r, attr, str, strlen(str));
 }
-EXPORT_SYMBOL(nft_rule_attr_set_str);
+EXPORT_SYMBOL(nftnl_rule_attr_set_str, nft_rule_attr_set_str);
 
 const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
 				   uint32_t *data_len)
@@ -226,20 +226,20 @@ const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_rule_attr_get_data);
+EXPORT_SYMBOL(nftnl_rule_attr_get_data, nft_rule_attr_get_data);
 
 const void *nft_rule_attr_get(const struct nft_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
 	return nft_rule_attr_get_data(r, attr, &data_len);
 }
-EXPORT_SYMBOL(nft_rule_attr_get);
+EXPORT_SYMBOL(nftnl_rule_attr_get, nft_rule_attr_get);
 
 const char *nft_rule_attr_get_str(const struct nft_rule *r, uint16_t attr)
 {
 	return nft_rule_attr_get(r, attr);
 }
-EXPORT_SYMBOL(nft_rule_attr_get_str);
+EXPORT_SYMBOL(nftnl_rule_attr_get_str, nft_rule_attr_get_str);
 
 uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr)
 {
@@ -250,7 +250,7 @@ uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_rule_attr_get_u32);
+EXPORT_SYMBOL(nftnl_rule_attr_get_u32, nft_rule_attr_get_u32);
 
 uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr)
 {
@@ -261,7 +261,7 @@ uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_rule_attr_get_u64);
+EXPORT_SYMBOL(nftnl_rule_attr_get_u64, nft_rule_attr_get_u64);
 
 uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr)
 {
@@ -272,7 +272,7 @@ uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_rule_attr_get_u8);
+EXPORT_SYMBOL(nftnl_rule_attr_get_u8, nft_rule_attr_get_u8);
 
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 {
@@ -313,13 +313,13 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 		mnl_attr_nest_end(nlh, nest);
 	}
 }
-EXPORT_SYMBOL(nft_rule_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_rule_nlmsg_build_payload, nft_rule_nlmsg_build_payload);
 
 void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr)
 {
 	list_add_tail(&expr->head, &r->expr_list);
 }
-EXPORT_SYMBOL(nft_rule_add_expr);
+EXPORT_SYMBOL(nftnl_rule_add_expr, nft_rule_add_expr);
 
 static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -468,7 +468,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_rule_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_rule_nlmsg_parse, nft_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
 int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
@@ -702,14 +702,14 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 {
 	return nft_rule_do_parse(r, type, data, err, NFT_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nft_rule_parse);
+EXPORT_SYMBOL(nftnl_rule_parse, nft_rule_parse);
 
 int nft_rule_parse_file(struct nft_rule *r, enum nft_parse_type type,
 			FILE *fp, struct nft_parse_err *err)
 {
 	return nft_rule_do_parse(r, type, fp, err, NFT_PARSE_FILE);
 }
-EXPORT_SYMBOL(nft_rule_parse_file);
+EXPORT_SYMBOL(nftnl_rule_parse_file, nft_rule_parse_file);
 
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 					 uint32_t type, uint32_t flags)
@@ -967,7 +967,7 @@ int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
 	return nft_rule_cmd_snprintf(buf, size, r, nft_flag2cmd(flags), type,
 				     flags);
 }
-EXPORT_SYMBOL(nft_rule_snprintf);
+EXPORT_SYMBOL(nftnl_rule_snprintf, nft_rule_snprintf);
 
 static inline int nft_rule_do_snprintf(char *buf, size_t size, void *r,
 				       uint32_t cmd, uint32_t type,
@@ -982,7 +982,7 @@ int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type,
 	return nft_fprintf(fp, r, NFT_CMD_UNSPEC, type, flags,
 			   nft_rule_do_snprintf);
 }
-EXPORT_SYMBOL(nft_rule_fprintf);
+EXPORT_SYMBOL(nftnl_rule_fprintf, nft_rule_fprintf);
 
 int nft_rule_expr_foreach(struct nft_rule *r,
                           int (*cb)(struct nft_rule_expr *e, void *data),
@@ -998,7 +998,7 @@ int nft_rule_expr_foreach(struct nft_rule *r,
        }
        return 0;
 }
-EXPORT_SYMBOL(nft_rule_expr_foreach);
+EXPORT_SYMBOL(nftnl_rule_expr_foreach, nft_rule_expr_foreach);
 
 struct nft_rule_expr_iter {
 	struct nft_rule		*r;
@@ -1022,7 +1022,7 @@ struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_rule_expr_iter_create);
+EXPORT_SYMBOL(nftnl_rule_expr_iter_create, nft_rule_expr_iter_create);
 
 struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter)
 {
@@ -1038,13 +1038,13 @@ struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter)
 
 	return expr;
 }
-EXPORT_SYMBOL(nft_rule_expr_iter_next);
+EXPORT_SYMBOL(nftnl_rule_expr_iter_next, nft_rule_expr_iter_next);
 
 void nft_rule_expr_iter_destroy(struct nft_rule_expr_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_rule_expr_iter_destroy);
+EXPORT_SYMBOL(nftnl_rule_expr_iter_destroy, nft_rule_expr_iter_destroy);
 
 struct nft_rule_list {
 	struct list_head list;
@@ -1062,7 +1062,7 @@ struct nft_rule_list *nft_rule_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nft_rule_list_alloc);
+EXPORT_SYMBOL(nftnl_rule_list_alloc, nft_rule_list_alloc);
 
 void nft_rule_list_free(struct nft_rule_list *list)
 {
@@ -1074,31 +1074,31 @@ void nft_rule_list_free(struct nft_rule_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nft_rule_list_free);
+EXPORT_SYMBOL(nftnl_rule_list_free, nft_rule_list_free);
 
 int nft_rule_list_is_empty(struct nft_rule_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nft_rule_list_is_empty);
+EXPORT_SYMBOL(nftnl_rule_list_is_empty, nft_rule_list_is_empty);
 
 void nft_rule_list_add(struct nft_rule *r, struct nft_rule_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_rule_list_add);
+EXPORT_SYMBOL(nftnl_rule_list_add, nft_rule_list_add);
 
 void nft_rule_list_add_tail(struct nft_rule *r, struct nft_rule_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_rule_list_add_tail);
+EXPORT_SYMBOL(nftnl_rule_list_add_tail, nft_rule_list_add_tail);
 
 void nft_rule_list_del(struct nft_rule *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL(nft_rule_list_del);
+EXPORT_SYMBOL(nftnl_rule_list_del, nft_rule_list_del);
 
 int nft_rule_list_foreach(struct nft_rule_list *rule_list,
 			  int (*cb)(struct nft_rule *r, void *data),
@@ -1114,7 +1114,7 @@ int nft_rule_list_foreach(struct nft_rule_list *rule_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_rule_list_foreach);
+EXPORT_SYMBOL(nftnl_rule_list_foreach, nft_rule_list_foreach);
 
 struct nft_rule_list_iter {
 	struct nft_rule_list	*list;
@@ -1137,13 +1137,13 @@ struct nft_rule_list_iter *nft_rule_list_iter_create(struct nft_rule_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_rule_list_iter_create);
+EXPORT_SYMBOL(nftnl_rule_list_iter_create, nft_rule_list_iter_create);
 
 struct nft_rule *nft_rule_list_iter_cur(struct nft_rule_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nft_rule_list_iter_cur);
+EXPORT_SYMBOL(nftnl_rule_list_iter_cur, nft_rule_list_iter_cur);
 
 struct nft_rule *nft_rule_list_iter_next(struct nft_rule_list_iter *iter)
 {
@@ -1159,10 +1159,10 @@ struct nft_rule *nft_rule_list_iter_next(struct nft_rule_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL(nft_rule_list_iter_next);
+EXPORT_SYMBOL(nftnl_rule_list_iter_next, nft_rule_list_iter_next);
 
 void nft_rule_list_iter_destroy(struct nft_rule_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_rule_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_rule_list_iter_destroy, nft_rule_list_iter_destroy);
diff --git a/src/ruleset.c b/src/ruleset.c
index e7f9204..42fe9e6 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -62,7 +62,7 @@ struct nft_ruleset *nft_ruleset_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_ruleset));
 }
-EXPORT_SYMBOL(nft_ruleset_alloc);
+EXPORT_SYMBOL(nftnl_ruleset_alloc, nft_ruleset_alloc);
 
 void nft_ruleset_free(struct nft_ruleset *r)
 {
@@ -76,13 +76,13 @@ void nft_ruleset_free(struct nft_ruleset *r)
 		nft_rule_list_free(r->rule_list);
 	xfree(r);
 }
-EXPORT_SYMBOL(nft_ruleset_free);
+EXPORT_SYMBOL(nftnl_ruleset_free, nft_ruleset_free);
 
 bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_ruleset_attr_is_set);
+EXPORT_SYMBOL(nftnl_ruleset_attr_is_set, nft_ruleset_attr_is_set);
 
 void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr)
 {
@@ -109,7 +109,7 @@ void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr)
 	}
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_ruleset_attr_unset);
+EXPORT_SYMBOL(nftnl_ruleset_attr_unset, nft_ruleset_attr_unset);
 
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data)
 {
@@ -135,7 +135,7 @@ void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data)
 	}
 	r->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_ruleset_attr_set);
+EXPORT_SYMBOL(nftnl_ruleset_attr_set, nft_ruleset_attr_set);
 
 void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 {
@@ -155,7 +155,7 @@ void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(nft_ruleset_attr_get);
+EXPORT_SYMBOL(nftnl_ruleset_attr_get, nft_ruleset_attr_get);
 
 void nft_ruleset_ctx_free(const struct nft_parse_ctx *ctx)
 {
@@ -178,13 +178,13 @@ void nft_ruleset_ctx_free(const struct nft_parse_ctx *ctx)
 		break;
 	}
 }
-EXPORT_SYMBOL(nft_ruleset_ctx_free);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_free, nft_ruleset_ctx_free);
 
 bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr)
 {
 	return ctx->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_ruleset_ctx_is_set);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_is_set, nft_ruleset_ctx_is_set);
 
 void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr)
 {
@@ -210,14 +210,14 @@ void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(nft_ruleset_ctx_get);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get, nft_ruleset_ctx_get);
 
 uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx, uint16_t attr)
 {
 	const void *ret = nft_ruleset_ctx_get(ctx, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nft_ruleset_ctx_get_u32);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get_u32, nft_ruleset_ctx_get_u32);
 
 #if defined(JSON_PARSING) || defined(XML_PARSING)
 static void nft_ruleset_ctx_set(struct nft_parse_ctx *ctx, uint16_t attr,
@@ -751,7 +751,7 @@ int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
 {
 	return nft_ruleset_do_parse(type, fp, err, NFT_PARSE_FILE, data, cb);
 }
-EXPORT_SYMBOL(nft_ruleset_parse_file_cb);
+EXPORT_SYMBOL(nftnl_ruleset_parse_file_cb, nft_ruleset_parse_file_cb);
 
 int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
 				struct nft_parse_err *err, void *data,
@@ -760,7 +760,7 @@ int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
 	return nft_ruleset_do_parse(type, buffer, err, NFT_PARSE_BUFFER, data,
 				    cb);
 }
-EXPORT_SYMBOL(nft_ruleset_parse_buffer_cb);
+EXPORT_SYMBOL(nftnl_ruleset_parse_buffer_cb, nft_ruleset_parse_buffer_cb);
 
 static int nft_ruleset_cb(const struct nft_parse_ctx *ctx)
 {
@@ -828,14 +828,14 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 {
 	return nft_ruleset_parse_buffer_cb(type, data, err, r, nft_ruleset_cb);
 }
-EXPORT_SYMBOL(nft_ruleset_parse);
+EXPORT_SYMBOL(nftnl_ruleset_parse, nft_ruleset_parse);
 
 int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
 			   FILE *fp, struct nft_parse_err *err)
 {
 	return nft_ruleset_parse_file_cb(type, fp, err, rs, nft_ruleset_cb);
 }
-EXPORT_SYMBOL(nft_ruleset_parse_file);
+EXPORT_SYMBOL(nftnl_ruleset_parse_file, nft_ruleset_parse_file);
 
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
@@ -1097,7 +1097,7 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 		return -1;
 	}
 }
-EXPORT_SYMBOL(nft_ruleset_snprintf);
+EXPORT_SYMBOL(nftnl_ruleset_snprintf, nft_ruleset_snprintf);
 
 static int nft_ruleset_fprintf_tables(FILE *fp, const struct nft_ruleset *rs,
 				      uint32_t type, uint32_t flags)
@@ -1317,4 +1317,4 @@ int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
 	return nft_ruleset_cmd_fprintf(fp, rs, nft_flag2cmd(flags), type,
 				       flags);
 }
-EXPORT_SYMBOL(nft_ruleset_fprintf);
+EXPORT_SYMBOL(nftnl_ruleset_fprintf, nft_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index 1782f72..2df6b93 100644
--- a/src/set.c
+++ b/src/set.c
@@ -38,7 +38,7 @@ struct nft_set *nft_set_alloc(void)
 	INIT_LIST_HEAD(&s->element_list);
 	return s;
 }
-EXPORT_SYMBOL(nft_set_alloc);
+EXPORT_SYMBOL(nftnl_set_alloc, nft_set_alloc);
 
 void nft_set_free(struct nft_set *s)
 {
@@ -55,13 +55,13 @@ void nft_set_free(struct nft_set *s)
 	}
 	xfree(s);
 }
-EXPORT_SYMBOL(nft_set_free);
+EXPORT_SYMBOL(nftnl_set_free, nft_set_free);
 
 bool nft_set_attr_is_set(const struct nft_set *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_set_attr_is_set);
+EXPORT_SYMBOL(nftnl_set_attr_is_set, nft_set_attr_is_set);
 
 void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 {
@@ -98,7 +98,7 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_set_attr_unset);
+EXPORT_SYMBOL(nftnl_set_attr_unset, nft_set_attr_unset);
 
 static uint32_t nft_set_attr_validate[NFT_SET_ATTR_MAX + 1] = {
 	[NFT_SET_ATTR_FLAGS]		= sizeof(uint32_t),
@@ -170,31 +170,31 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	}
 	s->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_set_attr_set_data);
+EXPORT_SYMBOL(nftnl_set_attr_set_data, nft_set_attr_set_data);
 
 void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 {
 	nft_set_attr_set_data(s, attr, data, nft_set_attr_validate[attr]);
 }
-EXPORT_SYMBOL(nft_set_attr_set);
+EXPORT_SYMBOL(nftnl_set_attr_set, nft_set_attr_set);
 
 void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val)
 {
 	nft_set_attr_set(s, attr, &val);
 }
-EXPORT_SYMBOL(nft_set_attr_set_u32);
+EXPORT_SYMBOL(nftnl_set_attr_set_u32, nft_set_attr_set_u32);
 
 void nft_set_attr_set_u64(struct nft_set *s, uint16_t attr, uint64_t val)
 {
 	nft_set_attr_set(s, attr, &val);
 }
-EXPORT_SYMBOL(nft_set_attr_set_u64);
+EXPORT_SYMBOL(nftnl_set_attr_set_u64, nft_set_attr_set_u64);
 
 void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str)
 {
 	nft_set_attr_set(s, attr, str);
 }
-EXPORT_SYMBOL(nft_set_attr_set_str);
+EXPORT_SYMBOL(nftnl_set_attr_set_str, nft_set_attr_set_str);
 
 const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 				  uint32_t *data_len)
@@ -243,20 +243,20 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_set_attr_get_data);
+EXPORT_SYMBOL(nftnl_set_attr_get_data, nft_set_attr_get_data);
 
 const void *nft_set_attr_get(struct nft_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	return nft_set_attr_get_data(s, attr, &data_len);
 }
-EXPORT_SYMBOL(nft_set_attr_get);
+EXPORT_SYMBOL(nftnl_set_attr_get, nft_set_attr_get);
 
 const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr)
 {
 	return nft_set_attr_get(s, attr);
 }
-EXPORT_SYMBOL(nft_set_attr_get_str);
+EXPORT_SYMBOL(nftnl_set_attr_get_str, nft_set_attr_get_str);
 
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 {
@@ -267,7 +267,7 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_set_attr_get_u32);
+EXPORT_SYMBOL(nftnl_set_attr_get_u32, nft_set_attr_get_u32);
 
 uint64_t nft_set_attr_get_u64(struct nft_set *s, uint16_t attr)
 {
@@ -278,7 +278,7 @@ uint64_t nft_set_attr_get_u64(struct nft_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nft_set_attr_get_u64);
+EXPORT_SYMBOL(nftnl_set_attr_get_u64, nft_set_attr_get_u64);
 
 struct nft_set *nft_set_clone(const struct nft_set *set)
 {
@@ -349,7 +349,7 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 	if (s->flags & (1 << NFT_SET_ATTR_GC_INTERVAL))
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 }
-EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload, nft_set_nlmsg_build_payload);
 
 static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -488,7 +488,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_set_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_set_nlmsg_parse, nft_set_nlmsg_parse);
 
 #ifdef JSON_PARSING
 static int nft_jansson_parse_set_info(struct nft_set *s, json_t *tree,
@@ -762,14 +762,14 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 {
 	return nft_set_do_parse(s, type, data, err, NFT_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nft_set_parse);
+EXPORT_SYMBOL(nftnl_set_parse, nft_set_parse);
 
 int nft_set_parse_file(struct nft_set *s, enum nft_parse_type type,
 		       FILE *fp, struct nft_parse_err *err)
 {
 	return nft_set_do_parse(s, type, fp, err, NFT_PARSE_FILE);
 }
-EXPORT_SYMBOL(nft_set_parse_file);
+EXPORT_SYMBOL(nftnl_set_parse_file, nft_set_parse_file);
 
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 				  uint32_t type, uint32_t flags)
@@ -1036,7 +1036,7 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 	return nft_set_cmd_snprintf(buf, size, s, nft_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL(nft_set_snprintf);
+EXPORT_SYMBOL(nftnl_set_snprintf, nft_set_snprintf);
 
 static inline int nft_set_do_snprintf(char *buf, size_t size, void *s,
 				      uint32_t cmd, uint32_t type,
@@ -1051,13 +1051,13 @@ int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type,
 	return nft_fprintf(fp, s, NFT_CMD_UNSPEC, type, flags,
 			   nft_set_do_snprintf);
 }
-EXPORT_SYMBOL(nft_set_fprintf);
+EXPORT_SYMBOL(nftnl_set_fprintf, nft_set_fprintf);
 
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)
 {
 	list_add_tail(&elem->head, &s->element_list);
 }
-EXPORT_SYMBOL(nft_set_elem_add);
+EXPORT_SYMBOL(nftnl_set_elem_add, nft_set_elem_add);
 
 struct nft_set_list {
 	struct list_head list;
@@ -1075,7 +1075,7 @@ struct nft_set_list *nft_set_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nft_set_list_alloc);
+EXPORT_SYMBOL(nftnl_set_list_alloc, nft_set_list_alloc);
 
 void nft_set_list_free(struct nft_set_list *list)
 {
@@ -1087,31 +1087,31 @@ void nft_set_list_free(struct nft_set_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nft_set_list_free);
+EXPORT_SYMBOL(nftnl_set_list_free, nft_set_list_free);
 
 int nft_set_list_is_empty(struct nft_set_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nft_set_list_is_empty);
+EXPORT_SYMBOL(nftnl_set_list_is_empty, nft_set_list_is_empty);
 
 void nft_set_list_add(struct nft_set *s, struct nft_set_list *list)
 {
 	list_add(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nft_set_list_add);
+EXPORT_SYMBOL(nftnl_set_list_add, nft_set_list_add);
 
 void nft_set_list_add_tail(struct nft_set *s, struct nft_set_list *list)
 {
 	list_add_tail(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nft_set_list_add_tail);
+EXPORT_SYMBOL(nftnl_set_list_add_tail, nft_set_list_add_tail);
 
 void nft_set_list_del(struct nft_set *s)
 {
 	list_del(&s->head);
 }
-EXPORT_SYMBOL(nft_set_list_del);
+EXPORT_SYMBOL(nftnl_set_list_del, nft_set_list_del);
 
 int nft_set_list_foreach(struct nft_set_list *set_list,
 			 int (*cb)(struct nft_set *t, void *data), void *data)
@@ -1126,7 +1126,7 @@ int nft_set_list_foreach(struct nft_set_list *set_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_set_list_foreach);
+EXPORT_SYMBOL(nftnl_set_list_foreach, nft_set_list_foreach);
 
 struct nft_set_list_iter {
 	struct nft_set_list	*list;
@@ -1149,13 +1149,13 @@ struct nft_set_list_iter *nft_set_list_iter_create(struct nft_set_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_set_list_iter_create);
+EXPORT_SYMBOL(nftnl_set_list_iter_create, nft_set_list_iter_create);
 
 struct nft_set *nft_set_list_iter_cur(struct nft_set_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nft_set_list_iter_cur);
+EXPORT_SYMBOL(nftnl_set_list_iter_cur, nft_set_list_iter_cur);
 
 struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)
 {
@@ -1171,13 +1171,13 @@ struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)
 
 	return s;
 }
-EXPORT_SYMBOL(nft_set_list_iter_next);
+EXPORT_SYMBOL(nftnl_set_list_iter_next, nft_set_list_iter_next);
 
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_set_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_set_list_iter_destroy, nft_set_list_iter_destroy);
 
 static struct nft_set *nft_set_lookup(const char *this_set_name,
 				      struct nft_set_list *set_list)
diff --git a/src/set_elem.c b/src/set_elem.c
index 643dd76..a130cc3 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -37,7 +37,7 @@ struct nft_set_elem *nft_set_elem_alloc(void)
 
 	return s;
 }
-EXPORT_SYMBOL(nft_set_elem_alloc);
+EXPORT_SYMBOL(nftnl_set_elem_alloc, nft_set_elem_alloc);
 
 void nft_set_elem_free(struct nft_set_elem *s)
 {
@@ -53,13 +53,13 @@ void nft_set_elem_free(struct nft_set_elem *s)
 
 	xfree(s);
 }
-EXPORT_SYMBOL(nft_set_elem_free);
+EXPORT_SYMBOL(nftnl_set_elem_free, nft_set_elem_free);
 
 bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_set_elem_attr_is_set);
+EXPORT_SYMBOL(nftnl_set_elem_attr_is_set, nft_set_elem_attr_is_set);
 
 void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 {
@@ -92,7 +92,7 @@ void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_set_elem_attr_unset);
+EXPORT_SYMBOL(nftnl_set_elem_attr_unset, nft_set_elem_attr_unset);
 
 void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 			   const void *data, uint32_t data_len)
@@ -130,25 +130,25 @@ void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 	}
 	s->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_set_elem_attr_set);
+EXPORT_SYMBOL(nftnl_set_elem_attr_set, nft_set_elem_attr_set);
 
 void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t val)
 {
 	nft_set_elem_attr_set(s, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_set_elem_attr_set_u32);
+EXPORT_SYMBOL(nftnl_set_elem_attr_set_u32, nft_set_elem_attr_set_u32);
 
 void nft_set_elem_attr_set_u64(struct nft_set_elem *s, uint16_t attr, uint64_t val)
 {
 	nft_set_elem_attr_set(s, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nft_set_elem_attr_set_u64);
+EXPORT_SYMBOL(nftnl_set_elem_attr_set_u64, nft_set_elem_attr_set_u64);
 
 void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str)
 {
 	nft_set_elem_attr_set(s, attr, str, strlen(str));
 }
-EXPORT_SYMBOL(nft_set_elem_attr_set_str);
+EXPORT_SYMBOL(nftnl_set_elem_attr_set_str, nft_set_elem_attr_set_str);
 
 const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_t *data_len)
 {
@@ -180,7 +180,7 @@ const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_set_elem_attr_get);
+EXPORT_SYMBOL(nftnl_set_elem_attr_get, nft_set_elem_attr_get);
 
 const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr)
 {
@@ -188,7 +188,7 @@ const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr)
 
 	return nft_set_elem_attr_get(s, attr, &size);
 }
-EXPORT_SYMBOL(nft_set_elem_attr_get_str);
+EXPORT_SYMBOL(nftnl_set_elem_attr_get_str, nft_set_elem_attr_get_str);
 
 uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
 {
@@ -196,7 +196,7 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
 	uint32_t val = *((uint32_t *)nft_set_elem_attr_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL(nft_set_elem_attr_get_u32);
+EXPORT_SYMBOL(nftnl_set_elem_attr_get_u32, nft_set_elem_attr_get_u32);
 
 uint64_t nft_set_elem_attr_get_u64(struct nft_set_elem *s, uint16_t attr)
 {
@@ -204,7 +204,7 @@ uint64_t nft_set_elem_attr_get_u64(struct nft_set_elem *s, uint16_t attr)
 	uint64_t val = *((uint64_t *)nft_set_elem_attr_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL(nft_set_elem_attr_get_u64);
+EXPORT_SYMBOL(nftnl_set_elem_attr_get_u64, nft_set_elem_attr_get_u64);
 
 struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem)
 {
@@ -296,7 +296,7 @@ void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 
 	mnl_attr_nest_end(nlh, nest1);
 }
-EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload, nft_set_elems_nlmsg_build_payload);
 
 static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -485,7 +485,7 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_parse, nft_set_elems_nlmsg_parse);
 
 #ifdef XML_PARSING
 int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
@@ -589,14 +589,14 @@ int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
 {
 	return nft_set_elem_do_parse(e, type, data, err, NFT_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nft_set_elem_parse);
+EXPORT_SYMBOL(nftnl_set_elem_parse, nft_set_elem_parse);
 
 int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
 			    FILE *fp, struct nft_parse_err *err)
 {
 	return nft_set_elem_do_parse(e, type, fp, err, NFT_PARSE_FILE);
 }
-EXPORT_SYMBOL(nft_set_elem_parse_file);
+EXPORT_SYMBOL(nftnl_set_elem_parse_file, nft_set_elem_parse_file);
 
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
 				      struct nft_set_elem *e, uint32_t flags)
@@ -771,7 +771,7 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 	return nft_set_elem_cmd_snprintf(buf, size, e, nft_flag2cmd(flags),
 					 type, flags);
 }
-EXPORT_SYMBOL(nft_set_elem_snprintf);
+EXPORT_SYMBOL(nftnl_set_elem_snprintf, nft_set_elem_snprintf);
 
 static inline int nft_set_elem_do_snprintf(char *buf, size_t size, void *e,
 					   uint32_t cmd, uint32_t type,
@@ -786,7 +786,7 @@ int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type,
 	return nft_fprintf(fp, se, NFT_CMD_UNSPEC, type, flags,
 			   nft_set_elem_do_snprintf);
 }
-EXPORT_SYMBOL(nft_set_elem_fprintf);
+EXPORT_SYMBOL(nftnl_set_elem_fprintf, nft_set_elem_fprintf);
 
 int nft_set_elem_foreach(struct nft_set *s,
 			 int (*cb)(struct nft_set_elem *e, void *data),
@@ -802,7 +802,7 @@ int nft_set_elem_foreach(struct nft_set *s,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_set_elem_foreach);
+EXPORT_SYMBOL(nftnl_set_elem_foreach, nft_set_elem_foreach);
 
 struct nft_set_elems_iter {
 	struct nft_set			*set;
@@ -828,13 +828,13 @@ struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_set_elems_iter_create);
+EXPORT_SYMBOL(nftnl_set_elems_iter_create, nft_set_elems_iter_create);
 
 struct nft_set_elem *nft_set_elems_iter_cur(struct nft_set_elems_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nft_set_elems_iter_cur);
+EXPORT_SYMBOL(nftnl_set_elems_iter_cur, nft_set_elems_iter_cur);
 
 struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter)
 {
@@ -849,13 +849,13 @@ struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter)
 
 	return s;
 }
-EXPORT_SYMBOL(nft_set_elems_iter_next);
+EXPORT_SYMBOL(nftnl_set_elems_iter_next, nft_set_elems_iter_next);
 
 void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_set_elems_iter_destroy);
+EXPORT_SYMBOL(nftnl_set_elems_iter_destroy, nft_set_elems_iter_destroy);
 
 static bool nft_attr_nest_overflow(struct nlmsghdr *nlh,
 				   const struct nlattr *from,
@@ -900,4 +900,4 @@ int nft_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload_iter);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload_iter, nft_set_elems_nlmsg_build_payload_iter);
diff --git a/src/table.c b/src/table.c
index 09470e0..543ea8d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -40,7 +40,7 @@ struct nft_table *nft_table_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_table));
 }
-EXPORT_SYMBOL(nft_table_alloc);
+EXPORT_SYMBOL(nftnl_table_alloc, nft_table_alloc);
 
 void nft_table_free(struct nft_table *t)
 {
@@ -49,13 +49,13 @@ void nft_table_free(struct nft_table *t)
 
 	xfree(t);
 }
-EXPORT_SYMBOL(nft_table_free);
+EXPORT_SYMBOL(nftnl_table_free, nft_table_free);
 
 bool nft_table_attr_is_set(const struct nft_table *t, uint16_t attr)
 {
 	return t->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nft_table_attr_is_set);
+EXPORT_SYMBOL(nftnl_table_attr_is_set, nft_table_attr_is_set);
 
 void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 {
@@ -77,7 +77,7 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 	}
 	t->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nft_table_attr_unset);
+EXPORT_SYMBOL(nftnl_table_attr_unset, nft_table_attr_unset);
 
 static uint32_t nft_table_attr_validate[NFT_TABLE_ATTR_MAX + 1] = {
 	[NFT_TABLE_ATTR_FLAGS]	= sizeof(uint32_t),
@@ -111,31 +111,31 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 	}
 	t->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nft_table_attr_set_data);
+EXPORT_SYMBOL(nftnl_table_attr_set_data, nft_table_attr_set_data);
 
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
 {
 	nft_table_attr_set_data(t, attr, data, nft_table_attr_validate[attr]);
 }
-EXPORT_SYMBOL(nft_table_attr_set);
+EXPORT_SYMBOL(nftnl_table_attr_set, nft_table_attr_set);
 
 void nft_table_attr_set_u32(struct nft_table *t, uint16_t attr, uint32_t val)
 {
 	nft_table_attr_set_data(t, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nft_table_attr_set_u32);
+EXPORT_SYMBOL(nftnl_table_attr_set_u32, nft_table_attr_set_u32);
 
 void nft_table_attr_set_u8(struct nft_table *t, uint16_t attr, uint8_t val)
 {
 	nft_table_attr_set_data(t, attr, &val, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nft_table_attr_set_u8);
+EXPORT_SYMBOL(nftnl_table_attr_set_u8, nft_table_attr_set_u8);
 
 void nft_table_attr_set_str(struct nft_table *t, uint16_t attr, const char *str)
 {
 	nft_table_attr_set_data(t, attr, str, 0);
 }
-EXPORT_SYMBOL(nft_table_attr_set_str);
+EXPORT_SYMBOL(nftnl_table_attr_set_str, nft_table_attr_set_str);
 
 const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
 				    uint32_t *data_len)
@@ -158,34 +158,34 @@ const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nft_table_attr_get_data);
+EXPORT_SYMBOL(nftnl_table_attr_get_data, nft_table_attr_get_data);
 
 const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
 {
 	uint32_t data_len;
 	return nft_table_attr_get_data(t, attr, &data_len);
 }
-EXPORT_SYMBOL(nft_table_attr_get);
+EXPORT_SYMBOL(nftnl_table_attr_get, nft_table_attr_get);
 
 uint32_t nft_table_attr_get_u32(struct nft_table *t, uint16_t attr)
 {
 	const void *ret = nft_table_attr_get(t, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nft_table_attr_get_u32);
+EXPORT_SYMBOL(nftnl_table_attr_get_u32, nft_table_attr_get_u32);
 
 uint8_t nft_table_attr_get_u8(struct nft_table *t, uint16_t attr)
 {
 	const void *ret = nft_table_attr_get(t, attr);
 	return ret == NULL ? 0 : *((uint8_t *)ret);
 }
-EXPORT_SYMBOL(nft_table_attr_get_u8);
+EXPORT_SYMBOL(nftnl_table_attr_get_u8, nft_table_attr_get_u8);
 
 const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr)
 {
 	return nft_table_attr_get(t, attr);
 }
-EXPORT_SYMBOL(nft_table_attr_get_str);
+EXPORT_SYMBOL(nftnl_table_attr_get_str, nft_table_attr_get_str);
 
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t)
 {
@@ -194,7 +194,7 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
 }
-EXPORT_SYMBOL(nft_table_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_table_nlmsg_build_payload, nft_table_nlmsg_build_payload);
 
 static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -247,7 +247,7 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 
 	return 0;
 }
-EXPORT_SYMBOL(nft_table_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_table_nlmsg_parse, nft_table_nlmsg_parse);
 
 #ifdef XML_PARSING
 int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
@@ -384,14 +384,14 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 {
 	return nft_table_do_parse(t, type, data, err, NFT_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nft_table_parse);
+EXPORT_SYMBOL(nftnl_table_parse, nft_table_parse);
 
 int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
 			 FILE *fp, struct nft_parse_err *err)
 {
 	return nft_table_do_parse(t, type, fp, err, NFT_PARSE_FILE);
 }
-EXPORT_SYMBOL(nft_table_parse_file);
+EXPORT_SYMBOL(nftnl_table_parse_file, nft_table_parse_file);
 
 static int nft_table_export(char *buf, size_t size, struct nft_table *t,
 			    int type)
@@ -453,7 +453,7 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 	return nft_table_cmd_snprintf(buf, size, t, nft_flag2cmd(flags), type,
 				      flags);
 }
-EXPORT_SYMBOL(nft_table_snprintf);
+EXPORT_SYMBOL(nftnl_table_snprintf, nft_table_snprintf);
 
 static inline int nft_table_do_snprintf(char *buf, size_t size, void *t,
 					uint32_t cmd, uint32_t type,
@@ -468,7 +468,7 @@ int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type,
 	return nft_fprintf(fp, t, NFT_CMD_UNSPEC, type, flags,
 			   nft_table_do_snprintf);
 }
-EXPORT_SYMBOL(nft_table_fprintf);
+EXPORT_SYMBOL(nftnl_table_fprintf, nft_table_fprintf);
 
 struct nft_table_list {
 	struct list_head list;
@@ -486,7 +486,7 @@ struct nft_table_list *nft_table_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nft_table_list_alloc);
+EXPORT_SYMBOL(nftnl_table_list_alloc, nft_table_list_alloc);
 
 void nft_table_list_free(struct nft_table_list *list)
 {
@@ -498,31 +498,31 @@ void nft_table_list_free(struct nft_table_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nft_table_list_free);
+EXPORT_SYMBOL(nftnl_table_list_free, nft_table_list_free);
 
 int nft_table_list_is_empty(struct nft_table_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nft_table_list_is_empty);
+EXPORT_SYMBOL(nftnl_table_list_is_empty, nft_table_list_is_empty);
 
 void nft_table_list_add(struct nft_table *r, struct nft_table_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_table_list_add);
+EXPORT_SYMBOL(nftnl_table_list_add, nft_table_list_add);
 
 void nft_table_list_add_tail(struct nft_table *r, struct nft_table_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nft_table_list_add_tail);
+EXPORT_SYMBOL(nftnl_table_list_add_tail, nft_table_list_add_tail);
 
 void nft_table_list_del(struct nft_table *t)
 {
 	list_del(&t->head);
 }
-EXPORT_SYMBOL(nft_table_list_del);
+EXPORT_SYMBOL(nftnl_table_list_del, nft_table_list_del);
 
 int nft_table_list_foreach(struct nft_table_list *table_list,
 			   int (*cb)(struct nft_table *t, void *data),
@@ -538,7 +538,7 @@ int nft_table_list_foreach(struct nft_table_list *table_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nft_table_list_foreach);
+EXPORT_SYMBOL(nftnl_table_list_foreach, nft_table_list_foreach);
 
 struct nft_table_list_iter {
 	struct nft_table_list	*list;
@@ -561,7 +561,7 @@ struct nft_table_list_iter *nft_table_list_iter_create(struct nft_table_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nft_table_list_iter_create);
+EXPORT_SYMBOL(nftnl_table_list_iter_create, nft_table_list_iter_create);
 
 struct nft_table *nft_table_list_iter_next(struct nft_table_list_iter *iter)
 {
@@ -577,10 +577,10 @@ struct nft_table *nft_table_list_iter_next(struct nft_table_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL(nft_table_list_iter_next);
+EXPORT_SYMBOL(nftnl_table_list_iter_next, nft_table_list_iter_next);
 
 void nft_table_list_iter_destroy(struct nft_table_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nft_table_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_table_list_iter_destroy, nft_table_list_iter_destroy);
-- 
1.7.10.4

