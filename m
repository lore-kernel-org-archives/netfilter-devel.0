From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables 1/3] iptables: nft: generalize batch infrastructure
Date: Tue, 10 Jun 2014 11:30:37 +0200
Message-ID: <1402392639-8071-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49664 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaFJJar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:30:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare inclusion of tables and chain objects in the batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   82 ++++++++++++++++++++++++++++----------------------------
 iptables/nft.h |    4 +--
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f3ec526..919b64d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -615,7 +615,7 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
 
-	INIT_LIST_HEAD(&h->rule_list);
+	INIT_LIST_HEAD(&h->obj_list);
 
 	h->batch = mnl_nft_batch_alloc();
 
@@ -949,37 +949,37 @@ err:
 	return NULL;
 }
 
-enum rule_update_type {
-       NFT_DO_APPEND,
-       NFT_DO_INSERT,
-       NFT_DO_REPLACE,
-       NFT_DO_DELETE,
-       NFT_DO_FLUSH,
-       NFT_DO_COMMIT,
-       NFT_DO_ABORT,
+enum obj_update_type {
+	NFT_COMPAT_RULE_APPEND,
+	NFT_COMPAT_RULE_INSERT,
+	NFT_COMPAT_RULE_REPLACE,
+	NFT_COMPAT_RULE_DELETE,
+	NFT_COMPAT_RULE_FLUSH,
+	NFT_COMPAT_COMMIT,
+	NFT_COMPAT_ABORT,
 };
 
-struct rule_update {
-       struct list_head        head;
-       enum rule_update_type   type;
-       struct nft_rule	       *rule;
+struct obj_update {
+       struct list_head		head;
+       enum obj_update_type	type;
+       struct nft_rule		*rule;
 };
 
-static int rule_update_add(struct nft_handle *h, enum rule_update_type type,
+static int batch_rule_add(struct nft_handle *h, enum obj_update_type type,
 			  struct nft_rule *r)
 {
-       struct rule_update *rupd;
+	struct obj_update *obj;
 
-       rupd = calloc(1, sizeof(struct rule_update));
-       if (rupd == NULL)
-	       return -1;
+	obj = calloc(1, sizeof(struct obj_update));
+	if (obj == NULL)
+		return -1;
 
-       rupd->rule = r;
-       rupd->type = type;
-       list_add_tail(&rupd->head, &h->rule_list);
-       h->rule_list_num++;
+	obj->rule = r;
+	obj->type = type;
+	list_add_tail(&obj->head, &h->obj_list);
+	h->obj_list_num++;
 
-       return 0;
+	return 0;
 }
 
 int
@@ -1001,11 +1001,11 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	if (handle > 0) {
 		nft_rule_attr_set(r, NFT_RULE_ATTR_HANDLE, &handle);
-		type = NFT_DO_REPLACE;
+		type = NFT_COMPAT_RULE_REPLACE;
 	} else
-		type = NFT_DO_APPEND;
+		type = NFT_COMPAT_RULE_APPEND;
 
-	if (rule_update_add(h, type, r) < 0)
+	if (batch_rule_add(h, type, r) < 0)
 		nft_rule_free(r);
 
 	return 1;
@@ -1243,7 +1243,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table, const char *chain)
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, (char *)table);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, (char *)chain);
 
-	if (rule_update_add(h, NFT_DO_FLUSH, r) < 0)
+	if (batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r) < 0)
 		nft_rule_free(r);
 }
 
@@ -1630,7 +1630,7 @@ static int __nft_rule_del(struct nft_handle *h, struct nft_rule_list *list,
 
 	nft_rule_list_del(r);
 
-	ret = rule_update_add(h, NFT_DO_DELETE, r);
+	ret = batch_rule_add(h, NFT_COMPAT_RULE_DELETE, r);
 	if (ret < 0) {
 		nft_rule_free(r);
 		return -1;
@@ -1756,7 +1756,7 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 	if (handle > 0)
 		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_POSITION, handle);
 
-	if (rule_update_add(h, NFT_DO_INSERT, r) < 0) {
+	if (batch_rule_add(h, NFT_COMPAT_RULE_INSERT, r) < 0) {
 		nft_rule_free(r);
 		return 0;
 	}
@@ -2180,28 +2180,28 @@ error:
 static int nft_action(struct nft_handle *h, int action)
 {
 	int flags = NLM_F_CREATE, type;
-	struct rule_update *n, *tmp;
+	struct obj_update *n, *tmp;
 	struct nlmsghdr *nlh;
 	uint32_t seq = 1;
 	int ret;
 
 	mnl_nft_batch_begin(h->batch, seq++);
 
-	list_for_each_entry_safe(n, tmp, &h->rule_list, head) {
+	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
 		switch (n->type) {
-		case NFT_DO_APPEND:
+		case NFT_COMPAT_RULE_APPEND:
 			type = NFT_MSG_NEWRULE;
 			flags |= NLM_F_APPEND;
 			break;
-		case NFT_DO_INSERT:
+		case NFT_COMPAT_RULE_INSERT:
 			type = NFT_MSG_NEWRULE;
 			break;
-		case NFT_DO_REPLACE:
+		case NFT_COMPAT_RULE_REPLACE:
 			type = NFT_MSG_NEWRULE;
 			flags |= NLM_F_REPLACE;
 			break;
-		case NFT_DO_DELETE:
-		case NFT_DO_FLUSH:
+		case NFT_COMPAT_RULE_DELETE:
+		case NFT_COMPAT_RULE_FLUSH:
 			type = NFT_MSG_DELRULE;
 			break;
 		default:
@@ -2213,7 +2213,7 @@ static int nft_action(struct nft_handle *h, int action)
 		nft_rule_nlmsg_build_payload(nlh, n->rule);
 		nft_rule_print_debug(n->rule, nlh);
 
-		h->rule_list_num--;
+		h->obj_list_num--;
 		list_del(&n->head);
 		nft_rule_free(n->rule);
 		free(n);
@@ -2223,10 +2223,10 @@ static int nft_action(struct nft_handle *h, int action)
 	}
 
 	switch (action) {
-	case NFT_DO_COMMIT:
+	case NFT_COMPAT_COMMIT:
 		mnl_nft_batch_end(h->batch, seq++);
 		break;
-	case NFT_DO_ABORT:
+	case NFT_COMPAT_ABORT:
 		break;
 	}
 
@@ -2244,12 +2244,12 @@ static int nft_action(struct nft_handle *h, int action)
 
 int nft_commit(struct nft_handle *h)
 {
-	return nft_action(h, NFT_DO_COMMIT);
+	return nft_action(h, NFT_COMPAT_COMMIT);
 }
 
 int nft_abort(struct nft_handle *h)
 {
-	return nft_action(h, NFT_DO_ABORT);
+	return nft_action(h, NFT_COMPAT_ABORT);
 }
 
 int nft_compatible_revision(const char *name, uint8_t rev, int opt)
diff --git a/iptables/nft.h b/iptables/nft.h
index c31371c..ddc5201 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -30,8 +30,8 @@ struct nft_handle {
 	struct mnl_socket	*nl;
 	uint32_t		portid;
 	uint32_t		seq;
-	struct list_head	rule_list;
-	int			rule_list_num;
+	struct list_head	obj_list;
+	int			obj_list_num;
 	struct mnl_nlmsg_batch	*batch;
 	struct nft_family_ops	*ops;
 	struct builtin_table	*tables;
-- 
1.7.10.4

