From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables 3/3] iptables: nft: add tables and chains to the batch
Date: Tue, 10 Jun 2014 11:30:39 +0200
Message-ID: <1402392639-8071-3-git-send-email-pablo@netfilter.org>
References: <1402392639-8071-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49679 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaFJJav (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:30:51 -0400
In-Reply-To: <1402392639-8071-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since kernel changes:

55dd6f9 ("netfilter: nf_tables: use new transaction infrastructure
to handle table").
91c7b38 ("netfilter: nf_tables: use new transaction infrastructure
to handle chain").

it is possible to put tables and chains in the same batch (which was
already including rules). This patch probes the kernel to check if
if the new transaction is available, otherwise it falls back to the
previous non-transactional approach to handle these two objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |  367 +++++++++++++++++++++++++++++++++++++-------------------
 iptables/nft.h |    5 +-
 2 files changed, 249 insertions(+), 123 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 884462c..2a5f0b9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -42,6 +42,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/set.h>
 
 #include <netinet/in.h>	/* inet_ntoa */
 #include <arpa/inet.h>
@@ -269,6 +270,67 @@ static void mnl_nft_batch_end(struct mnl_nlmsg_batch *batch, uint32_t seq)
 	mnl_nft_batch_put(batch, NFNL_MSG_BATCH_END, seq);
 }
 
+enum obj_update_type {
+	NFT_COMPAT_TABLE_ADD,
+	NFT_COMPAT_CHAIN_ADD,
+	NFT_COMPAT_CHAIN_UPDATE,
+	NFT_COMPAT_RULE_APPEND,
+	NFT_COMPAT_RULE_INSERT,
+	NFT_COMPAT_RULE_REPLACE,
+	NFT_COMPAT_RULE_DELETE,
+	NFT_COMPAT_RULE_FLUSH,
+};
+
+enum obj_action {
+	NFT_COMPAT_COMMIT,
+	NFT_COMPAT_ABORT,
+};
+
+struct obj_update {
+	struct list_head	head;
+	enum obj_update_type	type;
+	union {
+		struct nft_table	*table;
+		struct nft_chain	*chain;
+		struct nft_rule		*rule;
+		void			*ptr;
+	};
+};
+
+static int batch_add(struct nft_handle *h, enum obj_update_type type, void *ptr)
+{
+	struct obj_update *obj;
+
+	obj = calloc(1, sizeof(struct obj_update));
+	if (obj == NULL)
+		return -1;
+
+	obj->ptr = ptr;
+	obj->type = type;
+	list_add_tail(&obj->head, &h->obj_list);
+	h->obj_list_num++;
+
+	return 0;
+}
+
+static int batch_table_add(struct nft_handle *h, enum obj_update_type type,
+			   struct nft_table *t)
+{
+	return batch_add(h, type, t);
+}
+
+static int batch_chain_add(struct nft_handle *h, enum obj_update_type type,
+			   struct nft_chain *c)
+{
+	return batch_add(h, type, c);
+}
+
+static int batch_rule_add(struct nft_handle *h, enum obj_update_type type,
+			  struct nft_rule *r)
+{
+	return batch_add(h, type, r);
+}
+
 struct builtin_table xtables_ipv4[TABLES_MAX] = {
 	[RAW] = {
 		.name	= "raw",
@@ -427,25 +489,14 @@ struct builtin_table xtables_arp[TABLES_MAX] = {
 	},
 };
 
-static int nft_table_builtin_add(struct nft_handle *h,
-				 struct builtin_table *_t)
+int nft_table_add(struct nft_handle *h, struct nft_table *t, uint16_t flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_table *t;
 	int ret;
 
-	if (_t->initialized)
-		return 0;
-
-	t = nft_table_alloc();
-	if (t == NULL)
-		return -1;
-
-	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, (char *)_t->name);
-
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
-					NLM_F_ACK|NLM_F_EXCL, h->seq);
+					NLM_F_ACK|flags, h->seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
 
@@ -458,7 +509,31 @@ static int nft_table_builtin_add(struct nft_handle *h,
 #endif
 
 	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret == 0 || errno == EEXIST)
+
+	return (ret == 0 || (ret == -1 && errno == EEXIST)) ? 0 : -1;
+}
+
+static int nft_table_builtin_add(struct nft_handle *h,
+				 struct builtin_table *_t)
+{
+	struct nft_table *t;
+	int ret;
+
+	if (_t->initialized)
+		return 0;
+
+	t = nft_table_alloc();
+	if (t == NULL)
+		return -1;
+
+	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, (char *)_t->name);
+
+	if (h->batch_support)
+		ret = batch_table_add(h, NFT_COMPAT_TABLE_ADD, t);
+	else
+		ret = nft_table_add(h, t, NLM_F_EXCL);
+
+	if (ret == 0)
 		_t->initialized = true;
 
 	return ret;
@@ -484,26 +559,42 @@ nft_chain_builtin_alloc(struct builtin_table *table,
 	return c;
 }
 
-void
-nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
-		      struct builtin_chain *chain, int policy)
+int nft_chain_add(struct nft_handle *h, struct nft_chain *c, uint16_t flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_chain *c;
-
-	c = nft_chain_builtin_alloc(table, chain, policy);
-	if (c == NULL)
-		return;
 
 	/* NLM_F_CREATE requests module autoloading */
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
-					NLM_F_ACK|NLM_F_EXCL|NLM_F_CREATE,
+					NLM_F_ACK|flags|NLM_F_CREATE,
 					h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 	nft_chain_free(c);
 
-	mnl_talk(h, nlh, NULL, NULL);
+#ifdef NLDEBUG
+	char tmp[1024];
+
+	nft_chain_snprintf(tmp, sizeof(tmp), c, 0, 0);
+	printf("DEBUG: chain: %s\n", tmp);
+	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
+#endif
+
+	return mnl_talk(h, nlh, NULL, NULL);
+}
+
+void nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
+			   struct builtin_chain *chain, int policy)
+{
+	struct nft_chain *c;
+
+	c = nft_chain_builtin_alloc(table, chain, policy);
+	if (c == NULL)
+		return;
+
+	if (h->batch_support)
+		batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
+	else
+		nft_chain_add(h, c, NLM_F_EXCL);
 }
 
 /* find if built-in table already exists */
