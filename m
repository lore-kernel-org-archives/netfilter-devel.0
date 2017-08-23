From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: debug: check for sorted array
Date: Wed, 23 Aug 2017 17:26:26 +0200
Message-ID: <20170823152627.19865-3-fw@strlen.de>
References: <20170823152627.19865-1-fw@strlen.de>
Cc: aconole@bytheb.org, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58166 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932324AbdHWP0P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 11:26:15 -0400
In-Reply-To: <20170823152627.19865-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure our grow/shrink routine places them in the correct order.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6212958c9c58..8ca26729430b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -159,6 +159,27 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 	return new;
 }
 
+static void hooks_validate(const struct nf_hook_entries *hooks)
+{
+#ifdef CONFIG_DEBUG_KERNEL
+	struct nf_hook_ops **orig_ops;
+	int prio = INT_MIN;
+	size_t i = 0;
+
+	orig_ops = nf_hook_entries_get_hook_ops(hooks);
+
+	for (i = 0; i < hooks->num_hook_entries; i++) {
+		if (orig_ops[i] == &dummy_ops)
+			continue;
+
+		WARN_ON(orig_ops[i]->priority < prio);
+
+		if (orig_ops[i]->priority > prio)
+			prio = orig_ops[i]->priority;
+	}
+#endif
+}
+
 /*
  * __nf_hook_entries_try_shrink - try to shrink hook array
  *
@@ -212,6 +233,7 @@ static void *__nf_hook_entries_try_shrink(struct nf_hook_entries __rcu **pp)
 		new_ops[j] = (void *)orig_ops[i];
 		j++;
 	}
+	hooks_validate(new);
 out_assign:
 	rcu_assign_pointer(*pp, new);
 	return old;
@@ -263,6 +285,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	if (IS_ERR(new_hooks))
 		return PTR_ERR(new_hooks);
 
+	hooks_validate(new_hooks);
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (reg->pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
-- 
2.13.0

