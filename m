From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC libnftnl PATCH 1/2] src: add mnlio API functions
Date: Wed, 05 Feb 2014 20:17:47 +0100
Message-ID: <20140205191746.9979.44016.stgit@nfdev.cica.es>
References: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35402 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437AbaBETRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:17:52 -0500
In-Reply-To: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions are likely to be used by all userspace programs to interact
with the nftables kernel subsystem.

Lets put in the library, so: its easy to maintain, we can save lots of LOCs,
programmers can easily learn how to work with nftables, etc..

This patch will require several iterations: batch_pages are left behind.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/Makefile.am |    3 
 include/libnftnl/mnlio.h     |   92 ++++
 src/Makefile.am              |    1 
 src/libnftnl.map             |   37 ++
 src/mnlio.c                  |  957 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1089 insertions(+), 1 deletion(-)
 create mode 100644 include/libnftnl/mnlio.h
 create mode 100644 src/mnlio.c

diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index a0841d2..cf703bb 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -4,4 +4,5 @@ pkginclude_HEADERS = table.h		\
 		     expr.h		\
 		     set.h		\
 		     ruleset.h		\
-		     common.h
+		     common.h		\
+		     mnlio.h
diff --git a/include/libnftnl/mnlio.h b/include/libnftnl/mnlio.h
new file mode 100644
index 0000000..e517d70
--- /dev/null
+++ b/include/libnftnl/mnlio.h
@@ -0,0 +1,92 @@
+#ifndef _LIBNFTNL_MNLIO_H_
+#define _LIBNFTNL_MNLIO_H_
+
+#include <libnftnl/ruleset.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/set.h>
+#include <libnftnl/rule.h>
+
+int
+nft_mnlio_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	       int (*cb)(const struct nlmsghdr *nlh, void *data),
+	       void *cb_data);
+void nft_mnlio_batch_put(struct mnl_nlmsg_batch *batch, int type,
+			 uint32_t seq);
+int nft_mnlio_batch_talk(struct mnl_socket *nl, struct mnl_nlmsg_batch *b);
+void nft_mnlio_batch_begin(struct mnl_nlmsg_batch *batch);
+void nft_mnlio_batch_end(struct mnl_nlmsg_batch *batch);
+struct mnl_nlmsg_batch *nft_mnlio_batch_alloc(void);
+bool nft_mnlio_batch_ready(struct mnl_nlmsg_batch *batch);
+void nft_mnlio_batch_reset(struct mnl_nlmsg_batch *batch);
+
+int nft_mnlio_rule_add(struct nft_rule *nlr, unsigned int flags,
+		       struct mnl_nlmsg_batch *batch);
+int nft_mnlio_rule_list_add(struct nft_rule_list *nlrl, unsigned int flags,
+			    struct mnl_nlmsg_batch *batch);
+int nft_mnlio_rule_del(struct nft_rule *nlr, unsigned int flags,
+		       struct mnl_nlmsg_batch *batch);
+struct nft_rule_list *
+nft_mnlio_rule_dump(struct mnl_socket *nf_sock, int family);
+
+int nft_mnlio_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			unsigned int flags);
+int nft_mnlio_chain_list_add(struct mnl_socket *nf_sock,
+			     struct nft_chain_list *nlcl,
+			     unsigned int flags);
+int nft_mnlio_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			   unsigned int flags);
+int nft_mnlio_chain_list_delete(struct mnl_socket *nfsock,
+				struct nft_chain_list *nlcl,
+				unsigned int flags);
+struct nft_chain_list *
+nft_mnlio_chain_dump(struct mnl_socket *nf_sock, int family);
+int nft_mnlio_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			unsigned int flags);
+
+int nft_mnlio_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			unsigned int flags);
+int nft_mnlio_table_list_add(struct mnl_socket *nf_sock,
+			     struct nft_table_list *nltl,
+			     unsigned int flags);
+int nft_mnlio_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			   unsigned int flags);
+int nft_mnlio_table_list_delete(struct mnl_socket *nfsock,
+				struct nft_table_list *nltl,
+				unsigned int flags);
+struct nft_table_list *
+nft_mnlio_table_dump(struct mnl_socket *nf_sock, int family);
+int nft_mnlio_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			unsigned int flags);
+
+int nft_mnlio_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+		      unsigned int flags);
+int nft_mnlio_set_list_add(struct mnl_socket *nf_sock,
+			   struct nft_set_list *nlsl,
+			   unsigned int flags);
+int nft_mnlio_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			 unsigned int flags);
+int nft_mnlio_set_list_delete(struct mnl_socket *nfsock,
+			      struct nft_set_list *nlsl, unsigned int flags);
+struct nft_set_list *
+nft_mnlio_set_dump(struct mnl_socket *nf_sock, int family, const char *table);
+int nft_mnlio_set_get(struct mnl_socket *nf_sock, struct nft_set *nls);
+
+int nft_mnlio_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags);
+
+int nft_mnlio_setelem_list_add(struct mnl_socket *nf_sock,
+			       struct nft_set_list *nlsl,
+			       unsigned int flags);
+int nft_mnlio_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			     unsigned int flags);
+int nft_mnlio_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
+
+struct nft_ruleset *
+nft_mnlio_ruleset_dump(struct mnl_socket *nf_sock, uint32_t family);
+int nft_mnlio_ruleset_add(struct mnl_socket *nf_sock, struct nft_ruleset *rs,
+			  unsigned int tflags, unsigned int cflags,
+			  unsigned int rflags, unsigned int sflags,
+			  unsigned int seflags, struct mnl_nlmsg_batch *batch);
+
+#endif /* _LIBNFTNL_MNLIO_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 450279f..ba1eb49 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -35,6 +35,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/reject.c	\
 		      expr/target.c	\
 		      expr/data_reg.h	\