@@ -595,6 +686,49 @@ static bool nft_chain_builtin(struct nft_chain *c)
 	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
 }
 
+static bool mnl_batch_supported(struct nft_handle *h)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = 1;
+	int ret;
+
+	mnl_nft_batch_begin(h->batch, seq++);
+
+	nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(h->batch),
+				NFT_MSG_NEWSET, AF_INET,
+				NLM_F_ACK, seq++);
+	mnl_nlmsg_batch_next(h->batch);
+
+	mnl_nft_batch_end(h->batch, seq++);
+
+	ret = mnl_socket_sendto(h->nl, mnl_nlmsg_batch_head(h->batch),
+				mnl_nlmsg_batch_size(h->batch));
+	if (ret < 0)
+		goto err;
+
+	mnl_nlmsg_batch_reset(h->batch);
+
+	ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(h->nl),
+				 NULL, NULL);
+		if (ret <= 0)
+			break;
+
+		ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	}
+
+	/* We're sending an incomplete message to see if the kernel supports
+	 * set messages in batches. EINVAL means that we sent an incomplete
+	 * message with missing attributes. The kernel just ignores messages
+	 * that we cannot include in the batch.
+	 */
+	return (ret == -1 && errno == EINVAL) ? true : false;
+err:
+	mnl_nlmsg_batch_reset(h->batch);
+	return ret;
+}
+
 int nft_init(struct nft_handle *h, struct builtin_table *t)
 {
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
@@ -613,6 +747,7 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	INIT_LIST_HEAD(&h->obj_list);
 
 	h->batch = mnl_nft_batch_alloc();
+	h->batch_support = mnl_batch_supported(h);
 
 	return 0;
 }
@@ -624,30 +759,6 @@ void nft_fini(struct nft_handle *h)
 	mnl_nlmsg_batch_stop(h->batch);
 }
 
-int nft_table_add(struct nft_handle *h, const struct nft_table *t)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
-					NLM_F_ACK|NLM_F_EXCL, h->seq);
-	nft_table_nlmsg_build_payload(nlh, t);
-
-	return mnl_talk(h, nlh, NULL, NULL);
-}
-
-int nft_chain_add(struct nft_handle *h, const struct nft_chain *c)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
-					NLM_F_ACK|NLM_F_EXCL, h->seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-
-	return mnl_talk(h, nlh, NULL, NULL);
-}
-
 static void nft_chain_print_debug(struct nft_chain *c, struct nlmsghdr *nlh)
 {
 #ifdef NLDEBUG
@@ -659,13 +770,11 @@ static void nft_chain_print_debug(struct nft_chain *c, struct nlmsghdr *nlh)
 #endif
 }
 
