From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/10][CONNTRACK] Remove unused helper_[find_get|put]
	functions
Date: Fri, 07 Jul 2006 04:14:22 +0200
Message-ID: <44ADC37E.1000707@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040303080303020700030702"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------040303080303020700030702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Remove unused functions for conntrack application helpers

This patch depends on [PATCH 3/10]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040303080303020700030702
Content-Type: text/plain;
 name="05helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05helper.patch"

[CONNTRACK] Remove unused helper_[find_get|put] functions

Remove unused functions for conntrack application helpers

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-07-06 23:35:25.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-07-06 23:36:44.000000000 +0200
@@ -817,42 +817,14 @@ static inline int helper_cmp(const struc
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
-{
-	struct nf_conntrack_helper *helper;
-
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
-
-	read_unlock_bh(&nf_conntrack_lock);
-
-	return helper;
-}
-
-void nf_ct_helper_put(struct nf_conntrack_helper *helper)
-{
-	module_put(helper->me);
-}
-
 static struct nf_conn *
 __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 		     const struct nf_conntrack_tuple *repl,
@@ -885,7 +857,7 @@ __nf_conntrack_alloc(const struct nf_con
 
 	/* FIXME: protect helper list per RCU */
 	read_lock_bh(&nf_conntrack_lock);
-	helper = __nf_ct_helper_find(repl);
+	helper = nf_ct_helper_find(repl);
 	if (helper)
 		features |= NF_CT_F_HELP;
 	read_unlock_bh(&nf_conntrack_lock);
Index: net-2.6/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-2.6.orig/include/net/netfilter/nf_conntrack.h	2006-07-06 23:34:35.000000000 +0200
+++ net-2.6/include/net/netfilter/nf_conntrack.h	2006-07-06 23:35:25.000000000 +0200
@@ -221,8 +221,7 @@ extern void nf_ct_remove_expectations(st

 extern void nf_conntrack_flush(void);
 
 extern struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
-extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
+nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
 
 extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
Index: net-2.6/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_standalone.c	2006-07-06 23:34:35.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_standalone.c	2006-07-06 23:35:25.000000000 +0200
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
Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06 23:35:25.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06 23:36:24.000000000 +0200
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
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2006-07-06 23:34:35.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c	2006-07-06 23:35:25.000000000 +0200
@@ -954,8 +954,7 @@ EXPORT_SYMBOL_GPL(ip_conntrack_hash_inse
 
 EXPORT_SYMBOL_GPL(ip_ct_remove_expectations);
 
-EXPORT_SYMBOL_GPL(ip_conntrack_helper_find_get);
-EXPORT_SYMBOL_GPL(ip_conntrack_helper_put);
+EXPORT_SYMBOL_GPL(ip_conntrack_helper_find);
 EXPORT_SYMBOL_GPL(__ip_conntrack_helper_find_byname);
 
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_find_get);
Index: net-2.6/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- net-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2006-07-06 23:34:35.000000000 +0200
+++ net-2.6/include/linux/netfilter_ipv4/ip_conntrack.h	2006-07-06 23:35:25.000000000 +0200
@@ -255,8 +255,7 @@ ip_ct_iterate_cleanup(int (*iter)(struct
 extern struct ip_conntrack_helper *
 __ip_conntrack_helper_find_byname(const char *);
 extern struct ip_conntrack_helper *
-ip_conntrack_helper_find_get(const struct ip_conntrack_tuple *tuple);
-extern void ip_conntrack_helper_put(struct ip_conntrack_helper *helper);
+ip_conntrack_helper_find(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_protocol *
 __ip_conntrack_proto_find(u_int8_t protocol);

--------------040303080303020700030702--
