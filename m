Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A58C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 19:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352199AbiEQTte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 15:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352045AbiEQTtb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 15:49:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7236151E53
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 12:49:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nr3C7-0003a5-PD; Tue, 17 May 2022 21:49:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com
Subject: [PATCH nf-next] netfilter: conntrack: re-fetch conntrack after insertion
Date:   Tue, 17 May 2022 21:49:18 +0200
Message-Id: <20220517194918.20555-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case the conntrack is clashing, insertion can free skb->_nfct and
set skb->_nfct to the already-confirmed entry.

This wasn't found before because the conntrack entry and the extension
space used to free'd after an rcu grace period, plus the race needs
events enabled to trigger.

Reported-by: <syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com>
Fixes: 71d8c47fc653 ("netfilter: conntrack: introduce clash resolution on insertion race")
Fixes: 2ad9d7747c10 ("netfilter: conntrack: free extension area immediately")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_core.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 6406cfee34c2..37866c8386e2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -58,8 +58,13 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct)) {
 			ret = __nf_conntrack_confirm(skb);
+
+			if (ret == NF_ACCEPT)
+				ct = (struct nf_conn *)skb_nfct(skb);
+		}
+
 		if (ret == NF_ACCEPT && nf_ct_ecache_exist(ct))
 			nf_ct_deliver_cached_events(ct);
 	}
-- 
2.35.1

