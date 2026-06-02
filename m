Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACB119D89E
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 21:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434609; cv=none; b=drfEKowgaw1SnYXiMaoWKQ12pkB4twLRgfI8Y9SnoOM3nQztTsSK/5d5RjUNcNQNDGuIcMQulDVa7ZuvVxfNR4pqbHa/XeRw5LZcZ2a6+/T4Ce3q+ZxtwSyAYCYmvUlJEmXor66kT/dAJ3Pxl44ZOl4ZYao1RWskeRvRwudQrEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434609; c=relaxed/simple;
	bh=iidl02IjaruUjqDfemxB05J03VhLwerpLxj8XDuad3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVcaQ3/bl23IMazfe9NSWFXTsDdXejKWMq/lv43IfMwSriNR4WpSWYSdRaN4IrKNa32siSV3XLfSkAdmQP7bomrFj/NMJ7JgmaRktQ1+X5Ih9fYhq75hRLc9HHi3PwJXa892kbDWv5uk2IsYpvWniidtA5pGWXh7IJuMCD7VJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GwPcLOEc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GwPcLOEc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9CA296019C;
	Tue,  2 Jun 2026 23:09:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780434597;
	bh=U0SUDKdgQ3uvn7oGsyK9hxGZgpg++oNKSJonH5dC3ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwPcLOEcdrvn9vS8zMhfpS00cPR4BP8riuX/VpuSJMgKv/B/WW7soAhW2cvYSCZl4
	 +HZC74IKEcYPWhh+okWHj0Usl5jB6/TO+12Op29ckR3QG6gf8wLNjs1fLrwqhJo/xg
	 MkSU0QQdaCwhi1gs3GIePO3D0iwGECtzrC8+KMtt1JTSptcgK06kG9mSEurcXZMX24
	 Plv/EGSZINbXoGDs21s7lcVw3oJtCAl13gY07QnzGsrgO6rTlorAEbzQgZBo+1oYFV
	 W31U+3P1F+GOH9V02Fm/JS3UqSNtDB3Zw1NCV/1p8/FNaqsioEmoxhY6LHCgu5rYe0
	 ZdSKJM15Vbipg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 2/6] netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper
Date: Tue,  2 Jun 2026 23:09:48 +0200
Message-ID: <20260602210952.736311-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602210952.736311-1-pablo@netfilter.org>
References: <20260602210952.736311-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adapt all existing helpers to use a modified version of
nf_ct_helper_init(), to dynamically allocate struct nf_conntrack_helper.

Allocate expect_policy[] built-in into the helper to ensure this area is
reachable after helper removal since a follow up patch adds refcount to
track use of the nf_conntrack_helper structure from packet path so it
remains around until last reference from ct helper extension is dropped.

Export __nf_conntrack_helper_register() which allows to register
nfnetlink_cthelper dynamically allocated helper. Adapt nfnetlink_cthelper
to use the built-in expect_policy[].

This is a preparation patch to add packet path refcounting to helpers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: address AI reviewer hints.

 include/net/netfilter/nf_conntrack_helper.h |  16 +--
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  27 +++--
 net/netfilter/nf_conntrack_amanda.c         |  39 +++----
 net/netfilter/nf_conntrack_ftp.c            |   5 +-
 net/netfilter/nf_conntrack_h323_main.c      | 107 ++++++++------------
 net/netfilter/nf_conntrack_helper.c         |  74 +++++++++++---
 net/netfilter/nf_conntrack_irc.c            |   5 +-
 net/netfilter/nf_conntrack_netbios_ns.c     |  20 ++--
 net/netfilter/nf_conntrack_pptp.c           |  22 ++--
 net/netfilter/nf_conntrack_sane.c           |   5 +-
 net/netfilter/nf_conntrack_sip.c            |   5 +-
 net/netfilter/nf_conntrack_snmp.c           |  21 ++--
 net/netfilter/nf_conntrack_tftp.c           |   5 +-
 net/netfilter/nfnetlink_cthelper.c          |  47 ++++-----
 14 files changed, 209 insertions(+), 189 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..1956bc12bf56 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -29,13 +29,16 @@ enum nf_ct_helper_flags {
 
 #define NF_CT_HELPER_NAME_LEN	16
 
+/* Must be kept in sync with the classes defined by helpers */
+#define NF_CT_MAX_EXPECT_CLASSES	4
+
 struct nf_conntrack_helper {
 	struct hlist_node hnode;	/* Internal use. */
 
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
 	refcount_t refcnt;
 	struct module *me;		/* pointer to self */
-	const struct nf_conntrack_expect_policy *expect_policy;
+	struct nf_conntrack_expect_policy expect_policy[NF_CT_MAX_EXPECT_CLASSES];
 
 	/* Tuple of things we will help (compared against server response) */
 	struct nf_conntrack_tuple tuple;
@@ -63,9 +66,6 @@ struct nf_conntrack_helper {
 	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
 };
 
-/* Must be kept in sync with the classes defined by helpers */
-#define NF_CT_MAX_EXPECT_CLASSES	4
-
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
 	/* Helper. if any */
@@ -103,11 +103,13 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 					  struct nf_conn *ct),
 		       struct module *module);
 
