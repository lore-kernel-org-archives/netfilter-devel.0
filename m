Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6603D9DAE;
	Wed, 25 Mar 2026 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444331; cv=none; b=FbOmM970oR55eyO42iG1d0dB8dJSPby9XjvBSFmPP3V4cAjxhdQOBQOwFiJUv54RywTr1YjwH9OZMRGcsKcmpxDp4TjL2ES7hfXjVak8nE9o52B6SQJ4+rhTw3GmgAg61xjtJBIhuhby6EqMNye7+xD5lFu25A81t0+KxUxIE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444331; c=relaxed/simple;
	bh=QPx8aZ4EIRNRk3EuhjhbxwWFUz1O04BIedHDikjetes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiV0wM+KR5eh/7sfskjg8QZkiFyDeMt9j6gRQISdOy9ndn5ITwDMYqD4ctZFIPWLM8u1NuCYvOHR+uEagh+CvXEj8zdeWIAjADAjATRaQFQEkXVifYSEyZho24LLozRboUGe7gxyD5jKn2YAkNqQimvsXK60Y3EQKaaI5Fg5Cxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3EA706080C; Wed, 25 Mar 2026 14:12:08 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 08/14] netfilter: nf_conntrack_expect: honor expectation helper field
Date: Wed, 25 Mar 2026 14:11:02 +0100
Message-ID: <20260325131108.23045-9-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The expectation helper field is mostly unused. As a result, the
netfilter codebase relies on accessing the helper through exp->master.

Always set on the expectation helper field so it can be used to reach
the helper.

This is a preparation patches for follow up fixes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_expect.h |  2 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_expect.c         |  6 +++++-
 net/netfilter/nf_conntrack_h323_main.c      | 12 ++++++------
 net/netfilter/nf_conntrack_helper.c         |  7 ++++++-
 net/netfilter/nf_conntrack_netlink.c        |  2 +-
 net/netfilter/nf_conntrack_sip.c            |  2 +-
 7 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 165e7a03b8e9..1b01400b10bd 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -40,7 +40,7 @@ struct nf_conntrack_expect {
 			 struct nf_conntrack_expect *this);
 
 	/* Helper to assign to new connection */
-	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_helper __rcu *helper;
 
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index a7552a46d6ac..d21576fcb1d6 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -70,7 +70,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
-	exp->helper               = NULL;
+	rcu_assign_pointer(exp->helper, nfct_help(ct)->helper);
 
 	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f..197a76d0b231 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -309,6 +309,10 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
+/* This function can only be used from packet path, where accessing
+ * master's helper is safe, because the packet holds a reference on
+ * the conntrack object. Never use it from control plane.
+ */
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 		       u_int8_t family,
 		       const union nf_inet_addr *saddr,
@@ -325,7 +329,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->flags = 0;
 	exp->class = class;
 	exp->expectfn = NULL;
-	exp->helper = NULL;
+	rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index a2a0e22ccee1..3f5c50455b71 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -643,7 +643,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = &nf_conntrack_helper_h245;
+	rcu_assign_pointer(exp->helper, &nf_conntrack_helper_h245);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -767,7 +767,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1234,7 +1234,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1306,7 +1306,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	exp->helper = nf_conntrack_helper_ras;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1523,7 +1523,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1577,7 +1577,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	exp->helper = nf_conntrack_helper_q931;
+	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ceb48c3ca0a4..294a6ffcbccd 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -399,7 +399,7 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	const struct nf_conntrack_helper *me = data;
 	const struct nf_conntrack_helper *this;
 
-	if (exp->helper == me)
+	if (rcu_access_pointer(exp->helper) == me)
 		return true;
 
 	this = rcu_dereference_protected(help->helper,
@@ -421,6 +421,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
 	nf_ct_iterate_destroy(unhelp, me);
+
+	/* nf_ct_iterate_destroy() does an unconditional synchronize_rcu() as
+	 * last step, this ensures rcu readers of exp->helper are done.
+	 * No need for another synchronize_rcu() here.
+	 */
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c156574e1273..a42d14290786 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3573,7 +3573,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
-	exp->helper = helper;
+	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4ab5ef71d96d..106b2f419e19 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1297,7 +1297,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	exp->helper = helper;
+	rcu_assign_pointer(exp->helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-- 
2.52.0

