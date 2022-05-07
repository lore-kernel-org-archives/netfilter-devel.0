Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AB3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 May 2022 21:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbiEGVd4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 May 2022 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbiEGVdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 May 2022 17:33:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DC7CBC32
        for <netfilter-devel@vger.kernel.org>; Sat,  7 May 2022 14:30:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] intervals: deletion should adjust range not yet in the kernel
Date:   Sat,  7 May 2022 23:30:02 +0200
Message-Id: <20220507213002.15209-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not remove the range if it does not exists yet in the kernel, adjust it
instead.  Uncovered by use-after-free error.

==276702==ERROR: AddressSanitizer: heap-use-after-free on address 0x60d00190663c at pc 0x7ff310ab526f bp 0x7fffeb76f750 sp 0x7fffeb76f748 READ of size 4 at 0x60d00190663c thread T0
    #0 0x7ff310ab526e in __adjust_elem_right .../nftables/src/intervals.c:300
    #1 0x7ff310ab59a7 in adjust_elem_right .../nftables/src/intervals.c:311
    #2 0x7ff310ab6daf in setelem_adjust .../nftables/src/intervals.c:354
    #3 0x7ff310ab783a in setelem_delete .../nftables/src/intervals.c:411
    #4 0x7ff310ab80e6 in __set_delete .../nftables/src/intervals.c:451

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 85ec59eda36a..e61adc769c41 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -270,9 +270,6 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 	if (prev->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
 		list_move_tail(&clone->list, &purge->expressions);
-	} else {
-		list_del(&prev->list);
-		expr_free(prev);
 	}
 }
 
-- 
2.30.2

