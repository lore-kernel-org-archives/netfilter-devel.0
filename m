Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BAF3E928C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226716; cv=none; b=EtJ7MweA0SHeTvh4aFdvy6wT9y6M0M3k2LV2CTRrJKJsWb8oWwT471XsrgSCZMj15bA6frEZJuaD9kmJrNniGJYjejjzuVsejQy0skQF7E0ZiUsUP+cTbm9Tx6td7Thlz5XUXmPPprYDY5LYq8ViZt6Otm/psgM3tO3g330g6hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226716; c=relaxed/simple;
	bh=mvg+5VRM+0uFlk/oOvGBODUq2beh6EZezmc/02VrDWA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIaKpT6T0IEEc1enXZLmrOcCmzulE2hXtdxfIl6sr5Jz+jWYiFuRO8LBUCyfs/bCLqn+MhEOHyTRjj2uuseNfd+p/y2mlzgfcoq9gdH+JVWGoPQapdChKMPmz7UO9V7SO7SFz2bcVYnv/bzCAb5W/04baG+SYWG1KRB2NLmPb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AZ7/9aEF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AZ7/9aEF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C532E60292
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226713;
	bh=O9JBM2gdH2ukCq8cwY51lGpnOtYm8/LO5J09Lt4o4ts=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AZ7/9aEFWbbJENxbJ43hcY0mqcTf6b+mgOJsW0qt+6vyRXohDIrC5KumAtqIpJdHV
	 gjau8ciVbw85U6KYLuQsit8dhUw13BmQWlWpH+JRmw70ePaagsf7HLqxlyYhnq+MLd
	 TVwurTlKGqULJJucCrTKZyMYYtN9GGQAubfwURc2iMTI+dC7IGEKLkiVxNlWWRm7ns
	 aIsaP+lo7nUc/9Kn9Nh1GsHNVweS0C1DRXUhHBWAs+V/SB1cq1CXH7Ft9AefOKG+kO
	 b44ttR9lGU2SeEYNAyKMO3FT3wNeufi9dgC6wrR435cBFWag9jzHVGE3KdDNIcYNLP
	 BN2z7h6WZSF0g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 4/7] netfilter: conntrack: add null check in nfct_help() calls
Date: Tue, 19 May 2026 23:38:23 +0200
Message-ID: <20260519213826.1181661-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
References: <20260519213826.1181661-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When helper is removed, nf_ct_iterate_destroy() unhelps the conntrack
entries. Then, the nf_ct_ext_find() might return NULL if the extension
is stale for unconfirmed conntracks if the genid validation fails.

Add the null check to nfct_help() and helpers that call this function
since packet path could be walking over helper while it is being
removed.

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count").
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_broadcast.c |  3 +++
 net/netfilter/nf_conntrack_expect.c    | 31 +++++++++++++++++---------
 net/netfilter/nf_conntrack_sip.c       | 20 +++++++++++++++--
 net/netfilter/nf_nat_sip.c             |  3 +++
 net/netfilter/nfnetlink_cthelper.c     |  6 +++++
 net/netfilter/xt_CT.c                  |  1 +
 6 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 75e53fde6b29..400119b6320e 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -29,6 +29,9 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	struct nf_conn_help *help = nfct_help(ct);
 	__be32 mask = 0;
 
+	if (!help)
+		goto out;
+
 	/* we're only interested in locally generated packets */
 	if (skb->sk == NULL || !net_eq(nf_ct_net(ct), sock_net(skb->sk)))
 		goto out;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8e943efbdf0a..09d0eff47658 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -60,8 +60,14 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	cnet = nf_ct_pernet(net);
 	cnet->expect_count--;
 
-	hlist_del_rcu(&exp->lnode);
-	master_help->expecting[exp->class]--;
+	/* This master conntrack has been unhelped, it is not reachable
+	 * anymore, skip expectation removal from local master conntrack
+	 * list and the expecting counter update.
+	 */
+	if (master_help) {
+		hlist_del_rcu(&exp->lnode);
+		master_help->expecting[exp->class]--;
+	}
 
 	nf_ct_expect_event_report(IPEXP_DESTROY, exp, portid, report);
 	nf_ct_expect_put(exp);
