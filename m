Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665BF30676A
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426119; cv=none; b=V8dEYg3c9RDDOu22+zqyqKa6cYdTLNSWZDc2JTIdBANkZqsc9R+Fegm1nWlxGkYaDqmpO+/0A9srDkSFFIyoJ0/jeXVuHkCJNeFW54GX/XTjevlDbTrQK5jZEHi1DDd0+0KLOcA6e5oNF0asVM7voK3CJWFcdi3rXfKgkOlWT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426119; c=relaxed/simple;
	bh=/WZID1qJ+YXPVy7sDVYqzfRuq6QiUBhRwX2NwtSryHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IABZuQ7yatP4I4w2ELtyfUOSX/QuUyIW8jLksgKw7idC8LEEWJht5RRH9sNFP1e2q29mEq5Y49jZ9lhG+HGwHqJTgp1ZMy3yLnkGuGaJ3X9BHKUYJjBd52pjRB7Mvb7B8EY0/Vqt6YJec1Cx6fh0AVADN4P7x+GluU9Iphq1WGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C209660345; Fri, 22 May 2026 07:01:55 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/5] netfilter: conntrack: get rid of tuple in helper definitions
Date: Fri, 22 May 2026 07:01:31 +0200
Message-ID: <20260522050140.4838-3-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Leftover from the days when the kernel did automatic assignment of helpers
based on a pre-registered / well-known-port.

This helper autoassign was removed from the kernel, so all we really
need are the l3 and l4 protocol numbers.

Because helpers can register for UNSPEC (== l3 agnostic), we can also
remove redundant ipv4+ipv6 register requests.

In the broadcast helper, the only remaining consumer of the port number is
removed.  AFAICS its not needed either: The expectation is populated from
the control connection reply tuple, so the src port is the original
directions destination (snmp for example).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h |  4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  5 +-
 net/netfilter/nf_conntrack_amanda.c         | 35 +++------
 net/netfilter/nf_conntrack_broadcast.c      |  2 -
 net/netfilter/nf_conntrack_h323_main.c      | 85 +++++++--------------
 net/netfilter/nf_conntrack_helper.c         | 20 ++---
 net/netfilter/nf_conntrack_netbios_ns.c     |  7 +-
 net/netfilter/nf_conntrack_pptp.c           |  5 +-
 net/netfilter/nf_conntrack_snmp.c           |  7 +-
 net/netfilter/nfnetlink_cthelper.c          | 20 ++---
 10 files changed, 68 insertions(+), 122 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..ab41ff60e9d1 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -37,8 +37,8 @@ struct nf_conntrack_helper {
 	struct module *me;		/* pointer to self */
 	const struct nf_conntrack_expect_policy *expect_policy;
 
-	/* Tuple of things we will help (compared against server response) */
-	struct nf_conntrack_tuple tuple;
+	u8 nfproto; /* l3num protocol that the helper supports (can be NFPROTO_UNSPEC) */
+	u8 l4proto;  /* l4 protocol that the helper supports (UDP, TCP) */
 
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index 717b726504fe..2ef2ea0736e9 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -207,9 +207,8 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 	.help			= help,
 	.expect_policy		= &snmp_exp_policy,
 	.name			= "snmp_trap",
-	.tuple.src.l3num	= AF_INET,
-	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_TRAP_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
+	.nfproto		= NFPROTO_IPV4,
+	.l4proto		= IPPROTO_UDP,
 };
 
 static int __init nf_nat_snmp_basic_init(void)
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d2c09e8dd872..6e9cf06991b3 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -169,35 +169,21 @@ static const struct nf_conntrack_expect_policy amanda_exp_policy = {
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
+static struct nf_conntrack_helper amanda_helper __read_mostly = {
+	.name			= HELPER_NAME,
+	.me			= THIS_MODULE,
+	.help			= amanda_help,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_UDP,
+	.expect_policy		= &amanda_exp_policy,
+	.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
 };
 
 static void __exit nf_conntrack_amanda_fini(void)
 {
 	int i;
 
-	nf_conntrack_helpers_unregister(amanda_helper,
-					ARRAY_SIZE(amanda_helper));
+	nf_conntrack_helper_unregister(&amanda_helper);
 	for (i = 0; i < ARRAY_SIZE(search); i++)
 		textsearch_destroy(search[i].ts);
 }
@@ -217,8 +203,7 @@ static int __init nf_conntrack_amanda_init(void)
 			goto err1;
 		}
 	}
-	ret = nf_conntrack_helpers_register(amanda_helper,
-					    ARRAY_SIZE(amanda_helper));
+	ret = nf_conntrack_helper_register(&amanda_helper);
 	if (ret < 0)
 		goto err1;
 	return 0;
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 75e53fde6b29..3113ed150755 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -62,8 +62,6 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
 	helper = rcu_dereference(help->helper);
