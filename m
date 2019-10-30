Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10EECA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6502087E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJ3R1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:27:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45120 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfJ3R1V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:27:21 -0400
Received: from localhost ([::1]:58210 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPrke-0007mS-7n; Wed, 30 Oct 2019 18:27:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 06/12] nft: Eliminate pointless calls to nft_family_ops_lookup()
Date:   Wed, 30 Oct 2019 18:26:55 +0100
Message-Id: <20191030172701.5892-7-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030172701.5892-1-phil@nwl.cc>
References: <20191030172701.5892-1-phil@nwl.cc>
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
 iptables/nft.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6a8eafd1938ca..547bc5f0aaad0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1336,12 +1336,10 @@ static const char *policy_name[NF_ACCEPT+1] = {
 
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list)
 {
+	struct nft_family_ops *ops = h->ops;
 	struct nftnl_chain_list_iter *iter;
-	struct nft_family_ops *ops;
 	struct nftnl_chain *c;
 
-	ops = nft_family_ops_lookup(h->family);
-
 	iter = nftnl_chain_list_iter_create(list);
 	if (iter == NULL)
 		return 0;
@@ -2165,7 +2163,6 @@ static int nft_rule_count(struct nft_handle *h, struct nftnl_chain *c)
 }
 
 static void __nft_print_header(struct nft_handle *h,
-			       const struct nft_family_ops *ops,
 			       struct nftnl_chain *c, unsigned int format)
 {
 	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
@@ -2181,14 +2178,14 @@ static void __nft_print_header(struct nft_handle *h,
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
+	const struct nft_family_ops *ops = h->ops;
 	struct nftnl_chain_list *list;
 	struct nftnl_chain_list_iter *iter;
 	struct nftnl_chain *c;
@@ -2197,8 +2194,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	nft_xt_builtin_init(h, table);
 	nft_assert_table_compatible(h, table, chain);
 
-	ops = nft_family_ops_lookup(h->family);
-
 	list = nft_chain_list_get(h, table, chain);
 	if (!list)
 		return 0;
@@ -2211,7 +2206,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (!rulenum) {
 			if (ops->print_table_header)
 				ops->print_table_header(table);
-			__nft_print_header(h, ops, c, format);
+			__nft_print_header(h, c, format);
 		}
 		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
 		return 1;
@@ -2229,7 +2224,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (found)
 			printf("\n");
 
-		__nft_print_header(h, ops, c, format);
+		__nft_print_header(h, c, format);
 		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
 
 		found = true;
-- 
2.23.0

