From: Feng Gao <gfree.wind@outlook.com>
Subject: [PATCH 1/1 V2] netfilter: Add nf_conntrack_helpers_register to fix one panic
Date: Sat, 31 Oct 2015 23:40:53 +0800
Message-ID: <BAY403-EAS27321B698171BF5F88C2EB0952E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s23.hotmail.com ([65.54.190.34]:51890 "EHLO
	BAY004-OMC1S23.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbbJaPk6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Oct 2015 11:40:58 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When execute "insmod nf_conntrack_ftp.ko ports=76,76", the kernel crashes
immediately.Because the old codes try to unregister the helper which is
not registered successfully.
Now add new function nf_conntrack_helpers_register to fix this bug.
It would unregister the right helpers automatically if someone fails.
And add another function nf_ct_helper_init to init the helper.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 38 +++++++++++++++
 net/netfilter/nf_conntrack_ftp.c            | 58 +++++++----------------
 net/netfilter/nf_conntrack_helper.c         | 29 ++++++++++++
 net/netfilter/nf_conntrack_irc.c            | 37 +++++----------
 net/netfilter/nf_conntrack_sane.c           | 55 +++++++---------------
 net/netfilter/nf_conntrack_sip.c            | 73
+++++++++++------------------
 net/netfilter/nf_conntrack_tftp.c           | 46 +++++++-----------
 7 files changed, 158 insertions(+), 180 deletions(-)
diff --git a/include/net/netfilter/nf_conntrack_helper.h
b/include/net/netfilter/nf_conntrack_helper.h
index 6cf614bc..49841bb
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -59,9 +59,47 @@ struct nf_conntrack_helper
*nf_conntrack_helper_try_module_get(const char *name,
 							       u16 l3num,
 							       u8 protonum);
 
+static inline void nf_ct_helper_init(struct nf_conntrack_helper *helper,
+				u16 l3num,
+				u16 protonum,
+				const char *name,
+				u16 default_port,
+				u16 spec_port,
+				const struct nf_conntrack_expect_policy
*exp_pol,
+				u32 expect_class_max,
+				u32 data_len,
+				int (*help)(struct sk_buff *skb,
+					unsigned int protoff,
+					struct nf_conn *ct,
+					enum ip_conntrack_info
conntrackinfo),
+				int (*from_nlattr)(struct nlattr *attr,
+					struct nf_conn *ct),
+				struct module *module)
+{
+	helper->tuple.src.l3num = l3num;
+	helper->tuple.dst.protonum = protonum;
+	helper->tuple.src.u.all = htons(spec_port);
+	helper->expect_policy = exp_pol;
+	helper->expect_class_max = expect_class_max;
+	helper->data_len = data_len;
+	helper->help = help;
+	helper->from_nlattr = from_nlattr;
+	helper->me = module;
+
+	if (spec_port == default_port)
+		snprintf(helper->name, sizeof(helper->name), "%s", name);
+	else
+		snprintf(helper->name, sizeof(helper->name), "%s-%u", name,
spec_port);
+}
+
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
+				unsigned int);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+				unsigned int);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper
*helper,
 					  gfp_t gfp);
diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index b666959..db8b21b
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -580,25 +580,13 @@ static const struct nf_conntrack_expect_policy
ftp_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	int i, j;
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			if (ftp[i][j].me == NULL)
-				continue;
-
-			pr_debug("nf_ct_ftp: unregistering helper for pf: %d
"
-				 "port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&ftp[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&ftp[0][0], ports_c * 2);
 	kfree(ftp_buffer);
 }
 
 static int __init nf_conntrack_ftp_init(void)
 {
-	int i, j = -1, ret = 0;
+	int i, ret = 0;
 
 	ftp_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!ftp_buffer)
