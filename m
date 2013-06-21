From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] src: use libnftables
Date: Fri, 21 Jun 2013 16:42:19 +0200
Message-ID: <1371825739-3669-5-git-send-email-pablo@netfilter.org>
References: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422959Ab3FUOmi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:38 -0400
In-Reply-To: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch migrates nft to use the libnftables library, that is used
by the iptables over nftables compat utility as well. Most of the
conversion was pretty straight forward. Some small significant changes
happened in the handling of set element and immediate data abstraction
that libnl provides. libnftables is a bit more granular since it splits
the struct nfnl_nft_data into three attributes: verdict, chain and plain
data (used in maps).

I have added a new file src/mnl.c that contains the low level netlink
communication that now resides in nftables source tree instead of
the library. This should help to implement the batching support using
libmnl in follow up patches.

I also spent some significant amount of time running my tests to make
sure that we don't increase the number of bugs that we already have
(I plan to provide a list of those that I have detected and diagnosed,
so anyone else can help us to fix them).

As a side effect, this change should also prepare the field for the
support JSON and XML support anytime soon.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac              |    8 +-
 include/mnl.h             |   43 +++
 include/netlink.h         |   67 ++--
 include/nftables.h        |    2 +-
 src/Makefile.in           |    1 +
 src/erec.c                |    2 +-
 src/mnl.c                 |  478 +++++++++++++++++++++++++
 src/netlink.c             |  846 ++++++++++++++++++++++-----------------------
 src/netlink_delinearize.c |  190 ++++++----
 src/netlink_linearize.c   |  337 ++++++++++--------
 10 files changed, 1303 insertions(+), 671 deletions(-)
 create mode 100644 include/mnl.h
 create mode 100644 src/mnl.c

diff --git a/configure.ac b/configure.ac
index 316d043..811d7e2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,11 +49,11 @@ then
 fi
 
 # Checks for libraries.
-AC_CHECK_LIB([nl], [nl_socket_alloc], ,
-	     AC_MSG_ERROR([No suitable version of libnl found]))
+AC_CHECK_LIB([mnl], [mnl_socket_open], ,
+	     AC_MSG_ERROR([No suitable version of libmnl found]))
 
-AC_CHECK_LIB([nl-nf], [nfnl_nft_rule_alloc], ,
-	     AC_MSG_ERROR([No suitable version of libnl-nf found]))
+AC_CHECK_LIB([nftables], [nft_rule_alloc], ,
+	     AC_MSG_ERROR([No suitable version of libnftables found]))
 
 AC_CHECK_LIB([gmp], [__gmpz_init], ,
 	     AC_MSG_ERROR([No suitable version of libgmp found]))
diff --git a/include/mnl.h b/include/mnl.h
new file mode 100644
index 0000000..c878ce4
--- /dev/null
+++ b/include/mnl.h
@@ -0,0 +1,43 @@
+#ifndef _MNL_H_
+#define _MNL_H_
+
+int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *r,
+		     unsigned int flags);
+int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *r,
+			unsigned int flags);
+struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
+					int family);
+
+int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+		      unsigned int flags);
+int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+                         unsigned int flags);
+struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
+					  int family);
+int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+		      unsigned int flags);
+
+int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags);
+int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags);
+struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
+					  int family);
+int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags);
+
+int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+		    unsigned int flags);
+int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+		       unsigned int flags);
+struct nft_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
+				      const char *table);
+int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls);
+
+int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			unsigned int flags);
+int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			   unsigned int flags);
+int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
+
+#endif
diff --git a/include/netlink.h b/include/netlink.h
index ccbb872..19574f0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -1,13 +1,14 @@
 #ifndef NFTABLES_NETLINK_H
 #define NFTABLES_NETLINK_H
 
-#include <netlink/netfilter/netfilter.h>
-#include <netlink/netfilter/nft_table.h>
-#include <netlink/netfilter/nft_chain.h>
-#include <netlink/netfilter/nft_rule.h>
-#include <netlink/netfilter/nft_expr.h>
-#include <netlink/netfilter/nft_data.h>
-#include <netlink/object.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+#include <libnftables/set.h>
+
+#include <linux/netlink.h>
+#include <linux/netfilter/nf_tables.h>
 
 #include <rule.h>
 
@@ -17,45 +18,57 @@
  * @msgs:	message queue
  * @list:	list of parsed rules/chains/tables
  * @set:	current set
+ * @data:	pointer to pass data to callback
  */
 struct netlink_ctx {
 	struct list_head	*msgs;
 	struct list_head	list;
 	struct set		*set;
+	const void		*data;
 };
 
-extern void netlink_dump_object(struct nl_object *obj);
+extern struct nft_table *alloc_nft_table(const struct handle *h);
+extern struct nft_chain *alloc_nft_chain(const struct handle *h);
+extern struct nft_rule *alloc_nft_rule(const struct handle *h);
+extern struct nft_rule_expr *alloc_nft_expr(const char *name);
+extern struct nft_set *alloc_nft_set(const struct handle *h);
 
-extern struct nfnl_nft_table *alloc_nft_table(const struct handle *h);
-extern struct nfnl_nft_chain *alloc_nft_chain(const struct handle *h);
-extern struct nfnl_nft_rule *alloc_nft_rule(const struct handle *h);
-extern struct nfnl_nft_expr *alloc_nft_expr(int (*init)(struct nfnl_nft_expr *));
-extern struct nfnl_nft_set *alloc_nft_set(const struct handle *h);
-extern struct nfnl_nft_data *alloc_nft_data(const void *data, unsigned int len);
+struct nft_data_linearize {
+	size_t		len;
+	uint32_t	value[4];
+	char		chain[NFT_CHAIN_MAXNAMELEN];
+	int		verdict;
+};
 
-extern struct nfnl_nft_data *netlink_gen_data(const struct expr *expr);
-extern struct nfnl_nft_data *netlink_gen_raw_data(const mpz_t value,
-						  enum byteorder byteorder,
-						  unsigned int len);
+struct nft_data_delinearize {
+	size_t		len;
+	const uint32_t	*value;
+	const char	*chain;
+	int		verdict;
+};
+
+extern void netlink_gen_data(const struct expr *expr,
+			     struct nft_data_linearize *data);
+extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
+				 unsigned int len,
+				 struct nft_data_linearize *data);
 
 extern struct expr *netlink_alloc_value(const struct location *loc,
-				        const struct nfnl_nft_data *nld);
+				        const struct nft_data_delinearize *nld);
 extern struct expr *netlink_alloc_data(const struct location *loc,
-				       const struct nfnl_nft_data *nld,
+				       const struct nft_data_delinearize *nld,
 				       enum nft_registers dreg);
 
 extern int netlink_linearize_rule(struct netlink_ctx *ctx,
-				  struct nfnl_nft_rule *nlr,
+				  struct nft_rule *nlr,
 				  const struct rule *rule);
 extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
-					     const struct nl_object *obj);
+					     const struct nft_rule *r);
 
 extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
 extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
-extern int netlink_get_rule(struct netlink_ctx *ctx, const struct handle *h,
-			    const struct location *loc);
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
@@ -103,4 +116,10 @@ extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, struct set *set);
 
+extern void netlink_dump_table(struct nft_table *nlt);
+extern void netlink_dump_chain(struct nft_chain *nlc);
+extern void netlink_dump_rule(struct nft_rule *nlr);
+extern void netlink_dump_expr(struct nft_rule_expr *nle);
+extern void netlink_dump_set(struct nft_set *nls);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/nftables.h b/include/nftables.h
index ff91d93..ec21d37 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -50,7 +50,7 @@ struct location {
 			unsigned int		last_column;
 		};
 		struct {
-			struct nl_object	*nl_obj;
+			void			*nle;
 		};
 	};
 };
diff --git a/src/Makefile.in b/src/Makefile.in
index 6bfcd64..658e9b3 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -21,6 +21,7 @@ nft-obj			+= rbtree.o
 nft-obj			+= gmputil.o
 nft-obj			+= utils.o
 nft-obj			+= erec.o
+nft-obj			+= mnl.o
 
 nft-obj			+= parser.o
 nft-extra-clean-files	+= parser.c parser.h
