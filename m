Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C10C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26B222D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHUJ0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:26:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43742 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUJ0N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:26:13 -0400
Received: from localhost ([::1]:56832 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i0Msd-00053R-CL; Wed, 21 Aug 2019 11:26:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/14] nft: Eliminate pointless calls to nft_family_ops_lookup()
Date:   Wed, 21 Aug 2019 11:25:52 +0200
Message-Id: <20190821092602.16292-5-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190821092602.16292-1-phil@nwl.cc>
References: <20190821092602.16292-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nft_handle is available, use its 'ops' field instead of performing a
new lookup. For the same reason, there is no need to pass ops pointer to
__nft_print_header().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 458dededaca29..28e63aad15878 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1663,11 +1663,8 @@ static const char *policy_name[NF_ACCEPT+1] = {
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list)
 {
 	struct nftnl_chain_list_iter *iter;
-	struct nft_family_ops *ops;
 	struct nftnl_chain *c;
 
-	ops = nft_family_ops_lookup(h->family);
-
 	iter = nftnl_chain_list_iter_create(list);
 	if (iter == NULL)
 		return 0;
@@ -1693,8 +1690,8 @@ int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list)
 			}
 		}
 
-		if (ops->save_chain)
-			ops->save_chain(c, policy);
+		if (h->ops->save_chain)
+			h->ops->save_chain(c, policy);
 
 		c = nftnl_chain_list_iter_next(iter);
 	}
@@ -2484,7 +2481,6 @@ static int nft_rule_count(struct nft_handle *h, struct nftnl_chain *c)
 }
 
 static void __nft_print_header(struct nft_handle *h,
-			       const struct nft_family_ops *ops,
 			       struct nftnl_chain *c, unsigned int format)
 {
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
@@ -2500,14 +2496,13 @@ static void __nft_print_header(struct nft_handle *h,
 	if (nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY))
 		pname = policy_name[nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY)];
 
-	ops->print_header(format, chain_name, pname,
+	h->ops->print_header(format, chain_name, pname,
 			&ctrs, basechain, refs - entries, entries);
 }
 
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		  int rulenum, unsigned int format)
 {
-	const struct nft_family_ops *ops;
 	struct nftnl_chain_list *list;
 	struct nftnl_chain_list_iter *iter;
 	struct nftnl_chain *c;
@@ -2515,8 +2510,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_xt_builtin_init(h, table);
 
-	ops = nft_family_ops_lookup(h->family);
-
 	if (!nft_is_table_compatible(h, table)) {
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
 		return 0;
@@ -2532,11 +2525,11 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 			return 0;
 
 		if (!rulenum) {
-			if (ops->print_table_header)
-				ops->print_table_header(table);
-			__nft_print_header(h, ops, c, format);
+			if (h->ops->print_table_header)
+				h->ops->print_table_header(table);
+			__nft_print_header(h, c, format);
 		}
-		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
+		__nft_rule_list(h, c, rulenum, format, h->ops->print_rule);
 		return 1;
 	}
 
@@ -2544,16 +2537,16 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (iter == NULL)
 		return 0;
 
-	if (ops->print_table_header)
-		ops->print_table_header(table);
+	if (h->ops->print_table_header)
+		h->ops->print_table_header(table);
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c != NULL) {
 		if (found)
 			printf("\n");
 
-		__nft_print_header(h, ops, c, format);
-		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
+		__nft_print_header(h, c, format);
+		__nft_rule_list(h, c, rulenum, format, h->ops->print_rule);
 
 		found = true;
 		c = nftnl_chain_list_iter_next(iter);
-- 
2.22.0

