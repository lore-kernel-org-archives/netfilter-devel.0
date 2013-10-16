From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: add fprintf functions
Date: Wed, 16 Oct 2013 19:14:38 +0200
Message-ID: <20131016171437.27537.1477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36920 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761257Ab3JPROu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:14:50 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 0F2AB51ED1D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2013 17:14:47 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oogWVy0DfZ5i for <netfilter-devel@vger.kernel.org>;
	Wed, 16 Oct 2013 19:14:41 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 5BB3151ED16
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2013 19:14:41 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now it's possible to print directly from libnftables to a file or other stream.

In order to don't force any format, the caller must print '\n'.

Signed-off-by: Arturo Borrero Gonzale <arturo.borrero.glez@gmail.com>
---
 include/libnftables/chain.h   |    1 +
 include/libnftables/rule.h    |    1 +
 include/libnftables/ruleset.h |    1 +
 include/libnftables/set.h     |    2 ++
 include/libnftables/table.h   |    1 +
 src/chain.c                   |   27 +++++++++++++++++++++++++++
 src/internal.h                |    2 ++
 src/libnftables.map           |    6 ++++++
 src/rule.c                    |   27 +++++++++++++++++++++++++++
 src/ruleset.c                 |   28 ++++++++++++++++++++++++++++
 src/set.c                     |   27 +++++++++++++++++++++++++++
 src/set_elem.c                |   27 +++++++++++++++++++++++++++
 src/table.c                   |   27 +++++++++++++++++++++++++++
 13 files changed, 177 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index d3086ea..4b58f16 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -58,6 +58,7 @@ enum nft_chain_parse_type {
 
 int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type, const char *data);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
+int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *t);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9fba9c8..a35b700 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -57,6 +57,7 @@ enum nft_rule_parse_type {
 
 int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, const char *data);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
+int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *t);
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index a4a1279..980276d 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -37,6 +37,7 @@ enum nft_ruleset_parse_type {
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse_type type, const char *data);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index e377826..2bddda4 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -36,6 +36,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 
 int nft_set_snprintf(char *buf, size_t size, struct nft_set *s, uint32_t type, uint32_t flags);
+int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type, uint32_t flags);
 
 struct nft_set_list;
 
@@ -106,6 +107,7 @@ int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s)
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type type, const char *data);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
+int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
 
 int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 66574cf..c412c43 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -46,6 +46,7 @@ enum nft_table_parse_type {
 
 int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type, const char *data);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
+int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
 int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t);
diff --git a/src/chain.c b/src/chain.c
index f831479..b92b22f 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -851,6 +851,33 @@ int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
 }
 EXPORT_SYMBOL(nft_chain_snprintf);
 
+int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type,
+		      uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_chain_snprintf(buf, bufsiz, c, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_chain_snprintf(buf, bufsiz, c, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_chain_fprintf);
+
 struct nft_chain_list {
 	struct list_head list;
 };
diff --git a/src/internal.h b/src/internal.h
index b29288a..e0f17ec 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -17,6 +17,8 @@
 #define BASE_DEC 10
 #define BASE_HEX 16
 
+#define NFT_SNPRINTF_BUFSIZ 4096
+
 enum nft_type {
 	NFT_TYPE_U8,
 	NFT_TYPE_U16,
diff --git a/src/libnftables.map b/src/libnftables.map
index 1223403..aa47714 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -12,6 +12,7 @@ global:
   nft_table_attr_get_str;
   nft_table_parse;
   nft_table_snprintf;
+  nft_table_fprintf;
   nft_table_nlmsg_build_hdr;
   nft_table_nlmsg_build_payload;
   nft_table_nlmsg_parse;
@@ -42,6 +43,7 @@ global:
   nft_chain_attr_get_str;
   nft_chain_parse;
   nft_chain_snprintf;
+  nft_chain_fprintf;
   nft_chain_nlmsg_build_hdr;
   nft_chain_nlmsg_build_payload;
   nft_chain_nlmsg_parse;
@@ -71,6 +73,7 @@ global:
   nft_rule_attr_get_str;
   nft_rule_parse;
   nft_rule_snprintf;
+  nft_rule_fprintf;
   nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
   nft_rule_nlmsg_parse;
@@ -126,6 +129,7 @@ global:
   nft_set_nlmsg_parse;
   nft_set_parse;
   nft_set_snprintf;
+  nft_set_fprintf;
 
   nft_set_list_alloc;
   nft_set_list_free;
@@ -157,6 +161,7 @@ global:
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
   nft_set_elem_snprintf;
+  nft_set_elem_fprinf;
 
   nft_set_elems_nlmsg_build_payload;
   nft_set_elems_nlmsg_parse;
@@ -176,6 +181,7 @@ global:
   nft_ruleset_attr_get;
   nft_ruleset_parse;
   nft_ruleset_snprintf;
+  nft_ruleset_fprintf;
 
 local: *;
 };
diff --git a/src/rule.c b/src/rule.c
index 7f2bce6..68e733b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -843,6 +843,33 @@ int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *r,
 }
 EXPORT_SYMBOL(nft_rule_snprintf);
 
+int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type,
+		     uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_rule_snprintf(buf, bufsiz, r, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_rule_snprintf(buf, bufsiz, r, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_rule_fprintf);
+
 int nft_rule_expr_foreach(struct nft_rule *r,
                           int (*cb)(struct nft_rule_expr *e, void *data),
                           void *data)
diff --git a/src/ruleset.c b/src/ruleset.c
index a7fbc33..54c3fc1 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -811,3 +811,31 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 	return -1;
 }
 EXPORT_SYMBOL(nft_ruleset_snprintf);
+
+int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type,
+			uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_ruleset_snprintf(buf, bufsiz, rs, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_ruleset_snprintf(buf, bufsiz, rs, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_ruleset_fprintf);
+
diff --git a/src/set.c b/src/set.c
index 31185a0..099fa4b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -668,6 +668,33 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 }
 EXPORT_SYMBOL(nft_set_snprintf);
 
+int nft_set_fprintf(FILE *fp, struct nft_set *s, uint32_t type,
+		    uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_set_snprintf(buf, bufsiz, s, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_set_snprintf(buf, bufsiz, s, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_set_fprintf);
+
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)
 {
 	list_add_tail(&elem->head, &s->element_list);
diff --git a/src/set_elem.c b/src/set_elem.c
index ba24c96..2dacd48 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -575,6 +575,33 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 }
 EXPORT_SYMBOL(nft_set_elem_snprintf);
 
+int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type,
+			 uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_set_elem_snprintf(buf, bufsiz, se, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_set_elem_snprintf(buf, bufsiz, se, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_set_elem_fprintf);
+
 int nft_set_elem_foreach(struct nft_set *s,
 			 int (*cb)(struct nft_set_elem *e, void *data),
 			 void *data)
diff --git a/src/table.c b/src/table.c
index 7f14b32..fd1307d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -388,6 +388,33 @@ int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
 }
 EXPORT_SYMBOL(nft_table_snprintf);
 
+int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type,
+		      uint32_t flags)
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = nft_table_snprintf(buf, bufsiz, t, type, flags);
+	if (ret > NFT_SNPRINTF_BUFSIZ) {
+		buf = calloc(1, ret);
+		if (buf == NULL)
+			return -1;
+
+		bufsiz = ret;
+		ret = nft_table_snprintf(buf, bufsiz, t, type, flags);
+	}
+
+	ret = fprintf(fp, "%s", buf);
+
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_table_fprintf);
+
 struct nft_table_list {
 	struct list_head list;
 };