-int nf_conntrack_helper_register(struct nf_conntrack_helper *);
+int nf_conntrack_helper_register(struct nf_conntrack_helper *, struct nf_conntrack_helper **);
+int __nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
-int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int);
-void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int,
+				  struct nf_conntrack_helper **);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper **,
 				     unsigned int);
 
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index 717b726504fe..0ede138dfd29 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -202,29 +202,34 @@ static const struct nf_conntrack_expect_policy snmp_exp_policy = {
 	.timeout	= 180,
 };
 
-static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
-	.me			= THIS_MODULE,
-	.help			= help,
-	.expect_policy		= &snmp_exp_policy,
-	.name			= "snmp_trap",
-	.tuple.src.l3num	= AF_INET,
-	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_TRAP_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
-};
+static struct nf_conntrack_helper snmp_trap_helper __read_mostly;
+static struct nf_conntrack_helper *snmp_trap_helper_ptr __read_mostly;
 
 static int __init nf_nat_snmp_basic_init(void)
 {
+	int err;
+
 	BUG_ON(nf_nat_snmp_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
 
-	return nf_conntrack_helper_register(&snmp_trap_helper);
+	nf_ct_helper_init(&snmp_trap_helper, AF_INET, IPPROTO_UDP,
+			  "snmp_trap", SNMP_TRAP_PORT, SNMP_TRAP_PORT, SNMP_TRAP_PORT,
+			  &snmp_exp_policy, 0, help, NULL, THIS_MODULE);
+
+	err = nf_conntrack_helper_register(&snmp_trap_helper, &snmp_trap_helper_ptr);
+	if (err < 0) {
+		RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit nf_nat_snmp_basic_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
 	synchronize_rcu();
-	nf_conntrack_helper_unregister(&snmp_trap_helper);
+	nf_conntrack_helper_unregister(snmp_trap_helper_ptr);
 }
 
 module_init(nf_nat_snmp_basic_init);
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d2c09e8dd872..ddafbdfc96dc 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -169,35 +169,15 @@ static const struct nf_conntrack_expect_policy amanda_exp_policy = {
 	.timeout		= 180,
 };
 
-static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
-	{
-		.name			= HELPER_NAME,
-		.me			= THIS_MODULE,
-		.help			= amanda_help,
-		.tuple.src.l3num	= AF_INET,
-		.tuple.src.u.udp.port	= cpu_to_be16(10080),
-		.tuple.dst.protonum	= IPPROTO_UDP,
-		.expect_policy		= &amanda_exp_policy,
-		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
-	},
-	{
-		.name			= "amanda",
-		.me			= THIS_MODULE,
-		.help			= amanda_help,
-		.tuple.src.l3num	= AF_INET6,
-		.tuple.src.u.udp.port	= cpu_to_be16(10080),
-		.tuple.dst.protonum	= IPPROTO_UDP,
-		.expect_policy		= &amanda_exp_policy,
-		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
-	},
-};
+static struct nf_conntrack_helper amanda_helper[2] __read_mostly;
+static struct nf_conntrack_helper *amanda_helper_ptr[2] __read_mostly;
 
 static void __exit nf_conntrack_amanda_fini(void)
 {
 	int i;
 
-	nf_conntrack_helpers_unregister(amanda_helper,
-					ARRAY_SIZE(amanda_helper));
+	nf_conntrack_helpers_unregister(amanda_helper_ptr,
+					ARRAY_SIZE(amanda_helper_ptr));
 	for (i = 0; i < ARRAY_SIZE(search); i++)
 		textsearch_destroy(search[i].ts);
 }
@@ -217,8 +197,17 @@ static int __init nf_conntrack_amanda_init(void)
 			goto err1;
 		}
 	}
