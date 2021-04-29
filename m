Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D85C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E3D61460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhD2Xny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59542 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 08B856413C
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 09/18] cache: add set_cache_del() and use it
Date:   Fri, 30 Apr 2021 01:42:46 +0200
Message-Id: <20210429234255.16840-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update set_cache_del() from the monitor path to remove sets
in the cache.

Fixes: df48e56e987f ("cache: add hashtable cache for sets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 1 +
 src/cache.c     | 5 +++++
 src/monitor.c   | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/cache.h b/include/cache.h
index 992f993c0667..f5b4876a4d40 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -70,6 +70,7 @@ struct chain;
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table, const char *name);
 void set_cache_add(struct set *set, struct table *table);
+void set_cache_del(struct set *set);
 struct set *set_cache_find(const struct table *table, const char *name);
 
 struct cache {
diff --git a/src/cache.c b/src/cache.c
index 1aec12666d52..03b781bb4834 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -319,6 +319,11 @@ void set_cache_add(struct set *set, struct table *table)
 	cache_add(&set->cache, &table->set_cache, hash);
 }
 
+void set_cache_del(struct set *set)
+{
+	cache_del(&set->cache);
+}
+
 struct set *set_cache_find(const struct table *table, const char *name)
 {
 	struct set *set;
diff --git a/src/monitor.c b/src/monitor.c
index ae288f6cb212..00cf7d135034 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -687,7 +687,7 @@ out:
 static void netlink_events_cache_delset_cb(struct set *s,
 					   void *data)
 {
-	list_del(&s->list);
+	set_cache_del(s);
 	set_free(s);
 }
 
-- 
2.20.1

