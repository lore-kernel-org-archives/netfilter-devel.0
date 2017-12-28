From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: Fix exporting symbols with clang
Date: Thu, 28 Dec 2017 19:48:30 +0100
Message-ID: <20171228184830.7593-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753792AbdL1Ssl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Dec 2017 13:48:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D900F249C2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:48:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EC53DA3A3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:48:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12121DA848
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:48:34 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1CDFC4265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:48:33 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Armin Krejzi <krejzi@email.com>

When EXPORT_SYMBOL is located after function definition,
clang won't properly export the function, resulting
in a library with no symbols when built with clang.

Based on libmnl commit dcdb47373a37 ("Move declaration of visibility
attributes before definition.")

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1205
Signed-off-by: Armin Krejzi <krejzi@email.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Armin cannot post this to the ml for some reason, so I'm sending it for
him.

 src/batch.c    | 14 +++++------
 src/chain.c    | 68 +++++++++++++++++++++++++--------------------------
 src/common.c   | 14 +++++------
 src/expr.c     | 36 +++++++++++++--------------
 src/gen.c      | 26 ++++++++++----------
 src/object.c   | 66 ++++++++++++++++++++++++-------------------------
 src/rule.c     | 77 +++++++++++++++++++++++++++++-----------------------------
 src/ruleset.c  | 32 ++++++++++++------------
 src/set.c      | 66 +++++++++++++++++++++++++------------------------
 src/set_elem.c | 49 +++++++++++++++++++------------------
 src/table.c    | 60 ++++++++++++++++++++++-----------------------
 src/trace.c    |  2 +-
 src/udata.c    | 32 ++++++++++++------------
 13 files changed, 273 insertions(+), 269 deletions(-)

diff --git a/src/batch.c b/src/batch.c
index 5ee3fd7..ca8f922 100644
--- a/src/batch.c
+++ b/src/batch.c
@@ -57,6 +57,7 @@ static void nftnl_batch_add_page(struct nftnl_batch_page *page,
 	list_add_tail(&page->head, &batch->page_list);
 }
 
+EXPORT_SYMBOL(nftnl_batch_alloc);
 struct nftnl_batch *nftnl_batch_alloc(uint32_t pg_size, uint32_t pg_overrun_size)
 {
 	struct nftnl_batch *batch;
@@ -80,8 +81,8 @@ err1:
 	free(batch);
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_batch_alloc);
 
+EXPORT_SYMBOL(nftnl_batch_free);
 void nftnl_batch_free(struct nftnl_batch *batch)
 {
 	struct nftnl_batch_page *page, *next;
@@ -94,8 +95,8 @@ void nftnl_batch_free(struct nftnl_batch *batch)
 
 	free(batch);
 }
-EXPORT_SYMBOL(nftnl_batch_free);
 
+EXPORT_SYMBOL(nftnl_batch_update);
 int nftnl_batch_update(struct nftnl_batch *batch)
 {
 	struct nftnl_batch_page *page;
@@ -119,20 +120,20 @@ int nftnl_batch_update(struct nftnl_batch *batch)
 err1:
 	return -1;
 }
-EXPORT_SYMBOL(nftnl_batch_update);
 
+EXPORT_SYMBOL(nftnl_batch_buffer);
 void *nftnl_batch_buffer(struct nftnl_batch *batch)
 {
 	return mnl_nlmsg_batch_current(batch->current_page->batch);
 }
-EXPORT_SYMBOL(nftnl_batch_buffer);
 
+EXPORT_SYMBOL(nftnl_batch_buffer_len);
 uint32_t nftnl_batch_buffer_len(struct nftnl_batch *batch)
 {
 	return mnl_nlmsg_batch_size(batch->current_page->batch);
 }
-EXPORT_SYMBOL(nftnl_batch_buffer_len);
 
+EXPORT_SYMBOL(nftnl_batch_iovec_len);
 int nftnl_batch_iovec_len(struct nftnl_batch *batch)
 {
 	int num_pages = batch->num_pages;
@@ -143,8 +144,8 @@ int nftnl_batch_iovec_len(struct nftnl_batch *batch)
 
 	return num_pages;
 }
-EXPORT_SYMBOL(nftnl_batch_iovec_len);
 
+EXPORT_SYMBOL(nftnl_batch_iovec);
 void nftnl_batch_iovec(struct nftnl_batch *batch, struct iovec *iov,
 		       uint32_t iovlen)
 {
@@ -160,4 +161,3 @@ void nftnl_batch_iovec(struct nftnl_batch *batch, struct iovec *iov,
 		i++;
 	}
 }
-EXPORT_SYMBOL(nftnl_batch_iovec);
diff --git a/src/chain.c b/src/chain.c
index a11bcf5..eff5186 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -87,12 +87,13 @@ static const char *nftnl_hooknum2str(int family, int hooknum)
 	return "unknown";
 }
 
+EXPORT_SYMBOL(nftnl_chain_alloc);
 struct nftnl_chain *nftnl_chain_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_chain));
 }
-EXPORT_SYMBOL(nftnl_chain_alloc);
 
+EXPORT_SYMBOL(nftnl_chain_free);
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
 	if (c->flags & (1 << NFTNL_CHAIN_NAME))
@@ -105,14 +106,14 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 		xfree(c->dev);
 	xfree(c);
 }
-EXPORT_SYMBOL(nftnl_chain_free);
 
+EXPORT_SYMBOL(nftnl_chain_is_set);
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr)
 {
 	return c->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_chain_is_set);
 
+EXPORT_SYMBOL(nftnl_chain_unset);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 {
 	if (!(c->flags & (1 << attr)))
@@ -147,7 +148,6 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 
 	c->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_chain_unset);
 
 static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_HOOKNUM]	= sizeof(uint32_t),
@@ -159,6 +159,7 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_FAMILY]		= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_chain_set_data);
 int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			 const void *data, uint32_t data_len)
 {
@@ -226,44 +227,44 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 	c->flags |= (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_chain_set_data);
 
+EXPORT_SYMBOL(nftnl_chain_set);
 void nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void *data)
 {
 	nftnl_chain_set_data(c, attr, data, nftnl_chain_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_chain_set);
 
+EXPORT_SYMBOL(nftnl_chain_set_u32);
 void nftnl_chain_set_u32(struct nftnl_chain *c, uint16_t attr, uint32_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_chain_set_u32);
 
+EXPORT_SYMBOL(nftnl_chain_set_s32);
 void nftnl_chain_set_s32(struct nftnl_chain *c, uint16_t attr, int32_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(int32_t));
 }
-EXPORT_SYMBOL(nftnl_chain_set_s32);
 
+EXPORT_SYMBOL(nftnl_chain_set_u64);
 void nftnl_chain_set_u64(struct nftnl_chain *c, uint16_t attr, uint64_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nftnl_chain_set_u64);
 
+EXPORT_SYMBOL(nftnl_chain_set_u8);
 void nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t data)
 {
 	nftnl_chain_set_data(c, attr, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nftnl_chain_set_u8);
 
+EXPORT_SYMBOL(nftnl_chain_set_str);
 int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
 {
 	return nftnl_chain_set_data(c, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_chain_set_str);
 
+EXPORT_SYMBOL(nftnl_chain_get_data);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 				 uint32_t *data_len)
 {
@@ -310,21 +311,21 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_chain_get_data);
 
+EXPORT_SYMBOL(nftnl_chain_get);
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_chain_get_data(c, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_chain_get);
 
+EXPORT_SYMBOL(nftnl_chain_get_str);
 const char *nftnl_chain_get_str(const struct nftnl_chain *c, uint16_t attr)
 {
 	return nftnl_chain_get(c, attr);
 }
-EXPORT_SYMBOL(nftnl_chain_get_str);
 
+EXPORT_SYMBOL(nftnl_chain_get_u32);
 uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
@@ -334,8 +335,8 @@ uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_chain_get_u32);
 
+EXPORT_SYMBOL(nftnl_chain_get_s32);
 int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
@@ -345,8 +346,8 @@ int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_chain_get_s32);
 
+EXPORT_SYMBOL(nftnl_chain_get_u64);
 uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
@@ -356,8 +357,8 @@ uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_chain_get_u64);
 
+EXPORT_SYMBOL(nftnl_chain_get_u8);
 uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 {
 	uint32_t data_len;
@@ -367,8 +368,8 @@ uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_chain_get_u8);
 
+EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_chain *c)
 {
 	if (c->flags & (1 << NFTNL_CHAIN_TABLE))
@@ -404,7 +405,6 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 	if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
 }
-EXPORT_SYMBOL(nftnl_chain_nlmsg_build_payload);
 
 static int nftnl_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -529,6 +529,7 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_chain_nlmsg_parse);
 int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 {
 	struct nlattr *tb[NFTA_CHAIN_MAX+1] = {};
@@ -590,7 +591,6 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 
 	return ret;
 }
-EXPORT_SYMBOL(nftnl_chain_nlmsg_parse);
 
 static inline int nftnl_str2hooknum(int family, const char *hook)
 {
@@ -732,19 +732,19 @@ static int nftnl_chain_do_parse(struct nftnl_chain *c, enum nftnl_parse_type typ
 	return ret;
 }
 
+EXPORT_SYMBOL(nftnl_chain_parse);
 int nftnl_chain_parse(struct nftnl_chain *c, enum nftnl_parse_type type,
 		    const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_chain_do_parse(c, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_chain_parse);
 
+EXPORT_SYMBOL(nftnl_chain_parse_file);
 int nftnl_chain_parse_file(struct nftnl_chain *c, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_chain_do_parse(c, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_chain_parse_file);
 
 static int nftnl_chain_export(char *buf, size_t size,
 			      const struct nftnl_chain *c, int type)
@@ -850,6 +850,7 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_chain_snprintf);
 int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *c,
 			 uint32_t type, uint32_t flags)
 {
@@ -859,7 +860,6 @@ int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *c,
 	return nftnl_chain_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags),
 					type, flags);
 }
-EXPORT_SYMBOL(nftnl_chain_snprintf);
 
 static int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
