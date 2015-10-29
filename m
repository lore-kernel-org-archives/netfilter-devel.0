From: Feng Gao <gfree.wind@outlook.com>
Subject: [PATCH 2/2] netfilter: Fix one compile error and some warnings
Date: Thu, 29 Oct 2015 23:59:09 +0800
Message-ID: <BAY403-EAS15678F56E2C8951B1197C5095200@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s24.hotmail.com ([65.54.190.35]:54620 "EHLO
	BAY004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbbJ2P7l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 11:59:41 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nf_conntrack_sip.c was not compiled with last patch.
So I fail to find there was one compile error.
Now I fix it and some compile warnings.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h |    4 ++--
 net/netfilter/nf_conntrack_ftp.c            |    4 ++--
 net/netfilter/nf_conntrack_irc.c            |    4 ++--
 net/netfilter/nf_conntrack_sane.c           |    4 ++--
 net/netfilter/nf_conntrack_sip.c            |    4 ++--
 net/netfilter/nf_conntrack_tftp.c           |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h
b/include/net/netfilter/nf_conntrack_helper.h
index a6be9da..a54d87a 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -63,9 +63,9 @@ int nf_conntrack_helper_register(struct
nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
 int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
-								unsigned
int);
+				unsigned int);
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
-								unsigned
int);
+				unsigned int);
 
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper
*helper,
diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index 06bedf6..37d6816 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -580,7 +580,7 @@ static const struct nf_conntrack_expect_policy
ftp_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
+	nf_conntrack_helpers_unregister(&ftp[0][0], ports_c * 2);
 	kfree(ftp_buffer);
 }
 
@@ -615,7 +615,7 @@ static int __init nf_conntrack_ftp_init(void)
 		}
 	}
 
-	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
+	ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
 	if (ret) {
 		pr_err("nf_ct_ftp: failed to register helpers\n");
 		kfree(ftp_buffer);
diff --git a/net/netfilter/nf_conntrack_irc.c
b/net/netfilter/nf_conntrack_irc.c
index 7c27575..f570cb9 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -266,7 +266,7 @@ static int __init nf_conntrack_irc_init(void)
 			sprintf(irc[i].name, "irc-%u", i);
 	}
 
-	ret = nf_conntrack_helpers_register(irc, ports_c);
+	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
 	if (ret) {
 		pr_err("nf_ct_irc: failed to register helpers\n");
 		kfree(irc_buffer);
@@ -280,7 +280,7 @@ static int __init nf_conntrack_irc_init(void)
  * it is needed by the init function */
 static void nf_conntrack_irc_fini(void)
 {
-	nf_conntrack_helpers_unregister(irc, ports_c);
+	nf_conntrack_helpers_unregister(&irc[0], ports_c);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c
b/net/netfilter/nf_conntrack_sane.c
index 8fe6e8f..9f657bd 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -174,7 +174,7 @@ static const struct nf_conntrack_expect_policy
sane_exp_policy = {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(sane, ports_c * 2);
+	nf_conntrack_helpers_unregister(&sane[0][0], ports_c * 2);
 	kfree(sane_buffer);
 }
 
@@ -212,7 +212,7 @@ static int __init nf_conntrack_sane_init(void)
 		}
 	}
 
-	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
+	ret = nf_conntrack_helpers_register(&sane[0][0], ports_c * 2);
 	if (ret) {
 		pr_err("nf_ct_sane: failed to register helpers\n");
 		kfree(sane_buffer);
diff --git a/net/netfilter/nf_conntrack_sip.c
b/net/netfilter/nf_conntrack_sip.c
index 0606dc0..c67044d 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1614,7 +1614,7 @@ static const struct nf_conntrack_expect_policy
sip_exp_policy[SIP_EXPECT_MAX + 1
 
 static void nf_conntrack_sip_fini(void)
 {
-	nf_conntrack_helpers_unregister(sip, ports_c*ARRAY_SIZE(sip[0]);
+	nf_conntrack_helpers_unregister(&sip[0][0], ports_c *
ARRAY_SIZE(sip[0]));
 }
 
 static int __init nf_conntrack_sip_init(void)
@@ -1657,7 +1657,7 @@ static int __init nf_conntrack_sip_init(void)
 		}
 	}
 
-	ret = nf_conntrack_helpers_register(sip, ports_c *
ARRAY_SIZE(sip[0]));
+	ret = nf_conntrack_helpers_register(&sip[0][0], ports_c *
ARRAY_SIZE(sip[0]));
 	if (ret) {
 		pr_err("nf_ct_sip: failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_tftp.c
b/net/netfilter/nf_conntrack_tftp.c
index 0d3b7ad..317b305 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,7 +104,7 @@ static const struct nf_conntrack_expect_policy
tftp_exp_policy = {
 
 static void nf_conntrack_tftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(tftp, ports_c*2);
+	nf_conntrack_helpers_unregister(&tftp[0][0], ports_c*2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -133,7 +133,7 @@ static int __init nf_conntrack_tftp_init(void)
 		}
 	}
 
-	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
+	ret = nf_conntrack_helpers_register(&tftp[0][0], ports_c * 2);
 	if (ret) {
 		pr_err("nf_ct_tftp: failed to register helpers\n");
 		return ret;