diff --git a/src/erec.c b/src/erec.c
index f2b0ce6..7451d94 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -107,7 +107,7 @@ void erec_print(FILE *f, const struct error_record *erec)
 		fprintf(f, "%s\n", erec->msg);
 		for (l = 0; l < (int)erec->num_locations; l++) {
 			loc = &erec->locations[l];
-			netlink_dump_object(loc->nl_obj);
+			netlink_dump_expr(loc->nle);
 		}
 		fprintf(f, "\n");
 	} else {
diff --git a/src/mnl.c b/src/mnl.c
new file mode 100644
index 0000000..ea9637c
--- /dev/null
+++ b/src/mnl.c
@@ -0,0 +1,478 @@
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
+#include <libmnl/libmnl.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+#include <libnftables/set.h>
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <mnl.h>
+#include <errno.h>
+#include <utils.h>
+
+static int seq;
+
+static int
+mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
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
+
+/*
+ * Rule
+ */
+int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
+		     unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			NLM_F_APPEND|NLM_F_ACK|NLM_F_CREATE, seq);
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *nlr,
+			unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
+			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_rule_nlmsg_build_payload(nlh, nlr);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+static int rule_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_rule_list *nlr_list = data;
+	struct nft_rule *r;
+
+	r = nft_rule_alloc();
+	if (r == NULL)
+		memory_allocation_error();
+
+	if (nft_rule_nlmsg_parse(nlh, r) < 0)
+		goto err_free;
+
+	nft_rule_list_add(r, nlr_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_rule_free(r);
+	return MNL_CB_OK;
+}
+
+struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_rule_list *nlr_list;
+	int ret;
+
+	nlr_list = nft_rule_list_alloc();
+	if (nlr_list == NULL)
+		memory_allocation_error();
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+				       NLM_F_DUMP, seq);
+
+	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	if (ret < 0)
+		goto err;
+
+	return nlr_list;
+err:
+	nft_rule_list_free(nlr_list);
+	return NULL;
+}
+
+/*
+ * Chain
+ */
+int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+		      unsigned int flags)
+
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK|flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			 unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+static int chain_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_chain_list *nlc_list = data;
+	struct nft_chain *c;
+
+	c = nft_chain_alloc();
+	if (c == NULL)
+		memory_allocation_error();
+
+	if (nft_chain_nlmsg_parse(nlh, c) < 0)
+		goto err_free;
+
+	nft_chain_list_add(c, nlc_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_chain_free(c);
+	return MNL_CB_OK;
+}
+
+struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_chain_list *nlc_list;
+	int ret;
+
+	nlc_list = nft_chain_list_alloc();
+	if (nlc_list == NULL)
+		memory_allocation_error();
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+					NLM_F_DUMP, seq);
+
+	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	if (ret < 0)
+		goto err;
+
+	return nlc_list;
+err:
+	nft_chain_list_free(nlc_list);
+	return NULL;
+}
+
+static int chain_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	nft_chain_nlmsg_parse(nlh, data);
+	return MNL_CB_OK;
+}
+
+int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+		      unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK|flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
+}
+
+/*
+ * Table
+ */
+int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_EXCL|NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+static int table_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_table_list *nlt_list = data;
+	struct nft_table *t;
+
+	t = nft_table_alloc();
+	if (t == NULL)
+		memory_allocation_error();
+
+	if (nft_table_nlmsg_parse(nlh, t) < 0)
+		goto err_free;
+
+	nft_table_list_add(t, nlt_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_table_free(t);
+	return MNL_CB_OK;
+}
+
+struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock, int family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_table_list *nlt_list;
+	int ret;
+
+	nlt_list = nft_table_list_alloc();
+	if (nlt_list == NULL)
+		memory_allocation_error();
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					NLM_F_DUMP, seq);
+
+	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
+	if (ret < 0)
+		goto err;
+
+	return nlt_list;
+err:
+	nft_table_list_free(nlt_list);
+	return NULL;
+}
+
+static int table_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_table *t = data;
+
+	nft_table_nlmsg_parse(nlh, t);
+	return MNL_CB_OK;
+}
+
+int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
+		      unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
+					nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+					NLM_F_ACK, seq);
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
+}
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
+int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+		    unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      flags|NLM_F_CREATE|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
+}
+
+int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+		       unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      flags|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+static int set_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_set_list *nls_list = data;
+	struct nft_set *s;
+
+	s = nft_set_alloc();
+	if (s == NULL)
+		memory_allocation_error();
+
+	if (nft_set_nlmsg_parse(nlh, s) < 0)
+		goto err_free;
+
+	nft_set_list_add(s, nls_list);
+	return MNL_CB_OK;
+
+err_free:
+	nft_set_free(s);
+	return MNL_CB_OK;
+}
+
+struct nft_set_list *
+mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_set *s;
+	struct nft_set_list *nls_list;
+	int ret;
+
+	s = nft_set_alloc();
+	if (s == NULL)
+		memory_allocation_error();
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+				      NLM_F_DUMP|NLM_F_ACK, seq);
+	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+	nft_set_nlmsg_build_payload(nlh, s);
+	nft_set_free(s);
+
+	nls_list = nft_set_list_alloc();
+	if (nls_list == NULL)
+		memory_allocation_error();
+
+	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	if (ret < 0)
+		goto err;
+
+	return nls_list;
+err:
+	nft_set_list_free(nls_list);
+	return NULL;
+}
+
+static int set_get_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_set *s = data;
+
+	nft_set_nlmsg_parse(nlh, s);
+	return MNL_CB_OK;
+}
+
+int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_get_cb, nls);
+}
+
+/*
+ * Set elements
+ */
+int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+			unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
+			   unsigned int flags)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      NLM_F_ACK, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+}
+
+static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
+{
+	nft_set_elems_nlmsg_parse(nlh, data);
+	return MNL_CB_OK;
+}
+
+int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
+				      nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				      NLM_F_DUMP|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, nls);
+
+	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
+}
diff --git a/src/netlink.c b/src/netlink.c
index da290d5..d835281 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008-2012 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -8,59 +9,39 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
-#include <netlink/netfilter/nfnl.h>
-#include <netlink/netfilter/netfilter.h>
-#include <netlink/netfilter/nft_table.h>
-#include <netlink/netfilter/nft_chain.h>
-#include <netlink/netfilter/nft_rule.h>
-#include <netlink/netfilter/nft_expr.h>
-#include <netlink/netfilter/nft_data.h>
-#include <netlink/netfilter/nft_setelem.h>
-#include <netlink/netfilter/nft_set.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <libmnl/libmnl.h>
+
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/expr.h>
+#include <libnftables/set.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <nftables.h>
 #include <netlink.h>
+#include <mnl.h>
 #include <expression.h>
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
 
-static struct nl_sock *nf_sock;
+static struct mnl_socket *nf_sock;
 
 static void __init netlink_open_sock(void)
 {
-	nlmsg_set_default_size(65536);
-	nf_sock = nl_socket_alloc();
+	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
 	if (nf_sock == NULL)
 		memory_allocation_error();
 
-	nfnl_connect(nf_sock);
-	nl_socket_set_nonblocking(nf_sock);
+	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 }
 
 static void __exit netlink_close_sock(void)
 {
-	nl_socket_free(nf_sock);
-}
-
-static void netlink_set_callback(nl_recvmsg_msg_cb_t func, void *arg)
-{
-	nl_socket_modify_cb(nf_sock, NL_CB_VALID, NL_CB_CUSTOM, func, arg);
-}
-
-void netlink_dump_object(struct nl_object *obj)
-{
-#ifdef DEBUG
-	struct nl_dump_params params = {
-		.dp_fd		= stdout,
-		.dp_type	= NL_DUMP_DETAILS,
-	};
-
-	if (!(debug_level & DEBUG_NETLINK))
-		return;
-	nl_object_dump(obj, &params);
-#endif
+	mnl_socket_close(nf_sock);
 }
 
 static int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
@@ -79,119 +60,128 @@ static int netlink_io_error(struct netlink_ctx *ctx, const struct location *loc,
 	return -1;
 }
 
-struct nfnl_nft_table *alloc_nft_table(const struct handle *h)
+struct nft_table *alloc_nft_table(const struct handle *h)
 {
-	struct nfnl_nft_table *nlt;
+	struct nft_table *nlt;
 
-	nlt = nfnl_nft_table_alloc();
+	nlt = nft_table_alloc();
 	if (nlt == NULL)
 		memory_allocation_error();
-	nfnl_nft_table_set_family(nlt, h->family);
+
+	nft_table_attr_set_u32(nlt, NFT_TABLE_ATTR_FAMILY, h->family);
 	if (h->table != NULL)
-		nfnl_nft_table_set_name(nlt, h->table, strlen(h->table) + 1);
+		nft_table_attr_set(nlt, NFT_TABLE_ATTR_NAME, h->table);
 	return nlt;
 }
 
-struct nfnl_nft_chain *alloc_nft_chain(const struct handle *h)
+struct nft_chain *alloc_nft_chain(const struct handle *h)
 {
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain *nlc;
 
-	nlc = nfnl_nft_chain_alloc();
+	nlc = nft_chain_alloc();
 	if (nlc == NULL)
 		memory_allocation_error();
-	nfnl_nft_chain_set_family(nlc, h->family);
-	nfnl_nft_chain_set_table(nlc, h->table, strlen(h->table) + 1);
+
+	nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_FAMILY, h->family);
+	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TABLE, h->table);
 	if (h->handle != 0)
-		nfnl_nft_chain_set_handle(nlc, h->handle);
+		nft_chain_attr_set_u64(nlc, NFT_CHAIN_ATTR_HANDLE, h->handle);
 	if (h->chain != NULL)
-		nfnl_nft_chain_set_name(nlc, h->chain, strlen(h->chain) + 1);
+		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, h->chain);
 	return nlc;
 }
 
-struct nfnl_nft_rule *alloc_nft_rule(const struct handle *h)
+struct nft_rule *alloc_nft_rule(const struct handle *h)
 {
-	struct nfnl_nft_rule *nlr;
+	struct nft_rule *nlr;
 
-	nlr = nfnl_nft_rule_alloc();
+	nlr = nft_rule_alloc();
 	if (nlr == NULL)
 		memory_allocation_error();
-	nfnl_nft_rule_set_family(nlr, h->family);
-	nfnl_nft_rule_set_table(nlr, h->table, strlen(h->table) + 1);
+
+	nft_rule_attr_set_u32(nlr, NFT_RULE_ATTR_FAMILY, h->family);
+	nft_rule_attr_set_str(nlr, NFT_RULE_ATTR_TABLE, h->table);
 	if (h->chain != NULL)
-		nfnl_nft_rule_set_chain(nlr, h->chain, strlen(h->chain) + 1);
+		nft_rule_attr_set_str(nlr, NFT_RULE_ATTR_CHAIN, h->chain);
 	if (h->handle)
-		nfnl_nft_rule_set_handle(nlr, h->handle);
+		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_HANDLE, h->handle);
 	return nlr;
 }
 
-struct nfnl_nft_expr *alloc_nft_expr(int (*init)(struct nfnl_nft_expr *))
+struct nft_rule_expr *alloc_nft_expr(const char *name)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
-	nle = nfnl_nft_expr_alloc();
-	if (nle == NULL || init(nle) != 0)
+	nle = nft_rule_expr_alloc(name);
+	if (nle == NULL)
 		memory_allocation_error();
 	return nle;
 }
 
-struct nfnl_nft_set *alloc_nft_set(const struct handle *h)
+struct nft_set *alloc_nft_set(const struct handle *h)
 {
-	struct nfnl_nft_set *nls;
+	struct nft_set *nls;
 
-	nls = nfnl_nft_set_alloc();
+	nls = nft_set_alloc();
 	if (nls == NULL)
 		memory_allocation_error();
-	nfnl_nft_set_set_family(nls, h->family);
-	nfnl_nft_set_set_table(nls, h->table, strlen(h->table) + 1);
+
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FAMILY, h->family);
+	nft_set_attr_set_str(nls, NFT_SET_ATTR_TABLE, h->table);
 	if (h->set != NULL)
-		nfnl_nft_set_set_name(nls, h->set, strlen(h->set) + 1);
+		nft_set_attr_set_str(nls, NFT_SET_ATTR_NAME, h->set);
+
 	return nls;
 }
 
-static struct nfnl_nft_setelem *alloc_nft_setelem(const struct expr *expr)
+static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 {
-	struct nfnl_nft_setelem *nlse;
+	struct nft_set_elem *nlse;
+	struct nft_data_linearize nld;
 
-	nlse = nfnl_nft_setelem_alloc();
+	nlse = nft_set_elem_alloc();
 	if (nlse == NULL)
 		memory_allocation_error();
 
-	if (expr->ops->type == EXPR_VALUE || expr->flags & EXPR_F_INTERVAL_END)
-		nfnl_nft_setelem_set_key(nlse, netlink_gen_data(expr));
-	else {
+	if (expr->ops->type == EXPR_VALUE ||
+	    expr->flags & EXPR_F_INTERVAL_END) {
+		netlink_gen_data(expr, &nld);
+		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
+				      &nld.value, nld.len);
+	} else {
 		assert(expr->ops->type == EXPR_MAPPING);
-		nfnl_nft_setelem_set_key(nlse, netlink_gen_data(expr->left));
-		nfnl_nft_setelem_set_data(nlse, netlink_gen_data(expr->right));
+		netlink_gen_data(expr->left, &nld);
+		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
+				      &nld.value, nld.len);
+		netlink_gen_data(expr->right, &nld);
+		if (expr->right->ops->type == EXPR_VERDICT) {
+			nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT,
+						  expr->right->verdict);
+			if (expr->chain != NULL) {
+				nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_CHAIN,
+						nld.chain, strlen(nld.chain));
+			}
+		}
 	}
 
-	if (expr->flags & EXPR_F_INTERVAL_END)
-		nfnl_nft_setelem_set_flags(nlse, NFT_SET_ELEM_INTERVAL_END);
+	if (expr->flags & EXPR_F_INTERVAL_END) {
+		nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_FLAGS,
+					  NFT_SET_ELEM_INTERVAL_END);
+	}
 
 	return nlse;
 }
 
