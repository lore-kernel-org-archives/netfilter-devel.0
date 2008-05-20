From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] deliver events for conntracks created/updated via
 ctnetlink
Date: Wed, 21 May 2008 00:39:53 +0200
Message-ID: <48335339.2050007@netfilter.org>
References: <483350D9.7010809@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010109060503010803080201"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44942 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934554AbYETWkJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:40:09 -0400
In-Reply-To: <483350D9.7010809@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010109060503010803080201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> As for now, the creation and update of conntracks via ctnetlink do not
> propagate an event to userspace. This can result in inconsistent
> situations if several userspace processes modify the connection tracking
> table by means of ctnetlink at the same time. Specifically, using the
> conntrack-cli while running an instance of conntrackde unsynchronizes
> the cache of conntrackd with the kernel conntrack table. Note that
> deletions do not suffer from this problem.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Same problem, the previous patch rejects one chunk if you try to apply
it to current davem's tree. The one attached should be fine.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010109060503010803080201
Content-Type: text/x-patch;
 name="05.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.patch"

[PATCH] deliver events for conntracks created via ctnetlink

As for now, the creation and update of conntracks via ctnetlink do not
propagate an event to userspace. This can result in inconsistent situations
if several userspace processes modify the connection tracking table by means
of ctnetlink at the same time. Specifically, using the conntrack command
line tool and conntrackd at the same time can trigger unconsistencies. 

This patch fixes this inconsistent situation. Note that the deletion does
not suffer from this problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-21 00:34:15.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-05-21 00:36:06.000000000 +0200
@@ -529,6 +529,11 @@ nla_put_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
+
+static struct notifier_block ctnl_notifier = {
+	.notifier_call	= ctnetlink_conntrack_event,
+};
+
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static int ctnetlink_done(struct netlink_callback *cb)
@@ -883,7 +888,7 @@ out:
 }
 
 static int
-ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[], int *events)
 {
 	unsigned long d;
 	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
@@ -930,12 +935,15 @@ ctnetlink_change_status(struct nf_conn *
 	 * so don't let users modify them directly if they don't pass
 	 * nf_nat_range. */
 	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
+
+	*events |= IPCT_STATUS;
+
 	return 0;
 }
 
 
 static inline int
-ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[], int *events)
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help = nfct_help(ct);
@@ -979,11 +987,13 @@ ctnetlink_change_helper(struct nf_conn *
 
 	rcu_assign_pointer(help->helper, helper);
 
+	*events |= IPCT_HELPER;
+
 	return 0;
 }
 
 static inline int
