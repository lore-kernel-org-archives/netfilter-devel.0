From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 7/8] conntrackd: use strncpy to set up the cache name
Date: Tue, 18 Aug 2015 19:28:38 +0200
Message-ID: <1439918919-6937-8-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37621 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:41 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is not exposed, but use the strncpy() variant to calm down static code
validators.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 7c41e54..79a024f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -34,7 +34,7 @@ struct cache_feature *cache_feature[CACHE_MAX_FEATURE] = {
 };
 
 struct cache *cache_create(const char *name, enum cache_type type,
-			   unsigned int features, 
+			   unsigned int features,
 			   struct cache_extra *extra,
 			   struct cache_ops *ops)
 {
@@ -53,7 +53,8 @@ struct cache *cache_create(const char *name, enum cache_type type,
 		return NULL;
 	memset(c, 0, sizeof(struct cache));
 
-	strcpy(c->name, name);
+	strncpy(c->name, name, CACHE_MAX_NAMELEN);
+	c->name[CACHE_MAX_NAMELEN - 1] = '\0';
 	c->type = type;
 
 	for (i = 0; i < CACHE_MAX_FEATURE; i++) {
-- 
1.7.10.4