-struct nfnl_nft_data *alloc_nft_data(const void *data, unsigned int len)
+void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
+			  unsigned int len, struct nft_data_linearize *data)
 {
-	struct nfnl_nft_data *nld;
-
 	assert(len > 0);
-	nld = nfnl_nft_data_alloc(data, len);
-	if (nld == NULL)
-		memory_allocation_error();
-	return nld;
+	mpz_export_data(data->value, value, byteorder, len);
+	data->len = len;
 }
 
-struct nfnl_nft_data *netlink_gen_raw_data(const mpz_t value,
-					   enum byteorder byteorder,
-					   unsigned int len)
-{
-	unsigned char data[len];
-
-	mpz_export_data(data, value, byteorder, len);
-	return alloc_nft_data(data, len);
-}
-
-static struct nfnl_nft_data *netlink_gen_concat_data(const struct expr *expr)
+static void netlink_gen_concat_data(const struct expr *expr,
+				    struct nft_data_linearize *nld)
 {
 	const struct expr *i;
 	unsigned int len, offset;
@@ -210,79 +200,75 @@ static struct nfnl_nft_data *netlink_gen_concat_data(const struct expr *expr)
 					i->len / BITS_PER_BYTE);
 			offset += i->len / BITS_PER_BYTE;
 		}
-	
-		return alloc_nft_data(data, len / BITS_PER_BYTE);
+
+		memcpy(nld->value, data, len / BITS_PER_BYTE);
+		nld->len = len;
 	}
 }
 
-static struct nfnl_nft_data *netlink_gen_constant_data(const struct expr *expr)
+static void netlink_gen_constant_data(const struct expr *expr,
+				      struct nft_data_linearize *data)
 {
 	assert(expr->ops->type == EXPR_VALUE);
-	return netlink_gen_raw_data(expr->value, expr->byteorder,
-				    div_round_up(expr->len, BITS_PER_BYTE));
+	netlink_gen_raw_data(expr->value, expr->byteorder,
+			     div_round_up(expr->len, BITS_PER_BYTE), data);
 }
 
-static struct nfnl_nft_data *netlink_gen_verdict(const struct expr *expr)
+static void netlink_gen_verdict(const struct expr *expr,
+				struct nft_data_linearize *data)
 {
-	struct nfnl_nft_data *verdict;
-
-	verdict = nfnl_nft_verdict_alloc();
-	nfnl_nft_verdict_set_verdict(verdict, expr->verdict);
+	data->verdict = expr->verdict;
 
 	switch (expr->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		nfnl_nft_verdict_set_chain(verdict, expr->chain);
+		strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
+		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
 	}
-
-	return verdict;
 }
 
-struct nfnl_nft_data *netlink_gen_data(const struct expr *expr)
+void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 {
 	switch (expr->ops->type) {
 	case EXPR_VALUE:
-		return netlink_gen_constant_data(expr);
+		return netlink_gen_constant_data(expr, data);
 	case EXPR_CONCAT:
-		return netlink_gen_concat_data(expr);
+		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
-		return netlink_gen_verdict(expr);
+		return netlink_gen_verdict(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr->ops->name);
 	}
 }
 
 struct expr *netlink_alloc_value(const struct location *loc,
-				 const struct nfnl_nft_data *nld)
+				 const struct nft_data_delinearize *nld)
 {
 	return constant_expr_alloc(loc, &invalid_type, BYTEORDER_INVALID,
-				   nfnl_nft_data_get_size(nld) * BITS_PER_BYTE,
-				   nfnl_nft_data_get(nld));
+				   nld->len * BITS_PER_BYTE, nld->value);
 }
 
 static struct expr *netlink_alloc_verdict(const struct location *loc,
-					  const struct nfnl_nft_data *nld)
+					  const struct nft_data_delinearize *nld)
 {
-	unsigned int code;
 	char *chain;
 
-	code = nfnl_nft_verdict_get_verdict(nld);
-	switch (code) {
+	switch (nld->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		chain = xstrdup(nfnl_nft_verdict_get_chain(nld));
+		chain = xstrdup(nld->chain);
 		break;
 	default:
 		chain = NULL;
 		break;
 	}
 
-	return verdict_expr_alloc(loc, code, chain);
+	return verdict_expr_alloc(loc, nld->verdict, chain);
 }
 
 struct expr *netlink_alloc_data(const struct location *loc,
-				const struct nfnl_nft_data *nld,
+				const struct nft_data_delinearize *nld,
 				enum nft_registers dreg)
 {
 	switch (dreg) {
@@ -296,230 +282,246 @@ struct expr *netlink_alloc_data(const struct location *loc,
 int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 		     const struct rule *rule, uint32_t flags)
 {
-	struct nfnl_nft_rule *nlr;
+	struct nft_rule *nlr;
 	int err;
 
 	nlr = alloc_nft_rule(&rule->handle);
 	err = netlink_linearize_rule(ctx, nlr, rule);
 	if (err == 0) {
-		err = nfnl_nft_rule_add(nf_sock, nlr, flags | NLM_F_EXCL);
+		err = mnl_nft_rule_add(nf_sock, nlr, flags | NLM_F_EXCL);
 		if (err < 0)
 			netlink_io_error(ctx, &rule->location,
-					 "Could not add rule: %s", nl_geterror(err));
+					 "Could not add rule: %s",
+					 strerror(errno));
 	}
-	nfnl_nft_rule_put(nlr);
+	nft_rule_free(nlr);
 	return err;
 }
 
 int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
-	struct nfnl_nft_rule *nlr;
+	struct nft_rule *nlr;
 	int err;
 
 	nlr = alloc_nft_rule(h);
-	err = nfnl_nft_rule_delete(nf_sock, nlr, 0);
-	nfnl_nft_rule_put(nlr);
+	err = mnl_nft_rule_delete(nf_sock, nlr, 0);
+	nft_rule_free(nlr);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete rule: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
-static void list_rule_cb(struct nl_object *obj, void *arg)
+void netlink_dump_rule(struct nft_rule *nlr)
 {
-	const struct nfnl_nft_rule *nlr = (struct nfnl_nft_rule *)obj;
-	struct netlink_ctx *ctx = arg;
-	struct rule *rule;
+#ifdef DEBUG
+	char buf[4096];
 
-	netlink_dump_object(obj);
-	if (!nfnl_nft_rule_test_family(nlr) ||
-	    !nfnl_nft_rule_test_table(nlr) ||
-	    !nfnl_nft_rule_test_chain(nlr) ||
-	    !nfnl_nft_rule_test_handle(nlr)) {
-		netlink_io_error(ctx, NULL, "Incomplete rule received");
+	if (!(debug_level & DEBUG_NETLINK))
 		return;
-	}
 
-	rule = netlink_delinearize_rule(ctx, obj);
-	list_add_tail(&rule->list, &ctx->list);
+	nft_rule_snprintf(buf, sizeof(buf), nlr, 0, 0);
+	fprintf(stderr, "%s\n", buf);
+#endif
 }
 
-static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
-			      const struct location *loc)
+void netlink_dump_expr(struct nft_rule_expr *nle)
 {
-	struct nl_cache *rule_cache;
-	struct nfnl_nft_rule *nlr;
-	int err;
+#ifdef DEBUG
+	char buf[4096];
 
-	err = nfnl_nft_rule_alloc_cache(nf_sock, &rule_cache);
-	if (err < 0)
-		return netlink_io_error(ctx, loc,
-					"Could not receive rules from kernel: %s",
-					nl_geterror(err));
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
 
-	nlr = alloc_nft_rule(h);
-	nl_cache_foreach_filter(rule_cache, OBJ_CAST(nlr), list_rule_cb, ctx);
-	nfnl_nft_rule_put(nlr);
-	nl_cache_free(rule_cache);
-	return 0;
+	nft_rule_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
+	fprintf(stderr, "%s\n", buf);
+#endif
 }
 
-static int netlink_get_rule_cb(struct nl_msg *msg, void *arg)
+static int list_rule_cb(struct nft_rule *nlr, void *arg)
 {
-	return nl_msg_parse(msg, list_rule_cb, arg);
+	struct netlink_ctx *ctx = arg;
+	const struct handle *h = ctx->data;
+	struct rule *rule;
+
+	if ((h->family != nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY)) ||
+	    strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE), h->table) != 0 ||
+	    (h->chain &&
+	     strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN), h->chain) != 0))
+		return 0;
+
+	netlink_dump_rule(nlr);
+	rule = netlink_delinearize_rule(ctx, nlr);
+	list_add_tail(&rule->list, &ctx->list);
+
+	return 0;
 }
 
-int netlink_get_rule(struct netlink_ctx *ctx, const struct handle *h,
-		     const struct location *loc)
+static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
+			      const struct location *loc)
 {
-	struct nfnl_nft_rule *nlr;
-	int err;
-
-	nlr = alloc_nft_rule(h);
-	netlink_set_callback(netlink_get_rule_cb, ctx);
-	err = nfnl_nft_rule_query(nf_sock, nlr, 0);
-	if (err == 0)
-		err = nl_recvmsgs_default(nf_sock);
-	nfnl_nft_rule_put(nlr);
+	struct nft_rule_list *rule_cache;
 
-	if (err < 0)
+	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
+	if (rule_cache == NULL)
 		return netlink_io_error(ctx, loc,
-					"Could not receive rule from kernel: %s",
-					nl_geterror(err));
-	return err;
+					"Could not receive rules from kernel: %s",
+					strerror(errno));
+
+	ctx->data = h;
+	nft_rule_list_foreach(rule_cache, list_rule_cb, ctx);
+	nft_rule_list_free(rule_cache);
+	return 0;
 }
 
-static void flush_rule_cb(struct nl_object *obj, void *arg)
+static int flush_rule_cb(struct nft_rule *nlr, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
 	int err;
 
-	netlink_dump_object(obj);
-	err = nfnl_nft_rule_delete(nf_sock, (struct nfnl_nft_rule *)obj, 0);
-	if (err < 0)
+	netlink_dump_rule(nlr);
+	err = mnl_nft_rule_delete(nf_sock, nlr, 0);
+	if (err < 0) {
 		netlink_io_error(ctx, NULL, "Could not delete rule: %s",
-				 nl_geterror(err));
+				 strerror(errno));
+		return err;
+	}
+	return 0;
 }
 
 static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
-	struct nl_cache *rule_cache;
-	struct nfnl_nft_rule *nlr;
-	int err;
+	struct nft_rule_list *rule_cache;
+	struct nft_rule *nlr;
 
-	err = nfnl_nft_rule_alloc_cache(nf_sock, &rule_cache);
-	if (err < 0)
+	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
+	if (rule_cache == NULL)
 		return netlink_io_error(ctx, loc,
 					"Could not receive rules from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 
 	nlr = alloc_nft_rule(h);
-	nl_cache_foreach_filter(rule_cache, OBJ_CAST(nlr), flush_rule_cb, ctx);
-	nfnl_nft_rule_put(nlr);
-	nl_cache_free(rule_cache);
+	nft_rule_list_foreach(rule_cache, flush_rule_cb, ctx);
+	nft_rule_free(nlr);
+	nft_rule_list_free(rule_cache);
 	return 0;
 }
 
