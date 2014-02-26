From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] src: check if netlink parsing fails
Date: Wed, 26 Feb 2014 19:13:26 +0100
Message-ID: <20140226181326.26149.52163.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54745 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752579AbaBZSNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:13:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to check if mnl_attr_parse() returns an error, which means that it
failed to validate and retrieve the attributes.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c    |   17 +++++++++++++----
 src/rule.c     |    5 ++++-
 src/set.c      |    7 +++++--
 src/set_elem.c |    7 ++++++-
 src/table.c    |    6 +++++-
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 34eb91d..d7a3628 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -447,9 +447,12 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 {
 	struct nlattr *tb[NFTA_CHAIN_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	int ret = 0;
+	int ret;
+
+	ret = mnl_attr_parse(nlh, sizeof(*nfg), nft_chain_parse_attr_cb, tb);
+	if (ret != MNL_CB_OK)
+		return -1;
 
-	mnl_attr_parse(nlh, sizeof(*nfg), nft_chain_parse_attr_cb, tb);
 	if (tb[NFTA_CHAIN_NAME]) {
 		strncpy(c->name, mnl_attr_get_str(tb[NFTA_CHAIN_NAME]),
 			NFT_CHAIN_MAXNAMELEN);
@@ -459,8 +462,11 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 		c->table = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
 	}
-	if (tb[NFTA_CHAIN_HOOK])
+	if (tb[NFTA_CHAIN_HOOK]) {
 		ret = nft_chain_parse_hook(tb[NFTA_CHAIN_HOOK], c);
+		if (ret != 0)
+			return -1;
+	}
 	if (tb[NFTA_CHAIN_POLICY]) {
 		c->policy = ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_POLICY]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
@@ -469,8 +475,11 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 		c->use = ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_USE]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_USE);
 	}
-	if (tb[NFTA_CHAIN_COUNTERS])
+	if (tb[NFTA_CHAIN_COUNTERS]) {
 		ret = nft_chain_parse_counters(tb[NFTA_CHAIN_COUNTERS], c);
+		if (ret != 0)
+			return -1;
+	}
 	if (tb[NFTA_CHAIN_HANDLE]) {
 		c->handle = be64toh(mnl_attr_get_u64(tb[NFTA_CHAIN_HANDLE]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
diff --git a/src/rule.c b/src/rule.c
index 53d2ebf..134ebe2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -412,7 +412,10 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
 	int ret = 0;
 
-	mnl_attr_parse(nlh, sizeof(*nfg), nft_rule_parse_attr_cb, tb);
+	ret = mnl_attr_parse(nlh, sizeof(*nfg), nft_rule_parse_attr_cb, tb);
+	if (ret != MNL_CB_OK)
+		return -1;
+
 	if (tb[NFTA_RULE_TABLE]) {
 		r->table = strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
 		r->flags |= (1 << NFT_RULE_ATTR_TABLE);
diff --git a/src/set.c b/src/set.c
index c3a7fae..81295c8 100644
--- a/src/set.c
+++ b/src/set.c
@@ -244,9 +244,12 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	int ret = 0;
+	int ret;
+
+	ret = mnl_attr_parse(nlh, sizeof(*nfg), nft_set_parse_attr_cb, tb);
+	if (ret != MNL_CB_OK)
+		return -1;
 
-	mnl_attr_parse(nlh, sizeof(*nfg), nft_set_parse_attr_cb, tb);
 	if (tb[NFTA_SET_TABLE]) {
 		s->table = strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
 		s->flags |= (1 << NFT_SET_ATTR_TABLE);
diff --git a/src/set_elem.c b/src/set_elem.c
index 79fc641..3b7d7dc 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -252,7 +252,12 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 	if (e == NULL)
 		return -1;
 
-	mnl_attr_parse_nested(nest, nft_set_elem_parse_attr_cb, tb);
+	ret = mnl_attr_parse_nested(nest, nft_set_elem_parse_attr_cb, tb);
+	if (ret != MNL_CB_OK) {
+		nft_set_elem_free(e);
+		return -1;
+	}
+
 	if (tb[NFTA_SET_ELEM_FLAGS]) {
 		e->set_elem_flags =
 			ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_FLAGS]));
diff --git a/src/table.c b/src/table.c
index c834a4e..aa7d1c9 100644
--- a/src/table.c
+++ b/src/table.c
@@ -205,10 +205,14 @@ static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 
 int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 {
+	int ret;
 	struct nlattr *tb[NFTA_TABLE_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
 
-	mnl_attr_parse(nlh, sizeof(*nfg), nft_table_parse_attr_cb, tb);
+	ret = mnl_attr_parse(nlh, sizeof(*nfg), nft_table_parse_attr_cb, tb);
+	if (ret != MNL_CB_OK)
+		return -1;
+
 	if (tb[NFTA_TABLE_NAME]) {
 		t->name = strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
 		t->flags |= (1 << NFT_TABLE_ATTR_NAME);