@@ -610,33 +598,21 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP
connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		ftp[i][0].tuple.src.l3num = PF_INET;
-		ftp[i][1].tuple.src.l3num = PF_INET6;
-		for (j = 0; j < 2; j++) {
-			ftp[i][j].data_len = sizeof(struct
nf_ct_ftp_master);
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
-			pr_debug("nf_ct_ftp: registering helper for pf: %d "
-				 "port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			ret = nf_conntrack_helper_register(&ftp[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_ftp: failed to
register"
-				       " helper for pf: %d port: %d\n",
-					ftp[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_ftp_fini();
-				return ret;
-			}
-		}
+		nf_ct_helper_init(&ftp[i][0], AF_INET, IPPROTO_TCP, 
+			"ftp", FTP_PORT, ports[i],
+			&ftp_exp_policy, 0, sizeof(struct nf_ct_ftp_master),
+			help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+		nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP,
+			"ftp", FTP_PORT, ports[i],
+			&ftp_exp_policy, 0, sizeof(struct nf_ct_ftp_master),
+			help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+	}
+
+	ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_ftp: failed to register helpers\n");
+		kfree(ftp_buffer);
+		return ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c
b/net/netfilter/nf_conntrack_helper.c
index bd9d315..8412963
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,6 +456,35 @@ void nf_conntrack_helper_unregister(struct
nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *me,
+				unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; ++i) {
+		err = nf_conntrack_helper_register(&me[i]);
+		if (err)
+			goto err;
+	}
+
+	return err;
+
+err:
+	if (i > 0)
+		nf_conntrack_helpers_unregister(me, i);
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_register);
+
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *me,
+				unsigned int n)
+{
+	while (n-- > 0)
+		nf_conntrack_helper_unregister(&me[n]);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
+
 static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
diff --git a/net/netfilter/nf_conntrack_irc.c
b/net/netfilter/nf_conntrack_irc.c
index 0fd2976..197c214
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -253,27 +253,19 @@ static int __init nf_conntrack_irc_init(void)
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
-		ret = nf_conntrack_helper_register(&irc[i]);
-		if (ret) {
-			printk(KERN_ERR "nf_ct_irc: failed to register
helper "
-			       "for pf: %u port: %u\n",
-			       irc[i].tuple.src.l3num, ports[i]);
-			nf_conntrack_irc_fini();
-			return ret;
-		}
+		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP,
+			"irc", IRC_PORT, ports[i],
+			&irc_exp_policy, 0, 0,
+			help, NULL, THIS_MODULE);
+	}
+
+	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	if (ret) {
+		pr_err("nf_ct_irc: failed to register helpers\n");
+		kfree(irc_buffer);
+		return ret;
 	}
+
 	return 0;
 }
 