+void netlink_dump_chain(struct nft_chain *nlc)
+{
+#ifdef DEBUG
+	char buf[4096];
+
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
+
+	nft_chain_snprintf(buf, sizeof(buf), nlc, 0, 0);
+	fprintf(stderr, "%s\n", buf);
+#endif
+}
+
 int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct chain *chain)
 {
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain *nlc;
 	int err;
 
 	nlc = alloc_nft_chain(h);
 	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
-		nfnl_nft_chain_set_hooknum(nlc, chain->hooknum);
-		nfnl_nft_chain_set_priority(nlc, chain->priority);
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
+				       chain->hooknum);
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
+				       chain->priority);
 	}
-	netlink_dump_object(OBJ_CAST(nlc));
-	err = nfnl_nft_chain_add(nf_sock, nlc, NLM_F_EXCL);
-	nfnl_nft_chain_put(nlc);
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_add(nf_sock, nlc, NLM_F_EXCL);
+	nft_chain_free(nlc);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not add chain: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
 int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc, const char *name)
 {
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain *nlc;
 	int err;
 
 	nlc = alloc_nft_chain(h);
-	nfnl_nft_chain_set_name(nlc, name, strlen(name) + 1);
-	netlink_dump_object(OBJ_CAST(nlc));
-	err = nfnl_nft_chain_add(nf_sock, nlc, 0);
-	nfnl_nft_chain_put(nlc);
+	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_add(nf_sock, nlc, 0);
+	nft_chain_free(nlc);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not rename chain: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
 int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain *nlc;
 	int err;
 
 	nlc = alloc_nft_chain(h);
-	netlink_dump_object(OBJ_CAST(nlc));
-	err = nfnl_nft_chain_delete(nf_sock, nlc, 0);
-	nfnl_nft_chain_put(nlc);
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
+	nft_chain_free(nlc);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete chain: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
-static void list_chain_cb(struct nl_object *obj, void *arg)
+static int list_chain_cb(struct nft_chain *nlc, void *arg)
 {
-	struct nfnl_nft_chain *nlc = (struct nfnl_nft_chain *)obj;
 	struct netlink_ctx *ctx = arg;
+	const struct handle *h = ctx->data;
 	struct chain *chain;
 
-	netlink_dump_object(obj);
-	if (!nfnl_nft_chain_test_family(nlc) ||
-	    !nfnl_nft_chain_test_table(nlc) ||
-	    !nfnl_nft_chain_test_name(nlc)) {
-		netlink_io_error(ctx, NULL, "Incomplete chain received");
-		return;
-	}
+	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
+	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE), h->table) != 0)
+		return 0;
 
-	chain = chain_alloc(nfnl_nft_chain_get_name(nlc));
-	chain->handle.family = nfnl_nft_chain_get_family(nlc);
-	chain->handle.table  = xstrdup(nfnl_nft_chain_get_table(nlc));
-	chain->handle.handle = nfnl_nft_chain_get_handle(nlc);
-	chain->hooknum       = nfnl_nft_chain_get_hooknum(nlc);
-	chain->priority      = nfnl_nft_chain_get_priority(nlc);
+	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+	chain->handle.family =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
+	chain->handle.table  =
+		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+	chain->handle.handle =
+		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
+	chain->hooknum       =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+	chain->priority      =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
 	list_add_tail(&chain->list, &ctx->list);
+
+	return 0;
 }
 
 int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
-	struct nl_cache *chain_cache;
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain_list *chain_cache;
 	struct chain *chain;
-	int err;
 
-	err = nfnl_nft_chain_alloc_cache(nf_sock, &chain_cache);
-	if (err < 0)
+	chain_cache = mnl_nft_chain_dump(nf_sock, h->family);
+	if (chain_cache == NULL)
 		return netlink_io_error(ctx, loc,
 					"Could not receive chains from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 
-	nlc = alloc_nft_chain(h);
-	nl_cache_foreach_filter(chain_cache, OBJ_CAST(nlc), list_chain_cb, ctx);
-	nfnl_nft_chain_put(nlc);
-	nl_cache_free(chain_cache);
+	ctx->data = h;
+	nft_chain_list_foreach(chain_cache, list_chain_cb, ctx);
+	nft_chain_list_free(chain_cache);
 
 	/* Caller wants all existing chains */
 	if (h->chain == NULL)
@@ -534,32 +536,33 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_io_error(ctx, NULL,
 				"Could not find chain `%s' in table `%s': %s",
 				h->chain, h->table,
-				nl_geterror(NLE_OBJ_NOTFOUND));
-}
-
-static int netlink_get_chain_cb(struct nl_msg *msg, void *arg)
-{
-	return nl_msg_parse(msg, list_chain_cb, arg);
+				strerror(ENOENT));
 }
 
 int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
-	struct nfnl_nft_chain *nlc;
+	struct nft_chain *nlc;
+	struct chain *chain;
 	int err;
 
 	nlc = alloc_nft_chain(h);
-	netlink_set_callback(netlink_get_chain_cb, ctx);
-	err = nfnl_nft_chain_query(nf_sock, nlc, 0);
-	if (err == 0)
-		err = nl_recvmsgs_default(nf_sock);
-	netlink_set_callback(NULL, NULL);
-	nfnl_nft_chain_put(nlc);
+	err = mnl_nft_chain_get(nf_sock, nlc, 0);
+
+	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+	chain->handle.family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
+	chain->handle.table  = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
+	chain->handle.handle = nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
+	chain->hooknum       = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+	chain->priority      = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+	list_add_tail(&chain->list, &ctx->list);
+
+	nft_chain_free(nlc);
 
 	if (err < 0)
 		return netlink_io_error(ctx, loc,
 					"Could not receive chain from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 	return err;
 }
 
@@ -578,96 +581,97 @@ int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct table *table)
 {
-	struct nfnl_nft_table *nlt;
+	struct nft_table *nlt;
 	int err;
 
 	nlt = alloc_nft_table(h);
-	err = nfnl_nft_table_add(nf_sock, nlt, NLM_F_EXCL);
-	nfnl_nft_table_put(nlt);
+	err = mnl_nft_table_add(nf_sock, nlt, NLM_F_EXCL);
+	nft_table_free(nlt);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not add table: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
 int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	struct nfnl_nft_table *nlt;
+	struct nft_table *nlt;
 	int err;
 
 	nlt = alloc_nft_table(h);
-	err = nfnl_nft_table_delete(nf_sock, nlt, 0);
-	nfnl_nft_table_put(nlt);
+	err = mnl_nft_table_delete(nf_sock, nlt, 0);
+	nft_table_free(nlt);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete table: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
-static void list_table_cb(struct nl_object *obj, void *arg)
+void netlink_dump_table(struct nft_table *nlt)
 {
-	struct nfnl_nft_table *nlt = (struct nfnl_nft_table *)obj;
-	struct netlink_ctx *ctx = arg;
-	struct table *table;
+#ifdef DEBUG
+	char buf[4096];
 
-	netlink_dump_object(obj);
-	if (!nfnl_nft_table_test_family(nlt) ||
-	    !nfnl_nft_table_test_name(nlt)) {
-		netlink_io_error(ctx, NULL, "Incomplete table received");
+	if (!(debug_level & DEBUG_NETLINK))
 		return;
-	}
 
+	nft_table_snprintf(buf, sizeof(buf), nlt, 0, 0);
+	fprintf(stderr, "%s\n", buf);
+#endif
+}
+
+static int list_table_cb(struct nft_table *nlt, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	struct table *table;
+
+	netlink_dump_table(nlt);
 	table = table_alloc();
-	table->handle.family = nfnl_nft_table_get_family(nlt);
-	table->handle.table  = xstrdup(nfnl_nft_table_get_name(nlt));
+	table->handle.family =
+		nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
+	table->handle.table  =
+		xstrdup(nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
 	list_add_tail(&table->list, &ctx->list);
+
+	return 0;
 }
 
 int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc)
 {
-	struct nl_cache *table_cache;
-	struct nfnl_nft_table *nlt;
-	int err;
+	struct nft_table_list *table_cache;
+	struct nft_table *nlt;
 
-	err = nfnl_nft_table_alloc_cache(nf_sock, &table_cache);
-	if (err < 0)
+	table_cache = mnl_nft_table_dump(nf_sock, h->family);
+	if (table_cache == NULL)
 		return netlink_io_error(ctx, loc,
 					"Could not receive tables from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 
 	nlt = alloc_nft_table(h);
-	nl_cache_foreach_filter(table_cache, OBJ_CAST(nlt), list_table_cb, ctx);
-	nfnl_nft_table_put(nlt);
-	nl_cache_free(table_cache);
+	nft_table_list_foreach(table_cache, list_table_cb, ctx);
+	nft_table_free(nlt);
+	nft_table_list_free(table_cache);
 	return 0;
 }
 
-static int netlink_get_table_cb(struct nl_msg *msg, void *arg)
-{
-	return nl_msg_parse(msg, list_table_cb, arg);
-}
-
 int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
-	struct nfnl_nft_table *nlt;
+	struct nft_table *nlt;
 	int err;
 
 	nlt = alloc_nft_table(h);
-	netlink_set_callback(netlink_get_table_cb, ctx);
-	err = nfnl_nft_table_query(nf_sock, nlt, 0);
-	if (err == 0)
-		err = nl_recvmsgs_default(nf_sock);
-	nfnl_nft_table_put(nlt);
+	err = mnl_nft_table_get(nf_sock, nlt, 0);
+	nft_table_free(nlt);
 
 	if (err < 0)
 		return netlink_io_error(ctx, loc,
 					"Could not receive table from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 	return err;
 }
 
@@ -704,268 +708,261 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	}
 }
 
-static void add_set_cb(struct nl_object *obj, void *arg)
+void netlink_dump_set(struct nft_set *nls)
 {
-	struct nfnl_nft_set *nls = (struct nfnl_nft_set *)obj;
-	struct netlink_ctx *ctx = arg;
-	struct set *set = ctx->set;
+#ifdef DEBUG
+	char buf[4096];
 
-	netlink_dump_object(OBJ_CAST(nls));
-	set->handle.set = xstrdup(nfnl_nft_set_get_name(nls));
-}
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
 
-static int netlink_add_set_cb(struct nl_msg *msg, void *arg)
-{
-	return nl_msg_parse(msg, add_set_cb, arg);
+	nft_set_snprintf(buf, sizeof(buf), nls, 0, 0);
+	fprintf(stderr, "%s\n", buf);
+#endif
 }
 
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		    struct set *set)
 {
-	struct nfnl_nft_set *nls;
+	struct nft_set *nls;
 	int err;
 
 	nls = alloc_nft_set(h);
-	nfnl_nft_set_set_flags(nls, set->flags);
-	nfnl_nft_set_set_keytype(nls, dtype_map_to_kernel(set->keytype));
-	nfnl_nft_set_set_keylen(nls, set->keylen / BITS_PER_BYTE);
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
+			     dtype_map_to_kernel(set->keytype));
+	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
+			     set->keylen / BITS_PER_BYTE);
 	if (set->flags & NFT_SET_MAP) {
-		nfnl_nft_set_set_datatype(nls, dtype_map_to_kernel(set->datatype));
-		nfnl_nft_set_set_datalen(nls, set->datalen / BITS_PER_BYTE);
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
+				     dtype_map_to_kernel(set->datatype));
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
+				     set->datalen / BITS_PER_BYTE);
 	}
