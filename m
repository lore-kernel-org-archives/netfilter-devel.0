Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5E2C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCCE20684
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfHLLun (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 07:50:43 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45786 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbfHLLun (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 07:50:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hx8qY-000126-3A; Mon, 12 Aug 2019 13:50:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: connlabels: prefer static lock initialiser
Date:   Mon, 12 Aug 2019 13:40:04 +0200
Message-Id: <20190812114004.23746-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

seen during boot:
BUG: spinlock bad magic on CPU#2, swapper/0/1
 lock: nf_connlabels_lock+0x0/0x60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Call Trace:
 do_raw_spin_lock+0x14e/0x1b0
 nf_connlabels_get+0x15/0x40
 ct_init_net+0xc4/0x270
 ops_init+0x56/0x1c0
 register_pernet_operations+0x1c8/0x350
 register_pernet_subsys+0x1f/0x40
 tcf_register_action+0x7c/0x1a0
 do_one_initcall+0x13d/0x2d9

Problem is that ct action init function can run before
connlabels_init().  Lock has not been initialised yet.

Fix it by using a static initialiser.

Fixes: b57dc7c13ea90e09ae15f821d2583fa0231b4935 ("net/sched: Introduce action ct")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_labels.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 74b8113f7aeb..d1c6b2a2e7bd 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,7 +11,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static spinlock_t nf_connlabels_lock;
+static __read_mostly DEFINE_SPINLOCK(nf_connlabels_lock);
 
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
@@ -89,7 +89,6 @@ int nf_conntrack_labels_init(void)
 {
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
 
-	spin_lock_init(&nf_connlabels_lock);
 	return nf_ct_extend_register(&labels_extend);
 }
 
-- 
2.21.0

