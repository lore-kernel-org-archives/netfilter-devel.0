From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v3] ruleset: fix crash if we free sets included in the set_list
Date: Tue, 24 Feb 2015 09:10:32 +0100
Message-ID: <1424765433-4975-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55712 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbBXIK0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 03:10:26 -0500
Received: by mail-wi0-f177.google.com with SMTP id bs8so23148674wib.4
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2015 00:10:25 -0800 (PST)
Received: from localhost.localdomain ([77.231.217.213])
        by mx.google.com with ESMTPSA id mb20sm19357878wic.18.2015.02.24.00.10.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Feb 2015 00:10:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When we parse a ruleset which has a rule using a set. First step is parse the
set, set up an id and add it to a set list. Later, we use this set list to find
the set associated to the rule and we set up the set id to the expression
(lookup expression) of the rule.

The problem is if we return this set using the function
nft_ruleset_parse_file_cb and we free this set. We have a crash when we try to
iterate in the set list.

This patch solves it, cloning the set and adding the new set to the set list.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
 * Use memcpy to clone the object.

 include/libnftnl/set.h |    2 ++
 src/ruleset.c          |    7 ++++++-
 src/set.c              |   31 +++++++++++++++++++++++++++++++
 src/set_elem.c         |   16 ++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 7f3504f..3f8ef87 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -42,6 +42,7 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 				  uint32_t *data_len);
 const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr);
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
+struct nft_set *nft_set_clone(const struct nft_set *set);
 
 struct nlmsghdr;
 
@@ -103,6 +104,7 @@ const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr);
 uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr);
 
 bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
+struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem);
 
 #define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
diff --git a/src/ruleset.c b/src/ruleset.c
index 89ea344..9e8965c 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -312,9 +312,14 @@ static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
 				 struct nft_set *set, uint32_t type,
 				 struct nft_parse_err *err)
 {
+	struct nft_set *newset;
+
 	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
-	nft_set_list_add_tail(set, ctx->set_list);
+	newset = nft_set_clone(set);
+	if (newset == NULL)
+		goto err;
 
+	nft_set_list_add_tail(newset, ctx->set_list);
 	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, type);
 	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_SET, set);
 	if (ctx->cb(ctx) < 0)
diff --git a/src/set.c b/src/set.c
index c6c3301..a02189b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -249,6 +249,37 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 
+struct nft_set *nft_set_clone(const struct nft_set *set)
+{
+	struct nft_set *newset;
+	struct nft_set_elem *elem, *newelem;
+
+	newset = nft_set_alloc();
+	if (newset == NULL)
+		return NULL;
+
+	memcpy(newset, set, sizeof(*set));
+
+	if (set->flags & (1 << NFT_SET_ATTR_TABLE))
+		newset->table = strdup(set->table);
+	if (set->flags & (1 << NFT_SET_ATTR_NAME))
+		newset->name = strdup(set->name);
+
+	INIT_LIST_HEAD(&newset->element_list);
+	list_for_each_entry(elem, &set->element_list, head) {
+		newelem = nft_set_elem_clone(elem);
+		if (newelem == NULL)
+			goto err;
+
+		list_add_tail(&newelem->head, &newset->element_list);
+	}
+
+	return newset;
+err:
+	nft_set_free(newset);
+	return NULL;
+}
+
 static void
 nft_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nft_set *s)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index 5794f3a..47ea1c5 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -164,6 +164,22 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_elem_attr_get_u32);
 
+struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem)
+{
+	struct nft_set_elem *newelem;
+
+	newelem = nft_set_elem_alloc();
+	if (newelem == NULL)
+		return NULL;
+
+	memcpy(newelem, elem, sizeof(*elem));
+
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+		newelem->data.chain = strdup(elem->data.chain);
+
+	return newelem;
+}
+
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 				      struct nft_set_elem *e)
 {
-- 
1.7.10.4

