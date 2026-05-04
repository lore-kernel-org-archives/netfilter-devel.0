Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EFE2D3EC7;
	Mon,  4 May 2026 23:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938060; cv=none; b=IS2dRYEggQvStSwrKRLd2cOjIzTzdsZIJyFvFyL02lt0oPdhQrF8Z6aa5Li0HS0qB/ABgX0poF2P+CkgDHooHaVZVaV3QJRdXR7ZGa/0BIdLsy8/MgN7LPZ7X+avYEm+6n3JwFPpfbfeRXF/rjG3OJWJyYLUAD7MbOYyNhuoIfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938060; c=relaxed/simple;
	bh=RcBZXcX8EAEUZjJFdtgZgh/kwGfy8h5kj1j49AsVUlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csvdeOhesTbpKHS5X+VlzJLXzTsYZDguYP6dHkGzD5/h8+V28tVa1CnVcYAirnJVWG7hI/XF2w49hDVJfvvSL/zxW6rHw/O5Z28tCDs/zRjoVQoR5i3xVimGiQmGKtrehIpuw/OJx5bIcCrxm0PVGh/ttqhxukdJLAPzGlVOkRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ujwQ2YVO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ujwQ2YVO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 47F276017D;
	Tue,  5 May 2026 01:40:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777938056;
	bh=BFRvixt3q/dnHxHSuvmWagBm0APhHcLiblX83aOinQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujwQ2YVO6skJFToigVW0mJ3xEM2sLO1cz6TMCLn1t9bIizgh78Pn422CjAFskDYCE
	 O/MUnMeMZYqATeUGnWysIicPfeZrKdI3o3nlQJEo35m2kmo3471CTojTz8ZRAcP1B5
	 bxA058HVqzLiOGnobf3oPmedfsWpGtRMKBhMvBtTYSZvzvoJCzGKbWfy6E5ehYAEyO
	 S4h1QNCygnte042+pWZe62mrCZEscQ0/VgoB6PxITtMNz2M/Y3dVbekZ/x4k7O4IdO
	 ytgEZ9O4KNyCeycHb3e4Y/YQxzh3fsZE4Ptx1up8Mr6V/yeCgnhCDxCfosuQWBsizR
	 T02ApLCwFn2IA==
Date: Tue, 5 May 2026 01:40:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 06/12] netfilter: nf_conntrack_expect: honor
 expectation helper field
Message-ID: <afkuhbWieFXRTirN@chamomile>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <20260326125153.685915-7-pablo@netfilter.org>
 <8fd5d3a3-d1d7-4542-a0db-1678989940d4@ovn.org>
 <afSCXEg-X-ieL9cY@chamomile>
 <ef01005e-d867-4936-b138-b98f37e5f394@ovn.org>
 <afkosr2fDEPA_jX9@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iyhop23c+WPECR0i"
Content-Disposition: inline
In-Reply-To: <afkosr2fDEPA_jX9@chamomile>


--iyhop23c+WPECR0i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, May 05, 2026 at 01:16:05AM +0200, Pablo Neira Ayuso wrote:
> Thanks for the detailed report. It seems I changed the semantics of
> exp->helper, this used to be use to set a new helper for an expected
> connection, which is the case for sip and h323.
> 
> Would this patch help address the issue you are observing?

Actually, this needs to set to NULL the new exp->assign_helper field,
see new patch, untested.

--iyhop23c+WPECR0i
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix-exp-helper.patch"

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
index 24d0576d84b7..b01d48ab351e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -308,6 +308,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 	if (!new)
 		return NULL;
 
+	new->assign_helper = NULL;
 	new->master = me;
 	refcount_set(&new->use, 1);
 	return new;
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

--iyhop23c+WPECR0i--
