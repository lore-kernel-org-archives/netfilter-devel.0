From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/32]: nf_conntrack: introduce expectation classes and policies
Date: Thu, 28 Feb 2008 13:00:05 +0100 (MET)
Message-ID: <20080228115956.29267.74234.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbYB1MAG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:06 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: introduce expectation classes and policies

Introduce expectation classes and policies. An expectation class
is used to distinguish different types of expectations by the
same helper (for example audio/video/t.120). The expectation
policy is used to hold the maximum number of expectations and
the initial timeout for each class.

The individual classes are isolated from each other, which means
that for example an audio expectation will only evict other audio
expectations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 52e02723b365a29b1694a8d157d42aa5f6c72895
tree f0f9bc64bf1f793073f0638df64ff2c63b833c19
parent 322ac7d38f97af880a7df6f39336b1918ccaf7d6
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:12 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:12 +0100

 include/linux/netfilter/nf_conntrack_amanda.h |    6 ++
 include/linux/netfilter/nf_conntrack_ftp.h    |    6 ++
 include/linux/netfilter/nf_conntrack_h323.h   |   18 +++++++
 include/linux/netfilter/nf_conntrack_irc.h    |    6 ++
 include/linux/netfilter/nf_conntrack_pptp.h   |    6 ++
 include/linux/netfilter/nf_conntrack_sane.h   |    6 ++
 include/linux/netfilter/nf_conntrack_sip.h    |    6 ++
 include/linux/netfilter/nf_conntrack_tftp.h   |    6 ++
 include/net/netfilter/nf_conntrack.h          |    5 +-
 include/net/netfilter/nf_conntrack_expect.h   |   11 ++++
 include/net/netfilter/nf_conntrack_helper.h   |    5 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c        |   22 +++++++-
 net/netfilter/nf_conntrack_amanda.c           |   18 +++++--
 net/netfilter/nf_conntrack_expect.c           |   50 ++++++++++++------
 net/netfilter/nf_conntrack_ftp.c              |   13 ++++-
 net/netfilter/nf_conntrack_h323_main.c        |   68 ++++++++++++++++---------
 net/netfilter/nf_conntrack_helper.c           |    3 +
 net/netfilter/nf_conntrack_irc.c              |   10 +++-
 net/netfilter/nf_conntrack_netbios_ns.c       |   18 ++++++-
 net/netfilter/nf_conntrack_pptp.c             |   17 +++++-
 net/netfilter/nf_conntrack_sane.c             |   14 ++++-
 net/netfilter/nf_conntrack_sip.c              |   13 ++++-
 net/netfilter/nf_conntrack_tftp.c             |   14 ++++-
 23 files changed, 264 insertions(+), 77 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 0bb5a69..8afacb9 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -2,6 +2,12 @@
 #define _NF_CONNTRACK_AMANDA_H
 /* AMANDA tracking. */
 
+enum amanda_expectation_classes {
+	AMANDA_EXPECT,
+	__AMANDA_EXPECT_MAX,
+};
+#define AMANDA_EXPECT_MAX	(__AMANDA_EXPECT_MAX - 1)
+
 extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
 					  enum ip_conntrack_info ctinfo,
 					  unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 47727d7..8c03915 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -19,6 +19,12 @@ enum nf_ct_ftp_type
 
 #define FTP_PORT	21
 
