From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/2] src: get rid of EXPORT_SYMBOL_ALIAS()
Date: Tue,  7 Jun 2016 17:04:32 +0200
Message-ID: <1465311872-17878-2-git-send-email-pablo@netfilter.org>
References: <1465311872-17878-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbcFGPEv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:04:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5583092176A
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2A73E9EBA5
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 378359EBA5
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:45 +0200 (CEST)
In-Reply-To: <1465311872-17878-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This machinery was introduced to avoid sudden compilation breakage of
old nftables releases. With the release of 0.6 (and 0.5 which is now 9
months old) this is not required anymore. Moreover, users gain nothing
from older releases since they are half-boiled and full of bugs.

So let's get rid of this aliases now. Bump LIBVERSION and update map
file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am   |   2 +-
 doxygen.cfg.in   |   2 +-
 include/utils.h  |   2 -
 src/batch.c      |  14 +--
 src/chain.c      |  68 +++++++-------
 src/common.c     |  14 +--
 src/expr.c       |  32 +++----
 src/gen.c        |  26 +++---
 src/libnftnl.map | 265 +------------------------------------------------------
 src/rule.c       |  74 ++++++++--------
 src/ruleset.c    |  32 +++----
 src/set.c        |  64 +++++++-------
 src/set_elem.c   |  48 +++++-----
 src/table.c      |  60 ++++++-------
 14 files changed, 220 insertions(+), 483 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 94c5dfc..f836dea 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=5:0:1
