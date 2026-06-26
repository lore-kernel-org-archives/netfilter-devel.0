Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06EE1F8AC5
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782477118; cv=none; b=dADmvg/rRUs4fm9F/gV8TZMO6fQHQoftOqGhh1ZKuJW7qm0o6mZ/8ZUSCyVn9PP7aEITXT/jEDyMdt0OclkozIVz8Yjl0PZaF0ITQtHyfnD+B3dHn5xRts9SsWV/DhtTD0WB1jRHIkbnOmtvquW+P+McnMyO/Dhc3syrRn9be5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782477118; c=relaxed/simple;
	bh=rUmdjKyLS6cdVMwr+yAdOLEZC+6bCRtOlg5AAtdo0rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv7a+d/g5VDr1WJ8NT7quPHTd+T7/CHCVhGB7+KuaeXx21d601Bi3rwDSlVRBLbm+OcPV5OXgM/f1Jxd3uHTjV1DeSQtIPP75EiO6ZsH2zui62XYLAwJjwBlKU3jvYlFTiLYglN2dHJC5moF4AvIOrd70q4rXNDMZaOZigJsapA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77B5F602A3; Fri, 26 Jun 2026 14:31:54 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: conntrack: remove obsolete module parameters
Date: Fri, 26 Jun 2026 14:31:31 +0200
Message-ID: <20260626123131.23096-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626123131.23096-1-fw@strlen.de>
References: <20260626123131.23096-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

helper autoassign was removed years ago, all the port numbers are
no longer functional.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_h323.h |  2 -
 include/linux/netfilter/nf_conntrack_pptp.h |  2 -
 include/linux/netfilter/nf_conntrack_sane.h |  2 -
 include/linux/netfilter/nf_conntrack_tftp.h |  2 -
 include/net/netfilter/nf_conntrack_helper.h |  1 -
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  4 +-
 net/netfilter/nf_conntrack_ftp.c            | 32 +++++----------
 net/netfilter/nf_conntrack_h323_main.c      | 10 ++---
 net/netfilter/nf_conntrack_helper.c         |  6 +--
 net/netfilter/nf_conntrack_irc.c            | 27 ++++---------
 net/netfilter/nf_conntrack_netbios_ns.c     |  2 -
 net/netfilter/nf_conntrack_pptp.c           |  2 +-
 net/netfilter/nf_conntrack_sane.c           | 34 +++++-----------
 net/netfilter/nf_conntrack_sip.c            | 45 ++++++---------------
 net/netfilter/nf_conntrack_snmp.c           |  4 +-
 net/netfilter/nf_conntrack_tftp.c           | 33 +++++----------
 17 files changed, 59 insertions(+), 151 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 81286c499325..b15f37604cde 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -9,8 +9,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
-#define RAS_PORT 1719
-#define Q931_PORT 1720
 #define H323_RTP_CHANNEL_MAX 4	/* Audio, video, FAX and other */
 
 /* This structure exists only once per master */
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index c3bdb4370938..c0b305ce7c3c 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -50,8 +50,6 @@ struct nf_nat_pptp {
 	__be16 pac_call_id;			/* NAT'ed PAC call id */
 };
 
-#define PPTP_CONTROL_PORT	1723
-
 #define PPTP_PACKET_CONTROL	1
 #define PPTP_PACKET_MGMT	2
 
diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
index 46c7acd1b4a7..8501035d7335 100644
--- a/include/linux/netfilter/nf_conntrack_sane.h
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -3,8 +3,6 @@
 #define _NF_CONNTRACK_SANE_H
 /* SANE tracking. */
 
