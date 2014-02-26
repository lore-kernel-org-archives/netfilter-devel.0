From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7] src: early attribute type validation in nft_*_attr_set
Date: Wed, 26 Feb 2014 02:51:53 +0100
Message-ID: <1393379519-16189-2-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaBZBwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:09 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to remove the default case in the switch, which
show help to spot missing attribute support since gcc will spot
a compilation warning.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/chain.h |    2 ++
 include/libnftnl/rule.h  |    2 ++
 include/libnftnl/set.h   |    2 ++
 include/libnftnl/table.h |    2 ++
 src/chain.c              |    5 +++--
 src/rule.c               |    5 +++--
 src/set.c                |    5 +++--
 src/table.c              |   11 ++++++-----
 8 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 66626d8..27de302 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -29,7 +29,9 @@ enum {
 	NFT_CHAIN_ATTR_PACKETS	= 8,
 	NFT_CHAIN_ATTR_HANDLE,
 	NFT_CHAIN_ATTR_TYPE,
+	__NFT_CHAIN_ATTR_MAX
 };
+#define NFT_CHAIN_ATTR_MAX (__NFT_CHAIN_ATTR_MAX - 1)
 
 bool nft_chain_attr_is_set(const struct nft_chain *c, uint16_t attr);
 void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 4033d3c..13e6c14 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -26,7 +26,9 @@ enum {
 	NFT_RULE_ATTR_COMPAT_PROTO,
 	NFT_RULE_ATTR_COMPAT_FLAGS,
 	NFT_RULE_ATTR_POSITION,
+	__NFT_RULE_ATTR_MAX
 };
+#define NFT_RULE_ATTR_MAX (__NFT_RULE_ATTR_MAX - 1)
 
 void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
 bool nft_rule_attr_is_set(const struct nft_rule *r, uint16_t attr);
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 7fa9fb2..ba11315 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -17,7 +17,9 @@ enum {
 	NFT_SET_ATTR_DATA_TYPE,
 	NFT_SET_ATTR_DATA_LEN,
 	NFT_SET_ATTR_FAMILY,
+	__NFT_SET_ATTR_MAX
 };
+#define NFT_SET_ATTR_MAX (__NFT_SET_ATTR_MAX - 1)
 
 struct nft_set;
 
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 56e7e35..96f2668 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -22,7 +22,9 @@ enum {
 	NFT_TABLE_ATTR_FAMILY,
 	NFT_TABLE_ATTR_FLAGS,
 	NFT_TABLE_ATTR_USE,
+	__NFT_TABLE_ATTR_MAX
 };
+#define NFT_TABLE_ATTR_MAX (__NFT_TABLE_ATTR_MAX - 1)
 
 bool nft_table_attr_is_set(const struct nft_table *t, uint16_t attr);
 void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
diff --git a/src/chain.c b/src/chain.c
index 34eb91d..19e7950 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -142,6 +142,9 @@ EXPORT_SYMBOL(nft_chain_attr_unset);
 
 void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
 {
+	if (attr > NFT_CHAIN_ATTR_MAX)
+		return;
+
 	switch(attr) {
 	case NFT_CHAIN_ATTR_NAME:
 		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
@@ -182,8 +185,6 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, const void *data)
 
 		c->type = strdup(data);
 		break;
-	default:
-		return;
 	}
 	c->flags |= (1 << attr);
 }
diff --git a/src/rule.c b/src/rule.c
index 53d2ebf..5e149c7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -115,6 +115,9 @@ EXPORT_SYMBOL(nft_rule_attr_unset);
 
 void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 {
+	if (attr > NFT_RULE_ATTR_MAX)
+		return;
+
 	switch(attr) {
 	case NFT_RULE_ATTR_TABLE:
 		if (r->table)
@@ -143,8 +146,6 @@ void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const void *data)
 	case NFT_RULE_ATTR_POSITION:
 		r->position = *((uint64_t *)data);
 		break;
-	default:
-		return;
 	}
 	r->flags |= (1 << attr);
 }
diff --git a/src/set.c b/src/set.c
index c3a7fae..c8b5ccf 100644
--- a/src/set.c
+++ b/src/set.c
@@ -98,6 +98,9 @@ EXPORT_SYMBOL(nft_set_attr_unset);
 
 void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 {
+	if (attr > NFT_SET_ATTR_MAX)
+		return;
+
 	switch(attr) {
 	case NFT_SET_ATTR_TABLE:
 		if (s->table)
@@ -129,8 +132,6 @@ void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data)
 	case NFT_SET_ATTR_FAMILY:
 		s->family = *((uint32_t *)data);
 		break;
-	default:
-		return;
 	}
 	s->flags |= (1 << attr);
 }
diff --git a/src/table.c b/src/table.c
index c834a4e..af4b13c 100644
--- a/src/table.c
+++ b/src/table.c
@@ -81,26 +81,27 @@ EXPORT_SYMBOL(nft_table_attr_unset);
 
 void nft_table_attr_set(struct nft_table *t, uint16_t attr, const void *data)
 {
+	if (attr > NFT_TABLE_ATTR_MAX)
+		return;
+
 	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
 		if (t->name)
 			xfree(t->name);
 
 		t->name = strdup(data);
-		t->flags |= (1 << NFT_TABLE_ATTR_NAME);
 		break;
 	case NFT_TABLE_ATTR_FLAGS:
 		t->table_flags = *((uint32_t *)data);
-		t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 		break;
 	case NFT_TABLE_ATTR_FAMILY:
 		t->family = *((uint8_t *)data);
-		t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
 		break;
 	case NFT_TABLE_ATTR_USE:
-		/* Cannot be unset, ignoring it */
-		break;
+		/* Cannot be set, ignoring it */
+		return;
 	}
+	t->flags |= (1 << attr);
 }
 EXPORT_SYMBOL(nft_table_attr_set);
 
-- 
1.7.10.4

