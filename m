Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E22C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 20:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiEQUut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 16:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353028AbiEQUut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 16:50:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9B5FE9
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 13:50:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nr49U-0003rF-NZ; Tue, 17 May 2022 22:50:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com
Subject: [PATCH nf-next] netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit
Date:   Tue, 17 May 2022 22:50:36 +0200
Message-Id: <20220517205036.25883-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <0000000000002ecf9805df3af808@google.com>
References: <0000000000002ecf9805df3af808@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reports:
BUG: KASAN: slab-out-of-bounds in __list_del_entry_valid+0xcc/0xf0 lib/list_debug.c:42
[..]
 list_del include/linux/list.h:148 [inline]
 cttimeout_net_exit+0x211/0x540 net/netfilter/nfnetlink_cttimeout.c:617

No reproducer so far. Looking at recent changes in this area
its clear that the free_head must not be at the end of the
structure because nf_ct_timeout structure has variable size.

Reported-by: <syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com>
Fixes: 78222bacfca9 ("netfilter: cttimeout: decouple unlink and free on netns destruction")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f069c24c6146..af15102bc696 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -35,12 +35,13 @@ static unsigned int nfct_timeout_id __read_mostly;
 
 struct ctnl_timeout {
 	struct list_head	head;
+	struct list_head	free_head;
 	struct rcu_head		rcu_head;
 	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
-	struct nf_ct_timeout	timeout;
 
-	struct list_head	free_head;
+	/* must be at the end */
+	struct nf_ct_timeout	timeout;
 };
 
 struct nfct_timeout_pernet {
-- 
2.35.1

