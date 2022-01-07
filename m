Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9E5C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jan 2022 14:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347793AbiAGOq1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jan 2022 09:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbiAGOq0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jan 2022 09:46:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF9AC061574
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jan 2022 06:46:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n5qVb-0007tb-B1; Fri, 07 Jan 2022 15:46:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: egress: avoid a lockdep splat
Date:   Fri,  7 Jan 2022 15:46:16 +0100
Message-Id: <20220107144616.4261-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!
2 locks held by sd-resolve/1100:
 0: ..(rcu_read_lock_bh){1:3}, at: ip_finish_output2
 1: ..(rcu_read_lock_bh){1:3}, at: __dev_queue_xmit
 __dev_queue_xmit+0 ..

The helper has two callers, one uses rcu_read_lock, the other
rcu_read_lock_bh().  Annotate the dereference to reflect this.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 targetting -next since its only a wrong annotation.

 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b71b57a83bb4..b4dd96e4dc8d 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -94,7 +94,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 #endif
 
-	e = rcu_dereference(dev->nf_hooks_egress);
+	e = rcu_dereference_check(dev->nf_hooks_egress, rcu_read_lock_bh_held());
 	if (!e)
 		return skb;
 
-- 
2.34.1