@@ -867,18 +867,19 @@ static int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
 	return nftnl_chain_snprintf(buf, size, c, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_chain_fprintf);
 int nftnl_chain_fprintf(FILE *fp, const struct nftnl_chain *c, uint32_t type,
 			uint32_t flags)
 {
 	return nftnl_fprintf(fp, c, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_chain_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_chain_fprintf);
 
 struct nftnl_chain_list {
 	struct list_head list;
 };
 
+EXPORT_SYMBOL(nftnl_chain_list_alloc);
 struct nftnl_chain_list *nftnl_chain_list_alloc(void)
 {
 	struct nftnl_chain_list *list;
@@ -891,8 +892,8 @@ struct nftnl_chain_list *nftnl_chain_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nftnl_chain_list_alloc);
 
+EXPORT_SYMBOL(nftnl_chain_list_free);
 void nftnl_chain_list_free(struct nftnl_chain_list *list)
 {
 	struct nftnl_chain *r, *tmp;
@@ -903,32 +904,32 @@ void nftnl_chain_list_free(struct nftnl_chain_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_chain_list_free);
 
+EXPORT_SYMBOL(nftnl_chain_list_is_empty);
 int nftnl_chain_list_is_empty(const struct nftnl_chain_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_chain_list_is_empty);
 
+EXPORT_SYMBOL(nftnl_chain_list_add);
 void nftnl_chain_list_add(struct nftnl_chain *r, struct nftnl_chain_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_chain_list_add);
 
+EXPORT_SYMBOL(nftnl_chain_list_add_tail);
 void nftnl_chain_list_add_tail(struct nftnl_chain *r, struct nftnl_chain_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_chain_list_add_tail);
 
+EXPORT_SYMBOL(nftnl_chain_list_del);
 void nftnl_chain_list_del(struct nftnl_chain *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL(nftnl_chain_list_del);
 
+EXPORT_SYMBOL(nftnl_chain_list_foreach);
 int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list,
 			   int (*cb)(struct nftnl_chain *r, void *data),
 			   void *data)
@@ -943,13 +944,13 @@ int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_chain_list_foreach);
 
 struct nftnl_chain_list_iter {
 	const struct nftnl_chain_list	*list;
 	struct nftnl_chain		*cur;
 };
 
+EXPORT_SYMBOL(nftnl_chain_list_iter_create);
 struct nftnl_chain_list_iter *
 nftnl_chain_list_iter_create(const struct nftnl_chain_list *l)
 {
@@ -967,8 +968,8 @@ nftnl_chain_list_iter_create(const struct nftnl_chain_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_chain_list_iter_create);
 
+EXPORT_SYMBOL(nftnl_chain_list_iter_next);
 struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *iter)
 {
 	struct nftnl_chain *r = iter->cur;
@@ -983,10 +984,9 @@ struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *ite
 
 	return r;
 }
-EXPORT_SYMBOL(nftnl_chain_list_iter_next);
 
+EXPORT_SYMBOL(nftnl_chain_list_iter_destroy);
 void nftnl_chain_list_iter_destroy(struct nftnl_chain_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_chain_list_iter_destroy);
diff --git a/src/common.c b/src/common.c
index a95883c..561c954 100644
--- a/src/common.c
+++ b/src/common.c
@@ -43,14 +43,15 @@ static struct nlmsghdr *__nftnl_nlmsg_build_hdr(char *buf, uint16_t type,
 	return nlh;
 }
 
+EXPORT_SYMBOL(nftnl_nlmsg_build_hdr);
 struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t type, uint16_t family,
 				       uint16_t flags, uint32_t seq)
 {
 	return __nftnl_nlmsg_build_hdr(buf, (NFNL_SUBSYS_NFTABLES << 8) | type,
 				       family, flags, seq, 0);
 }
-EXPORT_SYMBOL(nftnl_nlmsg_build_hdr);
 
+EXPORT_SYMBOL(nftnl_parse_err_alloc);
 struct nftnl_parse_err *nftnl_parse_err_alloc(void)
 {
 	struct nftnl_parse_err *err;
@@ -63,14 +64,14 @@ struct nftnl_parse_err *nftnl_parse_err_alloc(void)
 
 	return err;
 }
-EXPORT_SYMBOL(nftnl_parse_err_alloc);
 
+EXPORT_SYMBOL(nftnl_parse_err_free);
 void nftnl_parse_err_free(struct nftnl_parse_err *err)
 {
 	xfree(err);
 }
-EXPORT_SYMBOL(nftnl_parse_err_free);
 
+EXPORT_SYMBOL(nftnl_parse_perror);
 int nftnl_parse_perror(const char *msg, struct nftnl_parse_err *err)
 {
 	switch (err->error) {
@@ -89,7 +90,6 @@ int nftnl_parse_perror(const char *msg, struct nftnl_parse_err *err)
 		return fprintf(stderr, "%s: Undefined error\n", msg);
 	}
 }
-EXPORT_SYMBOL(nftnl_parse_perror);
 
 int nftnl_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
 			    uint32_t flags)
@@ -165,20 +165,21 @@ int nftnl_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
 			   nftnl_cmd_footer_fprintf_cb);
 }
 
+EXPORT_SYMBOL(nftnl_batch_begin);
 struct nlmsghdr *nftnl_batch_begin(char *buf, uint32_t seq)
 {
 	return __nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, AF_UNSPEC,
 				       0, seq, NFNL_SUBSYS_NFTABLES);
 }
-EXPORT_SYMBOL(nftnl_batch_begin);
 
+EXPORT_SYMBOL(nftnl_batch_end);
 struct nlmsghdr *nftnl_batch_end(char *buf, uint32_t seq)
 {
 	return __nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_END, AF_UNSPEC,
 				       0, seq, NFNL_SUBSYS_NFTABLES);
 }
-EXPORT_SYMBOL(nftnl_batch_end);
 
+EXPORT_SYMBOL(nftnl_batch_is_supported);
 int nftnl_batch_is_supported(void)
 {
 	struct mnl_socket *nl;
@@ -236,4 +237,3 @@ err:
 	mnl_nlmsg_batch_stop(b);
 	return -1;
 }
-EXPORT_SYMBOL(nftnl_batch_is_supported);
diff --git a/src/expr.c b/src/expr.c
index 1eae707..62565e0 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -24,6 +24,7 @@
 
 #include <libnftnl/expr.h>
 
+EXPORT_SYMBOL(nftnl_expr_alloc);
 struct nftnl_expr *nftnl_expr_alloc(const char *name)
 {
 	struct nftnl_expr *expr;
@@ -43,8 +44,8 @@ struct nftnl_expr *nftnl_expr_alloc(const char *name)
 
 	return expr;
 }
-EXPORT_SYMBOL(nftnl_expr_alloc);
 
+EXPORT_SYMBOL(nftnl_expr_free);
 void nftnl_expr_free(const struct nftnl_expr *expr)
 {
 	if (expr->ops->free)
@@ -52,14 +53,14 @@ void nftnl_expr_free(const struct nftnl_expr *expr)
 
 	xfree(expr);
 }
-EXPORT_SYMBOL(nftnl_expr_free);
 
+EXPORT_SYMBOL(nftnl_expr_is_set);
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type)
 {
 	return expr->flags & (1 << type);
 }
-EXPORT_SYMBOL(nftnl_expr_is_set);
 
+EXPORT_SYMBOL(nftnl_expr_set);
 int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 		   const void *data, uint32_t data_len)
 {
@@ -73,42 +74,42 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 	expr->flags |= (1 << type);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_expr_set);
 
+EXPORT_SYMBOL(nftnl_expr_set_u8);
 void
 nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nftnl_expr_set_u8);
 
+EXPORT_SYMBOL(nftnl_expr_set_u16);
 void
 nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint16_t));
 }
-EXPORT_SYMBOL(nftnl_expr_set_u16);
 
+EXPORT_SYMBOL(nftnl_expr_set_u32);
 void
 nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_expr_set_u32);
 
+EXPORT_SYMBOL(nftnl_expr_set_u64);
 void
 nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_t data)
 {
 	nftnl_expr_set(expr, type, &data, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nftnl_expr_set_u64);
 
+EXPORT_SYMBOL(nftnl_expr_set_str);
 int nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char *str)
 {
 	return nftnl_expr_set(expr, type, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_expr_set_str);
 
+EXPORT_SYMBOL(nftnl_expr_get);
 const void *nftnl_expr_get(const struct nftnl_expr *expr,
 			      uint16_t type, uint32_t *data_len)
 {
@@ -129,8 +130,8 @@ const void *nftnl_expr_get(const struct nftnl_expr *expr,
 
 	return ret;
 }
-EXPORT_SYMBOL(nftnl_expr_get);
 
+EXPORT_SYMBOL(nftnl_expr_get_u8);
 uint8_t nftnl_expr_get_u8(const struct nftnl_expr *expr, uint16_t type)
 {
 	const void *data;
@@ -145,8 +146,8 @@ uint8_t nftnl_expr_get_u8(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint8_t *)data);
 }
-EXPORT_SYMBOL(nftnl_expr_get_u8);
 
+EXPORT_SYMBOL(nftnl_expr_get_u16);
 uint16_t nftnl_expr_get_u16(const struct nftnl_expr *expr, uint16_t type)
 {
 	const void *data;
@@ -161,8 +162,8 @@ uint16_t nftnl_expr_get_u16(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint16_t *)data);
 }
-EXPORT_SYMBOL(nftnl_expr_get_u16);
 
+EXPORT_SYMBOL(nftnl_expr_get_u32);
 uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type)
 {
 	const void *data;
@@ -177,8 +178,8 @@ uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint32_t *)data);
 }
-EXPORT_SYMBOL(nftnl_expr_get_u32);
 
+EXPORT_SYMBOL(nftnl_expr_get_u64);
 uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type)
 {
 	const void *data;
@@ -193,16 +194,16 @@ uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type)
 
 	return *((uint64_t *)data);
 }
-EXPORT_SYMBOL(nftnl_expr_get_u64);
 
+EXPORT_SYMBOL(nftnl_expr_get_str);
 const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 {
 	uint32_t data_len;
 
 	return (const char *)nftnl_expr_get(expr, type, &data_len);
 }
-EXPORT_SYMBOL(nftnl_expr_get_str);
 
+EXPORT_SYMBOL(nftnl_expr_cmp);
 bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
 {
 	if (e1->flags != e2->flags ||
@@ -211,7 +212,6 @@ bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
 
 	return e1->ops->cmp(e1, e2);
 }
-EXPORT_SYMBOL(nftnl_expr_cmp);
 
 void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
 {
@@ -275,6 +275,7 @@ err1:
 	return NULL;
 }
 
+EXPORT_SYMBOL(nftnl_expr_snprintf);
 int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 			uint32_t type, uint32_t flags)
 {
@@ -292,7 +293,6 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 
 	return offset;
 }
