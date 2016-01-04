From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 nf-next] netfilter: nf_ct_helper: define pr_fmt()
Date: Mon,  4 Jan 2016 12:48:11 +0100
Message-ID: <1451908093-3754-1-git-send-email-pablo@netfilter.org>
Cc: gfree.wind@outlook.com, fgao@ikuai8.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38255 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbcADLsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 06:48:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 64E87130FC5
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:48:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 55AC7DA801
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:48:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 14EC3DA80B
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:48:33 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c  | 17 ++++++++---------
 net/netfilter/nf_conntrack_irc.c  |  7 ++++---
 net/netfilter/nf_conntrack_sane.c | 19 +++++++++----------
 net/netfilter/nf_conntrack_sip.c  |  5 +++--
 net/netfilter/nf_conntrack_tftp.c |  7 ++++---
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index b666959..883c691 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netfilter.h>
@@ -505,11 +507,11 @@ skip_nl_seq:
 		   different IP address.  Simply don't record it for
 		   NAT. */
 		if (cmd.l3num == PF_INET) {
-			pr_debug("conntrack_ftp: NOT RECORDING: %pI4 != %pI4\n",
+			pr_debug("NOT RECORDING: %pI4 != %pI4\n",
 				 &cmd.u3.ip,
 				 &ct->tuplehash[dir].tuple.src.u3.ip);
 		} else {
-			pr_debug("conntrack_ftp: NOT RECORDING: %pI6 != %pI6\n",
+			pr_debug("NOT RECORDING: %pI6 != %pI6\n",
 				 cmd.u3.ip6,
 				 ct->tuplehash[dir].tuple.src.u3.ip6);
 		}
@@ -586,8 +588,7 @@ static void nf_conntrack_ftp_fini(void)
 			if (ftp[i][j].me == NULL)
 				continue;
 
-			pr_debug("nf_ct_ftp: unregistering helper for pf: %d "
-				 "port: %d\n",
+			pr_debug("unregistering helper for pf: %d port: %d\n",
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&ftp[i][j]);
 		}
@@ -625,14 +626,12 @@ static int __init nf_conntrack_ftp_init(void)
 			else
 				sprintf(ftp[i][j].name, "ftp-%d", ports[i]);
 
-			pr_debug("nf_ct_ftp: registering helper for pf: %d "
-				 "port: %d\n",
+			pr_debug("registering helper for pf: %d port: %d\n",
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&ftp[i][j]);
 			if (ret) {
-				printk(KERN_ERR "nf_ct_ftp: failed to register"
-				       " helper for pf: %d port: %d\n",
-					ftp[i][j].tuple.src.l3num, ports[i]);
+				pr_err("failed to register helper for pf: %d port: %d\n",
+				       ftp[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_ftp_fini();
 				return ret;
 			}
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 0fd2976..8b6da27 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -9,6 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/skbuff.h>
@@ -237,7 +239,7 @@ static int __init nf_conntrack_irc_init(void)
 	int i, ret;
 
 	if (max_dcc_channels < 1) {
-		printk(KERN_ERR "nf_ct_irc: max_dcc_channels must not be zero\n");
+		pr_err("max_dcc_channels must not be zero\n");
 		return -EINVAL;
 	}
 
@@ -267,8 +269,7 @@ static int __init nf_conntrack_irc_init(void)
 
 		ret = nf_conntrack_helper_register(&irc[i]);
 		if (ret) {
-			printk(KERN_ERR "nf_ct_irc: failed to register helper "
-			       "for pf: %u port: %u\n",
+			pr_err("failed to register helper for pf: %u port: %u\n",
 			       irc[i].tuple.src.l3num, ports[i]);
 			nf_conntrack_irc_fini();
 			return ret;
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 4a2134f..7523a57 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -17,6 +17,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netfilter.h>
@@ -120,14 +122,14 @@ static int help(struct sk_buff *skb,
 	ct_sane_info->state = SANE_STATE_NORMAL;
 
 	if (datalen < sizeof(struct sane_reply_net_start)) {
-		pr_debug("nf_ct_sane: NET_START reply too short\n");
+		pr_debug("NET_START reply too short\n");
 		goto out;
 	}
 
 	reply = sb_ptr;
 	if (reply->status != htonl(SANE_STATUS_SUCCESS)) {
 		/* saned refused the command */
-		pr_debug("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
+		pr_debug("unsuccessful SANE_STATUS = %u\n",
 			 ntohl(reply->status));
 		goto out;
 	}
@@ -148,7 +150,7 @@ static int help(struct sk_buff *skb,
 			  &tuple->src.u3, &tuple->dst.u3,
 			  IPPROTO_TCP, NULL, &reply->port);
 
-	pr_debug("nf_ct_sane: expect: ");
+	pr_debug("expect: ");
 	nf_ct_dump_tuple(&exp->tuple);
 
 	/* Can't expect this?  Best to drop packet now. */
@@ -178,8 +180,7 @@ static void nf_conntrack_sane_fini(void)
 
 	for (i = 0; i < ports_c; i++) {
 		for (j = 0; j < 2; j++) {
-			pr_debug("nf_ct_sane: unregistering helper for pf: %d "
-				 "port: %d\n",
+			pr_debug("unregistering helper for pf: %d port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&sane[i][j]);
 		}
@@ -216,14 +217,12 @@ static int __init nf_conntrack_sane_init(void)
 			else
 				sprintf(sane[i][j].name, "sane-%d", ports[i]);
 
-			pr_debug("nf_ct_sane: registering helper for pf: %d "
-				 "port: %d\n",
+			pr_debug("registering helper for pf: %d port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&sane[i][j]);
 			if (ret) {
-				printk(KERN_ERR "nf_ct_sane: failed to "
-				       "register helper for pf: %d port: %d\n",
-					sane[i][j].tuple.src.l3num, ports[i]);
+				pr_err("failed to register helper for pf: %d port: %d\n",
+				       sane[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_sane_fini();
 				return ret;
 			}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..3e06402 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/skbuff.h>
@@ -1665,8 +1667,7 @@ static int __init nf_conntrack_sip_init(void)
 
 			ret = nf_conntrack_helper_register(&sip[i][j]);
 			if (ret) {
-				printk(KERN_ERR "nf_ct_sip: failed to register"
-				       " helper for pf: %u port: %u\n",
+				pr_err("failed to register helper for pf: %u port: %u\n",
 				       sip[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_sip_fini();
 				return ret;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index e68ab4f..36f9640 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -5,6 +5,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/in.h>
@@ -138,9 +140,8 @@ static int __init nf_conntrack_tftp_init(void)
 
 			ret = nf_conntrack_helper_register(&tftp[i][j]);
 			if (ret) {
-				printk(KERN_ERR "nf_ct_tftp: failed to register"
-				       " helper for pf: %u port: %u\n",
-					tftp[i][j].tuple.src.l3num, ports[i]);
+				pr_err("failed to register helper for pf: %u port: %u\n",
+				       tftp[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_tftp_fini();
 				return ret;
 			}
-- 
2.1.4

