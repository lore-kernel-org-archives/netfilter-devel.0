From: gfree.wind@vip.163.com
Subject: [PATCH nf v6 2/3] netfilter: nat_helper: Register one nf_ct_nat_helper each proto nat module
Date: Fri,  5 May 2017 08:55:12 +0800
Message-ID: <1493945713-67263-2-git-send-email-gfree.wind@vip.163.com>
References: <1493945713-67263-1-git-send-email-gfree.wind@vip.163.com>
Cc: Gao Feng <gfree.wind@vip.163.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from proxy90-7.mail.163.com ([43.230.90.7]:40378 "EHLO
        proxy90-7.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdEEBBN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 21:01:13 -0400
In-Reply-To: <1493945713-67263-1-git-send-email-gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <gfree.wind@vip.163.com>

There are multiple proto nat modules which depend on the follow_master_nat
in the nf_nat_core. When this module is gone, all modules which refers to
it could not work well.

Now register one struct nf_ct_nat_helper in every proto nat module, it makes
sure every nat module could not effect each other, and it is helpful to
maintain the codes. The new nf_ct_nat_helper could be found by ctlink with
its name too, while the original "nat-follow-master" helper is not effected.
ctlink still could specify the "nat-follow-master" for ftp, but recommend
use the ftp's nat_helper "ftp-nat-follow-master" as the ftp nat_helper.

The following are all modifications.
1. Every proto nat module registers one nat_helper at least;
2. Replace the expectfn with nat_helper in the nf_conntrack_expect;
It is used to the latter commit which add the nat_helper module check.
3. Remove nf_ct_nat_helper_find_by_symbol, it is useless now.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
---
 v6: Rename the helper name of ftp, tftp.. to ftp-nat-follow-master, per Pablo
 v5: Register one nat_helper for every nat module, per Pablo
 v4: Cover the nat_module assignment in dataplane, per Pablo
 v3: Rename the nf_ct_helper_expectfn, func, and member, per Pablo
 v2: Use the module as the identifier when flush expect
 v1: initial version

 include/net/netfilter/nf_conntrack_expect.h |  5 ++--
 include/net/netfilter/nf_conntrack_helper.h |  2 --
 net/ipv4/netfilter/nf_nat_h323.c            | 44 ++++++++++++++++++-----------
 net/netfilter/ipvs/ip_vs_nfct.c             |  7 ++++-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_core.c           |  4 +--
 net/netfilter/nf_conntrack_expect.c         |  2 +-
 net/netfilter/nf_conntrack_netlink.c        | 14 ++++-----
 net/netfilter/nf_conntrack_pptp.c           | 14 +++++++--
 net/netfilter/nf_nat_amanda.c               |  9 +++++-
 net/netfilter/nf_nat_ftp.c                  |  9 +++++-
 net/netfilter/nf_nat_irc.c                  |  9 +++++-
 net/netfilter/nf_nat_sip.c                  | 18 ++++++------
 net/netfilter/nf_nat_tftp.c                 |  9 +++++-
 14 files changed, 101 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5ed33ea..f665a6b 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -23,9 +23,8 @@ struct nf_conntrack_expect {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
-	/* Function to call after setup and insertion */
-	void (*expectfn)(struct nf_conn *new,
-			 struct nf_conntrack_expect *this);
+	/* Expectation function owner */
+	struct nf_ct_nat_helper *nat_helper;
 
 	/* Helper to assign to new connection */
 	struct nf_conntrack_helper *helper;
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d14fe493..e8d31ca 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -125,8 +125,6 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 void nf_ct_nat_helper_unregister(struct nf_ct_nat_helper *n);
 struct nf_ct_nat_helper *
 nf_ct_nat_helper_find_by_name(const char *name);
-struct nf_ct_nat_helper *
-nf_ct_nat_helper_find_by_symbol(const void *symbol);
 
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 346e764..ce2095c 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -21,6 +21,26 @@
 #include <linux/netfilter/nf_conntrack_h323.h>
 
 /****************************************************************************/
+static void ip_nat_q931_expect(struct nf_conn *new,
+			       struct nf_conntrack_expect *this);
+static void ip_nat_callforwarding_expect(struct nf_conn *new,
+					 struct nf_conntrack_expect *this);
+
+static struct nf_ct_nat_helper q931_nat = {
+	.name		= "Q.931",
+	.expectfn	= ip_nat_q931_expect,
+};
+
+static struct nf_ct_nat_helper callforwarding_nat = {
+	.name		= "callforwarding",
+	.expectfn	= ip_nat_callforwarding_expect,
+};
+
+static struct nf_ct_nat_helper follow_master_nat = {
+	.name		= "h323-nat-follow-master",
+	.expectfn	= nf_nat_follow_master,
+};
+
 static int set_addr(struct sk_buff *skb, unsigned int protoff,
 		    unsigned char **data, int dataoff,
 		    unsigned int addroff, __be32 ip, __be16 port)
@@ -187,10 +207,10 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 
 	/* Set expectations for NAT */
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
-	rtp_exp->expectfn = nf_nat_follow_master;
+	rtp_exp->nat_helper = &follow_master_nat;
 	rtp_exp->dir = !dir;
 	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
-	rtcp_exp->expectfn = nf_nat_follow_master;
+	rtcp_exp->nat_helper = &follow_master_nat;
 	rtcp_exp->dir = !dir;
 
 	/* Lookup existing expects */
@@ -289,7 +309,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &follow_master_nat;
 	exp->dir = !dir;
 
 	/* Try to get same port: if not, try to change it. */
@@ -341,7 +361,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &follow_master_nat;
 	exp->dir = !dir;
 
 	/* Check existing expects */
@@ -433,7 +453,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-	exp->expectfn = ip_nat_q931_expect;
+	exp->nat_helper = &q931_nat;
 	exp->dir = !dir;
 
 	/* Check existing expects */
@@ -527,7 +547,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	exp->saved_addr = exp->tuple.dst.u3;
 	exp->tuple.dst.u3.ip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
-	exp->expectfn = ip_nat_callforwarding_expect;
+	exp->nat_helper = &callforwarding_nat;
 	exp->dir = !dir;
 
 	/* Try to get same port: if not, try to change it. */
@@ -567,16 +587,6 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-static struct nf_ct_nat_helper q931_nat = {
-	.name		= "Q.931",
-	.expectfn	= ip_nat_q931_expect,
-};
-
-static struct nf_ct_nat_helper callforwarding_nat = {
-	.name		= "callforwarding",
-	.expectfn	= ip_nat_callforwarding_expect,
-};
-
 /****************************************************************************/
 static int __init init(void)
 {
@@ -601,6 +611,7 @@ static int __init init(void)
 	RCU_INIT_POINTER(nat_q931_hook, nat_q931);
 	nf_ct_nat_helper_register(&q931_nat);
 	nf_ct_nat_helper_register(&callforwarding_nat);
+	nf_ct_nat_helper_register(&follow_master_nat);
 	return 0;
 }
 
@@ -618,6 +629,7 @@ static void __exit fini(void)
 	RCU_INIT_POINTER(nat_q931_hook, NULL);
 	nf_ct_nat_helper_unregister(&q931_nat);
 	nf_ct_nat_helper_unregister(&callforwarding_nat);
+	nf_ct_nat_helper_unregister(&follow_master_nat);
 	synchronize_rcu();
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index fc230d9..fc5af4f 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -220,6 +220,11 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
 	return;
 }
 
+static struct nf_ct_nat_helper ip_vs_nat = {
+	.name = "ip-vs-nat",
+	.expectfn = ip_vs_nfct_expect_callback,
+};
+
 /*
  * Create NF conntrack expectation with wildcard (optional) source port.
  * Then the default callback function will alter the reply and will confirm
@@ -245,7 +250,7 @@ void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 			proto, port ? &port : NULL,
 			from_rs ? &cp->cport : &cp->vport);
 
-	exp->expectfn = ip_vs_nfct_expect_callback;
+	exp->nat_helper = &ip_vs_nat;
 
 	IP_VS_DBG(7, "%s: ct=%p, expect tuple=" FMT_TUPLE "\n",
 		__func__, ct, ARG_TUPLE(&exp->tuple));
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 4e99cca..114e042 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -65,7 +65,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->mask.src.u3.ip       = mask;
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
 
-	exp->expectfn             = NULL;
+	exp->nat_helper           = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	exp->helper               = NULL;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ffb78e5..ae61513 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1233,8 +1233,8 @@ void nf_conntrack_free(struct nf_conn *ct)
 	local_bh_enable();
 
 	if (exp) {
-		if (exp->expectfn)
-			exp->expectfn(ct, exp);
+		if (exp->nat_helper)
+			exp->nat_helper->expectfn(ct, exp);
 		nf_ct_expect_put(exp);
 	}
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index d800730..aef8e18 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -295,7 +295,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 
 	exp->flags = 0;
 	exp->class = class;
-	exp->expectfn = NULL;
+	exp->nat_helper = NULL;
 	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0e3d1af..2a7ade6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2522,7 +2522,6 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
 #endif
-	struct nf_ct_nat_helper *nat_helper;
 
 	if (timeout < 0)
 		timeout = 0;
@@ -2571,9 +2570,9 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 		    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
 			goto nla_put_failure;
 	}
-	nat_helper = nf_ct_nat_helper_find_by_symbol(exp->expectfn);
-	if (!nat_helper &&
-	    nla_put_string(skb, CTA_EXPECT_FN, nat_helper->name))
+
+	if (!exp->nat_helper &&
+	    nla_put_string(skb, CTA_EXPECT_FN, exp->nat_helper->name))
 		goto nla_put_failure;
 
 	return 0;
@@ -3097,9 +3096,10 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 			err = -EINVAL;
 			goto err_out;
 		}
-		exp->expectfn = nat_helper->expectfn;
-	} else
-		exp->expectfn = NULL;
+		exp->nat_helper = nat_helper;
+	} else {
+		exp->nat_helper = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f60a475..896b154 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -69,6 +69,9 @@
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
+static void pptp_expectfn(struct nf_conn *ct,
+			  struct nf_conntrack_expect *exp);
+
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 /* PptpControlMessageType names */
 const char *const pptp_msg_name[] = {
@@ -99,6 +102,11 @@
 #define PPTP_GRE_TIMEOUT 		(10 MINS)
 #define PPTP_GRE_STREAM_TIMEOUT 	(5 HOURS)
 
+static struct nf_ct_nat_helper pptp_nat = {
+	.name			= "pptp-nat",
+	.expectfn		= pptp_expectfn,
+};
+
 static void pptp_expectfn(struct nf_conn *ct,
 			 struct nf_conntrack_expect *exp)
 {
@@ -221,7 +229,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &peer_callid, &callid);
-	exp_orig->expectfn = pptp_expectfn;
+	exp_orig->nat_helper = &pptp_nat;
 
 	/* reply direction, PAC->PNS */
 	dir = IP_CT_DIR_REPLY;
@@ -230,7 +238,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &callid, &peer_callid);
-	exp_reply->expectfn = pptp_expectfn;
+	exp_reply->nat_helper = &pptp_nat;
 
 	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
 	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
@@ -607,11 +615,13 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 
 static int __init nf_conntrack_pptp_init(void)
 {
+	nf_ct_nat_helper_register(&pptp_nat);
 	return nf_conntrack_helper_register(&pptp);
 }
 
 static void __exit nf_conntrack_pptp_fini(void)
 {
+	nf_ct_nat_helper_unregister(&pptp_nat);
 	nf_conntrack_helper_unregister(&pptp);
 }
 
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index eb77238..9b540a9 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -24,6 +24,11 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_nat_amanda");
 
+static struct nf_ct_nat_helper amanda_nat = {
+	.name = "amanda-nat-follow-master",
+	.expectfn = nf_nat_follow_master,
+};
+
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int protoff,
@@ -41,7 +46,7 @@ static unsigned int help(struct sk_buff *skb,
 
 	/* When you see the packet, we need to NAT it the same as the
 	 * this one (ie. same IP: it will be TCP and master is UDP). */
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &amanda_nat;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
@@ -76,12 +81,14 @@ static unsigned int help(struct sk_buff *skb,
 static void __exit nf_nat_amanda_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
+	nf_ct_nat_helper_unregister(&amanda_nat);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_amanda_init(void)
 {
 	BUG_ON(nf_nat_amanda_hook != NULL);
+	nf_ct_nat_helper_register(&amanda_nat);
 	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index e84a578..f1f4501 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -24,6 +24,11 @@
 MODULE_DESCRIPTION("ftp NAT helper");
 MODULE_ALIAS("ip_nat_ftp");
 
+static struct nf_ct_nat_helper ftp_nat = {
+	.name = "ftp-nat-follow-master",
+	.expectfn = nf_nat_follow_master,
+};
+
 /* FIXME: Time out? --RR */
 
 static int nf_nat_ftp_fmt_cmd(struct nf_conn *ct, enum nf_ct_ftp_type type,
@@ -80,7 +85,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 
 	/* When you see the packet, we need to NAT it the same as the
 	 * this one. */
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &ftp_nat;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
@@ -123,12 +128,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 static void __exit nf_nat_ftp_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
+	nf_ct_nat_helper_unregister(&ftp_nat);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_ftp_init(void)
 {
 	BUG_ON(nf_nat_ftp_hook != NULL);
+	nf_ct_nat_helper_register(&ftp_nat);
 	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fb2258..cf623d3 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -26,6 +26,11 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_nat_irc");
 
+static struct nf_ct_nat_helper irc_nat = {
+	.name = "irc-nat-follow-master",
+	.expectfn = nf_nat_follow_master,
+};
+
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int protoff,
@@ -44,7 +49,7 @@ static unsigned int help(struct sk_buff *skb,
 
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &irc_nat;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
@@ -96,12 +101,14 @@ static unsigned int help(struct sk_buff *skb,
 static void __exit nf_nat_irc_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
+	nf_ct_nat_helper_unregister(&irc_nat);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_irc_init(void)
 {
 	BUG_ON(nf_nat_irc_hook != NULL);
+	nf_ct_nat_helper_register(&irc_nat);
 	RCU_INIT_POINTER(nf_nat_irc_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index d27c5a2..cd9333c 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -28,6 +28,13 @@
 MODULE_DESCRIPTION("SIP NAT helper");
 MODULE_ALIAS("ip_nat_sip");
 
+static void nf_nat_sip_expected(struct nf_conn *ct,
+				struct nf_conntrack_expect *exp);
+
+static struct nf_ct_nat_helper sip_nat = {
+	.name		= "sip",
+	.expectfn	= nf_nat_sip_expected,
+};
 
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 				  unsigned int dataoff,
@@ -376,7 +383,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 	exp->tuple.dst.u3 = newaddr;
 	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
 	exp->dir = !dir;
-	exp->expectfn = nf_nat_sip_expected;
+	exp->nat_helper = &sip_nat;
 
 	for (; port != 0; port++) {
 		int ret;
@@ -561,13 +568,13 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 	rtp_exp->tuple.dst.u3 = *rtp_addr;
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->dir = !dir;
-	rtp_exp->expectfn = nf_nat_sip_expected;
+	rtp_exp->nat_helper = &sip_nat;
 
 	rtcp_exp->saved_addr = rtcp_exp->tuple.dst.u3;
 	rtcp_exp->tuple.dst.u3 = *rtp_addr;
 	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
 	rtcp_exp->dir = !dir;
-	rtcp_exp->expectfn = nf_nat_sip_expected;
+	rtcp_exp->nat_helper = &sip_nat;
 
 	/* Try to get same pair of ports: if not, try to change them. */
 	for (port = ntohs(rtp_exp->tuple.dst.u.udp.port);
@@ -618,11 +625,6 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 	return NF_DROP;
 }
 
-static struct nf_ct_nat_helper sip_nat = {
-	.name		= "sip",
-	.expectfn	= nf_nat_sip_expected,
-};
-
 static void __exit nf_nat_sip_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d..d279b41 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -18,6 +18,11 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_nat_tftp");
 
+static struct nf_ct_nat_helper tftp_nat = {
+	.name = "tftp-nat-follow-master",
+	.expectfn = nf_nat_follow_master,
+};
+
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
 			 struct nf_conntrack_expect *exp)
@@ -27,7 +32,7 @@ static unsigned int help(struct sk_buff *skb,
 	exp->saved_proto.udp.port
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
-	exp->expectfn = nf_nat_follow_master;
+	exp->nat_helper = &tftp_nat;
 	if (nf_ct_expect_related(exp) != 0) {
 		nf_ct_helper_log(skb, exp->master, "cannot add expectation");
 		return NF_DROP;
@@ -38,12 +43,14 @@ static unsigned int help(struct sk_buff *skb,
 static void __exit nf_nat_tftp_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
+	nf_ct_nat_helper_unregister(&tftp_nat);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_tftp_init(void)
 {
 	BUG_ON(nf_nat_tftp_hook != NULL);
+	nf_ct_nat_helper_register(&tftp_nat);
 	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
 	return 0;
 }
-- 
1.9.1


