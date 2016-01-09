From: fgao@ikuai8.com
Subject: [PATCH 2/3] netfilter: nf_ct_helper: Add nf_conntrack_helpers_register()
Date: Sat,  9 Jan 2016 23:03:42 +0800
Message-ID: <1452351822-13637-1-git-send-email-fgao@ikuai8.com>
Cc: fgao@ikuai8.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:50075 "EHLO smtpbgau1.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbcAIPDx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jan 2016 10:03:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

This patch adds nf_conntrack_helpers_register() and
nf_conntrack_helpers_unregister() to consolidate the helper registration
code.

This patch also fixes a crash via "insmod nf_conntrack_ftp.ko ports=76,76".
This happens because the code tries to unregister the helper which was not
actually registered successfully.
Now add new function nf_conntrack_helpers_register to fix this bug.
It would unregister the right helpers automatically if someone fails.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  5 ++++
 net/netfilter/nf_conntrack_ftp.c            | 33 +++++----------------
 net/netfilter/nf_conntrack_helper.c         | 28 ++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            | 22 ++++++--------
 net/netfilter/nf_conntrack_sane.c           | 32 +++++---------------
 net/netfilter/nf_conntrack_sip.c            | 46 ++++++-----------------------
 net/netfilter/nf_conntrack_tftp.c           | 28 +++++-------------
 7 files changed, 74 insertions(+), 120 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index b5e2d7d..8c0c08f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -73,6 +73,11 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
+				unsigned int);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+				unsigned int);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper *helper,
 					  gfp_t gfp);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 80928c6..02fefb2 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -582,18 +582,7 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	int i, j;
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			if (ftp[i][j].me == NULL)
-				continue;
-
-			pr_debug("unregistering helper for pf: %d port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&ftp[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&ftp[0][0], ports_c * 2);
 	kfree(ftp_buffer);
 }
 
@@ -615,24 +604,16 @@ static int __init nf_conntrack_ftp_init(void)
 				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
 				  sizeof(struct nf_ct_ftp_master), help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&ftp[i][0]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %d port: %d\n",
-			       ftp[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_ftp_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP, "ftp",
 				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
 				  sizeof(struct nf_ct_ftp_master), help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&ftp[i][1]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %d port: %d\n",
-			       ftp[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_ftp_fini();
-			return ret;
-		}
+	}
+	ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
+	if (ret < 0) {
+		pr_err("failed to register helpers\n");
+		kfree(ftp_buffer);
+		return ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index dddfefc..42e7e15 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -486,6 +486,34 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_init);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *helper,
+				  unsigned int n)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < n; i++) {
+		err = nf_conntrack_helper_register(&helper[i]);
+		if (err < 0)
+			goto err;
+	}
+
+	return err;
+err:
+	if (i > 0)
+		nf_conntrack_helpers_unregister(helper, i);
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_register);
+
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
+				     unsigned int n)
+{
+	while (n-- > 0)
+		nf_conntrack_helper_unregister(&helper[n]);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
+
 static struct nf_ct_ext_type helper_extend __read_mostly = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index bc1a0dd..2a403db 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -232,8 +232,6 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
 static struct nf_conntrack_expect_policy irc_exp_policy;
 
-static void nf_conntrack_irc_fini(void);
-
 static int __init nf_conntrack_irc_init(void)
 {
 	int i, ret;
@@ -258,14 +256,15 @@ static int __init nf_conntrack_irc_init(void)
 		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
 				  IRC_PORT, ports[i], &irc_exp_policy, 0, 0,
 				  help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&irc[i]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       irc[i].tuple.src.l3num, ports[i]);
-			nf_conntrack_irc_fini();
-			return ret;
-		}
 	}
