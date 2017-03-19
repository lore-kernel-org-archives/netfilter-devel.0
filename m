From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 3/5] netfilter: drop const qualifier from struct nf_conntrack_expect_policy
Date: Sun, 19 Mar 2017 22:36:00 +0800
Message-ID: <1489934162-7415-4-git-send-email-zlpnobody@163.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m50-156.163.com ([123.125.50.156]:47680 "EHLO m50-156.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdCSPL1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 11:11:27 -0400
In-Reply-To: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

So we can modify the nf_conntrack_expect_policy directly, the next patch
will need this.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 4 ++--
 net/ipv4/netfilter/nf_nat_snmp_basic.c      | 2 +-
 net/netfilter/nf_conntrack_amanda.c         | 2 +-
 net/netfilter/nf_conntrack_expect.c         | 2 +-
 net/netfilter/nf_conntrack_ftp.c            | 2 +-
 net/netfilter/nf_conntrack_h323_main.c      | 6 +++---
 net/netfilter/nf_conntrack_helper.c         | 2 +-
 net/netfilter/nf_conntrack_pptp.c           | 2 +-
 net/netfilter/nf_conntrack_sane.c           | 2 +-
 net/netfilter/nf_conntrack_sip.c            | 2 +-
 net/netfilter/nf_conntrack_tftp.c           | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1eaac1f..621a404 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -27,7 +27,7 @@ struct nf_conntrack_helper {
 
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
 	struct module *me;		/* pointer to self */
-	const struct nf_conntrack_expect_policy *expect_policy;
+	struct nf_conntrack_expect_policy *expect_policy;
 
 	/* length of internal data, ie. sizeof(struct nf_ct_*_master) */
 	size_t data_len;
@@ -61,7 +61,7 @@ struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u16 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
-		       const struct nf_conntrack_expect_policy *exp_pol,
+		       struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max, u32 data_len,
 		       int (*help)(struct sk_buff *skb, unsigned int protoff,
 				   struct nf_conn *ct,
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index c9b52c3..5f32532 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1255,7 +1255,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
-static const struct nf_conntrack_expect_policy snmp_exp_policy = {
+static struct nf_conntrack_expect_policy snmp_exp_policy = {
 	.max_expected	= 0,
 	.timeout	= 180,
 };
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 57a26cc..fbf9f59 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -167,7 +167,7 @@ static int amanda_help(struct sk_buff *skb,
 	return ret;
 }
 
-static const struct nf_conntrack_expect_policy amanda_exp_policy = {
+static struct nf_conntrack_expect_policy amanda_exp_policy = {
 	.max_expected		= 3,
 	.timeout		= 180,
 };
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4b2e1fb..2d81122 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -402,7 +402,7 @@ static void evict_oldest_expect(struct nf_conn *master,
 
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 {
-	const struct nf_conntrack_expect_policy *p;
+	struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
 	struct nf_conn *master = expect->master;
 	struct nf_conn_help *master_help = nfct_help(master);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 4aecef4..ad51dd3 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -561,7 +561,7 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 
 static struct nf_conntrack_helper ftp[MAX_PORTS * 2] __read_mostly;
 
-static const struct nf_conntrack_expect_policy ftp_exp_policy = {
+static struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index f65d936..2223c57 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -629,7 +629,7 @@ static int h245_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
-static const struct nf_conntrack_expect_policy h245_exp_policy = {
+static struct nf_conntrack_expect_policy h245_exp_policy = {
 	.max_expected	= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
 	.timeout	= 240,
 };
@@ -1205,7 +1205,7 @@ static int q931_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
-static const struct nf_conntrack_expect_policy q931_exp_policy = {
+static struct nf_conntrack_expect_policy q931_exp_policy = {
 	/* T.120 and H.245 */
 	.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 4,
 	.timeout		= 240,
@@ -1791,7 +1791,7 @@ static int ras_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 /****************************************************************************/
-static const struct nf_conntrack_expect_policy ras_exp_policy = {
+static struct nf_conntrack_expect_policy ras_exp_policy = {
 	.max_expected		= 32,
 	.timeout		= 240,
 };
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..b8591fb 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -483,7 +483,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u16 l3num, u16 protonum, const char *name,
 		       u16 default_port, u16 spec_port, u32 id,
-		       const struct nf_conntrack_expect_policy *exp_pol,
+		       struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max, u32 data_len,
 		       int (*help)(struct sk_buff *skb, unsigned int protoff,
 				   struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f60a475..1f20d6a 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -587,7 +587,7 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
-static const struct nf_conntrack_expect_policy pptp_exp_policy = {
+static struct nf_conntrack_expect_policy pptp_exp_policy = {
 	.max_expected	= 2,
 	.timeout	= 5 * 60,
 };
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 9dcb9ee..d54cfec 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -168,7 +168,7 @@ static int help(struct sk_buff *skb,
 
 static struct nf_conntrack_helper sane[MAX_PORTS * 2] __read_mostly;
 
-static const struct nf_conntrack_expect_policy sane_exp_policy = {
+static struct nf_conntrack_expect_policy sane_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 0d17894..3ec7b734 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1592,7 +1592,7 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 
 static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;
 
-static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
+static struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
 	[SIP_EXPECT_SIGNALLING] = {
 		.name		= "signalling",
 		.max_expected	= 1,
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index b1227dc..fcc4965 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -99,7 +99,7 @@ static int tftp_help(struct sk_buff *skb,
 
 static struct nf_conntrack_helper tftp[MAX_PORTS * 2] __read_mostly;
 
-static const struct nf_conntrack_expect_policy tftp_exp_policy = {
+static struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
-- 
2.5.5