-	if (helper)
-		exp->tuple.src.u.udp.port = helper->tuple.src.u.udp.port;
 
 	exp->mask.src.u3.ip       = mask;
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b2fe6554b9cf..3c66d81f5ab0 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -59,8 +59,8 @@ static DEFINE_SPINLOCK(nf_h323_lock);
 static char *h323_buffer;
 
 static struct nf_conntrack_helper nf_conntrack_helper_h245;
-static struct nf_conntrack_helper nf_conntrack_helper_q931[];
-static struct nf_conntrack_helper nf_conntrack_helper_ras[];
+static struct nf_conntrack_helper nf_conntrack_helper_q931;
+static struct nf_conntrack_helper nf_conntrack_helper_ras;
 
 static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 			 struct nf_conn *ct, enum ip_conntrack_info ctinfo,
@@ -580,8 +580,8 @@ static const struct nf_conntrack_expect_policy h245_exp_policy = {
 static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.name			= "H.245",
 	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_UNSPEC,
-	.tuple.dst.protonum	= IPPROTO_UDP,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_UDP,
 	.help			= h245_help,
 	.expect_policy		= &h245_exp_policy,
 };
@@ -767,7 +767,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1140,25 +1140,13 @@ static const struct nf_conntrack_expect_policy q931_exp_policy = {
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
+static struct nf_conntrack_helper nf_conntrack_helper_q931 __read_mostly = {
+	.name			= "Q.931",
+	.me			= THIS_MODULE,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_TCP,
+	.help			= q931_help,
+	.expect_policy		= &q931_exp_policy,
 };
 
 static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
@@ -1234,7 +1222,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1306,7 +1294,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1523,7 +1511,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1577,7 +1565,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1711,25 +1699,13 @@ static const struct nf_conntrack_expect_policy ras_exp_policy = {
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
+static struct nf_conntrack_helper nf_conntrack_helper_ras __read_mostly = {
+	.name			= "RAS",
+	.me			= THIS_MODULE,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_UDP,
+	.help			= ras_help,
+	.expect_policy		= &ras_exp_policy,
 };
 
 static int __init h323_helper_init(void)
@@ -1739,19 +1715,16 @@ static int __init h323_helper_init(void)
 	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245);
 	if (ret < 0)
 		return ret;
-	ret = nf_conntrack_helpers_register(nf_conntrack_helper_q931,
-					ARRAY_SIZE(nf_conntrack_helper_q931));
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_q931);
 	if (ret < 0)
 		goto err1;
-	ret = nf_conntrack_helpers_register(nf_conntrack_helper_ras,
-					ARRAY_SIZE(nf_conntrack_helper_ras));
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras);
 	if (ret < 0)
 		goto err2;
 
 	return 0;
 err2:
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
-					ARRAY_SIZE(nf_conntrack_helper_q931));
+	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931);
 err1:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 	return ret;
@@ -1759,10 +1732,8 @@ static int __init h323_helper_init(void)
 
 static void __exit h323_helper_exit(void)
 {
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_ras,
-					ARRAY_SIZE(nf_conntrack_helper_ras));
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
-					ARRAY_SIZE(nf_conntrack_helper_q931));
+	nf_conntrack_helper_unregister(&nf_conntrack_helper_ras);
+	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931);
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 }
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 32f64f600417..8bf283613c8c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -61,12 +61,9 @@ __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 	hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
 		if (strcmp(h->name, name))
 			continue;
-
-		if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
-		    h->tuple.src.l3num != l3num)
+		if (h->nfproto != NFPROTO_UNSPEC && h->nfproto != l3num)
 			continue;
-
-		if (h->tuple.dst.protonum == protonum)
+		if (h->l4proto == protonum)
 			return h;
 	}
 	return NULL;
@@ -348,7 +345,7 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	unsigned int h = helper_hash(me->name, me->tuple.dst.protonum);
+	unsigned int h = helper_hash(me->name, me->l4proto);
 	struct nf_conntrack_helper *cur;
 	int ret = 0;
 
