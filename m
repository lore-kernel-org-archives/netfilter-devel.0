Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C43921DC
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 11:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777981341; cv=none; b=Au1Oi3ccRPrR9F7Lgo+tXi/knwbzwXokaosFi1YTMtSB7J0zhd4eo2JLOFh4k55p4KXrYXXqL5mjBvWGdIJK/9ik9kIBvsUKh44OU7UtHFvUhbtxPZ5GBVPLoW7gaCqQnGa/aUsUG2tQj0ijPTGdxbTJ+mZhs527JHs6pRLUnjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777981341; c=relaxed/simple;
	bh=tYlG84z+v7itpnKID+DVuY2ovnlQb9PzViHoco5f48Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CW909AgyY7sxt1hYy0UY4OIUkfgqNtYr49X3n9oHowjuHPP8U08OgIt9DWYomwh9m6WJn7HTsPkyGIFUP6RGUrtx+rSGQ4/P1+cP42WeKjmlphWpLsBvqlTT2FxIXCK8Pw/Ku57sw6y9GPGKU45IdZGgAuWxhTwhl9AmHBL8gbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=asxXZ/p3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="asxXZ/p3"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 17E9B600B5;
	Tue,  5 May 2026 13:42:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777981337;
	bh=nF907Ym+boHw87rXndxULVGgcwjNp+DPEnODGdwbcjI=;
	h=From:To:Cc:Subject:Date:From;
	b=asxXZ/p3c7gPphArM3m9vrE7aTJKob0U0gjDrclneus+0skdZAgGX7wIpD88VV8q3
	 Uy3vex7QvcKjz2JDYEHyA8KKI3wUM05BpNBOl2ivj5nScmLsLARZN7J6i2YKaGsOdv
	 FTDAMkCV9kc/Ck37yWVm2dT8ZY3bP5HF1C4UjzdRg2rchj3zFeLb73MpeNWpQI7Ij3
	 Z0zAy7lIR97SS65jtba10BNxPIT+hdHuP2QRY97a5fljI2sbSE6k4n6/QBh4UsoSKv
	 jvijhZDI1lJNYR0cU6+uKHPWQod+cRYHcNKt76ov0G7socclANYeJT9UKmtwk0Frw+
	 7SHHuwdyohn5w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: i.maximets@ovn.org
Subject: [PATCH nf] netfilter: nf_conntrack_expect: restore helper propagation via expectation
Date: Tue,  5 May 2026 13:42:13 +0200
Message-ID: <20260505114213.406362-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent series to fix expectations broke helper propagation via
expectation, this mechanism is used by the sip and h323 helper. This
also propagates the conntrack helper to expected connections. I changed
semantics of exp->helper which now tells us the actual helper that
created the expectation.

Add an explicit assign_helper field to expectations for this purpose
and update helpers to use it.

Restore this feature for userspace conntrack helper via ctnetlink
nfqueue integration so it is again possible to attach a helper to an
expectation, where it makes sense. This is not restored via ctnetlink
expectation creation as there is not client for such feature.

Make sure the expectation using this helper propagation mechanism also
go away when the helper is unregistered.

Fixes: 9c42bc9db90a ("netfilter: nf_conntrack_expect: honor expectation helper field")
Fixes: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  5 ++++-
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_core.c           |  4 ++--
 net/netfilter/nf_conntrack_expect.c         |  2 ++
 net/netfilter/nf_conntrack_h323_main.c      | 12 ++++++------
 net/netfilter/nf_conntrack_helper.c         |  5 +++++
 net/netfilter/nf_conntrack_netlink.c        | 18 ++++++++++++++++--
 net/netfilter/nf_conntrack_sip.c            |  2 +-
 8 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index e9a8350e7ccf..80f50fd0f7ad 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -45,9 +45,12 @@ struct nf_conntrack_expect {
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
 
-	/* Helper to assign to new connection */
+	/* Helper that created this expectation */
 	struct nf_conntrack_helper __rcu *helper;
 
+	/* Helper to assign to new connection */
+	struct nf_conntrack_helper __rcu *assign_helper;
+
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 4f39bf7c843f..75e53fde6b29 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -72,6 +72,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, NULL);
 	write_pnet(&exp->net, net);
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b08189226320..656287d16d86 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1815,10 +1815,10 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
 			ct->master = exp->master;
-			if (exp->helper) {
+			if (exp->assign_helper) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 				if (help)
-					rcu_assign_pointer(help->helper, exp->helper);
+					rcu_assign_pointer(help->helper, exp->assign_helper);
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 24d0576d84b7..f82d7ec8e8c0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -308,6 +308,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 	if (!new)
 		return NULL;
 
+	new->assign_helper = NULL;
 	new->master = me;
 	refcount_set(&new->use, 1);
 	return new;
@@ -344,6 +345,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		helper = rcu_dereference(help->helper);
 
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, NULL);
 	write_pnet(&exp->net, net);
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	exp->zone = ct->zone;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 3f5c50455b71..b2fe6554b9cf 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -643,7 +643,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, &nf_conntrack_helper_h245);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_h245);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -767,7 +767,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1234,7 +1234,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1306,7 +1306,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_ras);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1523,7 +1523,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1577,7 +1577,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a715304a53d8..b594cd244fe1 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -400,6 +400,11 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 
 	this = rcu_dereference_protected(exp->helper,
 					 lockdep_is_held(&nf_conntrack_expect_lock));
+	if (this == me)
+		return true;
+
+	this = rcu_dereference_protected(exp->assign_helper,
+					 lockdep_is_held(&nf_conntrack_expect_lock));
 	return this == me;
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eda5fe4a75c8..3606c7402094 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2634,6 +2634,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
+		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
@@ -2860,6 +2861,7 @@ static int
 ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 			     u32 portid, u32 report)
 {
+	struct nf_conntrack_helper *assign_helper = NULL;
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
 	struct nf_conntrack_expect *exp;
@@ -2875,8 +2877,18 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
+	if (cda[CTA_EXPECT_HELP_NAME]) {
+		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
+
+		assign_helper = __nf_conntrack_helper_find(helpname,
+							   nf_ct_l3num(ct),
+							   nf_ct_protonum(ct));
+		if (!assign_helper)
+			return -EOPNOTSUPP;
+	}
+
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     &tuple, &mask);
+				     assign_helper, &tuple, &mask);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3515,6 +3527,7 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 
 static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
+		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
@@ -3568,6 +3581,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	exp->zone = ct->zone;
 #endif
 	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, assign_helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
@@ -3623,7 +3637,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	exp = ctnetlink_alloc_expect(cda, ct, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1eb55907d470..d24bfa9e8234 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1383,7 +1383,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-- 
2.47.3