@@ -405,10 +411,10 @@ void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
-static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
+static void nf_ct_expect_insert(struct nf_conntrack_expect *exp,
+				struct nf_conn_help *master_help)
 {
 	struct nf_conntrack_net *cnet;
-	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(exp);
 	unsigned int h = nf_ct_expect_dst_hash(net, &exp->tuple);
@@ -452,13 +458,13 @@ static void evict_oldest_expect(struct nf_conn *master,
 }
 
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
+				       struct nf_conn_help *master_help,
 				       unsigned int flags)
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
 	struct nf_conntrack_net *cnet;
 	struct nf_conn *master = expect->master;
-	struct nf_conn_help *master_help = nfct_help(master);
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(expect);
 	struct hlist_node *next;
@@ -467,10 +473,6 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 
 	lockdep_nfct_expect_lock_held();
 
-	if (!master_help) {
-		ret = -ESHUTDOWN;
-		goto out;
-	}
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (master_matches(i, expect, flags) &&
@@ -514,14 +516,21 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 				u32 portid, int report, unsigned int flags)
 {
+	struct nf_conn_help *master_help;
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	ret = __nf_ct_expect_check(expect, flags);
+	master_help = nfct_help(expect->master);
+	if (!master_help) {
+		ret = -ESHUTDOWN;
+		goto out;
+	}
+
+	ret = __nf_ct_expect_check(expect, master_help, flags);
 	if (ret < 0)
 		goto out;
 
-	nf_ct_expect_insert(expect);
+	nf_ct_expect_insert(expect, master_help);
 
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 2f90f2c54708..adc5562dcf11 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -887,6 +887,9 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
 	struct hlist_node *next;
 	int found = 0;
 
+	if (!help)
+		return 0;
+
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if (exp->class != SIP_EXPECT_SIGNALLING ||
@@ -910,6 +913,9 @@ static void flush_expectations(struct nf_conn *ct, bool media)
 	struct nf_conntrack_expect *exp;
 	struct hlist_node *next;
 
+	if (!help)
+		return;
+
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if ((exp->class != SIP_EXPECT_SIGNALLING) ^ media)
@@ -940,6 +946,11 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
 	const struct nf_nat_sip_hooks *hooks;
+	struct nf_conn_help *help;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_DROP;
 
 	saddr = NULL;
 	if (sip_direct_media) {
@@ -1002,7 +1013,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
 		if (!exp || exp->master == ct ||
-		    exp->helper != nfct_help(ct)->helper ||
+		    exp->helper != help->helper ||
 		    exp->class != class)
 			break;
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -1328,6 +1339,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	union nf_inet_addr *saddr, daddr;
 	const struct nf_nat_sip_hooks *hooks;
 	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
 	__be16 port;
 	u8 proto;
 	unsigned int expires = 0;
@@ -1381,7 +1393,11 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		goto store_cseq;
 	}
 
-	helper = rcu_dereference(nfct_help(ct)->helper);
+	help = nfct_help(ct);
+	if (!help)
+		return NF_DROP;
+
+	helper = rcu_dereference(help->helper);
 	if (!helper)
 		return NF_DROP;
 
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index b1931202825b..7f29a6785327 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -332,6 +332,9 @@ static void nf_nat_sip_expected(struct nf_conn *ct,
 	int range_set_for_snat = 0;
 	struct nf_nat_range2 range;
 
+	if (!help)
+		return;
+
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 61a2407b53bd..203bf5cf1f29 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -101,6 +101,9 @@ nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	struct nf_conn_help *help = nfct_help(ct);
 	const struct nf_conntrack_helper *helper;
 
+	if (!help)
+		return -EINVAL;
+
 	if (attr == NULL)
 		return -EINVAL;
 
@@ -118,6 +121,9 @@ nfnl_cthelper_to_nlattr(struct sk_buff *skb, const struct nf_conn *ct)
 	const struct nf_conn_help *help = nfct_help(ct);
 	const struct nf_conntrack_helper *helper;
 
+	if (!help)
+		return 0;
+
 	helper = rcu_dereference(help->helper);
 	if (helper && helper->data_len &&
 	    nla_put(skb, CTA_HELP_INFO, helper->data_len, &help->data))
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index d2aeacf94230..827e45f5d5ee 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -223,6 +223,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 
 err4:
 	help = nfct_help(ct);
+	WARN_ON_ONCE(help);
 	xt_ct_put_helper(help);
 err3:
 	nf_ct_tmpl_free(ct);
-- 
2.47.3

