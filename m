Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2A8C76195
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EE6A20880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733164AbfGPK0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 06:26:55 -0400
Received: from mail.us.es ([193.147.175.20]:60874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbfGPK0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16D1CB6C7C
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF09D1150CC
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0D861158EE; Tue, 16 Jul 2019 12:26:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEE73115402
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 12:26:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A40444265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/5] src: use set_is_anonymous()
Date:   Tue, 16 Jul 2019 12:26:22 +0200
Message-Id: <20190716102624.4628-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190716102624.4628-1-pablo@netfilter.org>
References: <20190716102624.4628-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c    | 2 +-
 src/expression.c  | 4 ++--
 src/json.c        | 4 ++--
 src/monitor.c     | 4 ++--
 src/parser_json.c | 2 +-
 src/rule.c        | 4 ++--
 src/segtree.c     | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f915187165cc..e35291d28b6a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1642,7 +1642,7 @@ static int __binop_transfer(struct eval_ctx *ctx,
 		}
 		break;
 	case EXPR_SET_REF:
-		if (!((*right)->set->flags & NFT_SET_ANONYMOUS))
+		if (!set_is_anonymous((*right)->set->flags))
 			return 0;
 
 		return __binop_transfer(ctx, left, &(*right)->set->init);
diff --git a/src/expression.c b/src/expression.c
index 5d0b4f82cae4..cb49e0b73f5a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -851,7 +851,7 @@ static const char *calculate_delim(const struct expr *expr, int *count)
 	const char *newline = ",\n\t\t\t     ";
 	const char *singleline = ", ";
 
-	if (expr->set_flags & NFT_SET_ANONYMOUS)
+	if (set_is_anonymous(expr->set_flags))
 		return singleline;
 
 	if (!expr->dtype)
@@ -1035,7 +1035,7 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 
 static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	if (expr->set->flags & NFT_SET_ANONYMOUS) {
+	if (set_is_anonymous(expr->set->flags)) {
 		if (expr->set->flags & NFT_SET_EVAL)
 			nft_print(octx, "%s", expr->set->handle.set.name);
 		else
diff --git a/src/json.c b/src/json.c
index f40dc51883b7..b21677efea91 100644
--- a/src/json.c
+++ b/src/json.c
@@ -522,7 +522,7 @@ json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	if (expr->set->flags & NFT_SET_ANONYMOUS) {
+	if (set_is_anonymous(expr->set->flags)) {
 		return expr_print_json(expr->set->init, octx);
 	} else {
 		return json_pack("s+", "@", expr->set->handle.set.name);
@@ -1473,7 +1473,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(set, &table->sets, list) {
-		if (set->flags & NFT_SET_ANONYMOUS)
+		if (set_is_anonymous(set->flags))
 			continue;
 		tmp = set_print_json(&ctx->nft->output, set);
 		json_array_append_new(root, tmp);
diff --git a/src/monitor.c b/src/monitor.c
index 5b25c9d4854e..40c381149cda 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -275,7 +275,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 
 	nls = netlink_set_alloc(nlh);
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-	if (flags & NFT_SET_ANONYMOUS)
+	if (set_is_anonymous(flags))
 		goto out;
 
 	set = netlink_delinearize_set(monh->ctx, nls);
@@ -392,7 +392,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		goto out;
 	}
 
-	if (set->flags & NFT_SET_ANONYMOUS)
+	if (set_is_anonymous(set->flags))
 		goto out;
 
 	/* we want to 'delinearize' the set_elem, but don't
diff --git a/src/parser_json.c b/src/parser_json.c
index f701ebdf1858..9add6f88d09e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3598,7 +3598,7 @@ static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
 	case NFT_MSG_NEWSET:
 		nls = netlink_set_alloc(nlh);
 		flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-		if (!(flags & NFT_SET_ANONYMOUS))
+		if (!set_is_anonymous(flags))
 			handle = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 		nftnl_set_free(nls);
 		break;
diff --git a/src/rule.c b/src/rule.c
index e04fc09b0a5b..52d8181f0d92 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -388,7 +388,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 
 	list_for_each_entry(table, &cache->list, list) {
 		list_for_each_entry(set, &table->sets, list) {
-			if (set->flags & NFT_SET_ANONYMOUS)
+			if (set_is_anonymous(set->flags))
 				continue;
 			if (!strcmp(set->handle.set.name, set_name)) {
 				*t = table;
@@ -1272,7 +1272,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		delim = "\n";
 	}
 	list_for_each_entry(set, &table->sets, list) {
-		if (set->flags & NFT_SET_ANONYMOUS)
+		if (set_is_anonymous(set->flags))
 			continue;
 		nft_print(octx, "%s", delim);
 		set_print(set, octx);
diff --git a/src/segtree.c b/src/segtree.c
index a21270a08c46..eff0653a8dfb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -440,7 +440,7 @@ static bool segtree_needs_first_segment(const struct set *set,
 		 * 3) New empty set and, separately, new elements are added.
 		 * 4) This set is created with a number of initial elements.
 		 */
-		if ((set->flags & NFT_SET_ANONYMOUS) ||
+		if ((set_is_anonymous(set->flags)) ||
 		    (set->init && set->init->size == 0) ||
 		    (set->init == NULL && init) ||
 		    (set->init == init)) {
-- 
2.11.0