@@ -281,10 +273,7 @@ static int __init nf_conntrack_irc_init(void)
  * it is needed by the init function */
 static void nf_conntrack_irc_fini(void)
 {
-	int i;
-
-	for (i = 0; i < ports_c; i++)
-		nf_conntrack_helper_unregister(&irc[i]);
+	nf_conntrack_helpers_unregister(&irc[0], ports_c);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c
b/net/netfilter/nf_conntrack_sane.c
index 4a2134f..b6d1734
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -174,23 +174,13 @@ static const struct nf_conntrack_expect_policy
sane_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			pr_debug("nf_ct_sane: unregistering helper for pf:
%d "
-				 "port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&sane[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&sane[0][0], ports_c * 2);
 	kfree(sane_buffer);
 }
 
 static int __init nf_conntrack_sane_init(void)
 {
-	int i, j = -1, ret = 0;
+	int i, ret = 0;
 
 	sane_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!sane_buffer)
@@ -202,32 +192,21 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		sane[i][0].tuple.src.l3num = PF_INET;
-		sane[i][1].tuple.src.l3num = PF_INET6;
-		for (j = 0; j < 2; j++) {
-			sane[i][j].data_len = sizeof(struct
nf_ct_sane_master);
-			sane[i][j].tuple.src.u.tcp.port = htons(ports[i]);
-			sane[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			sane[i][j].expect_policy = &sane_exp_policy;
-			sane[i][j].me = THIS_MODULE;
-			sane[i][j].help = help;
-			if (ports[i] == SANE_PORT)
-				sprintf(sane[i][j].name, "sane");
-			else
-				sprintf(sane[i][j].name, "sane-%d",
ports[i]);
-
-			pr_debug("nf_ct_sane: registering helper for pf: %d
"
-				 "port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			ret = nf_conntrack_helper_register(&sane[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_sane: failed to "
-				       "register helper for pf: %d port:
%d\n",
-					sane[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_sane_fini();
-				return ret;
-			}
-		}
+		nf_ct_helper_init(&sane[i][0], AF_INET, IPPROTO_TCP, 
+			"sane", SANE_PORT, ports[i],
+			&sane_exp_policy, 0, sizeof(struct
nf_ct_sane_master),
+			help, NULL, THIS_MODULE);
+		nf_ct_helper_init(&sane[i][1], AF_INET6, IPPROTO_TCP,
+			"sane", SANE_PORT, ports[i],
+			&sane_exp_policy, 0, sizeof(struct
nf_ct_sane_master),
+			help, NULL, THIS_MODULE);
+	}
+
+	ret = nf_conntrack_helpers_register(&sane[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_sane: failed to register helpers\n");
+		kfree(sane_buffer);
+		return ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_sip.c
b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..5426635
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1614,20 +1614,12 @@ static const struct nf_conntrack_expect_policy
sip_exp_policy[SIP_EXPECT_MAX + 1
 
 static void nf_conntrack_sip_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < ARRAY_SIZE(sip[i]); j++) {
-			if (sip[i][j].me == NULL)
-				continue;
-			nf_conntrack_helper_unregister(&sip[i][j]);
-		}
-	}
+	nf_conntrack_helpers_unregister(&sip[0][0], ports_c *
ARRAY_SIZE(sip[0]));
 }
 
 static int __init nf_conntrack_sip_init(void)
 {
-	int i, j, ret;
+	int i, ret;
 
 	if (ports_c == 0)
 		ports[ports_c++] = SIP_PORT;
@@ -1635,43 +1627,32 @@ static int __init nf_conntrack_sip_init(void)
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
-			sip[i][j].data_len = sizeof(struct
nf_ct_sip_master);
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
+		nf_ct_helper_init(&sip[i][0], AF_INET, IPPROTO_UDP, 
+			"sip", SIP_PORT, ports[i],
+			&sip_exp_policy[0], SIP_EXPECT_MAX, 
+			sizeof(struct nf_ct_sip_master),
+			sip_help_udp, NULL, THIS_MODULE);
+		nf_ct_helper_init(&sip[i][1], AF_INET, IPPROTO_TCP,
+			"sip", SIP_PORT, ports[i],
+			&sip_exp_policy[0], SIP_EXPECT_MAX,
+			sizeof(struct nf_ct_sip_master),
+			sip_help_tcp, NULL, THIS_MODULE);
+		nf_ct_helper_init(&sip[i][2], AF_INET6, IPPROTO_UDP,
+			"sip", SIP_PORT, ports[i],
+			&sip_exp_policy[0], SIP_EXPECT_MAX, 
+			sizeof(struct nf_ct_sip_master),
+			sip_help_udp, NULL, THIS_MODULE);
+		nf_ct_helper_init(&sip[i][3], AF_INET6, IPPROTO_TCP,
+			"sip", SIP_PORT, ports[i],
+			&sip_exp_policy[0], SIP_EXPECT_MAX, 
+			sizeof(struct nf_ct_sip_master),
+			sip_help_tcp, NULL, THIS_MODULE);

+	}
 
-			ret = nf_conntrack_helper_register(&sip[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_sip: failed to
register"
-				       " helper for pf: %u port: %u\n",
-				       sip[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_sip_fini();
-				return ret;
-			}
-		}
+	ret = nf_conntrack_helpers_register(&sip[0][0], ports_c *
ARRAY_SIZE(sip[0]));
+	if (ret) {
+		pr_err("nf_ct_sip: failed to register helpers\n");
+		return ret;
 	}
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c
b/net/netfilter/nf_conntrack_tftp.c
index e68ab4f..a44dbb5
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,17 +104,12 @@ static const struct nf_conntrack_expect_policy
tftp_exp_policy = {
 
 static void nf_conntrack_tftp_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++)
-			nf_conntrack_helper_unregister(&tftp[i][j]);
-	}
+	nf_conntrack_helpers_unregister(&tftp[0][0], ports_c*2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
 {
-	int i, j, ret;
+	int i, ret;
 
 	if (ports_c == 0)
 		ports[ports_c++] = TFTP_PORT;
@@ -122,29 +117,20 @@ static int __init nf_conntrack_tftp_init(void)
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
-				printk(KERN_ERR "nf_ct_tftp: failed to
register"
-				       " helper for pf: %u port: %u\n",
-					tftp[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_tftp_fini();
-				return ret;
-			}
-		}
+		nf_ct_helper_init(&tftp[i][0], AF_INET, IPPROTO_UDP, 
+			"tftp", TFTP_PORT, ports[i],
+			&tftp_exp_policy, 0, 0,
+			tftp_help, NULL, THIS_MODULE);
+		nf_ct_helper_init(&tftp[i][1], AF_INET6, IPPROTO_UDP,
+			"tftp", TFTP_PORT, ports[i],
+			&tftp_exp_policy, 0, 0,
+			tftp_help, NULL, THIS_MODULE);
+	}
+
+	ret = nf_conntrack_helpers_register(&tftp[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_tftp: failed to register helpers\n");
+		return ret;
 	}
 	return 0;
 }