+		      mnlio.c		\
 		      libnftnl.map	\
 		      expr_ops.h	\
 		      internal.h
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 43378ed..acc7201 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -194,5 +194,42 @@ global:
   nft_parse_err_free;
   nft_parse_perror;
 
+  nft_mnlio_talk;
+  nft_mnlio_batch_put;
+  nft_mnlio_batch_talk;
+  nft_mnlio_batch_begin;
+  nft_mnlio_batch_end;
+  nft_mnlio_batch_alloc;
+  nft_mnlio_batch_ready;
+  nft_mnlio_batch_reset;
+  nft_mnlio_rule_add;
+  nft_mnlio_rule_list_add;
+  nft_mnlio_rule_del;
+  nft_mnlio_rule_dump;
+  nft_mnlio_chain_add;
+  nft_mnlio_chain_list_add;
+  nft_mnlio_chain_delete;
+  nft_mnlio_chain_list_delete;
+  nft_mnlio_chain_dump;
+  nft_mnlio_chain_get;
+  nft_mnlio_table_add;
+  nft_mnlio_table_list_add;
+  nft_mnlio_table_delete;
+  nft_mnlio_table_list_delete;
+  nft_mnlio_table_dump;
+  nft_mnlio_table_get;
+  nft_mnlio_set_add;
+  nft_mnlio_set_list_add;
+  nft_mnlio_set_delete;
+  nft_mnlio_set_list_delete;
+  nft_mnlio_set_dump;
+  nft_mnlio_set_get;
+  nft_mnlio_setelem_add;
+  nft_mnlio_setelem_list_add;
+  nft_mnlio_setelem_delete;
+  nft_mnlio_setelem_get;
+  nft_mnlio_ruleset_dump;
+  nft_mnlio_ruleset_add;
+
 local: *;
 };
