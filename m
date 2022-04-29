Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94841C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Apr 2022 18:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbiD2Si6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiD2Si4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 14:38:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A09D8A9FA
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2022 11:35:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nkVSo-0001tW-KF; Fri, 29 Apr 2022 20:35:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] segtree: add pretty-print support for wildcard strings in concatenated sets
Date:   Fri, 29 Apr 2022 20:32:38 +0200
Message-Id: <20220429183239.5569-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429183239.5569-1-fw@strlen.de>
References: <20220429183239.5569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For concat ranges, something like 'ppp*' is translated as a range
from 'ppp\0\0\0...' to 'ppp\ff\ff\ff...'.

In order to display this properly, check for presence of string base
type and convert to symbolic expression, with appended '*' character.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 4602becc10e6..f9cac373a5f0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -345,6 +345,8 @@ void concat_range_aggregate(struct expr *set)
 		list_for_each_entry_safe(r1, r1_next,
 					 &expr_value(start)->expressions,
 					 list) {
+			bool string_type = false;
+
 			mpz_init(range);
 			mpz_init(p);
 
@@ -356,16 +358,48 @@ void concat_range_aggregate(struct expr *set)
 				goto next;
 			}
 
+			if (expr_basetype(r1)->type == TYPE_STRING &&
+			    expr_basetype(r2)->type == TYPE_STRING) {
+				string_type = true;
+				mpz_switch_byteorder(r1->value, r1->len / BITS_PER_BYTE);
+				mpz_switch_byteorder(r2->value, r2->len / BITS_PER_BYTE);
+			}
+
 			mpz_sub(range, r2->value, r1->value);
 			mpz_sub_ui(range, range, 1);
 			mpz_and(p, r1->value, range);
 
 			/* Check if we are forced, or if it's anyway preferable,
-			 * to express the range as two points instead of a
-			 * netmask.
+			 * to express the range as a wildcard string, or two points
+			 * instead of a netmask.
 			 */
 			prefix_len = range_mask_len(r1->value, r2->value,
 						    r1->len);
+			if (string_type) {
+				mpz_switch_byteorder(r1->value, r1->len / BITS_PER_BYTE);
+				mpz_switch_byteorder(r2->value, r2->len / BITS_PER_BYTE);
+			}
+
+			if (prefix_len >= 0 &&
+			    (prefix_len % BITS_PER_BYTE) == 0 &&
+			    string_type) {
+				unsigned int str_len = prefix_len / BITS_PER_BYTE;
+				char data[str_len + 2];
+
+				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, str_len);
+				data[str_len] = '*';
+
+				tmp = constant_expr_alloc(&r1->location, r1->dtype,
+							  BYTEORDER_HOST_ENDIAN,
+							  (str_len + 1) * BITS_PER_BYTE, data);
+				tmp->len = r2->len;
+				list_replace(&r2->list, &tmp->list);
+				r2_next = tmp->list.next;
+				expr_free(r2);
+				free_r1 = 1;
+				goto next;
+			}
+
 			if (prefix_len < 0 ||
 			    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
 				tmp = range_expr_alloc(&r1->location, r1,
-- 
2.35.1