@@ -365,9 +362,9 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 		if (!strcmp(cur->name, me->name) &&
-		    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
-		     cur->tuple.src.l3num == me->tuple.src.l3num) &&
-		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
+		    (cur->nfproto == NFPROTO_UNSPEC ||
+		     cur->nfproto == me->nfproto) &&
+		    cur->l4proto == me->l4proto) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -431,9 +428,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 					  struct nf_conn *ct),
 		       struct module *module)
 {
-	helper->tuple.src.l3num = l3num;
-	helper->tuple.dst.protonum = protonum;
-	helper->tuple.src.u.all = htons(spec_port);
+	helper->nfproto = l3num;
+	helper->l4proto = protonum;
 	helper->expect_policy = exp_pol;
 	helper->expect_class_max = expect_class_max;
 	helper->help = help;
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 55415f011943..06cb7ebc5818 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -33,7 +33,7 @@ static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
-static struct nf_conntrack_expect_policy exp_policy = {
+static struct nf_conntrack_expect_policy exp_policy __ro_after_init = {
 	.max_expected	= 1,
 };
 
@@ -46,9 +46,8 @@ static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
 
 static struct nf_conntrack_helper helper __read_mostly = {
 	.name			= HELPER_NAME,
-	.tuple.src.l3num	= NFPROTO_IPV4,
-	.tuple.src.u.udp.port	= cpu_to_be16(NMBD_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
+	.nfproto		= NFPROTO_IPV4,
+	.l4proto		= IPPROTO_UDP,
 	.me			= THIS_MODULE,
 	.help			= netbios_ns_help,
 	.expect_policy		= &exp_policy,
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 4c679638df06..c079d4db52b8 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -589,9 +589,8 @@ static const struct nf_conntrack_expect_policy pptp_exp_policy = {
 static struct nf_conntrack_helper pptp __read_mostly = {
 	.name			= "pptp",
 	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_INET,
-	.tuple.src.u.tcp.port	= cpu_to_be16(PPTP_CONTROL_PORT),
-	.tuple.dst.protonum	= IPPROTO_TCP,
+	.nfproto		= NFPROTO_IPV4,
+	.l4proto		= IPPROTO_TCP,
 	.help			= conntrack_pptp_help,
 	.destroy		= pptp_destroy_siblings,
 	.expect_policy		= &pptp_exp_policy,
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index 7b7eed43c54f..18342e1af989 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -43,15 +43,14 @@ static int snmp_conntrack_help(struct sk_buff *skb, unsigned int protoff,
 	return NF_ACCEPT;
 }
 
-static struct nf_conntrack_expect_policy exp_policy = {
+static struct nf_conntrack_expect_policy exp_policy __ro_after_init = {
 	.max_expected	= 1,
 };
 
 static struct nf_conntrack_helper helper __read_mostly = {
 	.name			= "snmp",
-	.tuple.src.l3num	= NFPROTO_IPV4,
-	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
+	.nfproto		= NFPROTO_IPV4,
+	.l4proto		= IPPROTO_UDP,
 	.me			= THIS_MODULE,
 	.help			= snmp_conntrack_help,
 	.expect_policy		= &exp_policy,
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..805c4711926c 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -246,8 +246,8 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	helper->data_len = size;
 
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
-	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));
-
+	helper->nfproto = tuple->src.l3num;
+	helper->l4proto = tuple->dst.protonum;
 	helper->me = THIS_MODULE;
 	helper->help = nfnl_userspace_cthelper;
 	helper->from_nlattr = nfnl_cthelper_from_nlattr;
@@ -441,8 +441,8 @@ static int nfnl_cthelper_new(struct sk_buff *skb, const struct nfnl_info *info,
 		if (strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
 			continue;
 
-		if ((tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		if (tuple.src.l3num != cur->nfproto ||
+		    tuple.dst.protonum != cur->l4proto)
 			continue;
 
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL)
@@ -471,10 +471,10 @@ nfnl_cthelper_dump_tuple(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_be16(skb, NFCTH_TUPLE_L3PROTONUM,
-			 htons(helper->tuple.src.l3num)))
+			 htons(helper->nfproto)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, NFCTH_TUPLE_L4PROTONUM, helper->tuple.dst.protonum))
+	if (nla_put_u8(skb, NFCTH_TUPLE_L4PROTONUM, helper->l4proto))
 		goto nla_put_failure;
 
 	nla_nest_end(skb, nest_parms);
@@ -650,8 +650,8 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 			continue;
 
 		if (tuple_set &&
-		    (tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		    (tuple.src.l3num != cur->nfproto ||
+		     tuple.dst.protonum != cur->l4proto))
 			continue;
 
 		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -710,8 +710,8 @@ static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
 			continue;
 
 		if (tuple_set &&
-		    (tuple.src.l3num != cur->tuple.src.l3num ||
-		     tuple.dst.protonum != cur->tuple.dst.protonum))
+		    (tuple.src.l3num != cur->nfproto ||
+		     tuple.dst.protonum != cur->l4proto))
 			continue;
 
 		if (refcount_dec_if_one(&cur->refcnt)) {
-- 
2.53.0

