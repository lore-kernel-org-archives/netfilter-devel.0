Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCBBECE58D
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0FAC206BB
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfJIOco (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:44 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45136 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730490AbfJIOco (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 10:32:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iID18-0003aR-Ac; Wed, 09 Oct 2019 16:32:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Edward Cree <ecree@solarflare.com>
Subject: [PATCH nf-next] netfilter: add and use nf_hook_slow_list()
Date:   Wed,  9 Oct 2019 16:30:46 +0200
Message-Id: <20191009143046.11070-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time, NF_HOOK_LIST() macro will iterate the list and then call
nf_hook() for each skb.

This makes it so the entire list is passed into the netfilter core.
The advantage is that we only need to fetch the rule blob once per list
instead of per-skb.  If no rules are present, the list operations
can be elided entirely.

NF_HOOK_LIST only supports ipv4 and ipv6, but those are the only
callers.

Cc: Edward Cree <ecree@solarflare.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h | 41 +++++++++++++++++++++++++++++----------
 net/netfilter/core.c      | 20 +++++++++++++++++++
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 77ebb61faf48..eb312e7ca36e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -199,6 +199,8 @@ extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		 const struct nf_hook_entries *e, unsigned int i);
 
+void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
+		       const struct nf_hook_entries *e);
 /**
  *	nf_hook - call a netfilter hook
  *
@@ -311,17 +313,36 @@ NF_HOOK_LIST(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk,
 	     struct list_head *head, struct net_device *in, struct net_device *out,
 	     int (*okfn)(struct net *, struct sock *, struct sk_buff *))
 {
-	struct sk_buff *skb, *next;
-	struct list_head sublist;
-
-	INIT_LIST_HEAD(&sublist);
-	list_for_each_entry_safe(skb, next, head, list) {
-		list_del(&skb->list);
-		if (nf_hook(pf, hook, net, sk, skb, in, out, okfn) == 1)
-			list_add_tail(&skb->list, &sublist);
+	struct nf_hook_entries *hook_head = NULL;
+
+#ifdef CONFIG_JUMP_LABEL
+	if (__builtin_constant_p(pf) &&
+	    __builtin_constant_p(hook) &&
+	    !static_key_false(&nf_hooks_needed[pf][hook]))
+		return;
+#endif
+
+	rcu_read_lock();
+	switch (pf) {
+	case NFPROTO_IPV4:
+		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
+		break;
+	case NFPROTO_IPV6:
+		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
-	/* Put passed packets back on main list */
-	list_splice(&sublist, head);
+
+	if (hook_head) {
+		struct nf_hook_state state;
+
+		nf_hook_state_init(&state, hook, pf, in, out, sk, net, okfn);
+
+		nf_hook_slow_list(head, &state, hook_head);
+	}
+	rcu_read_unlock();
 }
 
 /* Call setsockopt() */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5d5bdf450091..306587b07a4f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -536,6 +536,26 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 }
 EXPORT_SYMBOL(nf_hook_slow);
 
+void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
+		       const struct nf_hook_entries *e)
+{
+	struct sk_buff *skb, *next;
+	struct list_head sublist;
+	int ret;
+
+	INIT_LIST_HEAD(&sublist);
+
+	list_for_each_entry_safe(skb, next, head, list) {
+		list_del(&skb->list);
+		ret = nf_hook_slow(skb, state, e, 0);
+		if (ret == 1)
+			list_add_tail(&skb->list, &sublist);
+	}
+	/* Put passed packets back on main list */
+	list_splice(&sublist, head);
+}
+EXPORT_SYMBOL(nf_hook_slow_list);
+
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
-- 
2.21.0