-EXPORT_SYMBOL(nftnl_expr_snprintf);
 
 static int nftnl_expr_do_snprintf(char *buf, size_t size, const void *e,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
@@ -300,10 +300,10 @@ static int nftnl_expr_do_snprintf(char *buf, size_t size, const void *e,
 	return nftnl_expr_snprintf(buf, size, e, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_expr_fprintf);
 int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
 		       uint32_t flags)
 {
 	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
 			     nftnl_expr_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_expr_fprintf);
diff --git a/src/gen.c b/src/gen.c
index eafb015..f92180c 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -29,24 +29,25 @@ struct nftnl_gen {
 	uint32_t flags;
 };
 
+EXPORT_SYMBOL(nftnl_gen_alloc);
 struct nftnl_gen *nftnl_gen_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_gen));
 }
-EXPORT_SYMBOL(nftnl_gen_alloc);
 
+EXPORT_SYMBOL(nftnl_gen_free);
 void nftnl_gen_free(const struct nftnl_gen *gen)
 {
 	xfree(gen);
 }
-EXPORT_SYMBOL(nftnl_gen_free);
 
+EXPORT_SYMBOL(nftnl_gen_is_set);
 bool nftnl_gen_is_set(const struct nftnl_gen *gen, uint16_t attr)
 {
 	return gen->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_gen_is_set);
 
+EXPORT_SYMBOL(nftnl_gen_unset);
 void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr)
 {
 	if (!(gen->flags & (1 << attr)))
@@ -58,12 +59,12 @@ void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr)
 	}
 	gen->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_gen_unset);
 
 static uint32_t nftnl_gen_validate[NFTNL_GEN_MAX + 1] = {
 	[NFTNL_GEN_ID]	= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_gen_set_data);
 int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 		       const void *data, uint32_t data_len)
 {
@@ -78,20 +79,20 @@ int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 	gen->flags |= (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_gen_set_data);
 
+EXPORT_SYMBOL(nftnl_gen_set);
 int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data)
 {
 	return nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_gen_set);
 
+EXPORT_SYMBOL(nftnl_gen_set_u32);
 void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t val)
 {
 	nftnl_gen_set_data(gen, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_gen_set_u32);
 
+EXPORT_SYMBOL(nftnl_gen_get_data);
 const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
 			       uint32_t *data_len)
 {
@@ -105,21 +106,20 @@ const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_gen_get_data);
 
+EXPORT_SYMBOL(nftnl_gen_get);
 const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_gen_get_data(gen, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_gen_get);
 
+EXPORT_SYMBOL(nftnl_gen_get_u32);
 uint32_t nftnl_gen_get_u32(const struct nftnl_gen *gen, uint16_t attr)
 {
 	const void *ret = nftnl_gen_get(gen, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_gen_get_u32);
 
 static int nftnl_gen_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -140,6 +140,7 @@ static int nftnl_gen_parse_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+EXPORT_SYMBOL(nftnl_gen_nlmsg_parse);
 int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 {
 	struct nlattr *tb[NFTA_GEN_MAX + 1] = {};
@@ -154,7 +155,6 @@ int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_gen_nlmsg_parse);
 
 static int nftnl_gen_snprintf_default(char *buf, size_t size,
 				      const struct nftnl_gen *gen)
@@ -186,6 +186,7 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_gen_snprintf);
 int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen,
 		       uint32_t type, uint32_t flags)
 {
@@ -195,7 +196,6 @@ int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen,
 	return nftnl_gen_cmd_snprintf(buf, size, gen, nftnl_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL(nftnl_gen_snprintf);
 
 static int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
@@ -203,10 +203,10 @@ static int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
 	return nftnl_gen_snprintf(buf, size, gen, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_gen_fprintf);
 int nftnl_gen_fprintf(FILE *fp, const struct nftnl_gen *gen, uint32_t type,
 		      uint32_t flags)
 {
 	return nftnl_fprintf(fp, gen, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_gen_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_gen_fprintf);
diff --git a/src/object.c b/src/object.c
index da3423b..30000f7 100644
--- a/src/object.c
+++ b/src/object.c
@@ -40,12 +40,13 @@ static struct obj_ops *nftnl_obj_ops_lookup(uint32_t type)
 	return obj_ops[type];
 }
 
+EXPORT_SYMBOL(nftnl_obj_alloc);
 struct nftnl_obj *nftnl_obj_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_obj));
 }
-EXPORT_SYMBOL(nftnl_obj_alloc);
 
+EXPORT_SYMBOL(nftnl_obj_free);
 void nftnl_obj_free(const struct nftnl_obj *obj)
 {
 	if (obj->flags & (1 << NFTNL_OBJ_TABLE))
@@ -55,19 +56,19 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 
 	xfree(obj);
 }
-EXPORT_SYMBOL(nftnl_obj_free);
 
+EXPORT_SYMBOL(nftnl_obj_is_set);
 bool nftnl_obj_is_set(const struct nftnl_obj *obj, uint16_t attr)
 {
 	return obj->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_obj_is_set);
 
 static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
 	[NFTNL_OBJ_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_OBJ_USE]		= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_obj_set_data);
 void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 			const void *data, uint32_t data_len)
 {
@@ -101,44 +102,44 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	}
 	obj->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_obj_set_data);
 