-#define SANE_PORT	6566
-
 enum sane_state {
 	SANE_STATE_NORMAL,
 	SANE_STATE_START_REQUESTED,
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index 90b334bbce3c..e3d1739c557d 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -2,8 +2,6 @@
 #ifndef _NF_CONNTRACK_TFTP_H
 #define _NF_CONNTRACK_TFTP_H
 
-#define TFTP_PORT 69
-
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index f3f0c1392e88..bc5427d239f4 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -94,7 +94,6 @@ void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u8 l3num, u16 protonum, const char *name,
-		       u16 default_port, u16 spec_port, u32 id,
 		       const struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max,
 		       int (*help)(struct sk_buff *skb, unsigned int protoff,
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index 0ede138dfd29..e540b86bd15b 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -213,7 +213,7 @@ static int __init nf_nat_snmp_basic_init(void)
 	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
 
 	nf_ct_helper_init(&snmp_trap_helper, AF_INET, IPPROTO_UDP,
-			  "snmp_trap", SNMP_TRAP_PORT, SNMP_TRAP_PORT, SNMP_TRAP_PORT,
+			  "snmp_trap",
 			  &snmp_exp_policy, 0, help, NULL, THIS_MODULE);
 
 	err = nf_conntrack_helper_register(&snmp_trap_helper, &snmp_trap_helper_ptr);
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index ddafbdfc96dc..edced039970d 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -199,10 +199,10 @@ static int __init nf_conntrack_amanda_init(void)
 	}
 
 	nf_ct_helper_init(&amanda_helper[0], AF_INET, IPPROTO_UDP,
-			  HELPER_NAME, 10080, 10080, 10080,
+			  HELPER_NAME,
 			  &amanda_exp_policy, 0, amanda_help, NULL, THIS_MODULE);
 	nf_ct_helper_init(&amanda_helper[1], AF_INET6, IPPROTO_UDP,
-			  HELPER_NAME, 10080, 10080, 10080,
+			  HELPER_NAME,
 			  &amanda_exp_policy, 0, amanda_help, NULL, THIS_MODULE);
 
 	ret = nf_conntrack_helpers_register(amanda_helper,
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 0847f845613d..f3944598c172 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -35,11 +35,6 @@ MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 static DEFINE_SPINLOCK(nf_ftp_lock);
 
-#define MAX_PORTS 8
-static u_int16_t ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-
 static bool loose;
 module_param(loose, bool, 0600);
 
@@ -560,8 +555,8 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	return 0;
 }
 
-static struct nf_conntrack_helper ftp[MAX_PORTS * 2] __read_mostly;
-static struct nf_conntrack_helper *ftp_ptr[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper ftp __read_mostly;
+static struct nf_conntrack_helper *ftp_ptr __read_mostly;
 
 static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.max_expected	= 1,
@@ -570,32 +565,23 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 
 static void __exit nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(ftp_ptr, ports_c * 2);
+	nf_conntrack_helper_unregister(ftp_ptr);
 }
 
 static int __init nf_conntrack_ftp_init(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_ftp_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = FTP_PORT;
-
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
-				  &ftp_exp_policy, 0, help,
-				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
-				  &ftp_exp_policy, 0, help,
-				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-	}
+	nf_ct_helper_init(&ftp, NFPROTO_UNSPEC, IPPROTO_TCP,
+			  HELPER_NAME,
+			  &ftp_exp_policy, 0, help,
+			  nf_ct_ftp_from_nlattr, THIS_MODULE);
 
-	ret = nf_conntrack_helpers_register(ftp, ports_c * 2, ftp_ptr);
+	ret = nf_conntrack_helper_register(&ftp, &ftp_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 24931e379985..98b9753d5e65 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1713,19 +1713,19 @@ static int __init h323_helper_init(void)
 	int ret;
 
 	nf_ct_helper_init(&nf_conntrack_helper_ras[0], AF_INET, IPPROTO_UDP,
-			  "RAS", RAS_PORT, RAS_PORT, RAS_PORT,
+			  "RAS",
 			  &ras_exp_policy, 0, ras_help, NULL, THIS_MODULE);
 	nf_ct_helper_init(&nf_conntrack_helper_ras[1], AF_INET6, IPPROTO_UDP,
-			  "RAS", RAS_PORT, RAS_PORT, RAS_PORT,
+			  "RAS",
 			  &ras_exp_policy, 0, ras_help, NULL, THIS_MODULE);
 	nf_ct_helper_init(&nf_conntrack_helper_h245, AF_UNSPEC, IPPROTO_UDP,
-			  "H.245", 0, 0, 0,
+			  "H.245",
 			  &h245_exp_policy, 0, h245_help, NULL, THIS_MODULE);
 	nf_ct_helper_init(&nf_conntrack_helper_q931[0], AF_INET, IPPROTO_TCP,
-			  "Q.931", Q931_PORT, Q931_PORT, Q931_PORT,
+			  "Q.931",
 			  &q931_exp_policy, 0, q931_help, NULL, THIS_MODULE);
 	nf_ct_helper_init(&nf_conntrack_helper_q931[1], AF_INET6, IPPROTO_TCP,
-			  "Q.931", Q931_PORT, Q931_PORT, Q931_PORT,
+			  "Q.931",
 			  &q931_exp_policy, 0, q931_help, NULL, THIS_MODULE);
 
 	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b28986100db0..506c58034761 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -472,7 +472,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 		       u8 l3num, u16 protonum, const char *name,
-		       u16 default_port, u16 spec_port, u32 id,
 		       const struct nf_conntrack_expect_policy *exp_pol,
 		       u32 expect_class_max,
 		       int (*help)(struct sk_buff *skb, unsigned int protoff,
@@ -493,10 +492,7 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 	snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
 		 NF_NAT_HELPER_PREFIX "%s", name);
 
-	if (spec_port == default_port)
-		snprintf(helper->name, sizeof(helper->name), "%s", name);
-	else
-		snprintf(helper->name, sizeof(helper->name), "%s-%u", name, id);
+	snprintf(helper->name, sizeof(helper->name), "%s", name);
 
 	if (WARN_ON_ONCE(expect_class_max >= NF_CT_MAX_EXPECT_CLASSES))
 		return;
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 193ab34db795..4e6bafe41437 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -21,9 +21,6 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_irc.h>
 
-#define MAX_PORTS 8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
 static unsigned int max_dcc_channels = 8;
 static unsigned int dcc_timeout __read_mostly = 300;
 /* This is slow, but it's simple. --RR */
@@ -42,8 +39,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 module_param(max_dcc_channels, uint, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
 				   "IRC session");
@@ -254,13 +249,13 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
-static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
-static struct nf_conntrack_helper *irc_ptr[MAX_PORTS] __read_mostly;
+static struct nf_conntrack_helper irc __read_mostly;
+static struct nf_conntrack_helper *irc_ptr __read_mostly;
 static struct nf_conntrack_expect_policy irc_exp_policy;
 
 static int __init nf_conntrack_irc_init(void)
 {
-	int i, ret;
+	int ret;
 
 	nf_conntrack_helper_deprecated(HELPER_NAME);
 
@@ -282,17 +277,11 @@ static int __init nf_conntrack_irc_init(void)
 	if (!irc_buffer)
 		return -ENOMEM;
 
-	/* If no port given, default to standard irc port */
-	if (ports_c == 0)
-		ports[ports_c++] = IRC_PORT;
+	nf_ct_helper_init(&irc, AF_INET, IPPROTO_TCP, HELPER_NAME,
+			  &irc_exp_policy,
+			  0, help, NULL, THIS_MODULE);
 
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, HELPER_NAME,
-				  IRC_PORT, ports[i], i, &irc_exp_policy,
-				  0, help, NULL, THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(&irc[0], ports_c, irc_ptr);
+	ret = nf_conntrack_helper_register(&irc, &irc_ptr);
 	if (ret) {
 		pr_err("failed to register helpers\n");
 		kfree(irc_buffer);
@@ -304,7 +293,7 @@ static int __init nf_conntrack_irc_init(void)
 
 static void __exit nf_conntrack_irc_fini(void)
 {
-	nf_conntrack_helpers_unregister(irc_ptr, ports_c);
+	nf_conntrack_helper_unregister(irc_ptr);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 89d1cf7d6512..caa2b101fa9e 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -21,7 +21,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 
 #define HELPER_NAME	"netbios-ns"
-#define NMBD_PORT	137
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
@@ -54,7 +53,6 @@ static int __init nf_conntrack_netbios_ns_init(void)
 	exp_policy.timeout = timeout;
 
 	nf_ct_helper_init(&helper, AF_INET, IPPROTO_UDP, HELPER_NAME,
-			  NMBD_PORT, NMBD_PORT, NMBD_PORT,
 			  &exp_policy, 0, netbios_ns_help, NULL, THIS_MODULE);
 
 	return nf_conntrack_helper_register(&helper, &helper_ptr);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 80fc14c87ddc..cbf32a3cb1f6 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -540,7 +540,7 @@ static int __init nf_conntrack_pptp_init(void)
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_pptp_master));
 
 	nf_ct_helper_init(&pptp, AF_INET, IPPROTO_TCP,
-			  "pptp", PPTP_CONTROL_PORT, PPTP_CONTROL_PORT, PPTP_CONTROL_PORT,
+			  "pptp",
 			  &pptp_exp_policy, 0, conntrack_pptp_help, NULL, THIS_MODULE);
 
 	pptp.destroy = gre_pptp_destroy_siblings;
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 39085acf7a71..a0658f69d78f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -34,11 +34,6 @@ MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS 8
-static u_int16_t ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-
 struct sane_request {
 	__be32 RPC_code;
 #define SANE_NET_START      7   /* RPC code */
@@ -169,8 +164,8 @@ static int help(struct sk_buff *skb,
 	return ret;
 }
 
-static struct nf_conntrack_helper sane[MAX_PORTS * 2] __read_mostly;
-static struct nf_conntrack_helper *sane_ptr[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper sane __read_mostly;
+static struct nf_conntrack_helper *sane_ptr __read_mostly;
 
 static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.max_expected	= 1,
@@ -179,32 +174,21 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 
 static void __exit nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(sane_ptr, ports_c * 2);
+	nf_conntrack_helper_unregister(sane_ptr);
 }
 
 static int __init nf_conntrack_sane_init(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_sane_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = SANE_PORT;
-
-	/* FIXME should be configurable whether IPv4 and IPv6 connections
-		 are tracked or not - YK */
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
-				  &sane_exp_policy, 0, help, NULL,
-				  THIS_MODULE);
-		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
-				  &sane_exp_policy, 0, help, NULL,
-				  THIS_MODULE);
-	}
+	nf_ct_helper_init(&sane, NFPROTO_UNSPEC, IPPROTO_TCP,
+			  HELPER_NAME,
+			  &sane_exp_policy, 0, help, NULL,
+			  THIS_MODULE);
 
-	ret = nf_conntrack_helpers_register(sane, ports_c * 2, sane_ptr);
+	ret = nf_conntrack_helper_register(&sane, &sane_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5ec3a4a4bbd7..d0b85b8ad1e6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -35,12 +35,6 @@ MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS	8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of SIP servers");
-
 static unsigned int sip_timeout __read_mostly = SIP_TIMEOUT;
 module_param(sip_timeout, uint, 0600);
 MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
@@ -1764,8 +1758,8 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 	return process_sip_msg(skb, ct, protoff, dataoff, &dptr, &datalen);
 }
 
-static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;
-static struct nf_conntrack_helper *sip_ptr[MAX_PORTS * 4] __read_mostly;
+static struct nf_conntrack_helper sip[2] __read_mostly;
+static struct nf_conntrack_helper *sip_ptr[2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
 	[SIP_EXPECT_SIGNALLING] = {
@@ -1792,38 +1786,25 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 
 static void __exit nf_conntrack_sip_fini(void)
 {
-	nf_conntrack_helpers_unregister(sip_ptr, ports_c * 4);
+	nf_conntrack_helpers_unregister(sip_ptr, 2);
 }
 
 static int __init nf_conntrack_sip_init(void)
 {
-	int i, ret;
+	int ret;
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_sip_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = SIP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
-				  NULL, THIS_MODULE);
-	}
+	nf_ct_helper_init(&sip[0], NFPROTO_UNSPEC, IPPROTO_UDP,
+			  HELPER_NAME,
+			  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
+			  NULL, THIS_MODULE);
+	nf_ct_helper_init(&sip[1], NFPROTO_UNSPEC, IPPROTO_TCP,
+			  HELPER_NAME,
+			  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
+			  NULL, THIS_MODULE);
 
-	ret = nf_conntrack_helpers_register(sip, ports_c * 4, sip_ptr);
+	ret = nf_conntrack_helpers_register(sip, 2, sip_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index b6fce5703fce..109986d5d55e 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -14,8 +14,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_snmp.h>
 
-#define SNMP_PORT	161
-
 MODULE_AUTHOR("Jiri Olsa <jolsa@redhat.com>");
 MODULE_DESCRIPTION("SNMP service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
@@ -55,7 +53,7 @@ static int __init nf_conntrack_snmp_init(void)
 	exp_policy.timeout = timeout;
 
 	nf_ct_helper_init(&helper, AF_INET, IPPROTO_UDP,
-			  "snmp", SNMP_PORT, SNMP_PORT, SNMP_PORT,
+			  "snmp",
 			  &exp_policy, 0, snmp_conntrack_help, NULL,
 			  THIS_MODULE);
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 4393c435aa35..a69559edf9b3 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -26,12 +26,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS 8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
-
 nf_nat_tftp_hook_fn __rcu *nf_nat_tftp_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
 
@@ -95,8 +89,8 @@ static int tftp_help(struct sk_buff *skb,
 	return ret;
 }
 
-static struct nf_conntrack_helper tftp[MAX_PORTS * 2] __read_mostly;
-static struct nf_conntrack_helper *tftp_ptr[MAX_PORTS * 2] __read_mostly;
+static struct nf_conntrack_helper tftp __read_mostly;
+static struct nf_conntrack_helper *tftp_ptr __read_mostly;
 
 static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.max_expected	= 1,
@@ -105,30 +99,21 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 
 static void __exit nf_conntrack_tftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(tftp_ptr, ports_c * 2);
+	nf_conntrack_helper_unregister(tftp_ptr);
 }
 
 static int __init nf_conntrack_tftp_init(void)
 {
-	int i, ret;
+	int ret;
 
 	NF_CT_HELPER_BUILD_BUG_ON(0);
 
-	if (ports_c == 0)
-		ports[ports_c++] = TFTP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP,
-				  HELPER_NAME, TFTP_PORT, ports[i], i,
-				  &tftp_exp_policy, 0, tftp_help, NULL,
-				  THIS_MODULE);
-		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP,
-				  HELPER_NAME, TFTP_PORT, ports[i], i,
-				  &tftp_exp_policy, 0, tftp_help, NULL,
-				  THIS_MODULE);
-	}
+	nf_ct_helper_init(&tftp, NFPROTO_UNSPEC, IPPROTO_UDP,
+			  HELPER_NAME,
+			  &tftp_exp_policy, 0, tftp_help, NULL,
+			  THIS_MODULE);
 
-	ret = nf_conntrack_helpers_register(tftp, ports_c * 2, tftp_ptr);
+	ret = nf_conntrack_helper_register(&tftp, &tftp_ptr);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
-- 
2.53.0