-static int
-__nft_chain_set(struct nft_handle *h, const char *table,
-		const char *chain, int policy,
-		const struct xt_counters *counters)
+static struct nft_chain *nft_chain_new(struct nft_handle *h,
+				       const char *table, const char *chain,
+				       int policy,
+				       const struct xt_counters *counters)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nft_chain *c;
 	struct builtin_table *_t;
 	struct builtin_chain *_c;
@@ -680,10 +789,10 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 		/* This is a built-in chain */
 		c = nft_chain_builtin_alloc(_t, _c, policy);
 		if (c == NULL)
-			return -1;
+			return NULL;
 	} else {
 		errno = ENOENT;
-		return -1;
+		return NULL;
 	}
 
 	if (counters) {
@@ -693,30 +802,30 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 					counters->pcnt);
 	}
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
-					h->restore ? NLM_F_ACK|NLM_F_CREATE :
-					NLM_F_ACK, h->seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-
-	nft_chain_print_debug(c, nlh);
-
-	nft_chain_free(c);
-
-	return mnl_talk(h, nlh, NULL, NULL);
+	return c;
 }
 
 int nft_chain_set(struct nft_handle *h, const char *table,
 		  const char *chain, const char *policy,
 		  const struct xt_counters *counters)
 {
-	int ret = -1;
+	struct nft_chain *c = NULL;
+	int ret;
 
 	nft_fn = nft_chain_set;
 
 	if (strcmp(policy, "DROP") == 0)
-		ret = __nft_chain_set(h, table, chain, NF_DROP, counters);
+		c = nft_chain_new(h, table, chain, NF_DROP, counters);
 	else if (strcmp(policy, "ACCEPT") == 0)
-		ret = __nft_chain_set(h, table, chain, NF_ACCEPT, counters);
+		c = nft_chain_new(h, table, chain, NF_ACCEPT, counters);
+
+	if (c == NULL)
+		return 0;
+
+	if (h->batch_support)
+		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_UPDATE, c);
+	else
+		ret = nft_chain_add(h, c, 0);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -901,39 +1010,6 @@ err:
 	return NULL;
 }
 
-enum obj_update_type {
-	NFT_COMPAT_RULE_APPEND,
-	NFT_COMPAT_RULE_INSERT,
-	NFT_COMPAT_RULE_REPLACE,
-	NFT_COMPAT_RULE_DELETE,
-	NFT_COMPAT_RULE_FLUSH,
-	NFT_COMPAT_COMMIT,
-	NFT_COMPAT_ABORT,
-};
-
-struct obj_update {
-       struct list_head		head;
-       enum obj_update_type	type;
-       struct nft_rule		*rule;
-};
-
-static int batch_rule_add(struct nft_handle *h, enum obj_update_type type,
-			  struct nft_rule *r)
-{
-	struct obj_update *obj;
-
-	obj = calloc(1, sizeof(struct obj_update));
-	if (obj == NULL)
-		return -1;
-
-	obj->rule = r;
-	obj->type = type;
-	list_add_tail(&obj->head, &h->obj_list);
-	h->obj_list_num++;
-
-	return 0;
-}
-
 int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 		void *data, uint64_t handle, bool verbose)
@@ -2129,45 +2205,94 @@ error:
 	return ret;
 }
 
+static void nft_compat_table_batch_add(struct nft_handle *h, uint16_t type,
+				       uint16_t flags, uint32_t seq,
+				       struct nft_table *table)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(h->batch),
+					type, h->family, flags, seq);
+	nft_table_nlmsg_build_payload(nlh, table);
+	nft_table_free(table);
+}
+
+static void nft_compat_chain_batch_add(struct nft_handle *h, uint16_t type,
+				       uint16_t flags, uint32_t seq,
+				       struct nft_chain *chain)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(h->batch),
+					type, h->family, flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, chain);
+	nft_chain_print_debug(chain, nlh);
+	nft_chain_free(chain);
+}
+
+static void nft_compat_rule_batch_add(struct nft_handle *h, uint16_t type,
+				      uint16_t flags, uint32_t seq,
+				      struct nft_rule *rule)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(h->batch),
+				       type, h->family, flags, seq);
+	nft_rule_nlmsg_build_payload(nlh, rule);
+	nft_rule_print_debug(rule, nlh);
+	nft_rule_free(rule);
+}
+
 static int nft_action(struct nft_handle *h, int action)
 {
-	int flags = NLM_F_CREATE, type;
 	struct obj_update *n, *tmp;
-	struct nlmsghdr *nlh;
 	uint32_t seq = 1;
-	int ret;
+	int ret = 0;
 
 	mnl_nft_batch_begin(h->batch, seq++);
 
 	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
 		switch (n->type) {
+		case NFT_COMPAT_TABLE_ADD:
+			nft_compat_table_batch_add(h, NFT_MSG_NEWTABLE,
+						   NLM_F_CREATE, seq++,
+						   n->table);
+			break;
+		case NFT_COMPAT_CHAIN_ADD:
+			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN,
+						   NLM_F_CREATE, seq++,
+						   n->chain);
+			break;
+		case NFT_COMPAT_CHAIN_UPDATE:
+			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN,
+						   h->restore ?
+						     NLM_F_CREATE : 0,
+						   seq++, n->chain);
+			break;
 		case NFT_COMPAT_RULE_APPEND:
