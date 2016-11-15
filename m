From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next 3/3] netfilter: convert while loops to for loops
Date: Tue, 15 Nov 2016 17:48:46 -0500
Message-ID: <1479250126-15111-4-git-send-email-aconole@bytheb.org>
References: <1479250126-15111-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        coreteam@netfilter.org, "David S . Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35322 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932797AbcKOWs6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 17:48:58 -0500
Received: by mail-qk0-f194.google.com with SMTP id n204so18684081qke.2
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 14:48:57 -0800 (PST)
In-Reply-To: <1479250126-15111-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is to facilitate converting from a singly-linked list to an array
of elements.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/bridge/br_netfilter_hooks.c | 8 ++++----
 net/netfilter/core.c            | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index ef8cfa7..1434de1 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1008,10 +1008,10 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	struct nf_hook_state state;
 	int ret;
 
-	elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
-
-	while (elem && (nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF))
-		elem = rcu_dereference(elem->next);
+	for (elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
+	     nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF;
+	     elem = rcu_dereference(elem->next))
+		;
 
 	if (!elem)
 		return okfn(net, sk, skb);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 2bb46e2..ce6adfa 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -107,10 +107,9 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	mutex_lock(&nf_hook_mutex);
 
 	/* Find the spot in the list */
-	while ((p = nf_entry_dereference(*pp)) != NULL) {
+	for (; (p = nf_entry_dereference(*pp)) != NULL; pp = &p->next) {
 		if (reg->priority < nf_hook_entry_priority(p))
 			break;
-		pp = &p->next;
 	}
 	rcu_assign_pointer(entry->next, p);
 	rcu_assign_pointer(*pp, entry);
@@ -137,12 +136,11 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 		return;
 
 	mutex_lock(&nf_hook_mutex);
-	while ((p = nf_entry_dereference(*pp)) != NULL) {
+	for (; (p = nf_entry_dereference(*pp)) != NULL; pp = &p->next) {
 		if (nf_hook_entry_ops(p) == reg) {
 			rcu_assign_pointer(*pp, p->next);
 			break;
 		}
-		pp = &p->next;
 	}
 	mutex_unlock(&nf_hook_mutex);
 	if (!p) {
-- 
2.7.4