diff --git a/src/mnlio.c b/src/mnlio.c
new file mode 100644
index 0000000..8e558dd
--- /dev/null
+++ b/src/mnlio.c
@@ -0,0 +1,957 @@
+/*
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ */
+
+#include "internal.h"
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/set.h>
+#include <libnftnl/mnlio.h>
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <errno.h>
+
+static uint32_t seq;
+
+static uint32_t nft_mnlio_seqnum_alloc(void)
+{
+	return seq++;
+}
+
+int
+nft_mnlio_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	       int (*cb)(const struct nlmsghdr *nlh, void *data),
+	       void *cb_data)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t portid = mnl_socket_get_portid(nf_sock);
+	int ret;
+
+	if (mnl_socket_sendto(nf_sock, data, len) < 0)
+		return -1;
+
+	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, cb, cb_data);
+		if (ret <= 0)
+			goto out;
+
+		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+	}
+out:
+	if (ret < 0 && errno == EAGAIN)
+		return 0;
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_talk);
+
+/*
+ * Batching
+ */
+
+/* selected batch page is 256 Kbytes long to load ruleset of
+ * half a million rules without hitting -EMSGSIZE due to large
+ * iovec.
+ */
+#define BATCH_PAGE_SIZE (getpagesize() * 32)
+
+struct mnl_nlmsg_batch *nft_mnlio_batch_alloc(void)
+{
+	static char *buf;
+
+	/* libmnl needs higher buffer to handle batch overflows */
+	buf = malloc(BATCH_PAGE_SIZE + getpagesize());
+	if (buf == NULL)
+		return NULL;
+
+	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
+}
+EXPORT_SYMBOL(nft_mnlio_batch_alloc);
+
+bool nft_mnlio_batch_ready(struct mnl_nlmsg_batch *batch)
+{
+	/* Check if the batch only contains the initial and trailing batch
+	 * messages. In that case, the batch is empty.
+	 */
+	return mnl_nlmsg_batch_size(batch) != (NLMSG_HDRLEN+sizeof(struct nfgenmsg)) * 2;
+}
+EXPORT_SYMBOL(nft_mnlio_batch_ready);
+
+void nft_mnlio_batch_reset(struct mnl_nlmsg_batch *batch)
+{
+	mnl_nlmsg_batch_reset(batch);
+}
+EXPORT_SYMBOL(nft_mnlio_batch_reset);
+
+void nft_mnlio_batch_put(struct mnl_nlmsg_batch *batch, int type,
+			 uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = seqnum;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+
+	mnl_nlmsg_batch_next(batch);
+}
+EXPORT_SYMBOL(nft_mnlio_batch_put);
+
+void nft_mnlio_batch_begin(struct mnl_nlmsg_batch *b)
+{
+	nft_mnlio_batch_put(b, NFNL_MSG_BATCH_BEGIN,
+			    nft_mnlio_seqnum_alloc());
+}
+EXPORT_SYMBOL(nft_mnlio_batch_begin);
+
+void nft_mnlio_batch_end(struct mnl_nlmsg_batch *b)
+{
+	nft_mnlio_batch_put(b, NFNL_MSG_BATCH_END,
+			    nft_mnlio_seqnum_alloc());
+}
+EXPORT_SYMBOL(nft_mnlio_batch_end);
+
+int nft_mnlio_batch_talk(struct mnl_socket *nl, struct mnl_nlmsg_batch *b)
+{
+	int ret, fd = mnl_socket_get_fd(nl);
+	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	fd_set readfds;
+	struct timeval tv = {
+		.tv_sec		= 0,
+		.tv_usec	= 0
+	};
+
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(b),
+				mnl_nlmsg_batch_size(b));
+	if (ret == -1)
+		goto err;
+
+	FD_ZERO(&readfds);
+	FD_SET(fd, &readfds);
+
+	/* receive and digest all the acknowledgments from the kernel. */
+	ret = select(fd+1, &readfds, NULL, NULL, &tv);
+	if (ret == -1)
+		goto err;
+
+	while (ret > 0 && FD_ISSET(fd, &readfds)) {
+		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
+		if (ret == -1)
+			goto err;
+
+		ret = mnl_cb_run(rcv_buf, ret, 0, mnl_socket_get_portid(nl),
+				 NULL, NULL);
+		if (ret < 0)
+			goto err;
+
+		ret = select(fd+1, &readfds, NULL, NULL, &tv);
+		if (ret == -1)
+			goto err;
+
+		FD_ZERO(&readfds);
+		FD_SET(fd, &readfds);
+	}
+err:
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_batch_talk);
+
+/*
+ * Rule
+ */
+int nft_mnlio_rule_add(struct nft_rule *nlr, unsigned int flags,
+		       struct mnl_nlmsg_batch *batch)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			NLM_F_CREATE | flags, nft_mnlio_seqnum_alloc());
+
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+
+	return 0;
+}
+EXPORT_SYMBOL(nft_mnlio_rule_add);
+
+int nft_mnlio_rule_list_add(struct nft_rule_list *nlrl, unsigned int flags,
+			    struct mnl_nlmsg_batch *batch)
+{
+	int ret = 0;
+	struct nft_rule_list_iter *i;
+	struct nft_rule *r;
+
+	i = nft_rule_list_iter_create(nlrl);
+	if (i == NULL)
+		return -1;
+
+	r = nft_rule_list_iter_next(i);
+	while (r != NULL) {
+		ret = nft_mnlio_rule_add(r, flags, batch);
+		if (ret != 0)
+			return ret;
+
+		r = nft_rule_list_iter_next(i);
+	}
+	nft_rule_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_rule_list_add);
+
+int nft_mnlio_rule_del(struct nft_rule *nlr, unsigned int flags,
+		       struct mnl_nlmsg_batch *batch)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			0, nft_mnlio_seqnum_alloc());
+
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+
+	return 0;
+}
+EXPORT_SYMBOL(nft_mnlio_rule_del);
+
+static int rule_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_rule_list *nlr_list = data;
+	struct nft_rule *r;
+
+	r = nft_rule_alloc();
+	if (r == NULL)
+		return -1;
+
+	if (nft_rule_nlmsg_parse(nlh, r) < 0)
+		goto err_free;
+
+	nft_rule_list_add_tail(r, nlr_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_rule_free(r);
+	return MNL_CB_OK;
+}
+
+struct nft_rule_list *
+nft_mnlio_rule_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_rule_list *nlr_list;
+	int ret;
+
+	nlr_list = nft_rule_list_alloc();
+	if (nlr_list == NULL)
+		return NULL;
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+				       NLM_F_DUMP, seq);
+
+	ret = nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	if (ret < 0)
+		goto err;
+
+	return nlr_list;
+err:
+	nft_rule_list_free(nlr_list);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_mnlio_rule_dump);
+
+/*
+ * Chain
+ */
+int nft_mnlio_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			unsigned int flags)
+
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_chain_add);
+
+
+int nft_mnlio_chain_list_add(struct mnl_socket *nf_sock,
+			     struct nft_chain_list *nlcl,
+			     unsigned int flags)
+{
+	int ret = 0;
+	struct nft_chain_list_iter *i;
+	struct nft_chain *c;
+
+	i = nft_chain_list_iter_create(nlcl);
+	if (i == NULL)
+		return -1;
+
+	c = nft_chain_list_iter_next(i);
+	while (c != NULL) {
+		ret = nft_mnlio_chain_add(nf_sock, c, flags);
+
+		if (ret != 0)
+			break;
+
+		c = nft_chain_list_iter_next(i);
+	}
+	nft_chain_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_chain_list_add);
+
+int nft_mnlio_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			   unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_chain_delete);
+
+int nft_mnlio_chain_list_delete(struct mnl_socket *nfsock,
+				struct nft_chain_list *nlcl,
+				unsigned int flags)
+{
+	struct nft_chain_list_iter *i;
+	struct nft_chain *c;
+	int ret = 0;
+
+	i = nft_chain_list_iter_create(nlcl);
+	if (i == NULL)
+		return -1;
+
+	c = nft_chain_list_iter_next(i);
+	while (c != NULL) {
+		ret = nft_mnlio_chain_delete(nfsock, c, flags);
+
+		if (ret < 0)
+			break;
+
+		c = nft_chain_list_iter_next(i);
+	}
+	nft_chain_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_chain_list_delete);
+
+static int chain_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_chain_list *nlc_list = data;
+	struct nft_chain *c;
+
+	c = nft_chain_alloc();
+	if (c == NULL)
+		return -1;
+
+	if (nft_chain_nlmsg_parse(nlh, c) < 0)
+		goto err_free;
+
+	nft_chain_list_add_tail(c, nlc_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_chain_free(c);
+	return MNL_CB_OK;
+}
+
+struct nft_chain_list *
+nft_mnlio_chain_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_chain_list *nlc_list;
+	int ret;
+
+	nlc_list = nft_chain_list_alloc();
+	if (nlc_list == NULL)
+		return NULL;
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+					NLM_F_DUMP, seq);
+
+	ret = nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	if (ret < 0)
+		goto err;
+
+	return nlc_list;
+err:
+	nft_chain_list_free(nlc_list);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_mnlio_chain_dump);
+
+static int chain_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	nft_chain_nlmsg_parse(nlh, data);
+	return MNL_CB_OK;
+}
+
+int nft_mnlio_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK | flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
+}
+EXPORT_SYMBOL(nft_mnlio_chain_get);
+
+/*
+ * Table
+ */
+int nft_mnlio_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_ACK | flags, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_table_add);
+
+int nft_mnlio_table_list_add(struct mnl_socket *nf_sock,
+			     struct nft_table_list *nltl,
+			     unsigned int flags)
+{
+	int ret = 0;
+	struct nft_table_list_iter *i;
+	struct nft_table *t;
+
+	i = nft_table_list_iter_create(nltl);
+	if (i == NULL)
+		return -1;
+
+	t = nft_table_list_iter_next(i);
+	while (t != NULL) {
+		ret = nft_mnlio_table_add(nf_sock, t, flags);
+
+		if (ret != 0)
+			break;
+
+		t = nft_table_list_iter_next(i);
+	}
+	nft_table_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_table_list_add);
+
+int nft_mnlio_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			   unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_table_delete);
+
+int nft_mnlio_table_list_delete(struct mnl_socket *nfsock,
+				struct nft_table_list *nltl,
+				unsigned int flags)
+{
+	struct nft_table_list_iter *i;
+	struct nft_table *t;
+	int ret = 0;
+
+	i = nft_table_list_iter_create(nltl);
+	if (i == NULL)
+		return -1;
+
+	t = nft_table_list_iter_next(i);
+	while (t != NULL) {
+		ret = nft_mnlio_table_delete(nfsock, t, flags);
+
+		if (ret < 0)
+			break;
+
+		t = nft_table_list_iter_next(i);
+	}
+	nft_table_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_table_list_delete);
+
+static int table_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_table_list *nlt_list = data;
+	struct nft_table *t;
+
+	t = nft_table_alloc();
+	if (t == NULL)
+		return -1;
+
+	if (nft_table_nlmsg_parse(nlh, t) < 0)
+		goto err_free;
+
+	nft_table_list_add_tail(t, nlt_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_table_free(t);
+	return MNL_CB_OK;
+}
+
+struct nft_table_list *
+nft_mnlio_table_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_table_list *nlt_list;
+	int ret;
+
+	nlt_list = nft_table_list_alloc();
+	if (nlt_list == NULL)
+		return NULL;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					NLM_F_DUMP, seq);
+
+	ret = nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
+	if (ret < 0)
+		goto err;
+
+	return nlt_list;
+err:
+	nft_table_list_free(nlt_list);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_mnlio_table_dump);
+
+static int table_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_table *t = data;
+
+	nft_table_nlmsg_parse(nlh, t);
+	return MNL_CB_OK;
+}
+
+int nft_mnlio_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t family;
+
+	family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					NLM_F_ACK, seq);
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
+}
+EXPORT_SYMBOL(nft_mnlio_table_get);
+
+
+/*
+ * Set
+ */
+static int set_add_cb(const struct nlmsghdr *nlh, void *data)
+{
+	nft_set_nlmsg_parse(nlh, data);
+	return MNL_CB_OK;
+}
+
+int nft_mnlio_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+		      unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
+}
+EXPORT_SYMBOL(nft_mnlio_set_add);
+
+int nft_mnlio_set_list_add(struct mnl_socket *nf_sock,
+			   struct nft_set_list *nlsl,
+			   unsigned int flags)
+{
+	int ret = 0;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		return -1;
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = nft_mnlio_set_add(nf_sock, s, flags);
+
+		if (ret != 0)
+			break;
+
+		s = nft_set_list_iter_next(i);
+	}
+	nft_set_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_set_list_add);
+
+int nft_mnlio_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			 unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			flags|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_set_delete);
+
+int nft_mnlio_set_list_delete(struct mnl_socket *nfsock,
+			      struct nft_set_list *nlsl, unsigned int flags)
+{
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+	int ret = 0;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		return -1;
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = nft_mnlio_set_delete(nfsock, s, flags);
+
+		if (ret < 0)
+			break;
+
+		s = nft_set_list_iter_next(i);
+	}
+	nft_set_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_set_list_delete);
+
+static int set_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_set_list *nls_list = data;
+	struct nft_set *s;
+
+	s = nft_set_alloc();
+	if (s == NULL)
+		return -1;
+
+	if (nft_set_nlmsg_parse(nlh, s) < 0)
+		goto err_free;
+
+	nft_set_list_add_tail(s, nls_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_set_free(s);
+	return MNL_CB_OK;
+}
+
+struct nft_set_list *
+nft_mnlio_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_set *s;
+	struct nft_set_list *nls_list;
+	int ret;
+
+	s = nft_set_alloc();
+	if (s == NULL)
+		return NULL;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+				      NLM_F_DUMP|NLM_F_ACK, seq);
+	if (table != NULL)
+		nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+	nft_set_nlmsg_build_payload(nlh, s);
+	nft_set_free(s);
+
+	nls_list = nft_set_list_alloc();
+	if (nls_list == NULL)
+		return NULL;
+
+	ret = nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	if (ret < 0)
+		goto err;
+
+	return nls_list;
+err:
+	nft_set_list_free(nls_list);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_mnlio_set_dump);
+
+static int set_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_set *s = data;
+
+	nft_set_nlmsg_parse(nlh, s);
+	return MNL_CB_OK;
+}
+
+int nft_mnlio_set_get(struct mnl_socket *nf_sock, struct nft_set *nls)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, set_get_cb, nls);
+}
+EXPORT_SYMBOL(nft_mnlio_set_get);
+
+/*
+ * Set elements
+ */
+int nft_mnlio_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			  unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_setelem_add);
+
+int nft_mnlio_setelem_list_add(struct mnl_socket *nf_sock,
+			       struct nft_set_list *nlsl,
+			       unsigned int flags)
+{
+	int ret = 0;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		return -1;
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = nft_mnlio_setelem_add(nf_sock, s, flags);
+
+		if (ret != 0)
+			break;
+
+		s = nft_set_list_iter_next(i);
+	}
+	nft_set_list_iter_destroy(i);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_setelem_list_add);
+
+int nft_mnlio_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			     unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+EXPORT_SYMBOL(nft_mnlio_setelem_delete);
+
+static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
+{
+	nft_set_elems_nlmsg_parse(nlh, data);
+	return MNL_CB_OK;
+}
+
+int nft_mnlio_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+			NLM_F_DUMP|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return nft_mnlio_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
+}
+EXPORT_SYMBOL(nft_mnlio_setelem_get);
+
+/*
+ * ruleset
+ */
+struct nft_ruleset *
+nft_mnlio_ruleset_dump(struct mnl_socket *nf_sock, uint32_t family)
+{
+	struct nft_ruleset *rs;
+	struct nft_table_list *t;
+	struct nft_chain_list *c;
+	struct nft_set_list *sl;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+	struct nft_rule_list *r;
+	int ret = 0;
+
+	rs = nft_ruleset_alloc();
+	if (rs == NULL)
+		return NULL;
+
+	t = nft_mnlio_table_dump(nf_sock, family);
+	if (t != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
+
+	c = nft_mnlio_chain_dump(nf_sock, family);
+	if (c != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
+
+	sl = nft_mnlio_set_dump(nf_sock, family, NULL);
+	if (sl != NULL) {
+		i = nft_set_list_iter_create(sl);
+		s = nft_set_list_iter_next(i);
+		while (s != NULL) {
+			ret = nft_mnlio_setelem_get(nf_sock, s);
+			if (ret != 0)
+				goto out;
+
+			s = nft_set_list_iter_next(i);
+		}
+		nft_set_list_iter_destroy(i);
+
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
+	}
+
+	r = nft_mnlio_rule_dump(nf_sock, family);
+	if (r != NULL)
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+
+	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) &&
+	    !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)))
+		goto out;
+
+	return rs;
+out:
+	nft_ruleset_free(rs);
+	return NULL;
+}
+EXPORT_SYMBOL(nft_mnlio_ruleset_dump);
+
+int nft_mnlio_ruleset_add(struct mnl_socket *nf_sock, struct nft_ruleset *rs,
+			  unsigned int tflags, unsigned int cflags,
+			  unsigned int rflags, unsigned int sflags,
+			  unsigned int seflags, struct mnl_nlmsg_batch *batch)
+{
+	int ret = 0;
+	struct nft_table_list *t;
+	struct nft_chain_list *c;
+	struct nft_set_list *s;
+	struct nft_rule_list *r;
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) {
+		t = (struct nft_table_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_TABLELIST);
+		ret = nft_mnlio_table_list_add(nf_sock, t, tflags);
+		if (ret != 0)
+			return ret;
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) {
+		c = (struct nft_chain_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_CHAINLIST);
+		ret = nft_mnlio_chain_list_add(nf_sock, c, cflags);
+		if (ret != 0)
+			return ret;
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) {
+		s = (struct nft_set_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_SETLIST);
+		ret = nft_mnlio_set_list_add(nf_sock, s, sflags);
+		if (ret != 0)
+			return ret;
+
+		ret = nft_mnlio_setelem_list_add(nf_sock, s, seflags);
+		if (ret != 0)
+			return ret;
+
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)) {
+		r = (struct nft_rule_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_RULELIST);
+		ret = nft_mnlio_rule_list_add(r, rflags, batch);
+		if (ret != 0)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_mnlio_ruleset_add);

