From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/9] src: assert when setting unknown attributes
Date: Tue, 14 Jun 2016 15:18:38 +0200
Message-ID: <1465910325-13286-2-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55942 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbcFNNS5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:18:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 38AB0E7DA2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 258F59EBA4
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 183A99EBA4
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:52 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If this attribute is not supported by the library, we should rise an
assertion so the client knows something is wrong, instead of silently
going through.

The only case I can think may hit this problem is version mismatch
between library and tools. This should not ever really happen, so better
bail out from the library itself in this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h | 9 +++++++++
 src/chain.c     | 4 +---
 src/gen.c       | 4 +---
 src/rule.c      | 4 +---
 src/set.c       | 4 +---
 src/table.c     | 4 +---
 src/utils.c     | 8 ++++++++
 7 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 1684b5a..c7472be 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -41,6 +41,15 @@ void __nftnl_assert_fail(uint16_t attr, const char *filename, int line);
 		nftnl_assert(data, attr, _validate_array[_attr] == _data_len);	\
 })
 
+void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
+				const char *filename, int line);
+
+#define nftnl_assert_attr_exists(_attr, _attr_max)					\
+({											\
+	if (_attr > _attr_max)								\
+		__nftnl_assert_attr_exists(_attr, _attr_max, __FILE__, __LINE__);	\
+})
+
 #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
 	if (ret < 0)					\
 		return ret;				\
diff --git a/src/chain.c b/src/chain.c
index 70daaf3..4c487cc 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -168,9 +168,7 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			     const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_CHAIN_MAX)
-		return;
-
+	nftnl_assert_attr_exists(attr, NFTNL_CHAIN_MAX);
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
 
 	switch(attr) {
diff --git a/src/gen.c b/src/gen.c
index 8533f38..698b9b9 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -67,9 +67,7 @@ static uint32_t nftnl_gen_validate[NFTNL_GEN_MAX + 1] = {
 void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 			   const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_GEN_MAX)
-		return;
-
+	nftnl_assert_attr_exists(attr, NFTNL_GEN_MAX);
 	nftnl_assert_validate(data, nftnl_gen_validate, attr, data_len);
 
 	switch (attr) {
diff --git a/src/rule.c b/src/rule.c
index 1e1a138..21d94aa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -130,9 +130,7 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			    const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_RULE_MAX)
-		return;
-
+	nftnl_assert_attr_exists(attr, NFTNL_RULE_MAX);
 	nftnl_assert_validate(data, nftnl_rule_validate, attr, data_len);
 
 	switch(attr) {
diff --git a/src/set.c b/src/set.c
index 3caaf39..bc8c8bc 100644
--- a/src/set.c
+++ b/src/set.c
@@ -116,9 +116,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 			   uint32_t data_len)
 {
-	if (attr > NFTNL_SET_MAX)
-		return;
-
+	nftnl_assert_attr_exists(attr, NFTNL_SET_MAX);
 	nftnl_assert_validate(data, nftnl_set_validate, attr, data_len);
 
 	switch(attr) {
diff --git a/src/table.c b/src/table.c
index 6e5e267..406babf 100644
--- a/src/table.c
+++ b/src/table.c
@@ -87,9 +87,7 @@ static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 			     const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_TABLE_MAX)
-		return;
-
+	nftnl_assert_attr_exists(attr, NFTNL_TABLE_MAX);
 	nftnl_assert_validate(data, nftnl_table_validate, attr, data_len);
 
 	switch (attr) {
diff --git a/src/utils.c b/src/utils.c
index 22710b9..e2715a2 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -269,6 +269,14 @@ out:
 	return ret;
 }
 
+void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
+				const char *filename, int line)
+{
+	fprintf(stderr, "libnftnl: attribute %d > %d (maximum) assertion failed in %s:%d\n",
+		attr, attr_max, filename, line);
+	exit(EXIT_FAILURE);
+}
+
 void __nftnl_assert_fail(uint16_t attr, const char *filename, int line)
 {
 	fprintf(stderr, "libnftnl: attribute %d assertion failed in %s:%d\n",
-- 
2.1.4

