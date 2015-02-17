From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2] ruleset: fix crash if we free sets included in the set_list
Date: Tue, 17 Feb 2015 15:03:51 +0100
Message-ID: <1424181831-9027-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40112 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbBQODi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 09:03:38 -0500
Received: by mail-wi0-f180.google.com with SMTP id h11so33691728wiw.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2015 06:03:37 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id kr5sm22607178wjc.1.2015.02.17.06.03.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Feb 2015 06:03:36 -0800 (PST)
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
[changes in v2]
 * Added the function to clone set and set elems.

 include/libnftnl/set.h |    2 ++
 src/ruleset.c          |    8 +++++++-
 src/set.c              |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/set_elem.c         |   27 +++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 1 deletion(-)

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
index 89ea344..bc669c0 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -312,8 +312,14 @@ static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
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
+
+	nft_set_list_add_tail(newset, ctx->set_list);
 
 	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, type);
 	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_SET, set);
diff --git a/src/set.c b/src/set.c
index c6c3301..5fd5245 100644
--- a/src/set.c
+++ b/src/set.c
@@ -249,6 +249,58 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 
+struct nft_set *nft_set_clone(const struct nft_set *set)
+{
+	struct nft_set *newset;
+	struct nft_set_elem *elem, *tmp, *newelem;
+
+	newset = nft_set_alloc();
+	if (newset == NULL)
+		return NULL;
+
+	if (set->flags & (1 << NFT_SET_ATTR_TABLE))
+		nft_set_attr_set_str(newset, NFT_SET_ATTR_TABLE, set->table);
+	if (set->flags & (1 << NFT_SET_ATTR_NAME))
+		nft_set_attr_set_str(newset, NFT_SET_ATTR_NAME, set->name);
+	if (set->flags & (1 << NFT_SET_ATTR_FLAGS))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_FLAGS,
+				     set->set_flags);
+	if (set->flags & (1 << NFT_SET_ATTR_KEY_TYPE))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_KEY_TYPE,
+				     set->key_type);
+	if (set->flags & (1 << NFT_SET_ATTR_KEY_LEN))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_KEY_LEN,
+				     set->key_len);
+	if (set->flags & (1 << NFT_SET_ATTR_DATA_TYPE))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_DATA_TYPE,
+				     set->data_type);
+	if (set->flags & (1 << NFT_SET_ATTR_DATA_LEN))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_DATA_LEN,
+				     set->data_len);
+	if (set->flags & (1 << NFT_SET_ATTR_FAMILY))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_FAMILY, set->family);
+	if (set->flags & (1 << NFT_SET_ATTR_ID))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_ID, set->id);
+	if (set->flags & (1 << NFT_SET_ATTR_POLICY))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_POLICY, set->policy);
+	if (set->flags & (1 << NFT_SET_ATTR_DESC_SIZE))
+		nft_set_attr_set_u32(newset, NFT_SET_ATTR_DESC_SIZE,
+				     set->desc.size);
+
+	list_for_each_entry_safe(elem, tmp, &set->element_list, head) {
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
index 5794f3a..1e3a157 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -164,6 +164,33 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
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
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS))
+		nft_set_elem_attr_set_u32(newelem, NFT_SET_ELEM_ATTR_FLAGS,
+					  elem->set_elem_flags);
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_KEY))
+		nft_set_elem_attr_set(newelem, NFT_SET_ELEM_ATTR_KEY,
+				      elem->key.val, elem->key.len);
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT))
+		nft_set_elem_attr_set_u32(newelem, NFT_SET_ELEM_ATTR_VERDICT,
+					  elem->data.verdict);
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+		nft_set_elem_attr_set_str(newelem, NFT_SET_ELEM_ATTR_CHAIN,
+					  elem->data.chain);
+	if (elem->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
+		nft_set_elem_attr_set(newelem, NFT_SET_ELEM_ATTR_DATA,
+				      elem->data.val, elem->data.len);
+
+	return newelem;
+}
+
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 				      struct nft_set_elem *e)
 {
-- 
1.7.10.4

