Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F303BC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB381208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgEFReY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFReY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EFFC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:24 -0700 (PDT)
Received: from localhost ([::1]:58738 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNw6-0002lh-U5; Wed, 06 May 2020 19:34:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/15] nft: Avoid use-after-free when rebuilding cache
Date:   Wed,  6 May 2020 19:33:19 +0200
Message-Id: <20200506173331.9347-4-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By the time nft_action() decides to rebuild the cache, nft_cmd structs
have been freed already and therefore table and chain names in
nft_cache_req point to invalid memory.

Fix this by duplicating the strings and freeing them when releasing the
cache.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 14 ++++++++++----
 iptables/nft.h       |  4 ++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 83af9a2f689e1..84ea97d3e54a6 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -39,7 +39,7 @@ static void cache_chain_list_insert(struct list_head *list, const char *name)
 	}
 
 	new = xtables_malloc(sizeof(*new));
-	new->name = name;
+	new->name = strdup(name);
 	list_add_tail(&new->head, pos ? &pos->head : list);
 }
 
@@ -54,7 +54,10 @@ void nft_cache_level_set(struct nft_handle *h, int level,
 	if (!cmd || !cmd->table || req->all_chains)
 		return;
 
-	req->table = cmd->table;
+	if (!req->table)
+		req->table = strdup(cmd->table);
+	else
+		assert(!strcmp(req->table, cmd->table));
 
 	if (!cmd->chain) {
 		req->all_chains = true;
@@ -663,11 +666,14 @@ void nft_release_cache(struct nft_handle *h)
 
 	if (req->level != NFT_CL_FAKE)
 		req->level = NFT_CL_TABLES;
-	req->table = NULL;
-
+	if (req->table) {
+		free(req->table);
+		req->table = NULL;
+	}
 	req->all_chains = false;
 	list_for_each_entry_safe(cc, cc_tmp, &req->chain_list, head) {
 		list_del(&cc->head);
+		free(cc->name);
 		free(cc);
 	}
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 045393da7c179..aeacc608fcb9f 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -73,12 +73,12 @@ enum obj_update_type {
 
 struct cache_chain {
 	struct list_head head;
-	const char *name;
+	char *name;
 };
 
 struct nft_cache_req {
 	enum nft_cache_level	level;
-	const char		*table;
+	char			*table;
 	bool			all_chains;
 	struct list_head	chain_list;
 };
-- 
2.25.1

