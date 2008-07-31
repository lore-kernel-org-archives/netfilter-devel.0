From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Thu, 31 Jul 2008 11:44:48 +0200
Message-ID: <48918990.3010309@netfilter.org>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org> <48906E10.9020902@trash.net> <48917974.3090304@netfilter.org> <48917BD0.9050105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070708080307060104090308"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42915 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753264AbYGaJo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:44:57 -0400
In-Reply-To: <48917BD0.9050105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070708080307060104090308
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Moreover, someone may remove the module in the middle just after the
>> module loading but, well, we have lost the race in the case.
> 
> I'd do something similar to qdiscs etc:
> 
> - lookup helper
> - if not found: request_module, take lock again, repeat lookup, return
> EAGAIN if found now
> - in the nfnetlink command handler: if ret == EAGAIN replay message
> 
> grep for "replay" in net/ for a few examples of this. This also
> handles the race BTW.

Nice. Thanks for the explanation :). I'll check if I can cook a couple
of patches to do it that way at some point.

>>> Second, this implicit helper assignment is also a bit unusual,
>>> why don't we simply insist that the conntrack has a helper
>>> assigned through the ctnetlink conntrack interface?
>>
>> If I understood well, then we simply assign the helper to the conntrack
>> and the expectation part of ctnetlink should rely on the existing
>> assigned helper, right?
> 
> Yes, I think thats cleaner.
>>
>> Please, have a look at the patch attached.
> 
> Looks fine.

Would you also apply the following two patches before looking at [PATCH
5/7]?

The first patch is a refactorization that was in the previous version of
4/7, the latter is a minor return value change to make it consistent
with others error values in ctnetlink.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070708080307060104090308
Content-Type: text/x-diff;
 name="04.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.patch"

[PATCH] helper assignation code refactorization

This refactorization provides a function to lookup-and-set the
connection tracking helper. The function removes the exported symbol
__nf_ct_helper_find as it has not clients anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2008-07-31 09:14:25.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_core.c	2008-07-31 11:07:55.000000000 +0200
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
 
Index: net-next-2.6.git/include/net/netfilter/nf_conntrack_helper.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack_helper.h	2008-07-31 10:31:08.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack_helper.h	2008-07-31 11:07:55.000000000 +0200
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
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_helper.c	2008-07-31 09:14:25.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_helper.c	2008-07-31 11:07:55.000000000 +0200
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
Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-31 11:32:17.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-31 11:40:32.000000000 +0200
@@ -1120,8 +1120,6 @@ ctnetlink_create_conntrack(struct nlattr
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
-	struct nf_conn_help *help;
-	struct nf_conntrack_helper *helper;
 
 	ct = nf_conntrack_alloc(otuple, rtuple, GFP_KERNEL);
 	if (ct == NULL || IS_ERR(ct))
@@ -1152,16 +1150,10 @@ ctnetlink_create_conntrack(struct nlattr
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
+	if (__nf_ct_set_helper(ct, GFP_KERNEL) == -ENOMEM) {
+		rcu_read_unlock();
+		err = -ENOMEM;
+		goto err;
 	}
 
 	/* setup master conntrack: this is a confirmed expectation */

--------------070708080307060104090308
Content-Type: text/x-diff;
 name="04b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04b.patch"

[PATCH] use EOPNOTSUPP instead of EINVAL if the conntrack has no helper

This patch changes the return value if the conntrack has no helper assigned.
Instead of EINVAL, which is reserved for malformed messages, it returns 
EOPNOTSUPP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-31 11:40:32.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-31 11:40:40.000000000 +0200
@@ -1694,7 +1694,7 @@ ctnetlink_create_expect(struct nlattr *c
 
 	if (!help || !help->helper) {
 		/* such conntrack hasn't got any helper, abort */
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 		goto out;
 	}
 

--------------070708080307060104090308--