+EXPORT_SYMBOL(nftnl_obj_set);
 void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data)
 {
 	nftnl_obj_set_data(obj, attr, data, nftnl_obj_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_obj_set);
 
+EXPORT_SYMBOL(nftnl_obj_set_u8);
 void nftnl_obj_set_u8(struct nftnl_obj *obj, uint16_t attr, uint8_t val)
 {
 	nftnl_obj_set_data(obj, attr, &val, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nftnl_obj_set_u8);
 
+EXPORT_SYMBOL(nftnl_obj_set_u16);
 void nftnl_obj_set_u16(struct nftnl_obj *obj, uint16_t attr, uint16_t val)
 {
 	nftnl_obj_set_data(obj, attr, &val, sizeof(uint16_t));
 }
-EXPORT_SYMBOL(nftnl_obj_set_u16);
 
+EXPORT_SYMBOL(nftnl_obj_set_u32);
 void nftnl_obj_set_u32(struct nftnl_obj *obj, uint16_t attr, uint32_t val)
 {
 	nftnl_obj_set_data(obj, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_obj_set_u32);
 
+EXPORT_SYMBOL(nftnl_obj_set_u64);
 void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val)
 {
 	nftnl_obj_set_data(obj, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nftnl_obj_set_u64);
 
+EXPORT_SYMBOL(nftnl_obj_set_str);
 void nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t attr, const char *str)
 {
 	nftnl_obj_set_data(obj, attr, str, 0);
 }
-EXPORT_SYMBOL(nftnl_obj_set_str);
 
+EXPORT_SYMBOL(nftnl_obj_get_data);
 const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
 			       uint32_t *data_len)
 {
@@ -169,49 +170,49 @@ const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_obj_get_data);
 
+EXPORT_SYMBOL(nftnl_obj_get);
 const void *nftnl_obj_get(struct nftnl_obj *obj, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_obj_get_data(obj, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_obj_get);
 
+EXPORT_SYMBOL(nftnl_obj_get_u8);
 uint8_t nftnl_obj_get_u8(struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret = nftnl_obj_get(obj, attr);
 	return ret == NULL ? 0 : *((uint8_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_obj_get_u8);
 
+EXPORT_SYMBOL(nftnl_obj_get_u16);
 uint16_t nftnl_obj_get_u16(struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret = nftnl_obj_get(obj, attr);
 	return ret == NULL ? 0 : *((uint16_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_obj_get_u16);
 
+EXPORT_SYMBOL(nftnl_obj_get_u32);
 uint32_t nftnl_obj_get_u32(struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret = nftnl_obj_get(obj, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_obj_get_u32);
 
+EXPORT_SYMBOL(nftnl_obj_get_u64);
 uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret = nftnl_obj_get(obj, attr);
 	return ret == NULL ? 0 : *((uint64_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_obj_get_u64);
 
+EXPORT_SYMBOL(nftnl_obj_get_str);
 const char *nftnl_obj_get_str(struct nftnl_obj *obj, uint16_t attr)
 {
 	return nftnl_obj_get(obj, attr);
 }
-EXPORT_SYMBOL(nftnl_obj_get_str);
 
+EXPORT_SYMBOL(nftnl_obj_nlmsg_build_payload);
 void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 				   const struct nftnl_obj *obj)
 {
@@ -229,7 +230,6 @@ void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_nest_end(nlh, nest);
 	}
 }
-EXPORT_SYMBOL(nftnl_obj_nlmsg_build_payload);
 
 static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -259,6 +259,7 @@ static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+EXPORT_SYMBOL(nftnl_obj_nlmsg_parse);
 int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 {
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
@@ -300,7 +301,6 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_obj_nlmsg_parse);
 
 #ifdef JSON_PARSING
 static int nftnl_jansson_parse_obj(struct nftnl_obj *t, json_t *tree,
@@ -378,19 +378,19 @@ static int nftnl_obj_do_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
 	return ret;
 }
 
+EXPORT_SYMBOL(nftnl_obj_parse);
 int nftnl_obj_parse(struct nftnl_obj *obj, enum nftnl_parse_type type,
 		      const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_obj_do_parse(obj, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_obj_parse);
 
+EXPORT_SYMBOL(nftnl_obj_parse_file);
 int nftnl_obj_parse_file(struct nftnl_obj *obj, enum nftnl_parse_type type,
 			   FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_obj_do_parse(obj, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_obj_parse_file);
 
 static int nftnl_obj_export(char *buf, size_t size,
 			    const struct nftnl_obj *obj,
@@ -471,6 +471,7 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_obj_snprintf);
 int nftnl_obj_snprintf(char *buf, size_t size, const struct nftnl_obj *obj,
 		       uint32_t type, uint32_t flags)
 {
@@ -480,7 +481,6 @@ int nftnl_obj_snprintf(char *buf, size_t size, const struct nftnl_obj *obj,
 	return nftnl_obj_cmd_snprintf(buf, size, obj, nftnl_flag2cmd(flags),
 				      type, flags);
 }
-EXPORT_SYMBOL(nftnl_obj_snprintf);
 
 static int nftnl_obj_do_snprintf(char *buf, size_t size, const void *obj,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
@@ -488,18 +488,19 @@ static int nftnl_obj_do_snprintf(char *buf, size_t size, const void *obj,
 	return nftnl_obj_snprintf(buf, size, obj, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_obj_fprintf);
 int nftnl_obj_fprintf(FILE *fp, const struct nftnl_obj *obj, uint32_t type,
 		      uint32_t flags)
 {
 	return nftnl_fprintf(fp, obj, NFTNL_CMD_UNSPEC, type, flags,
 			     nftnl_obj_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_obj_fprintf);
 
 struct nftnl_obj_list {
 	struct list_head list;
 };
 
+EXPORT_SYMBOL(nftnl_obj_list_alloc);
 struct nftnl_obj_list *nftnl_obj_list_alloc(void)
 {
 	struct nftnl_obj_list *list;
@@ -512,8 +513,8 @@ struct nftnl_obj_list *nftnl_obj_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nftnl_obj_list_alloc);
 
+EXPORT_SYMBOL(nftnl_obj_list_free);
 void nftnl_obj_list_free(struct nftnl_obj_list *list)
 {
 	struct nftnl_obj *r, *tmp;
@@ -524,33 +525,33 @@ void nftnl_obj_list_free(struct nftnl_obj_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_obj_list_free);
 
+EXPORT_SYMBOL(nftnl_obj_list_is_empty);
 int nftnl_obj_list_is_empty(struct nftnl_obj_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_obj_list_is_empty);
 
+EXPORT_SYMBOL(nftnl_obj_list_add);
 void nftnl_obj_list_add(struct nftnl_obj *r, struct nftnl_obj_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_obj_list_add);
 
+EXPORT_SYMBOL(nftnl_obj_list_add_tail);
 void nftnl_obj_list_add_tail(struct nftnl_obj *r,
 			       struct nftnl_obj_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_obj_list_add_tail);
 
+EXPORT_SYMBOL(nftnl_obj_list_del);
 void nftnl_obj_list_del(struct nftnl_obj *t)
 {
 	list_del(&t->head);
 }
-EXPORT_SYMBOL(nftnl_obj_list_del);
 
+EXPORT_SYMBOL(nftnl_obj_list_foreach);
 int nftnl_obj_list_foreach(struct nftnl_obj_list *table_list,
 			     int (*cb)(struct nftnl_obj *t, void *data),
 			     void *data)
@@ -565,13 +566,13 @@ int nftnl_obj_list_foreach(struct nftnl_obj_list *table_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_obj_list_foreach);
 
 struct nftnl_obj_list_iter {
 	struct nftnl_obj_list	*list;
 	struct nftnl_obj	*cur;
 };
 
+EXPORT_SYMBOL(nftnl_obj_list_iter_create);
 struct nftnl_obj_list_iter *
 nftnl_obj_list_iter_create(struct nftnl_obj_list *l)
 {
@@ -589,8 +590,8 @@ nftnl_obj_list_iter_create(struct nftnl_obj_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_obj_list_iter_create);
 
+EXPORT_SYMBOL(nftnl_obj_list_iter_next);
 struct nftnl_obj *nftnl_obj_list_iter_next(struct nftnl_obj_list_iter *iter)
 {
 	struct nftnl_obj *r = iter->cur;
@@ -605,10 +606,9 @@ struct nftnl_obj *nftnl_obj_list_iter_next(struct nftnl_obj_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL(nftnl_obj_list_iter_next);
 
+EXPORT_SYMBOL(nftnl_obj_list_iter_destroy);
 void nftnl_obj_list_iter_destroy(struct nftnl_obj_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_obj_list_iter_destroy);
diff --git a/src/rule.c b/src/rule.c
index a9e9870..e4cba1f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -52,6 +52,7 @@ struct nftnl_rule {
 	struct list_head expr_list;
 };
 
+EXPORT_SYMBOL(nftnl_rule_alloc);
 struct nftnl_rule *nftnl_rule_alloc(void)
 {
 	struct nftnl_rule *r;
@@ -64,8 +65,8 @@ struct nftnl_rule *nftnl_rule_alloc(void)
 
 	return r;
 }
-EXPORT_SYMBOL(nftnl_rule_alloc);
 
+EXPORT_SYMBOL(nftnl_rule_free);
 void nftnl_rule_free(const struct nftnl_rule *r)
 {
 	struct nftnl_expr *e, *tmp;
@@ -82,14 +83,14 @@ void nftnl_rule_free(const struct nftnl_rule *r)
 
 	xfree(r);
 }
-EXPORT_SYMBOL(nftnl_rule_free);
 
+EXPORT_SYMBOL(nftnl_rule_is_set);
 bool nftnl_rule_is_set(const struct nftnl_rule *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_rule_is_set);
 
+EXPORT_SYMBOL(nftnl_rule_unset);
 void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 {
 	if (!(r->flags & (1 << attr)))
@@ -116,7 +117,6 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_rule_unset);
 
 static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 	[NFTNL_RULE_HANDLE]		= sizeof(uint64_t),
@@ -127,6 +127,7 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 	[NFTNL_RULE_ID]			= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_rule_set_data);
 int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			const void *data, uint32_t data_len)
 {
@@ -183,32 +184,32 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 	r->flags |= (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_rule_set_data);
 
+EXPORT_SYMBOL(nftnl_rule_set);
 int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data)
 {
 	return nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_rule_set);
 
+EXPORT_SYMBOL(nftnl_rule_set_u32);
 void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t val)
 {
 	nftnl_rule_set_data(r, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_rule_set_u32);
 
+EXPORT_SYMBOL(nftnl_rule_set_u64);
 void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t val)
 {
 	nftnl_rule_set_data(r, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nftnl_rule_set_u64);
 
+EXPORT_SYMBOL(nftnl_rule_set_str);
 int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char *str)
 {
 	return nftnl_rule_set_data(r, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_rule_set_str);
 
+EXPORT_SYMBOL(nftnl_rule_get_data);
 const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 				   uint32_t *data_len)
 {
@@ -246,21 +247,21 @@ const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_rule_get_data);
 
+EXPORT_SYMBOL(nftnl_rule_get);
 const void *nftnl_rule_get(const struct nftnl_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_rule_get_data(r, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_rule_get);
 
+EXPORT_SYMBOL(nftnl_rule_get_str);
 const char *nftnl_rule_get_str(const struct nftnl_rule *r, uint16_t attr)
 {
 	return nftnl_rule_get(r, attr);
 }
-EXPORT_SYMBOL(nftnl_rule_get_str);
 
+EXPORT_SYMBOL(nftnl_rule_get_u32);
 uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
@@ -270,8 +271,8 @@ uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_rule_get_u32);
 
+EXPORT_SYMBOL(nftnl_rule_get_u64);
 uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
@@ -281,8 +282,8 @@ uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_rule_get_u64);
 
+EXPORT_SYMBOL(nftnl_rule_get_u8);
 uint8_t nftnl_rule_get_u8(const struct nftnl_rule *r, uint16_t attr)
 {
 	uint32_t data_len;
@@ -292,8 +293,8 @@ uint8_t nftnl_rule_get_u8(const struct nftnl_rule *r, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_rule_get_u8);
 
+EXPORT_SYMBOL(nftnl_rule_nlmsg_build_payload);
 void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 {
 	struct nftnl_expr *expr;
@@ -335,13 +336,12 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 	if (r->flags & (1 << NFTNL_RULE_ID))
 		mnl_attr_put_u32(nlh, NFTA_RULE_ID, htonl(r->id));
 }
-EXPORT_SYMBOL(nftnl_rule_nlmsg_build_payload);
 
+EXPORT_SYMBOL(nftnl_rule_add_expr);
 void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr)
 {
 	list_add_tail(&expr->head, &r->expr_list);
 }
-EXPORT_SYMBOL(nftnl_rule_add_expr);
 
 static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -441,6 +441,7 @@ static int nftnl_rule_parse_compat(struct nlattr *nest, struct nftnl_rule *r)
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_rule_nlmsg_parse);
 int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 {
 	struct nlattr *tb[NFTA_RULE_MAX+1] = {};
@@ -510,7 +511,6 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
 int nftnl_jansson_parse_rule(struct nftnl_rule *r, json_t *tree,
@@ -658,19 +658,20 @@ static int nftnl_rule_do_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 
 	return ret;
 }
+
+EXPORT_SYMBOL(nftnl_rule_parse);
 int nftnl_rule_parse(struct nftnl_rule *r, enum nftnl_parse_type type,
 		   const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_rule_do_parse(r, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_rule_parse);
 
+EXPORT_SYMBOL(nftnl_rule_parse_file);
 int nftnl_rule_parse_file(struct nftnl_rule *r, enum nftnl_parse_type type,
 			FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_rule_do_parse(r, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_rule_parse_file);
 
 static int nftnl_rule_export(char *buf, size_t size,
 			     const struct nftnl_rule *r,
@@ -819,6 +820,7 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_rule_snprintf);
 int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
 			uint32_t type, uint32_t flags)
 {
@@ -828,7 +830,6 @@ int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
 	return nftnl_rule_cmd_snprintf(buf, size, r, nftnl_flag2cmd(flags), type,
 				     flags);
 }
-EXPORT_SYMBOL(nftnl_rule_snprintf);
 
 static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
@@ -836,14 +837,15 @@ static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
 	return nftnl_rule_snprintf(buf, size, r, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_rule_fprintf);
 int nftnl_rule_fprintf(FILE *fp, const struct nftnl_rule *r, uint32_t type,
 		       uint32_t flags)
 {
 	return nftnl_fprintf(fp, r, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_rule_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_rule_fprintf);
 
+EXPORT_SYMBOL(nftnl_expr_foreach);
 int nftnl_expr_foreach(struct nftnl_rule *r,
                           int (*cb)(struct nftnl_expr *e, void *data),
                           void *data)
@@ -858,7 +860,6 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
        }
        return 0;
 }
-EXPORT_SYMBOL(nftnl_expr_foreach);
 
 struct nftnl_expr_iter {
 	const struct nftnl_rule	*r;
@@ -876,6 +877,7 @@ static void nftnl_expr_iter_init(const struct nftnl_rule *r,
 				       head);
 }
 
+EXPORT_SYMBOL(nftnl_expr_iter_create);
 struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 {
 	struct nftnl_expr_iter *iter;
@@ -888,8 +890,8 @@ struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_expr_iter_create);
 
+EXPORT_SYMBOL(nftnl_expr_iter_next);
 struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter)
 {
 	struct nftnl_expr *expr = iter->cur;
@@ -904,14 +906,14 @@ struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter)
 
 	return expr;
 }
-EXPORT_SYMBOL(nftnl_expr_iter_next);
 
+EXPORT_SYMBOL(nftnl_expr_iter_destroy);
 void nftnl_expr_iter_destroy(struct nftnl_expr_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_expr_iter_destroy);
 
+EXPORT_SYMBOL(nftnl_rule_cmp);
 bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
 {
 	struct nftnl_expr_iter it1, it2;
@@ -941,12 +943,12 @@ bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
 
 	return eq;
 }
-EXPORT_SYMBOL(nftnl_rule_cmp);
 
 struct nftnl_rule_list {
 	struct list_head list;
 };
 
+EXPORT_SYMBOL(nftnl_rule_list_alloc);
 struct nftnl_rule_list *nftnl_rule_list_alloc(void)
 {
 	struct nftnl_rule_list *list;
@@ -959,8 +961,8 @@ struct nftnl_rule_list *nftnl_rule_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nftnl_rule_list_alloc);
 
+EXPORT_SYMBOL(nftnl_rule_list_free);
 void nftnl_rule_list_free(struct nftnl_rule_list *list)
 {
 	struct nftnl_rule *r, *tmp;
@@ -971,32 +973,32 @@ void nftnl_rule_list_free(struct nftnl_rule_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_rule_list_free);
 
+EXPORT_SYMBOL(nftnl_rule_list_is_empty);
 int nftnl_rule_list_is_empty(const struct nftnl_rule_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_rule_list_is_empty);
 
+EXPORT_SYMBOL(nftnl_rule_list_add);
 void nftnl_rule_list_add(struct nftnl_rule *r, struct nftnl_rule_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_rule_list_add);
 
+EXPORT_SYMBOL(nftnl_rule_list_add_tail);
 void nftnl_rule_list_add_tail(struct nftnl_rule *r, struct nftnl_rule_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_rule_list_add_tail);
 
+EXPORT_SYMBOL(nftnl_rule_list_del);
 void nftnl_rule_list_del(struct nftnl_rule *r)
 {
 	list_del(&r->head);
 }
-EXPORT_SYMBOL(nftnl_rule_list_del);
 
+EXPORT_SYMBOL(nftnl_rule_list_foreach);
 int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list,
 			  int (*cb)(struct nftnl_rule *r, void *data),
 			  void *data)
@@ -1011,13 +1013,13 @@ int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_rule_list_foreach);
 
 struct nftnl_rule_list_iter {
 	const struct nftnl_rule_list	*list;
 	struct nftnl_rule		*cur;
 };
 
+EXPORT_SYMBOL(nftnl_rule_list_iter_create);
 struct nftnl_rule_list_iter *
 nftnl_rule_list_iter_create(const struct nftnl_rule_list *l)
 {
@@ -1035,14 +1037,14 @@ nftnl_rule_list_iter_create(const struct nftnl_rule_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_rule_list_iter_create);
 
+EXPORT_SYMBOL(nftnl_rule_list_iter_cur);
 struct nftnl_rule *nftnl_rule_list_iter_cur(struct nftnl_rule_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nftnl_rule_list_iter_cur);
 
+EXPORT_SYMBOL(nftnl_rule_list_iter_next);
 struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter)
 {
 	struct nftnl_rule *r = iter->cur;
@@ -1057,10 +1059,9 @@ struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter)
 
 	return r;
 }
-EXPORT_SYMBOL(nftnl_rule_list_iter_next);
 
+EXPORT_SYMBOL(nftnl_rule_list_iter_destroy);
 void nftnl_rule_list_iter_destroy(const struct nftnl_rule_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_rule_list_iter_destroy);
diff --git a/src/ruleset.c b/src/ruleset.c
index cf86ca6..eb49fde 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -55,12 +55,13 @@ struct nftnl_parse_ctx {
 	uint16_t flags;
 };
 
+EXPORT_SYMBOL(nftnl_ruleset_alloc);
 struct nftnl_ruleset *nftnl_ruleset_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_ruleset));
 }
-EXPORT_SYMBOL(nftnl_ruleset_alloc);
 
+EXPORT_SYMBOL(nftnl_ruleset_free);
 void nftnl_ruleset_free(const struct nftnl_ruleset *r)
 {
 	if (r->flags & (1 << NFTNL_RULESET_TABLELIST))
@@ -73,14 +74,14 @@ void nftnl_ruleset_free(const struct nftnl_ruleset *r)
 		nftnl_rule_list_free(r->rule_list);
 	xfree(r);
 }
-EXPORT_SYMBOL(nftnl_ruleset_free);
 
+EXPORT_SYMBOL(nftnl_ruleset_is_set);
 bool nftnl_ruleset_is_set(const struct nftnl_ruleset *r, uint16_t attr)
 {
 	return r->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_ruleset_is_set);
 
+EXPORT_SYMBOL(nftnl_ruleset_unset);
 void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr)
 {
 	if (!(r->flags & (1 << attr)))
@@ -102,8 +103,8 @@ void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr)
 	}
 	r->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_ruleset_unset);
 
+EXPORT_SYMBOL(nftnl_ruleset_set);
 void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *data)
 {
 	switch (attr) {
@@ -128,8 +129,8 @@ void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *data)
 	}
 	r->flags |= (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_ruleset_set);
 
+EXPORT_SYMBOL(nftnl_ruleset_get);
 void *nftnl_ruleset_get(const struct nftnl_ruleset *r, uint16_t attr)
 {
 	if (!(r->flags & (1 << attr)))
@@ -148,8 +149,8 @@ void *nftnl_ruleset_get(const struct nftnl_ruleset *r, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(nftnl_ruleset_get);
 
+EXPORT_SYMBOL(nftnl_ruleset_ctx_free);
 void nftnl_ruleset_ctx_free(const struct nftnl_parse_ctx *ctx)
 {
 	switch (ctx->type) {
@@ -171,14 +172,14 @@ void nftnl_ruleset_ctx_free(const struct nftnl_parse_ctx *ctx)
 		break;
 	}
 }
-EXPORT_SYMBOL(nftnl_ruleset_ctx_free);
 
+EXPORT_SYMBOL(nftnl_ruleset_ctx_is_set);
 bool nftnl_ruleset_ctx_is_set(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
 	return ctx->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_ruleset_ctx_is_set);
 
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get);
 void *nftnl_ruleset_ctx_get(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
 	if (!(ctx->flags & (1 << attr)))
@@ -203,14 +204,13 @@ void *nftnl_ruleset_ctx_get(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(nftnl_ruleset_ctx_get);
 
+EXPORT_SYMBOL(nftnl_ruleset_ctx_get_u32);
 uint32_t nftnl_ruleset_ctx_get_u32(const struct nftnl_parse_ctx *ctx, uint16_t attr)
 {
 	const void *ret = nftnl_ruleset_ctx_get(ctx, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_ruleset_ctx_get_u32);
 
 #if defined(JSON_PARSING)
 static void nftnl_ruleset_ctx_set(struct nftnl_parse_ctx *ctx, uint16_t attr,
@@ -593,14 +593,15 @@ nftnl_ruleset_do_parse(enum nftnl_parse_type type, const void *data,
 	return ret;
 }
 
+EXPORT_SYMBOL(nftnl_ruleset_parse_file_cb);
 int nftnl_ruleset_parse_file_cb(enum nftnl_parse_type type, FILE *fp,
 			      struct nftnl_parse_err *err, void *data,
 			      int (*cb)(const struct nftnl_parse_ctx *ctx))
 {
 	return nftnl_ruleset_do_parse(type, fp, err, NFTNL_PARSE_FILE, data, cb);
 }
-EXPORT_SYMBOL(nftnl_ruleset_parse_file_cb);
 
+EXPORT_SYMBOL(nftnl_ruleset_parse_buffer_cb);
 int nftnl_ruleset_parse_buffer_cb(enum nftnl_parse_type type, const char *buffer,
 				struct nftnl_parse_err *err, void *data,
 				int (*cb)(const struct nftnl_parse_ctx *ctx))
@@ -608,7 +609,6 @@ int nftnl_ruleset_parse_buffer_cb(enum nftnl_parse_type type, const char *buffer
 	return nftnl_ruleset_do_parse(type, buffer, err, NFTNL_PARSE_BUFFER, data,
 				    cb);
 }
-EXPORT_SYMBOL(nftnl_ruleset_parse_buffer_cb);
 
 static int nftnl_ruleset_cb(const struct nftnl_parse_ctx *ctx)
 {
@@ -671,19 +671,19 @@ static int nftnl_ruleset_cb(const struct nftnl_parse_ctx *ctx)
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_ruleset_parse);
 int nftnl_ruleset_parse(struct nftnl_ruleset *r, enum nftnl_parse_type type,
 		      const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_ruleset_parse_buffer_cb(type, data, err, r, nftnl_ruleset_cb);
 }
-EXPORT_SYMBOL(nftnl_ruleset_parse);
 
+EXPORT_SYMBOL(nftnl_ruleset_parse_file);
 int nftnl_ruleset_parse_file(struct nftnl_ruleset *rs, enum nftnl_parse_type type,
 			   FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_ruleset_parse_file_cb(type, fp, err, rs, nftnl_ruleset_cb);
 }
-EXPORT_SYMBOL(nftnl_ruleset_parse_file);
 
 static const char *nftnl_ruleset_o_opentag(uint32_t type)
 {
@@ -930,6 +930,7 @@ static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
 	}
 }
 
+EXPORT_SYMBOL(nftnl_ruleset_snprintf);
 int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r,
 			 uint32_t type, uint32_t flags)
 {
@@ -948,7 +949,6 @@ int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r
 		return -1;
 	}
 }
-EXPORT_SYMBOL(nftnl_ruleset_snprintf);
 
 static int nftnl_ruleset_fprintf_tables(FILE *fp, const struct nftnl_ruleset *rs,
 				      uint32_t type, uint32_t flags)
@@ -1162,10 +1162,10 @@ static int nftnl_ruleset_cmd_fprintf(FILE *fp, const struct nftnl_ruleset *rs,
 	return len;
 }
 
+EXPORT_SYMBOL(nftnl_ruleset_fprintf);
 int nftnl_ruleset_fprintf(FILE *fp, const struct nftnl_ruleset *rs, uint32_t type,
 			uint32_t flags)
 {
 	return nftnl_ruleset_cmd_fprintf(fp, rs, nftnl_flag2cmd(flags), type,
 				       flags);
 }
-EXPORT_SYMBOL(nftnl_ruleset_fprintf);
diff --git a/src/set.c b/src/set.c
index 592ea24..ac24eae 100644
--- a/src/set.c
+++ b/src/set.c
@@ -27,6 +27,7 @@
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
 
+EXPORT_SYMBOL(nftnl_set_alloc);
 struct nftnl_set *nftnl_set_alloc(void)
 {
 	struct nftnl_set *s;
@@ -38,8 +39,8 @@ struct nftnl_set *nftnl_set_alloc(void)
 	INIT_LIST_HEAD(&s->element_list);
 	return s;
 }
-EXPORT_SYMBOL(nftnl_set_alloc);
 
+EXPORT_SYMBOL(nftnl_set_free);
 void nftnl_set_free(const struct nftnl_set *s)
 {
 	struct nftnl_set_elem *elem, *tmp;
@@ -57,14 +58,14 @@ void nftnl_set_free(const struct nftnl_set *s)
 	}
 	xfree(s);
 }
-EXPORT_SYMBOL(nftnl_set_free);
 
+EXPORT_SYMBOL(nftnl_set_is_set);
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_set_is_set);
 
+EXPORT_SYMBOL(nftnl_set_unset);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 {
 	if (!(s->flags & (1 << attr)))
@@ -99,7 +100,6 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_set_unset);
 
 static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_FLAGS]		= sizeof(uint32_t),
