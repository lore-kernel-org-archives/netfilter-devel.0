From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/4] ipt_string: match to look for string matchings
Date: Sun, 09 Jan 2005 23:23:22 +0100
Message-ID: <41E1AEDA.5020402@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040400080709030604040904"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040400080709030604040904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here's the match called ipt_string which lets you look for matchings in 
a packet via iptables.

I haven't register a new revision since this AFAICS this match wasn't 
ever in a standalone kernel, so must we respect backward compatibility 
in this case? My patch is not doing it.

--
Pablo

--------------040400080709030604040904
Content-Type: text/x-patch;
 name="ipt_string.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_string.patch"

--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/ipt_string.c	2005-01-09 14:22:52.000000000 +0100
@@ -0,0 +1,81 @@
+/* Kernel module to match a string into a packet.
+ *
+ * Copyright (C) 2005 Pablo Neira Ayuso  <pablo@eurodev.net>
+ *
+ * This code under GPL version 2.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/nf_string_match.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_string.h>
+
+MODULE_LICENSE("GPL");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_string_info *info = matchinfo;
+	unsigned int off = 0;
+	
+	if (nf_string_match_search(skb, info->sm, &off))
+		return (1 - info->invert);
+	
+	return (0 + info->invert);
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_ip *ip,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
+{
+	struct ipt_string_info *info = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_string_info)))
+		return 0;
+
+	/* Initialization */
+	info->sm = (struct nf_string_match *)
+			nf_string_match_create(info->pattern, info->patlen);
+	if (!info->sm)
+		return 0;
+
+	return 1;
+}
+
+static void
+destroy(void *matchinfo, unsigned int matchinfosize)
+{
+	struct ipt_string_info *info = matchinfo;
+
+	nf_string_match_destroy(info->sm);
+}
+
+static struct ipt_match string_match = {
+	.name       	="string",
+	.match      	= match, 
+	.checkentry 	= checkentry,
+	.destroy 	= destroy,
+	.me         	= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&string_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&string_match);
+}
+
+module_init(init);
+module_exit(fini);
--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/ipt_string.h	2005-01-09 14:16:44.000000000 +0100
@@ -0,0 +1,16 @@
+#ifndef _IPT_STRING_H
+#define _IPT_STRING_H
+
+#include <linux/netfilter_ipv4/ipt_string.h>
+
+#define MAX_PATLEN 256
+
+struct ipt_string_info {
+    char 	pattern[MAX_PATLEN];
+    int 	patlen;
+    int 	invert;
+    struct	nf_string_match *sm;
+};
+
+#endif /* _IPT_STRING_H */
+

--------------040400080709030604040904--
