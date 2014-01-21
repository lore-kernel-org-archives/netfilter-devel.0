From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH] src: add import operation
Date: Tue, 21 Jan 2014 18:02:11 +0100
Message-ID: <20140121170211.31038.31659.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46317 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665AbaAURCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:02:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The import operation reads XML/JSON data from stdin.

A basic way to test is:
 % nft export json | nft import json

This operation flush the kernel ruleset before adding the one imported.

Adding data from a file:
 % cat file.json | nft import json
 % nft import json < file.json

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/mnl.h     |   23 ++++
 include/netlink.h |   12 ++
 include/rule.h    |    2 
 src/evaluate.c    |    1 
 src/mnl.c         |  278 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c     |  195 +++++++++++++++++++++++++++++++++++++
 src/parser.y      |   21 +++-
 src/rule.c        |   50 ++++++++++
 src/scanner.l     |    1 
 9 files changed, 579 insertions(+), 4 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index f4de27d..bbb5b6f 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -23,6 +23,7 @@ void mnl_batch_end(void);
 int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list);
 int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
+int mnl_nft_rule_list_add(struct nft_rule_list *nlrl, unsigned int flags);
 int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
 
@@ -35,8 +36,13 @@ struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
+int mnl_nft_chain_list_add(struct mnl_socket *nf_sock,
+			   struct nft_chain_list *nlcl,
+			   unsigned int flags);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
                          unsigned int flags);
+int mnl_nft_chain_list_delete(struct mnl_socket *nfsock,
+			      struct nft_chain_list *nlcl, unsigned int flags);
 struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					  int family);
 int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
@@ -44,8 +50,13 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
+int mnl_nft_table_list_add(struct mnl_socket *nf_sock,
+			   struct nft_table_list *nltl,
+			   unsigned int flags);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
+int mnl_nft_table_list_delete(struct mnl_socket *nfsock,
+			      struct nft_table_list *nltl, unsigned int flags);
 struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					  int family);
 int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
@@ -53,18 +64,30 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 		    unsigned int flags);
+int mnl_nft_set_list_add(struct mnl_socket *nf_sock,
+			 struct nft_set_list *nlsl,
+			 unsigned int flags);
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 		       unsigned int flags);
+int mnl_nft_set_list_delete(struct mnl_socket *nfsock,
+			    struct nft_set_list *nlsl, unsigned int flags);
 struct nft_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
 				      const char *table);
 int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			unsigned int flags);
+int mnl_nft_set_elem_list_add(struct mnl_socket *nf_sock,
+			      struct nft_set_list *nlsl,
+			      unsigned int flags);
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 struct nft_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
+int mnl_nft_ruleset_add(struct mnl_socket *nf_sock, struct nft_ruleset *rs,
+			unsigned int tflags, unsigned int cflags,
+			unsigned int rflags, unsigned int sflags,
+			unsigned int seflags);
 #endif /* _NFTABLES_MNL_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index cfd8462..92982d7 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -139,4 +139,16 @@ extern int netlink_io_error(struct netlink_ctx *ctx,
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
+extern int netlink_flush_ruleset(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc);
+extern int netlink_delete_ruleset(struct netlink_ctx *ctx,
+				  const struct handle *h,
+				  const struct location *loc);
+extern int netlink_wipe_ruleset(struct netlink_ctx *ctx,
+				const struct handle *h,
+				const struct location *loc);
+extern int netlink_add_ruleset(struct netlink_ctx *ctx,
+			       const struct location *loc,
+			       struct nft_ruleset *rs);
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index 886aadc..0905ff1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -205,6 +205,7 @@ extern void set_print(const struct set *set);
  * @CMD_FLUSH:		flush container
  * @CMD_RENAME:		rename object
  * @CMD_EXPORT:		export the ruleset in a given format
