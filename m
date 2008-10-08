From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 12/79: netns nf_conntrack: add ->ct_net pointer from conntrack to netns
Date: Wed,  8 Oct 2008 12:46:37 +0200 (MEST)
Message-ID: <20081008104637.10423.24342.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45886 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYJHKqi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:38 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5a1fb391d881905e89623d78858d05b248cbc86a
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:02 2008 +0200

    netfilter: netns nf_conntrack: add ->ct_net pointer from conntrack to netns
    
    Conntrack (struct nf_conn) gets pointer to netns: ->ct_net -- netns in which
    it was created. It comes from netdevice.
    
    ->ct_net is write-once field.
    
    Every conntrack in system has ->ct_net initialized, no exceptions.
    
    ->ct_net doesn't pin netns: conntracks are recycled after timeouts and
    pinning background traffic will prevent netns from even starting shutdown
    sequence.
    
    Right now every conntrack is created in init_net.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 0741ad5..2b8d6ef 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -123,7 +123,9 @@ struct nf_conn
 
 	/* Extensions */
 	struct nf_ct_ext *ext;
-
+#ifdef CONFIG_NET_NS
+	struct net *ct_net;
+#endif
 	struct rcu_head rcu;
 };
 
@@ -147,6 +149,17 @@ static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
+extern struct net init_net;
+
+static inline struct net *nf_ct_net(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NET_NS
+	return ct->ct_net;
+#else
+	return &init_net;
+#endif
+}
+
 /* Alter reply tuple (maybe alter helper). */
 extern void
 nf_conntrack_alter_reply(struct nf_conn *ct,
@@ -251,7 +264,8 @@ extern void
 nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
-nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
+nf_conntrack_alloc(struct net *net,
+		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_tuple *repl,
 		   gfp_t gfp);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ee79e93..cefc338 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -464,7 +464,8 @@ static noinline int early_drop(unsigned int hash)
 	return dropped;
 }
 
-struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
+struct nf_conn *nf_conntrack_alloc(struct net *net,
+				   const struct nf_conntrack_tuple *orig,
 				   const struct nf_conntrack_tuple *repl,
 				   gfp_t gfp)
 {
@@ -503,6 +504,9 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
 	setup_timer(&ct->timeout, death_by_timeout, (unsigned long)ct);
+#ifdef CONFIG_NET_NS
+	ct->ct_net = net;
+#endif
 	INIT_RCU_HEAD(&ct->rcu);
 
 	return ct;
@@ -528,7 +532,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_free);
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct nf_conntrack_tuple_hash *
-init_conntrack(const struct nf_conntrack_tuple *tuple,
+init_conntrack(struct net *net,
+	       const struct nf_conntrack_tuple *tuple,
 	       struct nf_conntrack_l3proto *l3proto,
 	       struct nf_conntrack_l4proto *l4proto,
 	       struct sk_buff *skb,
@@ -544,7 +549,7 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 		return NULL;
 	}
 
-	ct = nf_conntrack_alloc(tuple, &repl_tuple, GFP_ATOMIC);
+	ct = nf_conntrack_alloc(net, tuple, &repl_tuple, GFP_ATOMIC);
 	if (ct == NULL || IS_ERR(ct)) {
 		pr_debug("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)ct;
@@ -631,7 +636,8 @@ resolve_normal_ct(struct sk_buff *skb,
 	/* look for tuple match */
 	h = nf_conntrack_find_get(&tuple);
 	if (!h) {
-		h = init_conntrack(&tuple, l3proto, l4proto, skb, dataoff);
+		h = init_conntrack(&init_net, &tuple, l3proto, l4proto, skb,
+				   dataoff);
 		if (!h)
 			return NULL;
 		if (IS_ERR(h))
@@ -1185,6 +1191,9 @@ int nf_conntrack_init(struct net *net)
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
+#ifdef CONFIG_NET_NS
+	nf_conntrack_untracked.ct_net = &init_net;
+#endif
 	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a875203..da3cdc8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1125,7 +1125,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
 
-	ct = nf_conntrack_alloc(otuple, rtuple, GFP_KERNEL);
+	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_KERNEL);
 	if (ct == NULL || IS_ERR(ct))
 		return -ENOMEM;
 
