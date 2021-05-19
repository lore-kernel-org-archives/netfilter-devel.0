Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9412C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9490C611C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhESVJY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 17:09:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46800 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhESVJX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 17:09:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2325D6417E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 23:07:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] rule: skip exact matches on fuzzy lookup
Date:   Wed, 19 May 2021 23:07:59 +0200
Message-Id: <20210519210759.264858-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The fuzzy lookup is exercised from the error path, when no object is
found. Remove branch that checks for exact matching since that should
not ever happen.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index dda1718d69ef..dcf1646a9c7c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -215,10 +215,6 @@ struct set *set_lookup_fuzzy(const char *set_name,
 		list_for_each_entry(set, &table->set_cache.list, cache.list) {
 			if (set_is_anonymous(set->flags))
 				continue;
-			if (!strcmp(set->handle.set.name, set_name)) {
-				*t = table;
-				return set;
-			}
 			if (string_misspell_update(set->handle.set.name,
 						   set_name, set, &st))
 				*t = table;
@@ -765,10 +761,6 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
-			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
-				*t = table;
-				return chain;
-			}
 			if (string_misspell_update(chain->handle.chain.name,
 						   h->chain.name, chain, &st))
 				*t = table;
@@ -1174,9 +1166,6 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
-		if (!strcmp(table->handle.table.name, h->table.name))
-			return table;
-
 		string_misspell_update(table->handle.table.name,
 				       h->table.name, table, &st);
 	}
@@ -1728,10 +1717,6 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
-			if (!strcmp(obj->handle.obj.name, obj_name)) {
-				*t = table;
-				return obj;
-			}
 			if (string_misspell_update(obj->handle.obj.name,
 						   obj_name, obj, &st))
 				*t = table;
@@ -2206,10 +2191,6 @@ struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 
 	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(ft, &table->ft_cache.list, cache.list) {
-			if (!strcmp(ft->handle.flowtable.name, ft_name)) {
-				*t = table;
-				return ft;
-			}
 			if (string_misspell_update(ft->handle.flowtable.name,
 						   ft_name, ft, &st))
 				*t = table;
-- 
2.30.2

