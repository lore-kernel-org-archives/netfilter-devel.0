From: fgao@ikuai8.com
Subject: [PATCH 1/3] netfilter: nf_ct_helper: Add new function nf_ct_helper_init()
Date: Sat,  9 Jan 2016 23:03:14 +0800
Message-ID: <1452351794-13562-1-git-send-email-fgao@ikuai8.com>
Cc: fgao@ikuai8.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:56801 "EHLO smtpbg202.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbcAIPDb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jan 2016 10:03:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 11 ++++
 net/netfilter/nf_conntrack_ftp.c            | 47 ++++++++--------
 net/netfilter/nf_conntrack_helper.c         | 30 +++++++++++
 net/netfilter/nf_conntrack_irc.c            | 17 ++----
 net/netfilter/nf_conntrack_sane.c           | 46 ++++++++--------
 net/netfilter/nf_conntrack_sip.c            | 84 ++++++++++++++++-------------
 net/netfilter/nf_conntrack_tftp.c           | 42 +++++++--------
 7 files changed, 157 insertions(+), 120 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 6cf614bc..b5e2d7d 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -58,6 +58,17 @@ struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
 struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 							       u16 l3num,
 							       u8 protonum);
+void nf_ct_helper_init(struct nf_conntrack_helper *helper,
+		       u16 l3num, u16 protonum, const char *name,
+		       u16 default_port, u16 spec_port,
+		       const struct nf_conntrack_expect_policy *exp_pol,
+		       u32 expect_class_max, u32 data_len,
+		       int (*help)(struct sk_buff *skb, unsigned int protoff,
+				   struct nf_conn *ct,
+				   enum ip_conntrack_info ctinfo),
+		       int (*from_nlattr)(struct nlattr *attr,
+					  struct nf_conn *ct),
+		       struct module *module);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 883c691..80928c6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -599,7 +599,7 @@ static void nf_conntrack_ftp_fini(void)
 
 static int __init nf_conntrack_ftp_init(void)
 {
-	int i, j = -1, ret = 0;
+	int i, ret = 0;
 
 	ftp_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!ftp_buffer)
