From: Feng Gao <gfree.wind@outlook.com>
Subject: [PATCH 1/1] netfilter: Add nf_conntrack_helpers_register to fix one kernel panic
Date: Wed, 21 Oct 2015 23:22:41 +0800
Message-ID: <BAY403-EAS1574128879F6523343D6F5895380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s28.hotmail.com ([65.54.190.39]:52220 "EHLO
	BAY004-OMC1S28.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbbJUPWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Oct 2015 11:22:43 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When execute "insmod nf_conntrack_ftp.ko ports=76,76", the kernel crashes
immediately.Because the old codes try to unregister the helper which is
not registered successfully.
Now add new function nf_conntrack_helpers_register to fix this bug.
It would unregister the right helpers automatically if someone fails.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h |    5 ++++
 net/netfilter/nf_conntrack_ftp.c            |   33
++++++--------------------
 net/netfilter/nf_conntrack_helper.c         |   29 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |   20 ++++++---------
 net/netfilter/nf_conntrack_sane.c           |   27 ++++++---------------
 net/netfilter/nf_conntrack_sip.c            |   25 +++++--------------
 net/netfilter/nf_conntrack_tftp.c           |   22 +++++------------
 7 files changed, 72 insertions(+), 89 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h
b/include/net/netfilter/nf_conntrack_helper.h
index 6cf614b..a6be9da 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -62,6 +62,11 @@ struct nf_conntrack_helper
*nf_conntrack_helper_try_module_get(const char *name,
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
+								unsigned
int);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+								unsigned
int);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper
*helper,
 					  gfp_t gfp);
diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index b666959..06bedf6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -580,19 +580,7 @@ static const struct nf_conntrack_expect_policy
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
+	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
 	kfree(ftp_buffer);
 }
 
@@ -624,21 +612,16 @@ static int __init nf_conntrack_ftp_init(void)
 				sprintf(ftp[i][j].name, "ftp");
 			else
 				sprintf(ftp[i][j].name, "ftp-%d", ports[i]);
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
 		}
 	}
 
+	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_ftp: failed to register helpers\n");
+		kfree(ftp_buffer);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_helper.c
b/net/netfilter/nf_conntrack_helper.c
index bd9d315..8412963 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,6 +456,35 @@ void nf_conntrack_helper_unregister(struct
nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *me,
+			unsigned int n)
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
+			unsigned int n)
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
index 0fd2976..7c27575 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -264,16 +264,15 @@ static int __init nf_conntrack_irc_init(void)
 			sprintf(irc[i].name, "irc");
 		else
 			sprintf(irc[i].name, "irc-%u", i);
+	}
 
-		ret = nf_conntrack_helper_register(&irc[i]);
-		if (ret) {
-			printk(KERN_ERR "nf_ct_irc: failed to register
helper "
-			       "for pf: %u port: %u\n",
-			       irc[i].tuple.src.l3num, ports[i]);
-			nf_conntrack_irc_fini();
-			return ret;
-		}
+	ret = nf_conntrack_helpers_register(irc, ports_c);
+	if (ret) {
+		pr_err("nf_ct_irc: failed to register helpers\n");
+		kfree(irc_buffer);
+		return ret;
 	}
+
 	return 0;
 }
 
@@ -281,10 +280,7 @@ static int __init nf_conntrack_irc_init(void)
  * it is needed by the init function */
 static void nf_conntrack_irc_fini(void)
 {
-	int i;
-
-	for (i = 0; i < ports_c; i++)
-		nf_conntrack_helper_unregister(&irc[i]);
+	nf_conntrack_helpers_unregister(irc, ports_c);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c
b/net/netfilter/nf_conntrack_sane.c
index 4a2134f..8fe6e8f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -174,17 +174,7 @@ static const struct nf_conntrack_expect_policy
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
+	nf_conntrack_helpers_unregister(sane, ports_c * 2);
 	kfree(sane_buffer);
 }
 
@@ -219,17 +209,16 @@ static int __init nf_conntrack_sane_init(void)
 			pr_debug("nf_ct_sane: registering helper for pf: %d
"
 				 "port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
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
 		}
 	}
 
+	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_sane: failed to register helpers\n");
+		kfree(sane_buffer);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_sip.c
b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..0606dc0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1614,15 +1614,7 @@ static const struct nf_conntrack_expect_policy
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
+	nf_conntrack_helpers_unregister(sip, ports_c * ARRAY_SIZE(sip[0]);
 }
 
 static int __init nf_conntrack_sip_init(void)
@@ -1662,17 +1654,14 @@ static int __init nf_conntrack_sip_init(void)
 				sprintf(sip[i][j].name, "sip-%u", i);
 
 			pr_debug("port #%u: %u\n", i, ports[i]);
-
-			ret = nf_conntrack_helper_register(&sip[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_sip: failed to
register"
-				       " helper for pf: %u port: %u\n",
-				       sip[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_sip_fini();
-				return ret;
-			}
 		}
 	}
+
+	ret = nf_conntrack_helpers_register(sip, ports_c *
ARRAY_SIZE(sip[0]));
+	if (ret) {
+		pr_err("nf_ct_sip: failed to register helpers\n");
+		return ret;
+	}
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_tftp.c
b/net/netfilter/nf_conntrack_tftp.c
index e68ab4f..0d3b7ad 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,12 +104,7 @@ static const struct nf_conntrack_expect_policy
tftp_exp_policy = {
 
 static void nf_conntrack_tftp_fini(void)
 {
-	int i, j;
-
-	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++)
-			nf_conntrack_helper_unregister(&tftp[i][j]);
-	}
+	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -135,17 +130,14 @@ static int __init nf_conntrack_tftp_init(void)
 				sprintf(tftp[i][j].name, "tftp");
 			else
 				sprintf(tftp[i][j].name, "tftp-%u", i);
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
 		}
 	}
+
+	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_tftp: failed to register helpers\n");
+		return ret;
+	}
 	return 0;
 }
