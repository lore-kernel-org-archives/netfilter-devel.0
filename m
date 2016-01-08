From: Gao Feng <fgao@ikuai8.com>
Subject: [PATCH 4/4,nf-next] netfilter: nf_ct_helper: Use unidimensional helper array instead of bidimensional ones
Date: Fri,  8 Jan 2016 13:07:51 +0800
Message-ID: <1452229671-10010-1-git-send-email-fgao@ikuai8.com>
Cc: fgao@ikuai8.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:10193 "EHLO smtpbg65.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbcAHFIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 00:08:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_ftp.c  | 10 +++++-----
 net/netfilter/nf_conntrack_sane.c | 10 +++++-----
 net/netfilter/nf_conntrack_tftp.c | 12 +++++-------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 02fefb2..efeca6e 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -572,7 +572,7 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	return 0;
 }
 
-static struct nf_conntrack_helper ftp[MAX_PORTS][2] __read_mostly;
+static struct nf_conntrack_helper ftp[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.max_expected	= 1,
@@ -582,7 +582,7 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(&ftp[0][0], ports_c * 2);
+	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
 	kfree(ftp_buffer);
 }
 
@@ -600,16 +600,16 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[i][0], AF_INET, IPPROTO_TCP, "ftp",
+		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP, "ftp",
 				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
 				  sizeof(struct nf_ct_ftp_master), help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP, "ftp",
+		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP, "ftp",
 				  FTP_PORT, ports[i], &ftp_exp_policy, 0,
 				  sizeof(struct nf_ct_ftp_master), help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
 	}
-	ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
+	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		kfree(ftp_buffer);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index c93bf8e..536c208 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -166,7 +166,7 @@ out:
 	return ret;
 }
 
-static struct nf_conntrack_helper sane[MAX_PORTS][2] __read_mostly;
+static struct nf_conntrack_helper sane[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.max_expected	= 1,
@@ -176,7 +176,7 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(&sane[0][0], ports_c * 2);
+	nf_conntrack_helpers_unregister(sane, ports_c * 2);
 	kfree(sane_buffer);
 }
 
@@ -194,17 +194,17 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[i][0], AF_INET, IPPROTO_TCP, "sane",
+		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP, "sane",
 				  SANE_PORT, ports[i], &sane_exp_policy, 0,
 				  sizeof(struct nf_ct_sane_master), help, NULL,
 				  THIS_MODULE);
-		nf_ct_helper_init(&sane[i][1], AF_INET6, IPPROTO_TCP, "sane",
+		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP, "sane",
 				  SANE_PORT, ports[i], &sane_exp_policy, 0,
 				  sizeof(struct nf_ct_sane_master), help, NULL,
 				  THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(&sane[0][0], ports_c * 2);
+	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		kfree(sane_buffer);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index d87c312..d93a61c 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -97,7 +97,7 @@ static int tftp_help(struct sk_buff *skb,
 	return ret;
 }
 
-static struct nf_conntrack_helper tftp[MAX_PORTS][2] __read_mostly;
+static struct nf_conntrack_helper tftp[MAX_PORTS * 2] __read_mostly;
 
 static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.max_expected	= 1,
@@ -106,7 +106,7 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 
 static void nf_conntrack_tftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(&tftp[0][0], ports_c * 2);
+	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -117,17 +117,15 @@ static int __init nf_conntrack_tftp_init(void)
 		ports[ports_c++] = TFTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		memset(&tftp[i], 0, sizeof(tftp[i]));
-
-		nf_ct_helper_init(&tftp[i][0], AF_INET, IPPROTO_UDP, "tftp",
+		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP, "tftp",
 				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
 				  tftp_help, NULL, THIS_MODULE);
-		nf_ct_helper_init(&tftp[i][1], AF_INET6, IPPROTO_UDP, "tftp",
+		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP, "tftp",
 				  TFTP_PORT, ports[i], &tftp_exp_policy, 0, 0,
 				  tftp_help, NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(&tftp[0][0], ports_c * 2);
+	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
-- 
1.9.1



