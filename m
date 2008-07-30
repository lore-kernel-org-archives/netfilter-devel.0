From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Wed, 30 Jul 2008 13:03:59 +0200
Message-ID: <48904A9F.8010509@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050804010907080308070406"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39485 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752858AbYG3LEH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:04:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050804010907080308070406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] Helper modules load on-demand support for ctnetlink

This patch adds helper load on-demand support for ctnetlink. This patch
also refactorizes the code to provide a couple of functions to look up
and set the connection tracking helper. The function removes the
exported symbol __nf_ct_helper_find as it has not clients anymore.

This patch uses the persistent helper aliasing defined in the previous
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050804010907080308070406
Content-Type: text/x-diff;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

[PATCH] Helper modules load on-demand support for ctnetlink

This patch adds helper load on-demand support for ctnetlink. This patch
also refactorizes the code to provide a couple of functions to look up 
and set the connection tracking helper. The function removes the exported
symbol __nf_ct_helper_find as it has not clients anymore.

This patch uses the persistent helper aliasing defined in the previous 
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2008-07-30 08:50:04.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_core.c	2008-07-30 08:54:09.000000000 +0200
@@ -578,14 +578,7 @@ init_conntrack(const struct nf_conntrack
 		nf_conntrack_get(&ct->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
-		struct nf_conntrack_helper *helper;
-
-		helper = __nf_ct_helper_find(&repl_tuple);
-		if (helper) {
-			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-			if (help)
-				rcu_assign_pointer(help->helper, helper);
-		}
+		__nf_ct_set_helper(ct, GFP_ATOMIC);
 		NF_CT_STAT_INC(new);
 	}
 
@@ -757,7 +750,6 @@ void nf_conntrack_alter_reply(struct nf_
 			      const struct nf_conntrack_tuple *newreply)
 {
 	struct nf_conn_help *help = nfct_help(ct);
-	struct nf_conntrack_helper *helper;
 
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
@@ -769,25 +761,7 @@ void nf_conntrack_alter_reply(struct nf_
 	if (ct->master || (help && !hlist_empty(&help->expectations)))
 		return;
 
-	rcu_read_lock();
-	helper = __nf_ct_helper_find(newreply);
-	if (helper == NULL) {
-		if (help)
-			rcu_assign_pointer(help->helper, NULL);
-		goto out;
-	}
-
-	if (help == NULL) {
-		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-		if (help == NULL)
-			goto out;
-	} else {
-		memset(&help->help, 0, sizeof(help->help));
-	}
-
-	rcu_assign_pointer(help->helper, helper);
-out:
-	rcu_read_unlock();
+	nf_ct_set_helper(ct, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 
Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-30 08:50:04.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:00:05.000000000 +0200
@@ -1120,8 +1120,6 @@ ctnetlink_create_conntrack(struct nlattr
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
-	struct nf_conn_help *help;
-	struct nf_conntrack_helper *helper;
 
 	ct = nf_conntrack_alloc(otuple, rtuple, GFP_KERNEL);
 	if (ct == NULL || IS_ERR(ct))
@@ -1152,17 +1150,7 @@ ctnetlink_create_conntrack(struct nlattr
 #endif
 
 	rcu_read_lock();
-	helper = __nf_ct_helper_find(rtuple);
-	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
-		if (help == NULL) {
-			rcu_read_unlock();
-			err = -ENOMEM;
-			goto err;
-		}
-		/* not in hash table yet so not strictly necessary */
-		rcu_assign_pointer(help->helper, helper);
-	}
+	__nf_ct_set_helper(ct, GFP_KERNEL);
 
 	/* setup master conntrack: this is a confirmed expectation */
 	if (master_ct) {
@@ -1672,9 +1660,24 @@ ctnetlink_create_expect(struct nlattr *c
 	help = nfct_help(ct);
 
 	if (!help || !help->helper) {
-		/* such conntrack hasn't got any helper, abort */
+#ifdef CONFIG_KMOD
+		char *name;
+
 		err = -EINVAL;
+		if (!cda[CTA_EXPECT_HELP_NAME])
+			goto out;
+
+		err = -ENOTSUPP;
+		name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
+		if (request_module("nfct-helper-%s", name) < 0)
+			goto out;
+
+		if (nf_ct_set_helper(ct, GFP_KERNEL) < 0)
+			goto out;
+#else
+		err = -ENOTSUPP;
 		goto out;
+#endif
 	}
 
 	exp = nf_ct_expect_alloc(ct);
Index: net-next-2.6.git/include/net/netfilter/nf_conntrack_helper.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack_helper.h	2008-07-30 08:50:04.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack_helper.h	2008-07-30 08:54:09.000000000 +0200
@@ -39,9 +39,6 @@ struct nf_conntrack_helper
 };
 
 extern struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
-
-extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
@@ -49,6 +46,19 @@ extern void nf_conntrack_helper_unregist
 
 extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
+extern int __nf_ct_set_helper(struct nf_conn *ct, gfp_t flags);
+
+static inline int nf_ct_set_helper(struct nf_conn *ct, gfp_t flags)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __nf_ct_set_helper(ct, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
Index: net-next-2.6.git/net/netfilter/nf_conntrack_helper.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_helper.c	2008-07-30 08:50:04.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_helper.c	2008-07-30 08:54:09.000000000 +0200
@@ -43,7 +43,7 @@ static unsigned int helper_hash(const st
 		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
 }
 
-struct nf_conntrack_helper *
+static struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *helper;
@@ -61,7 +61,6 @@ __nf_ct_helper_find(const struct nf_conn
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__nf_ct_helper_find);
 
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name)
@@ -93,6 +92,36 @@ struct nf_conn_help *nf_ct_helper_ext_ad
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
+int __nf_ct_set_helper(struct nf_conn *ct, gfp_t flags)
+{
+	int ret = 0;
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help = nfct_help(ct);
+
+	helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	if (helper == NULL) {
+		if (help)
+			rcu_assign_pointer(help->helper, NULL);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (help == NULL) {
+		help = nf_ct_helper_ext_add(ct, flags);
+		if (help == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		memset(&help->help, 0, sizeof(help->help));
+	}
+
+	rcu_assign_pointer(help->helper, helper);
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__nf_ct_set_helper);
+
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {

--------------050804010907080308070406--
