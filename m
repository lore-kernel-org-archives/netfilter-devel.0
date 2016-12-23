From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 10/10] src: support for stateful object monitoring
Date: Fri, 23 Dec 2016 15:26:55 +0100
Message-ID: <1482503215-25422-10-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941139AbcLWO1S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 824B22519A7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 723DF8E66B
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 371358E66D
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:14 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends the event monitoring infrastructure to catch events
of addition and removal of stateful objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |   3 ++
 src/netlink.c  | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/rule.c     |  25 +++++++++++
 3 files changed, 162 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 86c0392f89af..878563d9fcbc 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -283,7 +283,10 @@ struct obj {
 struct obj *obj_alloc(const struct location *loc);
 void obj_free(struct obj *obj);
 void obj_add_hash(struct obj *obj, struct table *table);
+struct obj *obj_lookup(const struct table *table, const char *name,
+		       uint32_t type);
 void obj_print(const struct obj *n);
+void obj_print_plain(const struct obj *obj);
 const char *obj_type_name(uint32_t type);
 
 /**
diff --git a/src/netlink.c b/src/netlink.c
index 97220f451343..5f478ff07319 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1923,6 +1923,19 @@ static struct nftnl_rule *netlink_rule_alloc(const struct nlmsghdr *nlh)
 	return nlr;
 }
 
+static struct nftnl_obj *netlink_obj_alloc(const struct nlmsghdr *nlh)
+{
+	struct nftnl_obj *nlo;
+
+	nlo = nftnl_obj_alloc();
+	if (nlo == NULL)
+		memory_allocation_error();
+	if (nftnl_obj_nlmsg_parse(nlh, nlo) < 0)
+		netlink_abi_error();
+
+	return nlo;
+}
+
 static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 {
 	switch (msg) {
@@ -2184,6 +2197,51 @@ out:
 	return MNL_CB_OK;
 }
 
+static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
+				 struct netlink_mon_handler *monh)
+{
+	struct nftnl_obj *nlo;
+	uint32_t family;
+	struct obj *obj;
+
+	nlo = netlink_obj_alloc(nlh);
+
+	switch (monh->format) {
+	case NFTNL_OUTPUT_DEFAULT:
+		switch (type) {
+		case NFT_MSG_NEWOBJ:
+			printf("add ");
+			obj = netlink_delinearize_obj(monh->ctx, nlo);
+			if (obj == NULL) {
+				nftnl_obj_free(nlo);
+				return MNL_CB_ERROR;
+			}
+			obj_print_plain(obj);
+			obj_free(obj);
+			printf("\n");
+			break;
+		case NFT_MSG_DELOBJ:
+			family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
+			printf("delete %s %s %s %s\n",
+			       obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE)),
+			       family2str(family),
+			       nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE),
+			       nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
+			break;
+		}
+		break;
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		nftnl_obj_fprintf(stdout, nlo, monh->format,
+				  netlink_msg2nftnl_of(type));
+		fprintf(stdout, "\n");
+		break;
+	}
+
+	nftnl_obj_free(nlo);
+	return MNL_CB_OK;
+}
+
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
 	if (s->flags & NFT_SET_INTERVAL)
@@ -2363,6 +2421,72 @@ static void netlink_events_cache_delsets(struct netlink_mon_handler *monh,
 	nftnl_rule_free(nlr);
 }
 
+static void netlink_events_cache_addobj(struct netlink_mon_handler *monh,
+					const struct nlmsghdr *nlh)
+{
+	struct netlink_ctx obj_tmpctx;
+	struct nftnl_obj *nlo;
+	struct table *t;
+	struct obj *obj;
+	LIST_HEAD(msgs);
+
+	memset(&obj_tmpctx, 0, sizeof(obj_tmpctx));
+	init_list_head(&obj_tmpctx.list);
+	init_list_head(&msgs);
+	obj_tmpctx.msgs = &msgs;
+
+	nlo = netlink_obj_alloc(nlh);
+	obj = netlink_delinearize_obj(&obj_tmpctx, nlo);
+	if (obj == NULL)
+		goto out;
+
+	t = table_lookup(&obj->handle);
+	if (t == NULL) {
+		fprintf(stderr, "W: Unable to cache object: table not found.\n");
+		obj_free(obj);
+		goto out;
+	}
+
+	obj_add_hash(obj, t);
+out:
+	nftnl_obj_free(nlo);
+}
+
+static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
+					const struct nlmsghdr *nlh)
+{
+	struct nftnl_obj *nlo;
+	const char *name;
+	struct obj *obj;
+	struct handle h;
+	struct table *t;
+	uint32_t type;
+
+	nlo      = netlink_obj_alloc(nlh);
+	h.family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
+	h.table  = nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE);
+
+	name     = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
+	type	 = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
+
+	t = table_lookup(&h);
+	if (t == NULL) {
+		fprintf(stderr, "W: Unable to cache object: table not found.\n");
+		goto out;
+	}
+
+	obj = obj_lookup(t, name, type);
+	if (obj == NULL) {
+		fprintf(stderr, "W: Unable to find object in cache\n");
+		goto out;
+	}
+
+	list_del(&obj->list);
+	obj_free(obj);
+out:
+	nftnl_obj_free(nlo);
+}
+
 static void netlink_events_cache_update(struct netlink_mon_handler *monh,
 					const struct nlmsghdr *nlh, int type)
 {
@@ -2386,6 +2510,12 @@ static void netlink_events_cache_update(struct netlink_mon_handler *monh,
 		/* there are no notification for anon-set deletion */
 		netlink_events_cache_delsets(monh, nlh);
 		break;
+	case NFT_MSG_NEWOBJ:
+		netlink_events_cache_addobj(monh, nlh);
+		break;
+	case NFT_MSG_DELOBJ:
+		netlink_events_cache_delobj(monh, nlh);
+		break;
 	}
 }
 
@@ -2697,6 +2827,10 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_TRACE:
 		ret = netlink_events_trace_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWOBJ:
+	case NFT_MSG_DELOBJ:
+		ret = netlink_events_obj_cb(nlh, type, monh);
+		break;
 	}
 	fflush(stdout);
 
diff --git a/src/rule.c b/src/rule.c
index b97213e94954..b6dc755e9621 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1158,6 +1158,19 @@ void obj_add_hash(struct obj *obj, struct table *table)
 	list_add_tail(&obj->list, &table->objs);
 }
 
+struct obj *obj_lookup(const struct table *table, const char *name,
+		       uint32_t type)
+{
+	struct obj *obj;
+
+	list_for_each_entry(obj, &table->objs, list) {
+		if (!strcmp(obj->handle.obj, name) &&
+		    obj->type == type)
+			return obj;
+	}
+	return NULL;
+}
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts)
 {
@@ -1229,6 +1242,18 @@ void obj_print(const struct obj *obj)
 	obj_print_declaration(obj, &opts);
 }
 
+void obj_print_plain(const struct obj *obj)
+{
+	struct print_fmt_options opts = {
+		.tab		= "",
+		.nl		= " ",
+		.table		= obj->handle.table,
+		.family		= family2str(obj->handle.family),
+	};
+
+	obj_print_declaration(obj, &opts);
+}
+
 static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 {
 	struct print_fmt_options opts = {
-- 
2.1.4

