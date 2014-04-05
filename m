From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: fix bogus assertion for unset attributes
Date: Sat,  5 Apr 2014 20:45:05 +0200
Message-ID: <1396723505-11929-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbaDESpS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:45:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you try to obtain an unset attribute, you hit an assertion error
that should not happen. Fix this by checking if the attribute is
unset, otherwise skip the assertion checking.

Now that we have that nft_assert takes the data parameter, we can also
validate if someone is using the setter passing NULL, which is illegal.
So let's add an assertion for that as well.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c    |   10 +++++-----
 src/internal.h |   14 ++++++++------
 src/rule.c     |    8 ++++----
 src/set.c      |    4 ++--
 src/table.c    |    2 +-
 5 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index ca71069..472203e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -156,7 +156,7 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 	if (attr > NFT_CHAIN_ATTR_MAX)
 		return;
 
-	nft_assert_validate(nft_chain_attr_validate, attr, data_len);
+	nft_assert_validate(data, nft_chain_attr_validate, attr, data_len);
 
 	switch(attr) {
 	case NFT_CHAIN_ATTR_NAME:
@@ -300,7 +300,7 @@ uint32_t nft_chain_attr_get_u32(struct nft_chain *c, uint16_t attr)
 	uint32_t data_len;
 	const uint32_t *val = nft_chain_attr_get_data(c, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(uint32_t));
+	nft_assert(val, attr, data_len == sizeof(uint32_t));
 
 	return val ? *val : 0;
 }
@@ -311,7 +311,7 @@ int32_t nft_chain_attr_get_s32(struct nft_chain *c, uint16_t attr)
 	uint32_t data_len;
 	const int32_t *val = nft_chain_attr_get_data(c, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(int32_t));
+	nft_assert(val, attr, data_len == sizeof(int32_t));
 
 	return val ? *val : 0;
 }
@@ -322,7 +322,7 @@ uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr)
 	uint32_t data_len;
 	const uint64_t *val = nft_chain_attr_get_data(c, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(int64_t));
+	nft_assert(val, attr, data_len == sizeof(int64_t));
 
 	return val ? *val : 0;
 }
@@ -333,7 +333,7 @@ uint8_t nft_chain_attr_get_u8(struct nft_chain *c, uint16_t attr)
 	uint32_t data_len;
 	const uint8_t *val = nft_chain_attr_get_data(c, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(int8_t));
+	nft_assert(val, attr, data_len == sizeof(int8_t));
 
 	return val ? *val : 0;
 }
diff --git a/src/internal.h b/src/internal.h
index 89ea962..71b0a09 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -190,15 +190,17 @@ struct nft_set_elem {
 
 void __nft_assert_fail(uint16_t attr, const char *filename, int line);
 
-#define nft_assert(attr, expr)				\
-  ((expr)						\
+#define nft_assert(val, attr, expr)			\
+  ((!val || expr)					\
    ? (void)0						\
    : __nft_assert_fail(attr, __FILE__, __LINE__))
 
-#define nft_assert_validate(_validate_array, _attr, _data_len)		\
-({									\
-	if (_validate_array[_attr])					\
-		nft_assert(attr, _validate_array[_attr] == _data_len);	\
+#define nft_assert_validate(data, _validate_array, _attr, _data_len)		\
+({										\
+	if (data == NULL)							\
+		__nft_assert_fail(attr, __FILE__, __LINE__);			\
+	if (_validate_array[_attr])						\
+		nft_assert(data, attr, _validate_array[_attr] == _data_len);	\
 })
 
 #endif
diff --git a/src/rule.c b/src/rule.c
index 1dce1d5..df9dd80 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -133,7 +133,7 @@ void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
 	if (attr > NFT_RULE_ATTR_MAX)
 		return;
 
-	nft_assert_validate(nft_rule_attr_validate, attr, data_len);
+	nft_assert_validate(data, nft_rule_attr_validate, attr, data_len);
 
 	switch(attr) {
 	case NFT_RULE_ATTR_TABLE:
@@ -248,7 +248,7 @@ uint32_t nft_rule_attr_get_u32(const struct nft_rule *r, uint16_t attr)
 	uint32_t data_len;
 	const uint32_t *val = nft_rule_attr_get_data(r, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(uint32_t));
+	nft_assert(val, attr, data_len == sizeof(uint32_t));
 
 	return val ? *val : 0;
 }
@@ -259,7 +259,7 @@ uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr)
 	uint32_t data_len;
 	const uint64_t *val = nft_rule_attr_get_data(r, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(uint64_t));
+	nft_assert(val, attr, data_len == sizeof(uint64_t));
 
 	return val ? *val : 0;
 }
@@ -270,7 +270,7 @@ uint8_t nft_rule_attr_get_u8(const struct nft_rule *r, uint16_t attr)
 	uint32_t data_len;
 	const uint8_t *val = nft_rule_attr_get_data(r, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(uint8_t));
+	nft_assert(val, attr, data_len == sizeof(uint8_t));
 
 	return val ? *val : 0;
 }
diff --git a/src/set.c b/src/set.c
index b3ff4ce..1402fcf 100644
--- a/src/set.c
+++ b/src/set.c
@@ -112,7 +112,7 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	if (attr > NFT_SET_ATTR_MAX)
 		return;
 
-	nft_assert_validate(nft_set_attr_validate, attr, data_len);
+	nft_assert_validate(data, nft_set_attr_validate, attr, data_len);
 
 	switch(attr) {
 	case NFT_SET_ATTR_TABLE:
@@ -226,7 +226,7 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 	uint32_t data_len;
 	const uint32_t *val = nft_set_attr_get_data(s, attr, &data_len);
 
-	nft_assert(attr, data_len == sizeof(uint32_t));
+	nft_assert(val, attr, data_len == sizeof(uint32_t));
 
 	return val ? *val : 0;
 }
diff --git a/src/table.c b/src/table.c
index 7a85b9e..44e9a7b 100644
--- a/src/table.c
+++ b/src/table.c
@@ -90,7 +90,7 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 	if (attr > NFT_TABLE_ATTR_MAX)
 		return;
 
-	nft_assert_validate(nft_table_attr_validate, attr, data_len);
+	nft_assert_validate(data, nft_table_attr_validate, attr, data_len);
 
 	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
-- 
1.7.10.4