+enum ftp_expectation_classes {
+	FTP_EXPECT,
+	__FTP_EXPECT_MAX
+};
+#define FTP_EXPECT_MAX	(__FTP_EXPECT_MAX - 1)
+
 #define NUM_SEQ_TO_REMEMBER 2
 /* This structure exists only once per master */
 struct nf_ct_ftp_master {
diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 26f9226..0295a19 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -9,6 +9,24 @@
 #define Q931_PORT 1720
 #define H323_RTP_CHANNEL_MAX 4	/* Audio, video, FAX and other */
 
+enum h245_expectation_classes {
+	H245_EXPECT,
+	__H245_EXPECT_MAX
+};
+#define H245_EXPECT_MAX	(__H245_EXPECT_MAX - 1)
+
+enum q931_expectation_classes {
+	Q931_EXPECT,
+	__Q931_EXPECT_MAX
+};
+#define Q931_EXPECT_MAX	(__Q931_EXPECT_MAX - 1)
+
+enum ras_expect_classes {
+	RAS_EXPECT,
+	__RAS_EXPECT_MAX,
+};
+#define RAS_EXPECT_MAX	(__RAS_EXPECT_MAX - 1)
+
 /* This structure exists only once per master */
 struct nf_ct_h323_master {
 
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index 36282bf..25cf670 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -5,6 +5,12 @@
 
 #define IRC_PORT	6667
 
+enum irc_expectation_classes {
+	IRC_EXPECT,
+	__IRC_EXPECT_MAX
+};
+#define IRC_EXPECT_MAX	(__IRC_EXPECT_MAX - 1)
+
 extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 3bbde0c..b63cd99 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -48,6 +48,12 @@ struct nf_nat_pptp {
 
 #define PPTP_CONTROL_PORT	1723
 
+enum pptp_expectation_classes {
+	PPTP_EXPECT,
+	__PPTP_EXPECT_MAX
+};
+#define PPTP_EXPECT_MAX	(__PPTP_EXPECT_MAX - 1)
+
 #define PPTP_PACKET_CONTROL	1
 #define PPTP_PACKET_MGMT	2
 
diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
index 4767d6e..bb3fec3 100644
--- a/include/linux/netfilter/nf_conntrack_sane.h
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -6,6 +6,12 @@
 
 #define SANE_PORT	6566
 
+enum sane_expectation_classes {
+	SANE_EXPECT,
+	__SANE_EXPECT_MAX
+};
+#define SANE_EXPECT_MAX	(__SANE_EXPECT_MAX - 1)
+
 enum sane_state {
 	SANE_STATE_NORMAL,
 	SANE_STATE_START_REQUESTED,
diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 8e5ce1c..a58d6a3 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -5,6 +5,12 @@
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
+enum sip_expectation_classes {
+	SIP_EXPECT,
+	__SIP_EXPECT_MAX
+};
+#define SIP_EXPECT_MAX	(__SIP_EXPECT_MAX - 1)
+
 enum sip_header_pos {
 	POS_REG_REQ_URI,
 	POS_REQ_URI,
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index c78d38f..11001ae 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -3,6 +3,12 @@
 
 #define TFTP_PORT 69
 
+enum tftp_expectation_classes {
+	TFTP_EXPECT,
+	__TFTP_EXPECT_MAX
+};
+#define TFTP_EXPECT_MAX	(__TFTP_EXPECT_MAX - 1)
+
 struct tftphdr {
 	__be16 opcode;
 };
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 90b3e7f..9228771 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -75,6 +75,9 @@ do {									\
 
 struct nf_conntrack_helper;
 
+/* Must be kept in sync with the classes defined by helpers */
+#define NF_CT_MAX_EXPECT_CLASSES	1
+
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
 	/* Helper. if any */
@@ -85,7 +88,7 @@ struct nf_conn_help {
 	struct hlist_head expectations;
 
 	/* Current number of expected connections */
-	unsigned int expecting;
+	u8 expecting[NF_CT_MAX_EXPECT_CLASSES];
 };
 
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 47c28dd..a9797c5 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -41,6 +41,9 @@ struct nf_conntrack_expect
 	/* Flags */
 	unsigned int flags;
 
+	/* Expectation class */
+	unsigned int class;
+
 #ifdef CONFIG_NF_NAT_NEEDED
 	__be32 saved_ip;
 	/* This is the original per-proto part, used to map the
@@ -53,6 +56,12 @@ struct nf_conntrack_expect
 	struct rcu_head rcu;
 };
 
+struct nf_conntrack_expect_policy
+{
+	unsigned int	max_expected;
+	unsigned int	timeout;
+};
+
 #define NF_CT_EXPECT_PERMANENT	0x1
 #define NF_CT_EXPECT_INACTIVE	0x2
 
@@ -75,7 +84,7 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
-void nf_ct_expect_init(struct nf_conntrack_expect *, int,
+void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, int,
 		       const union nf_inet_addr *,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 4ca125e..f8060ab 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -20,9 +20,7 @@ struct nf_conntrack_helper
 
 	const char *name;		/* name of the module */
 	struct module *me;		/* pointer to self */
-	unsigned int max_expected;	/* Maximum number of concurrent 
-					 * expected connections */
-	unsigned int timeout;		/* timeout for expecteds */
+	const struct nf_conntrack_expect_policy *expect_policy;
 
 	/* Tuple of things we will help (compared against server response) */
 	struct nf_conntrack_tuple tuple;
@@ -37,6 +35,7 @@ struct nf_conntrack_helper
 	void (*destroy)(struct nf_conn *ct);
 
 	int (*to_nlattr)(struct sk_buff *skb, const struct nf_conn *ct);
+	unsigned int expect_class_max;
 };
 
 extern struct nf_conntrack_helper *
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 540ce6a..48dd5de 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -50,6 +50,7 @@
 #include <net/udp.h>
 
 #include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_nat_helper.h>
 
@@ -62,6 +63,12 @@ MODULE_ALIAS("ip_nat_snmp_basic");
 #define SNMP_TRAP_PORT 162
 #define NOCT1(n) (*(u8 *)(n))
 
+enum snmp_expectation_classes {
+	SNMP_EXPECT,
+	__SNMP_EXPECT_MAX
+};
+#define SNMP_EXPECT_MAX	(__SNMP_EXPECT_MAX - 1)
+
 static int debug;
 static DEFINE_SPINLOCK(snmp_lock);
 
@@ -1267,11 +1274,18 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
+static const struct nf_conntrack_expect_policy snmp_exp_policy[SNMP_EXPECT_MAX + 1] = {
+	[SNMP_EXPECT] = {
+		.max_expected	= 0,
+		.timeout	= 180,
+	},
+};
+
 static struct nf_conntrack_helper snmp_helper __read_mostly = {
-	.max_expected		= 0,
-	.timeout		= 180,
 	.me			= THIS_MODULE,
 	.help			= help,
+	.expect_policy		= snmp_exp_policy,
+	.expect_class_max	= SNMP_EXPECT_MAX,
 	.name			= "snmp",
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(SNMP_PORT),
@@ -1279,10 +1293,10 @@ static struct nf_conntrack_helper snmp_helper __read_mostly = {
 };
 
 static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
-	.max_expected		= 0,
-	.timeout		= 180,
 	.me			= THIS_MODULE,
 	.help			= help,
+	.expect_policy		= snmp_exp_policy,
+	.expect_class_max	= SNMP_EXPECT_MAX,
 	.name			= "snmp_trap",
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(SNMP_TRAP_PORT),
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7b8239c..eaafa08 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -148,7 +148,8 @@ static int amanda_help(struct sk_buff *skb,
 			goto out;
 		}
 		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+		nf_ct_expect_init(exp, AMANDA_EXPECT, family,
+				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_TCP, NULL, &port);
 
 		nf_nat_amanda = rcu_dereference(nf_nat_amanda_hook);
@@ -164,26 +165,33 @@ out:
 	return ret;
 }
 
+static const struct nf_conntrack_expect_policy amanda_exp_policy[AMANDA_EXPECT_MAX + 1] = {
+	[AMANDA_EXPECT] = {
+		.max_expected		= 3,
+		.timeout		= 180,
+	},
+};
+
 static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 	{
 		.name			= "amanda",
-		.max_expected		= 3,
-		.timeout		= 180,
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= __constant_htons(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
+		.expect_policy		= amanda_exp_policy,
+		.expect_class_max	= AMANDA_EXPECT_MAX,
 	},
 	{
 		.name			= "amanda",
-		.max_expected		= 3,
-		.timeout		= 180,
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.udp.port	= __constant_htons(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
+		.expect_policy		= amanda_exp_policy,
+		.expect_class_max	= AMANDA_EXPECT_MAX,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4bd694d..f4ce51c 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -54,7 +54,7 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	nf_ct_expect_count--;
 
 	hlist_del(&exp->lnode);
-	master_help->expecting--;
+	master_help->expecting[exp->class]--;
 	nf_ct_expect_put(exp);
 
 	NF_CT_STAT_INC(expect_delete);
@@ -171,7 +171,7 @@ void nf_ct_remove_expectations(struct nf_conn *ct)
 	struct hlist_node *n, *next;
 
 	/* Optimization: most connection never expect any others. */
-	if (!help || help->expecting == 0)
+	if (!help)
 		return;
 
 	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
@@ -205,7 +205,7 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 static inline int expect_matches(const struct nf_conntrack_expect *a,
 				 const struct nf_conntrack_expect *b)
 {
-	return a->master == b->master
+	return a->master == b->master && a->class == b->class
 		&& nf_ct_tuple_equal(&a->tuple, &b->tuple)
 		&& nf_ct_tuple_mask_equal(&a->mask, &b->mask);
 }
@@ -240,7 +240,8 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
-void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
+void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
+		       int family,
 		       const union nf_inet_addr *saddr,
 		       const union nf_inet_addr *daddr,
 		       u_int8_t proto, const __be16 *src, const __be16 *dst)
@@ -253,6 +254,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 		len = 16;
 
 	exp->flags = 0;
+	exp->class = class;
 	exp->expectfn = NULL;
 	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
@@ -309,19 +311,21 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
+	const struct nf_conntrack_expect_policy *p;
 	unsigned int h = nf_ct_expect_dst_hash(&exp->tuple);
 
 	atomic_inc(&exp->use);
 
 	hlist_add_head(&exp->lnode, &master_help->expectations);
-	master_help->expecting++;
+	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
 	nf_ct_expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
-	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
+	p = &master_help->helper->expect_policy[exp->class];
+	exp->timeout.expires = jiffies + p->timeout * HZ;
 	add_timer(&exp->timeout);
 
 	atomic_inc(&exp->use);
@@ -329,35 +333,41 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 }
 
 /* Race with expectations being used means we could have none to find; OK. */
-static void evict_oldest_expect(struct nf_conn *master)
+static void evict_oldest_expect(struct nf_conn *master,
+				struct nf_conntrack_expect *new)
 {
 	struct nf_conn_help *master_help = nfct_help(master);
-	struct nf_conntrack_expect *exp = NULL;
+	struct nf_conntrack_expect *exp, *last = NULL;
 	struct hlist_node *n;
 
-	hlist_for_each_entry(exp, n, &master_help->expectations, lnode)
-		; /* nothing */
+	hlist_for_each_entry(exp, n, &master_help->expectations, lnode) {
+		if (exp->class == new->class)
+			last = exp;
+	}
 
-	if (exp && del_timer(&exp->timeout)) {
-		nf_ct_unlink_expect(exp);
-		nf_ct_expect_put(exp);
+	if (last && del_timer(&last->timeout)) {
+		nf_ct_unlink_expect(last);
+		nf_ct_expect_put(last);
 	}
 }
 
 static inline int refresh_timer(struct nf_conntrack_expect *i)
 {
 	struct nf_conn_help *master_help = nfct_help(i->master);
+	const struct nf_conntrack_expect_policy *p;
 
 	if (!del_timer(&i->timeout))
 		return 0;
 
-	i->timeout.expires = jiffies + master_help->helper->timeout*HZ;
+	p = &master_help->helper->expect_policy[i->class];
+	i->timeout.expires = jiffies + p->timeout * HZ;
 	add_timer(&i->timeout);
 	return 1;
 }
 
 int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 {
+	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
 	struct nf_conn *master = expect->master;
 	struct nf_conn_help *master_help = nfct_help(master);
@@ -386,9 +396,15 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 		}
 	}
 	/* Will be over limit? */
-	if (master_help->helper->max_expected &&
-	    master_help->expecting >= master_help->helper->max_expected)
-		evict_oldest_expect(master);
+	p = &master_help->helper->expect_policy[expect->class];
+	if (p->max_expected &&
+	    master_help->expecting[expect->class] >= p->max_expected) {
+		evict_oldest_expect(master, expect);
+		if (master_help->expecting[expect->class] >= p->max_expected) {
+			ret = -EMFILE;
+			goto out;
+		}
+	}
 
 	if (nf_ct_expect_count >= nf_ct_expect_max) {
 		if (net_ratelimit())
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 6770baf..64579a5 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -483,7 +483,7 @@ static int help(struct sk_buff *skb,
 		daddr = &cmd.u3;
 	}
 
-	nf_ct_expect_init(exp, cmd.l3num,
+	nf_ct_expect_init(exp, FTP_EXPECT, cmd.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3, daddr,
 			  IPPROTO_TCP, NULL, &cmd.u.tcp.port);
 
@@ -517,6 +517,13 @@ out_update_nl:
 static struct nf_conntrack_helper ftp[MAX_PORTS][2] __read_mostly;
 static char ftp_names[MAX_PORTS][2][sizeof("ftp-65535")] __read_mostly;
 
+static const struct nf_conntrack_expect_policy ftp_exp_policy[FTP_EXPECT_MAX + 1] = {
+	[FTP_EXPECT] = {
+		.max_expected	= 1,
+		.timeout	= 5 * 60,
+	},
+};
+
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
@@ -556,8 +563,8 @@ static int __init nf_conntrack_ftp_init(void)
 		for (j = 0; j < 2; j++) {
 			ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			ftp[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			ftp[i][j].max_expected = 1;
-			ftp[i][j].timeout = 5 * 60;	/* 5 Minutes */
+			ftp[i][j].expect_policy = ftp_exp_policy;
+			ftp[i][j].expect_class_max = FTP_EXPECT_MAX;
 			ftp[i][j].me = THIS_MODULE;
 			ftp[i][j].help = help;
 			tmpname = &ftp_names[i][j][0];
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6213787..f2ac76a 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -277,7 +277,7 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for RTP */
 	if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(rtp_exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(rtp_exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_UDP, NULL, &rtp_port);
@@ -287,7 +287,7 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		nf_ct_expect_put(rtp_exp);
 		return -1;
 	}
-	nf_ct_expect_init(rtcp_exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(rtcp_exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_UDP, NULL, &rtcp_port);
@@ -344,7 +344,7 @@ static int expect_t120(struct sk_buff *skb,
 	/* Create expect for T.120 connections */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
@@ -612,13 +612,20 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
+static const struct nf_conntrack_expect_policy h245_exp_policy[H245_EXPECT_MAX + 1] = {
+	[H245_EXPECT] = {
+		.max_expected	= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
+		.timeout	= 240,
+	},
+};
+
 static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.name			= "H.245",
 	.me			= THIS_MODULE,
-	.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
-	.timeout		= 240,
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.help			= h245_help
+	.help			= h245_help,
+	.expect_policy		= h245_exp_policy,
+	.expect_class_max	= H245_EXPECT_MAX,
 };
 
 /****************************************************************************/
@@ -676,7 +683,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for h245 connection */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
@@ -792,7 +799,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	/* Create expect for the second call leg */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->helper = nf_conntrack_helper_q931;
@@ -1156,28 +1163,34 @@ static int q931_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
+static const struct nf_conntrack_expect_policy q931_exp_policy[Q931_EXPECT_MAX + 1] = {
+	[Q931_EXPECT] = {
+		/* T.120 and H.245 */
+		.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 4,
+		.timeout		= 240,
+	},
+};
+
 static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
-					  /* T.120 and H.245 */
-		.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 4,
-		.timeout		= 240,
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.tcp.port	= __constant_htons(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
-		.help			= q931_help
+		.help			= q931_help,
+		.expect_policy		= q931_exp_policy,
+		.expect_class_max	= Q931_EXPECT_MAX,
 	},
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
-					  /* T.120 and H.245 */
-		.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 4,
-		.timeout		= 240,
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.tcp.port	= __constant_htons(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
-		.help			= q931_help
+		.help			= q931_help,
+		.expect_policy		= q931_exp_policy,
+		.expect_class_max	= Q931_EXPECT_MAX,
 	},
 };
 
@@ -1261,7 +1274,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for Q.931 */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  gkrouted_only ? /* only accept calls from GK? */
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
@@ -1332,7 +1345,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
 	exp->helper = nf_conntrack_helper_ras;
@@ -1536,7 +1549,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
@@ -1589,7 +1602,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect for call signal */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, 0, ct->tuplehash[!dir].tuple.src.l3num,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
@@ -1728,26 +1741,33 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
+static const struct nf_conntrack_expect_policy ras_exp_policy[RAS_EXPECT_MAX + 1] = {
+	[RAS_EXPECT] = {
+		.max_expected		= 32,
+		.timeout		= 240,
+	},
+};
+
 static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 	{
 		.name			= "RAS",
 		.me			= THIS_MODULE,
-		.max_expected		= 32,
-		.timeout		= 240,
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= __constant_htons(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.help			= ras_help,
+		.expect_policy		= ras_exp_policy,
+		.expect_class_max	= RAS_EXPECT_MAX,
 	},
 	{
 		.name			= "RAS",
 		.me			= THIS_MODULE,
-		.max_expected		= 32,
-		.timeout		= 240,
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.udp.port	= __constant_htons(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.help			= ras_help,
+		.expect_policy		= ras_exp_policy,
+		.expect_class_max	= RAS_EXPECT_MAX,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b1fd21c..e350f56 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -110,7 +110,8 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	unsigned int h = helper_hash(&me->tuple);
 
-	BUG_ON(me->timeout == 0);
+	BUG_ON(me->expect_policy == NULL);
+	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index c336b07..6d871e4 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -187,7 +187,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			}
 			tuple = &ct->tuplehash[!dir].tuple;
 			port = htons(dcc_port);
-			nf_ct_expect_init(exp, tuple->src.l3num,
+			nf_ct_expect_init(exp, IRC_EXPECT, tuple->src.l3num,
 					  NULL, &tuple->dst.u3,
 					  IPPROTO_TCP, NULL, &port);
 
@@ -210,6 +210,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
 static char irc_names[MAX_PORTS][sizeof("irc-65535")] __read_mostly;
+static struct nf_conntrack_expect_policy irc_exp_policy[IRC_EXPECT_MAX + 1];
 
 static void nf_conntrack_irc_fini(void);
 
@@ -223,6 +224,9 @@ static int __init nf_conntrack_irc_init(void)
 		return -EINVAL;
 	}
 
+	irc_exp_policy[IRC_EXPECT].max_expected = max_dcc_channels;
+	irc_exp_policy[IRC_EXPECT].timeout	= dcc_timeout;
+
 	irc_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!irc_buffer)
 		return -ENOMEM;
@@ -235,8 +239,8 @@ static int __init nf_conntrack_irc_init(void)
 		irc[i].tuple.src.l3num = AF_INET;
 		irc[i].tuple.src.u.tcp.port = htons(ports[i]);
 		irc[i].tuple.dst.protonum = IPPROTO_TCP;
-		irc[i].max_expected = max_dcc_channels;
-		irc[i].timeout = dcc_timeout;
+		irc[i].expect_policy = irc_exp_policy;
+		irc[i].expect_class_max = IRC_EXPECT_MAX;
 		irc[i].me = THIS_MODULE;
 		irc[i].help = help;
 
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 9810d81..7ffc7ff 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -42,6 +42,12 @@ static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
+enum netbios_ns_expectation_classes {
+	NETBIOS_NS_EXPECT,
+	__NETBIOS_NS_EXPECT_MAX
+};
+#define NETBIOS_NS_EXPECT_MAX	(__NETBIOS_NS_EXPECT_MAX - 1)
+
 static int help(struct sk_buff *skb, unsigned int protoff,
 		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
@@ -86,6 +92,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
+	exp->class		  = NETBIOS_NS_EXPECT;
 	exp->helper               = NULL;
 
 	nf_ct_expect_related(exp);
@@ -96,19 +103,26 @@ out:
 	return NF_ACCEPT;
 }
 
+static struct nf_conntrack_expect_policy exp_policy[NETBIOS_NS_EXPECT_MAX + 1] = {
+	[NETBIOS_NS_EXPECT] = {
+		.max_expected	= 1,
+	},
+};
+
 static struct nf_conntrack_helper helper __read_mostly = {
 	.name			= "netbios-ns",
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(NMBD_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.max_expected		= 1,
 	.me			= THIS_MODULE,
 	.help			= help,
+	.expect_policy		= exp_policy,
+	.expect_class_max	= NETBIOS_NS_EXPECT_MAX,
 };
 
 static int __init nf_conntrack_netbios_ns_init(void)
 {
-	helper.timeout = timeout;
+	exp_policy[NETBIOS_NS_EXPECT].timeout = timeout;
 	return nf_conntrack_helper_register(&helper);
 }
 
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index b5cb8e8..40ab327 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -208,7 +208,8 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 
 	/* original direction, PNS->PAC */
 	dir = IP_CT_DIR_ORIGINAL;
-	nf_ct_expect_init(exp_orig, ct->tuplehash[dir].tuple.src.l3num,
+	nf_ct_expect_init(exp_orig, PPTP_EXPECT,
+			  ct->tuplehash[dir].tuple.src.l3num,
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &peer_callid, &callid);
@@ -216,7 +217,8 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 
 	/* reply direction, PAC->PNS */
 	dir = IP_CT_DIR_REPLY;
-	nf_ct_expect_init(exp_reply, ct->tuplehash[dir].tuple.src.l3num,
+	nf_ct_expect_init(exp_reply, PPTP_EXPECT,
+			  ct->tuplehash[dir].tuple.src.l3num,
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &callid, &peer_callid);
@@ -575,17 +577,24 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
+static const struct nf_conntrack_expect_policy pptp_exp_policy[PPTP_EXPECT_MAX + 1] = {
+	[PPTP_EXPECT] = {
+		.max_expected	= 2,
+		.timeout	= 5 * 60,
+	},
+};
+
 /* control protocol helper */
 static struct nf_conntrack_helper pptp __read_mostly = {
 	.name			= "pptp",
 	.me			= THIS_MODULE,
-	.max_expected		= 2,
-	.timeout		= 5 * 60,
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.tcp.port	= __constant_htons(PPTP_CONTROL_PORT),
 	.tuple.dst.protonum	= IPPROTO_TCP,
 	.help			= conntrack_pptp_help,
 	.destroy		= pptp_destroy_siblings,
+	.expect_policy		= pptp_exp_policy,
+	.expect_class_max	= PPTP_EXPECT_MAX,
 };
 
 static int __init nf_conntrack_pptp_init(void)
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index a70051d..ddb7581 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -143,7 +143,8 @@ static int help(struct sk_buff *skb,
 	}
 
 	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+	nf_ct_expect_init(exp, SANE_EXPECT, family,
+			  &tuple->src.u3, &tuple->dst.u3,
 			  IPPROTO_TCP, NULL, &reply->port);
 
 	pr_debug("nf_ct_sane: expect: ");
@@ -163,6 +164,13 @@ out:
 static struct nf_conntrack_helper sane[MAX_PORTS][2] __read_mostly;
 static char sane_names[MAX_PORTS][2][sizeof("sane-65535")] __read_mostly;
 
+static const struct nf_conntrack_expect_policy sane_exp_policy[SANE_EXPECT_MAX + 1] = {
+	[SANE_EXPECT] = {
+		.max_expected	= 1,
+		.timeout	= 5 * 60,
+	},
+};
+
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
@@ -200,8 +208,8 @@ static int __init nf_conntrack_sane_init(void)
 		for (j = 0; j < 2; j++) {
 			sane[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			sane[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			sane[i][j].max_expected = 1;
-			sane[i][j].timeout = 5 * 60;	/* 5 Minutes */
+			sane[i][j].expect_policy = sane_exp_policy;
+			sane[i][j].expect_class_max = SANE_EXPECT_MAX;
 			sane[i][j].me = THIS_MODULE;
 			sane[i][j].help = help;
 			tmpname = &sane_names[i][j][0];
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c521c89..d38f953 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -380,7 +380,7 @@ static int set_expected_rtp(struct sk_buff *skb,
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL)
 		return NF_DROP;
-	nf_ct_expect_init(exp, family,
+	nf_ct_expect_init(exp, SIP_EXPECT, family,
 			  &ct->tuplehash[!dir].tuple.src.u3, addr,
 			  IPPROTO_UDP, NULL, &port);
 
@@ -476,6 +476,13 @@ out:
 static struct nf_conntrack_helper sip[MAX_PORTS][2] __read_mostly;
 static char sip_names[MAX_PORTS][2][sizeof("sip-65535")] __read_mostly;
 
+static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
+	[SIP_EXPECT] = {
+		.max_expected	= 2,
+		.timeout	= 3 * 60,
+	},
+};
+
 static void nf_conntrack_sip_fini(void)
 {
 	int i, j;
@@ -505,8 +512,8 @@ static int __init nf_conntrack_sip_init(void)
 		for (j = 0; j < 2; j++) {
 			sip[i][j].tuple.dst.protonum = IPPROTO_UDP;
 			sip[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			sip[i][j].max_expected = 2;
-			sip[i][j].timeout = 3 * 60; /* 3 minutes */
+			sip[i][j].expect_policy = sip_exp_policy;
+			sip[i][j].expect_class_max = SIP_EXPECT_MAX;
 			sip[i][j].me = THIS_MODULE;
 			sip[i][j].help = sip_help;
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index bd2e800..7be03d6 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -63,7 +63,8 @@ static int tftp_help(struct sk_buff *skb,
 		if (exp == NULL)
 			return NF_DROP;
 		tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
+		nf_ct_expect_init(exp, TFTP_EXPECT, family,
+				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
 		pr_debug("expect: ");
@@ -92,6 +93,13 @@ static int tftp_help(struct sk_buff *skb,
 static struct nf_conntrack_helper tftp[MAX_PORTS][2] __read_mostly;
 static char tftp_names[MAX_PORTS][2][sizeof("tftp-65535")] __read_mostly;
 
+static const struct nf_conntrack_expect_policy tftp_exp_policy[TFTP_EXPECT_MAX + 1] = {
+	[TFTP_EXPECT] = {
+		.max_expected	= 1,
+		.timeout	= 5 * 60,
+	},
+};
+
 static void nf_conntrack_tftp_fini(void)
 {
 	int i, j;
@@ -118,8 +126,8 @@ static int __init nf_conntrack_tftp_init(void)
 		for (j = 0; j < 2; j++) {
 			tftp[i][j].tuple.dst.protonum = IPPROTO_UDP;
 			tftp[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			tftp[i][j].max_expected = 1;
-			tftp[i][j].timeout = 5 * 60; /* 5 minutes */
+			tftp[i][j].expect_policy = tftp_exp_policy;
+			tftp[i][j].expect_class_max = TFTP_EXPECT_MAX;
 			tftp[i][j].me = THIS_MODULE;
 			tftp[i][j].help = tftp_help;
 