+
+	nf_ct_helper_init(&amanda_helper[0], AF_INET, IPPROTO_UDP,
+			  HELPER_NAME, 10080, 10080, 10080,
+			  &amanda_exp_policy, 0, amanda_help, NULL, THIS_MODULE);
+	nf_ct_helper_init(&amanda_helper[1], AF_INET6, IPPROTO_UDP,
+			  HELPER_NAME, 10080, 10080, 10080,
+			  &amanda_exp_policy, 0, amanda_help, NULL, THIS_MODULE);
+
 	ret = nf_conntrack_helpers_register(amanda_helper,
-					    ARRAY_SIZE(amanda_helper));
+					    ARRAY_SIZE(amanda_helper),
+					    amanda_helper_ptr);
 	if (ret < 0)
 		goto err1;
 	return 0;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index de83bf9e6c61..b21da0c78845 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -552,6 +552,7 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 }
 
 static struct nf_conntrack_helper ftp[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper *ftp_ptr[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.max_expected	= 1,
@@ -560,7 +561,7 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 
 static void __exit nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
+	nf_conntrack_helpers_unregister(ftp_ptr, ports_c * 2);
 }
 
 static int __init nf_conntrack_ftp_init(void)
@@ -585,7 +586,7 @@ static int __init nf_conntrack_ftp_init(void)
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
+	ret = nf_conntrack_helpers_register(ftp, ports_c * 2, ftp_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b2fe6554b9cf..e7bbfe82f464 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -577,14 +577,8 @@ static const struct nf_conntrack_expect_policy h245_exp_policy = {
 	.timeout	= 240,
 };
 
-static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
-	.name			= "H.245",
-	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_UNSPEC,
-	.tuple.dst.protonum	= IPPROTO_UDP,
-	.help			= h245_help,
-	.expect_policy		= &h245_exp_policy,
-};
+static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly;
+static struct nf_conntrack_helper *nf_conntrack_helper_h245_ptr __read_mostly;
 
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
@@ -643,7 +637,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_h245);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_h245_ptr);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -732,6 +726,9 @@ static int callforward_do_filter(struct net *net,
 
 }
 
+static struct nf_conntrack_helper nf_conntrack_helper_q931[2] __read_mostly;
+static struct nf_conntrack_helper *nf_conntrack_helper_q931_ptr[2] __read_mostly;
+
 static int expect_callforwarding(struct sk_buff *skb,
 				 struct nf_conn *ct,
 				 enum ip_conntrack_info ctinfo,
@@ -767,7 +764,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931_ptr);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1140,27 +1137,6 @@ static const struct nf_conntrack_expect_policy q931_exp_policy = {
 	.timeout		= 240,
 };
 
-static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
-	{
-		.name			= "Q.931",
-		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET,
-		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
-		.tuple.dst.protonum	= IPPROTO_TCP,
-		.help			= q931_help,
-		.expect_policy		= &q931_exp_policy,
-	},
-	{
-		.name			= "Q.931",
-		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET6,
-		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
-		.tuple.dst.protonum	= IPPROTO_TCP,
-		.help			= q931_help,
-		.expect_policy		= &q931_exp_policy,
-	},
-};
-
 static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
 				   int *datalen)
 {
@@ -1234,7 +1210,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931_ptr);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1275,6 +1251,9 @@ static int process_grq(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
+static struct nf_conntrack_helper nf_conntrack_helper_ras[2] __read_mostly;
+static struct nf_conntrack_helper *nf_conntrack_helper_ras_ptr[2] __read_mostly;
+
 static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff,
@@ -1306,7 +1285,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras_ptr);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1523,7 +1502,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931_ptr);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1577,7 +1556,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931_ptr);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1711,59 +1690,57 @@ static const struct nf_conntrack_expect_policy ras_exp_policy = {
 	.timeout		= 240,
 };
 
