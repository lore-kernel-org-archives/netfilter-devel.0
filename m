From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 12/12]: add comment match
Date: Tue, 21 Sep 2004 05:23:42 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9EBE.90501@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060607080601060501030703"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060607080601060501030703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.12, 2004-09-20 11:55:28+02:00, kaber@coreworks.de
  [NETFILTER]: add comment match
 
  2.4 version by Brad Fisher <brad@info-link.net>
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------060607080601060501030703
Content-Type: text/x-patch;
 name="12.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="12.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/20 11:55:28+02:00 kaber@coreworks.de 
#   [NETFILTER]: add comment match
#   
#   2.4 version by Brad Fisher <brad@info-link.net>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_comment.c
#   2004/09/20 11:55:06+02:00 kaber@coreworks.de +59 -0
# 
# net/ipv4/netfilter/ipt_comment.c
#   2004/09/20 11:55:06+02:00 kaber@coreworks.de +0 -0
#   BitKeeper file /home/kaber/src/net/2.6-netfilter/net/ipv4/netfilter/ipt_comment.c
# 
# include/linux/netfilter_ipv4/ipt_comment.h
#   2004/09/20 11:55:04+02:00 kaber@coreworks.de +10 -0
# 
# net/ipv4/netfilter/Makefile
#   2004/09/20 11:55:04+02:00 kaber@coreworks.de +1 -6
#   [NETFILTER]: add comment match
#   
#   2.4 version by Brad Fisher <brad@info-link.net>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/Kconfig
#   2004/09/20 11:55:04+02:00 kaber@coreworks.de +10 -0
#   [NETFILTER]: add comment match
#   
#   2.4 version by Brad Fisher <brad@info-link.net>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ipt_comment.h
#   2004/09/20 11:55:04+02:00 kaber@coreworks.de +0 -0
#   BitKeeper file /home/kaber/src/net/2.6-netfilter/include/linux/netfilter_ipv4/ipt_comment.h
# 
diff -Nru a/include/linux/netfilter_ipv4/ipt_comment.h b/include/linux/netfilter_ipv4/ipt_comment.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/include/linux/netfilter_ipv4/ipt_comment.h	2004-09-20 12:00:15 +02:00
@@ -0,0 +1,10 @@
+#ifndef _IPT_COMMENT_H
+#define _IPT_COMMENT_H
+
+#define IPT_MAX_COMMENT_LEN 256
+
+struct ipt_comment_info {
+	unsigned char comment[IPT_MAX_COMMENT_LEN];
+};
+
+#endif /* _IPT_COMMENT_H */
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2004-09-20 12:00:15 +02:00
+++ b/net/ipv4/netfilter/Kconfig	2004-09-20 12:00:15 +02:00
@@ -332,6 +332,16 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
 
+config IP_NF_MATCH_COMMENT
+	tristate  'comment match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds a `comment' dummy-match, which allows you to put
+	  comments in your iptables ruleset.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2004-09-20 12:00:15 +02:00
+++ b/net/ipv4/netfilter/Makefile	2004-09-20 12:00:15 +02:00
@@ -50,28 +50,23 @@
 obj-$(CONFIG_IP_NF_MATCH_MARK) += ipt_mark.o
 obj-$(CONFIG_IP_NF_MATCH_MAC) += ipt_mac.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
-
 obj-$(CONFIG_IP_NF_MATCH_PKTTYPE) += ipt_pkttype.o
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) += ipt_multiport.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
-
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
-
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp.o
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah.o ipt_esp.o
-
 obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o
-
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_STATE) += ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
 obj-$(CONFIG_IP_NF_MATCH_REALM) += ipt_realm.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
-
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
+obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Nru a/net/ipv4/netfilter/ipt_comment.c b/net/ipv4/netfilter/ipt_comment.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/net/ipv4/netfilter/ipt_comment.c	2004-09-20 12:00:15 +02:00
@@ -0,0 +1,59 @@
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
+MODULE_DESCRIPTION("iptables comment match module");
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
+	/* We always match */
+	return 1;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	/* Check the size */
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_comment_info)))
+		return 0;
+	return 1;
+}
+
+static struct ipt_match comment_match = {
+	.name		= "comment",
+	.match		= match,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&comment_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&comment_match);
+}
+
+module_init(init);
+module_exit(fini);

--------------060607080601060501030703--
