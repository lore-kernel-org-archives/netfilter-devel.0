From: simran singhal <singhalsimran0@gmail.com>
Subject: [PATCH] iptables: libiptc: Use list_{next/prev}_entry instead of
 list_entry
Date: Wed, 29 Mar 2017 11:42:19 +0530
Message-ID: <20170329061219.GA6036@singhal-Inspiron-5558>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34413 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbdC2GM3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 02:12:29 -0400
Received: by mail-pg0-f65.google.com with SMTP id o123so1370618pga.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 23:12:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replace list_entry with list_{next/prev}_entry as it makes
the code more clear to read.

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 libiptc/libiptc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index a6e7057..5590cb8 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1452,7 +1452,7 @@ static void iptcc_chain_iterator_advance(struct xtc_handle *handle)
 		handle->chain_iterator_cur = NULL;
 	else
 		handle->chain_iterator_cur =
-			list_entry(c->list.next, struct chain_head, list);
+			list_next_entry(c, list);
 }
 
 /* Iterator functions to run through the chains. */
@@ -1540,8 +1540,7 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle *handle)
 		return NULL;
 	}
 
-	r = list_entry(handle->rule_iterator_cur->list.next,
-			struct rule_head, list);
+	r = list_next_entry(handle->rule_iterator_cur, list);
 
 	iptc_fn = TC_NEXT_RULE;
 
@@ -2013,8 +2012,8 @@ static int delete_entry(const IPT_CHAINLABEL chain, const STRUCT_ENTRY *origfw,
 		 * pointer will then point to real next node */
 		if (i == handle->rule_iterator_cur) {
 			handle->rule_iterator_cur =
-				list_entry(handle->rule_iterator_cur->list.prev,
-					   struct rule_head, list);
+				list_prev_entry(handle->rule_iterator_cur,
+						list);
 		}
 
 		c->num_rules--;
@@ -2078,8 +2077,7 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 	 * point to real next node */
 	if (r == handle->rule_iterator_cur) {
 		handle->rule_iterator_cur =
-			list_entry(handle->rule_iterator_cur->list.prev,
-				   struct rule_head, list);
+			list_prev_entry(handle->rule_iterator_cur, list);
 	}
 
 	c->num_rules--;
-- 
2.7.4