@@ -611,30 +611,27 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		ftp[i][0].tuple.src.l3num = PF_INET;
-		ftp[i][1].tuple.src.l3num = PF_INET6;
-		for (j = 0; j < 2; j++) {
-			ftp[i][j].data_len = sizeof(struct nf_ct_ftp_master);
-			ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
-			ftp[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			ftp[i][j].expect_policy = &ftp_exp_policy;
-			ftp[i][j].me = THIS_MODULE;
-			ftp[i][j].help = help;
-			ftp[i][j].from_nlattr = nf_ct_ftp_from_nlattr;
-			if (ports[i] == FTP_PORT)
-				sprintf(ftp[i][j].name, "ftp");
-			else
-				sprintf(ftp[i][j].name, "ftp-%d", ports[i]);
-
-			pr_debug("registering helper for pf: %d port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			ret = nf_conntrack_helper_register(&ftp[i][j]);
-			if (ret) {
-				pr_err("failed to register helper for pf: %d port: %d\n",
-				       ftp[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_ftp_fini();
-				return ret;
-			}
+		nf_ct_helper_init(&ftp[i][0], AF_INET, IPPROTO_TCP, "ftp",
+				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
+				  sizeof(struct nf_ct_ftp_master), help,
+				  nf_ct_ftp_from_nlattr, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&ftp[i][0]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %d port: %d\n",
+			       ftp[i][0].tuple.src.l3num, ports[i]);
+			nf_conntrack_ftp_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP, "ftp",
+				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
+				  sizeof(struct nf_ct_ftp_master), help,
+				  nf_ct_ftp_from_nlattr, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&ftp[i][1]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %d port: %d\n",
+			       ftp[i][1].tuple.src.l3num, ports[i]);
+			nf_conntrack_ftp_fini();
+			return ret;
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index bd9d315..dddfefc 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,6 +456,36 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
+void nf_ct_helper_init(struct nf_conntrack_helper *helper,
+		       u16 l3num, u16 protonum, const char *name,
+		       u16 default_port, u16 spec_port,
+		       const struct nf_conntrack_expect_policy *exp_pol,
+		       u32 expect_class_max, u32 data_len,
+		       int (*help)(struct sk_buff *skb, unsigned int protoff,
+				   struct nf_conn *ct,
+				   enum ip_conntrack_info ctinfo),
+		       int (*from_nlattr)(struct nlattr *attr,
+					  struct nf_conn *ct),
+		       struct module *module)
+{
+	helper->tuple.src.l3num		= l3num;
+	helper->tuple.dst.protonum	= protonum;
+	helper->tuple.src.u.all		= htons(spec_port);
+	helper->expect_policy		= exp_pol;
+	helper->expect_class_max	= expect_class_max;
+	helper->data_len		= data_len;
+	helper->help			= help;
+	helper->from_nlattr		= from_nlattr;
+	helper->me			= module;
+
+	if (spec_port == default_port)
+		snprintf(helper->name, sizeof(helper->name), "%s", name);
+	else
+		snprintf(helper->name, sizeof(helper->name), "%s-%u", name,
+			 spec_port);
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_init);
+
 static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 8b6da27..bc1a0dd 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -255,20 +255,11 @@ static int __init nf_conntrack_irc_init(void)
 		ports[ports_c++] = IRC_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		irc[i].tuple.src.l3num = AF_INET;
-		irc[i].tuple.src.u.tcp.port = htons(ports[i]);
-		irc[i].tuple.dst.protonum = IPPROTO_TCP;
-		irc[i].expect_policy = &irc_exp_policy;
-		irc[i].me = THIS_MODULE;
-		irc[i].help = help;
-
-		if (ports[i] == IRC_PORT)
-			sprintf(irc[i].name, "irc");
-		else
-			sprintf(irc[i].name, "irc-%u", i);
-
+		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
+				  IRC_PORT, ports[i], &irc_exp_policy, 0, 0,
+				  help, NULL, THIS_MODULE);
 		ret = nf_conntrack_helper_register(&irc[i]);
-		if (ret) {
+		if (ret < 0) {
 			pr_err("failed to register helper for pf: %u port: %u\n",
 			       irc[i].tuple.src.l3num, ports[i]);
 			nf_conntrack_irc_fini();
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 7523a57..d005b14 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -191,7 +191,7 @@ static void nf_conntrack_sane_fini(void)
 
 static int __init nf_conntrack_sane_init(void)
 {
-	int i, j = -1, ret = 0;
+	int i, ret = 0;
 
 	sane_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!sane_buffer)
@@ -203,29 +203,27 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		sane[i][0].tuple.src.l3num = PF_INET;
-		sane[i][1].tuple.src.l3num = PF_INET6;
-		for (j = 0; j < 2; j++) {
-			sane[i][j].data_len = sizeof(struct nf_ct_sane_master);
-			sane[i][j].tuple.src.u.tcp.port = htons(ports[i]);
-			sane[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			sane[i][j].expect_policy = &sane_exp_policy;
-			sane[i][j].me = THIS_MODULE;
-			sane[i][j].help = help;
-			if (ports[i] == SANE_PORT)
-				sprintf(sane[i][j].name, "sane");
-			else
-				sprintf(sane[i][j].name, "sane-%d", ports[i]);
-
-			pr_debug("registering helper for pf: %d port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			ret = nf_conntrack_helper_register(&sane[i][j]);
-			if (ret) {
-				pr_err("failed to register helper for pf: %d port: %d\n",
-				       sane[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_sane_fini();
-				return ret;
-			}
+		nf_ct_helper_init(&sane[i][0], AF_INET, IPPROTO_TCP, "sane",
+				  SANE_PORT, ports[i], &sane_exp_policy, 0,
+				  sizeof(struct nf_ct_sane_master), help, NULL,
+				  THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sane[i][0]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %d port: %d\n",
+			       sane[i][0].tuple.src.l3num, ports[i]);
+			nf_conntrack_sane_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&sane[i][1], AF_INET6, IPPROTO_TCP, "sane",
+				  SANE_PORT, ports[i], &sane_exp_policy, 0,
+				  sizeof(struct nf_ct_sane_master), help, NULL,
+				  THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sane[i][1]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %d port: %d\n",
+			       sane[i][1].tuple.src.l3num, ports[i]);
+			nf_conntrack_sane_fini();
+			return ret;
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 3e06402..5951427 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1629,7 +1629,7 @@ static void nf_conntrack_sip_fini(void)
 
 static int __init nf_conntrack_sip_init(void)
 {
-	int i, j, ret;
+	int i, ret;
 
 	if (ports_c == 0)
 		ports[ports_c++] = SIP_PORT;
@@ -1637,41 +1637,53 @@ static int __init nf_conntrack_sip_init(void)
 	for (i = 0; i < ports_c; i++) {
 		memset(&sip[i], 0, sizeof(sip[i]));
 
-		sip[i][0].tuple.src.l3num = AF_INET;
-		sip[i][0].tuple.dst.protonum = IPPROTO_UDP;
-		sip[i][0].help = sip_help_udp;
-		sip[i][1].tuple.src.l3num = AF_INET;
-		sip[i][1].tuple.dst.protonum = IPPROTO_TCP;
-		sip[i][1].help = sip_help_tcp;
-
-		sip[i][2].tuple.src.l3num = AF_INET6;
-		sip[i][2].tuple.dst.protonum = IPPROTO_UDP;
-		sip[i][2].help = sip_help_udp;
-		sip[i][3].tuple.src.l3num = AF_INET6;
-		sip[i][3].tuple.dst.protonum = IPPROTO_TCP;
-		sip[i][3].help = sip_help_tcp;
-
-		for (j = 0; j < ARRAY_SIZE(sip[i]); j++) {
-			sip[i][j].data_len = sizeof(struct nf_ct_sip_master);
-			sip[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			sip[i][j].expect_policy = sip_exp_policy;
-			sip[i][j].expect_class_max = SIP_EXPECT_MAX;
-			sip[i][j].me = THIS_MODULE;
-
-			if (ports[i] == SIP_PORT)
-				sprintf(sip[i][j].name, "sip");
-			else
-				sprintf(sip[i][j].name, "sip-%u", i);
-
-			pr_debug("port #%u: %u\n", i, ports[i]);
-
-			ret = nf_conntrack_helper_register(&sip[i][j]);
-			if (ret) {
-				pr_err("failed to register helper for pf: %u port: %u\n",
-				       sip[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_sip_fini();
-				return ret;
-			}
+		nf_ct_helper_init(&sip[i][0], AF_INET, IPPROTO_UDP, "sip",
+				  SIP_PORT, ports[i], &sip_exp_policy[0],
+				  SIP_EXPECT_MAX,
+				  sizeof(struct nf_ct_sip_master), sip_help_udp,
+				  NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sip[i][0]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       sip[i][0].tuple.src.l3num, ports[i]);
+			nf_conntrack_sip_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&sip[i][1], AF_INET, IPPROTO_TCP, "sip",
+				  SIP_PORT, ports[i], &sip_exp_policy[0],
+				  SIP_EXPECT_MAX,
+				  sizeof(struct nf_ct_sip_master), sip_help_tcp,
+				  NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sip[i][1]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       sip[i][1].tuple.src.l3num, ports[i]);
+			nf_conntrack_sip_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&sip[i][2], AF_INET6, IPPROTO_UDP, "sip",
+				  SIP_PORT, ports[i], &sip_exp_policy[0],
+				  SIP_EXPECT_MAX,
+				  sizeof(struct nf_ct_sip_master), sip_help_udp,
+				  NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sip[i][2]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       sip[i][2].tuple.src.l3num, ports[i]);
+			nf_conntrack_sip_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&sip[i][3], AF_INET6, IPPROTO_TCP, "sip",
+				  SIP_PORT, ports[i], &sip_exp_policy[0],
+				  SIP_EXPECT_MAX,
+				  sizeof(struct nf_ct_sip_master), sip_help_tcp,
+				  NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&sip[i][3]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       sip[i][3].tuple.src.l3num, ports[i]);
+			nf_conntrack_sip_fini();
+			return ret;
 		}
 	}
 	return 0;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 36f9640..25776d0 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -116,7 +116,7 @@ static void nf_conntrack_tftp_fini(void)
 
 static int __init nf_conntrack_tftp_init(void)
 {
-	int i, j, ret;
+	int i, ret;
 
 	if (ports_c == 0)
 		ports[ports_c++] = TFTP_PORT;
@@ -124,27 +124,25 @@ static int __init nf_conntrack_tftp_init(void)
 	for (i = 0; i < ports_c; i++) {
 		memset(&tftp[i], 0, sizeof(tftp[i]));
 
-		tftp[i][0].tuple.src.l3num = AF_INET;
-		tftp[i][1].tuple.src.l3num = AF_INET6;
-		for (j = 0; j < 2; j++) {
-			tftp[i][j].tuple.dst.protonum = IPPROTO_UDP;
-			tftp[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			tftp[i][j].expect_policy = &tftp_exp_policy;
-			tftp[i][j].me = THIS_MODULE;
-			tftp[i][j].help = tftp_help;
-
-			if (ports[i] == TFTP_PORT)
-				sprintf(tftp[i][j].name, "tftp");
-			else
-				sprintf(tftp[i][j].name, "tftp-%u", i);
-
-			ret = nf_conntrack_helper_register(&tftp[i][j]);
-			if (ret) {
-				pr_err("failed to register helper for pf: %u port: %u\n",
-				       tftp[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_tftp_fini();
-				return ret;
-			}
+		nf_ct_helper_init(&tftp[i][0], AF_INET, IPPROTO_UDP, "tftp",
+				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
+				  tftp_help, NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&tftp[i][0]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       tftp[i][0].tuple.src.l3num, ports[i]);
+			nf_conntrack_tftp_fini();
+			return ret;
+		}
+		nf_ct_helper_init(&tftp[i][1], AF_INET6, IPPROTO_UDP, "tftp",
+				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
+				  tftp_help, NULL, THIS_MODULE);
+		ret = nf_conntrack_helper_register(&tftp[i][1]);
+		if (ret < 0) {
+			pr_err("failed to register helper for pf: %u port: %u\n",
+			       tftp[i][1].tuple.src.l3num, ports[i]);
+			nf_conntrack_tftp_fini();
+			return ret;
 		}
 	}
 	return 0;
-- 
1.9.1