-ctnetlink_change_timeout(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_timeout(struct nf_conn *ct, struct nlattr *cda[], int *events)
 {
 	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
@@ -993,11 +1003,15 @@ ctnetlink_change_timeout(struct nf_conn 
 	ct->timeout.expires = jiffies + timeout * HZ;
 	add_timer(&ct->timeout);
 
+	*events |= IPCT_REFRESH;
+
 	return 0;
 }
 
 static inline int
-ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_protoinfo(struct nf_conn *ct,
+			   struct nlattr *cda[],
+			   int *events)
 {
 	struct nlattr *tb[CTA_PROTOINFO_MAX+1], *attr = cda[CTA_PROTOINFO];
 	struct nf_conntrack_l4proto *l4proto;
@@ -1006,8 +1020,11 @@ ctnetlink_change_protoinfo(struct nf_con
 	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
 
 	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	if (l4proto->from_nlattr)
+	if (l4proto->from_nlattr) {
 		err = l4proto->from_nlattr(tb, ct);
+		if (err == 0)
+			*events |= IPCT_PROTOINFO;
+	}
 	nf_ct_l4proto_put(l4proto);
 
 	return err;
@@ -1043,7 +1060,9 @@ change_nat_seq_adj(struct nf_nat_seq *na
 }
 
 static int
-ctnetlink_change_nat_seq_adj(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_nat_seq_adj(struct nf_conn *ct,
+			     struct nlattr *cda[],
+			     int *events)
 {
 	int ret = 0;
 	struct nf_conn_nat *nat = nfct_nat(ct);
@@ -1058,6 +1077,8 @@ ctnetlink_change_nat_seq_adj(struct nf_c
 			return ret;
 
 		ct->status |= IPS_SEQ_ADJUST;
+
+		*events |= IPCT_NATSEQADJ;
 	}
 
 	if (cda[CTA_NAT_SEQ_ADJ_REPLY]) {
@@ -1067,6 +1088,8 @@ ctnetlink_change_nat_seq_adj(struct nf_c
 			return ret;
 
 		ct->status |= IPS_SEQ_ADJUST;
+
+		*events |= IPCT_NATSEQADJ;
 	}
 
 	return 0;
@@ -1074,47 +1097,53 @@ ctnetlink_change_nat_seq_adj(struct nf_c
 #endif
 
 static int
-ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
+ctnetlink_change_conntrack(struct nf_conn *ct,
+			   struct nlattr *cda[],
+			   unsigned int *events)
 {
 	int err;
 
 	if (cda[CTA_HELP]) {
-		err = ctnetlink_change_helper(ct, cda);
+		err = ctnetlink_change_helper(ct, cda, events);
 		if (err < 0)
 			return err;
 	}
 
 	if (cda[CTA_TIMEOUT]) {
-		err = ctnetlink_change_timeout(ct, cda);
+		err = ctnetlink_change_timeout(ct, cda, events);
 		if (err < 0)
 			return err;
 	}
 
 	if (cda[CTA_STATUS]) {
-		err = ctnetlink_change_status(ct, cda);
+		err = ctnetlink_change_status(ct, cda, events);
 		if (err < 0)
 			return err;
 	}
 
 	if (cda[CTA_PROTOINFO]) {
-		err = ctnetlink_change_protoinfo(ct, cda);
+		err = ctnetlink_change_protoinfo(ct, cda, events);
 		if (err < 0)
 			return err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		*events |= IPCT_MARK;
+	}
 #endif
 
 #if defined(CONFIG_NF_CONNTRACK_SECMARK)
-	if (cda[CTA_SECMARK])
+	if (cda[CTA_SECMARK]) {
 		ct->secmark = ntohl(nla_get_be32(cda[CTA_SECMARK]));
+		*events |= IPCT_SECMARK;
+	}
 #endif
 
 #ifdef CONFIG_NF_NAT_NEEDED
 	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
-		err = ctnetlink_change_nat_seq_adj(ct, cda);
+		err = ctnetlink_change_nat_seq_adj(ct, cda, events);
 		if (err < 0)
 			return err;
 	}
@@ -1133,6 +1162,7 @@ ctnetlink_create_conntrack(struct nlattr
 	int err = -EINVAL;
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
+	unsigned long events = IPCT_REFRESH;
 
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
@@ -1146,20 +1176,22 @@ ctnetlink_create_conntrack(struct nlattr
 	ct->status |= IPS_CONFIRMED;
 
 	if (cda[CTA_STATUS]) {
-		err = ctnetlink_change_status(ct, cda);
+		err = ctnetlink_change_status(ct, cda, &events);
 		if (err < 0)
 			goto err;
 	}
 
 	if (cda[CTA_PROTOINFO]) {
-		err = ctnetlink_change_protoinfo(ct, cda);
+		err = ctnetlink_change_protoinfo(ct, cda, &events);
 		if (err < 0)
 			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		events |= IPCT_MARK;
+	}
 #endif
 
 	rcu_read_lock();
@@ -1173,18 +1205,28 @@ ctnetlink_create_conntrack(struct nlattr
 		}
 		/* not in hash table yet so not strictly necessary */
 		rcu_assign_pointer(help->helper, helper);
+
+		events |= IPCT_HELPER;
 	}
 
 	/* setup master conntrack: this is a confirmed expectation */
 	if (master_ct) {
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
-	}
+		events |= IPCT_RELATED;
+	} else
+		events |= IPCT_NEW;
+
+	atomic_inc(&ct->ct_general.use);
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 	rcu_read_unlock();
 
+	ctnetlink_conntrack_event(&ctnl_notifier, events, ct);
+
+	nf_ct_put(ct);
+
 	return 0;
 
 err:
@@ -1260,6 +1302,9 @@ ctnetlink_new_conntrack(struct sock *ctn
 	 * so there's no need to increase the refcount */
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		unsigned long events = 0;
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
 		/* we only allow nat config for new conntracks */
 		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 			err = -EOPNOTSUPP;
@@ -1270,8 +1315,17 @@ ctnetlink_new_conntrack(struct sock *ctn
 			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
-		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
-						 cda);
+		err = ctnetlink_change_conntrack(ct, cda, &events);
+
+		spin_unlock_bh(&nf_conntrack_lock);
+
+		if (err == 0) {
+			atomic_inc(&ct->ct_general.use);
+			ctnetlink_conntrack_event(&ctnl_notifier, &events, ct);
+			nf_ct_put(ct);
+		}
+
+		return err;
 	}
 
 out_unlock:
@@ -1450,7 +1504,12 @@ nla_put_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
+
+static struct notifier_block ctnl_notifier_exp = {
+	.notifier_call	= ctnetlink_expect_event,
+};
 #endif
+
 static int ctnetlink_exp_done(struct netlink_callback *cb)
 {
 	if (cb->args[1])
@@ -1745,16 +1804,6 @@ ctnetlink_new_expect(struct sock *ctnl, 
 	return err;
 }
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-static struct notifier_block ctnl_notifier = {
-	.notifier_call	= ctnetlink_conntrack_event,
-};
-
-static struct notifier_block ctnl_notifier_exp = {
-	.notifier_call	= ctnetlink_expect_event,
-};
-#endif
-
 static const struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
 	[IPCTNL_MSG_CT_NEW]		= { .call = ctnetlink_new_conntrack,
 					    .attr_count = CTA_MAX,

--------------010109060503010803080201--