-	netlink_dump_object(OBJ_CAST(nls));
-
-	ctx->set = set;
-	netlink_set_callback(netlink_add_set_cb, ctx);
-	err = nfnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
-	if (err == 0)
-		err = nl_recvmsgs_default(nf_sock);
-	netlink_set_callback(NULL, NULL);
-	nfnl_nft_set_put(nls);
-	ctx->set = NULL;
+	netlink_dump_set(nls);
 
+	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
 	if (err < 0)
 		netlink_io_error(ctx, NULL, "Could not add set: %s",
-				 nl_geterror(err));
+				 strerror(errno));
+
+	set->handle.set =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+	nft_set_free(nls);
+
 	return err;
 }
 
 int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
 {
-	struct nfnl_nft_set *nls;
+	struct nft_set *nls;
 	int err;
 
 	nls = alloc_nft_set(h);
-	err = nfnl_nft_set_delete(nf_sock, nls, 0);
-	nfnl_nft_set_put(nls);
+	err = mnl_nft_set_delete(nf_sock, nls, 0);
+	nft_set_free(nls);
 
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete set: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
-static void list_set_cb(struct nl_object *obj, void *arg)
+static int list_set_cb(struct nft_set *nls, void *arg)
 {
-	struct nfnl_nft_set *nls = (struct nfnl_nft_set *)obj;
 	struct netlink_ctx *ctx = arg;
 	const struct datatype *keytype, *datatype;
-	uint32_t flags;
+	uint32_t flags, key, data;
 	struct set *set;
 
-	netlink_dump_object(obj);
-	if (!nfnl_nft_set_test_family(nls) ||
-	    !nfnl_nft_set_test_table(nls) ||
-	    !nfnl_nft_set_test_name(nls) ||
-	    !nfnl_nft_set_test_keytype(nls) ||
-	    !nfnl_nft_set_test_keylen(nls)) {
-		netlink_io_error(ctx, NULL, "Incomplete set received");
-		return;
-	}
-
-	keytype = dtype_map_from_kernel(nfnl_nft_set_get_keytype(nls));
+	netlink_dump_set(nls);
+	key = nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE);
+	keytype = dtype_map_from_kernel(key);
 	if (keytype == NULL) {
 		netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
-				 nfnl_nft_set_get_keytype(nls));
-		return;
+				 key);
+		return -1;
 	}
 
-	flags = nfnl_nft_set_get_flags(nls);
+	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
 	if (flags & NFT_SET_MAP) {
-		datatype = dtype_map_from_kernel(nfnl_nft_set_get_datatype(nls));
+		data = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE);
+		datatype = dtype_map_from_kernel(data);
 		if (datatype == NULL) {
 			netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
-					 nfnl_nft_set_get_datatype(nls));
-			return;
+					 data);
+			return -1;
 		}
 	} else
 		datatype = NULL;
 
 	set = set_alloc(&internal_location);
-	set->handle.family = nfnl_nft_set_get_family(nls);
-	set->handle.table  = xstrdup(nfnl_nft_set_get_table(nls));
-	set->handle.set    = xstrdup(nfnl_nft_set_get_name(nls));
+	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	set->handle.table  =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
+	set->handle.set    =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
 	set->keytype       = keytype;
-	set->keylen        = nfnl_nft_set_get_keylen(nls) * BITS_PER_BYTE;
+	set->keylen        =
+		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
 	set->flags         = flags;
 	set->datatype      = datatype;
-	set->datalen       = nfnl_nft_set_get_datalen(nls) * BITS_PER_BYTE;
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
+		set->datalen =
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN) * BITS_PER_BYTE;
+	}
 	list_add_tail(&set->list, &ctx->list);
+
+	return 0;
 }
 
 int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
-	struct nl_cache *set_cache;
-	int err;
+	struct nft_set_list *set_cache;
 
-	err = nfnl_nft_set_alloc_cache(nf_sock, h->family, h->table, &set_cache);
-	if (err < 0)
+	set_cache = mnl_nft_set_dump(nf_sock, h->family, h->table);
+	if (set_cache == NULL)
 		return netlink_io_error(ctx, loc,
 					"Could not receive sets from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
 
-	nl_cache_foreach(set_cache, list_set_cb, ctx);
-	nl_cache_free(set_cache);
+	nft_set_list_foreach(set_cache, list_set_cb, ctx);
+	nft_set_list_free(set_cache);
 	return 0;
 }
 
-static int netlink_get_set_cb(struct nl_msg *msg, void *arg)
-{
-	return nl_msg_parse(msg, list_set_cb, arg);
-}
-
 int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 		    const struct location *loc)
 {
-	struct nfnl_nft_set *nls;
+	struct nft_set *nls;
+	struct set *set;
 	int err;
 
 	nls = alloc_nft_set(h);
-	netlink_dump_object(OBJ_CAST(nls));
-	netlink_set_callback(netlink_get_set_cb, ctx);
-	err = nfnl_nft_set_query(nf_sock, nls, 0);
-	if (err == 0)
-		err = nl_recvmsgs_default(nf_sock);
-	netlink_set_callback(NULL, NULL);
-
-	nfnl_nft_set_put(nls);
-
+	netlink_dump_set(nls);
+	err = mnl_nft_set_get(nf_sock, nls);
 	if (err < 0)
 		return netlink_io_error(ctx, loc,
 					"Could not receive set from kernel: %s",
-					nl_geterror(err));
+					strerror(errno));
+
+	set = set_alloc(&internal_location);
+	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	set->handle.table  =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
+	set->handle.set    =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+	set->keytype       =
+		 dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE));
+	set->keylen        =
+		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
+	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	set->datatype      =
+		dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE));
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
+		set->datalen =
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN) * BITS_PER_BYTE;
+	}
+	list_add_tail(&set->list, &ctx->list);
+	nft_set_free(nls);
+
 	return err;
 }
 
-static int alloc_setelem_cache(const struct expr *set, struct nl_cache **res)
+static void alloc_setelem_cache(const struct expr *set, struct nft_set *nls)
 {
-	struct nfnl_nft_setelem *nlse;
-	struct nl_cache *elements;
+	struct nft_set_elem *nlse;
 	const struct expr *expr;
-	int err;
 
-	err = nl_cache_alloc_name("netfilter/nft_setelem", &elements);
-	if (err < 0)
-		return err;
 	list_for_each_entry(expr, &set->expressions, list) {
 		nlse = alloc_nft_setelem(expr);
-		netlink_dump_object(OBJ_CAST(nlse));
-		nl_cache_add(elements, OBJ_CAST(nlse));
+		nft_set_elem_add(nls, nlse);
 	}
-	*res = elements;
-	return 0;
 }
 
 int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct expr *expr)
 {
-	struct nfnl_nft_set *nls;
-	struct nl_cache *elements;
+	struct nft_set *nls;
 	int err;
 
 	nls = alloc_nft_set(h);
-	netlink_dump_object(OBJ_CAST(nls));
+	alloc_setelem_cache(expr, nls);
+	netlink_dump_set(nls);
 
-	err = alloc_setelem_cache(expr, &elements);
-	if (err < 0)
-		goto out;
-	err = nfnl_nft_setelem_add(nf_sock, nls, elements, 0);
-	if (err < 0)
-		goto out;
-	err = nl_recvmsgs_default(nf_sock);
-out:
-	nfnl_nft_set_put(nls);
+	err = mnl_nft_setelem_add(nf_sock, nls, 0);
+	nft_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
 				 "Could not add set elements: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
 int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct expr *expr)
 {
-	struct nfnl_nft_set *nls;
-	struct nl_cache *elements;
+	struct nft_set *nls;
 	int err;
 
 	nls = alloc_nft_set(h);
-	err = alloc_setelem_cache(expr, &elements);
-	if (err < 0)
-		goto out;
-	err = nfnl_nft_setelem_delete(nf_sock, nls, elements, 0);
-	if (err < 0)
-		goto out;
-	err = nl_recvmsgs_default(nf_sock);
-out:
-	nfnl_nft_set_put(nls);
+	alloc_setelem_cache(expr, nls);
+	netlink_dump_set(nls);
+
+	err = mnl_nft_setelem_delete(nf_sock, nls, 0);
+	nft_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
 				 "Could not delete set elements: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
 
-static void list_setelem_cb(struct nl_object *obj, void *arg)
+static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
 {
-	struct nfnl_nft_setelem *nlse = nl_object_priv(obj);
-	struct nfnl_nft_data *nld;
+	struct nft_data_delinearize nld;
 	struct netlink_ctx *ctx = arg;
 	struct set *set = ctx->set;
 	struct expr *expr, *data;
-	uint32_t flags;
+	uint32_t flags = 0;
 
-	netlink_dump_object(obj);
-	if (!nfnl_nft_setelem_test_key(nlse)) {
-		netlink_io_error(ctx, NULL, "Incomplete set element received");
-		return;
-	}
+	nld.value =
+		nft_set_elem_attr_get(nlse, NFT_SET_ELEM_ATTR_KEY, &nld.len);
+	if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_FLAGS))
+		flags = nft_set_elem_attr_get_u32(nlse, NFT_SET_ELEM_ATTR_FLAGS);
 
-	nld   = nfnl_nft_setelem_get_key(nlse);
-	flags = nfnl_nft_setelem_get_flags(nlse);
-
-	expr = netlink_alloc_value(&internal_location, nld);
+	expr = netlink_alloc_value(&internal_location, &nld);
 	expr->dtype	= set->keytype;
 	expr->byteorder	= set->keytype->byteorder;
 	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
-	else if (nfnl_nft_setelem_test_data(nlse)) {
-		nld = nfnl_nft_setelem_get_data(nlse);
-
-		data = netlink_alloc_data(&internal_location, nld,
+	} else {
+		if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_DATA)) {
+			nld.value = nft_set_elem_attr_get(nlse, NFT_SET_ELEM_ATTR_DATA,
+							  &nld.len);
+		} else if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_CHAIN)) {
+			nld.chain = nft_set_elem_attr_get_str(nlse, NFT_SET_ELEM_ATTR_CHAIN);
+			nld.verdict = nft_set_elem_attr_get_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT);
+		} else if (nft_set_elem_attr_is_set(nlse, NFT_SET_ELEM_ATTR_VERDICT)) {
+			nld.verdict = nft_set_elem_attr_get_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT);
+		} else
+			goto out;
+
+		data = netlink_alloc_data(&internal_location, &nld,
 					  set->datatype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
 		data->dtype = set->datatype;
 
 		expr = mapping_expr_alloc(&internal_location, expr, data);
 	}