+LIBVERSION=6:0:0
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 042060b..23fcad4 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -72,7 +72,7 @@ RECURSIVE              = YES
 EXCLUDE                = 
 EXCLUDE_SYMLINKS       = NO
 EXCLUDE_PATTERNS       = */.git/* .*.d
-EXCLUDE_SYMBOLS        = EXPORT_SYMBOL EXPORT_SYMBOL_ALIAS nft_table
+EXCLUDE_SYMBOLS        = EXPORT_SYMBOL
 EXAMPLE_PATH           = 
 EXAMPLE_PATTERNS       = 
 EXAMPLE_RECURSIVE      = NO
diff --git a/include/utils.h b/include/utils.h
index 46ff18a..1684b5a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -11,10 +11,8 @@
 #ifdef HAVE_VISIBILITY_HIDDEN
 #	define __visible	__attribute__((visibility("default")))
 #	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible;
-#	define EXPORT_SYMBOL_ALIAS(x, y)	typeof(x) (x) __visible; __typeof (y) y __attribute ((alias (#x), visibility ("default")))
 #else
 #	define EXPORT_SYMBOL
-#	define EXPORT_SYMBOL_ALIAS
 #endif
 
 #define __noreturn	__attribute__((__noreturn__))
diff --git a/src/batch.c b/src/batch.c
index 7299ff6..5ee3fd7 100644
--- a/src/batch.c
+++ b/src/batch.c
@@ -80,7 +80,7 @@ err1:
 	free(batch);
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_alloc, nft_batch_alloc);
+EXPORT_SYMBOL(nftnl_batch_alloc);
 
 void nftnl_batch_free(struct nftnl_batch *batch)
 {
@@ -94,7 +94,7 @@ void nftnl_batch_free(struct nftnl_batch *batch)
 
 	free(batch);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_free, nft_batch_free);
+EXPORT_SYMBOL(nftnl_batch_free);
 
 int nftnl_batch_update(struct nftnl_batch *batch)
 {
@@ -119,19 +119,19 @@ int nftnl_batch_update(struct nftnl_batch *batch)
 err1:
 	return -1;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_update, nft_batch_update);
+EXPORT_SYMBOL(nftnl_batch_update);
 
 void *nftnl_batch_buffer(struct nftnl_batch *batch)
 {
 	return mnl_nlmsg_batch_current(batch->current_page->batch);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_buffer, nft_batch_buffer);
+EXPORT_SYMBOL(nftnl_batch_buffer);
 
 uint32_t nftnl_batch_buffer_len(struct nftnl_batch *batch)
 {
 	return mnl_nlmsg_batch_size(batch->current_page->batch);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_buffer_len, nft_batch_buffer_len);
+EXPORT_SYMBOL(nftnl_batch_buffer_len);
 
 int nftnl_batch_iovec_len(struct nftnl_batch *batch)
 {
@@ -143,7 +143,7 @@ int nftnl_batch_iovec_len(struct nftnl_batch *batch)
 
 	return num_pages;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_iovec_len, nft_batch_iovec_len);
+EXPORT_SYMBOL(nftnl_batch_iovec_len);
 
 void nftnl_batch_iovec(struct nftnl_batch *batch, struct iovec *iov,
 		       uint32_t iovlen)
@@ -160,4 +160,4 @@ void nftnl_batch_iovec(struct nftnl_batch *batch, struct iovec *iov,
 		i++;
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_iovec, nft_batch_iovec);
+EXPORT_SYMBOL(nftnl_batch_iovec);
diff --git a/src/chain.c b/src/chain.c
index 990c576..70daaf3 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -91,7 +91,7 @@ struct nftnl_chain *nftnl_chain_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_chain));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_alloc, nft_chain_alloc);
+EXPORT_SYMBOL(nftnl_chain_alloc);
 
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
@@ -104,13 +104,13 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 
 	xfree(c);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_free, nft_chain_free);
+EXPORT_SYMBOL(nftnl_chain_free);
 
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr)
 {
 	return c->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_is_set, nft_chain_attr_is_set);
+EXPORT_SYMBOL(nftnl_chain_is_set);
 
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 {
@@ -153,7 +153,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 
 	c->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_unset, nft_chain_attr_unset);
+EXPORT_SYMBOL(nftnl_chain_unset);
 
 static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_HOOKNUM]	= sizeof(uint32_t),
@@ -222,43 +222,43 @@ void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 	}
 	c->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_data, nft_chain_attr_set_data);
+EXPORT_SYMBOL(nftnl_chain_set_data);
 
 void nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void *data)
 {
 	nftnl_chain_set_data(c, attr, data, nftnl_chain_validate[attr]);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set, nft_chain_attr_set);
+EXPORT_SYMBOL(nftnl_chain_set);
 
 void nftnl_chain_set_u32(struct nftnl_chain *c, uint16_t attr, uint32_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_u32, nft_chain_attr_set_u32);
+EXPORT_SYMBOL(nftnl_chain_set_u32);
 
 void nftnl_chain_set_s32(struct nftnl_chain *c, uint16_t attr, int32_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(int32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_s32, nft_chain_attr_set_s32);
+EXPORT_SYMBOL(nftnl_chain_set_s32);
 
 void nftnl_chain_set_u64(struct nftnl_chain *c, uint16_t attr, uint64_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_u64, nft_chain_attr_set_u64);
+EXPORT_SYMBOL(nftnl_chain_set_u64);
 
 void nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_u8, nft_chain_attr_set_u8);
+EXPORT_SYMBOL(nftnl_chain_set_u8);
 
 void nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
 {
 	nftnl_chain_set_data(c, attr, str, strlen(str));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_set_str, nft_chain_attr_set_str);
+EXPORT_SYMBOL(nftnl_chain_set_str);
 
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 				 uint32_t *data_len)
@@ -303,20 +303,20 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_data, nft_chain_attr_get_data);
+EXPORT_SYMBOL(nftnl_chain_get_data);
 
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_chain_get_data(c, attr, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get, nft_chain_attr_get);
+EXPORT_SYMBOL(nftnl_chain_get);
 
 const char *nftnl_chain_get_str(const struct nftnl_chain *c, uint16_t attr)
 {
 	return nftnl_chain_get(c, attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_str, nft_chain_attr_get_str);
+EXPORT_SYMBOL(nftnl_chain_get_str);
 
 uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 {
@@ -327,7 +327,7 @@ uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_u32, nft_chain_attr_get_u32);
+EXPORT_SYMBOL(nftnl_chain_get_u32);
 
 int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 {
@@ -338,7 +338,7 @@ int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_s32, nft_chain_attr_get_s32);
+EXPORT_SYMBOL(nftnl_chain_get_s32);
 
 uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 {
@@ -349,7 +349,7 @@ uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_u64, nft_chain_attr_get_u64);
+EXPORT_SYMBOL(nftnl_chain_get_u64);
 
 uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 {
@@ -360,7 +360,7 @@ uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_get_u8, nft_chain_attr_get_u8);
+EXPORT_SYMBOL(nftnl_chain_get_u8);
 
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *c)
 {
@@ -397,7 +397,7 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 	if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_nlmsg_build_payload, nft_chain_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 
 static int nftnl_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -572,7 +572,7 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_nlmsg_parse, nft_chain_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_chain_nlmsg_parse);
 
 static inline int nftnl_str2hooknum(int family, const char *hook)
 {
@@ -824,14 +824,14 @@ int nftnl_chain_parse(struct nftnl_chain *c, enum nftnl_parse_type type,
 {
 	return nftnl_chain_do_parse(c, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_parse, nft_chain_parse);
+EXPORT_SYMBOL(nftnl_chain_parse);
 
 int nftnl_chain_parse_file(struct nftnl_chain *c, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_chain_do_parse(c, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_parse_file, nft_chain_parse_file);
+EXPORT_SYMBOL(nftnl_chain_parse_file);
 
 static int nftnl_chain_export(char *buf, size_t size,
 			      const struct nftnl_chain *c, int type)
@@ -934,7 +934,7 @@ int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *c,
 	return nftnl_chain_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags), type,
 				      flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_snprintf, nft_chain_snprintf);
+EXPORT_SYMBOL(nftnl_chain_snprintf);
 
 static int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
@@ -948,7 +948,7 @@ int nftnl_chain_fprintf(FILE *fp, const struct nftnl_chain *c, uint32_t type,
 	return nftnl_fprintf(fp, c, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_chain_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_fprintf, nft_chain_fprintf);
+EXPORT_SYMBOL(nftnl_chain_fprintf);
 
 struct nftnl_chain_list {
 	struct list_head list;
@@ -966,7 +966,7 @@ struct nftnl_chain_list *nftnl_chain_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_alloc, nft_chain_list_alloc);
+EXPORT_SYMBOL(nftnl_chain_list_alloc);
 
 void nftnl_chain_list_free(struct nftnl_chain_list *list)
 {
@@ -978,31 +978,31 @@ void nftnl_chain_list_free(struct nftnl_chain_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_free, nft_chain_list_free);
+EXPORT_SYMBOL(nftnl_chain_list_free);
 
 int nftnl_chain_list_is_empty(const struct nftnl_chain_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_is_empty, nft_chain_list_is_empty);
+EXPORT_SYMBOL(nftnl_chain_list_is_empty);
 
 void nftnl_chain_list_add(struct nftnl_chain *r, struct nftnl_chain_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_add, nft_chain_list_add);
+EXPORT_SYMBOL(nftnl_chain_list_add);
 
 void nftnl_chain_list_add_tail(struct nftnl_chain *r, struct nftnl_chain_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_add_tail, nft_chain_list_add_tail);
+EXPORT_SYMBOL(nftnl_chain_list_add_tail);
 
 void nftnl_chain_list_del(struct nftnl_chain *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_del, nft_chain_list_del);
+EXPORT_SYMBOL(nftnl_chain_list_del);
 
 int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list,
 			   int (*cb)(struct nftnl_chain *r, void *data),
@@ -1018,7 +1018,7 @@ int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_foreach, nft_chain_list_foreach);
+EXPORT_SYMBOL(nftnl_chain_list_foreach);
 
 struct nftnl_chain_list_iter {
 	struct nftnl_chain_list	*list;
@@ -1041,7 +1041,7 @@ struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(struct nftnl_chain_li
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_iter_create, nft_chain_list_iter_create);
+EXPORT_SYMBOL(nftnl_chain_list_iter_create);
 
 struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *iter)
 {
@@ -1057,10 +1057,10 @@ struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *ite
 
 	return r;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_iter_next, nft_chain_list_iter_next);
+EXPORT_SYMBOL(nftnl_chain_list_iter_next);
 
 void nftnl_chain_list_iter_destroy(struct nftnl_chain_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_chain_list_iter_destroy, nft_chain_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_chain_list_iter_destroy);
diff --git a/src/common.c b/src/common.c
index bf4176c..8b001fe 100644
--- a/src/common.c
+++ b/src/common.c
@@ -40,7 +40,7 @@ struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 
 	return nlh;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_nlmsg_build_hdr, nft_nlmsg_build_hdr);
+EXPORT_SYMBOL(nftnl_nlmsg_build_hdr);
 
 struct nftnl_parse_err *nftnl_parse_err_alloc(void)
 {
@@ -54,13 +54,13 @@ struct nftnl_parse_err *nftnl_parse_err_alloc(void)
 
 	return err;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_parse_err_alloc, nft_parse_err_alloc);
+EXPORT_SYMBOL(nftnl_parse_err_alloc);
 
 void nftnl_parse_err_free(struct nftnl_parse_err *err)
 {
 	xfree(err);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_parse_err_free, nft_parse_err_free);
+EXPORT_SYMBOL(nftnl_parse_err_free);
 
 int nftnl_parse_perror(const char *msg, struct nftnl_parse_err *err)
 {
@@ -80,7 +80,7 @@ int nftnl_parse_perror(const char *msg, struct nftnl_parse_err *err)
 		return fprintf(stderr, "%s: Undefined error\n", msg);
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_parse_perror, nft_parse_perror);
+EXPORT_SYMBOL(nftnl_parse_perror);
 
 int nftnl_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
 			    uint32_t flags)
@@ -176,13 +176,13 @@ void nftnl_batch_begin(char *buf, uint32_t seq)
 {
 	nftnl_batch_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, seq);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_begin, nft_batch_begin);
+EXPORT_SYMBOL(nftnl_batch_begin);
 
 void nftnl_batch_end(char *buf, uint32_t seq)
 {
 	nftnl_batch_build_hdr(buf, NFNL_MSG_BATCH_END, seq);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_end, nft_batch_end);
+EXPORT_SYMBOL(nftnl_batch_end);
 
 int nftnl_batch_is_supported(void)
 {
@@ -241,4 +241,4 @@ err:
 	mnl_nlmsg_batch_stop(b);
 	return -1;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_batch_is_supported, nft_batch_is_supported);
+EXPORT_SYMBOL(nftnl_batch_is_supported);
diff --git a/src/expr.c b/src/expr.c
index ed07dc4..aa920dd 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -43,7 +43,7 @@ struct nftnl_expr *nftnl_expr_alloc(const char *name)
 
 	return expr;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_alloc, nft_rule_expr_alloc);
+EXPORT_SYMBOL(nftnl_expr_alloc);
 
 void nftnl_expr_free(const struct nftnl_expr *expr)
 {
@@ -52,13 +52,13 @@ void nftnl_expr_free(const struct nftnl_expr *expr)
 
 	xfree(expr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_free, nft_rule_expr_free);
+EXPORT_SYMBOL(nftnl_expr_free);
 
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type)
 {
 	return expr->flags & (1 << type);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_is_set, nft_rule_expr_is_set);
+EXPORT_SYMBOL(nftnl_expr_is_set);
 
 void
 nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
@@ -73,42 +73,42 @@ nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 	}
 	expr->flags |= (1 << type);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set, nft_rule_expr_set);
+EXPORT_SYMBOL(nftnl_expr_set);
 
 void
 nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set_u8, nft_rule_expr_set_u8);
+EXPORT_SYMBOL(nftnl_expr_set_u8);
 
 void
 nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint16_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set_u16, nft_rule_expr_set_u16);
+EXPORT_SYMBOL(nftnl_expr_set_u16);
 
 void
 nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set_u32, nft_rule_expr_set_u32);
+EXPORT_SYMBOL(nftnl_expr_set_u32);
 
 void
 nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set_u64, nft_rule_expr_set_u64);
+EXPORT_SYMBOL(nftnl_expr_set_u64);
 
 void
 nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str)
 {
 	nftnl_expr_set(expr, type, str, strlen(str)+1);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_set_str, nft_rule_expr_set_str);
+EXPORT_SYMBOL(nftnl_expr_set_str);
 
 const void *nftnl_expr_get(const struct nftnl_expr *expr,
 			      uint16_t type, uint32_t *data_len)
@@ -129,7 +129,7 @@ const void *nftnl_expr_get(const struct nftnl_expr *expr,
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get, nft_rule_expr_get);
+EXPORT_SYMBOL(nftnl_expr_get);
 
 uint8_t nftnl_expr_get_u8(const struct nftnl_expr *expr, uint16_t type)
 {
@@ -145,7 +145,7 @@ uint8_t nftnl_expr_get_u8(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint8_t *)data);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get_u8, nft_rule_expr_get_u8);
+EXPORT_SYMBOL(nftnl_expr_get_u8);
 
 uint16_t nftnl_expr_get_u16(const struct nftnl_expr *expr, uint16_t type)
 {
@@ -161,7 +161,7 @@ uint16_t nftnl_expr_get_u16(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint16_t *)data);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get_u16, nft_rule_expr_get_u16);
+EXPORT_SYMBOL(nftnl_expr_get_u16);
 
 uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type)
 {
@@ -177,7 +177,7 @@ uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint32_t *)data);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get_u32, nft_rule_expr_get_u32);
+EXPORT_SYMBOL(nftnl_expr_get_u32);
 
 uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type)
 {
@@ -193,7 +193,7 @@ uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint64_t *)data);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get_u64, nft_rule_expr_get_u64);
+EXPORT_SYMBOL(nftnl_expr_get_u64);
 
 const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 {
@@ -201,7 +201,7 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 
 	return (const char *)nftnl_expr_get(expr, type, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_get_str, nft_rule_expr_get_str);
+EXPORT_SYMBOL(nftnl_expr_get_str);
 
 void
 nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
@@ -273,4 +273,4 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 
 	return offset;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_snprintf, nft_rule_expr_snprintf);
+EXPORT_SYMBOL(nftnl_expr_snprintf);
diff --git a/src/gen.c b/src/gen.c
index 115a105..8533f38 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -33,19 +33,19 @@ struct nftnl_gen *nftnl_gen_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_gen));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_alloc, nft_gen_alloc);
+EXPORT_SYMBOL(nftnl_gen_alloc);
 
 void nftnl_gen_free(const struct nftnl_gen *gen)
 {
 	xfree(gen);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_free, nft_gen_free);
+EXPORT_SYMBOL(nftnl_gen_free);
 
 bool nftnl_gen_is_set(const struct nftnl_gen *gen, uint16_t attr)
 {
 	return gen->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_is_set, nft_gen_attr_is_set);
+EXPORT_SYMBOL(nftnl_gen_is_set);
 
 void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr)
 {
@@ -58,7 +58,7 @@ void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr)
 	}
 	gen->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_unset, nft_gen_attr_unset);
+EXPORT_SYMBOL(nftnl_gen_unset);
 
 static uint32_t nftnl_gen_validate[NFTNL_GEN_MAX + 1] = {
 	[NFTNL_GEN_ID]	= sizeof(uint32_t),
@@ -79,19 +79,19 @@ void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 	}
 	gen->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_set_data, nft_gen_attr_set_data);
+EXPORT_SYMBOL(nftnl_gen_set_data);
 
 void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data)
 {
 	nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_set, nft_gen_attr_set);
+EXPORT_SYMBOL(nftnl_gen_set);
 
 void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t val)
 {
 	nftnl_gen_set_data(gen, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_set_u32, nft_gen_attr_set_u32);
+EXPORT_SYMBOL(nftnl_gen_set_u32);
 
 const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
 			       uint32_t *data_len)
@@ -105,21 +105,21 @@ const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_get_data, nft_gen_attr_get_data);
+EXPORT_SYMBOL(nftnl_gen_get_data);
 
 const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_gen_get_data(gen, attr, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_get, nft_gen_attr_get);
+EXPORT_SYMBOL(nftnl_gen_get);
 
 uint32_t nftnl_gen_get_u32(const struct nftnl_gen *gen, uint16_t attr)
 {
 	const void *ret = nftnl_gen_get(gen, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_get_u32, nft_gen_attr_get_u32);
+EXPORT_SYMBOL(nftnl_gen_get_u32);
 
 static int nftnl_gen_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -154,7 +154,7 @@ int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_nlmsg_parse, nft_gen_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_gen_nlmsg_parse);
 
 static int nftnl_gen_snprintf_default(char *buf, size_t size,
 				      const struct nftnl_gen *gen)
@@ -192,7 +192,7 @@ int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen,
 	return nftnl_gen_cmd_snprintf(buf, size, gen, nftnl_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_snprintf, nft_gen_snprintf);
+EXPORT_SYMBOL(nftnl_gen_snprintf);
 
 static int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
@@ -206,4 +206,4 @@ int nftnl_gen_fprintf(FILE *fp, const struct nftnl_gen *gen, uint32_t type,
 	return nftnl_fprintf(fp, gen, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_gen_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_gen_fprintf, nft_gen_fprintf);
+EXPORT_SYMBOL(nftnl_gen_fprintf);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index c38e081..ed933c2 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -1,205 +1,5 @@
-LIBNFTNL_4 {
+LIBNFTNL_5 {
 global:
-  nft_table_alloc;
-  nft_table_free;
-  nft_table_attr_is_set;
-  nft_table_attr_unset;
-  nft_table_attr_set;
-  nft_table_attr_get;
-  nft_table_attr_set_u8;
-  nft_table_attr_set_u32;
-  nft_table_attr_set_str;
-  nft_table_attr_get_u8;
-  nft_table_attr_get_u32;
-  nft_table_attr_get_str;
-  nft_table_parse;
-  nft_table_parse_file;
-  nft_table_snprintf;
-  nft_table_fprintf;
-  nft_table_nlmsg_build_payload;
-  nft_table_nlmsg_parse;
-  nft_table_list_alloc;
-  nft_table_list_free;
-  nft_table_list_is_empty;
-  nft_table_list_foreach;
-  nft_table_list_add;
-  nft_table_list_add_tail;
-  nft_table_list_del;
-  nft_table_list_iter_create;
-  nft_table_list_iter_next;
-  nft_table_list_iter_destroy;
-
-  nft_chain_alloc;
-  nft_chain_free;
-  nft_chain_attr_is_set;
-  nft_chain_attr_unset;
-  nft_chain_attr_set;
-  nft_chain_attr_set_u8;
-  nft_chain_attr_set_u32;
-  nft_chain_attr_set_s32;
-  nft_chain_attr_set_u64;
-  nft_chain_attr_set_str;
-  nft_chain_attr_get;
-  nft_chain_attr_get_u8;
-  nft_chain_attr_get_u32;
-  nft_chain_attr_get_s32;
-  nft_chain_attr_get_u64;
-  nft_chain_attr_get_str;
-  nft_chain_parse;
-  nft_chain_parse_file;
-  nft_chain_snprintf;
-  nft_chain_fprintf;
-  nft_chain_nlmsg_build_payload;
-  nft_chain_nlmsg_parse;
-  nft_chain_list_alloc;
-  nft_chain_list_free;
-  nft_chain_list_is_empty;
-  nft_chain_list_add;
-  nft_chain_list_add_tail;
-  nft_chain_list_del;
-  nft_chain_list_foreach;
-  nft_chain_list_iter_create;
-  nft_chain_list_iter_next;
-  nft_chain_list_iter_destroy;
-
-  nft_rule_alloc;
-  nft_rule_free;
-  nft_rule_attr_is_set;
-  nft_rule_attr_unset;
-  nft_rule_attr_set;
-  nft_rule_attr_set_u32;
-  nft_rule_attr_set_u64;
-  nft_rule_attr_set_str;
-  nft_rule_attr_get;
-  nft_rule_attr_get_u8;
-  nft_rule_attr_get_u32;
-  nft_rule_attr_get_u64;
-  nft_rule_attr_get_str;
-  nft_rule_parse;
-  nft_rule_parse_file;
-  nft_rule_snprintf;
-  nft_rule_fprintf;
-  nft_rule_nlmsg_build_payload;
-  nft_rule_nlmsg_parse;
-  nft_rule_add_expr;
-
-  nft_rule_expr_foreach;
-  nft_rule_expr_iter_create;
-  nft_rule_expr_iter_next;
-  nft_rule_expr_iter_destroy;
-
-  nft_rule_expr_alloc;
-  nft_rule_expr_is_set;
-  nft_rule_expr_set;
-  nft_rule_expr_set_u8;
-  nft_rule_expr_set_u16;
-  nft_rule_expr_set_u32;
-  nft_rule_expr_set_u64;
-  nft_rule_expr_set_str;
-  nft_rule_expr_get;
-  nft_rule_expr_get_u8;
-  nft_rule_expr_get_u16;
-  nft_rule_expr_get_u32;
-  nft_rule_expr_get_u64;
-  nft_rule_expr_get_str;
-  nft_rule_expr_snprintf;
-  nft_rule_expr_free;
-
-  nft_rule_list_alloc;
-  nft_rule_list_free;
-  nft_rule_list_is_empty;
-  nft_rule_list_add;
-  nft_rule_list_add_tail;
-  nft_rule_list_del;
-  nft_rule_list_foreach;
-  nft_rule_list_iter_create;
-  nft_rule_list_iter_cur;
-  nft_rule_list_iter_next;
-  nft_rule_list_iter_destroy;
-
-  nft_set_alloc;
-  nft_set_free;
-  nft_set_attr_unset;
-  nft_set_attr_is_set;
-  nft_set_attr_set;
-  nft_set_attr_set_u32;
-  nft_set_attr_set_u64;
-  nft_set_attr_set_str;
-  nft_set_attr_get;
-  nft_set_attr_get_str;
-  nft_set_attr_get_u32;
-  nft_set_attr_get_u64;
-  nft_set_nlmsg_build_payload;
-  nft_set_nlmsg_parse;
-  nft_set_parse;
-  nft_set_parse_file;
-  nft_set_snprintf;
-  nft_set_fprintf;
-
-  nft_set_list_alloc;
-  nft_set_list_free;
-  nft_set_list_add;
-  nft_set_list_add_tail;
-  nft_set_list_del;
-  nft_set_list_is_empty;
-  nft_set_list_foreach;
-
-  nft_set_list_iter_create;
-  nft_set_list_iter_cur;
-  nft_set_list_iter_next;
-  nft_set_list_iter_destroy;
-
-  nft_set_elem_alloc;
-  nft_set_elem_free;
-  nft_set_elem_add;
-  nft_set_elem_foreach;
-  nft_set_elem_attr_is_set;
-  nft_set_elem_attr_unset;
-  nft_set_elem_attr_set;
-  nft_set_elem_attr_set_u32;
-  nft_set_elem_attr_set_u64;
-  nft_set_elem_attr_set_str;
-  nft_set_elem_attr_get;
-  nft_set_elem_attr_get_str;
-  nft_set_elem_attr_get_u32;
-  nft_set_elem_attr_get_u64;
-  nft_set_elem_nlmsg_build_payload;
-  nft_set_elem_parse;
-  nft_set_elem_parse_file;
-  nft_set_elem_snprintf;
-  nft_set_elem_fprinf;
-
-  nft_set_elems_nlmsg_build_payload;
-  nft_set_elems_nlmsg_parse;
-
-  nft_set_elems_foreach;
-
-  nft_set_elems_iter_create;
-  nft_set_elems_iter_cur;
-  nft_set_elems_iter_next;
-  nft_set_elems_iter_destroy;
-
-  nft_ruleset_alloc;
-  nft_ruleset_free;
-  nft_ruleset_attr_is_set;
-  nft_ruleset_attr_unset;
-  nft_ruleset_attr_set;
-  nft_ruleset_attr_get;
-  nft_ruleset_parse;
-  nft_ruleset_parse_file;
-  nft_ruleset_snprintf;
-  nft_ruleset_fprintf;
-
-  nft_nlmsg_build_hdr;
-
-  nft_parse_err_alloc;
-  nft_parse_err_free;
-  nft_parse_perror;
-
-#
-# aliases
-#
-
   nftnl_table_alloc;
   nftnl_table_free;
   nftnl_table_is_set;
@@ -396,20 +196,6 @@ global:
   nftnl_parse_err_free;
   nftnl_parse_perror;
 
-
-  nft_table_attr_set_data;
-  nft_table_attr_get_data;
-  nft_chain_attr_set_data;
-  nft_chain_attr_get_data;
-  nft_rule_attr_set_data;
-  nft_rule_attr_get_data;
-  nft_set_attr_set_data;
-  nft_set_attr_get_data;
-
-#
-# aliases
-#
-
   nftnl_table_set_data;
   nftnl_table_get_data;
   nftnl_chain_set_data;
@@ -419,29 +205,6 @@ global:
   nftnl_set_set_data;
   nftnl_set_get_data;
 
-  nft_set_elems_nlmsg_build_payload_iter;
-  nft_batch_is_supported;
-  nft_batch_begin;
-  nft_batch_end;
-
-  nft_gen_alloc;
-  nft_gen_free;
-  nft_gen_attr_is_set;
-  nft_gen_attr_unset;
-  nft_gen_attr_set_data;
-  nft_gen_attr_set;
-  nft_gen_attr_set_u32;
-  nft_gen_attr_get_data;
-  nft_gen_attr_get;
-  nft_gen_attr_get_u32;
-  nft_gen_nlmsg_parse;
-  nft_gen_snprintf;
-  nft_gen_fprintf;
-
-#
-# aliases
-#
-
   nftnl_set_elems_nlmsg_build_payload_iter;
   nftnl_batch_is_supported;
   nftnl_batch_begin;
@@ -461,26 +224,6 @@ global:
   nftnl_gen_snprintf;
   nftnl_gen_fprintf;
 
-
-  nft_ruleset_ctx_is_set;
-  nft_ruleset_ctx_get;
-  nft_ruleset_ctx_get_u32;
-  nft_ruleset_parse_file_cb;
-  nft_ruleset_parse_buffer_cb;
-  nft_ruleset_ctx_free;
-
-  nft_batch_alloc;
-  nft_batch_update;
-  nft_batch_free;
-  nft_batch_buffer;
-  nft_batch_buffer_len;
-  nft_batch_iovec_len;
-  nft_batch_iovec;
-
-#
-# aliases
-#
-
   nftnl_ruleset_ctx_is_set;
   nftnl_ruleset_ctx_get;
   nftnl_ruleset_ctx_get_u32;
@@ -496,10 +239,6 @@ global:
   nftnl_batch_iovec_len;
   nftnl_batch_iovec;
 
-local: *;
-};
-
-LIBNFTNL_4.1 {
 	nftnl_trace_alloc;
 	nftnl_trace_free;
 
@@ -527,4 +266,4 @@ LIBNFTNL_4.1 {
 	nftnl_udata_get;
 	nftnl_udata_next;
 	nftnl_udata_parse;
-} LIBNFTNL_4;
+};
diff --git a/src/rule.c b/src/rule.c
index 8ee8648..1e1a138 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -62,7 +62,7 @@ struct nftnl_rule *nftnl_rule_alloc(void)
 
 	return r;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_alloc, nft_rule_alloc);
+EXPORT_SYMBOL(nftnl_rule_alloc);
 
 void nftnl_rule_free(const struct nftnl_rule *r)
 {
@@ -80,13 +80,13 @@ void nftnl_rule_free(const struct nftnl_rule *r)
 
 	xfree(r);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_free, nft_rule_free);
+EXPORT_SYMBOL(nftnl_rule_free);
 
 bool nftnl_rule_is_set(const struct nftnl_rule *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_is_set, nft_rule_attr_is_set);
+EXPORT_SYMBOL(nftnl_rule_is_set);
 
 void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 {
@@ -117,7 +117,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_unset, nft_rule_attr_unset);
+EXPORT_SYMBOL(nftnl_rule_unset);
 
 static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 	[NFTNL_RULE_HANDLE]		= sizeof(uint64_t),
@@ -177,31 +177,31 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 	}
 	r->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_set_data, nft_rule_attr_set_data);
+EXPORT_SYMBOL(nftnl_rule_set_data);
 
 void nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data)
 {
 	nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_set, nft_rule_attr_set);
+EXPORT_SYMBOL(nftnl_rule_set);
 
 void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t val)
 {
 	nftnl_rule_set_data(r, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_set_u32, nft_rule_attr_set_u32);
+EXPORT_SYMBOL(nftnl_rule_set_u32);
 
 void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t val)
 {
 	nftnl_rule_set_data(r, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_set_u64, nft_rule_attr_set_u64);
+EXPORT_SYMBOL(nftnl_rule_set_u64);
 
 void nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str)
 {
 	nftnl_rule_set_data(r, attr, str, strlen(str));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_set_str, nft_rule_attr_set_str);
+EXPORT_SYMBOL(nftnl_rule_set_str);
 
 const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 				   uint32_t *data_len)
@@ -235,20 +235,20 @@ const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get_data, nft_rule_attr_get_data);
+EXPORT_SYMBOL(nftnl_rule_get_data);
 
 const void *nftnl_rule_get(const struct nftnl_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_rule_get_data(r, attr, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get, nft_rule_attr_get);
+EXPORT_SYMBOL(nftnl_rule_get);
 
 const char *nftnl_rule_get_str(const struct nftnl_rule *r, uint16_t attr)
 {
 	return nftnl_rule_get(r, attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get_str, nft_rule_attr_get_str);
+EXPORT_SYMBOL(nftnl_rule_get_str);
 
 uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 {
@@ -259,7 +259,7 @@ uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get_u32, nft_rule_attr_get_u32);
+EXPORT_SYMBOL(nftnl_rule_get_u32);
 
 uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 {
@@ -270,7 +270,7 @@ uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get_u64, nft_rule_attr_get_u64);
+EXPORT_SYMBOL(nftnl_rule_get_u64);
 
 uint8_t nftnl_rule_get_u8(const struct nftnl_rule *r, uint16_t attr)
 {
@@ -281,7 +281,7 @@ uint8_t nftnl_rule_get_u8(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_get_u8, nft_rule_attr_get_u8);
+EXPORT_SYMBOL(nftnl_rule_get_u8);
 
 void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 {
@@ -322,13 +322,13 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 		mnl_attr_nest_end(nlh, nest);
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_nlmsg_build_payload, nft_rule_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_rule_nlmsg_build_payload);
 
 void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr)
 {
 	list_add_tail(&expr->head, &r->expr_list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_add_expr, nft_rule_add_expr);
+EXPORT_SYMBOL(nftnl_rule_add_expr);
 
 static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -477,7 +477,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_nlmsg_parse, nft_rule_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
 int nftnl_jansson_parse_rule(struct nftnl_rule *r, json_t *tree,
@@ -711,14 +711,14 @@ int nftnl_rule_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 {
 	return nftnl_rule_do_parse(r, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_parse, nft_rule_parse);
+EXPORT_SYMBOL(nftnl_rule_parse);
 
 int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 			FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_rule_do_parse(r, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_parse_file, nft_rule_parse_file);
+EXPORT_SYMBOL(nftnl_rule_parse_file);
 
 static int nftnl_rule_snprintf_json(char *buf, size_t size,
 				    const struct nftnl_rule *r,
@@ -980,7 +980,7 @@ int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
 	return nftnl_rule_cmd_snprintf(buf, size, r, nftnl_flag2cmd(flags), type,
 				     flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_snprintf, nft_rule_snprintf);
+EXPORT_SYMBOL(nftnl_rule_snprintf);
 
 static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
@@ -994,7 +994,7 @@ int nftnl_rule_fprintf(FILE *fp, const struct nftnl_rule *r, uint32_t type,
 	return nftnl_fprintf(fp, r, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_rule_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_fprintf, nft_rule_fprintf);
+EXPORT_SYMBOL(nftnl_rule_fprintf);
 
 int nftnl_expr_foreach(struct nftnl_rule *r,
                           int (*cb)(struct nftnl_expr *e, void *data),
@@ -1010,7 +1010,7 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
        }
        return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
+EXPORT_SYMBOL(nftnl_expr_foreach);
 
 struct nftnl_expr_iter {
 	struct nftnl_rule		*r;
@@ -1034,7 +1034,7 @@ struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r)
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_iter_create, nft_rule_expr_iter_create);
+EXPORT_SYMBOL(nftnl_expr_iter_create);
 
 struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter)
 {
@@ -1050,13 +1050,13 @@ struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter)
 
 	return expr;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_iter_next, nft_rule_expr_iter_next);
+EXPORT_SYMBOL(nftnl_expr_iter_next);
 
 void nftnl_expr_iter_destroy(struct nftnl_expr_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_expr_iter_destroy, nft_rule_expr_iter_destroy);
+EXPORT_SYMBOL(nftnl_expr_iter_destroy);
 
 struct nftnl_rule_list {
 	struct list_head list;
@@ -1074,7 +1074,7 @@ struct nftnl_rule_list *nftnl_rule_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_alloc, nft_rule_list_alloc);
+EXPORT_SYMBOL(nftnl_rule_list_alloc);
 
 void nftnl_rule_list_free(struct nftnl_rule_list *list)
 {
@@ -1086,31 +1086,31 @@ void nftnl_rule_list_free(struct nftnl_rule_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_free, nft_rule_list_free);
+EXPORT_SYMBOL(nftnl_rule_list_free);
 
 int nftnl_rule_list_is_empty(const struct nftnl_rule_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_is_empty, nft_rule_list_is_empty);
+EXPORT_SYMBOL(nftnl_rule_list_is_empty);
 
 void nftnl_rule_list_add(struct nftnl_rule *r, struct nftnl_rule_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_add, nft_rule_list_add);
+EXPORT_SYMBOL(nftnl_rule_list_add);
 
 void nftnl_rule_list_add_tail(struct nftnl_rule *r, struct nftnl_rule_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_add_tail, nft_rule_list_add_tail);
+EXPORT_SYMBOL(nftnl_rule_list_add_tail);
 
 void nftnl_rule_list_del(struct nftnl_rule *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_del, nft_rule_list_del);
+EXPORT_SYMBOL(nftnl_rule_list_del);
 
 int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list,
 			  int (*cb)(struct nftnl_rule *r, void *data),
@@ -1126,7 +1126,7 @@ int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_foreach, nft_rule_list_foreach);
+EXPORT_SYMBOL(nftnl_rule_list_foreach);
 
 struct nftnl_rule_list_iter {
 	struct nftnl_rule_list	*list;
@@ -1149,13 +1149,13 @@ struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(struct nftnl_rule_list
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_iter_create, nft_rule_list_iter_create);
+EXPORT_SYMBOL(nftnl_rule_list_iter_create);
 
 struct nftnl_rule *nftnl_rule_list_iter_cur(struct nftnl_rule_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_iter_cur, nft_rule_list_iter_cur);
+EXPORT_SYMBOL(nftnl_rule_list_iter_cur);
 
 struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter)
 {
@@ -1171,10 +1171,10 @@ struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_iter_next, nft_rule_list_iter_next);
+EXPORT_SYMBOL(nftnl_rule_list_iter_next);
 
 void nftnl_rule_list_iter_destroy(const struct nftnl_rule_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_rule_list_iter_destroy, nft_rule_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_rule_list_iter_destroy);
diff --git a/src/ruleset.c b/src/ruleset.c
index 414b7c4..cbe1438 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -62,7 +62,7 @@ struct nftnl_ruleset *nftnl_ruleset_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_ruleset));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_alloc, nft_ruleset_alloc);
+EXPORT_SYMBOL(nftnl_ruleset_alloc);
 
 void nftnl_ruleset_free(const struct nftnl_ruleset *r)
 {
@@ -76,13 +76,13 @@ void nftnl_ruleset_free(const struct nftnl_ruleset *r)
 		nftnl_rule_list_free(r->rule_list);
 	xfree(r);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_free, nft_ruleset_free);
+EXPORT_SYMBOL(nftnl_ruleset_free);
 
 bool nftnl_ruleset_is_set(const struct nftnl_ruleset *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_is_set, nft_ruleset_attr_is_set);
+EXPORT_SYMBOL(nftnl_ruleset_is_set);
 
 void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr)
 {
@@ -109,7 +109,7 @@ void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr)
 	}
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_unset, nft_ruleset_attr_unset);
+EXPORT_SYMBOL(nftnl_ruleset_unset);
 
 void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *data)
 {
@@ -135,7 +135,7 @@ void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *data)
 	}
 	r->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_set, nft_ruleset_attr_set);
+EXPORT_SYMBOL(nftnl_ruleset_set);
 
 void *nftnl_ruleset_get(const struct nftnl_ruleset *r, uint16_t attr)
 {
@@ -155,7 +155,7 @@ void *nftnl_ruleset_get(const struct nftnl_ruleset *r, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_get, nft_ruleset_attr_get);
+EXPORT_SYMBOL(nftnl_ruleset_get);
 
 void nftnl_ruleset_ctx_free(const struct nftnl_parse_ctx *ctx)
 {
@@ -178,13 +178,13 @@ void nftnl_ruleset_ctx_free(const struct nftnl_parse_ctx *ctx)
 		break;
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_ctx_free, nft_ruleset_ctx_free);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_free);
 
 bool nftnl_ruleset_ctx_is_set(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
 	return ctx->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_ctx_is_set, nft_ruleset_ctx_is_set);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_is_set);
 
 void *nftnl_ruleset_ctx_get(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
@@ -210,14 +210,14 @@ void *nftnl_ruleset_ctx_get(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_ctx_get, nft_ruleset_ctx_get);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get);
 
 uint32_t nftnl_ruleset_ctx_get_u32(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
 	const void *ret = nftnl_ruleset_ctx_get(ctx, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_ctx_get_u32, nft_ruleset_ctx_get_u32);
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get_u32);
 
 #if defined(JSON_PARSING) || defined(XML_PARSING)
 static void nftnl_ruleset_ctx_set(struct nftnl_parse_ctx *ctx, uint16_t attr,
@@ -751,7 +751,7 @@ int nftnl_ruleset_parse_file_cb(enum nftnl_parse_type type, FILE *fp,
 {
 	return nftnl_ruleset_do_parse(type, fp, err, NFTNL_PARSE_FILE, data, cb);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_parse_file_cb, nft_ruleset_parse_file_cb);
+EXPORT_SYMBOL(nftnl_ruleset_parse_file_cb);
 
 int nftnl_ruleset_parse_buffer_cb(enum nftnl_parse_type type, const char *buffer,
 				struct nftnl_parse_err *err, void *data,
@@ -760,7 +760,7 @@ int nftnl_ruleset_parse_buffer_cb(enum nftnl_parse_type type, const char *buffer
 	return nftnl_ruleset_do_parse(type, buffer, err, NFTNL_PARSE_BUFFER, data,
 				    cb);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_parse_buffer_cb, nft_ruleset_parse_buffer_cb);
+EXPORT_SYMBOL(nftnl_ruleset_parse_buffer_cb);
 
 static int nftnl_ruleset_cb(const struct nftnl_parse_ctx *ctx)
 {
@@ -828,14 +828,14 @@ int nftnl_ruleset_parse(struct nftnl_ruleset *r, enum nftnl_parse_type type,
 {
 	return nftnl_ruleset_parse_buffer_cb(type, data, err, r, nftnl_ruleset_cb);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_parse, nft_ruleset_parse);
+EXPORT_SYMBOL(nftnl_ruleset_parse);
 
 int nftnl_ruleset_parse_file(struct nftnl_ruleset *rs, enum nftnl_parse_type type,
 			   FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_ruleset_parse_file_cb(type, fp, err, rs, nftnl_ruleset_cb);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_parse_file, nft_ruleset_parse_file);
+EXPORT_SYMBOL(nftnl_ruleset_parse_file);
 
 static const char *nftnl_ruleset_o_opentag(uint32_t type)
 {
@@ -1097,7 +1097,7 @@ int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r
 		return -1;
 	}
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_snprintf, nft_ruleset_snprintf);
+EXPORT_SYMBOL(nftnl_ruleset_snprintf);
 
 static int nftnl_ruleset_fprintf_tables(FILE *fp, const struct nftnl_ruleset *rs,
 				      uint32_t type, uint32_t flags)
@@ -1317,4 +1317,4 @@ int nftnl_ruleset_fprintf(FILE *fp, const struct nftnl_ruleset *rs, uint32_t typ
 	return nftnl_ruleset_cmd_fprintf(fp, rs, nftnl_flag2cmd(flags), type,
 				       flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_ruleset_fprintf, nft_ruleset_fprintf);
+EXPORT_SYMBOL(nftnl_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index dbea93b..3caaf39 100644
--- a/src/set.c
+++ b/src/set.c
@@ -38,7 +38,7 @@ struct nftnl_set *nftnl_set_alloc(void)
 	INIT_LIST_HEAD(&s->element_list);
 	return s;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_alloc, nft_set_alloc);
+EXPORT_SYMBOL(nftnl_set_alloc);
 
 void nftnl_set_free(const struct nftnl_set *s)
 {
@@ -55,13 +55,13 @@ void nftnl_set_free(const struct nftnl_set *s)
 	}
 	xfree(s);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_free, nft_set_free);
+EXPORT_SYMBOL(nftnl_set_free);
 
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_is_set, nft_set_attr_is_set);
+EXPORT_SYMBOL(nftnl_set_is_set);
 
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 {
@@ -98,7 +98,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_unset, nft_set_attr_unset);
+EXPORT_SYMBOL(nftnl_set_unset);
 
 static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_FLAGS]		= sizeof(uint32_t),
@@ -170,31 +170,31 @@ void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	}
 	s->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_set_data, nft_set_attr_set_data);
+EXPORT_SYMBOL(nftnl_set_set_data);
 
 void nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 {
 	nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_set, nft_set_attr_set);
+EXPORT_SYMBOL(nftnl_set_set);
 
 void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val)
 {
 	nftnl_set_set(s, attr, &val);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_set_u32, nft_set_attr_set_u32);
+EXPORT_SYMBOL(nftnl_set_set_u32);
 
 void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val)
 {
 	nftnl_set_set(s, attr, &val);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_attr_set_u64);
+EXPORT_SYMBOL(nftnl_set_set_u64);
 
 void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str)
 {
 	nftnl_set_set(s, attr, str);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);
+EXPORT_SYMBOL(nftnl_set_set_str);
 
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 			       uint32_t *data_len)
@@ -243,20 +243,20 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_get_data, nft_set_attr_get_data);
+EXPORT_SYMBOL(nftnl_set_get_data);
 
 const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_set_get_data(s, attr, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_get, nft_set_attr_get);
+EXPORT_SYMBOL(nftnl_set_get);
 
 const char *nftnl_set_get_str(const struct nftnl_set *s, uint16_t attr)
 {
 	return nftnl_set_get(s, attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_get_str, nft_set_attr_get_str);
+EXPORT_SYMBOL(nftnl_set_get_str);
 
 uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 {
@@ -267,7 +267,7 @@ uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_get_u32, nft_set_attr_get_u32);
+EXPORT_SYMBOL(nftnl_set_get_u32);
 
 uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 {
@@ -278,7 +278,7 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_get_u64, nft_set_attr_get_u64);
+EXPORT_SYMBOL(nftnl_set_get_u64);
 
 struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 {
@@ -349,7 +349,7 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 	if (s->flags & (1 << NFTNL_SET_GC_INTERVAL))
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_nlmsg_build_payload, nft_set_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
 
 static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -488,7 +488,7 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_nlmsg_parse, nft_set_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_set_nlmsg_parse);
 
 #ifdef JSON_PARSING
 static int nftnl_jansson_parse_set_info(struct nftnl_set *s, json_t *tree,
@@ -762,14 +762,14 @@ int nftnl_set_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 {
 	return nftnl_set_do_parse(s, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_parse, nft_set_parse);
+EXPORT_SYMBOL(nftnl_set_parse);
 
 int nftnl_set_parse_file(struct nftnl_set *s, enum nftnl_parse_type type,
 		       FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_set_do_parse(s, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_parse_file, nft_set_parse_file);
+EXPORT_SYMBOL(nftnl_set_parse_file);
 
 static int nftnl_set_snprintf_json(char *buf, size_t size,
 				   const struct nftnl_set *s,
@@ -1039,7 +1039,7 @@ int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s,
 	return nftnl_set_cmd_snprintf(buf, size, s, nftnl_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_snprintf, nft_set_snprintf);
+EXPORT_SYMBOL(nftnl_set_snprintf);
 
 static int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
@@ -1053,13 +1053,13 @@ int nftnl_set_fprintf(FILE *fp, const struct nftnl_set *s, uint32_t type,
 	return nftnl_fprintf(fp, s, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_set_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_fprintf, nft_set_fprintf);
+EXPORT_SYMBOL(nftnl_set_fprintf);
 
 void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem)
 {
 	list_add_tail(&elem->head, &s->element_list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_add, nft_set_elem_add);
+EXPORT_SYMBOL(nftnl_set_elem_add);
 
 struct nftnl_set_list {
 	struct list_head list;
@@ -1077,7 +1077,7 @@ struct nftnl_set_list *nftnl_set_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_alloc, nft_set_list_alloc);
+EXPORT_SYMBOL(nftnl_set_list_alloc);
 
 void nftnl_set_list_free(struct nftnl_set_list *list)
 {
@@ -1089,31 +1089,31 @@ void nftnl_set_list_free(struct nftnl_set_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_free, nft_set_list_free);
+EXPORT_SYMBOL(nftnl_set_list_free);
 
 int nftnl_set_list_is_empty(const struct nftnl_set_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_is_empty, nft_set_list_is_empty);
+EXPORT_SYMBOL(nftnl_set_list_is_empty);
 
 void nftnl_set_list_add(struct nftnl_set *s, struct nftnl_set_list *list)
 {
 	list_add(&s->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_add, nft_set_list_add);
+EXPORT_SYMBOL(nftnl_set_list_add);
 
 void nftnl_set_list_add_tail(struct nftnl_set *s, struct nftnl_set_list *list)
 {
 	list_add_tail(&s->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_add_tail, nft_set_list_add_tail);
+EXPORT_SYMBOL(nftnl_set_list_add_tail);
 
 void nftnl_set_list_del(struct nftnl_set *s)
 {
 	list_del(&s->head);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_del, nft_set_list_del);
+EXPORT_SYMBOL(nftnl_set_list_del);
 
 int nftnl_set_list_foreach(struct nftnl_set_list *set_list,
 			 int (*cb)(struct nftnl_set *t, void *data), void *data)
@@ -1128,7 +1128,7 @@ int nftnl_set_list_foreach(struct nftnl_set_list *set_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_foreach, nft_set_list_foreach);
+EXPORT_SYMBOL(nftnl_set_list_foreach);
 
 struct nftnl_set_list_iter {
 	struct nftnl_set_list	*list;
@@ -1151,13 +1151,13 @@ struct nftnl_set_list_iter *nftnl_set_list_iter_create(struct nftnl_set_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_create, nft_set_list_iter_create);
+EXPORT_SYMBOL(nftnl_set_list_iter_create);
 
 struct nftnl_set *nftnl_set_list_iter_cur(struct nftnl_set_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_cur, nft_set_list_iter_cur);
+EXPORT_SYMBOL(nftnl_set_list_iter_cur);
 
 struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter)
 {
@@ -1173,13 +1173,13 @@ struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter)
 
 	return s;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_next, nft_set_list_iter_next);
+EXPORT_SYMBOL(nftnl_set_list_iter_next);
 
 void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_destroy, nft_set_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_set_list_iter_destroy);
 
 static struct nftnl_set *nftnl_set_lookup(const char *this_set_name,
 				      struct nftnl_set_list *set_list)
diff --git a/src/set_elem.c b/src/set_elem.c
index b9c7e1e..da30b02 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -37,7 +37,7 @@ struct nftnl_set_elem *nftnl_set_elem_alloc(void)
 
 	return s;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_alloc, nft_set_elem_alloc);
+EXPORT_SYMBOL(nftnl_set_elem_alloc);
 
 void nftnl_set_elem_free(struct nftnl_set_elem *s)
 {
@@ -56,13 +56,13 @@ void nftnl_set_elem_free(struct nftnl_set_elem *s)
 
 	xfree(s);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_free, nft_set_elem_free);
+EXPORT_SYMBOL(nftnl_set_elem_free);
 
 bool nftnl_set_elem_is_set(const struct nftnl_set_elem *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_is_set, nft_set_elem_attr_is_set);
+EXPORT_SYMBOL(nftnl_set_elem_is_set);
 
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 {
@@ -95,7 +95,7 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_unset, nft_set_elem_attr_unset);
+EXPORT_SYMBOL(nftnl_set_elem_unset);
 
 void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			   const void *data, uint32_t data_len)
@@ -139,25 +139,25 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 	}
 	s->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set, nft_set_elem_attr_set);
+EXPORT_SYMBOL(nftnl_set_elem_set);
 
 void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, uint32_t val)
 {
 	nftnl_set_elem_set(s, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_u32, nft_set_elem_attr_set_u32);
+EXPORT_SYMBOL(nftnl_set_elem_set_u32);
 
 void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, uint64_t val)
 {
 	nftnl_set_elem_set(s, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_u64, nft_set_elem_attr_set_u64);
+EXPORT_SYMBOL(nftnl_set_elem_set_u64);
 
 void nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str)
 {
 	nftnl_set_elem_set(s, attr, str, strlen(str));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_str, nft_set_elem_attr_set_str);
+EXPORT_SYMBOL(nftnl_set_elem_set_str);
 
 const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t *data_len)
 {
@@ -189,7 +189,7 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_get, nft_set_elem_attr_get);
+EXPORT_SYMBOL(nftnl_set_elem_get);
 
 const char *nftnl_set_elem_get_str(struct nftnl_set_elem *s, uint16_t attr)
 {
@@ -197,7 +197,7 @@ const char *nftnl_set_elem_get_str(struct nftnl_set_elem *s, uint16_t attr)
 
 	return nftnl_set_elem_get(s, attr, &size);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_get_str, nft_set_elem_attr_get_str);
+EXPORT_SYMBOL(nftnl_set_elem_get_str);
 
 uint32_t nftnl_set_elem_get_u32(struct nftnl_set_elem *s, uint16_t attr)
 {
@@ -205,7 +205,7 @@ uint32_t nftnl_set_elem_get_u32(struct nftnl_set_elem *s, uint16_t attr)
 	uint32_t val = *((uint32_t *)nftnl_set_elem_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_get_u32, nft_set_elem_attr_get_u32);
+EXPORT_SYMBOL(nftnl_set_elem_get_u32);
 
 uint64_t nftnl_set_elem_get_u64(struct nftnl_set_elem *s, uint16_t attr)
 {
@@ -213,7 +213,7 @@ uint64_t nftnl_set_elem_get_u64(struct nftnl_set_elem *s, uint16_t attr)
 	uint64_t val = *((uint64_t *)nftnl_set_elem_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_get_u64, nft_set_elem_attr_get_u64);
+EXPORT_SYMBOL(nftnl_set_elem_get_u64);
 
 struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem)
 {
@@ -305,7 +305,7 @@ void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set
 
 	mnl_attr_nest_end(nlh, nest1);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_build_payload, nft_set_elems_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload);
 
 static int nftnl_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -494,7 +494,7 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_parse, nft_set_elems_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_parse);
 
 #ifdef XML_PARSING
 int nftnl_mxml_set_elem_parse(mxml_node_t *tree, struct nftnl_set_elem *e,
@@ -598,14 +598,14 @@ int nftnl_set_elem_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 {
 	return nftnl_set_elem_do_parse(e, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_parse, nft_set_elem_parse);
+EXPORT_SYMBOL(nftnl_set_elem_parse);
 
 int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 			    FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_set_elem_do_parse(e, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_parse_file, nft_set_elem_parse_file);
+EXPORT_SYMBOL(nftnl_set_elem_parse_file);
 
 static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 					const struct nftnl_set_elem *e,
@@ -784,7 +784,7 @@ int nftnl_set_elem_snprintf(char *buf, size_t size,
 	return nftnl_set_elem_cmd_snprintf(buf, size, e, nftnl_flag2cmd(flags),
 					 type, flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_snprintf, nft_set_elem_snprintf);
+EXPORT_SYMBOL(nftnl_set_elem_snprintf);
 
 static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
 				      uint32_t cmd, uint32_t type,
@@ -799,7 +799,7 @@ int nftnl_set_elem_fprintf(FILE *fp, struct nftnl_set_elem *se, uint32_t type,
 	return nftnl_fprintf(fp, se, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_set_elem_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_fprintf, nft_set_elem_fprintf);
+EXPORT_SYMBOL(nftnl_set_elem_fprintf);
 
 int nftnl_set_elem_foreach(struct nftnl_set *s,
 			 int (*cb)(struct nftnl_set_elem *e, void *data),
@@ -815,7 +815,7 @@ int nftnl_set_elem_foreach(struct nftnl_set *s,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elem_foreach, nft_set_elem_foreach);
+EXPORT_SYMBOL(nftnl_set_elem_foreach);
 
 struct nftnl_set_elems_iter {
 	struct nftnl_set			*set;
@@ -841,13 +841,13 @@ struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(struct nftnl_set *s)
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_iter_create, nft_set_elems_iter_create);
+EXPORT_SYMBOL(nftnl_set_elems_iter_create);
 
 struct nftnl_set_elem *nftnl_set_elems_iter_cur(struct nftnl_set_elems_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_iter_cur, nft_set_elems_iter_cur);
+EXPORT_SYMBOL(nftnl_set_elems_iter_cur);
 
 struct nftnl_set_elem *nftnl_set_elems_iter_next(struct nftnl_set_elems_iter *iter)
 {
@@ -862,13 +862,13 @@ struct nftnl_set_elem *nftnl_set_elems_iter_next(struct nftnl_set_elems_iter *it
 
 	return s;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_iter_next, nft_set_elems_iter_next);
+EXPORT_SYMBOL(nftnl_set_elems_iter_next);
 
 void nftnl_set_elems_iter_destroy(struct nftnl_set_elems_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_iter_destroy, nft_set_elems_iter_destroy);
+EXPORT_SYMBOL(nftnl_set_elems_iter_destroy);
 
 static bool nftnl_attr_nest_overflow(struct nlmsghdr *nlh,
 				   const struct nlattr *from,
@@ -913,4 +913,4 @@ int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 
 	return ret;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_build_payload_iter, nft_set_elems_nlmsg_build_payload_iter);
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload_iter);
diff --git a/src/table.c b/src/table.c
index 42fe49f..6e5e267 100644
--- a/src/table.c
+++ b/src/table.c
@@ -40,7 +40,7 @@ struct nftnl_table *nftnl_table_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_table));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_alloc, nft_table_alloc);
+EXPORT_SYMBOL(nftnl_table_alloc);
 
 void nftnl_table_free(const struct nftnl_table *t)
 {
@@ -49,13 +49,13 @@ void nftnl_table_free(const struct nftnl_table *t)
 
 	xfree(t);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_free, nft_table_free);
+EXPORT_SYMBOL(nftnl_table_free);
 
 bool nftnl_table_is_set(const struct nftnl_table *t, uint16_t attr)
 {
 	return t->flags & (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_is_set, nft_table_attr_is_set);
+EXPORT_SYMBOL(nftnl_table_is_set);
 
 void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 {
@@ -77,7 +77,7 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 	}
 	t->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_unset, nft_table_attr_unset);
+EXPORT_SYMBOL(nftnl_table_unset);
 
 static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FLAGS]	= sizeof(uint32_t),
@@ -111,31 +111,31 @@ void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 	}
 	t->flags |= (1 << attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_set_data, nft_table_attr_set_data);
+EXPORT_SYMBOL(nftnl_table_set_data);
 
 void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data)
 {
 	nftnl_table_set_data(t, attr, data, nftnl_table_validate[attr]);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_set, nft_table_attr_set);
+EXPORT_SYMBOL(nftnl_table_set);
 
 void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t val)
 {
 	nftnl_table_set_data(t, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_set_u32, nft_table_attr_set_u32);
+EXPORT_SYMBOL(nftnl_table_set_u32);
 
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t val)
 {
 	nftnl_table_set_data(t, attr, &val, sizeof(uint8_t));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_set_u8, nft_table_attr_set_u8);
+EXPORT_SYMBOL(nftnl_table_set_u8);
 
 void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str)
 {
 	nftnl_table_set_data(t, attr, str, 0);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_set_str, nft_table_attr_set_str);
+EXPORT_SYMBOL(nftnl_table_set_str);
 
 const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 				 uint32_t *data_len)
@@ -158,34 +158,34 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_get_data, nft_table_attr_get_data);
+EXPORT_SYMBOL(nftnl_table_get_data);
 
 const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_table_get_data(t, attr, &data_len);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_get, nft_table_attr_get);
+EXPORT_SYMBOL(nftnl_table_get);
 
 uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_get_u32, nft_table_attr_get_u32);
+EXPORT_SYMBOL(nftnl_table_get_u32);
 
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint8_t *)ret);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_get_u8, nft_table_attr_get_u8);
+EXPORT_SYMBOL(nftnl_table_get_u8);
 
 const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr)
 {
 	return nftnl_table_get(t, attr);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_get_str, nft_table_attr_get_str);
+EXPORT_SYMBOL(nftnl_table_get_str);
 
 void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_table *t)
 {
@@ -194,7 +194,7 @@ void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ta
 	if (t->flags & (1 << NFTNL_TABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_nlmsg_build_payload, nft_table_nlmsg_build_payload);
+EXPORT_SYMBOL(nftnl_table_nlmsg_build_payload);
 
 static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -247,7 +247,7 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_nlmsg_parse, nft_table_nlmsg_parse);
+EXPORT_SYMBOL(nftnl_table_nlmsg_parse);
 
 #ifdef XML_PARSING
 int nftnl_mxml_table_parse(mxml_node_t *tree, struct nftnl_table *t,
@@ -384,14 +384,14 @@ int nftnl_table_parse(struct nftnl_table *t, enum nftnl_parse_type type,
 {
 	return nftnl_table_do_parse(t, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_parse, nft_table_parse);
+EXPORT_SYMBOL(nftnl_table_parse);
 
 int nftnl_table_parse_file(struct nftnl_table *t, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_table_do_parse(t, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_parse_file, nft_table_parse_file);
+EXPORT_SYMBOL(nftnl_table_parse_file);
 
 static int nftnl_table_export(char *buf, size_t size,
 			      const struct nftnl_table *t, int type)
@@ -455,7 +455,7 @@ int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t,
 	return nftnl_table_cmd_snprintf(buf, size, t, nftnl_flag2cmd(flags), type,
 				      flags);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_snprintf, nft_table_snprintf);
+EXPORT_SYMBOL(nftnl_table_snprintf);
 
 static int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
@@ -469,7 +469,7 @@ int nftnl_table_fprintf(FILE *fp, const struct nftnl_table *t, uint32_t type,
 	return nftnl_fprintf(fp, t, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_table_do_snprintf);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_fprintf, nft_table_fprintf);
+EXPORT_SYMBOL(nftnl_table_fprintf);
 
 struct nftnl_table_list {
 	struct list_head list;
@@ -487,7 +487,7 @@ struct nftnl_table_list *nftnl_table_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_alloc, nft_table_list_alloc);
+EXPORT_SYMBOL(nftnl_table_list_alloc);
 
 void nftnl_table_list_free(struct nftnl_table_list *list)
 {
@@ -499,31 +499,31 @@ void nftnl_table_list_free(struct nftnl_table_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_free, nft_table_list_free);
+EXPORT_SYMBOL(nftnl_table_list_free);
 
 int nftnl_table_list_is_empty(const struct nftnl_table_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_is_empty, nft_table_list_is_empty);
+EXPORT_SYMBOL(nftnl_table_list_is_empty);
 
 void nftnl_table_list_add(struct nftnl_table *r, struct nftnl_table_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_add, nft_table_list_add);
+EXPORT_SYMBOL(nftnl_table_list_add);
 
 void nftnl_table_list_add_tail(struct nftnl_table *r, struct nftnl_table_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_add_tail, nft_table_list_add_tail);
+EXPORT_SYMBOL(nftnl_table_list_add_tail);
 
 void nftnl_table_list_del(struct nftnl_table *t)
 {
 	list_del(&t->head);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_del, nft_table_list_del);
+EXPORT_SYMBOL(nftnl_table_list_del);
 
 int nftnl_table_list_foreach(struct nftnl_table_list *table_list,
 			   int (*cb)(struct nftnl_table *t, void *data),
@@ -539,7 +539,7 @@ int nftnl_table_list_foreach(struct nftnl_table_list *table_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_foreach, nft_table_list_foreach);
+EXPORT_SYMBOL(nftnl_table_list_foreach);
 
 struct nftnl_table_list_iter {
 	struct nftnl_table_list	*list;
@@ -562,7 +562,7 @@ struct nftnl_table_list_iter *nftnl_table_list_iter_create(struct nftnl_table_li
 
 	return iter;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_iter_create, nft_table_list_iter_create);
+EXPORT_SYMBOL(nftnl_table_list_iter_create);
 
 struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *iter)
 {
@@ -578,10 +578,10 @@ struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *ite
 
 	return r;
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_iter_next, nft_table_list_iter_next);
+EXPORT_SYMBOL(nftnl_table_list_iter_next);
 
 void nftnl_table_list_iter_destroy(const struct nftnl_table_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL_ALIAS(nftnl_table_list_iter_destroy, nft_table_list_iter_destroy);
+EXPORT_SYMBOL(nftnl_table_list_iter_destroy);
-- 
2.1.4

