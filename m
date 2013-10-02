From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH] src: add function nft_rule_nlmsg_build_id
Date: Thu,  3 Oct 2013 01:14:52 +0200
Message-ID: <1380755692-17878-1-git-send-email-eric@regit.org>
References: <1380755553.6862.32.camel@tiger2>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50417 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3JBXPQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:15:16 -0400
In-Reply-To: <1380755553.6862.32.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new function nft_rule_nlmsg_build_id which can
be used to only dump the identifiers of a rule to the netlink
message. This allow to limit the size of the messages when doing
some deletion operation where the other parameters are not used.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/libnftables/rule.h |  1 +
 src/libnftables.map        |  1 +
 src/rule.c                 | 14 ++++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9fba9c8..08c9cc4 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -40,6 +40,7 @@ uint64_t nft_rule_attr_get_u64(const struct nft_rule *r, uint16_t attr);
 
 void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr);
 
+void nft_rule_nlmsg_build_id(struct nlmsghdr *nlh, struct nft_rule *t);
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
 
 enum {
diff --git a/src/libnftables.map b/src/libnftables.map
index 1223403..e6cd12c 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -72,6 +72,7 @@ global:
   nft_rule_parse;
   nft_rule_snprintf;
   nft_rule_nlmsg_build_hdr;
+  nft_rule_nlmsg_build_id;
   nft_rule_nlmsg_build_payload;
   nft_rule_nlmsg_parse;
   nft_rule_add_expr;
diff --git a/src/rule.c b/src/rule.c
index 7f2bce6..f9861da 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -248,11 +248,8 @@ nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_build_hdr);
 
-void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
+void nft_rule_nlmsg_build_id(struct nlmsghdr *nlh, struct nft_rule *r)
 {
-	struct nft_rule_expr *expr;
-	struct nlattr *nest;
-
 	if (r->flags & (1 << NFT_RULE_ATTR_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, r->table);
 	if (r->flags & (1 << NFT_RULE_ATTR_CHAIN))
@@ -261,6 +258,15 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
 		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(r->handle));
 	if (r->flags & (1 << NFT_RULE_ATTR_POSITION))
 		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
+}
+EXPORT_SYMBOL(nft_rule_nlmsg_build_id);
+
+void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *r)
+{
+	struct nft_rule_expr *expr;
+	struct nlattr *nest;
+
+	nft_rule_nlmsg_build_id(nlh, r);
 
 	if (!list_empty(&r->expr_list)) {
 		nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
-- 
1.8.4.rc3

