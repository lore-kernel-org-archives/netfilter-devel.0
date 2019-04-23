Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB00C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BF820645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfDWNWa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:30 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57318 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:30 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNT-0000pe-W6; Tue, 23 Apr 2019 15:22:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 3/6] xtables: add and use nft_build_cache
Date:   Tue, 23 Apr 2019 15:16:22 +0200
Message-Id: <20190423131625.23377-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Will be used with the "generation id" infrastructure.
When we're told that the commit failed because someone else made
changes, we can use this to re-initialize the cache and then
revalidate the transaction list (e.g. to detect that we now have
to flush the user-defined chain 'foo' that we wanted to create, but
was added just now by someone else).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c             | 28 +++++++++++++++++++++++-----
 iptables/nft.h             |  2 ++
 iptables/xtables-restore.c |  5 +----
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 1cef7a13c90d..4c9ce1a29383 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1486,6 +1486,28 @@ static int fetch_rule_cache(struct nft_handle *h)
 	return 0;
 }
 
+static void __nft_build_cache(struct nft_handle *h)
+{
+	fetch_chain_cache(h);
+	fetch_rule_cache(h);
+	h->have_cache = true;
+}
+
+
+void nft_build_cache(struct nft_handle *h)
+{
+	if (!h->have_cache)
+		__nft_build_cache(h);
+}
+
+void nft_rebuild_cache(struct nft_handle *h)
+{
+	if (!h->have_cache)
+		flush_chain_cache(h, NULL);
+
+	__nft_build_cache(h);
+}
+
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 					    const char *table)
 {
@@ -1495,11 +1517,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	if (!h->have_cache) {
-		fetch_chain_cache(h);
-		fetch_rule_cache(h);
-		h->have_cache = true;
-	}
+	nft_build_cache(h);
 
 	return h->table[t->type].chain_cache;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index d428287b46ff..97c28b356a46 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -63,6 +63,8 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     void *data);
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
+void nft_build_cache(struct nft_handle *h);
+void nft_rebuild_cache(struct nft_handle *h);
 
 /*
  * Operations with tables.
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index b12ab6a60b3a..a6a331d39868 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -145,10 +145,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (p->tablename && (strcmp(p->tablename, table) != 0))
 				continue;
 
-			/* Fixme: Needed to init chain cache.
-			 * Should create explicit function to do this.
-			 */
-			nft_chain_list_get(h, table);
+			nft_build_cache(h);
 
 			if (h->noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
-- 
2.21.0