@@ -115,6 +115,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_GC_INTERVAL]	= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_set_set_data);
 int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		       uint32_t data_len)
 {
@@ -188,32 +189,32 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	s->flags |= (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_set_set_data);
 
+EXPORT_SYMBOL(nftnl_set_set);
 int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 {
 	return nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_set_set);
 
+EXPORT_SYMBOL(nftnl_set_set_u32);
 void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val)
 {
 	nftnl_set_set(s, attr, &val);
 }
-EXPORT_SYMBOL(nftnl_set_set_u32);
 
+EXPORT_SYMBOL(nftnl_set_set_u64);
 void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val)
 {
 	nftnl_set_set(s, attr, &val);
 }
-EXPORT_SYMBOL(nftnl_set_set_u64);
 
+EXPORT_SYMBOL(nftnl_set_set_str);
 int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *str)
 {
 	return nftnl_set_set_data(s, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_set_set_str);
 
+EXPORT_SYMBOL(nftnl_set_get_data);
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 			       uint32_t *data_len)
 {
@@ -269,21 +270,21 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_set_get_data);
 
+EXPORT_SYMBOL(nftnl_set_get);
 const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_set_get_data(s, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_set_get);
 
+EXPORT_SYMBOL(nftnl_set_get_str);
 const char *nftnl_set_get_str(const struct nftnl_set *s, uint16_t attr)
 {
 	return nftnl_set_get(s, attr);
 }
