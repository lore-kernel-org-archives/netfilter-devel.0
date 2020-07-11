Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B230FC433E6
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9910220725
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGKKUU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgGKKUU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:20:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7933C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:20:19 -0700 (PDT)
Received: from localhost ([::1]:59522 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCcE-0007Kx-1T; Sat, 11 Jul 2020 12:20:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/18] nft: Turn nft_chain_save() into a foreach-callback
Date:   Sat, 11 Jul 2020 12:18:18 +0200
Message-Id: <20200711101831.29506-6-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let nftnl_chain_list_foreach() do the chain list iterating instead of
open-coding it. While being at it, simplify the policy value selection
code as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c          | 47 +++++++++++------------------------------
 iptables/nft.h          |  2 +-
 iptables/xtables-save.c |  2 +-
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e3811f5fb20b0..c6cfecda1846a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1558,46 +1558,23 @@ static const char *policy_name[NF_ACCEPT+1] = {
 	[NF_ACCEPT] = "ACCEPT",
 };
 
-int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list)
+int nft_chain_save(struct nftnl_chain *c, void *data)
 {
-	struct nft_family_ops *ops = h->ops;
-	struct nftnl_chain_list_iter *iter;
-	struct nftnl_chain *c;
-
-	iter = nftnl_chain_list_iter_create(list);
-	if (iter == NULL)
-		return 0;
-
-	c = nftnl_chain_list_iter_next(iter);
-	while (c != NULL) {
-		const char *policy = NULL;
-
-		if (nft_chain_builtin(c)) {
-			uint32_t pol = NF_ACCEPT;
-
-			if (nftnl_chain_get(c, NFTNL_CHAIN_POLICY))
-				pol = nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY);
-			policy = policy_name[pol];
-		} else if (h->family == NFPROTO_BRIDGE) {
-			if (nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY)) {
-				uint32_t pol;
-
-				pol = nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY);
-				policy = policy_name[pol];
-			} else {
-				policy = "RETURN";
-			}
-		}
-
-		if (ops->save_chain)
-			ops->save_chain(c, policy);
+	struct nft_handle *h = data;
+	const char *policy = NULL;
 
-		c = nftnl_chain_list_iter_next(iter);
+	if (nftnl_chain_is_set(c, NFTNL_CHAIN_POLICY)) {
+		policy = policy_name[nftnl_chain_get_u32(c, NFTNL_CHAIN_POLICY)];
+	} else if (nft_chain_builtin(c)) {
+		policy = "ACCEPT";
+	} else if (h->family == NFPROTO_BRIDGE) {
+		policy = "RETURN";
 	}
 
-	nftnl_chain_list_iter_destroy(iter);
+	if (h->ops->save_chain)
+		h->ops->save_chain(c, policy);
 
-	return 1;
+	return 0;
 }
 
 static int nft_chain_save_rules(struct nft_handle *h,
diff --git a/iptables/nft.h b/iptables/nft.h
index bd944f441caf1..fd390e7f90765 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -142,7 +142,7 @@ const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const c
 struct nftnl_chain;
 
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
-int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
+int nft_chain_save(struct nftnl_chain *c, void *data);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index bb3d8cd336c38..92b0c911c5f1c 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -92,7 +92,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	printf("*%s\n", tablename);
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
-	nft_chain_save(h, chain_list);
+	nftnl_chain_list_foreach(chain_list, nft_chain_save, h);
 	nft_rule_save(h, tablename, d->format);
 	if (d->commit)
 		printf("COMMIT\n");
-- 
2.27.0

