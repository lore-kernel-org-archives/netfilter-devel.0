From: Gao <fgao@ikuai8.com>
Subject: [PATCH 2/2] netfilter: Add nf_conntrack_helpers_register to fix one panic
Date: Sun, 22 Nov 2015 15:28:37 +0800
Message-ID: <1448177317-6887-1-git-send-email-fgao@ikuai8.com>
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:45126 "EHLO smtpbg202.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbbKZPoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 10:44:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When execute "insmod nf_conntrack_ftp.ko ports=76,76", the kernel crashes
immediately.Because the old codes try to unregister the helper which is
not registered successfully.
Now add new function nf_conntrack_helpers_register to fix this bug.
It would unregister the right helpers automatically if someone fails.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  5 +++
 net/netfilter/nf_conntrack_ftp.c            | 37 +++++----------------
 net/netfilter/nf_conntrack_helper.c         | 29 +++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            | 21 ++++++------
 net/netfilter/nf_conntrack_sane.c           | 35 +++++---------------
 net/netfilter/nf_conntrack_sip.c            | 50 ++++++-----------------------
 net/netfilter/nf_conntrack_tftp.c           | 30 +++++------------
 7 files changed, 76 insertions(+), 131 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 0c49c78..b3a61fa 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -77,6 +77,11 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
+		unsigned int);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+		unsigned int);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper *helper,
 					  gfp_t gfp);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index fc01c24..ecc51e6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -580,19 +580,7 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	int i, j;
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			if (ftp[i][j].me == NULL)
-				continue;
-
-			pr_debug("nf_ct_ftp: unregistering helper for pf: %d "
-				 "port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&ftp[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&ftp[0][0], ports_c * 2);
 	kfree(ftp_buffer);
 }
 
@@ -614,26 +602,17 @@ static int __init nf_conntrack_ftp_init(void)
 			"ftp", FTP_PORT, ports[i],
 			&ftp_exp_policy, 0, sizeof(struct nf_ct_ftp_master),
 			help, nf_ct_ftp_from_nlattr, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&ftp[i][0]);
-		if (ret) {
-			pr_err("nf_ct_ftp: failed to register"
-				" helper for pf: %d port: %d\n",
-				ftp[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_ftp_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP,
 			"ftp", FTP_PORT, ports[i],
 			&ftp_exp_policy, 0, sizeof(struct nf_ct_ftp_master),
 			help, nf_ct_ftp_from_nlattr, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&ftp[i][1]);
-		if (ret) {
-			pr_err("nf_ct_ftp: failed to register"
-				" helper for pf: %d port: %d\n",
-				ftp[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_ftp_fini();
-			return ret;
-		}
+	}
+
+	ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_ftp: failed to register helpers\n");
+		kfree(ftp_buffer);
+		return ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c5e649c..5ab040d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -491,6 +491,35 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_init);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *me,
+		unsigned int n)
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
+		unsigned int n)
+{
+	while (n-- > 0)
+		nf_conntrack_helper_unregister(&me[n]);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
+
 static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5135d9b..fa9b96c 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -257,15 +257,15 @@ static int __init nf_conntrack_irc_init(void)
 			"irc", IRC_PORT, ports[i],
 			&irc_exp_policy, 0, 0,
 			help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&irc[i]);
-		if (ret) {
-			printk(KERN_ERR "nf_ct_irc: failed to register helper "
-			       "for pf: %u port: %u\n",
-			       irc[i].tuple.src.l3num, ports[i]);
-			nf_conntrack_irc_fini();
-			return ret;
-		}
 	}
+
+	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	if (ret) {
+		pr_err("nf_ct_irc: failed to register helpers\n");
+		kfree(irc_buffer);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -273,10 +273,7 @@ static int __init nf_conntrack_irc_init(void)
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
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 1ffaae2..c5e0cb7 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -174,17 +174,7 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			pr_debug("nf_ct_sane: unregistering helper for pf: %d "
-				 "port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&sane[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&sane[0][0], ports_c * 2);
 	kfree(sane_buffer);
 }
 
@@ -206,28 +196,19 @@ static int __init nf_conntrack_sane_init(void)
 			"sane", SANE_PORT, ports[i],
 			&sane_exp_policy, 0, sizeof(struct nf_ct_sane_master),
 			help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sane[i][0]);
