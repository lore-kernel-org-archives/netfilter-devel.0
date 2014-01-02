From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] parsing: add interface to parse from file
Date: Thu, 02 Jan 2014 14:21:03 +0100
Message-ID: <20140102132103.23299.58753.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38615 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750733AbaABNVP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:21:15 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id E67CB51ECCB
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jan 2014 13:21:12 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jUk4wXlTWD6L for <netfilter-devel@vger.kernel.org>;
	Thu,  2 Jan 2014 14:21:07 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 156D951ECD5
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jan 2014 14:21:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds API interfaces to parse nft objects from a given filename.

I found this useful in `nft', where I'm trying to parse XML/JSON from a file.

Examples will be updated in a separated patch.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftables/chain.h   |    1 +
 include/libnftables/rule.h    |    1 +
 include/libnftables/ruleset.h |    1 +
 include/libnftables/set.h     |    2 ++
 include/libnftables/table.h   |    1 +
 src/chain.c                   |   15 +++++++++++++++
 src/internal.h                |    8 +++++++-
 src/libnftables.map           |    6 ++++++
 src/rule.c                    |   14 ++++++++++++++
 src/ruleset.c                 |   14 ++++++++++++++
 src/set.c                     |   14 ++++++++++++++
 src/set_elem.c                |   14 ++++++++++++++
 src/table.c                   |   14 ++++++++++++++
 src/utils.c                   |   34 ++++++++++++++++++++++++++++++++++
 14 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 8b4eab9..619088f 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -52,6 +52,7 @@ struct nlmsghdr;
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
 
 int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data);
+int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, const char *filename);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 86dbc17..1f53acd 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -48,6 +48,7 @@ struct nlmsghdr;
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
 
 int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const char *data);
+int nft_rule_fparse(struct nft_rule *r, enum nft_parse_type type, const char *filename);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index 1ec3059..210da80 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -31,6 +31,7 @@ void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
 const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type, const char *data);
+int nft_ruleset_fparse(struct nft_ruleset *rs, enum nft_parse_type type, const char *filename);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 13ac857..c27e8b0 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -61,6 +61,7 @@ struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter);
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
 
 int nft_set_parse(struct nft_set *s, enum nft_parse_type type, const char *data);
+int nft_set_fparse(struct nft_set *s, enum nft_parse_type type, const char *filename);
 
 /*
  * Set elements
@@ -99,6 +100,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type, const char *data);
+int nft_set_elem_fparse(struct nft_set_elem *e, enum nft_parse_type type, const char *filename);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 1d2be07..562b955 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -41,6 +41,7 @@ struct nlmsghdr;
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t);
 
 int nft_table_parse(struct nft_table *t, enum nft_parse_type type, const char *data);
+int nft_table_fparse(struct nft_table *t, enum nft_parse_type type, const char *filename);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
diff --git a/src/chain.c b/src/chain.c
index a0004b5..aa689d3 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -741,6 +741,21 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
 
+static inline int nft_chain_do_fparse(void *c,
+				      enum nft_parse_type type,
+				      const char *buf)
+{
+	return nft_chain_parse(c, type, buf);
+}
+
+int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type,
+		     const char *filename)
+{
+	return nft_fparse(c, type, filename, nft_chain_do_fparse);
+}
+EXPORT_SYMBOL(nft_chain_fparse);
+
+
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
diff --git a/src/internal.h b/src/internal.h
index a10d874..5dcbc4e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -91,8 +91,14 @@ int nft_str2verdict(const char *verdict);
 int nft_get_value(enum nft_type type, void *val, void *out);
 
 #include <stdio.h>
-int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <fcntl.h>
 
+#include <libnftables/common.h>
+int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+int nft_fparse(void *obj, enum nft_parse_type type, const char *filename, int (*parse_cb)(void *obj, enum nft_parse_type type, const char *data));
 void xfree(const void *ptr);
 
 struct expr_ops;
diff --git a/src/libnftables.map b/src/libnftables.map
index 7dc9aee..eb5ed5c 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -13,6 +13,7 @@ global:
   nft_table_attr_get_u32;
   nft_table_attr_get_str;
   nft_table_parse;
+  nft_table_fparse;
   nft_table_snprintf;
   nft_table_fprintf;
   nft_table_nlmsg_build_payload;
@@ -45,6 +46,7 @@ global:
   nft_chain_attr_get_u64;
   nft_chain_attr_get_str;
   nft_chain_parse;
+  nft_chain_fparse;
   nft_chain_snprintf;
   nft_chain_fprintf;
   nft_chain_nlmsg_build_payload;
@@ -74,6 +76,7 @@ global:
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
   nft_rule_parse;
+  nft_rule_fparse;
   nft_rule_snprintf;
   nft_rule_fprintf;
   nft_rule_nlmsg_build_payload;
@@ -128,6 +131,7 @@ global:
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
+  nft_set_fparse;
   nft_set_snprintf;
   nft_set_fprintf;
 
@@ -159,6 +163,7 @@ global:
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
+  nft_set_elem_fparse;
   nft_set_elem_snprintf;
   nft_set_elem_fprinf;
 
@@ -179,6 +184,7 @@ global:
   nft_ruleset_attr_set;
   nft_ruleset_attr_get;
   nft_ruleset_parse;
+  nft_ruleset_fparse;
   nft_ruleset_snprintf;
   nft_ruleset_fprintf;
 
diff --git a/src/rule.c b/src/rule.c
index 280350a..863c436 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -659,6 +659,20 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_rule_parse);
 
+static inline int nft_rule_do_fparse(void *r,
+				     enum nft_parse_type type,
+				     const char *buf)
+{
+	return nft_rule_parse(r, type, buf);
+}
+
+int nft_rule_fparse(struct nft_rule *r, enum nft_parse_type type,
+		    const char *filename)
+{
+	return nft_fparse(r, type, filename, nft_rule_do_fparse);
+}
+EXPORT_SYMBOL(nft_rule_fparse);
+
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 					 uint32_t type, uint32_t flags)
 {
diff --git a/src/ruleset.c b/src/ruleset.c
index f591382..7194b02 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -579,6 +579,20 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
+static inline int nft_ruleset_do_fparse(void *rs,
+					enum nft_parse_type type,
+					const char *buf)
+{
+	return nft_ruleset_parse(rs, type, buf);
+}
+
+int nft_ruleset_fparse(struct nft_ruleset *rs, enum nft_parse_type type,
+		       const char *filename)
+{
+	return nft_fparse(rs, type, filename, nft_ruleset_do_fparse);
+}
+EXPORT_SYMBOL(nft_ruleset_fparse);
+
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
diff --git a/src/set.c b/src/set.c
index c5204cc..43dd489 100644
--- a/src/set.c
+++ b/src/set.c
@@ -516,6 +516,20 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_set_parse);
 
+static inline int nft_set_do_fparse(void *s,
+				    enum nft_parse_type type,
+				    const char *buf)
+{
+	return nft_set_parse(s, type, buf);
+}
+
+int nft_set_fparse(struct nft_set *s, enum nft_parse_type type,
+		   const char *filename)
+{
+	return nft_fparse(s, type, filename, nft_set_do_fparse);
+}
+EXPORT_SYMBOL(nft_set_fparse);
+
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 				  uint32_t type, uint32_t flags)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index fce9c1d..9724142 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -430,6 +430,20 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 }
 EXPORT_SYMBOL(nft_set_elem_parse);
 
+static inline int nft_set_elem_do_fparse(void *e,
+					 enum nft_parse_type type,
+					 const char *buf)
+{
+	return nft_set_elem_parse(e, type, buf);
+}
+
+int nft_set_elem_fparse(struct nft_set_elem *e, enum nft_parse_type type,
+			const char *filename)
+{
+	return nft_fparse(e, type, filename, nft_set_elem_do_fparse);
+}
+EXPORT_SYMBOL(nft_set_elem_fparse);
+
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
 				      struct nft_set_elem *e, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index ba84264..4cf047d 100644
--- a/src/table.c
+++ b/src/table.c
@@ -357,6 +357,20 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_table_parse);
 
+static inline int nft_table_do_fparse(void *t,
+				      enum nft_parse_type type,
+				      const char *buf)
+{
+	return nft_table_parse(t, type, buf);
+}
+
+int nft_table_fparse(struct nft_table *t, enum nft_parse_type type,
+		     const char *filename)
+{
+	return nft_fparse(t, type, filename, nft_table_do_fparse);
+}
+EXPORT_SYMBOL(nft_table_fparse);
+
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
diff --git a/src/utils.c b/src/utils.c
index 2415917..713541d 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <unistd.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -201,3 +202,36 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 
 	return ret;
 }
+
+int nft_fparse(void *obj, enum nft_parse_type type, const char *filename,
+	       int (*parse_cb)(void *obj, enum nft_parse_type type,
+			       const char *data))
+{
+	char *buf;
+	struct stat s;
+	int fd, ret;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	fstat(fd, &s);
+	buf = mmap(0, s.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+
+	if (buf == (void *)-1)
+		goto err;
+
+	ret = parse_cb(obj, type, buf);
+	if (ret < 0)
+		goto err_unmap;
+
+	munmap(buf, s.st_size);
+	close(fd);
+	return ret;
+
+err_unmap:
+	munmap(buf, s.st_size);
+err:
+	close(fd);
+	return -1;
+}

