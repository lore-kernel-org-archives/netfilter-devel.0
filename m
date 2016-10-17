From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/10] netfilter: deprecate NF_STOP
Date: Mon, 17 Oct 2016 13:10:30 +0200
Message-ID: <1476702636-3303-5-git-send-email-pablo@netfilter.org>
References: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933677AbcJQLKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 07:10:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 995A01324D0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8793A78428
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BA1E78428
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:10:48 +0200 (CEST)
In-Reply-To: <1476702636-3303-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NF_STOP is only used by br_netfilter these days, and it can be emulated
with a combination of NF_STOLEN plus explicit call to the ->okfn()
function as Florian suggests.

To retain binary compatibility with userspace nf_queue application, we
have to keep NF_STOP around, so libnetfilter_queue userspace userspace
applications still work if they use NF_STOP for some exotic reason.

Out of tree modules using NF_STOP would break, but we don't care about
those.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter.h  | 2 +-
 net/bridge/br_netfilter_hooks.c | 6 ++++--
 net/netfilter/core.c            | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index d93f949d1d9a..7550e9176a54 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -13,7 +13,7 @@
 #define NF_STOLEN 2
 #define NF_QUEUE 3
 #define NF_REPEAT 4
-#define NF_STOP 5
+#define NF_STOP 5	/* Deprecated, for userspace nf_queue compatibility. */
 #define NF_MAX_VERDICT NF_STOP
 
 /* we overload the higher bits for encoding auxiliary data such as the queue
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d0d66faebe90..7e3645fa6339 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -845,8 +845,10 @@ static unsigned int ip_sabotage_in(void *priv,
 				   struct sk_buff *skb,
 				   const struct nf_hook_state *state)
 {
-	if (skb->nf_bridge && !skb->nf_bridge->in_prerouting)
-		return NF_STOP;
+	if (skb->nf_bridge && !skb->nf_bridge->in_prerouting) {
+		state->okfn(state->net, state->sk, skb);
+		return NF_STOLEN;
+	}
 
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6b09d9ed2646..2a6ed7d29c6c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -333,7 +333,7 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
 	entry = rcu_dereference(state->hook_entries);
 next_hook:
 	verdict = nf_iterate(skb, state, &entry);
-	if (verdict == NF_ACCEPT || verdict == NF_STOP) {
+	if (verdict == NF_ACCEPT) {
 		ret = 1;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_DROP) {
 		kfree_skb(skb);
-- 
2.1.4