-		if (ret) {
-			pr_err("nf_ct_sane: failed to "
-				"register helper for pf: %d port: %d\n",
-				sane[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_sane_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sane[i][1], AF_INET6, IPPROTO_TCP,
 			"sane", SANE_PORT, ports[i],
 			&sane_exp_policy, 0, sizeof(struct nf_ct_sane_master),
 			help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sane[i][1]);
-		if (ret) {
-			pr_err("nf_ct_sane: failed to "
-				"register helper for pf: %d port: %d\n",
-				sane[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_sane_fini();
-			return ret;
-		}
 	}
 
+	ret = nf_conntrack_helpers_register(&sane[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_sane: failed to register helpers\n");
+		kfree(sane_buffer);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 3ba9835..1b359aa 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1614,15 +1614,8 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 
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
+	nf_conntrack_helpers_unregister(&sip[0][0],
+					ports_c * ARRAY_SIZE(sip[0]));
 }
 
 static int __init nf_conntrack_sip_init(void)
@@ -1640,53 +1633,28 @@ static int __init nf_conntrack_sip_init(void)
 			&sip_exp_policy[0], SIP_EXPECT_MAX,
 			sizeof(struct nf_ct_sip_master),
 			sip_help_udp, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][0]);
-		if (ret) {
-			pr_err("nf_ct_sip: failed to register"
-				" helper for pf: %u port: %u\n",
-				sip[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][1], AF_INET, IPPROTO_TCP,
 			"sip", SIP_PORT, ports[i],
 			&sip_exp_policy[0], SIP_EXPECT_MAX,
 			sizeof(struct nf_ct_sip_master),
 			sip_help_tcp, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][1]);
-		if (ret) {
-			pr_err("nf_ct_sip: failed to register"
-				" helper for pf: %u port: %u\n",
-				sip[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][2], AF_INET6, IPPROTO_UDP,
 			"sip", SIP_PORT, ports[i],
 			&sip_exp_policy[0], SIP_EXPECT_MAX,
 			sizeof(struct nf_ct_sip_master),
 			sip_help_udp, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][2]);
-		if (ret) {
-			pr_err("nf_ct_sip: failed to register"
-				" helper for pf: %u port: %u\n",
-				sip[i][2].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][3], AF_INET6, IPPROTO_TCP,
 			"sip", SIP_PORT, ports[i],
 			&sip_exp_policy[0], SIP_EXPECT_MAX,
 			sizeof(struct nf_ct_sip_master),
 			sip_help_tcp, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][3]);
-		if (ret) {
-			pr_err("nf_ct_sip: failed to register"
-				" helper for pf: %u port: %u\n",
-				sip[i][3].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
+	}
+
+	ret = nf_conntrack_helpers_register(&sip[0][0],
+					ports_c * ARRAY_SIZE(sip[0]));
+	if (ret) {
+		pr_err("nf_ct_sip: failed to register helpers\n");
+		return ret;
 	}
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index b6d7903..c8f2423 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,12 +104,7 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 
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
@@ -126,27 +121,18 @@ static int __init nf_conntrack_tftp_init(void)
 			"tftp", TFTP_PORT, ports[i],
 			&tftp_exp_policy, 0, 0,
 			tftp_help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&tftp[i][0]);
-		if (ret) {
-			pr_err("nf_ct_tftp: failed to register"
-				" helper for pf: %u port: %u\n",
-				tftp[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_tftp_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&tftp[i][1], AF_INET6, IPPROTO_UDP,
 			"tftp", TFTP_PORT, ports[i],
 			&tftp_exp_policy, 0, 0,
 			tftp_help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&tftp[i][1]);
-		if (ret) {
-			pr_err("nf_ct_tftp: failed to register"
-				" helper for pf: %u port: %u\n",
-				tftp[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_tftp_fini();
-			return ret;
-		}
 	}
+
+	ret = nf_conntrack_helpers_register(&tftp[0][0], ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_tftp: failed to register helpers\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
1.9.1



