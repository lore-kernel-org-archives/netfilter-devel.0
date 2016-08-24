From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] rhashtable: add rhashtable_lookup_get_insert_key()
Date: Wed, 24 Aug 2016 16:23:14 +0200
Message-ID: <1472048595-7214-1-git-send-email-pablo@netfilter.org>
Cc: herbert@gondor.apana.org.au, tgraf@suug.ch
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753807AbcHXOXh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 10:23:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8D4E62273D9
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:23:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C734DA7FD
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:23:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CFE6100A5F
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 16:23:20 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies __rhashtable_insert_fast() so it returns the
existing element that clashes with the one that you want to insert.
This adds a new rhashtable_lookup_get_insert_key() interface to fetch
this existing element.

nf_tables needs this change to improve handling of EEXIST cases via
honoring the NLM_F_EXCL flag and by checking if the data part of the
mapping matches what we have.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/rhashtable.h | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 3eef080..a632cf0 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -566,7 +566,7 @@ restart:
 /* Internal function, please use rhashtable_insert_fast() instead */
 static inline int __rhashtable_insert_fast(
 	struct rhashtable *ht, const void *key, struct rhash_head *obj,
-	const struct rhashtable_params params)
+	const struct rhashtable_params params, void **data)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -630,8 +630,11 @@ slow_path:
 		if (key &&
 		    unlikely(!(params.obj_cmpfn ?
 			       params.obj_cmpfn(&arg, rht_obj(ht, head)) :
-			       rhashtable_compare(&arg, rht_obj(ht, head)))))
+			       rhashtable_compare(&arg, rht_obj(ht, head))))) {
+			if (data)
+				*data = rht_obj(ht, head);
 			goto out;
+		}
 		if (!--elasticity)
 			goto slow_path;
 	}
@@ -675,7 +678,7 @@ static inline int rhashtable_insert_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
-	return __rhashtable_insert_fast(ht, NULL, obj, params);
+	return __rhashtable_insert_fast(ht, NULL, obj, params, NULL);
 }
 
 /**
@@ -708,7 +711,7 @@ static inline int rhashtable_lookup_insert_fast(
 	BUG_ON(ht->p.obj_hashfn);
 
 	return __rhashtable_insert_fast(ht, key + ht->p.key_offset, obj,
-					params);
+					params, NULL);
 }
 
 /**
@@ -739,7 +742,26 @@ static inline int rhashtable_lookup_insert_key(
 {
 	BUG_ON(!ht->p.obj_hashfn || !key);
 
-	return __rhashtable_insert_fast(ht, key, obj, params);
+	return __rhashtable_insert_fast(ht, key, obj, params, NULL);
+}
+
+/**
+ * rhashtable_lookup_get_insert_key - lookup and insert object into hash table
+ * @ht:		hash table
+ * @obj:	pointer to hash head inside object
+ * @params:	hash table parameters
+ * @data:	pointer to element data already in hashes
+ *
+ * Just like rhashtable_lookup_insert_key(), but it returns the matching
+ * element in case that it already exists in the hashes.
+ */
+static inline int rhashtable_lookup_get_insert_key(
+	struct rhashtable *ht, const void *key, struct rhash_head *obj,
+	const struct rhashtable_params params, void **data)
+{
+	BUG_ON(!ht->p.obj_hashfn || !key);
+
+	return __rhashtable_insert_fast(ht, key, obj, params, data);
 }
 
 /* Internal function, please use rhashtable_remove_fast() instead */
-- 
2.1.4

