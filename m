From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] src: add nft_*_build_msg functions
Date: Tue, 06 May 2014 22:19:36 +0200
Message-ID: <20140506201936.18158.83354.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60539 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755173AbaEFUTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions are likely to be used by all userspace programs to interact
with the nftables kernel subsystem.

Lets put in the library.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/chain.h |    2 ++
 include/libnftnl/rule.h  |    2 ++
 include/libnftnl/set.h   |    4 ++++
 include/libnftnl/table.h |    2 ++
 src/chain.c              |   11 +++++++++++
 src/libnftnl.map         |    8 ++++++++
 src/rule.c               |   11 +++++++++++
 src/set.c                |   11 +++++++++++
 src/set_elem.c           |   11 +++++++++++
 src/table.c              |   11 +++++++++++
 10 files changed, 73 insertions(+)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index c11cb5e..eecc7e9 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -56,6 +56,8 @@ uint64_t nft_chain_attr_get_u64(struct nft_chain *c, uint16_t attr);
 struct nlmsghdr;
 
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
+void nft_chain_build_msg(struct nft_chain *c, void *buf, uint16_t msg,
+			 unsigned int flags, uint32_t seq);
 
 int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 		    const char *data, struct nft_parse_err *err);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 62dba59..2412ce1 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -53,6 +53,8 @@ void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr);
 struct nlmsghdr;
 
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
+void nft_rule_build_msg(struct nft_rule *r, void *buf, uint16_t msg,
+			unsigned int flags, uint32_t seq);
 
 int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 		   const char *data, struct nft_parse_err *err);
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index a975f1c..e7e267a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -44,6 +44,8 @@ struct nlmsghdr;
 
 #define nft_set_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
+void nft_set_build_msg(struct nft_set *s, void *buf, uint16_t msg,
+		       unsigned int flags, uint32_t seq);
 int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s);
 
@@ -104,6 +106,8 @@ bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
 #define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem *e);
+void nft_set_elems_build_msg(struct nft_set *s, void *buf, uint16_t msg,
+			     unsigned int flags, uint32_t seq);
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
 		       const char *data, struct nft_parse_err *err);
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index fac79e7..cb4d06e 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -45,6 +45,8 @@ const char *nft_table_attr_get_str(struct nft_table *t, uint16_t attr);
 struct nlmsghdr;
 
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t);
+void nft_table_build_msg(struct nft_table *t, void *buf, uint16_t msg,
+			 unsigned int flags, uint32_t seq);
 
 int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 		    const char *data, struct nft_parse_err *err);
diff --git a/src/chain.c b/src/chain.c
index 5311af6..3c9ace7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -372,6 +372,17 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_build_payload);
 
+void nft_chain_build_msg(struct nft_chain *c, void *buf, uint16_t msg,
+			 unsigned int flags, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	uint32_t family = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, msg, family, flags, seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
+}
+EXPORT_SYMBOL(nft_chain_build_msg);
+
 static int nft_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index b11db67..019eb6c 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -206,3 +206,11 @@ LIBNFTNL_1.1 {
   nft_set_attr_set_data;
   nft_set_attr_get_data;
 } LIBNFTNL_1.0;
+
+LIBNFTNL_1.2 {
+  nft_table_build_msg;
+  nft_chain_build_msg;
+  nft_rule_build_msg;
+  nft_set_build_msg;
+  nft_set_elems_build_msg;
+} LIBNFTNL_1.1;
diff --git a/src/rule.c b/src/rule.c
index ac88abb..0c8e0d6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -315,6 +315,17 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_build_payload);
 
+void nft_rule_build_msg(struct nft_rule *r, void *buf, uint16_t msg,
+			unsigned int flags, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	uint32_t family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
+
+	nlh = nft_rule_nlmsg_build_hdr(buf, msg, family, flags, seq);
+	nft_rule_nlmsg_build_payload(nlh, r);
+}
+EXPORT_SYMBOL(nft_rule_build_msg);
+
 void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr)
 {
 	list_add_tail(&expr->head, &r->expr_list);
diff --git a/src/set.c b/src/set.c
index 7c15857..417a3fe 100644
--- a/src/set.c
+++ b/src/set.c
@@ -245,6 +245,17 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
 
+void nft_set_build_msg(struct nft_set *s, void *buf, uint16_t msg,
+		       unsigned int flags, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	uint32_t family = nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
+
+	nlh = nft_set_nlmsg_build_hdr(buf, msg, family, flags, seq);
+	nft_set_nlmsg_build_payload(nlh, s);
+}
+EXPORT_SYMBOL(nft_set_build_msg);
+
 static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
diff --git a/src/set_elem.c b/src/set_elem.c
index 1eddce2..b4f4a5a 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -220,6 +220,17 @@ void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload);
 
+void nft_set_elems_build_msg(struct nft_set *s, void *buf, uint16_t msg,
+			     unsigned int flags, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	uint32_t family = nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
+
+	nlh = nft_set_nlmsg_build_hdr(buf, msg, family, flags, seq);
+	nft_set_elems_nlmsg_build_payload(nlh, s);
+}
+EXPORT_SYMBOL(nft_set_elems_build_msg);
+
 static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
diff --git a/src/table.c b/src/table.c
index b4d1663..a63bf64 100644
--- a/src/table.c
+++ b/src/table.c
@@ -196,6 +196,17 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 }
 EXPORT_SYMBOL(nft_table_nlmsg_build_payload);
 
+void nft_table_build_msg(struct nft_table *t, void *buf, uint16_t msg,
+			 unsigned int flags, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	uint32_t family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
+
+	nlh = nft_table_nlmsg_build_hdr(buf, msg, family, flags, seq);
+	nft_table_nlmsg_build_payload(nlh, t);
+}
+EXPORT_SYMBOL(nft_table_build_msg);
+
 static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;