+
+	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	if (ret < 0) {
+		pr_err("failed to register helpers\n");
+		kfree(irc_buffer);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -273,10 +272,7 @@ static int __init nf_conntrack_irc_init(void)
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
index d005b14..c93bf8e 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -176,16 +176,7 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++) {
-			pr_debug("unregistering helper for pf: %d port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&sane[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(&sane[0][0], ports_c * 2);
 	kfree(sane_buffer);
 }
 
@@ -207,24 +198,17 @@ static int __init nf_conntrack_sane_init(void)
 				  SANE_PORT, ports[i], &sane_exp_policy, 0,
 				  sizeof(struct nf_ct_sane_master), help, NULL,
 				  THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sane[i][0]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %d port: %d\n",
-			       sane[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_sane_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sane[i][1], AF_INET6, IPPROTO_TCP, "sane",
 				  SANE_PORT, ports[i], &sane_exp_policy, 0,
 				  sizeof(struct nf_ct_sane_master), help, NULL,
 				  THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sane[i][1]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %d port: %d\n",
-			       sane[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_sane_fini();
-			return ret;
-		}
+	}
+
+	ret = nf_conntrack_helpers_register(&sane[0][0], ports_c * 2);
+	if (ret < 0) {
+		pr_err("failed to register helpers\n");
+		kfree(sane_buffer);
+		return ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5951427..c53be45 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1616,15 +1616,8 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 
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
@@ -1642,49 +1635,28 @@ static int __init nf_conntrack_sip_init(void)
 				  SIP_EXPECT_MAX,
 				  sizeof(struct nf_ct_sip_master), sip_help_udp,
 				  NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][0]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       sip[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][1], AF_INET, IPPROTO_TCP, "sip",
 				  SIP_PORT, ports[i], &sip_exp_policy[0],
 				  SIP_EXPECT_MAX,
 				  sizeof(struct nf_ct_sip_master), sip_help_tcp,
 				  NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][1]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       sip[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][2], AF_INET6, IPPROTO_UDP, "sip",
 				  SIP_PORT, ports[i], &sip_exp_policy[0],
 				  SIP_EXPECT_MAX,
 				  sizeof(struct nf_ct_sip_master), sip_help_udp,
 				  NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][2]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       sip[i][2].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&sip[i][3], AF_INET6, IPPROTO_TCP, "sip",
 				  SIP_PORT, ports[i], &sip_exp_policy[0],
 				  SIP_EXPECT_MAX,
 				  sizeof(struct nf_ct_sip_master), sip_help_tcp,
 				  NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&sip[i][3]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       sip[i][3].tuple.src.l3num, ports[i]);
-			nf_conntrack_sip_fini();
-			return ret;
-		}
+	}
+
+	ret = nf_conntrack_helpers_register(&sip[0][0],
+					    ports_c * ARRAY_SIZE(sip[0]));
+	if (ret < 0) {
+		pr_err("failed to register helpers\n");
+		return ret;
 	}
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 25776d0..d87c312 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -106,12 +106,7 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 
 static void nf_conntrack_tftp_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++)
-			nf_conntrack_helper_unregister(&tftp[i][j]);
-	}
+	nf_conntrack_helpers_unregister(&tftp[0][0], ports_c * 2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -127,24 +122,17 @@ static int __init nf_conntrack_tftp_init(void)
 		nf_ct_helper_init(&tftp[i][0], AF_INET, IPPROTO_UDP, "tftp",
 				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
 				  tftp_help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&tftp[i][0]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       tftp[i][0].tuple.src.l3num, ports[i]);
-			nf_conntrack_tftp_fini();
-			return ret;
-		}
 		nf_ct_helper_init(&tftp[i][1], AF_INET6, IPPROTO_UDP, "tftp",
 				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
 				  tftp_help, NULL, THIS_MODULE);
-		ret = nf_conntrack_helper_register(&tftp[i][1]);
-		if (ret < 0) {
-			pr_err("failed to register helper for pf: %u port: %u\n",
-			       tftp[i][1].tuple.src.l3num, ports[i]);
-			nf_conntrack_tftp_fini();
-			return ret;
-		}
 	}
+
+	ret = nf_conntrack_helpers_register(&tftp[0][0], ports_c * 2);
+	if (ret < 0) {
+		pr_err("failed to register helpers\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
1.9.1