-
+out:
 	compound_expr_add(set->init, expr);
+	return 0;
 }
 
 extern void interval_map_decompose(struct expr *set);
@@ -973,32 +970,27 @@ extern void interval_map_decompose(struct expr *set);
 int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc, struct set *set)
 {
-	struct nl_cache *elements;
-	struct nfnl_nft_set *nls;
+	struct nft_set *nls;
 	int err;
 
 	nls = alloc_nft_set(h);
-	netlink_dump_object(OBJ_CAST(nls));
+	netlink_dump_set(nls);
 
-	err = nfnl_nft_setelem_alloc_cache(nf_sock, nls, &elements);
-	if (err < 0)
-		goto out;
-	err = nl_recvmsgs_default(nf_sock);
+	err = mnl_nft_setelem_get(nf_sock, nls);
 	if (err < 0)
 		goto out;
 
 	ctx->set = set;
 	set->init = set_expr_alloc(loc);
-	nl_cache_foreach(elements, list_setelem_cb, ctx);
-	nl_cache_free(elements);
+	nft_set_elem_foreach(nls, list_setelem_cb, ctx);
+	nft_set_free(nls);
 	ctx->set = NULL;
 
 	if (set->flags & NFT_SET_INTERVAL)
 		interval_map_decompose(set->init);
 out:
-	nfnl_nft_set_put(nls);
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not receive set elements: %s",
-				 nl_geterror(err));
+				 strerror(errno));
 	return err;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 50672b9..c24e105 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -8,6 +9,9 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
 #include <netlink.h>
@@ -69,14 +73,22 @@ static struct expr *netlink_get_register(struct netlink_parse_ctx *ctx,
 
 static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
-				    const struct nfnl_nft_expr *nle)
+				    const struct nft_rule_expr *nle)
 {
-	const struct nfnl_nft_data *data = nfnl_nft_immediate_get_data(nle);
-	enum nft_registers dreg = nfnl_nft_immediate_get_dreg(nle);
+	struct nft_data_delinearize nld;
+	enum nft_registers dreg;
 	struct stmt *stmt;
 	struct expr *expr;
 
-	expr = netlink_alloc_data(loc, data, dreg);
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_VERDICT))
+		nld.verdict = nft_rule_expr_get_u32(nle, NFT_EXPR_IMM_VERDICT); 
+	else if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_DATA)) {
+		nld.value = nft_rule_expr_get(nle, NFT_EXPR_IMM_DATA, &nld.len);
+	}
+
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_IMM_DREG);
+
+	expr = netlink_alloc_data(loc, &nld, dreg);
 	if (dreg == NFT_REG_VERDICT) {
 		stmt = verdict_stmt_alloc(loc, expr);
 		list_add_tail(&stmt->list, &ctx->rule->stmts);
@@ -84,9 +96,9 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 		netlink_set_register(ctx, dreg, expr);
 }
 
-static enum ops netlink_parse_cmp_op(const struct nfnl_nft_expr *nle)
+static enum ops netlink_parse_cmp_op(const struct nft_rule_expr *nle)
 {
-	switch (nfnl_nft_cmp_get_op(nle)) {
+	switch (nft_rule_expr_get_u8(nle, NFT_EXPR_CMP_OP)) {
 	case NFT_CMP_EQ:
 		return OP_EQ;
 	case NFT_CMP_NEQ:
@@ -106,21 +118,23 @@ static enum ops netlink_parse_cmp_op(const struct nfnl_nft_expr *nle)
 
 static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
-			      const struct nfnl_nft_expr *nle)
+			      const struct nft_rule_expr *nle)
 {
-	const struct nfnl_nft_data *data = nfnl_nft_cmp_get_data(nle);
+	struct nft_data_delinearize nld;
 	struct expr *expr, *left, *right;
 	struct stmt *stmt;
 	enum ops op;
 
-	left = netlink_get_register(ctx, loc, nfnl_nft_cmp_get_sreg(nle));
+	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
+	left = netlink_get_register(ctx, loc,
+			nft_rule_expr_get_u8(nle, NFT_EXPR_CMP_SREG));
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Relational expression has no left "
 				     "hand side");
 
 	op = netlink_parse_cmp_op(nle);
-	right = netlink_alloc_value(loc, data);
+	right = netlink_alloc_value(loc, &nld);
 
 	// FIXME
 	if (left->len && left->dtype && left->dtype->type != TYPE_STRING &&
@@ -135,28 +149,30 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 
 static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
-				 const struct nfnl_nft_expr *nle)
+				 const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
 	struct expr *expr, *left, *right;
 	struct set *set;
 	enum nft_registers dreg;
 
-	left = netlink_get_register(ctx, loc, nfnl_nft_lookup_get_sreg(nle));
+	left = netlink_get_register(ctx, loc,
+			nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_SREG));
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Lookup expression has no left hand side");
 
-	set = set_lookup(ctx->table, nfnl_nft_lookup_get_set(nle));
+	set = set_lookup(ctx->table,
+			 nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET));
 	if (set == NULL)
 		return netlink_error(ctx, loc,
 				     "Unknown set '%s' in lookup expression",
-				     nfnl_nft_lookup_get_set(nle));
+				     nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET));
 
 	right = set_ref_expr_alloc(loc, set);
 
-	if (nfnl_nft_lookup_test_dreg(nle)) {
-		dreg = nfnl_nft_lookup_get_dreg(nle);
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOOKUP_DREG)) {
+		dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_DREG);
 		expr = map_expr_alloc(loc, left, right);
 		if (dreg != NFT_REG_VERDICT)
 			return netlink_set_register(ctx, dreg, expr);
@@ -170,12 +186,14 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 
 static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
-				  const struct nfnl_nft_expr *nle)
+				  const struct nft_rule_expr *nle)
 {
 	struct expr *expr, *left, *mask, *xor, *or;
 	mpz_t m, x, o;
+	struct nft_data_delinearize nld;
 
-	left = netlink_get_register(ctx, loc, nfnl_nft_bitwise_get_sreg(nle));
+	left = netlink_get_register(ctx, loc,
+			nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_SREG));
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Bitwise expression has no left "
@@ -183,10 +201,14 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 
 	expr = left;
 
-	mask = netlink_alloc_value(loc, nfnl_nft_bitwise_get_mask(nle));
+	nld.value = nft_rule_expr_get(nle, NFT_EXPR_BITWISE_MASK, &nld.len);
+
+	mask = netlink_alloc_value(loc, &nld);
 	mpz_init_set(m, mask->value);
 
-	xor  = netlink_alloc_value(loc, nfnl_nft_bitwise_get_xor(nle));
+	nld.value = nft_rule_expr_get(nle, NFT_EXPR_BITWISE_XOR, &nld.len);
+
+	xor  = netlink_alloc_value(loc, &nld);
 	mpz_init_set(x, xor->value);
 
 	mpz_init_set_ui(o, 0);
@@ -215,7 +237,10 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 		expr_free(xor);
 
 	if (mpz_cmp_ui(o, 0)) {
-		or = netlink_alloc_value(loc, nfnl_nft_bitwise_get_xor(nle));
+		nld.value = nft_rule_expr_get(nle, NFT_EXPR_BITWISE_XOR,
+					      &nld.len);
+
+		or = netlink_alloc_value(loc, &nld);
 		mpz_set(or->value, o);
 		expr = binop_expr_alloc(loc, OP_OR, expr, or);
 		expr->len = left->len;
@@ -225,23 +250,26 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	mpz_clear(x);
 	mpz_clear(o);
 
-	netlink_set_register(ctx, nfnl_nft_bitwise_get_dreg(nle), expr);
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_DREG),
+			     expr);
 }
 
 static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
-				    const struct nfnl_nft_expr *nle)
+				    const struct nft_rule_expr *nle)
 {
 	struct expr *expr, *arg;
 	enum ops op;
 
-	arg = netlink_get_register(ctx, loc, nfnl_nft_byteorder_get_sreg(nle));
+	arg = netlink_get_register(ctx, loc,
+		nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_SREG));
 	if (arg == NULL)
 		return netlink_error(ctx, loc,
 				     "Byteorder expression has no left "
 				     "hand side");
 
-	switch (nfnl_nft_byteorder_get_op(nle)) {
+	switch (nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_OP)) {
 	case NFT_BYTEORDER_NTOH:
 		op = OP_NTOH;
 		break;
@@ -250,106 +278,120 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 		break;
 	default:
 		BUG("invalid byteorder operation %u\n",
-		    nfnl_nft_byteorder_get_op(nle));
+		    nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_OP));
 	}
 
 	expr = unary_expr_alloc(loc, op, arg);
 	expr->len = arg->len;
-	netlink_set_register(ctx, nfnl_nft_byteorder_get_dreg(nle), expr);
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_DREG),
+			     expr);
 }
 
 static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
-				  const struct nfnl_nft_expr *nle)
+				  const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
 	expr = payload_expr_alloc(loc, NULL, 0);
-	payload_init_raw(expr, nfnl_nft_payload_get_base(nle) + 1,
-			 nfnl_nft_payload_get_offset(nle) * BITS_PER_BYTE,
-			 nfnl_nft_payload_get_len(nle) * BITS_PER_BYTE);
+	payload_init_raw(expr, nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_BASE) + 1,
+			 nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE,
+			 nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE);
 
-	netlink_set_register(ctx, nfnl_nft_payload_get_dreg(nle), expr);
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_DREG),
+			     expr);
 }
 
 static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
-				 const struct nfnl_nft_expr *nle)
+				 const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
 	expr = exthdr_expr_alloc(loc, NULL, 0);
-	exthdr_init_raw(expr, nfnl_nft_exthdr_get_type(nle),
-			nfnl_nft_exthdr_get_offset(nle) * BITS_PER_BYTE,
-			nfnl_nft_exthdr_get_len(nle) * BITS_PER_BYTE);
+	exthdr_init_raw(expr, nft_rule_expr_get_u8(nle, NFT_EXPR_EXTHDR_TYPE),
+			nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE,
+			nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_LEN) * BITS_PER_BYTE);
 
-	netlink_set_register(ctx, nfnl_nft_exthdr_get_dreg(nle), expr);
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_DREG),
+			     expr);
 }
 
 static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
 			       const struct location *loc,
-			       const struct nfnl_nft_expr *nle)
+			       const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
-	expr = meta_expr_alloc(loc, nfnl_nft_meta_get_key(nle));
-	netlink_set_register(ctx, nfnl_nft_meta_get_dreg(nle), expr);
+	expr = meta_expr_alloc(loc,
+			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY));
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u8(nle, NFT_EXPR_META_DREG),
+			     expr);
 }
 
 static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 			     const struct location *loc,
-			     const struct nfnl_nft_expr *nle)
+			     const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
-	expr = ct_expr_alloc(loc, nfnl_nft_ct_get_key(nle));
-	netlink_set_register(ctx, nfnl_nft_ct_get_dreg(nle), expr);
+	expr = ct_expr_alloc(loc, nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY));
+	netlink_set_register(ctx,
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_CT_DREG),
+			     expr);
 }
 
 static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
