From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8][CTNETLINK] Fix race condition on conntrack creation
Date: Tue, 25 Jul 2006 15:18:38 +0200
Message-ID: <44C61A2E.3060102@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010800040301080906060706"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010800040301080906060706
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Current conntrack creation path can run into rare race conditions, the 
insertion into hashes and timer activation must be done atomically.

This patch also:
  - remove functions helper_[find_get|put] that have no clients anymore
  - rework get_features facility to avoid a softlockup

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------010800040301080906060706
Content-Type: text/plain;
 name="04racy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04racy.patch"

[CTNETLINK] Fix race condition on conntrack creation

Current conntrack creation path can run into rare race conditions, the 
insertion into hashes and timer activation must be done atomically.

This patch also:
 - remove functions helper_[find_get|put] that have no clients anymore
 - rework get_features facility to avoid a softlockup

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-23 15:23:42.000000000 +0200
@@ -1059,13 +1059,9 @@ ctnetlink_create_conntrack(struct nfattr
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	ct->helper = ip_conntrack_helper_find_get(rtuple);
-
-	add_timer(&ct->timeout);
+	ct->helper = ip_conntrack_helper_find(rtuple);
 	ip_conntrack_hash_insert(ct);
-
-	if (ct->helper)
-		ip_conntrack_helper_put(ct->helper);
+	add_timer(&ct->timeout);
 
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
@@ -1107,11 +1103,11 @@ ctnetlink_new_conntrack(struct sock *ctn
 		h = __ip_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
-		write_unlock_bh(&ip_conntrack_lock);
 		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+		write_unlock_bh(&ip_conntrack_lock);
 		return err;
 	}
 	/* implicit 'else' */
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-23 18:11:43.000000000 +0200
@@ -1049,6 +1049,7 @@ ctnetlink_create_conntrack(struct nfattr
 			   struct nf_conntrack_tuple *rtuple)
 {
 	struct nf_conn *ct;
+	struct nf_conn_help *help;
 	int err = -EINVAL;
 
 	DEBUGP("entered %s\n", __FUNCTION__);
@@ -1079,8 +1080,11 @@ ctnetlink_create_conntrack(struct nfattr
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	add_timer(&ct->timeout);
+	help = nfct_help(ct);
+	if (help)
+		help->helper = nf_ct_helper_find(rtuple);
 	nf_conntrack_hash_insert(ct);
+	add_timer(&ct->timeout);
 
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
@@ -1124,11 +1128,11 @@ ctnetlink_new_conntrack(struct sock *ctn
 		h = __nf_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
-		write_unlock_bh(&nf_conntrack_lock);
 		DEBUGP("no such conntrack, create new\n");
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+		write_unlock_bh(&nf_conntrack_lock);
 		return err;
 	}
 	/* implicit 'else' */
Index: net-2.6/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- net-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/include/linux/netfilter_ipv4/ip_conntrack.h	2006-07-23 15:23:42.000000000 +0200
@@ -255,8 +255,7 @@ ip_ct_iterate_cleanup(int (*iter)(struct
 extern struct ip_conntrack_helper *
 __ip_conntrack_helper_find_byname(const char *);
 extern struct ip_conntrack_helper *
-ip_conntrack_helper_find_get(const struct ip_conntrack_tuple *tuple);
-extern void ip_conntrack_helper_put(struct ip_conntrack_helper *helper);
+ip_conntrack_helper_find(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_protocol *
 __ip_conntrack_proto_find(u_int8_t protocol);
Index: net-2.6/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-2.6.orig/include/net/netfilter/nf_conntrack.h	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/include/net/netfilter/nf_conntrack.h	2006-07-23 15:23:42.000000000 +0200
@@ -221,8 +221,7 @@ extern void nf_ct_remove_expectations(st
 extern void nf_conntrack_flush(void);
 
 extern struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
-extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
+nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
 
 extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-23 15:23:42.000000000 +0200
@@ -428,12 +428,12 @@ void ip_conntrack_hash_insert(struct ip_
 {
 	unsigned int hash, repl_hash;
 
+	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
+	
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	write_lock_bh(&ip_conntrack_lock);
 	__ip_conntrack_hash_insert(ct, hash, repl_hash);
-	write_unlock_bh(&ip_conntrack_lock);
 }
 
 /* Confirm a connection given skb; places it in hash table */
@@ -566,42 +566,14 @@ static inline int helper_cmp(const struc
 	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
 
-static struct ip_conntrack_helper *
-__ip_conntrack_helper_find( const struct ip_conntrack_tuple *tuple)
+struct ip_conntrack_helper *
+ip_conntrack_helper_find(const struct ip_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct ip_conntrack_helper *,
 			 tuple);
 }
 
-struct ip_conntrack_helper *
-ip_conntrack_helper_find_get( const struct ip_conntrack_tuple *tuple)
-{
-	struct ip_conntrack_helper *helper;
-
-	/* need ip_conntrack_lock to assure that helper exists until
-	 * try_module_get() is called */
-	read_lock_bh(&ip_conntrack_lock);
-
-	helper = __ip_conntrack_helper_find(tuple);
-	if (helper) {
-		/* need to increase module usage count to assure helper will
-		 * not go away while the caller is e.g. busy putting a
-		 * conntrack in the hash that uses the helper */
-		if (!try_module_get(helper->me))
-			helper = NULL;
-	}
-
-	read_unlock_bh(&ip_conntrack_lock);
-
-	return helper;
-}
-
-void ip_conntrack_helper_put(struct ip_conntrack_helper *helper)
-{
-	module_put(helper->me);
-}
-
 struct ip_conntrack_protocol *
 __ip_conntrack_proto_find(u_int8_t protocol)
 {
@@ -730,7 +702,7 @@ init_conntrack(struct ip_conntrack_tuple
 		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
 	} else {
-		conntrack->helper = __ip_conntrack_helper_find(&repl_tuple);
+		conntrack->helper = ip_conntrack_helper_find(&repl_tuple);
 
 		CONNTRACK_STAT_INC(new);
 	}
@@ -1055,7 +1027,7 @@ void ip_conntrack_alter_reply(struct ip_
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && conntrack->expecting == 0)
-		conntrack->helper = __ip_conntrack_helper_find(newreply);
+		conntrack->helper = ip_conntrack_helper_find(newreply);
 	write_unlock_bh(&ip_conntrack_lock);
 }
 
Index: net-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c	2006-07-23 15:23:42.000000000 +0200
@@ -954,8 +954,7 @@ EXPORT_SYMBOL_GPL(ip_conntrack_hash_inse
 
 EXPORT_SYMBOL_GPL(ip_ct_remove_expectations);
 
-EXPORT_SYMBOL_GPL(ip_conntrack_helper_find_get);
-EXPORT_SYMBOL_GPL(ip_conntrack_helper_put);
+EXPORT_SYMBOL_GPL(ip_conntrack_helper_find);
 EXPORT_SYMBOL_GPL(__ip_conntrack_helper_find_byname);
 
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_find_get);
Index: net-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-07-23 18:44:42.000000000 +0200
@@ -678,12 +678,12 @@ void nf_conntrack_hash_insert(struct nf_
 {
 	unsigned int hash, repl_hash;
 
+	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
+
 	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	write_lock_bh(&nf_conntrack_lock);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
-	write_unlock_bh(&nf_conntrack_lock);
 }
 
 /* Confirm a connection given skb; places it in hash table */
@@ -817,50 +817,51 @@ static inline int helper_cmp(const struc
 	return nf_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
 
-static struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
+struct nf_conntrack_helper *
+nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct nf_conntrack_helper *,
 			 tuple);
 }
 
-struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
+static u_int32_t __get_features(const struct nf_conntrack_tuple *orig,
+				const struct nf_conntrack_tuple *repl,
+				const struct nf_conntrack_l3proto *l3proto)
 {
+	u_int32_t features = l3proto->get_features(orig);
 	struct nf_conntrack_helper *helper;
 
-	/* need nf_conntrack_lock to assure that helper exists until
-	 * try_module_get() is called */
-	read_lock_bh(&nf_conntrack_lock);
-
-	helper = __nf_ct_helper_find(tuple);
-	if (helper) {
-		/* need to increase module usage count to assure helper will
-		 * not go away while the caller is e.g. busy putting a
-		 * conntrack in the hash that uses the helper */
-		if (!try_module_get(helper->me))
-			helper = NULL;
-	}
+	helper = nf_ct_helper_find(repl);
+	if (helper)
+		features |= NF_CT_F_HELP;
 
-	read_unlock_bh(&nf_conntrack_lock);
+	DEBUGP("nf_conntrack_alloc: features=0x%x\n", features);
 
-	return helper;
+	return features;
 }
 
-void nf_ct_helper_put(struct nf_conntrack_helper *helper)
+static u_int32_t get_features(const struct nf_conntrack_tuple *orig,
+			      const struct nf_conntrack_tuple *repl,
+			      const struct nf_conntrack_l3proto *l3proto)
 {
-	module_put(helper->me);
+	u_int32_t features;
+
+	/* Protect access to helper list */
+	read_lock_bh(&nf_conntrack_lock);
+	features = __get_features(orig, repl, l3proto);
+	read_unlock_bh(&nf_conntrack_lock);
+
+	return features;
 }
 
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
-		     const struct nf_conntrack_l3proto *l3proto)
+		     const struct nf_conntrack_l3proto *l3proto,
+		     u_int32_t features)
 {
 	struct nf_conn *conntrack = NULL;
-	u_int32_t features = 0;
-	struct nf_conntrack_helper *helper;
 
 	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
 		get_random_bytes(&nf_conntrack_hash_rnd, 4);
@@ -880,18 +881,6 @@ __nf_conntrack_alloc(const struct nf_con
 		}
 	}
 
-	/*  find features needed by this conntrack. */
-	features = l3proto->get_features(orig);
-
-	/* FIXME: protect helper list per RCU */
-	read_lock_bh(&nf_conntrack_lock);
-	helper = __nf_ct_helper_find(repl);
-	if (helper)
-		features |= NF_CT_F_HELP;
-	read_unlock_bh(&nf_conntrack_lock);
-
-	DEBUGP("nf_conntrack_alloc: features=0x%x\n", features);
-
 	read_lock_bh(&nf_ct_cache_lock);
 
 	if (unlikely(!nf_ct_cache[features].use)) {
@@ -908,11 +897,6 @@ __nf_conntrack_alloc(const struct nf_con
 
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
-	if (helper) {
-		struct nf_conn_help *help = nfct_help(conntrack);
-		NF_CT_ASSERT(help);
-		help->helper = helper;
-	}
 
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
@@ -933,9 +917,11 @@ struct nf_conn *nf_conntrack_alloc(const
 				   const struct nf_conntrack_tuple *repl)
 {
 	struct nf_conntrack_l3proto *l3proto;
+	u_int32_t features;
 
 	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
-	return __nf_conntrack_alloc(orig, repl, l3proto);
+	features = __get_features(orig, repl, l3proto);
+	return __nf_conntrack_alloc(orig, repl, l3proto, features);
 }
 
 void nf_conntrack_free(struct nf_conn *conntrack)
@@ -960,13 +946,17 @@ init_conntrack(const struct nf_conntrack
 	struct nf_conn *conntrack;
 	struct nf_conntrack_tuple repl_tuple;
 	struct nf_conntrack_expect *exp;
+	u_int32_t features;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
 
-	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto);
+	/* find features needed by this conntrack */
+	features = get_features(tuple, &repl_tuple, l3proto);
+
+	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto, features);
 	if (conntrack == NULL || IS_ERR(conntrack)) {
 		DEBUGP("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)conntrack;
@@ -995,8 +985,12 @@ init_conntrack(const struct nf_conntrack
 #endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
-	} else
+	} else {
+		struct nf_conn_help *help = nfct_help(conntrack);
+		if (help)
+			help->helper = nf_ct_helper_find(&repl_tuple);
 		NF_CT_STAT_INC(new);
+	}
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
Index: net-2.6/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_standalone.c	2006-07-23 15:23:39.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_standalone.c	2006-07-23 15:23:42.000000000 +0200
@@ -889,8 +889,7 @@ EXPORT_SYMBOL(nf_conntrack_alloc);
 EXPORT_SYMBOL(nf_conntrack_free);
 EXPORT_SYMBOL(nf_conntrack_flush);
 EXPORT_SYMBOL(nf_ct_remove_expectations);
-EXPORT_SYMBOL(nf_ct_helper_find_get);
-EXPORT_SYMBOL(nf_ct_helper_put);
+EXPORT_SYMBOL(nf_ct_helper_find);
 EXPORT_SYMBOL(__nf_conntrack_helper_find_byname);
 EXPORT_SYMBOL(__nf_conntrack_find);
 EXPORT_SYMBOL(nf_ct_unlink_expect);

--------------010800040301080906060706--
