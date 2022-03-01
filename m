Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401B7C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 00:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiCAAWG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 19:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiCAAWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 19:22:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39BE24F2A
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 16:21:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nOqGV-0005ZT-Th; Tue, 01 Mar 2022 01:21:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 nf 1/2] netfilter: nf_queue: fix possible use-after-free
Date:   Tue,  1 Mar 2022 01:21:07 +0100
Message-Id: <20220301002108.28338-2-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301002108.28338-1-fw@strlen.de>
References: <20220301002108.28338-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Dumazet says:
  The sock_hold() side seems suspect, because there is no guarantee
  that sk_refcnt is not already 0.

On failure, we cannot queue the packet and need to indicate an
error.  The packet will be dropped by the caller.

v2: split skb prefetch hunk into separate change

Fixes: 271b72c7fa82c ("udp: RCU handling for Unicast packets.")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h |  2 +-
 net/netfilter/nf_queue.c         | 13 +++++++++----
 net/netfilter/nfnetlink_queue.c  | 12 +++++++++---
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 9eed51e920e8..980daa6e1e3a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -37,7 +37,7 @@ void nf_register_queue_handler(const struct nf_queue_handler *qh);
 void nf_unregister_queue_handler(void);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_free(struct nf_queue_entry *entry);
 
 static inline void init_hashrandom(u32 *jhash_initval)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 5ab0680db445..e39549c55945 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -96,19 +96,21 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 }
 
 /* Bump dev refs so they don't vanish while packet is out */
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
 
+	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
+		return false;
+
 	dev_hold(state->in);
 	dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -196,7 +198,10 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	__nf_queue_entry_init_physdevs(entry);
 
-	nf_queue_entry_get_refs(entry);
+	if (!nf_queue_entry_get_refs(entry)) {
+		kfree(entry);
+		return -ENOTCONN;
+	}
 
 	switch (entry->state.pf) {
 	case AF_INET:
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index ea2d9c2a44cf..64a6acb6aeae 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -710,9 +710,15 @@ static struct nf_queue_entry *
 nf_queue_entry_dup(struct nf_queue_entry *e)
 {
 	struct nf_queue_entry *entry = kmemdup(e, e->size, GFP_ATOMIC);
-	if (entry)
-		nf_queue_entry_get_refs(entry);
-	return entry;
+
+	if (!entry)
+		return NULL;
+
+	if (nf_queue_entry_get_refs(entry))
+		return entry;
+
+	kfree(entry);
+	return NULL;
 }
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-- 
2.34.1