-				  const struct nfnl_nft_expr *nle)
+				  const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
 
 	stmt = counter_stmt_alloc(loc);
-	stmt->counter.packets = nfnl_nft_counter_get_packets(nle);
-	stmt->counter.bytes   = nfnl_nft_counter_get_bytes(nle);
+	stmt->counter.packets =
+		nft_rule_expr_get_u64(nle, NFT_EXPR_CTR_PACKETS);
+	stmt->counter.bytes   =
+		nft_rule_expr_get_u64(nle, NFT_EXPR_CTR_BYTES);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
 static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
-			      const struct nfnl_nft_expr *nle)
+			      const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
 	const char *prefix;
 
 	stmt = log_stmt_alloc(loc);
-	prefix = nfnl_nft_log_get_prefix(nle);
+	prefix = nft_rule_expr_get_str(nle, NFT_EXPR_LOG_PREFIX);
 	if (prefix != NULL)
 		stmt->log.prefix = xstrdup(prefix);
-	stmt->log.group	     = nfnl_nft_log_get_group(nle);
-	stmt->log.snaplen    = nfnl_nft_log_get_snaplen(nle);
-	stmt->log.qthreshold = nfnl_nft_log_get_qthreshold(nle);
+	stmt->log.group = nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_GROUP);
+	stmt->log.snaplen = nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_SNAPLEN);
+	stmt->log.qthreshold =
+		nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_QTHRESHOLD);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
 static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 				const struct location *loc,
-				const struct nfnl_nft_expr *nle)
+				const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
 
 	stmt = limit_stmt_alloc(loc);
-	stmt->limit.rate  = nfnl_nft_limit_get_rate(nle);
-	stmt->limit.depth = nfnl_nft_limit_get_depth(nle);
+	stmt->limit.rate  = nft_rule_expr_get_u32(nle, NFT_EXPR_LIMIT_RATE);
+	stmt->limit.depth  = nft_rule_expr_get_u32(nle, NFT_EXPR_LIMIT_DEPTH);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
 static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
-				 const struct nfnl_nft_expr *expr)
+				 const struct nft_rule_expr *expr)
 {
 	struct stmt *stmt;
 
@@ -359,16 +401,16 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 
 static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
-			      const struct nfnl_nft_expr *nle)
+			      const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
 	struct expr *addr, *proto;
 	enum nft_registers reg1, reg2;
 
 	stmt = nat_stmt_alloc(loc);
-	stmt->nat.type = nfnl_nft_nat_get_type(nle);
+	stmt->nat.type = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_TYPE);
 
-	reg1 = nfnl_nft_nat_get_sreg_addr_min(nle);
+	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
 		addr = netlink_get_register(ctx, loc, reg1);
 		if (addr == NULL)
@@ -380,7 +422,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
-	reg2 = nfnl_nft_nat_get_sreg_addr_max(nle);
+	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MAX);
 	if (reg2 && reg2 != reg1) {
 		addr = netlink_get_register(ctx, loc, reg2);
 		if (addr == NULL)
@@ -394,7 +436,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
-	reg1 = nfnl_nft_nat_get_sreg_proto_min(nle);
+	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN);
 	if (reg1) {
 		proto = netlink_get_register(ctx, loc, reg1);
 		if (proto == NULL)
@@ -406,7 +448,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.proto = proto;
 	}
 
-	reg2 = nfnl_nft_nat_get_sreg_proto_max(nle);
+	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_PROTO_MAX);
 	if (reg2 && reg2 != reg1) {
 		proto = netlink_get_register(ctx, loc, reg2);
 		if (proto == NULL)
@@ -427,7 +469,7 @@ static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
-				 const struct nfnl_nft_expr *nle);
+				 const struct nft_rule_expr *nle);
 } netlink_parsers[] = {
 	{ .name = "immediate",	.parse = netlink_parse_immediate },
 	{ .name = "cmp",	.parse = netlink_parse_cmp },
@@ -450,25 +492,26 @@ static const struct input_descriptor indesc_netlink = {
 	.type  = INDESC_NETLINK,
 };
 
-static void netlink_parse_expr(struct nl_object *obj, void *arg)
+static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
 {
-	const struct nfnl_nft_expr *nle = (struct nfnl_nft_expr *)obj;
-	const char *type = nfnl_nft_expr_get_type(nle);
+	const char *type = nft_rule_expr_get_str(nle, NFT_RULE_EXPR_ATTR_NAME);
 	struct netlink_parse_ctx *ctx = arg;
 	struct location loc;
 	unsigned int i;
 
 	memset(&loc, 0, sizeof(loc));
 	loc.indesc = &indesc_netlink;
-	loc.nl_obj = obj;
+	loc.nle = nle;
 
 	for (i = 0; i < array_size(netlink_parsers); i++) {
 		if (strcmp(type, netlink_parsers[i].name))
 			continue;
-		return netlink_parsers[i].parse(ctx, &loc, nle);
+		netlink_parsers[i].parse(ctx, &loc, nle);
+		return 0;
 	}
 
 	netlink_error(ctx, &loc, "unknown expression type '%s'", type);
+	return 0;
 }
 
 struct rule_pp_ctx {
@@ -697,9 +740,8 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 }
 
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
-				      const struct nl_object *obj)
+				      const struct nft_rule *nlr)
 {
-	const struct nfnl_nft_rule *nlr = (const struct nfnl_nft_rule *)obj;
 	struct netlink_parse_ctx _ctx, *pctx = &_ctx;
 	struct handle h;
 
@@ -707,15 +749,15 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	_ctx.msgs = ctx->msgs;
 
 	memset(&h, 0, sizeof(h));
-	h.family = nfnl_nft_rule_get_family(nlr);
-	h.table  = xstrdup(nfnl_nft_rule_get_table(nlr));
-	h.chain  = xstrdup(nfnl_nft_rule_get_chain(nlr));
-	h.handle = nfnl_nft_rule_get_handle(nlr);
+	h.family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+	h.table  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE));
+	h.chain  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN));
+	h.handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
 
 	pctx->rule = rule_alloc(&internal_location, &h);
 	pctx->table = table_lookup(&h);
 	assert(pctx->table != NULL);
-	nfnl_nft_rule_foreach_expr(nlr, netlink_parse_expr, pctx);
+	nft_rule_expr_foreach((struct nft_rule *)nlr, netlink_parse_expr, pctx);
 
 	rule_parse_postprocess(pctx, pctx->rule);
 	return pctx->rule;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index accab9c..9929f4a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -10,6 +11,7 @@
 
 #include <linux/netfilter/nf_tables.h>
 
+#include <string.h>
 #include <rule.h>
 #include <statement.h>
 #include <expression.h>
@@ -18,7 +20,7 @@
 #include <utils.h>
 
 struct netlink_linearize_ctx {
-	struct nfnl_nft_rule	*nlr;
+	struct nft_rule		*nlr;
 	unsigned int		reg_low;
 };
 
@@ -52,59 +54,65 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
-
-	nle = alloc_nft_expr(nfnl_nft_payload_init);
-	nfnl_nft_payload_set_dreg(nle, dreg);
-	nfnl_nft_payload_set_base(nle, expr->payload.base - 1);
-	nfnl_nft_payload_set_offset(nle, expr->payload.offset / BITS_PER_BYTE);
-	nfnl_nft_payload_set_len(nle, expr->len / BITS_PER_BYTE);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("payload");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_BASE,
+			      expr->payload.base - 1);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_OFFSET,
+			      expr->payload.offset / BITS_PER_BYTE);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_LEN,
+			      expr->len / BITS_PER_BYTE);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
-
-	nle = alloc_nft_expr(nfnl_nft_exthdr_init);
-	nfnl_nft_exthdr_set_dreg(nle, dreg);
-	nfnl_nft_exthdr_set_type(nle, expr->exthdr.desc->type);
-	nfnl_nft_exthdr_set_offset(nle, expr->exthdr.tmpl->offset / BITS_PER_BYTE);
-	nfnl_nft_exthdr_set_len(nle, expr->len / BITS_PER_BYTE);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("exthdr");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_EXTHDR_DREG, dreg);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_EXTHDR_TYPE,
+			     expr->exthdr.desc->type);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_EXTHDR_OFFSET,
+			      expr->exthdr.tmpl->offset / BITS_PER_BYTE);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_EXTHDR_LEN,
+			      expr->len / BITS_PER_BYTE);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr,
 			     enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
-	nle = alloc_nft_expr(nfnl_nft_meta_init);
-	nfnl_nft_meta_set_dreg(nle, dreg);
-	nfnl_nft_meta_set_key(nle, expr->meta.key);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("meta");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_META_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_META_KEY, expr->meta.key);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 			   const struct expr *expr,
 			   enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
-	nle = alloc_nft_expr(nfnl_nft_ct_init);
-	nfnl_nft_ct_set_dreg(nle, dreg);
-	nfnl_nft_ct_set_key(nle, expr->ct.key);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("ct");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_KEY, expr->ct.key);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
 
 	assert(expr->mappings->ops->type == EXPR_SET_REF);
@@ -116,22 +124,23 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 
 	netlink_gen_expr(ctx, expr->map, sreg);
 
-	nle = alloc_nft_expr(nfnl_nft_lookup_init);
-	nfnl_nft_lookup_set_sreg(nle, sreg);
-	nfnl_nft_lookup_set_dreg(nle, dreg);
-	nfnl_nft_lookup_set_set(nle, expr->mappings->set->handle.set);
+	nle = alloc_nft_expr("lookup");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_DREG, dreg);
+	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
+			      expr->mappings->set->handle.set);
 
 	if (dreg == NFT_REG_VERDICT)
 		release_register(ctx);
 
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
 
 	assert(expr->right->ops->type == EXPR_SET_REF);
@@ -140,12 +149,13 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
-	nle = alloc_nft_expr(nfnl_nft_lookup_init);
-	nfnl_nft_lookup_set_sreg(nle, sreg);
-	nfnl_nft_lookup_set_set(nle, expr->right->set->handle.set);
+	nle = alloc_nft_expr("lookup");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SREG, sreg);
+	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
+			      expr->right->set->handle.set);
 
 	release_register(ctx);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static enum nft_cmp_ops netlink_gen_cmp_op(enum ops op)
