From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: expect: add to hash table after expect init
Date: Mon, 10 Jul 2017 15:06:39 +0200
Message-ID: <20170710130639.24167-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47658 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753528AbdGJNG1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 09:06:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

assuming we have lockless readers we should make sure they can only
see expectations that have already been initialized.

hlist_add_head_rcu acts as memory barrier, move it after timer setup.

Theoretically we could crash due to a del_timer() on other cpu
seeing garbage data.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not seen in practice, however i think this race
 is real.  Defer to nf-next if you think its not urgent.

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e03d16ed550d..c034951597fe 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -368,12 +368,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	/* two references : one for hash insert, one for the timer */
 	refcount_add(2, &exp->use);
 
-	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
-
-	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
-	net->ct.expect_count++;
-
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
 	helper = rcu_dereference_protected(master_help->helper,
@@ -384,6 +378,12 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	}
 	add_timer(&exp->timeout);
 
+	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
+	master_help->expecting[exp->class]++;
+
+	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
+	net->ct.expect_count++;
+
 	NF_CT_STAT_INC(net, expect_create);
 }
 
-- 
2.13.0

