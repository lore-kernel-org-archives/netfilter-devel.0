Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35776C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1329B611F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhDONOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:14:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57878 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbhDONN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:13:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 142E263E77
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:09 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 03/10] cache: add set_cache_del() and use it
Date:   Thu, 15 Apr 2021 15:13:23 +0200
Message-Id: <20210415131330.6692-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
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
 src/cache.c     | 6 ++++++
 src/monitor.c   | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/cache.h b/include/cache.h
index 6fa21742503c..d3be4c8a8693 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -60,6 +60,7 @@ void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
 void set_cache_add(struct set *set, struct table *table);
+void set_cache_del(struct set *set);
 struct set *set_cache_find(const struct table *table, const char *name);
 
 void obj_cache_add(struct obj *obj, struct table *table);
diff --git a/src/cache.c b/src/cache.c
index 95b5c46306c3..73c96a17704a 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -324,6 +324,12 @@ void set_cache_add(struct set *set, struct table *table)
 	list_add_tail(&set->cache_list, &table->cache_set);
 }
 
+void set_cache_del(struct set *set)
+{
+	list_del(&set->cache_hlist);
+	list_del(&set->cache_list);
+}
+
 struct set *set_cache_find(const struct table *table, const char *name)
 {
 	struct set *set;
diff --git a/src/monitor.c b/src/monitor.c
index 1f0f8a361fbd..eb887d9344fa 100644
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