-static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
-	{
-		.name			= "RAS",
-		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET,
-		.tuple.src.u.udp.port	= cpu_to_be16(RAS_PORT),
-		.tuple.dst.protonum	= IPPROTO_UDP,
-		.help			= ras_help,
-		.expect_policy		= &ras_exp_policy,
-	},
-	{
-		.name			= "RAS",
-		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET6,
-		.tuple.src.u.udp.port	= cpu_to_be16(RAS_PORT),
-		.tuple.dst.protonum	= IPPROTO_UDP,
-		.help			= ras_help,
-		.expect_policy		= &ras_exp_policy,
-	},
-};
-
 static int __init h323_helper_init(void)
 {
 	int ret;
 
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245);
+	nf_ct_helper_init(&nf_conntrack_helper_ras[0], AF_INET, IPPROTO_UDP,
+			  "RAS", RAS_PORT, RAS_PORT, RAS_PORT,
+			  &ras_exp_policy, 0, ras_help, NULL, THIS_MODULE);
+	nf_ct_helper_init(&nf_conntrack_helper_ras[1], AF_INET6, IPPROTO_UDP,
+			  "RAS", RAS_PORT, RAS_PORT, RAS_PORT,
+			  &ras_exp_policy, 0, ras_help, NULL, THIS_MODULE);
+	nf_ct_helper_init(&nf_conntrack_helper_h245, AF_UNSPEC, IPPROTO_UDP,
+			  "H.245", 0, 0, 0,
+			  &h245_exp_policy, 0, h245_help, NULL, THIS_MODULE);
+	nf_ct_helper_init(&nf_conntrack_helper_q931[0], AF_INET, IPPROTO_TCP,
+			  "Q.931", Q931_PORT, Q931_PORT, Q931_PORT,
+			  &q931_exp_policy, 0, q931_help, NULL, THIS_MODULE);
+	nf_ct_helper_init(&nf_conntrack_helper_q931[1], AF_INET6, IPPROTO_TCP,
+			  "Q.931", Q931_PORT, Q931_PORT, Q931_PORT,
+			  &q931_exp_policy, 0, q931_help, NULL, THIS_MODULE);
+
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245,
+					   &nf_conntrack_helper_h245_ptr);
 	if (ret < 0)
 		return ret;
 	ret = nf_conntrack_helpers_register(nf_conntrack_helper_q931,
-					ARRAY_SIZE(nf_conntrack_helper_q931));
+					    ARRAY_SIZE(nf_conntrack_helper_q931),
+					    nf_conntrack_helper_q931_ptr);
 	if (ret < 0)
 		goto err1;
 	ret = nf_conntrack_helpers_register(nf_conntrack_helper_ras,
-					ARRAY_SIZE(nf_conntrack_helper_ras));
+					    ARRAY_SIZE(nf_conntrack_helper_ras),
+					    nf_conntrack_helper_ras_ptr);
 	if (ret < 0)
 		goto err2;
 
 	return 0;
 err2:
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
-					ARRAY_SIZE(nf_conntrack_helper_q931));
+	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931_ptr,
+					ARRAY_SIZE(nf_conntrack_helper_q931_ptr));
 err1:
-	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
+	nf_conntrack_helper_unregister(nf_conntrack_helper_h245_ptr);
 	return ret;
 }
 
 static void __exit h323_helper_exit(void)
 {
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_ras,
+	nf_conntrack_helpers_unregister(nf_conntrack_helper_ras_ptr,
 					ARRAY_SIZE(nf_conntrack_helper_ras));
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
+	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931_ptr,
 					ARRAY_SIZE(nf_conntrack_helper_q931));