-EXPORT_SYMBOL(nftnl_set_get_str);
 
+EXPORT_SYMBOL(nftnl_set_get_u32);
 uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
@@ -293,8 +294,8 @@ uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_set_get_u32);
 
+EXPORT_SYMBOL(nftnl_set_get_u64);
 uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 {
 	uint32_t data_len;
@@ -304,7 +305,6 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 
 	return val ? *val : 0;
 }
-EXPORT_SYMBOL(nftnl_set_get_u64);
 
 struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 {
@@ -353,6 +353,7 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 	mnl_attr_nest_end(nlh, nest);
 }
 
+EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
 void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	if (s->flags & (1 << NFTNL_SET_TABLE))
@@ -385,7 +386,7 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
 }
-EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
+
 
 static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -465,6 +466,7 @@ static int nftnl_set_desc_parse(struct nftnl_set *s,
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_set_nlmsg_parse);
 int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
@@ -548,7 +550,6 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_set_nlmsg_parse);
 
 #ifdef JSON_PARSING
 static int nftnl_jansson_parse_set_info(struct nftnl_set *s, json_t *tree,
@@ -720,19 +721,20 @@ static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 
 	return ret;
 }
+
+EXPORT_SYMBOL(nftnl_set_parse);
 int nftnl_set_parse(struct nftnl_set *s, enum nftnl_parse_type type,
 		  const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_set_do_parse(s, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_set_parse);
 
+EXPORT_SYMBOL(nftnl_set_parse_file);
 int nftnl_set_parse_file(struct nftnl_set *s, enum nftnl_parse_type type,
 		       FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_set_do_parse(s, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_set_parse_file);
 
 static int nftnl_set_snprintf_json(char *buf, size_t size,
 				   const struct nftnl_set *s,
@@ -922,6 +924,7 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_set_snprintf);
 int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s,
 		       uint32_t type, uint32_t flags)
 {
@@ -931,7 +934,6 @@ int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s,
 	return nftnl_set_cmd_snprintf(buf, size, s, nftnl_flag2cmd(flags), type,
 				    flags);
 }
-EXPORT_SYMBOL(nftnl_set_snprintf);
 
 static int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
@@ -939,24 +941,25 @@ static int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
 	return nftnl_set_snprintf(buf, size, s, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_set_fprintf);
 int nftnl_set_fprintf(FILE *fp, const struct nftnl_set *s, uint32_t type,
 		      uint32_t flags)
 {
 	return nftnl_fprintf(fp, s, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_set_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_set_fprintf);
 
+EXPORT_SYMBOL(nftnl_set_elem_add);
 void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem)
 {
 	list_add_tail(&elem->head, &s->element_list);
 }
-EXPORT_SYMBOL(nftnl_set_elem_add);
 
 struct nftnl_set_list {
 	struct list_head list;
 };
 
+EXPORT_SYMBOL(nftnl_set_list_alloc);
 struct nftnl_set_list *nftnl_set_list_alloc(void)
 {
 	struct nftnl_set_list *list;
@@ -969,8 +972,8 @@ struct nftnl_set_list *nftnl_set_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nftnl_set_list_alloc);
 
+EXPORT_SYMBOL(nftnl_set_list_free);
 void nftnl_set_list_free(struct nftnl_set_list *list)
 {
 	struct nftnl_set *s, *tmp;
@@ -981,32 +984,32 @@ void nftnl_set_list_free(struct nftnl_set_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_set_list_free);
 
+EXPORT_SYMBOL(nftnl_set_list_is_empty);
 int nftnl_set_list_is_empty(const struct nftnl_set_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_set_list_is_empty);
 
+EXPORT_SYMBOL(nftnl_set_list_add);
 void nftnl_set_list_add(struct nftnl_set *s, struct nftnl_set_list *list)
 {
 	list_add(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_set_list_add);
 
+EXPORT_SYMBOL(nftnl_set_list_add_tail);
 void nftnl_set_list_add_tail(struct nftnl_set *s, struct nftnl_set_list *list)
 {
 	list_add_tail(&s->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_set_list_add_tail);
 
+EXPORT_SYMBOL(nftnl_set_list_del);
 void nftnl_set_list_del(struct nftnl_set *s)
 {
 	list_del(&s->head);
 }
-EXPORT_SYMBOL(nftnl_set_list_del);
 
+EXPORT_SYMBOL(nftnl_set_list_foreach);
 int nftnl_set_list_foreach(struct nftnl_set_list *set_list,
 			 int (*cb)(struct nftnl_set *t, void *data), void *data)
 {
@@ -1020,13 +1023,13 @@ int nftnl_set_list_foreach(struct nftnl_set_list *set_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_set_list_foreach);
 
 struct nftnl_set_list_iter {
 	const struct nftnl_set_list	*list;
 	struct nftnl_set		*cur;
 };
 
+EXPORT_SYMBOL(nftnl_set_list_iter_create);
 struct nftnl_set_list_iter *
 nftnl_set_list_iter_create(const struct nftnl_set_list *l)
 {
@@ -1044,15 +1047,15 @@ nftnl_set_list_iter_create(const struct nftnl_set_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_set_list_iter_create);
 
+EXPORT_SYMBOL(nftnl_set_list_iter_cur);
 struct nftnl_set *
 nftnl_set_list_iter_cur(const struct nftnl_set_list_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nftnl_set_list_iter_cur);
 
+EXPORT_SYMBOL(nftnl_set_list_iter_next);
 struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter)
 {
 	struct nftnl_set *s = iter->cur;
@@ -1067,13 +1070,12 @@ struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter)
 
 	return s;
 }
-EXPORT_SYMBOL(nftnl_set_list_iter_next);
 
+EXPORT_SYMBOL(nftnl_set_list_iter_destroy);
 void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_set_list_iter_destroy);
 
 static struct nftnl_set *nftnl_set_lookup(const char *this_set_name,
 				      struct nftnl_set_list *set_list)
diff --git a/src/set_elem.c b/src/set_elem.c
index 71c279a..e02a387 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -27,6 +27,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
+EXPORT_SYMBOL(nftnl_set_elem_alloc);
 struct nftnl_set_elem *nftnl_set_elem_alloc(void)
 {
 	struct nftnl_set_elem *s;
@@ -37,8 +38,8 @@ struct nftnl_set_elem *nftnl_set_elem_alloc(void)
 
 	return s;
 }
-EXPORT_SYMBOL(nftnl_set_elem_alloc);
 
+EXPORT_SYMBOL(nftnl_set_elem_free);
 void nftnl_set_elem_free(struct nftnl_set_elem *s)
 {
 	if (s->flags & (1 << NFTNL_SET_ELEM_CHAIN))
@@ -55,14 +56,14 @@ void nftnl_set_elem_free(struct nftnl_set_elem *s)
 
 	xfree(s);
 }
-EXPORT_SYMBOL(nftnl_set_elem_free);
 
+EXPORT_SYMBOL(nftnl_set_elem_is_set);
 bool nftnl_set_elem_is_set(const struct nftnl_set_elem *s, uint16_t attr)
 {
 	return s->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_set_elem_is_set);
 
+EXPORT_SYMBOL(nftnl_set_elem_unset);
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 {
 	if (!(s->flags & (1 << attr)))
@@ -94,8 +95,8 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 
 	s->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_set_elem_unset);
 
+EXPORT_SYMBOL(nftnl_set_elem_set);
 int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		       const void *data, uint32_t data_len)
 {
@@ -147,26 +148,26 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 	s->flags |= (1 << attr);
 	return -1;
 }
-EXPORT_SYMBOL(nftnl_set_elem_set);
 
+EXPORT_SYMBOL(nftnl_set_elem_set_u32);
 void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, uint32_t val)
 {
 	nftnl_set_elem_set(s, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_set_elem_set_u32);
 
+EXPORT_SYMBOL(nftnl_set_elem_set_u64);
 void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, uint64_t val)
 {
 	nftnl_set_elem_set(s, attr, &val, sizeof(uint64_t));
 }
-EXPORT_SYMBOL(nftnl_set_elem_set_u64);
 
+EXPORT_SYMBOL(nftnl_set_elem_set_str);
 int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str)
 {
 	return nftnl_set_elem_set(s, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_set_elem_set_str);
 
+EXPORT_SYMBOL(nftnl_set_elem_get);
 const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t *data_len)
 {
 	if (!(s->flags & (1 << attr)))
@@ -205,31 +206,30 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_set_elem_get);
 
