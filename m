From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: Re: [RFC PATCH] netfilter: call synchronize_net only once from nf_register_net_hooks
Date: Wed, 22 Nov 2017 15:30:40 +0100
Message-ID: <8737569yi7.fsf@redhat.com>
References: <20171122104026.7592-1-gscrivan@redhat.com>
        <20171122110606.GF24866@breakpoint.cc> <87a7zea73n.fsf@redhat.com>
        <20171122115659.GH24866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdKVOan (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:30:43 -0500
In-Reply-To: <20171122115659.GH24866@breakpoint.cc> (Florian Westphal's
        message of "Wed, 22 Nov 2017 12:56:59 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> writes:

> However, I suggest you try to go with call_rcu to get rid of all of the
> synchronize_net() calls. I don't even see why its still needed for
> nfqueue case provided we invoke the nfqueue drop handler first.
>
> PoC example, untested:

thanks, the patch seems to work for me, at least the problem I was
seeing before is now fixed.

Is there any reason for defining "struct nf_hook_entries_rcu_head"?

I've used this fixup patch and it works as well.  As someone new to the
code, I find it a bit easier to follow:


diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c08fd706d9c7..663046776def 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -77,12 +77,8 @@ struct nf_hook_entry {
 	void				*priv;
 };
 
-struct nf_hook_entries_rcu_head {
-	struct rcu_head head;
-	void            *allocation;
-};
-
 struct nf_hook_entries {
+	struct rcu_head                 head;
 	u16				num_hook_entries;
 	/* padding */
 	struct nf_hook_entry		hooks[];
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1f25c914f6e9..6bcf90948810 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -69,59 +69,34 @@ static DEFINE_MUTEX(nf_hook_mutex);
 #define nf_entry_dereference(e) \
 	rcu_dereference_protected(e, lockdep_is_held(&nf_hook_mutex))
 
-static struct nf_hook_entries_rcu_head *
-nf_hook_entries_rcu_head_get(struct nf_hook_entries *e)
-{
-	unsigned int num = e->num_hook_entries;
-	struct nf_hook_entries_rcu_head *head;
-	static struct nf_hook_ops **ops;
-
-        ops = nf_hook_entries_get_hook_ops(e);
-        head = (void *)&ops[num];
-
-	return head;
-}
-
 static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 {
 	struct nf_hook_entries *e;
 	size_t alloc = sizeof(*e) +
 		       sizeof(struct nf_hook_entry) * num +
-		       sizeof(struct nf_hook_ops *) * num +
-		       sizeof(struct nf_hook_entries_rcu_head);
+		       sizeof(struct nf_hook_ops *) * num;
 
 	if (num == 0)
 		return NULL;
 
 	e = kvzalloc(alloc, GFP_KERNEL);
 	if (e) {
-		struct nf_hook_entries_rcu_head *head;
-
 		e->num_hook_entries = num;
-
-		head = nf_hook_entries_rcu_head_get(e);
-		head->allocation = e;
 	}
 	return e;
 }
 
 void __nf_hook_entries_free(struct rcu_head *h)
 {
-	struct nf_hook_entries_rcu_head *head;
+	struct nf_hook_entries *entries;
 
-	head = container_of(h, struct nf_hook_entries_rcu_head, head);
-	kvfree(head->allocation);
+	entries = container_of(h, struct nf_hook_entries, head);
+	kvfree(entries);
 }
 
 void nf_hook_entries_free_rcu(struct nf_hook_entries *e)
 {
-	struct nf_hook_entries_rcu_head *head;
-
-	head = nf_hook_entries_rcu_head_get(e);
-	if (WARN_ON(e != head->allocation))
-		return;
-
-	call_rcu(&head->head, __nf_hook_entries_free);
+	call_rcu(&e->head, __nf_hook_entries_free);
 }
 
