Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27E7C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E518206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgD1MLM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MLM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:11:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F246EC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:11:11 -0700 (PDT)
Received: from localhost ([::1]:38662 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4w-00087u-QK; Tue, 28 Apr 2020 14:11:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 18/18] nft: Fix for '-F' in iptables dumps
Date:   Tue, 28 Apr 2020 14:10:13 +0200
Message-Id: <20200428121013.24507-19-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When restoring a dump which contains an explicit flush command,
previously added rules are removed from cache and the following commit
will try to create netlink messages based on freed memory.

Fix this by weeding any rule-based commands from obj_list if they
address the same chain.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 67b8466b50692..d2796fcd8ad26 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -402,6 +402,38 @@ batch_rule_add(struct nft_handle *h, enum obj_update_type type,
 	return batch_add(h, type, r);
 }
 
+static void batch_obj_del(struct nft_handle *h, struct obj_update *o);
+
+static void batch_chain_flush(struct nft_handle *h,
+			      const char *table, const char *chain)
+{
+	struct obj_update *obj, *tmp;
+
+	list_for_each_entry_safe(obj, tmp, &h->obj_list, head) {
+		struct nftnl_rule *r = obj->ptr;
+
+		switch (obj->type) {
+		case NFT_COMPAT_RULE_APPEND:
+		case NFT_COMPAT_RULE_INSERT:
+		case NFT_COMPAT_RULE_REPLACE:
+		case NFT_COMPAT_RULE_DELETE:
+			break;
+		default:
+			continue;
+		}
+
+		if (table &&
+		    strcmp(table, nftnl_rule_get_str(r, NFTNL_RULE_TABLE)))
+			continue;
+
+		if (chain &&
+		    strcmp(chain, nftnl_rule_get_str(r, NFTNL_RULE_CHAIN)))
+			continue;
+
+		batch_obj_del(h, obj);
+	}
+}
+
 const struct builtin_table xtables_ipv4[NFT_TABLE_MAX] = {
 	[NFT_TABLE_RAW] = {
 		.name	= "raw",
@@ -1681,6 +1713,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	}
 
 	if (chain || !verbose) {
+		batch_chain_flush(h, table, chain);
 		__nft_rule_flush(h, table, chain, verbose, false);
 		flush_rule_cache(h, table, c);
 		return 1;
@@ -1696,6 +1729,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	while (c != NULL) {
 		chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 
+		batch_chain_flush(h, table, chain);
 		__nft_rule_flush(h, table, chain, verbose, false);
 		flush_rule_cache(h, table, c);
 		c = nftnl_chain_list_iter_next(iter);
-- 
2.25.1

