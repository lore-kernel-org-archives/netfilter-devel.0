From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] netfilter: xt_recent: save 8 bytes per htable
Date: Sat,  5 Dec 2009 21:26:22 +0100
Message-ID: <1260044785-20962-2-git-send-email-jengelh@medozas.de>
References: <1260044785-20962-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54529 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757735AbZLEU0V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:26:21 -0500
In-Reply-To: <1260044785-20962-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moving rnd_inited into the hole after the uint8 lets go of the uint32
rnd_inited was using, plus the padding that would follow the int group.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_hashlimit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index dd16e40..5bdc1fb 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -81,13 +81,13 @@ struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
 	atomic_t use;
 	u_int8_t family;
+	bool rnd_initialized;
 
 	struct hashlimit_cfg1 cfg;	/* config */
 
 	/* used internally */
 	spinlock_t lock;		/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
-	int rnd_initialized;
 	unsigned int count;		/* number entries in table */
 	struct timer_list timer;	/* timer for gc */
 
@@ -150,7 +150,7 @@ dsthash_alloc_init(struct xt_hashlimit_htable *ht,
 	 * the first hashtable entry */
 	if (!ht->rnd_initialized) {
 		get_random_bytes(&ht->rnd, sizeof(ht->rnd));
-		ht->rnd_initialized = 1;
+		ht->rnd_initialized = true;
 	}
 
 	if (ht->cfg.max && ht->count >= ht->cfg.max) {
@@ -235,7 +235,7 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, u_int8_t family)
 	atomic_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
-	hinfo->rnd_initialized = 0;
+	hinfo->rnd_initialized = false;
 	spin_lock_init(&hinfo->lock);
 	hinfo->pde = proc_create_data(minfo->name, 0,
 		(family == NFPROTO_IPV4) ?
@@ -296,7 +296,7 @@ static int htable_create(struct xt_hashlimit_mtinfo1 *minfo, u_int8_t family)
 	atomic_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
-	hinfo->rnd_initialized = 0;
+	hinfo->rnd_initialized = false;
 	spin_lock_init(&hinfo->lock);
 
 	hinfo->pde = proc_create_data(minfo->name, 0,
-- 
1.6.5.3

