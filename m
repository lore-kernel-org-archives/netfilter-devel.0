From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: [RFC PATCH] netfilter: call synchronize_net only once from nf_register_net_hooks
Date: Wed, 22 Nov 2017 11:40:26 +0100
Message-ID: <20171122104026.7592-1-gscrivan@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbdKVKka (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 05:40:30 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D2BF6868E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 10:40:30 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SELinux, if enabled, registers for each new network namespace 6
netfilter hooks.  Avoid to use synchronize_net for each new hook, but do
it once after all the hooks are added.  The net benefit on an SMP
machine with two cores is that creating a new network namespace takes
-40% of the original time.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 net/netfilter/core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 52cd2901a097..beeb0b36f429 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -252,7 +252,7 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	return NULL;
 }
 
-int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
+static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries *p, *new_hooks;
 	struct nf_hook_entries __rcu **pp;
@@ -291,11 +291,19 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 #ifdef HAVE_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
-	synchronize_net();
 	BUG_ON(p == new_hooks);
 	kvfree(p);
 	return 0;
 }
+
+int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
+{
+	int ret = __nf_register_net_hook(net, reg);
+	if (ret < 0)
+		return ret;
+	synchronize_net();
+	return 0;
+}
 EXPORT_SYMBOL(nf_register_net_hook);
 
 /*
@@ -379,10 +387,11 @@ int nf_register_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 	int err = 0;
 
 	for (i = 0; i < n; i++) {
-		err = nf_register_net_hook(net, &reg[i]);
+		err = __nf_register_net_hook(net, &reg[i]);
 		if (err)
 			goto err;
 	}
+	synchronize_net();
 	return err;
 
 err:
-- 
2.14.3

