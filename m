Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042AEC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Mar 2022 13:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbiCWNY2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244283AbiCWNY1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 09:24:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485B47D008
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2022 06:22:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nX0wu-00015y-R4; Wed, 23 Mar 2022 14:22:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 11/16] netfilter: remove nf_ct_unconfirmed_destroy helper
Date:   Wed, 23 Mar 2022 14:22:09 +0100
Message-Id: <20220323132214.6700-12-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323132214.6700-1-fw@strlen.de>
References: <20220323132214.6700-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper tags connetions not yet in the conntrack table as
dying.  These nf_conn entries will be dropped instead when the
core attempts to insert them from the input or postrouting
'confirm' hook.

After the previous change, the entries get unlinked from the
list earlier, so that by the time the actual exit hook runs,
new connections no longer have a timeout policy assigned.

Its enough to walk the hashtable instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  3 ---
 net/netfilter/nf_conntrack_core.c    | 14 --------------
 net/netfilter/nfnetlink_cttimeout.c  |  4 +++-
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 28672a944499..f60212244b13 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -237,9 +237,6 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 	return nf_ct_delete(ct, 0, 0);
 }
 
-/* Set all unconfirmed conntrack as dying */
-void nf_ct_unconfirmed_destroy(struct net *);
-
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9010b6e5a072..b3cc318ceb45 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2431,20 +2431,6 @@ __nf_ct_unconfirmed_destroy(struct net *net)
 	}
 }
 
-void nf_ct_unconfirmed_destroy(struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	might_sleep();
-
-	if (atomic_read(&cnet->count) > 0) {
-		__nf_ct_unconfirmed_destroy(net);
-		nf_queue_nf_hook_drop(net);
-		synchronize_net();
-	}
-}
-EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_destroy);
-
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 45a87eaffebe..49fe2ec40af9 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -609,7 +609,9 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 	struct ctnl_timeout *cur, *tmp;
 
-	nf_ct_unconfirmed_destroy(net);
+	if (list_empty(&pernet->nfct_timeout_freelist))
+		return;
+
 	nf_ct_untimeout(net, NULL);
 
 	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, head) {
-- 
2.34.1

