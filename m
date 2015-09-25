From: Feng Gao <gfree.wind@outlook.com>
Subject: [PATCH]: netfilter: ftp/irc/sane/sip/tftp: Fix the kernel panic when load these modules with duplicated ports
Date: Fri, 25 Sep 2015 18:02:55 +0800
Message-ID: <BAY403-EAS55DEFB461D662C9DA7662795420@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <gfree.wind@outlook.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s8.hotmail.com ([65.54.190.19]:62983 "EHLO
	BAY004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbbIYKDB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 06:03:01 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reset the helper->me to NULL when it fail to register helper.
Then the fini function of these modules could avoid unregister
wrong helper.

Signed-off-by: Feng Gao <gfree.wind@gmail.com>
---
 net/netfilter/nf_conntrack_ftp.c  |    1 +
 net/netfilter/nf_conntrack_irc.c  |    7 +++++--
 net/netfilter/nf_conntrack_sane.c |    4 ++++
 net/netfilter/nf_conntrack_sip.c  |    1 +
 net/netfilter/nf_conntrack_tftp.c |    7 +++++--
 5 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index b666959..fbc4b82 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -630,6 +630,7 @@ static int __init nf_conntrack_ftp_init(void)
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&ftp[i][j]);
 			if (ret) {
+				ftp[i][j].me = NULL;
 				printk(KERN_ERR "nf_ct_ftp: failed to
register"
 				       " helper for pf: %d port: %d\n",
 					ftp[i][j].tuple.src.l3num,
ports[i]);
diff --git a/net/netfilter/nf_conntrack_irc.c
b/net/netfilter/nf_conntrack_irc.c
index 0fd2976..7c99378 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -267,6 +267,7 @@ static int __init nf_conntrack_irc_init(void)
 
 		ret = nf_conntrack_helper_register(&irc[i]);
 		if (ret) {
+			irc[i].me = NULL;
 			printk(KERN_ERR "nf_ct_irc: failed to register
helper "
 			       "for pf: %u port: %u\n",
 			       irc[i].tuple.src.l3num, ports[i]);
@@ -283,8 +284,10 @@ static void nf_conntrack_irc_fini(void)
 {
 	int i;
 
-	for (i = 0; i < ports_c; i++)
-		nf_conntrack_helper_unregister(&irc[i]);
+	for (i = 0; i < ports_c; i++) {
+		if (irc[i].me)
+			nf_conntrack_helper_unregister(&irc[i]);
+	}
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c
b/net/netfilter/nf_conntrack_sane.c
index 4a2134f..f4986df 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -178,6 +178,9 @@ static void nf_conntrack_sane_fini(void)
 
 	for (i = 0; i < ports_c; i++) {
 		for (j = 0; j < 2; j++) {
+			if (!sane[i][j].me)
+				continue;
+
 			pr_debug("nf_ct_sane: unregistering helper for pf:
%d "
 				 "port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
@@ -221,6 +224,7 @@ static int __init nf_conntrack_sane_init(void)
 				 sane[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&sane[i][j]);
 			if (ret) {
+				sane[i][j].me = NULL;
 				printk(KERN_ERR "nf_ct_sane: failed to "
 				       "register helper for pf: %d port:
%d\n",
 					sane[i][j].tuple.src.l3num,
ports[i]);
diff --git a/net/netfilter/nf_conntrack_sip.c
b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..53cd48a 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1665,6 +1665,7 @@ static int __init nf_conntrack_sip_init(void)
 
 			ret = nf_conntrack_helper_register(&sip[i][j]);
 			if (ret) {
+				sip[i][j].me = NULL;
 				printk(KERN_ERR "nf_ct_sip: failed to
register"
 				       " helper for pf: %u port: %u\n",
 				       sip[i][j].tuple.src.l3num, ports[i]);
diff --git a/net/netfilter/nf_conntrack_tftp.c
b/net/netfilter/nf_conntrack_tftp.c
index e68ab4f..8255b21 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -107,8 +107,10 @@ static void nf_conntrack_tftp_fini(void)
 	int i, j;
 
 	for (i = 0; i < ports_c; i++) {
-		for (j = 0; j < 2; j++)
-			nf_conntrack_helper_unregister(&tftp[i][j]);
+		for (j = 0; j < 2; j++) {
+			if (tftp[i][j].me)
+				nf_conntrack_helper_unregister(&tftp[i][j]);
+		}
 	}
 }
 
@@ -138,6 +140,7 @@ static int __init nf_conntrack_tftp_init(void)
 
 			ret = nf_conntrack_helper_register(&tftp[i][j]);
 			if (ret) {
+				tftp[i][j].me = NULL;
 				printk(KERN_ERR "nf_ct_tftp: failed to
register"
 				       " helper for pf: %u port: %u\n",
 					tftp[i][j].tuple.src.l3num,
ports[i]);
