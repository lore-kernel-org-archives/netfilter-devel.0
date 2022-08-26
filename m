Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355E6ECAAA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 07:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiHZHGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 03:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiHZHGI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 03:06:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C030D0759
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 00:06:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     i.maximets@ovn.org, pshelar@ovn.org, dev@openvswitch.org,
        aconole@redhat.com
Subject: [PATCH nf] netfilter: remove nf_conntrack_helper sysctl toggle
Date:   Fri, 26 Aug 2022 09:06:00 +0200
Message-Id: <20220826070600.8404-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__nf_ct_try_assign_helper() remains in place but it now requires a
template to configure the helper.

A toggle to disable automatic helper assignment was added by:

  a9006892643a ("netfilter: nf_ct_helper: allow to disable automatic helper assignment")

in 2012 to address the issues described in "Secure use of iptables and
connection tracking helpers". Automatic conntrack helper assignment was
disabled by:

  3bb398d925ec ("netfilter: nf_ct_helper: disable automatic helper assignment")

back in 2016.

This patch removes the sysctl toggle, users now have to rely on explicit
conntrack helper configuration via ruleset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h    |  2 -
 include/net/netns/conntrack.h           |  1 -
 net/netfilter/nf_conntrack_core.c       |  5 --
 net/netfilter/nf_conntrack_helper.c     | 80 ++++---------------------
 net/netfilter/nf_conntrack_netlink.c    |  5 --
 net/netfilter/nf_conntrack_standalone.c | 10 ----
 net/netfilter/nft_ct.c                  |  3 -
 7 files changed, 10 insertions(+), 96 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a32be8aa7ed2..6a2019aaa464 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -53,8 +53,6 @@ struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
 	unsigned int expect_count;
-	u8 sysctl_auto_assign_helper;
-	bool auto_assign_helper_warned;
 
 	/* only used from work queues, configuration plane, and so on: */
 	unsigned int users4;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index c396a3862e80..e1290c159184 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -101,7 +101,6 @@ struct netns_ct {
 	u8			sysctl_log_invalid; /* Log invalid packets */
 	u8			sysctl_events;
 	u8			sysctl_acct;
-	u8			sysctl_auto_assign_helper;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 71c2f4f95d36..c07bb87ff1be 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2068,10 +2068,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (ct->master || (help && !hlist_empty(&help->expectations)))
 		return;
-
-	rcu_read_lock();
-	__nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 
@@ -2797,7 +2793,6 @@ int nf_conntrack_init_net(struct net *net)
 	nf_conntrack_acct_pernet_init(net);
 	nf_conntrack_tstamp_pernet_init(net);
 	nf_conntrack_ecache_pernet_init(net);
-	nf_conntrack_helper_pernet_init(net);
 	nf_conntrack_proto_pernet_init(net);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index e96b32221444..ff737a76052e 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -35,11 +35,6 @@ unsigned int nf_ct_helper_hsize __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_helper_hsize);
 static unsigned int nf_ct_helper_count __read_mostly;
 
-static bool nf_ct_auto_assign_helper __read_mostly = false;
-module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
-MODULE_PARM_DESC(nf_conntrack_helper,
-		 "Enable automatic conntrack helper assignment (default 0)");
-
 static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
 static struct list_head nf_ct_nat_helpers __read_mostly;
 
@@ -51,24 +46,6 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
 		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
 }
 
-static struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	unsigned int h;
-
-	if (!nf_ct_helper_count)
-		return NULL;
-
-	h = helper_hash(tuple);
-	hlist_for_each_entry_rcu(helper, &nf_ct_helper_hash[h], hnode) {
-		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
-			return helper;
-	}
-	return NULL;
-}
-
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
@@ -209,33 +186,11 @@ nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
-static struct nf_conntrack_helper *
-nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	if (!cnet->sysctl_auto_assign_helper) {
-		if (cnet->auto_assign_helper_warned)
-			return NULL;
-		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
-			return NULL;
-		pr_info("nf_conntrack: default automatic helper assignment "
-			"has been turned off for security reasons and CT-based "
-			"firewall rule not found. Use the iptables CT target "
-			"to attach helpers instead.\n");
-		cnet->auto_assign_helper_warned = true;
-		return NULL;
-	}
-
-	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-}
-
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
-	struct net *net = nf_ct_net(ct);
 
 	/* We already got a helper explicitly attached. The function
 	 * nf_conntrack_alter_reply - in case NAT is in use - asks for looking
@@ -246,23 +201,21 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return 0;
 
-	if (tmpl != NULL) {
-		help = nfct_help(tmpl);
-		if (help != NULL) {
-			helper = rcu_dereference(help->helper);
-			set_bit(IPS_HELPER_BIT, &ct->status);
-		}
+	if (WARN_ON_ONCE(!tmpl))
+		return 0;
+
+	help = nfct_help(tmpl);
+	if (help != NULL) {
+		helper = rcu_dereference(help->helper);
+		set_bit(IPS_HELPER_BIT, &ct->status);
 	}
 
 	help = nfct_help(ct);
 
 	if (helper == NULL) {
-		helper = nf_ct_lookup_helper(ct, net);
-		if (helper == NULL) {
-			if (help)
-				RCU_INIT_POINTER(help->helper, NULL);
-			return 0;
-		}
+		if (help)
+			RCU_INIT_POINTER(help->helper, NULL);
+		return 0;
 	}
 
 	if (help == NULL) {
@@ -545,19 +498,6 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
-void nf_ct_set_auto_assign_helper_warned(struct net *net)
-{
-	nf_ct_pernet(net)->auto_assign_helper_warned = true;
-}
-EXPORT_SYMBOL_GPL(nf_ct_set_auto_assign_helper_warned);
-
-void nf_conntrack_helper_pernet_init(struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	cnet->sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
-}
-
 int nf_conntrack_helper_init(void)
 {
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 04169b54f2a2..7562b215b932 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2298,11 +2298,6 @@ ctnetlink_create_conntrack(struct net *net,
 			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
-	} else {
-		/* try an implicit helper assignation */
-		err = __nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
-		if (err < 0)
-			goto err2;
 	}
 
 	err = ctnetlink_setup_nat(ct, cda);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 05895878610c..4ffe84c5a82c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -561,7 +561,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_LOG_INVALID,
 	NF_SYSCTL_CT_EXPECT_MAX,
 	NF_SYSCTL_CT_ACCT,
-	NF_SYSCTL_CT_HELPER,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	NF_SYSCTL_CT_EVENTS,
 #endif
@@ -680,14 +679,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
-	[NF_SYSCTL_CT_HELPER] = {
-		.procname	= "nf_conntrack_helper",
-		.maxlen		= sizeof(u8),
-		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
-		.extra1 	= SYSCTL_ZERO,
-		.extra2 	= SYSCTL_ONE,
-	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
@@ -1100,7 +1091,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
-	table[NF_SYSCTL_CT_HELPER].data = &cnet->sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
 #endif
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b04995c3e17f..a3f01f209a53 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1089,9 +1089,6 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
-	/* Avoid the bogus warning, helper will be assigned after CT init */
-	nf_ct_set_auto_assign_helper_warned(ctx->net);
-
 	return 0;
 
 err_put_helper:
-- 
2.30.2

