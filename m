From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] src: fix memory leaks at nft_[object]_nlmsg_parse
Date: Wed,  5 Aug 2015 12:23:34 +0200
Message-ID: <1438770214-3064-1-git-send-email-carlosfg@riseup.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:57370 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbbHEKX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2015 06:23:57 -0400
Received: from piha.riseup.net (unknown [10.0.1.162])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id 7DB1940CC3
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2015 10:23:57 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free object attributes before overwrite it. Fix 'nlmsg_parse' methods of
following objects: 'table', 'chain', 'rule', 'set' and 'set_element'.
---
 src/chain.c    | 2 ++
 src/rule.c     | 2 ++
 src/set.c      | 2 ++
 src/set_elem.c | 2 ++
 src/table.c    | 1 +
 5 files changed, 9 insertions(+)

diff --git a/src/chain.c b/src/chain.c
index ed9d9e4..4f9c6b7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -534,6 +534,7 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 		c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
 	}
 	if (tb[NFTA_CHAIN_TABLE]) {
+		xfree(c->table);
 		c->table = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
 	}
@@ -560,6 +561,7 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 		c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
 	}
 	if (tb[NFTA_CHAIN_TYPE]) {
+		xfree(c->type);
 		c->type = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_TYPE);
 	}
diff --git a/src/rule.c b/src/rule.c
index 04088ed..ebaa3ed 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -425,10 +425,12 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 		return -1;
 
 	if (tb[NFTA_RULE_TABLE]) {
+		xfree(r->table);
 		r->table = strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
 		r->flags |= (1 << NFT_RULE_ATTR_TABLE);
 	}
 	if (tb[NFTA_RULE_CHAIN]) {
+		xfree(r->chain);
 		r->chain = strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
 		r->flags |= (1 << NFT_RULE_ATTR_CHAIN);
 	}
diff --git a/src/set.c b/src/set.c
index b07c4d9..1782f72 100644
--- a/src/set.c
+++ b/src/set.c
@@ -435,10 +435,12 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		return -1;
 
 	if (tb[NFTA_SET_TABLE]) {
+		xfree(s->table);
 		s->table = strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
 		s->flags |= (1 << NFT_SET_ATTR_TABLE);
 	}
 	if (tb[NFTA_SET_NAME]) {
+		xfree(s->name);
 		s->name = strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
 		s->flags |= (1 << NFT_SET_ATTR_NAME);
 	}
diff --git a/src/set_elem.c b/src/set_elem.c
index 3a799dc..643dd76 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -462,11 +462,13 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		return -1;
 
 	if (tb[NFTA_SET_ELEM_LIST_TABLE]) {
+		xfree(s->table);
 		s->table =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
 		s->flags |= (1 << NFT_SET_ATTR_TABLE);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET]) {
+		xfree(s->name);
 		s->name =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
 		s->flags |= (1 << NFT_SET_ATTR_NAME);
diff --git a/src/table.c b/src/table.c
index ab0a8ea..09470e0 100644
--- a/src/table.c
+++ b/src/table.c
@@ -229,6 +229,7 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 		return -1;
 
 	if (tb[NFTA_TABLE_NAME]) {
+		xfree(t->name);
 		t->name = strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
 		t->flags |= (1 << NFT_TABLE_ATTR_NAME);
 	}
-- 
2.4.6