-			type = NFT_MSG_NEWRULE;
-			flags |= NLM_F_APPEND;
+			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
+						  NLM_F_CREATE | NLM_F_APPEND,
+						  seq++, n->rule);
 			break;
 		case NFT_COMPAT_RULE_INSERT:
-			type = NFT_MSG_NEWRULE;
+			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
+						  NLM_F_CREATE, seq++,
+						  n->rule);
 			break;
 		case NFT_COMPAT_RULE_REPLACE:
-			type = NFT_MSG_NEWRULE;
-			flags |= NLM_F_REPLACE;
+			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
+						  NLM_F_CREATE | NLM_F_REPLACE,
+						  seq++, n->rule);
 			break;
 		case NFT_COMPAT_RULE_DELETE:
 		case NFT_COMPAT_RULE_FLUSH:
-			type = NFT_MSG_DELRULE;
+			nft_compat_rule_batch_add(h, NFT_MSG_DELRULE, 0,
+						  seq++, n->rule);
 			break;
-		default:
-			return 0;
 		}
 
-		nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(h->batch),
-					       type, h->family, flags, seq++);
-		nft_rule_nlmsg_build_payload(nlh, n->rule);
-		nft_rule_print_debug(n->rule, nlh);
-
 		h->obj_list_num--;
 		list_del(&n->head);
-		nft_rule_free(n->rule);
 		free(n);
 
 		if (!mnl_nlmsg_batch_next(h->batch))
@@ -2364,7 +2489,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 
 		found = true;
 
-		if (nft_table_add(h, table) < 0) {
+		if (batch_table_add(h, NFT_COMPAT_TABLE_ADD, table) < 0) {
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
 					"table `%s' already exists, skipping\n",
@@ -2395,7 +2520,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 		if (h->family != chain_family)
 			continue;
 
-		if (nft_chain_add(h, chain) < 0) {
+		if (batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, chain) < 0) {
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
 					"chain `%s' already exists in table `%s', skipping\n",
diff --git a/iptables/nft.h b/iptables/nft.h
index 1e78edd..339d7bc 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -36,6 +36,7 @@ struct nft_handle {
 	struct nft_family_ops	*ops;
 	struct builtin_table	*tables;
 	bool			restore;
+	bool			batch_support;
 };
 
 extern struct builtin_table xtables_ipv4[TABLES_MAX];
@@ -54,7 +55,7 @@ struct nft_table;
 struct nft_chain_list;
 
 struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
-int nft_table_add(struct nft_handle *h, const struct nft_table *t);
+int nft_table_add(struct nft_handle *h, struct nft_table *t, uint16_t flags);
 int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, const char *tablename, bool counters), bool counters);
 bool nft_table_find(struct nft_handle *h, const char *tablename);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nft_chain_list *list);
@@ -68,7 +69,7 @@ struct nft_chain *nft_chain_builtin_alloc(struct builtin_table *table, struct bu
 void nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table, struct builtin_chain *chain, int policy);
 struct builtin_chain *nft_chain_builtin_find(struct builtin_table *t, const char *chain);
 int nft_chain_builtin_init(struct nft_handle *h, const char *table, const char *chain, int policy);
-int nft_chain_add(struct nft_handle *h, const struct nft_chain *c);
+int nft_chain_add(struct nft_handle *h, struct nft_chain *c, uint16_t flags);
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 struct nft_chain_list *nft_chain_dump(struct nft_handle *h);
 struct nft_chain *nft_chain_list_find(struct nft_chain_list *list, const char *table, const char *chain);
-- 
1.7.10.4

