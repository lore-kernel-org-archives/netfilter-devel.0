Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54813C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbiDYNTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiDYNTW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:19:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA97E19C08
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:16:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1niyZT-000460-CS; Mon, 25 Apr 2022 15:16:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: prefer extension check to pointer check
Date:   Mon, 25 Apr 2022 15:15:44 +0200
Message-Id: <20220425131544.27860-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425131544.27860-1-fw@strlen.de>
References: <20220425131544.27860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The pointer check usually results in a 'false positive': its likely
that the ctnetlink module is loaded but no event monitoring is enabled.

After recent change to autodetect ctnetlink usage and only allocate
the ecache extension if a listener is active, check if the extension
is present on a given conntrack.

If its not there, there is nothing to report and calls to the
notification framework can be elided.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_core.h   |  2 +-
 include/net/netfilter/nf_conntrack_ecache.h | 31 ++++++++++-----------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 13807ea94cd2..6406cfee34c2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -60,7 +60,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct) {
 		if (!nf_ct_is_confirmed(ct))
 			ret = __nf_conntrack_confirm(skb);
-		if (likely(ret == NF_ACCEPT))
+		if (ret == NF_ACCEPT && nf_ct_ecache_exist(ct))
 			nf_ct_deliver_cached_events(ct);
 	}
 	return ret;
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 2e3d58439e34..0c1dac318e02 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -36,6 +36,15 @@ nf_ct_ecache_find(const struct nf_conn *ct)
 #endif
 }
 
+static inline bool nf_ct_ecache_exist(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	return nf_ct_ext_exist(ct, NF_CT_EXT_ECACHE);
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 
 /* This structure is passed to event handler */
@@ -108,30 +117,20 @@ nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
-		return 0;
-
-	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
-#else
-	return 0;
+	if (nf_ct_ecache_exist(ct))
+		return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
 #endif
+	return 0;
 }
 
 static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
-		return 0;
-
-	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
-#else
-	return 0;
+	if (nf_ct_ecache_exist(ct))
+		return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
 #endif
+	return 0;
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-- 
2.35.1

