From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/8] [PATCH] Helper modules load-on-demand support for
 ctnetlink
Date: Thu, 09 Oct 2008 18:43:25 +0200
Message-ID: <48EE34AD.6070909@netfilter.org>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083422.9824.35589.stgit@Decadence> <48EE085E.2020701@trash.net> <48EE0A9A.7010706@trash.net> <48EE1A33.4010603@netfilter.org> <48EE2D39.8090401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040803020609070107090100"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45612 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755489AbYJIQwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:52:09 -0400
In-Reply-To: <48EE2D39.8090401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040803020609070107090100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Patrick McHardy wrote:
>>>> This one doesn't apply:
>>>>
>>>> patching file include/net/netfilter/nf_conntrack_helper.h
>>>> patching file net/netfilter/nf_conntrack_core.c
>>>> Hunk #1 FAILED at 581.
>>>> Hunk #2 succeeded at 753 (offset -5 lines).
>>>> Hunk #3 succeeded at 764 (offset -5 lines).
>>>> 1 out of 3 hunks FAILED -- saving rejects to file
>>>> net/netfilter/nf_conntrack_core.c.rej
>>>> patching file net/netfilter/nf_conntrack_helper.c
>>>> patching file net/netfilter/nf_conntrack_netlink.c
>>>> Hunk #2 succeeded at 1131 with fuzz 1.
>>>> patching file net/netfilter/nfnetlink.c
>>> Oops, I think I didn't refresh my tree, so it didn't include any
>>> of the netfilter patches I sent to Dave :)
>>
>> So, what do I have to do now? I'm cloning Dave's tree now to put the
>> patches on top on it. Fine with it?
> 
> I think it was my mistake, let me try again ... yes, it applies
> cleanly. Both Dave's tree or my tree should work, but use Dave's
> if you want to be safe since I haven't updated mine yet.

OK, attached the new version of the patch.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040803020609070107090100
Content-Type: text/x-diff;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

[PATCH] Helper modules load-on-demand support for ctnetlink

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds module loading for helpers via ctnetlink.

* Creation path: We support explicit and implicit helper assignation. For
  the explicit case, we try to load the module. If the module is correctly
  loaded and the helper is present, we return EAGAIN to re-start the
  creation. Otherwise, we return EOPNOTSUPP.
* Update path: release the spin lock, load the module and check. If it is
  present, then return EAGAIN to re-start the update.

This patch includes a minor change in nfnetlink to support EAGAIN.
Based on a suggestion from Patrick McHardy.

This patch provides a refactorized function to lookup-and-set the
connection tracking helper. The function removes the exported symbol
__nf_ct_helper_find as it has not clients anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink.h         |    3 +
 include/net/netfilter/nf_conntrack_helper.h |    5 +-
 net/netfilter/nf_conntrack_core.c           |   28 +---------
 net/netfilter/nf_conntrack_helper.c         |   33 +++++++++++-
 net/netfilter/nf_conntrack_netlink.c        |   73 ++++++++++++++++++++++++---
 net/netfilter/nfnetlink.c                   |   12 +++-
 6 files changed, 111 insertions(+), 43 deletions(-)


diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 0d8424f..7d8e045 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -78,6 +78,9 @@ extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group,
 			  int echo);
 extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
 
+extern void nfnl_lock(void);
+extern void nfnl_unlock(void);
+
 #define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
 	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
 
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index f8060ab..8eebf6e 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -39,9 +39,6 @@ struct nf_conntrack_helper
 };
 
 extern struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple);
-
-extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
@@ -49,6 +46,8 @@ extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
 extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
+extern int __nf_ct_set_helper(struct nf_conn *ct, gfp_t flags);
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 27de3c7..54e35f3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -581,14 +581,7 @@ init_conntrack(struct net *net,
 		nf_conntrack_get(&ct->master->ct_general);
 		NF_CT_STAT_INC(net, expect_new);
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
 		NF_CT_STAT_INC(net, new);
 	}
 
@@ -765,7 +758,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 			      const struct nf_conntrack_tuple *newreply)
 {
 	struct nf_conn_help *help = nfct_help(ct);
-	struct nf_conntrack_helper *helper;
 
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
@@ -778,23 +770,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 		return;
 
 	rcu_read_lock();
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
+	__nf_ct_set_helper(ct, GFP_ATOMIC);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 9c06b9f..86cdbde 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -44,7 +44,7 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
 		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
 }
 