+EXPORT_SYMBOL(nftnl_set_elem_get_str);
 const char *nftnl_set_elem_get_str(struct nftnl_set_elem *s, uint16_t attr)
 {
 	uint32_t size;
 
 	return nftnl_set_elem_get(s, attr, &size);
 }
-EXPORT_SYMBOL(nftnl_set_elem_get_str);
 
+EXPORT_SYMBOL(nftnl_set_elem_get_u32);
 uint32_t nftnl_set_elem_get_u32(struct nftnl_set_elem *s, uint16_t attr)
 {
 	uint32_t size;
 	uint32_t val = *((uint32_t *)nftnl_set_elem_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL(nftnl_set_elem_get_u32);
 
+EXPORT_SYMBOL(nftnl_set_elem_get_u64);
 uint64_t nftnl_set_elem_get_u64(struct nftnl_set_elem *s, uint16_t attr)
 {
 	uint32_t size;
 	uint64_t val = *((uint64_t *)nftnl_set_elem_get(s, attr, &size));
 	return val;
 }
-EXPORT_SYMBOL(nftnl_set_elem_get_u64);
 
 struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem)
 {
@@ -315,6 +315,7 @@ static struct nlattr *nftnl_set_elem_build(struct nlmsghdr *nlh,
 	return nest2;
 }
 
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload);
 void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nftnl_set_elem *elem;
@@ -332,7 +333,6 @@ void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set
 
 	mnl_attr_nest_end(nlh, nest1);
 }
-EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload);
 
 static int nftnl_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -503,6 +503,7 @@ static int nftnl_set_elems_parse(struct nftnl_set *s, const struct nlattr *nest)
 	return ret;
 }
 
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_parse);
 int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_ELEM_LIST_MAX+1] = {};
@@ -546,7 +547,6 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_set_elems_nlmsg_parse);
 
 static int nftnl_set_elem_json_parse(struct nftnl_set_elem *e, const void *json,
 				   struct nftnl_parse_err *err,
@@ -587,19 +587,20 @@ nftnl_set_elem_do_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 
 	return ret;
 }
+
+EXPORT_SYMBOL(nftnl_set_elem_parse);
 int nftnl_set_elem_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 		       const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_set_elem_do_parse(e, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_set_elem_parse);
 
+EXPORT_SYMBOL(nftnl_set_elem_parse_file);
 int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 			    FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_set_elem_do_parse(e, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_set_elem_parse_file);
 
 static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 					const struct nftnl_set_elem *e,
@@ -720,6 +721,7 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_set_elem_snprintf);
 int nftnl_set_elem_snprintf(char *buf, size_t size,
 			    const struct nftnl_set_elem *e,
 			    uint32_t type, uint32_t flags)
@@ -730,7 +732,6 @@ int nftnl_set_elem_snprintf(char *buf, size_t size,
 	return nftnl_set_elem_cmd_snprintf(buf, size, e, nftnl_flag2cmd(flags),
 					 type, flags);
 }
-EXPORT_SYMBOL(nftnl_set_elem_snprintf);
 
 static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
 				      uint32_t cmd, uint32_t type,
@@ -739,14 +740,15 @@ static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
 	return nftnl_set_elem_snprintf(buf, size, e, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_set_elem_fprintf);
 int nftnl_set_elem_fprintf(FILE *fp, struct nftnl_set_elem *se, uint32_t type,
 			 uint32_t flags)
 {
 	return nftnl_fprintf(fp, se, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_set_elem_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_set_elem_fprintf);
 
+EXPORT_SYMBOL(nftnl_set_elem_foreach);
 int nftnl_set_elem_foreach(struct nftnl_set *s,
 			 int (*cb)(struct nftnl_set_elem *e, void *data),
 			 void *data)
@@ -761,7 +763,6 @@ int nftnl_set_elem_foreach(struct nftnl_set *s,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_set_elem_foreach);
 
 struct nftnl_set_elems_iter {
 	const struct nftnl_set		*set;
@@ -769,6 +770,7 @@ struct nftnl_set_elems_iter {
 	struct nftnl_set_elem		*cur;
 };
 
+EXPORT_SYMBOL(nftnl_set_elems_iter_create);
 struct nftnl_set_elems_iter *
 nftnl_set_elems_iter_create(const struct nftnl_set *s)
 {
@@ -788,15 +790,15 @@ nftnl_set_elems_iter_create(const struct nftnl_set *s)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_set_elems_iter_create);
 
+EXPORT_SYMBOL(nftnl_set_elems_iter_cur);
 struct nftnl_set_elem *
 nftnl_set_elems_iter_cur(const struct nftnl_set_elems_iter *iter)
 {
 	return iter->cur;
 }
-EXPORT_SYMBOL(nftnl_set_elems_iter_cur);
 
+EXPORT_SYMBOL(nftnl_set_elems_iter_next);
 struct nftnl_set_elem *nftnl_set_elems_iter_next(struct nftnl_set_elems_iter *iter)
 {
 	struct nftnl_set_elem *s = iter->cur;
@@ -810,13 +812,12 @@ struct nftnl_set_elem *nftnl_set_elems_iter_next(struct nftnl_set_elems_iter *it
 
 	return s;
 }
-EXPORT_SYMBOL(nftnl_set_elems_iter_next);
 
+EXPORT_SYMBOL(nftnl_set_elems_iter_destroy);
 void nftnl_set_elems_iter_destroy(struct nftnl_set_elems_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_set_elems_iter_destroy);
 
 static bool nftnl_attr_nest_overflow(struct nlmsghdr *nlh,
 				   const struct nlattr *from,
@@ -835,6 +836,7 @@ static bool nftnl_attr_nest_overflow(struct nlmsghdr *nlh,
 	return false;
 }
 
+EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload_iter);
 int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 					   struct nftnl_set_elems_iter *iter)
 {
@@ -865,4 +867,3 @@ int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 
 	return ret;
 }
-EXPORT_SYMBOL(nftnl_set_elems_nlmsg_build_payload_iter);
diff --git a/src/table.c b/src/table.c
index cf61dda..7f97ca4 100644
--- a/src/table.c
+++ b/src/table.c
@@ -36,12 +36,13 @@ struct nftnl_table {
 	uint32_t	flags;
 };
 
+EXPORT_SYMBOL(nftnl_table_alloc);
 struct nftnl_table *nftnl_table_alloc(void)
 {
 	return calloc(1, sizeof(struct nftnl_table));
 }
-EXPORT_SYMBOL(nftnl_table_alloc);
 
+EXPORT_SYMBOL(nftnl_table_free);
 void nftnl_table_free(const struct nftnl_table *t)
 {
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
@@ -49,14 +50,14 @@ void nftnl_table_free(const struct nftnl_table *t)
 
 	xfree(t);
 }
-EXPORT_SYMBOL(nftnl_table_free);
 
+EXPORT_SYMBOL(nftnl_table_is_set);
 bool nftnl_table_is_set(const struct nftnl_table *t, uint16_t attr)
 {
 	return t->flags & (1 << attr);
 }
-EXPORT_SYMBOL(nftnl_table_is_set);
 
+EXPORT_SYMBOL(nftnl_table_unset);
 void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 {
 	if (!(t->flags & (1 << attr)))
@@ -74,13 +75,13 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 	}
 	t->flags &= ~(1 << attr);
 }
-EXPORT_SYMBOL(nftnl_table_unset);
 
 static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FLAGS]	= sizeof(uint32_t),
 	[NFTNL_TABLE_FAMILY]	= sizeof(uint32_t),
 };
 
+EXPORT_SYMBOL(nftnl_table_set_data);
 int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 			 const void *data, uint32_t data_len)
 {
@@ -109,32 +110,32 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 	t->flags |= (1 << attr);
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_table_set_data);
 
+EXPORT_SYMBOL(nftnl_table_set);
 void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data)
 {
 	nftnl_table_set_data(t, attr, data, nftnl_table_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_table_set);
 
+EXPORT_SYMBOL(nftnl_table_set_u32);
 void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t val)
 {
 	nftnl_table_set_data(t, attr, &val, sizeof(uint32_t));
 }
-EXPORT_SYMBOL(nftnl_table_set_u32);
 
+EXPORT_SYMBOL(nftnl_table_set_u8);
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t val)
 {
 	nftnl_table_set_data(t, attr, &val, sizeof(uint8_t));
 }
-EXPORT_SYMBOL(nftnl_table_set_u8);
 
+EXPORT_SYMBOL(nftnl_table_set_str);
 int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str)
 {
 	return nftnl_table_set_data(t, attr, str, strlen(str) + 1);
 }
-EXPORT_SYMBOL(nftnl_table_set_str);
 
+EXPORT_SYMBOL(nftnl_table_get_data);
 const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 				 uint32_t *data_len)
 {
@@ -157,35 +158,35 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(nftnl_table_get_data);
 
+EXPORT_SYMBOL(nftnl_table_get);
 const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_table_get_data(t, attr, &data_len);
 }
-EXPORT_SYMBOL(nftnl_table_get);
 
+EXPORT_SYMBOL(nftnl_table_get_u32);
 uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint32_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_table_get_u32);
 
+EXPORT_SYMBOL(nftnl_table_get_u8);
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
 	return ret == NULL ? 0 : *((uint8_t *)ret);
 }
-EXPORT_SYMBOL(nftnl_table_get_u8);
 
+EXPORT_SYMBOL(nftnl_table_get_str);
 const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr)
 {
 	return nftnl_table_get(t, attr);
 }
-EXPORT_SYMBOL(nftnl_table_get_str);
 
