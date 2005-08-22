From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/4]: Add string match
Date: Mon, 22 Aug 2005 02:04:03 +0200
Message-ID: <43091673.4020404@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Add string match

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d5329f7baf82fbc6339fa9c7a167bd5728be46ea
tree d15ee1f092e13264baeb623a4303ac977df06f4b
parent 8cf07748b0be017ee9776fa5cb25b7d07e771e37
author Pablo Neira Ayuso <pablo@eurodev.net> Sun, 21 Aug 2005 21:55:43 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 21 Aug 2005 21:55:43 +0200

 include/linux/netfilter_ipv4/ipt_string.h |   18 ++++++
 net/ipv4/netfilter/Kconfig                |   12 ++++
 net/ipv4/netfilter/Makefile               |    1 
 net/ipv4/netfilter/ipt_string.c           |   91 +++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_string.h b/include/linux/netfilter_ipv4/ipt_string.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_string.h
@@ -0,0 +1,18 @@
+#ifndef _IPT_STRING_H
+#define _IPT_STRING_H
+
+#define IPT_STRING_MAX_PATTERN_SIZE 128
+#define IPT_STRING_MAX_ALGO_NAME_SIZE 16
+
+struct ipt_string_info
+{
+	u_int16_t from_offset;
+	u_int16_t to_offset;
+	char	  algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
+	char 	  pattern[IPT_STRING_MAX_PATTERN_SIZE];
+	u_int8_t  patlen;
+	u_int8_t  invert;
+	struct ts_config __attribute__((aligned(8))) *config;
+};
+
+#endif /*_IPT_STRING_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -410,6 +410,18 @@ config IP_NF_MATCH_HASHLIMIT
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
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_IP_NF_MATCH_REALM) += ipt_r
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_STRING) += ipt_string.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff --git a/net/ipv4/netfilter/ipt_string.c b/net/ipv4/netfilter/ipt_string.c
new file mode 100644
--- /dev/null
+++ b/net/ipv4/netfilter/ipt_string.c
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