+ * @CMD_IMPORT:		import a ruleset in a given format
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -215,6 +216,7 @@ enum cmd_ops {
 	CMD_FLUSH,
 	CMD_RENAME,
 	CMD_EXPORT,
+	CMD_IMPORT,
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 2c26d03..279c752 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1392,6 +1392,7 @@ static int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
+	case CMD_IMPORT:
 		return 0;
 	default:
 		BUG("invalid command operation %u\n", cmd->op);
diff --git a/src/mnl.c b/src/mnl.c
index 30e9cc6..6a0b977 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -291,6 +291,29 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 	return 0;
 }
 
+int mnl_nft_rule_list_add(struct nft_rule_list *nlrl, unsigned int flags)
+{
+	int ret = 0;
+	struct nft_rule_list_iter *i;
+	struct nft_rule *r;
+
+	i = nft_rule_list_iter_create(nlrl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	r = nft_rule_list_iter_next(i);
+	while (r != NULL) {
+		ret = mnl_nft_rule_batch_add(r, flags, mnl_seqnum_alloc());
+		if (ret != 0)
+			return ret;
+
+		r = nft_rule_list_iter_next(i);
+	}
+	nft_rule_list_iter_destroy(i);
+
+	return ret;
+}
+
 int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			   uint32_t seqnum)
 {
@@ -402,6 +425,32 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_chain_list_add(struct mnl_socket *nf_sock,
+			   struct nft_chain_list *nlcl,
+			   unsigned int flags)
+{
+	int ret = 0;
+	struct nft_chain_list_iter *i;
+	struct nft_chain *c;
+
+	i = nft_chain_list_iter_create(nlcl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	c = nft_chain_list_iter_next(i);
+	while (c != NULL) {
+		ret = mnl_nft_chain_add(nf_sock, c, flags);
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
+
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			 unsigned int flags)
 {
@@ -416,6 +465,31 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_chain_list_delete(struct mnl_socket *nfsock,
+			      struct nft_chain_list *nlcl, unsigned int flags)
+{
+	struct nft_chain_list_iter *i;
+	struct nft_chain *c;
+	int ret = 0;
+
+	i = nft_chain_list_iter_create(nlcl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	c = nft_chain_list_iter_next(i);
+	while (c != NULL) {
+		ret = mnl_nft_chain_delete(nfsock, c, flags);
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
+
 static int chain_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_chain_list *nlc_list = data;
@@ -497,6 +571,32 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_table_list_add(struct mnl_socket *nf_sock,
+			   struct nft_table_list *nltl,
+			   unsigned int flags)
+{
+	int ret = 0;
+	struct nft_table_list_iter *i;
+	struct nft_table *t;
+
+	i = nft_table_list_iter_create(nltl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	t = nft_table_list_iter_next(i);
+	while (t != NULL) {
+		ret = mnl_nft_table_add(nf_sock, t, flags);
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
+
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags)
 {
@@ -511,6 +611,31 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_table_list_delete(struct mnl_socket *nfsock,
+			      struct nft_table_list *nltl, unsigned int flags)
+{
+	struct nft_table_list_iter *i;
+	struct nft_table *t;
+	int ret = 0;
+
+	i = nft_table_list_iter_create(nltl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	t = nft_table_list_iter_next(i);
+	while (t != NULL) {
+		ret = mnl_nft_table_delete(nfsock, t, flags);
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
+
 static int table_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_table_list *nlt_list = data;
@@ -598,6 +723,32 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
 }
 
+int mnl_nft_set_list_add(struct mnl_socket *nf_sock,
+			 struct nft_set_list *nlsl,
+			 unsigned int flags)
+{
+	int ret = 0;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = mnl_nft_set_add(nf_sock, s, flags);
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
+
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 		       unsigned int flags)
 {
@@ -612,6 +763,31 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_set_list_delete(struct mnl_socket *nfsock,
+			    struct nft_set_list *nlsl, unsigned int flags)
+{
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+	int ret = 0;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = mnl_nft_set_delete(nfsock, s, flags);
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
+
 static int set_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_set_list *nls_list = data;
@@ -704,6 +880,32 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_set_elem_list_add(struct mnl_socket *nf_sock,
+			      struct nft_set_list *nlsl,
+			      unsigned int flags)
+{
+	int ret = 0;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+
+	i = nft_set_list_iter_create(nlsl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = mnl_nft_setelem_add(nf_sock, s, flags);
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
+
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags)
 {
@@ -795,3 +997,79 @@ out:
 	nft_ruleset_free(rs);
 	return NULL;
 }
+
+int mnl_nft_ruleset_add(struct mnl_socket *nf_sock, struct nft_ruleset *rs,
+			unsigned int tflags, unsigned int cflags,
+			unsigned int rflags, unsigned int sflags,
+			unsigned int seflags)
+{
+	int ret = 0;
+	struct nft_table_list *t;
+	struct nft_chain_list *c;
+	struct nft_set_list *s;
+	struct nft_rule_list *r;
+
+#ifdef DEBUG
+	if (debug_level & DEBUG_NETLINK)
+		fprintf(stdout, "mnl_nft_ruleset_add()\n");
+#endif
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST)) {
+		t = (struct nft_table_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_TABLELIST);
+		ret = mnl_nft_table_list_add(nf_sock, t, tflags);
+		if (ret != 0)
+			return ret;
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK)
+			fprintf(stdout, "mnl_nft_ruleset_add() tables OK\n");
+#endif
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) {
+		c = (struct nft_chain_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_CHAINLIST);
+		ret = mnl_nft_chain_list_add(nf_sock, c, cflags);
+		if (ret != 0)
+			return ret;
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK)
+			fprintf(stdout, "mnl_nft_ruleset_add() chains OK\n");
+#endif
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST)) {
+		s = (struct nft_set_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_SETLIST);
+		ret = mnl_nft_set_list_add(nf_sock, s, sflags);
+		if (ret != 0)
+			return ret;
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK)
+			fprintf(stdout, "mnl_nft_ruleset_add() sets OK\n");
+#endif
+
+		ret = mnl_nft_set_elem_list_add(nf_sock, s, seflags);
+		if (ret != 0)
+			return ret;
+
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK)
+			fprintf(stdout, "mnl_nft_ruleset_add() set_elems OK\n");
+#endif
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)) {
+		r = (struct nft_rule_list *)
+		     nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_RULELIST);
+		ret = mnl_nft_rule_list_add(r, rflags);
+		if (ret != 0)
+			return ret;
+#ifdef DEBUG
+		if (debug_level & DEBUG_NETLINK)
+			fprintf(stdout, "mnl_nft_ruleset_add() rules OK\n");
+#endif
+	}
+
+	return ret;
+}
diff --git a/src/netlink.c b/src/netlink.c
index e3bfc37..d9306ce 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -16,6 +16,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
+#include <libnftnl/ruleset.h>
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
@@ -1065,3 +1066,197 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 
 	return rs;
 }
+
+int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			  const struct location *loc)
+{
+	struct table *table;
+
+	if (netlink_list_tables(ctx, h, loc) < 0)
+		return -1;
+
+	list_for_each_entry(table, &ctx->list, list) {
+		if (netlink_flush_table(ctx, &table->handle, loc) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static void filter_sets(struct nft_set_list *sl, uint32_t flags)
+{
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+
+	i = nft_set_list_iter_create(sl);
+	if (i == NULL)
+		memory_allocation_error();
+
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		if (nft_set_attr_get_u32(s, NFT_SET_ATTR_FLAGS) & flags) {
+			nft_set_list_del(s);
+			nft_set_free(s);
+		}
+		s = nft_set_list_iter_next(i);
+	}
+	nft_set_list_iter_destroy(i);
+}
+
+int netlink_delete_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct location *loc)
+{
+	struct nft_chain_list *chain_cache;
+	struct nft_set_list *set_cache;
+	struct nft_table_list *table_cache;
+
+	chain_cache = mnl_nft_chain_dump(nf_sock, h->family);
+	if (chain_cache == NULL)
+		return netlink_io_error(ctx, loc,
+					"Could not receive chains from kernel:"
+					" %s", strerror(errno));
+
+	if (mnl_nft_chain_list_delete(nf_sock, chain_cache, 0) < 0) {
+		nft_chain_list_free(chain_cache);
+		return netlink_io_error(ctx, loc,
+					"Could not delete chain:"
+					" %s", strerror(errno));
+	}
+
+	nft_chain_list_free(chain_cache);
+
+	set_cache = mnl_nft_set_dump(nf_sock, h->family, NULL);
+	if (set_cache == NULL)
+		return netlink_io_error(ctx, loc,
+					"Could not receive sets from kernel:"
+					" %s", strerror(errno));
+
+	/*sleep(1);*/
+
+	/* don't delete ANONYMOUS sets: kernel does it */
+	filter_sets(set_cache, NFT_SET_ANONYMOUS);
+
+	if (mnl_nft_set_list_delete(nf_sock, set_cache, 0) < 0) {
+		nft_set_list_free(set_cache);
+		return netlink_io_error(ctx, loc,
+					"Could not delete set:"
+					" %s", strerror(errno));
+	}
+	nft_set_list_free(set_cache);
+
+	table_cache = mnl_nft_table_dump(nf_sock, h->family);
+	if (table_cache == NULL)
+		return netlink_io_error(ctx, loc,
+					"Could not receive tables from kernel:"
+					" %s", strerror(errno));
+	if (mnl_nft_table_list_delete(nf_sock, table_cache, 0) < 0) {
+		nft_table_list_free(table_cache);
+		return netlink_io_error(ctx, loc,
+					"Could not delete table:"
+					" %s", strerror(errno));
+	}
+	nft_table_list_free(table_cache);
+
+	return 0;
+}
+
+int netlink_wipe_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc)
+{
+	LIST_HEAD(err_list);
+
+	/* Batch is expected to start at src/main.c:nft_netlink() */
+
+	if (netlink_flush_ruleset(ctx, h, loc) < 0)
+		return -1;
+
+	/* commit the transaction now, otherwise
+	 * netlink_delete_ruleset() cannot be handled.
+	 */
+	mnl_batch_end();
+	if (netlink_batch_send(&err_list) < 0)
+		return -1;
+
+	mnl_batch_reset();
+
+	if (netlink_delete_ruleset(ctx, h, loc) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void ruleset_setup(struct nft_ruleset *rs)
+{
+	struct nft_chain *c;
+	struct nft_chain_list *cl;
+	struct nft_chain_list_iter *ci;
+	struct nft_rule_list *rl;
+	struct nft_rule *r;
+	struct nft_rule_list_iter *ri;
+	struct nft_rule_list *reverse_rule_list;
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST)) {
+		cl = (struct nft_chain_list *)
+		      nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_CHAINLIST);
+		ci = nft_chain_list_iter_create(cl);
+		if (ci == NULL)
+			memory_allocation_error();
+
+		c = nft_chain_list_iter_next(ci);
+		while (c != NULL) {
+			nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
+			c = nft_chain_list_iter_next(ci);
+		}
+		nft_chain_list_iter_destroy(ci);
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST)) {
+		reverse_rule_list = nft_rule_list_alloc();
+		if (reverse_rule_list == NULL)
+			memory_allocation_error();
+
+		rl = (struct nft_rule_list *)
+		      nft_ruleset_attr_get(rs, NFT_RULESET_ATTR_RULELIST);
+
+		ri = nft_rule_list_iter_create(rl);
+		if (ri == NULL)
+			memory_allocation_error();
+
+		r = nft_rule_list_iter_next(ri);
+		while (r != NULL) {
+			nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
+			nft_rule_attr_unset(r, NFT_RULE_ATTR_POSITION);
+			nft_rule_list_del(r);
+			nft_rule_list_add(r, reverse_rule_list);
+			r = nft_rule_list_iter_next(ri);
+		}
+		nft_rule_list_iter_destroy(ri);
+
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST,
+				     reverse_rule_list);
+	}
+}
+
+int netlink_add_ruleset(struct netlink_ctx *ctx, const struct location *loc,
+			struct nft_ruleset *rs)
+{
+	int ret;
+
+	mnl_batch_init();
+	mnl_batch_begin();
+
+	/* We need some makeup:
+	 * - unset chain handles
+	 * - unset rule handles and positions
+	 * - reverse the rule list
+	 */
+	ruleset_setup(rs);
+
+	ret = mnl_nft_ruleset_add(nf_sock, rs, 0, 0, NLM_F_EXCL | NLM_F_ECHO,
+				  0, 0);
+	if (ret != 0)
+		return netlink_io_error(ctx, loc,
+					"Could not add ruleset:"
+					" %s", strerror(errno));
+	return ret;
+}
diff --git a/src/parser.y b/src/parser.y
index bb8e4d7..3d94635 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -175,6 +175,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RENAME			"rename"
 %token DESCRIBE			"describe"
 %token EXPORT			"export"
+%token IMPORT			"import"
 
 %token ACCEPT			"accept"
 %token DROP			"drop"
@@ -346,8 +347,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd
+%type <cmd>			base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd import_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd import_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
@@ -467,8 +468,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format
-
+%type <val>			export_format import_format
 %%
 
 input			:	/* empty */
@@ -537,6 +537,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
+			|	IMPORT		import_cmd	{ $$ = $2; }
 			|	DESCRIBE	primary_expr
 			{
 				expr_describe($2);
@@ -679,6 +680,15 @@ export_cmd		:	export_format
 			}
 			;
 
+
+import_cmd		:	import_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_RULESET, &h, &@$, NULL);
+				$$->format = $1;
+			}
+			;
+
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
@@ -1843,6 +1853,9 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+import_format		:	export_format
+			;
+
 export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
 			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
 			;