-struct nf_conntrack_helper *
+static struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *helper;
@@ -62,7 +62,6 @@ __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__nf_ct_helper_find);
 
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name)
@@ -94,6 +93,36 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
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
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f38c649..98939e6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -952,8 +952,23 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 	}
 
 	helper = __nf_conntrack_helper_find_byname(helpname);
-	if (helper == NULL)
+	if (helper == NULL) {
+#ifdef CONFIG_KMOD
+		spin_unlock_bh(&nf_conntrack_lock);
+		nfnl_unlock();
+		if (request_module("nfct-helper-%s", helpname) < 0) {
+			nfnl_lock();
+			spin_lock_bh(&nf_conntrack_lock);
+			return -EOPNOTSUPP;
+		}
+		nfnl_lock();
+		spin_lock_bh(&nf_conntrack_lock);
+		helper = __nf_conntrack_helper_find_byname(helpname);
+		if (helper)
+			return -EAGAIN;
+#endif
 		return -EOPNOTSUPP;
+	}
 
 	if (help) {
 		if (help->helper == helper)
@@ -1117,7 +1132,6 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
-	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
 
 	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_KERNEL);
@@ -1132,16 +1146,57 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	ct->status |= IPS_CONFIRMED;
 
 	rcu_read_lock();
-	helper = __nf_ct_helper_find(rtuple);
-	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-		if (help == NULL) {
+ 	if (cda[CTA_HELP]) {
+ 		char *helpname;
+ 
+ 		err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
+ 		if (err < 0) {
+			rcu_read_unlock();
+			goto err;
+		}
+
+		helper = __nf_conntrack_helper_find_byname(helpname);
+		if (helper == NULL) {
+			rcu_read_unlock();
+#ifdef CONFIG_KMOD
+			nfnl_unlock();
+			if (request_module("nfct-helper-%s", helpname) < 0) {
+				nfnl_lock();
+				err = -EOPNOTSUPP;
+				goto err;
+			}
+			nfnl_lock();
+			rcu_read_lock();
+			helper = __nf_conntrack_helper_find_byname(helpname);
+			if (helper) {
+				rcu_read_unlock();
+				err = -EAGAIN;
+				goto err;
+			}
+			rcu_read_unlock();
+#endif
+			err = -EOPNOTSUPP;
+			goto err;
+		} else {
+			struct nf_conn_help *help;
+
+			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+			if (help == NULL) {
+				rcu_read_unlock();
+				err = -ENOMEM;
+				goto err;
+			}
+
+			/* not in hash table yet so not strictly necessary */
+			rcu_assign_pointer(help->helper, helper);
+		}
+	} else {
+		/* try an implicit helper assignation */
+		err = __nf_ct_set_helper(ct, GFP_ATOMIC);
+		if (err == -ENOMEM) {
 			rcu_read_unlock();
-			err = -ENOMEM;
 			goto err;
 		}
-		/* not in hash table yet so not strictly necessary */
-		rcu_assign_pointer(help->helper, helper);
 	}
 
 	if (cda[CTA_STATUS]) {
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index b75c9c4..4739f9f 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -44,15 +44,17 @@ static struct sock *nfnl = NULL;
 static const struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
 static DEFINE_MUTEX(nfnl_mutex);
 
-static inline void nfnl_lock(void)
+void nfnl_lock(void)
 {
 	mutex_lock(&nfnl_mutex);
 }
+EXPORT_SYMBOL_GPL(nfnl_lock);
 
-static inline void nfnl_unlock(void)
+void nfnl_unlock(void)
 {
 	mutex_unlock(&nfnl_mutex);
 }
+EXPORT_SYMBOL_GPL(nfnl_unlock);
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
@@ -132,6 +134,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return 0;
 
 	type = nlh->nlmsg_type;
+replay:
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_KMOD
@@ -165,7 +168,10 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		} else
 			return -EINVAL;
 
-		return nc->call(nfnl, skb, nlh, cda);
+		err = nc->call(nfnl, skb, nlh, cda);
+		if (err == -EAGAIN)
+			goto replay;
+		return err;
 	}
 }
 

--------------040803020609070107090100--
