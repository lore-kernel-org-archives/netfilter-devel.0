Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD85C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 18:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7304224249
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 18:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfLESHu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 13:07:50 -0500
Received: from correo.us.es ([193.147.175.20]:55020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfLESHu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 13:07:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74F94E2C52
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6560BDA702
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B09CDA707; Thu,  5 Dec 2019 19:07:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4004CDA702
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Dec 2019 19:07:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D9B154265A5A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 19:07:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: don't remove nul-root element from interval set
Date:   Thu,  5 Dec 2019 19:07:43 +0100
Message-Id: <20191205180743.134358-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check from the delinearize set element path if the nul-root element
already exists in the interval set. Hence, the element insertion path
skips the implicit nul-root interval insertion.

Under some circunstances, nft bogusly fails to delete the last element
of the interval set and to create an element in an existing empty
internal set. This patch includes a test that reproduces the issue.

Fixes: 4935a0d561b5 ("segtree: special handling for the first non-matching segment")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h                         |  2 +-
 include/rule.h                            |  1 +
 src/netlink.c                             |  7 +++++--
 src/segtree.c                             |  8 +-------
 tests/shell/testcases/sets/0041interval_0 | 25 +++++++++++++++++++++++++
 5 files changed, 33 insertions(+), 10 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0041interval_0

diff --git a/include/netlink.h b/include/netlink.h
index e6941714d5b9..53a55b61e4de 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -133,7 +133,7 @@ extern int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc, struct table *table,
 			       struct set *set, struct expr *init);
 extern int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-				       const struct set *set,
+				       struct set *set,
 				       struct nft_cache *cache);
 
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h);
diff --git a/include/rule.h b/include/rule.h
index 0b2eba37934b..dadeb4b941da 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -307,6 +307,7 @@ struct set {
 	struct expr		*init;
 	struct expr		*rg_cache;
 	uint32_t		policy;
+	bool			root;
 	bool			automerge;
 	struct {
 		uint32_t	size;
diff --git a/src/netlink.c b/src/netlink.c
index 486e12473726..9fc0b17194a0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -790,7 +790,7 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 }
 
 int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-				const struct set *set, struct nft_cache *cache)
+				struct set *set, struct nft_cache *cache)
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *key, *data;
@@ -828,8 +828,11 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
 		expr->stmt = netlink_parse_set_expr(set, cache, nle);
 	}
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
+		if (mpz_cmp_ui(set->key->value, 0) == 0)
+			set->root = true;
+	}
 
 	if (set_is_datamap(set->flags)) {
 		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_DATA)) {
diff --git a/src/segtree.c b/src/segtree.c
index 7217dbca08e1..d1dbe10c81a7 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -451,7 +451,7 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 static bool segtree_needs_first_segment(const struct set *set,
 					const struct expr *init, bool add)
 {
-	if (add) {
+	if (add && !set->root) {
 		/* Add the first segment in four situations:
 		 *
 		 * 1) This is an anonymous set.
@@ -465,12 +465,6 @@ static bool segtree_needs_first_segment(const struct set *set,
 		    (set->init == init)) {
 			return true;
 		}
-	} else {
-		/* If the set is empty after the removal, we have to
-		 * remove the first non-matching segment too.
-		 */
-		if (set->init && set->init->size - init->size == 0)
-			return true;
 	}
 	/* This is an update for a set that already contains elements, so don't
 	 * add the first non-matching elements otherwise we hit EEXIST.
diff --git a/tests/shell/testcases/sets/0041interval_0 b/tests/shell/testcases/sets/0041interval_0
new file mode 100755
index 000000000000..42fc6ccf74b6
--- /dev/null
+++ b/tests/shell/testcases/sets/0041interval_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+table ip t {
+        set s {
+                type ipv4_addr
+                flags interval
+                elements = { 192.168.2.195, 192.168.2.196,
+                             192.168.2.197, 192.168.2.198 }
+        }
+}"
+
+$NFT -f - <<< "$RULESET"
+
+$NFT 'delete element t s { 192.168.2.195, 192.168.2.196 }; add element t s { 192.168.2.196 }' 2>/dev/null
+$NFT get element t s { 192.168.2.196, 192.168.2.197, 192.168.2.198 } 1>/dev/null
+$NFT 'delete element t s { 192.168.2.196, 192.168.2.197 }; add element t s { 192.168.2.197 }' 2>/dev/null
+$NFT get element t s { 192.168.2.197, 192.168.2.198 } 1>/dev/null
+$NFT 'delete element t s { 192.168.2.198, 192.168.2.197 }; add element t s { 192.168.2.196, 192.168.2.197, 192.168.2.195 }' 1>/dev/null
+$NFT get element t s { 192.168.2.196, 192.168.2.197, 192.168.2.195 } 1>/dev/null
+$NFT delete element t s { 192.168.2.196, 192.168.2.197, 192.168.2.195 } 2>/dev/null
+$NFT create element t s { 192.168.2.196} 2>/dev/null
+$NFT get element t s { 192.168.2.196 } 1>/dev/null
-- 
2.11.0