diff --git a/src/rule.c b/src/rule.c
index f83f545..7a426f0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -19,6 +19,7 @@
 #include <rule.h>
 #include <utils.h>
 #include <netlink.h>
+#include <mnl.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -602,6 +603,53 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct nft_ruleset *rs;
+	struct nft_parse_err *err;
+
+	rs = nft_ruleset_alloc();
+	if (rs == NULL)
+		memory_allocation_error();
+
+	err = nft_parse_err_alloc();
+	if (err == NULL)
+		memory_allocation_error();
+
+	if (nft_ruleset_parse_file(rs, cmd->format, stdin, err) < 0) {
+		nft_parse_perror("Unable to parse file", err);
+		goto err;
+	}
+
+#ifdef DEBUG
+	if (debug_level & DEBUG_NETLINK)
+		fprintf(stdout, "Ruleset parsing OK.\n");
+#endif
+
+	if (netlink_wipe_ruleset(ctx, &cmd->handle, &cmd->location) < 0)
+		goto err;
+#ifdef DEBUG
+	if (debug_level & DEBUG_NETLINK)
+		fprintf(stdout, "Kernel ruleset wipe OK.\n");
+#endif
+
+	if (netlink_add_ruleset(ctx, &cmd->location, rs) < 0)
+		goto err;
+
+#ifdef DEBUG
+	if (debug_level & DEBUG_NETLINK)
+		fprintf(stdout, "New ruleset added to kernel (without rules).\n");
+#endif
+
+	nft_ruleset_free(rs);
+	nft_parse_err_free(err);
+	return 0;
+err:
+	nft_ruleset_free(rs);
+	nft_parse_err_free(err);
+	return -1;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -754,6 +802,8 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_rename(ctx, cmd);
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
+	case CMD_IMPORT:
+		return do_command_import(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 69f238d..5f74916 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -254,6 +254,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "export"		{ return EXPORT; }
+"import"		{ return IMPORT; }
 
 "position"		{ return POSITION; }
 

