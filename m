From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] src: rename set_keytype_alloc() to set_datatype_alloc()
Date: Tue, 28 Feb 2017 01:01:00 +0100
Message-ID: <1488240062-27366-2-git-send-email-pablo@netfilter.org>
References: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751285AbdB1ACd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 19:02:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96AB9E62C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87B76DA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ADC9DA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:08 +0100 (CET)
In-Reply-To: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function can be used either side of the map, so rename it to
something generic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 4 ++--
 src/datatype.c     | 6 +++---
 src/evaluate.c     | 2 +-
 src/netlink.c      | 2 +-
 src/rule.c         | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 3ce3a888f063..b78d76f78f76 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -254,8 +254,8 @@ concat_subtype_lookup(uint32_t type, unsigned int n)
 }
 
 extern const struct datatype *
-set_keytype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
-extern void set_keytype_destroy(const struct datatype *dtype);
+set_datatype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
+extern void set_datatype_destroy(const struct datatype *dtype);
 
 extern void time_print(uint64_t seconds);
 extern struct error_record *time_parse(const struct location *loc,
diff --git a/src/datatype.c b/src/datatype.c
index 64b8b8845b10..6b1dd4a09abb 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1029,8 +1029,8 @@ void concat_type_destroy(const struct datatype *dtype)
 	dtype_free(dtype);
 }
 
-const struct datatype *set_keytype_alloc(const struct datatype *orig_dtype,
-					 unsigned int byteorder)
+const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
+					  unsigned int byteorder)
 {
 	struct datatype *dtype;
 
@@ -1044,7 +1044,7 @@ const struct datatype *set_keytype_alloc(const struct datatype *orig_dtype,
 	return dtype;
 }
 
-void set_keytype_destroy(const struct datatype *dtype)
+void set_datatype_destroy(const struct datatype *dtype)
 {
 	if (dtype->flags & DTYPE_F_CLONE)
 		dtype_free(dtype);
diff --git a/src/evaluate.c b/src/evaluate.c
index 21f1a475d5e9..07a611804a90 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -73,7 +73,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(name),
-	set->keytype 	= set_keytype_alloc(keytype, keybyteorder);
+	set->keytype 	= set_datatype_alloc(keytype, keybyteorder);
 	set->keylen	= keylen;
 	set->init	= expr;
 
diff --git a/src/netlink.c b/src/netlink.c
index 1f3398225892..60d86d61c504 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1189,7 +1189,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 
-	set->keytype = set_keytype_alloc(keytype, byteorder);
+	set->keytype = set_datatype_alloc(keytype, byteorder);
 	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
diff --git a/src/rule.c b/src/rule.c
index b47076f000ee..6045747710db 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -210,7 +210,7 @@ void set_free(struct set *set)
 	if (set->init != NULL)
 		expr_free(set->init);
 	handle_free(&set->handle);
-	set_keytype_destroy(set->keytype);
+	set_datatype_destroy(set->keytype);
 	xfree(set);
 }
 
-- 
2.1.4

