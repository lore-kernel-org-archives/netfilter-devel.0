Return-Path: <SRS0=F0cc=5M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E316C43331
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 02:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DD120774
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 02:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0CZG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:25:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41648 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgC0CZG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 22:25:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jHegC-00068V-Ni; Fri, 27 Mar 2020 03:25:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: nf_queue: place bridge physports into queue_entry struct
Date:   Fri, 27 Mar 2020 03:24:47 +0100
Message-Id: <20200327022449.7411-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327022449.7411-1-fw@strlen.de>
References: <20200327022449.7411-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The refcount is done via entry->skb, which does work fine.
Major problem: When putting the refcount of the bridge ports, we
must always put the references while the skb is still around.

However, we will need to put the references after okfn() to avoid
a possible 1 -> 0 -> 1 refcount transition, so we cannot use the
skb pointer anymore.

Place the physports in the queue entry structure instead to allow
for refcounting changes in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h |  5 ++-
 net/netfilter/nf_queue.c         | 53 ++++++++++++++------------------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index cdbd98730852..e770bba00066 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -14,7 +14,10 @@ struct nf_queue_entry {
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
-
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*physin;
+	struct net_device	*physout;
+#endif
 	struct nf_hook_state	state;
 	u16			size; /* sizeof(entry) + saved route keys */
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 4da5776a9904..96eb72908467 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,24 +46,6 @@ void nf_unregister_queue_handler(struct net *net)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-static void nf_queue_entry_release_br_nf_refs(struct sk_buff *skb)
-{
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
-
-	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_put(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_put(physdev);
-	}
-#endif
-}
-
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
@@ -76,7 +58,12 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_put(state->sk);
 
-	nf_queue_entry_release_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_put(entry->physin);
+	if (entry->physout)
+		dev_put(entry->physout);
+#endif
 }
 
 void nf_queue_entry_free(struct nf_queue_entry *entry)
@@ -86,20 +73,19 @@ void nf_queue_entry_free(struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_free);
 
-static void nf_queue_entry_get_br_nf_refs(struct sk_buff *skb)
+static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	const struct sk_buff *skb = entry->skb;
+	struct nf_bridge_info *nf_bridge;
 
+	nf_bridge = nf_bridge_info_get(skb);
 	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_hold(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_hold(physdev);
+		entry->physin = nf_bridge_get_physindev(skb);
+		entry->physout = nf_bridge_get_physoutdev(skb);
+	} else {
+		entry->physin = NULL;
+		entry->physout = NULL;
 	}
 #endif
 }
@@ -116,7 +102,12 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_hold(state->sk);
 
-	nf_queue_entry_get_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_hold(entry->physin);
+	if (entry->physout)
+		dev_hold(entry->physout);
+#endif
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -207,6 +198,8 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
+	__nf_queue_entry_init_physdevs(entry);
+
 	nf_queue_entry_get_refs(entry);
 
 	switch (entry->state.pf) {
-- 
2.24.1

