From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] string match for iptables
Date: Sat, 20 Aug 2005 18:06:47 +0200
Message-ID: <43075517.3070405@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000006010605070601040400"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------000006010605070601040400
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here comes the iptables string match since the textsearch infrastructure 
went into 2.6.13. This adds to iptables the ability of looking for given 
patterns in packets. I'll be happy to see this stuff in Davem's 2.6.14 
tree ;)

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------000006010605070601040400
Content-Type: text/x-patch;
 name="10ipt_string.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10ipt_string.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ipt_string.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ netfilter-2.6.14/net/ipv4/netfilter/ipt_string.c	2005-08-20 17:10:03.000000000 +0200
@@ -0,0 +1,91 @@
+/* String matching match for iptables
+ * 
+ * (C) 2005 Pablo Neira Ayuso <pablo@eurodev.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_string.h>
+#include <linux/textsearch.h>
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@eurodev.net>");
+MODULE_DESCRIPTION("IP tables string match module");
+MODULE_LICENSE("GPL");
+
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const void *matchinfo,
+		 int offset,
+		 int *hotdrop)
+{
+	struct ts_state state;
+	struct ipt_string_info *conf = (struct ipt_string_info *) matchinfo;
+
+	memset(&state, 0, sizeof(struct ts_state));
+
+	return (skb_find_text((struct sk_buff *)skb, conf->from_offset, 
+			     conf->to_offset, conf->config, &state) 
+			     != UINT_MAX) && !conf->invert;
+}
+
+#define STRING_TEXT_PRIV(m) ((struct ipt_string_info *) m)
+
+static int checkentry(const char *tablename,
+		      const struct ipt_ip *ip,
+		      void *matchinfo,
+		      unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	struct ipt_string_info *conf = matchinfo;
+	struct ts_config *ts_conf;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_string_info)))
+		return 0;
+
+	/* Damn, can't handle this case properly with iptables... */
+	if (conf->from_offset > conf->to_offset)
+		return 0;
+
+	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		return 0;
+
+	conf->config = ts_conf;
+
+	return 1;
+}
+
+static void destroy(void *matchinfo, unsigned int matchsize)
+{
+	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
+}
+
+static struct ipt_match string_match = {
+	.name 		= "string",
+	.match 		= match,
+	.checkentry	= checkentry,
+	.destroy 	= destroy,
+	.me 		= THIS_MODULE
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
Index: netfilter-2.6.14/net/ipv4/netfilter/Makefile
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/Makefile	2005-08-20 15:49:31.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/Makefile	2005-08-20 17:10:03.000000000 +0200
@@ -65,6 +65,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_STRING) += ipt_string.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
Index: netfilter-2.6.14/net/ipv4/netfilter/Kconfig
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/Kconfig	2005-08-20 15:49:31.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/Kconfig	2005-08-20 17:50:59.000000000 +0200
@@ -410,6 +410,18 @@
 	  destination IP' or `500pps from any given source IP'  with a single
 	  IPtables rule.
 
+config IP_NF_MATCH_STRING
+	tristate  'string match support'
+	depends on IP_NF_IPTABLES 
+	select TEXTSEARCH
+	select TEXTSEARCH_KMP
+	select TEXTSEARCH_FSM
+	help
+	  This option adds a `string' match, which allows you to look for
+	  pattern matchings in packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
Index: netfilter-2.6.14/include/linux/netfilter_ipv4/ipt_string.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ netfilter-2.6.14/include/linux/netfilter_ipv4/ipt_string.h	2005-08-20 17:10:03.000000000 +0200
@@ -0,0 +1,18 @@
+#ifndef _IPT_STRING_H
+#define _IPT_STRING_H
+
+#define IPT_STRING_MAX_PATTERN_SIZE 128
+#define IPT_STRING_MAX_ALGO_NAME_SIZE 16
+
+struct ipt_string_info
+{
+	u_int16_t		from_offset;
+	u_int16_t		to_offset;
+	char			algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
+	char			pattern[IPT_STRING_MAX_PATTERN_SIZE];
+	u_int8_t		patlen;
+	u_int8_t		invert;
+	struct ts_config	*config;
+};
+
+#endif /*_IPT_STRING_H*/

--------------000006010605070601040400--