+EXPORT_SYMBOL(nftnl_table_nlmsg_build_payload);
 void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_table *t)
 {
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
@@ -193,7 +194,6 @@ void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ta
 	if (t->flags & (1 << NFTNL_TABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
 }
-EXPORT_SYMBOL(nftnl_table_nlmsg_build_payload);
 
 static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -219,6 +219,7 @@ static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+EXPORT_SYMBOL(nftnl_table_nlmsg_parse);
 int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 {
 	struct nlattr *tb[NFTA_TABLE_MAX+1] = {};
@@ -249,7 +250,6 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_table_nlmsg_parse);
 
 #ifdef JSON_PARSING
 int nftnl_jansson_parse_table(struct nftnl_table *t, json_t *tree,
@@ -330,19 +330,19 @@ static int nftnl_table_do_parse(struct nftnl_table *t, enum nftnl_parse_type typ
 	return ret;
 }
 
+EXPORT_SYMBOL(nftnl_table_parse);
 int nftnl_table_parse(struct nftnl_table *t, enum nftnl_parse_type type,
 		    const char *data, struct nftnl_parse_err *err)
 {
 	return nftnl_table_do_parse(t, type, data, err, NFTNL_PARSE_BUFFER);
 }
-EXPORT_SYMBOL(nftnl_table_parse);
 
+EXPORT_SYMBOL(nftnl_table_parse_file);
 int nftnl_table_parse_file(struct nftnl_table *t, enum nftnl_parse_type type,
 			 FILE *fp, struct nftnl_parse_err *err)
 {
 	return nftnl_table_do_parse(t, type, fp, err, NFTNL_PARSE_FILE);
 }
-EXPORT_SYMBOL(nftnl_table_parse_file);
 
 static int nftnl_table_export(char *buf, size_t size,
 			      const struct nftnl_table *t, int type)
@@ -400,6 +400,7 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size,
 	return offset;
 }
 
+EXPORT_SYMBOL(nftnl_table_snprintf);
 int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t,
 			 uint32_t type, uint32_t flags)
 {
@@ -409,7 +410,6 @@ int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t,
 	return nftnl_table_cmd_snprintf(buf, size, t, nftnl_flag2cmd(flags), type,
 				      flags);
 }
-EXPORT_SYMBOL(nftnl_table_snprintf);
 
 static int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
@@ -417,18 +417,19 @@ static int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
 	return nftnl_table_snprintf(buf, size, t, type, flags);
 }
 
+EXPORT_SYMBOL(nftnl_table_fprintf);
 int nftnl_table_fprintf(FILE *fp, const struct nftnl_table *t, uint32_t type,
 			uint32_t flags)
 {
 	return nftnl_fprintf(fp, t, NFTNL_CMD_UNSPEC, type, flags,
 			   nftnl_table_do_snprintf);
 }
-EXPORT_SYMBOL(nftnl_table_fprintf);
 
 struct nftnl_table_list {
 	struct list_head list;
 };
 
+EXPORT_SYMBOL(nftnl_table_list_alloc);
 struct nftnl_table_list *nftnl_table_list_alloc(void)
 {
 	struct nftnl_table_list *list;
@@ -441,8 +442,8 @@ struct nftnl_table_list *nftnl_table_list_alloc(void)
 
 	return list;
 }
-EXPORT_SYMBOL(nftnl_table_list_alloc);
 
+EXPORT_SYMBOL(nftnl_table_list_free);
 void nftnl_table_list_free(struct nftnl_table_list *list)
 {
 	struct nftnl_table *r, *tmp;
@@ -453,32 +454,32 @@ void nftnl_table_list_free(struct nftnl_table_list *list)
 	}
 	xfree(list);
 }
-EXPORT_SYMBOL(nftnl_table_list_free);
 
+EXPORT_SYMBOL(nftnl_table_list_is_empty);
 int nftnl_table_list_is_empty(const struct nftnl_table_list *list)
 {
 	return list_empty(&list->list);
 }
-EXPORT_SYMBOL(nftnl_table_list_is_empty);
 
+EXPORT_SYMBOL(nftnl_table_list_add);
 void nftnl_table_list_add(struct nftnl_table *r, struct nftnl_table_list *list)
 {
 	list_add(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_table_list_add);
 
+EXPORT_SYMBOL(nftnl_table_list_add_tail);
 void nftnl_table_list_add_tail(struct nftnl_table *r, struct nftnl_table_list *list)
 {
 	list_add_tail(&r->head, &list->list);
 }
-EXPORT_SYMBOL(nftnl_table_list_add_tail);
 
+EXPORT_SYMBOL(nftnl_table_list_del);
 void nftnl_table_list_del(struct nftnl_table *t)
 {
 	list_del(&t->head);
 }
-EXPORT_SYMBOL(nftnl_table_list_del);
 
+EXPORT_SYMBOL(nftnl_table_list_foreach);
 int nftnl_table_list_foreach(struct nftnl_table_list *table_list,
 			   int (*cb)(struct nftnl_table *t, void *data),
 			   void *data)
@@ -493,13 +494,13 @@ int nftnl_table_list_foreach(struct nftnl_table_list *table_list,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_table_list_foreach);
 
 struct nftnl_table_list_iter {
 	const struct nftnl_table_list	*list;
 	struct nftnl_table		*cur;
 };
 
+EXPORT_SYMBOL(nftnl_table_list_iter_create);
 struct nftnl_table_list_iter *
 nftnl_table_list_iter_create(const struct nftnl_table_list *l)
 {
@@ -517,8 +518,8 @@ nftnl_table_list_iter_create(const struct nftnl_table_list *l)
 
 	return iter;
 }
-EXPORT_SYMBOL(nftnl_table_list_iter_create);
 
+EXPORT_SYMBOL(nftnl_table_list_iter_next);
 struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *iter)
 {
 	struct nftnl_table *r = iter->cur;
@@ -533,10 +534,9 @@ struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *ite
 
 	return r;
 }
-EXPORT_SYMBOL(nftnl_table_list_iter_next);
 
+EXPORT_SYMBOL(nftnl_table_list_iter_destroy);
 void nftnl_table_list_iter_destroy(const struct nftnl_table_list_iter *iter)
 {
 	xfree(iter);
 }
-EXPORT_SYMBOL(nftnl_table_list_iter_destroy);
diff --git a/src/trace.c b/src/trace.c
index b016e72..f426437 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -324,8 +324,8 @@ static int nftnl_trace_parse_verdict(const struct nlattr *attr,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(nftnl_trace_nlmsg_parse);
 
+EXPORT_SYMBOL(nftnl_trace_nlmsg_parse);
 int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 {
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
diff --git a/src/udata.c b/src/udata.c
index d679dd0..6bd9651 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -16,6 +16,7 @@
 #include <stdint.h>
 #include <string.h>
 
+EXPORT_SYMBOL(nftnl_udata_buf_alloc);
 struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size)
 {
 	struct nftnl_udata_buf *buf;
@@ -28,46 +29,46 @@ struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size)
 
 	return buf;
 }
-EXPORT_SYMBOL(nftnl_udata_buf_alloc);
 
+EXPORT_SYMBOL(nftnl_udata_buf_free);
 void nftnl_udata_buf_free(const struct nftnl_udata_buf *buf)
 {
 	xfree(buf);
 }
-EXPORT_SYMBOL(nftnl_udata_buf_free);
 
+EXPORT_SYMBOL(nftnl_udata_buf_len);
 uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf)
 {
 	return (uint32_t)(buf->end - buf->data);
 }
-EXPORT_SYMBOL(nftnl_udata_buf_len);
 
+EXPORT_SYMBOL(nftnl_udata_buf_data);
 void *nftnl_udata_buf_data(const struct nftnl_udata_buf *buf)
 {
 	return (void *)buf->data;
 }
-EXPORT_SYMBOL(nftnl_udata_buf_data);
 
+EXPORT_SYMBOL(nftnl_udata_buf_put);
 void nftnl_udata_buf_put(struct nftnl_udata_buf *buf, const void *data,
 			 uint32_t len)
 {
 	memcpy(buf->data, data, len <= buf->size ? len : buf->size);
 	buf->end = buf->data + len;
 }
-EXPORT_SYMBOL(nftnl_udata_buf_put);
 
+EXPORT_SYMBOL(nftnl_udata_start);
 struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *buf)
 {
 	return (struct nftnl_udata *)buf->data;
 }
-EXPORT_SYMBOL(nftnl_udata_start);
 
+EXPORT_SYMBOL(nftnl_udata_end);
 struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *buf)
 {
 	return (struct nftnl_udata *)buf->end;
 }
-EXPORT_SYMBOL(nftnl_udata_end);
 
+EXPORT_SYMBOL(nftnl_udata_put);
 bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32_t len,
 		     const void *value)
 {
@@ -85,54 +86,54 @@ bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32_t len,
 
 	return true;
 }
-EXPORT_SYMBOL(nftnl_udata_put);
 
+EXPORT_SYMBOL(nftnl_udata_put_strz);
 bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 			  const char *strz)
 {
 	return nftnl_udata_put(buf, type, strlen(strz) + 1, strz);
 }
-EXPORT_SYMBOL(nftnl_udata_put_strz);
 
+EXPORT_SYMBOL(nftnl_udata_put_u32);
 bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
 			 uint32_t data)
 {
 	return nftnl_udata_put(buf, type, sizeof(data), &data);
 }
-EXPORT_SYMBOL(nftnl_udata_put_u32);
 
+EXPORT_SYMBOL(nftnl_udata_type);
 uint8_t nftnl_udata_type(const struct nftnl_udata *attr)
 {
 	return attr->type;
 }
-EXPORT_SYMBOL(nftnl_udata_type);
 
+EXPORT_SYMBOL(nftnl_udata_len);
 uint8_t nftnl_udata_len(const struct nftnl_udata *attr)
 {
 	return attr->len;
 }
-EXPORT_SYMBOL(nftnl_udata_len);
 
+EXPORT_SYMBOL(nftnl_udata_get);
 void *nftnl_udata_get(const struct nftnl_udata *attr)
 {
 	return (void *)attr->value;
 }
-EXPORT_SYMBOL(nftnl_udata_get);
 
+EXPORT_SYMBOL(nftnl_udata_get_u32);
 uint32_t nftnl_udata_get_u32(const struct nftnl_udata *attr)
 {
 	uint32_t *data = (uint32_t *)attr->value;
 
 	return *data;
 }
-EXPORT_SYMBOL(nftnl_udata_get_u32);
 
+EXPORT_SYMBOL(nftnl_udata_next);
 struct nftnl_udata *nftnl_udata_next(const struct nftnl_udata *attr)
 {
 	return (struct nftnl_udata *)&attr->value[attr->len];
 }
-EXPORT_SYMBOL(nftnl_udata_next);
 
+EXPORT_SYMBOL(nftnl_udata_parse);
 int nftnl_udata_parse(const void *data, uint32_t data_len, nftnl_udata_cb_t cb,
 		      void *cb_data)
 {
@@ -147,4 +148,3 @@ int nftnl_udata_parse(const void *data, uint32_t data_len, nftnl_udata_cb_t cb,
 
 	return ret;
 }
-EXPORT_SYMBOL(nftnl_udata_parse);
-- 
2.15.1