-	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
+	nf_conntrack_helper_unregister(nf_conntrack_helper_h245_ptr);
 }
 
 static void __exit nf_conntrack_h323_fini(void)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 17e971bd4c74..6161b4707011 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -347,14 +347,13 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
-int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
+int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h = helper_hash(&me->tuple);
 	struct nf_conntrack_helper *cur;
 	int ret = 0, i;
 
-	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
@@ -394,6 +393,33 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	mutex_unlock(&nf_ct_helper_mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__nf_conntrack_helper_register);
+
+int nf_conntrack_helper_register(struct nf_conntrack_helper *me,
+				 struct nf_conntrack_helper **helper_ptr)
+{
+	struct nf_conntrack_helper *new_helper;
+	int err;
+
+	new_helper = kzalloc_obj(*new_helper, GFP_KERNEL_ACCOUNT);
+	if (!new_helper)
+		return -ENOMEM;
+
+	memcpy(new_helper, me, sizeof(*new_helper));
+
+	err = __nf_conntrack_helper_register(new_helper);
+	if (err < 0)
+		goto err_helper;
+
+	*helper_ptr = new_helper;
+
+	return 0;
+
+err_helper:
+	kfree(new_helper);
+
+	return err;
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
 static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
@@ -430,6 +456,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 * last step, this ensures rcu readers of exp->helper are done.
 	 * No need for another synchronize_rcu() here.
 	 */
+	kfree(me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
@@ -445,11 +472,12 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 					  struct nf_conn *ct),
 		       struct module *module)
 {
+	memset(helper, 0, sizeof(*helper));
+
 	helper->tuple.src.l3num = l3num;
 	helper->tuple.dst.protonum = protonum;
 	helper->tuple.src.u.all = htons(spec_port);
-	helper->expect_policy = exp_pol;
-	helper->expect_class_max = expect_class_max;
+
 	helper->help = help;
 	helper->from_nlattr = from_nlattr;
 	helper->me = module;
@@ -460,34 +488,56 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		snprintf(helper->name, sizeof(helper->name), "%s", name);
 	else
 		snprintf(helper->name, sizeof(helper->name), "%s-%u", name, id);
+
+	if (WARN_ON_ONCE(expect_class_max >= NF_CT_MAX_EXPECT_CLASSES))
+		return;
+
+	memcpy(helper->expect_policy, exp_pol,
+	       (expect_class_max + 1) * sizeof(*exp_pol));
+	helper->expect_class_max = expect_class_max;
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_init);
 
 int nf_conntrack_helpers_register(struct nf_conntrack_helper *helper,
-				  unsigned int n)
+				  unsigned int n, struct nf_conntrack_helper **helper_ptr)
 {
+	struct nf_conntrack_helper *new_helper;
 	unsigned int i;
 	int err = 0;
 
 	for (i = 0; i < n; i++) {
-		err = nf_conntrack_helper_register(&helper[i]);
-		if (err < 0)
+		new_helper = kzalloc_obj(*new_helper, GFP_KERNEL_ACCOUNT);
+		if (!new_helper) {
+			err = -ENOMEM;
 			goto err;
+		}
+
+		memcpy(new_helper, &helper[i], sizeof(*new_helper));
+
+		err = __nf_conntrack_helper_register(new_helper);
+		if (err < 0)
+			goto err_helper;
+
+		helper_ptr[i] = new_helper;
 	}
 
 	return err;
+err_helper:
+	kfree(new_helper);
 err:
 	if (i > 0)
-		nf_conntrack_helpers_unregister(helper, i);
+		nf_conntrack_helpers_unregister(helper_ptr, i);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_register);
 
