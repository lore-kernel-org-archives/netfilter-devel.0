From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] src: add _unset functions
Date: Thu, 06 Jun 2013 22:15:58 +0200
Message-ID: <20130606201511.14106.55015.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51226 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752830Ab3FFUQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:16:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions unset the flag for the given attribute in each object and free data in some cases.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: improved unset operation and freed data pointer set to NULL

 include/libnftables/chain.h |    1 +
 include/libnftables/rule.h  |    1 +
 include/libnftables/set.h   |    2 ++
 include/libnftables/table.h |    1 +
 src/chain.c                 |   24 ++++++++++++++++++++++++
 src/libnftables.map         |    5 +++++
 src/rule.c                  |   23 +++++++++++++++++++++++
 src/set.c                   |   23 +++++++++++++++++++++++
 src/set_elem.c              |   13 +++++++++++++
 src/table.c                 |   15 ++++++++++++++-
 10 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index b12474f..f06f743 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -26,6 +26,7 @@ enum {
 	NFT_CHAIN_ATTR_TYPE,
 };
 
+void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const void *data);
 void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uint32_t data);
 void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int32_t data);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9c4ab0d..9989f19 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -23,6 +23,7 @@ enum {
 	NFT_RULE_ATTR_COMPAT_FLAGS,
 };
 
+void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data);
 void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint32_t val);
 void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint64_t val);
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 53c2947..211c065 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -16,6 +16,7 @@ struct nft_set;
 struct nft_set *nft_set_alloc(void);
 void nft_set_free(struct nft_set *s);
 
+void nft_set_attr_unset(struct nft_set *s, uint16_t attr);
 void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data);
 void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val);
 void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str);
@@ -61,6 +62,7 @@ void nft_set_elem_free(struct nft_set_elem *s);
 
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem);
 
+void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr);
 void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, const void *data, size_t data_len);
 void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t val);
 void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 658230c..09cd204 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -18,6 +18,7 @@ enum {
 	NFT_TABLE_ATTR_FLAGS,
 };
 
+void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data);
 const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
 
diff --git a/src/chain.c b/src/chain.c
index 4146e6a..e3e5d5d 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -58,6 +58,30 @@ void nft_chain_free(struct nft_chain *c)
 }
 EXPORT_SYMBOL(nft_chain_free);
 
+void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
+{
+	switch (attr) {
+	case NFT_CHAIN_ATTR_TABLE:
+		if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE))
+			if (c->table)
+				free(c->table);
+		break;
+	case NFT_CHAIN_ATTR_USE:
+		/* cannot be unset?, ignore it */
+		return;
+	case NFT_CHAIN_ATTR_TYPE:
+		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
+			if (c->type) {
+				free(c->type);
+				c->type = NULL;
+			}
+		break;
+	}
+
+	c->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_chain_attr_unset);
+
 void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
 {
 	switch(attr) {
diff --git a/src/libnftables.map b/src/libnftables.map
index 8bae60c..2b31d55 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -2,6 +2,7 @@ LIBNFTABLES_1.0 {
 global:
   nft_table_alloc;
   nft_table_free;
+  nft_table_attr_unset;
   nft_table_attr_set;
   nft_table_attr_get;
   nft_table_attr_set_u32;
@@ -22,6 +23,7 @@ global:
 
   nft_chain_alloc;
   nft_chain_free;
+  nft_chain_attr_unset;
   nft_chain_attr_set;
   nft_chain_attr_set_u32;
   nft_chain_attr_set_s32;
@@ -47,6 +49,7 @@ global:
 
   nft_rule_alloc;
   nft_rule_free;
+  nft_rule_attr_unset;
   nft_rule_attr_set;
   nft_rule_attr_set_u32;
   nft_rule_attr_set_u64;
@@ -91,6 +94,7 @@ global:
 
   nft_set_alloc;
   nft_set_free;
+  nft_set_attr_unset;
   nft_set_attr_set;
   nft_set_attr_set_u32;
   nft_set_attr_set_str;
@@ -114,6 +118,7 @@ global:
   nft_set_elem_alloc;
   nft_set_elem_free;
   nft_set_elem_add;
+  nft_set_elem_attr_unset;
   nft_set_elem_attr_set;
   nft_set_elem_attr_set_u32;
   nft_set_elem_attr_set_str;
diff --git a/src/rule.c b/src/rule.c
index 94eba44..3bb9c48 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -70,6 +70,29 @@ void nft_rule_free(struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_free);
 
+void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
+{
+	switch (attr) {
+	case NFT_RULE_ATTR_TABLE:
+		if (r->flags & (1 << NFT_RULE_ATTR_TABLE))
+			if (r->table) {
+				free(r->table);
+				r->table = NULL;
+			}
+		break;
+	case NFT_RULE_ATTR_CHAIN:
+		if (r->flags & (1 << NFT_RULE_ATTR_CHAIN))
+			if (r->chain) {
+				free(r->chain);
+				r->chain = NULL;
+			}
+		break;
+	}
+
+	r->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_rule_attr_unset);
+
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 {
 	switch(attr) {
diff --git a/src/set.c b/src/set.c
index ef2d11d..eb49167 100644
--- a/src/set.c
+++ b/src/set.c
@@ -56,6 +56,29 @@ void nft_set_free(struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_free);
 
+void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
+{
+	switch (attr) {
+	case NFT_SET_ATTR_TABLE:
+		if (s->flags & (1 << NFT_SET_ATTR_TABLE))
+			if (s->table) {
+				free(s->table);
+				s->table = NULL;
+			}
+		break;
+	case NFT_SET_ATTR_NAME:
+		if (s->flags & (1 << NFT_SET_ATTR_NAME))
+			if (s->name) {
+				free(s->name);
+				s->name = NULL;
+			}
+		break;
+	}
+
+	s->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_set_attr_unset);
+
 void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 {
 	switch(attr) {
diff --git a/src/set_elem.c b/src/set_elem.c
index a2669ad..620080d 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -44,6 +44,19 @@ void nft_set_elem_free(struct nft_set_elem *s)
 }
 EXPORT_SYMBOL(nft_set_elem_free);
 
+void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
+{
+	if (attr == NFT_SET_ELEM_ATTR_CHAIN)
+		if (s->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+			if (s->data.chain) {
+				free(s->data.chain);
+				s->data.chain = NULL;
+			}
+
+	s->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_set_elem_attr_unset);
+
 void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 			   const void *data, size_t data_len)
 {
diff --git a/src/table.c b/src/table.c
index 70f482d..6c3332c 100644
--- a/src/table.c
+++ b/src/table.c
@@ -49,9 +49,22 @@ void nft_table_free(struct nft_table *t)
 }
 EXPORT_SYMBOL(nft_table_free);
 
+void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
+{
+	if (attr == NFT_TABLE_ATTR_NAME)
+		if (t->flags & (1 << NFT_TABLE_ATTR_NAME))
+			if (t->name) {
+				free(t->name);
+				t->name = NULL;
+			}
+
+	t->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_table_attr_unset);
+
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
 {
-	switch(attr) {
+	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
 		if (t->name)
 			free(t->name);