@@ -172,21 +182,24 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
+	struct nft_data_linearize nld;
 
 	assert(dreg == NFT_REG_VERDICT);
 
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
-	nle = alloc_nft_expr(nfnl_nft_cmp_init);
-	nfnl_nft_cmp_set_sreg(nle, sreg);
-	nfnl_nft_cmp_set_op(nle, netlink_gen_cmp_op(expr->op));
-	nfnl_nft_cmp_set_data(nle, netlink_gen_data(expr->right));
+	nle = alloc_nft_expr("cmp");
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP,
+			      netlink_gen_cmp_op(expr->op));
+	netlink_gen_data(expr->right, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	release_register(ctx);
 
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
@@ -194,25 +207,30 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 			      enum nft_registers dreg)
 {
 	struct expr *range = expr->right;
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
+	struct nft_data_linearize nld;
 
 	assert(dreg == NFT_REG_VERDICT);
 
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
-	nle = alloc_nft_expr(nfnl_nft_cmp_init);
-	nfnl_nft_cmp_set_sreg(nle, sreg);
-	nfnl_nft_cmp_set_op(nle, netlink_gen_cmp_op(OP_GTE));
-	nfnl_nft_cmp_set_data(nle, netlink_gen_data(range->left));
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
-
-	nle = alloc_nft_expr(nfnl_nft_cmp_init);
-	nfnl_nft_cmp_set_sreg(nle, sreg);
-	nfnl_nft_cmp_set_op(nle, netlink_gen_cmp_op(OP_LTE));
-	nfnl_nft_cmp_set_data(nle, netlink_gen_data(range->right));
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("cmp");
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+			      netlink_gen_cmp_op(OP_GTE));
+	netlink_gen_data(range->left, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
+	nft_rule_add_expr(ctx->nlr, nle);
+
+	nle = alloc_nft_expr("cmp");
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+			      netlink_gen_cmp_op(OP_LTE));
+	netlink_gen_data(range->right, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
+	nft_rule_add_expr(ctx->nlr, nle);
 
 	release_register(ctx);
 }
@@ -221,8 +239,8 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
-	struct nfnl_nft_data *nld;
+	struct nft_rule_expr *nle;
+	struct nft_data_linearize nld, nld2;
 	enum nft_registers sreg;
 	unsigned int len;
 	mpz_t zero;
@@ -235,21 +253,23 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	mpz_init_set_ui(zero, 0);
 
-	nle = alloc_nft_expr(nfnl_nft_bitwise_init);
-	nld = netlink_gen_raw_data(zero, expr->right->byteorder, len);
-	nfnl_nft_bitwise_set_sreg(nle, sreg);
-	nfnl_nft_bitwise_set_dreg(nle, sreg);
-	nfnl_nft_bitwise_set_len(nle, len);
-	nfnl_nft_bitwise_set_mask(nle, netlink_gen_data(expr->right));
-	nfnl_nft_bitwise_set_xor(nle, nld);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
-
-	nle = alloc_nft_expr(nfnl_nft_cmp_init);
-	nld = netlink_gen_raw_data(zero, expr->right->byteorder, len);
-	nfnl_nft_cmp_set_sreg(nle, sreg);
-	nfnl_nft_cmp_set_op(nle, NFT_CMP_NEQ);
-	nfnl_nft_cmp_set_data(nle, nld);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("bitwise");
+	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
+	netlink_gen_data(expr->right, &nld2);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &nld.value, nld.len);
+	nft_rule_add_expr(ctx->nlr, nle);
+
+	nle = alloc_nft_expr("cmp");
+	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
+	netlink_gen_data(expr->right, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
+	nft_rule_add_expr(ctx->nlr, nle);
 
 	mpz_clear(zero);
 	release_register(ctx);
@@ -291,8 +311,8 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
-	struct nfnl_nft_data *nld;
+	struct nft_rule_expr *nle;
+	struct nft_data_linearize nld;
 	struct expr *left, *i;
 	struct expr *binops[16];
 	mpz_t mask, xor, val, tmp;
@@ -337,23 +357,22 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 
 	len = div_round_up(expr->len, BITS_PER_BYTE);
 
-	nle = alloc_nft_expr(nfnl_nft_bitwise_init);
-	nfnl_nft_bitwise_set_sreg(nle, dreg);
-	nfnl_nft_bitwise_set_dreg(nle, dreg);
-	nfnl_nft_bitwise_set_len(nle, len);
-
-	nld = netlink_gen_raw_data(mask, expr->byteorder, len);
-	nfnl_nft_bitwise_set_mask(nle, nld);
+	nle = alloc_nft_expr("bitwise");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
 
-	nld = netlink_gen_raw_data(xor, expr->byteorder, len);
-	nfnl_nft_bitwise_set_xor(nle, nld);
+	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, nld.value, nld.len);
+	netlink_gen_raw_data(xor, expr->byteorder, len, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, nld.value, nld.len);
 
 	mpz_clear(tmp);
 	mpz_clear(val);
 	mpz_clear(xor);
 	mpz_clear(mask);
 
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static enum nft_byteorder_ops netlink_gen_unary_op(enum ops op)
@@ -372,29 +391,47 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
 	netlink_gen_expr(ctx, expr->arg, dreg);
 
-	nle = alloc_nft_expr(nfnl_nft_byteorder_init);
-	nfnl_nft_byteorder_set_sreg(nle, dreg);
-	nfnl_nft_byteorder_set_dreg(nle, dreg);
-	nfnl_nft_byteorder_set_len(nle, expr->len / BITS_PER_BYTE);
-	nfnl_nft_byteorder_set_size(nle, expr->arg->len % 32 ? 2 : 4);
-	nfnl_nft_byteorder_set_op(nle, netlink_gen_unary_op(expr->op));
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("byteorder");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_SREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_LEN,
+			      expr->len / BITS_PER_BYTE);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_SIZE,
+			      expr->arg->len % 32 ? 2 : 4);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_OP,
+			      netlink_gen_unary_op(expr->op));
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 				  const struct expr *expr,
 				  enum nft_registers dreg)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
+	struct nft_data_linearize nld;
 
-	nle = alloc_nft_expr(nfnl_nft_immediate_init);
-	nfnl_nft_immediate_set_dreg(nle, dreg);
-	nfnl_nft_immediate_set_data(nle, netlink_gen_data(expr));
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("immediate");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_IMM_DREG, dreg);
+	netlink_gen_data(expr, &nld);
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		nft_rule_expr_set(nle, NFT_EXPR_IMM_DATA, nld.value, nld.len);
+		break;
+	case EXPR_VERDICT:
+		if (nft_rule_expr_is_set(nle, NFT_EXPR_IMM_CHAIN)) {
+			nft_rule_expr_set_str(nle, NFT_EXPR_IMM_CHAIN,
+					      nld.chain);
+		}
+		nft_rule_expr_set_u32(nle, NFT_EXPR_IMM_VERDICT, nld.verdict);
+		break;
+	default:
+		break;
+	}
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
@@ -437,77 +474,91 @@ static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 				     const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
-
-	nle = alloc_nft_expr(nfnl_nft_counter_init);
-	if (stmt->counter.packets)
-		nfnl_nft_counter_set_packets(nle, stmt->counter.packets);
-	if (stmt->counter.bytes)
-		nfnl_nft_counter_set_bytes(nle, stmt->counter.bytes);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("counter");
+	if (stmt->counter.packets) {
+		nft_rule_expr_set_u64(nle, NFT_EXPR_CTR_PACKETS,
+				      stmt->counter.packets);
+	}
+	if (stmt->counter.bytes) {
+		nft_rule_expr_set_u64(nle, NFT_EXPR_CTR_BYTES,
+				      stmt->counter.packets);
+	}
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
 
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, stmt->meta.expr, sreg);
 	release_register(ctx);
 
-	nle = alloc_nft_expr(nfnl_nft_meta_init);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("meta");
+	/* XXX nothing here ? */
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
-
-	nle = alloc_nft_expr(nfnl_nft_log_init);
-	if (stmt->log.prefix != NULL)
-		nfnl_nft_log_set_prefix(nle, stmt->log.prefix);
-	if (stmt->log.group)
-		nfnl_nft_log_set_group(nle, stmt->log.group);
-	if (stmt->log.snaplen)
-		nfnl_nft_log_set_snaplen(nle, stmt->log.snaplen);
-	if (stmt->log.qthreshold)
-		nfnl_nft_log_set_qthreshold(nle, stmt->log.qthreshold);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("log");
+	if (stmt->log.prefix != NULL) {
+		nft_rule_expr_set_str(nle, NFT_EXPR_LOG_PREFIX,
+				      stmt->log.prefix);
+	}
+	if (stmt->log.group) {
+		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_GROUP,
+				      stmt->log.group);
+	}
+	if (stmt->log.snaplen) {
+		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_SNAPLEN,
+				      stmt->log.snaplen);
+	}
+	if (stmt->log.qthreshold) {
+		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_QTHRESHOLD,
+				      stmt->log.qthreshold);
+	}
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 				   const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
-	nle = alloc_nft_expr(nfnl_nft_limit_init);
-	nfnl_nft_limit_set_rate(nle, stmt->limit.rate);
-	nfnl_nft_limit_set_depth(nle, stmt->limit.depth);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nle = alloc_nft_expr("limit");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_LIMIT_RATE, stmt->limit.rate);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_LIMIT_DEPTH, stmt->limit.depth);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 				    const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr(NULL);
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	/* XXX nothing here? */
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
-	struct nfnl_nft_expr *nle;
+	struct nft_rule_expr *nle;
 	enum nft_registers amin_reg, amax_reg;
 	enum nft_registers pmin_reg, pmax_reg;
 	int registers = 0;
 
-	nle = alloc_nft_expr(nfnl_nft_nat_init);
-	nfnl_nft_nat_set_type(nle, stmt->nat.type);
+	nle = alloc_nft_expr("nat");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_TYPE, stmt->nat.type);
 
 	if (stmt->nat.addr) {
 		amin_reg = get_register(ctx);
@@ -519,11 +570,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 
 			netlink_gen_expr(ctx, stmt->nat.addr->left, amin_reg);
 			netlink_gen_expr(ctx, stmt->nat.addr->right, amax_reg);
-			nfnl_nft_nat_set_sreg_addr_min(nle, amin_reg);
-			nfnl_nft_nat_set_sreg_addr_max(nle, amax_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
+					      amin_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MAX,
+					      amax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.addr, amin_reg);
-			nfnl_nft_nat_set_sreg_addr_min(nle, amin_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
+					      amin_reg);
 		}
 
 	}
@@ -538,11 +592,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 
 			netlink_gen_expr(ctx, stmt->nat.proto->left, pmin_reg);
 			netlink_gen_expr(ctx, stmt->nat.proto->right, pmax_reg);
-			nfnl_nft_nat_set_sreg_proto_min(nle, pmin_reg);
-			nfnl_nft_nat_set_sreg_proto_max(nle, pmax_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
+					      pmin_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MAX,
+					      pmax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.proto, pmin_reg);
-			nfnl_nft_nat_set_sreg_proto_min(nle, pmin_reg);
+			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
+					      pmin_reg);
 		}
 	}
 
@@ -551,7 +608,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		registers--;
 	}
 
-	nfnl_nft_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx->nlr, nle);
 }
 
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
@@ -579,7 +636,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-int netlink_linearize_rule(struct netlink_ctx *ctx, struct nfnl_nft_rule *nlr,
+int netlink_linearize_rule(struct netlink_ctx *ctx, struct nft_rule *nlr,
 			   const struct rule *rule)
 {
 	struct netlink_linearize_ctx lctx;
@@ -592,6 +649,6 @@ int netlink_linearize_rule(struct netlink_ctx *ctx, struct nfnl_nft_rule *nlr,
 	list_for_each_entry(stmt, &rule->stmts, list)
 		netlink_gen_stmt(&lctx, stmt);
 
-	netlink_dump_object(OBJ_CAST(nlr));
+	netlink_dump_rule(nlr);
 	return 0;
 }
-- 
1.7.10.4