-void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
-				unsigned int n)
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper **helper,
+				     unsigned int n)
 {
-	while (n-- > 0)
-		nf_conntrack_helper_unregister(&helper[n]);
+	while (n-- > 0) {
+		nf_conntrack_helper_unregister(helper[n]);
+		helper[n] = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
 
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 2ebe4cb47cf6..6a72848bd351 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -255,6 +255,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
+static struct nf_conntrack_helper *irc_ptr[MAX_PORTS] __read_mostly;
 static struct nf_conntrack_expect_policy irc_exp_policy;
 
 static int __init nf_conntrack_irc_init(void)
@@ -289,7 +290,7 @@ static int __init nf_conntrack_irc_init(void)
 				  0, help, NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	ret = nf_conntrack_helpers_register(&irc[0], ports_c, irc_ptr);
 	if (ret) {
 		pr_err("failed to register helpers\n");
 		kfree(irc_buffer);
@@ -301,7 +302,7 @@ static int __init nf_conntrack_irc_init(void)
 
 static void __exit nf_conntrack_irc_fini(void)
 {
-	nf_conntrack_helpers_unregister(irc, ports_c);
+	nf_conntrack_helpers_unregister(irc_ptr, ports_c);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 55415f011943..89d1cf7d6512 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -44,27 +44,25 @@ static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
 	return nf_conntrack_broadcast_help(skb, ct, ctinfo, timeout);
 }
 
-static struct nf_conntrack_helper helper __read_mostly = {
-	.name			= HELPER_NAME,
-	.tuple.src.l3num	= NFPROTO_IPV4,
-	.tuple.src.u.udp.port	= cpu_to_be16(NMBD_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
-	.me			= THIS_MODULE,
-	.help			= netbios_ns_help,
-	.expect_policy		= &exp_policy,
-};
+static struct nf_conntrack_helper helper __read_mostly;
+static struct nf_conntrack_helper *helper_ptr __read_mostly;
 
 static int __init nf_conntrack_netbios_ns_init(void)
 {
 	NF_CT_HELPER_BUILD_BUG_ON(0);
 
 	exp_policy.timeout = timeout;
-	return nf_conntrack_helper_register(&helper);
+
+	nf_ct_helper_init(&helper, AF_INET, IPPROTO_UDP, HELPER_NAME,
+			  NMBD_PORT, NMBD_PORT, NMBD_PORT,
+			  &exp_policy, 0, netbios_ns_help, NULL, THIS_MODULE);
+
+	return nf_conntrack_helper_register(&helper, &helper_ptr);
 }
 
 static void __exit nf_conntrack_netbios_ns_fini(void)
 {
-	nf_conntrack_helper_unregister(&helper);
+	nf_conntrack_helper_unregister(helper_ptr);
 }
 
 module_init(nf_conntrack_netbios_ns_init);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index dc23e4181618..edc85a3eef1e 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -582,27 +582,25 @@ static const struct nf_conntrack_expect_policy pptp_exp_policy = {
 };
 
 /* control protocol helper */
-static struct nf_conntrack_helper pptp __read_mostly = {
-	.name			= "pptp",
-	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_INET,
-	.tuple.src.u.tcp.port	= cpu_to_be16(PPTP_CONTROL_PORT),
-	.tuple.dst.protonum	= IPPROTO_TCP,
-	.help			= conntrack_pptp_help,
-	.destroy		= pptp_destroy_siblings,
-	.expect_policy		= &pptp_exp_policy,
-};
+static struct nf_conntrack_helper pptp __read_mostly;
+static struct nf_conntrack_helper *pptp_ptr __read_mostly;
 
 static int __init nf_conntrack_pptp_init(void)
 {
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_pptp_master));
 
-	return nf_conntrack_helper_register(&pptp);
+	nf_ct_helper_init(&pptp, AF_INET, IPPROTO_TCP,
+			  "pptp", PPTP_CONTROL_PORT, PPTP_CONTROL_PORT, PPTP_CONTROL_PORT,
+			  &pptp_exp_policy, 0, conntrack_pptp_help, NULL, THIS_MODULE);
+
+	pptp.destroy = pptp_destroy_siblings;
+
+	return nf_conntrack_helper_register(&pptp, &pptp_ptr);
 }
 
 static void __exit nf_conntrack_pptp_fini(void)
 {
-	nf_conntrack_helper_unregister(&pptp);
+	nf_conntrack_helper_unregister(pptp_ptr);
 }
 
 module_init(nf_conntrack_pptp_init);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 13dc421fc4f5..a7f7b07ba0c2 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -167,6 +167,7 @@ static int help(struct sk_buff *skb,
 }
 
 static struct nf_conntrack_helper sane[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper *sane_ptr[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.max_expected	= 1,
@@ -175,7 +176,7 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 
 static void __exit nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(sane, ports_c * 2);
+	nf_conntrack_helpers_unregister(sane_ptr, ports_c * 2);
 }
 
 static int __init nf_conntrack_sane_init(void)
@@ -200,7 +201,7 @@ static int __init nf_conntrack_sane_init(void)
 				  THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
+	ret = nf_conntrack_helpers_register(sane, ports_c * 2, sane_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e69941f1a101..2c78a3e1dab5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1731,6 +1731,7 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;
+static struct nf_conntrack_helper *sip_ptr[MAX_PORTS * 4] __read_mostly;
 
 static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
 	[SIP_EXPECT_SIGNALLING] = {
@@ -1757,7 +1758,7 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 
 static void __exit nf_conntrack_sip_fini(void)
 {
-	nf_conntrack_helpers_unregister(sip, ports_c * 4);
+	nf_conntrack_helpers_unregister(sip_ptr, ports_c * 4);
 }
 
 static int __init nf_conntrack_sip_init(void)
@@ -1788,7 +1789,7 @@ static int __init nf_conntrack_sip_init(void)
 				  NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(sip, ports_c * 4);
+	ret = nf_conntrack_helpers_register(sip, ports_c * 4, sip_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index 7b7eed43c54f..b6fce5703fce 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -47,25 +47,24 @@ static struct nf_conntrack_expect_policy exp_policy = {
 	.max_expected	= 1,
 };
 
-static struct nf_conntrack_helper helper __read_mostly = {
-	.name			= "snmp",
-	.tuple.src.l3num	= NFPROTO_IPV4,
-	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
-	.me			= THIS_MODULE,
-	.help			= snmp_conntrack_help,
-	.expect_policy		= &exp_policy,
-};
+static struct nf_conntrack_helper helper __read_mostly;
+static struct nf_conntrack_helper *helper_ptr __read_mostly;
 
 static int __init nf_conntrack_snmp_init(void)
 {
 	exp_policy.timeout = timeout;
-	return nf_conntrack_helper_register(&helper);
+
+	nf_ct_helper_init(&helper, AF_INET, IPPROTO_UDP,
+			  "snmp", SNMP_PORT, SNMP_PORT, SNMP_PORT,
+			  &exp_policy, 0, snmp_conntrack_help, NULL,
+			  THIS_MODULE);
+
+	return nf_conntrack_helper_register(&helper, &helper_ptr);
 }
 
 static void __exit nf_conntrack_snmp_fini(void)
 {
-	nf_conntrack_helper_unregister(&helper);
+	nf_conntrack_helper_unregister(helper_ptr);
 }
 
 module_init(nf_conntrack_snmp_init);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index a2e6833a0bf7..4393c435aa35 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -96,6 +96,7 @@ static int tftp_help(struct sk_buff *skb,
 }
 
 static struct nf_conntrack_helper tftp[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper *tftp_ptr[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.max_expected	= 1,
@@ -104,7 +105,7 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 
 static void __exit nf_conntrack_tftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
+	nf_conntrack_helpers_unregister(tftp_ptr, ports_c * 2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -127,7 +128,7 @@ static int __init nf_conntrack_tftp_init(void)
 				  THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
+	ret = nf_conntrack_helpers_register(tftp, ports_c * 2, tftp_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..a08f5da9888e 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -32,7 +32,7 @@ MODULE_DESCRIPTION("nfnl_cthelper: User-space connection tracking helpers");
 
 struct nfnl_cthelper {
 	struct list_head		list;
-	struct nf_conntrack_helper	helper;
+	struct nf_conntrack_helper	*helper;
 };
 
 static LIST_HEAD(nfnl_cthelper_list);
@@ -173,7 +173,6 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 				  const struct nlattr *attr)
 {
 	int i, ret;
-	struct nf_conntrack_expect_policy *expect_policy;
 	struct nlattr *tb[NFCTH_POLICY_SET_MAX+1];
 	unsigned int class_max;
 
@@ -192,26 +191,19 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	if (class_max > NF_CT_MAX_EXPECT_CLASSES)
 		return -EOVERFLOW;
 
-	expect_policy = kzalloc_objs(struct nf_conntrack_expect_policy,
-				     class_max);
-	if (expect_policy == NULL)
-		return -ENOMEM;
-
 	for (i = 0; i < class_max; i++) {
 		if (!tb[NFCTH_POLICY_SET+i])
 			goto err;
 
-		ret = nfnl_cthelper_expect_policy(&expect_policy[i],
+		ret = nfnl_cthelper_expect_policy(&helper->expect_policy[i],
 						  tb[NFCTH_POLICY_SET+i]);
 		if (ret < 0)
 			goto err;
 	}
 
 	helper->expect_class_max = class_max - 1;
-	helper->expect_policy = expect_policy;
 	return 0;
 err:
-	kfree(expect_policy);
 	return -EINVAL;
 }
 
@@ -227,21 +219,28 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
 		return -EINVAL;
 
-	nfcth = kzalloc_obj(*nfcth);
+	nfcth = kzalloc_obj(*nfcth, GFP_KERNEL_ACCOUNT);
 	if (nfcth == NULL)
 		return -ENOMEM;
-	helper = &nfcth->helper;
+
+	helper = kzalloc_obj(*helper, GFP_KERNEL_ACCOUNT);
+	if (!helper) {
+		ret = -ENOMEM;
+		goto err_cth;
+	}
+
+	nfcth->helper = helper;
 
 	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
 	if (ret < 0)
-		goto err1;
+		goto err_helper;
 
 	nla_strscpy(helper->name,
 		    tb[NFCTH_NAME], NF_CT_HELPER_NAME_LEN);
 	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
 	if (size > sizeof_field(struct nf_conn_help, data)) {
 		ret = -ENOMEM;
-		goto err2;
+		goto err_helper;
 	}
 	helper->data_len = size;
 
@@ -270,15 +269,15 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		}
 	}
 
-	ret = nf_conntrack_helper_register(helper);
+	ret = __nf_conntrack_helper_register(helper);
 	if (ret < 0)
-		goto err2;
+		goto err_helper;
 
 	list_add_tail(&nfcth->list, &nfnl_cthelper_list);
 	return 0;
-err2:
-	kfree(helper->expect_policy);
-err1:
+err_helper:
+	kfree(helper);
+err_cth:
 	kfree(nfcth);
 	return ret;
 }
@@ -436,7 +435,7 @@ static int nfnl_cthelper_new(struct sk_buff *skb, const struct nfnl_info *info,
 		return ret;
 
 	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
-		cur = &nlcth->helper;
+		cur = nlcth->helper;
 
 		if (strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
 			continue;
@@ -644,7 +643,7 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
-		cur = &nlcth->helper;
+		cur = nlcth->helper;
 		if (helper_name &&
 		    strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
 			continue;
@@ -702,7 +701,7 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 
 	ret = -ENOENT;
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
-		cur = &nlcth->helper;
+		cur = nlcth->helper;
 		j++;
 
 		if (helper_name &&
@@ -717,7 +716,6 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 		if (refcount_dec_if_one(&cur->refcnt)) {
 			found = true;
 			nf_conntrack_helper_unregister(cur);
-			kfree(cur->expect_policy);
 
 			list_del(&nlcth->list);
 			kfree(nlcth);
@@ -790,10 +788,9 @@ static void __exit nfnl_cthelper_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_cthelper_subsys);
 
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
-		cur = &nlcth->helper;
+		cur = nlcth->helper;
 
 		nf_conntrack_helper_unregister(cur);
-		kfree(cur->expect_policy);
 		kfree(nlcth);
 	}
 }
-- 
2.47.3

