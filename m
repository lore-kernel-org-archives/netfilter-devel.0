From: Brad Fisher <brad@info-link.net>
Subject: [PATCH] Comment match
Date: Thu, 04 Dec 2003 14:18:57 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCF96B1.2790DEE8@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------59E85F894FAA4DE78142D606"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Attached is a comment match which I wrote a while back.  I was hoping
that maybe it would be suitable for inclusion in patch-o-matic.
Basically this allows one to add a comment to any rule as follows:

  iptables -A INPUT -m comment --comment "This is a comment" <other
stuff here>

Currently, comments are limited to 255 bytes because of a statically
allocated buffer.  For iptables-save to work correctly, it may be a good
idea not to use comments with double-quote chars (") or line breaks/new
lines.  The code doesn't currently check this.

Hope someone finds this helpful.

-Brad

--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch.config.in"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch.config.in"

  dep_tristate '  tcpmss match support' CONFIG_IP_NF_MATCH_TCPMSS $CONFIG_IP_NF_IPTABLES
  dep_tristate '  comment match support (EXPERIMENTAL)' CONFIG_IP_NF_MATCH_COMMENT $CONFIG_IP_NF_IPTABLES

--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch"

diff -ruN linux-2.4.20/include/linux/netfilter_ipv4/ipt_comment.h linux-2.4.20-comment/include/linux/netfilter_ipv4/ipt_comment.h
--- linux-2.4.20/include/linux/netfilter_ipv4/ipt_comment.h	Wed Dec 31 18:00:00 1969
+++ linux-2.4.20-comment/include/linux/netfilter_ipv4/ipt_comment.h	Tue May 13 19:47:01 2003
@@ -0,0 +1,10 @@
+#ifndef _IPT_COMMENT_H
+#define _IPT_COMMENT_H
+
+#define IPT_MAX_COMMENT_LEN 256
+
+struct ipt_comment_info {
+  char comment[IPT_MAX_COMMENT_LEN];
+};
+
+#endif /* _IPT_COMMENT_H */
diff -ruN linux-2.4.20/net/ipv4/netfilter/ipt_comment.c linux-2.4.20-comment/net/ipv4/netfilter/ipt_comment.c
--- linux-2.4.20/net/ipv4/netfilter/ipt_comment.c	Wed Dec 31 18:00:00 1969
+++ linux-2.4.20-comment/net/ipv4/netfilter/ipt_comment.c	Tue May 13 19:47:27 2003
@@ -0,0 +1,73 @@
+/*
+ * Implements a dummy match to allow attaching comments to rules
+ *
+ * 2003-05-13 Brad Fisher (brad@info-link.net)
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_comment.h>
+
+MODULE_AUTHOR("Brad Fisher <brad@info-link.net>");
+MODULE_DESCRIPTION("Comment 'match'");
+MODULE_LICENSE("GPL");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	/* We always match */
+	return 1;
+}
+
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+       int i;
+       struct ipt_comment_info *info = matchinfo;   /* match info for rule */
+
+       /* Check the size */
+       if (matchsize != IPT_ALIGN(sizeof(struct ipt_comment_info))) {
+               return 0;
+       }
+
+       /* Check the string.  Must be NULL terminated. */
+       for (i = 0; i < IPT_MAX_COMMENT_LEN; ++i)
+	       if (!info->comment[i])
+		       return 1;
+
+       /* Not NULL terminated? */
+       return 0;
+}
+
+
+static struct ipt_match comment_match
+	= { { NULL, NULL }, "comment", &match, &checkentry, NULL, THIS_MODULE };
+
+
+static int __init init(void)
+{
+       return ipt_register_match(&comment_match);
+}
+
+
+static void __exit fini(void)
+{
+       ipt_unregister_match(&comment_match);
+}
+
+module_init(init);
+module_exit(fini);
+

--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch.configure.help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch.configure.help"

CONFIG_IP_NF_MATCH_TCPMSS
COMMENT match support
CONFIG_IP_NF_MATCH_COMMENT
  This option adds a `comment' match, which allows you
  to associate a comment string with any rule.

  If you say Y here, try iptables -m comment --help for more information.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.


--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch.help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch.help"

Author: Brad Fisher <brad@info-link.net>
Status: It Works For Me.

This option adds CONFIG_IP_NF_MATCH_COMMENT, which supplies a comment
match module.  This match allows you to add comments (up to 256 characters)
to any rule.

Supported options:
--comment COMMENT

Example:
  -A INPUT -s 192.168.0.0/16 -c comment --comment "A privatized IP block"

--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch.makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch.makefile"

obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o

obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o


--------------59E85F894FAA4DE78142D606
Content-Type: text/plain; charset=us-ascii;
 name="comment.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="comment.patch.userspace"

diff -ruN iptables-1.2.8/extensions/.comment-test iptables-1.2.8-comment-new/extensions/.comment-test
--- iptables-1.2.8/extensions/.comment-test	Wed Dec 31 18:00:00 1969
+++ iptables-1.2.8-comment-new/extensions/.comment-test	Tue May 13 18:38:07 2003
@@ -0,0 +1,3 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_comment.h ] && echo comment
+
diff -ruN iptables-1.2.8/extensions/libipt_comment.c iptables-1.2.8-comment-new/extensions/libipt_comment.c
--- iptables-1.2.8/extensions/libipt_comment.c	Wed Dec 31 18:00:00 1969
+++ iptables-1.2.8-comment-new/extensions/libipt_comment.c	Tue May 13 18:38:00 2003
@@ -0,0 +1,123 @@
+/* Shared library add-on to iptables to add comment match support. 
+ * 
+ * ChangeLog
+ *     2003-05-13: Brad Fisher <brad@info-link.net>
+ *         Initial comment match
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_comment.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+		"COMMENT match options:\n"
+		"--comment COMMENT             Attach a comment to a rule\n\n"
+		);
+}
+
+static struct option opts[] = {
+	{ "comment", 1, 0, '1' },
+	{0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static void
+parse_comment(const unsigned char *s, struct ipt_comment_info *info)
+{	
+	int slen = strlen(s);
+
+	if (slen > IPT_MAX_COMMENT_LEN) {
+		exit_error(PARAMETER_PROBLEM,
+			"COMMENT must be shorter than %i characters", IPT_MAX_COMMENT_LEN);
+	}
+	
+	strcpy(info->comment, s);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert) {
+			exit_error(PARAMETER_PROBLEM,
+					"Sorry, you can't have an inverted comment");
+		}
+		
+		parse_comment(argv[optind-1], commentinfo);
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --comment. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "COMMENT match: You must specify `--comment'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	printf("/* %s */ ", ((struct ipt_comment_info *)match->data)->comment);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+/* I wonder whether this works? */
+	printf("--comment \"%s\" ", ((struct ipt_comment_info *)match->data)->comment );
+}
+
+static
+struct iptables_match comment
+= { NULL,
+    "comment",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_comment_info)),
+    IPT_ALIGN(sizeof(struct ipt_comment_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match(&comment);
+}

--------------59E85F894FAA4DE78142D606--
