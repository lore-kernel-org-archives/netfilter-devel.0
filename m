Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BD5C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 14:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0014218AC
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 14:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbgJOOwR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 10:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388348AbgJOOwR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 10:52:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE37C061755
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 07:52:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kT4c3-0000vL-UL; Thu, 15 Oct 2020 16:52:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] segtree: copy expr data to closing element
Date:   Thu, 15 Oct 2020 16:52:11 +0200
Message-Id: <20201015145211.1688-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When last expr has no closing element we did not propagate
expr properties such as comment or expire date to the newly
allocated set elem.

Before:
nft create table t
nft 'add set t s { type ipv4_addr; flags interval; timeout 60s; }'
nft add element t s { 224.0.0.0/3 }
nft list set t s | grep -o 'elements.*'
elements = { 224.0.0.0-255.255.255.255 }

nft flush set t s
nft add element t s { 224.0.0.0/4, 240.0.0.0/4 }
nft list set t s | grep -o 'elements.*'
elements = { 224.0.0.0/4 expires 55s152ms, 240.0.0.0-255.255.255.255 }

nft delete set t s
nft 'add set t s { type ipv4_addr; flags interval; auto-merge; timeout 60s; }'
nft add element t s { 224.0.0.0/4, 240.0.0.0/4 }
nft list set t s | grep -o 'elements.*'
elements = { 224.0.0.0-255.255.255.255 }

After:
elements = { 224.0.0.0-255.255.255.255 expires 58s515ms }
elements = { 224.0.0.0/4 expires 54s622ms, 240.0.0.0-255.255.255.255 expires 54s622ms }
elements = { 224.0.0.0-255.255.255.255 expires 57s92ms }

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1454
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 59 +++++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 3a641bc56213..ec281359c691 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -927,6 +927,20 @@ next:
 	}
 }
 
+static void interval_expr_copy(struct expr *dst, struct expr *src)
+{
+	if (src->comment)
+		dst->comment = xstrdup(src->comment);
+	if (src->timeout)
+		dst->timeout = src->timeout;
+	if (src->expiration)
+		dst->expiration = src->expiration;
+	if (src->stmt) {
+		dst->stmt = src->stmt;
+		src->stmt = NULL;
+	}
+}
+
 void interval_map_decompose(struct expr *set)
 {
 	struct expr **elements, **ranges;
@@ -1016,30 +1030,12 @@ void interval_map_decompose(struct expr *set)
 			tmp = set_elem_expr_alloc(&low->location, tmp);
 
 			if (low->etype == EXPR_MAPPING) {
-				if (low->left->comment)
-					tmp->comment = xstrdup(low->left->comment);
-				if (low->left->timeout)
-					tmp->timeout = low->left->timeout;
-				if (low->left->expiration)
-					tmp->expiration = low->left->expiration;
-				if (low->left->stmt) {
-					tmp->stmt = low->left->stmt;
-					low->left->stmt = NULL;
-				}
+				interval_expr_copy(tmp, low->left);
 
 				tmp = mapping_expr_alloc(&tmp->location, tmp,
 							 expr_clone(low->right));
 			} else {
-				if (low->comment)
-					tmp->comment = xstrdup(low->comment);
-				if (low->timeout)
-					tmp->timeout = low->timeout;
-				if (low->expiration)
-					tmp->expiration = low->expiration;
-				if (low->stmt) {
-					tmp->stmt = low->stmt;
-					low->stmt = NULL;
-				}
+				interval_expr_copy(tmp, low);
 			}
 
 			compound_expr_add(set, tmp);
@@ -1056,30 +1052,12 @@ void interval_map_decompose(struct expr *set)
 			prefix = set_elem_expr_alloc(&low->location, prefix);
 
 			if (low->etype == EXPR_MAPPING) {
-				if (low->left->comment)
-					prefix->comment = xstrdup(low->left->comment);
-				if (low->left->timeout)
-					prefix->timeout = low->left->timeout;
-				if (low->left->expiration)
-					prefix->expiration = low->left->expiration;
-				if (low->left->stmt) {
-					prefix->stmt = low->left->stmt;
-					low->left->stmt = NULL;
-				}
+				interval_expr_copy(prefix, low->left);
 
 				prefix = mapping_expr_alloc(&low->location, prefix,
 							    expr_clone(low->right));
 			} else {
-				if (low->comment)
-					prefix->comment = xstrdup(low->comment);
-				if (low->timeout)
-					prefix->timeout = low->timeout;
-				if (low->expiration)
-					prefix->expiration = low->expiration;
-				if (low->stmt) {
-					prefix->stmt = low->stmt;
-					low->stmt = NULL;
-				}
+				interval_expr_copy(prefix, low);
 			}
 
 			compound_expr_add(set, prefix);
@@ -1110,6 +1088,7 @@ void interval_map_decompose(struct expr *set)
 			i = mapping_expr_alloc(&i->location, i,
 					       expr_clone(low->right));
 
+		interval_expr_copy(i, low);
 		expr_free(low);
 	}
 
-- 
2.26.2

