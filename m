From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] set: add helper to get the first set_elem
Date: Tue, 15 Apr 2014 09:58:42 +0200
Message-ID: <20140415075842.18544.32525.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43947 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbaDOH6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:58:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper that returns a pointer to the first set_elem in a given set.

This function is useful in situations where you know the set only have one
element (ie, event reporting from the kernel).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/set.h |    1 +
 src/libnftnl.map       |    1 +
 src/set.c              |   16 ++++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index a975f1c..739fa2a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -89,6 +89,7 @@ struct nft_set_elem *nft_set_elem_alloc(void);
 void nft_set_elem_free(struct nft_set_elem *s);
 
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem);
+struct nft_set_elem *nft_set_get_first_elem(struct nft_set *s);
 
 void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr);
 void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index b11db67..b63c2d1 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -151,6 +151,7 @@ global:
   nft_set_elem_alloc;
   nft_set_elem_free;
   nft_set_elem_add;
+  nft_set_get_first_elem;
   nft_set_elem_foreach;
   nft_set_elem_attr_is_set;
   nft_set_elem_attr_unset;
diff --git a/src/set.c b/src/set.c
index 550c262..50107d3 100644
--- a/src/set.c
+++ b/src/set.c
@@ -737,6 +737,22 @@ void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)
 }
 EXPORT_SYMBOL(nft_set_elem_add);
 
+struct nft_set_elem *nft_set_get_first_elem(struct nft_set *s)
+{
+	struct nft_set_elems_iter *sei;
+	struct nft_set_elem *se;
+
+	sei = nft_set_elems_iter_create(nls);
+	if (sei == NULL)
+		return NULL;
+
+	se = nft_set_elems_iter_cur(sei);
+	nft_set_elems_iter_destroy(sei);
+
+	return se;
+}
+EXPORT_SYMBOL(nft_set_get_first_elem);
+
 struct nft_set_list {
 	struct list_head list;
 };

