Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC27C4320A
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFAA61029
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbhHaMPc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240249AbhHaMPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:15:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A461C035424
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:08:05 -0700 (PDT)
Received: from localhost ([::1]:37568 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mL2Yd-0006Vj-PX; Tue, 31 Aug 2021 14:08:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft: Use xtables_{m,c}alloc() everywhere
Date:   Tue, 31 Aug 2021 14:08:30 +0200
Message-Id: <20210831120830.6414-2-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831120830.6414-1-phil@nwl.cc>
References: <20210831120830.6414-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make use of libxtables allocators where sensible to have implicit error
checking. Leave library-internal calls in place to not create unexpected
program exit points for users, apart from xt_xlate_alloc() as that
function called xtables_error() in error case which exits by itself
already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c |  6 +-----
 iptables/nft-cmd.c    |  5 +----
 iptables/nft.c        | 15 +++------------
 iptables/xshared.c    |  8 ++------
 iptables/xtables-eb.c | 14 +++-----------
 libxtables/xtables.c  | 11 ++---------
 6 files changed, 12 insertions(+), 47 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d98fd527d9549..11f3df3582aa5 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -477,11 +477,7 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
 static void parse_watcher(void *object, struct ebt_match **match_list,
 			  bool ismatch)
 {
-	struct ebt_match *m;
-
-	m = calloc(1, sizeof(struct ebt_match));
-	if (m == NULL)
-		xtables_error(OTHER_PROBLEM, "Can't allocate memory");
+	struct ebt_match *m = xtables_calloc(1, sizeof(struct ebt_match));
 
 	if (ismatch)
 		m->u.match = object;
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index a0c76a795e59c..87e66905655d6 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -23,10 +23,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 	struct nftnl_rule *rule;
 	struct nft_cmd *cmd;
 
-	cmd = calloc(1, sizeof(struct nft_cmd));
-	if (!cmd)
-		return NULL;
-
+	cmd = xtables_calloc(1, sizeof(struct nft_cmd));
 	cmd->command = command;
 	cmd->table = xtables_strdup(table);
 	if (chain)
diff --git a/iptables/nft.c b/iptables/nft.c
index a470939db54fb..c9ed38bd29a53 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -362,10 +362,7 @@ static struct obj_update *batch_add(struct nft_handle *h, enum obj_update_type t
 {
 	struct obj_update *obj;
 
-	obj = calloc(1, sizeof(struct obj_update));
-	if (obj == NULL)
-		return NULL;
-
+	obj = xtables_calloc(1, sizeof(struct obj_update));
 	obj->ptr = ptr;
 	obj->error.lineno = h->error.lineno;
 	obj->type = type;
@@ -997,10 +994,7 @@ static int __add_match(struct nftnl_expr *e, struct xt_entry_match *m)
 	nftnl_expr_set(e, NFTNL_EXPR_MT_NAME, m->u.user.name, strlen(m->u.user.name));
 	nftnl_expr_set_u32(e, NFTNL_EXPR_MT_REV, m->u.user.revision);
 
-	info = calloc(1, m->u.match_size);
-	if (info == NULL)
-		return -ENOMEM;
-
+	info = xtables_calloc(1, m->u.match_size);
 	memcpy(info, m->data, m->u.match_size - sizeof(*m));
 	nftnl_expr_set(e, NFTNL_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
 
@@ -1245,10 +1239,7 @@ static int __add_target(struct nftnl_expr *e, struct xt_entry_target *t)
 			  strlen(t->u.user.name));
 	nftnl_expr_set_u32(e, NFTNL_EXPR_TG_REV, t->u.user.revision);
 
-	info = calloc(1, t->u.target_size);
-	if (info == NULL)
-		return -ENOMEM;
-
+	info = xtables_calloc(1, t->u.target_size);
 	memcpy(info, t->data, t->u.target_size - sizeof(*t));
 	nftnl_expr_set(e, NFTNL_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ed3e9c5a4426a..2d3ef679fd765 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -220,9 +220,7 @@ void xs_init_target(struct xtables_target *target)
 {
 	if (target->udata_size != 0) {
 		free(target->udata);
-		target->udata = calloc(1, target->udata_size);
-		if (target->udata == NULL)
-			xtables_error(RESOURCE_PROBLEM, "malloc");
+		target->udata = xtables_calloc(1, target->udata_size);
 	}
 	if (target->init != NULL)
 		target->init(target->t);
@@ -238,9 +236,7 @@ void xs_init_match(struct xtables_match *match)
 		 * Same goes for target.
 		 */
 		free(match->udata);
-		match->udata = calloc(1, match->udata_size);
-		if (match->udata == NULL)
-			xtables_error(RESOURCE_PROBLEM, "malloc");
+		match->udata = xtables_calloc(1, match->udata_size);
 	}
 	if (match->init != NULL)
 		match->init(match->m);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6e35f58ee685f..6e5ecd4864fa5 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -274,9 +274,7 @@ static struct option *merge_options(struct option *oldopts,
 	ebtables_globals.option_offset += OPTION_OFFSET;
 	*options_offset = ebtables_globals.option_offset;
 
-	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
-	if (!merge)
-		return NULL;
+	merge = xtables_malloc(sizeof(struct option) * (num_new + num_old + 1));
 	memcpy(merge, oldopts, num_old * sizeof(struct option));
 	for (i = 0; i < num_new; i++) {
 		merge[num_old + i] = newopts[i];
@@ -571,10 +569,7 @@ void ebt_add_match(struct xtables_match *m,
 	m->mflags = 0;
 
 	/* glue code for watchers */
-	newnode = calloc(1, sizeof(struct ebt_match));
-	if (newnode == NULL)
-		xtables_error(OTHER_PROBLEM, "Unable to alloc memory");
-
+	newnode = xtables_calloc(1, sizeof(struct ebt_match));
 	newnode->ismatch = true;
 	newnode->u.match = newm;
 
@@ -603,10 +598,7 @@ void ebt_add_watcher(struct xtables_target *watcher,
 	watcher->tflags = 0;
 
 
-	newnode = calloc(1, sizeof(struct ebt_match));
-	if (newnode == NULL)
-		xtables_error(OTHER_PROBLEM, "Unable to alloc memory");
-
+	newnode = xtables_calloc(1, sizeof(struct ebt_match));
 	newnode->u.watcher = clone;
 
 	for (matchp = &cs->match_list; *matchp; matchp = &(*matchp)->next)
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index b261e97bba3b7..d670175db2236 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2353,18 +2353,11 @@ struct xt_xlate {
 
 struct xt_xlate *xt_xlate_alloc(int size)
 {
-	struct xt_xlate *xl;
+	struct xt_xlate *xl = xtables_malloc(sizeof(struct xt_xlate));
 	int i;
 
-	xl = malloc(sizeof(struct xt_xlate));
-	if (xl == NULL)
-		xtables_error(RESOURCE_PROBLEM, "OOM");
-
 	for (i = 0; i < __XT_XLATE_MAX; i++) {
-		xl->buf[i].data = malloc(size);
-		if (xl->buf[i].data == NULL)
-			xtables_error(RESOURCE_PROBLEM, "OOM");
-
+		xl->buf[i].data = xtables_malloc(size);
 		xl->buf[i].data[0] = '\0';
 		xl->buf[i].size = size;
 		xl->buf[i].rem = size;
-- 
2.32.0

