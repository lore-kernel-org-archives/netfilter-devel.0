From: Tim Vandermeersch <tim.vandermeersch@pandora.be>
Subject: Target ipt_XOR
Date: Thu, 29 May 2003 12:43:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED5E449.7030100@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This patch adds a new target "XOR" wich can encrypt TCP and UDP traffic 
using a simple xor encryption. See netfilter-extensions.sgml.diff for 
usage.

Suggestions, comments and bug-fixes are welcome...

Regards,
Tim

(I posted this same post yesterday but my system clock was a year 
behind, and I don't want people to overlook this great patch for that 
reason :) )

-----

diff -Nru orig/patch-o-matic/extra/XOR.patch new/patch-o-matic/extra/XOR.patch
--- orig/patch-o-matic/extra/XOR.patch	1970-01-01 01:00:00.000000000 +0100
+++ new/patch-o-matic/extra/XOR.patch	2003-05-28 19:01:31.000000000 +0200
@@ -0,0 +1,124 @@
+diff -Nru linux-2.4.20-plain/include/linux/netfilter_ipv4/ipt_XOR.h linux-2.4.20-XOR/include/linux/netfilter_ipv4/ipt_XOR.h
+--- linux-2.4.20-plain/include/linux/netfilter_ipv4/ipt_XOR.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20-XOR/include/linux/netfilter_ipv4/ipt_XOR.h	2003-05-28 18:31:50.000000000 +0200
+@@ -0,0 +1,9 @@
++#ifndef _IPT_XOR_H
++#define _IPT_XOR_H
++
++struct ipt_XOR_info {
++	char		key[30];
++	u_int8_t	block_size;
++};
++
++#endif /* _IPT_XOR_H */
+diff -Nru linux-2.4.20-plain/net/ipv4/netfilter/ipt_XOR.c linux-2.4.20-XOR/net/ipv4/netfilter/ipt_XOR.c
+--- linux-2.4.20-plain/net/ipv4/netfilter/ipt_XOR.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20-XOR/net/ipv4/netfilter/ipt_XOR.c	2003-05-28 18:53:22.000000000 +0200
+@@ -0,0 +1,107 @@
++/* XOR target for IP tables
++ * (C) 2000 by Tim Vandermeersch <Tim.Vandermeersch@pandora.be>
++ * Based on ipt_TTL.c
++ *
++ * Version 1.0
++ *
++ * This software is distributed under the terms of GNU GPL
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <linux/tcp.h>
++#include <linux/udp.h>
++
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_XOR.h>
++
++MODULE_AUTHOR("Tim Vandermeersch <Tim.Vandermeersch@pandora.be>");
++MODULE_DESCRIPTION("IP tables XOR module");
++MODULE_LICENSE("GPL");
++
++static unsigned int ipt_xor_target(struct sk_buff **pskb, unsigned int hooknum, 
++		const struct net_device *in, const struct net_device *out, 
++		const void *targinfo, void *userinfo)
++{
++	struct ipt_XOR_info *info = (void *) targinfo;
++	struct iphdr *iph = (*pskb)->nh.iph;
++	struct tcphdr *tcph;
++	struct udphdr *udph;
++	int i, j, k;
++  
++	if (iph->protocol == IPPROTO_TCP) {
++		tcph = (struct tcphdr *) ((*pskb)->data + iph->ihl*4);
++		for (i=0, j=0; i<(ntohs(iph->tot_len) - iph->ihl*4 - tcph->doff*4); ) {
++			for (k=0; k<=info->block_size; k++) {
++				(char) (*pskb)->data[ iph->ihl*4 + tcph->doff*4 + i ] ^= 
++						info->key[j];
++				i++;
++			}
++			j++;
++			if (info->key[j] == 0x00)
++				j = 0;
++		}
++	} else if (iph->protocol == IPPROTO_UDP) {
++		udph = (struct udphdr *) ((*pskb)->data + iph->ihl*4);
++		for (i=0, j=0; i<(ntohs(udph->len)-8); ) {
++			for (k=0; k<=info->block_size; k++) {
++				(char) (*pskb)->data[ iph->ihl*4 + sizeof(struct udphdr) + i ] ^= 
++						info->key[j];
++				i++;
++			}
++			j++;
++			if (info->key[j] == 0x00)
++				j = 0;
++		}
++	}
++  
++	return IPT_CONTINUE;
++}
++
++static int ipt_xor_checkentry(const char *tablename, const struct ipt_entry *e,
++		void *targinfo, unsigned int targinfosize, 
++		unsigned int hook_mask)
++{
++	struct ipt_XOR_info *info = targinfo;
++
++	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_XOR_info))) {
++		printk(KERN_WARNING "XOR: targinfosize %u != %Zu\n", 
++				targinfosize, IPT_ALIGN(sizeof(struct ipt_XOR_info)));
++	return 0;
++	}	
++
++	if (strcmp(tablename, "mangle")) {
++		printk(KERN_WARNING "XOR: can only be called from"
++				"\"mangle\" table, not \"%s\"\n", tablename);
++		return 0; 
++	}
++
++	if (!strcmp(info->key, "")) {
++		printk(KERN_WARNING "XOR: You must specify a key");
++		return 0;
++	}
++
++	if (info->block_size == 0) {
++		printk(KERN_WARNING "XOR: You must specify a block-size");
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_target ipt_XOR = { { NULL, NULL }, "XOR",
++	ipt_xor_target, ipt_xor_checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	return ipt_register_target(&ipt_XOR);
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_target(&ipt_XOR);
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru orig/patch-o-matic/extra/XOR.patch.config.in new/patch-o-matic/extra/XOR.patch.config.in
--- orig/patch-o-matic/extra/XOR.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ new/patch-o-matic/extra/XOR.patch.config.in	2003-05-28 19:01:31.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  XOR target support' CONFIG_IP_NF_TARGET_XOR $CONFIG_IP_NF_IPTABLES
diff -Nru orig/patch-o-matic/extra/XOR.patch.configure.help new/patch-o-matic/extra/XOR.patch.configure.help
--- orig/patch-o-matic/extra/XOR.patch.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ new/patch-o-matic/extra/XOR.patch.configure.help	2003-05-28 19:01:31.000000000 +0200
@@ -0,0 +1,8 @@
+CONFIG_IP_NF_TARGET_LOG
+XOR target support
+CONFIG_IP_NF_TARGET_XOR
+  This option adds a `XOR' target, which can encrypt TCP and 
+  UDP traffic using a simple XOR encryption.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nru orig/patch-o-matic/extra/XOR.patch.help new/patch-o-matic/extra/XOR.patch.help
--- orig/patch-o-matic/extra/XOR.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ new/patch-o-matic/extra/XOR.patch.help	2003-05-28 19:01:31.000000000 +0200
@@ -0,0 +1,6 @@
+Author: Tim Vandermeersch <Tim.Vandermeersch@pandora.be>
+Status: Experimental
+
+This adds CONFIG_IP_NF_TARGET_XOR option, which can 
+encrypt TCP and UDP traffic using a simple XOR 
+encryption
diff -Nru orig/patch-o-matic/extra/XOR.patch.makefile new/patch-o-matic/extra/XOR.patch.makefile
--- orig/patch-o-matic/extra/XOR.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ new/patch-o-matic/extra/XOR.patch.makefile	2003-05-28 19:01:31.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_XOR) += ipt_XOR.o
diff -Nru orig/userspace/extensions/libipt_XOR.c new/userspace/extensions/libipt_XOR.c
--- orig/userspace/extensions/libipt_XOR.c	1970-01-01 01:00:00.000000000 +0100
+++ new/userspace/extensions/libipt_XOR.c	2003-05-28 19:03:18.000000000 +0200
@@ -0,0 +1,112 @@
+/* Shared library add-on to iptables for the XOR target
+ * (C) 2000 by Tim Vandermeersch <Tim.Vandermeersch@pandora.be>
+ * Based on libipt_TTL.c
+ *
+ * Version 1.0
+ *
+ * This program is distributed under the terms of GNU GPL
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_XOR.h>
+
+#define	IPT_KEY_SET		1
+#define IPT_BLOCKSIZE_SET	2
+
+static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+{
+}
+
+static void help(void) 
+{
+	printf(
+		"XOR target v%s options\n"
+		"  --key string	          Set key to \"string\"\n"
+		"  --block-size		  Set block size\n",
+		IPTABLES_VERSION);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const struct ipt_entry *entry, 
+		struct ipt_entry_target **target)
+{
+	struct ipt_XOR_info *info = (struct ipt_XOR_info *) (*target)->data;
+	
+	if (!optarg)
+		exit_error(PARAMETER_PROBLEM, "XOR: too few arguments");
+	
+	if (check_inverse(optarg, &invert, NULL, 0))
+		exit_error(PARAMETER_PROBLEM, "XOR: unexpected '!'");
+
+	switch (c) {	
+		case '1':
+			strncpy(info->key, optarg, 30);
+			*flags |= IPT_KEY_SET;
+			break;
+		case '2':
+			info->block_size = atoi(optarg);
+			*flags |= IPT_BLOCKSIZE_SET;
+			break;
+		default:
+			return 0;
+	}
+	
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & IPT_KEY_SET))
+		exit_error(PARAMETER_PROBLEM, "XOR: You must specify a key");
+	if (!(flags & IPT_BLOCKSIZE_SET))
+		exit_error(PARAMETER_PROBLEM, "XOR: You must specify a block-size");
+}
+
+static void save (const struct ipt_ip *ip,
+		const struct ipt_entry_target *target)
+{
+	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
+
+	printf("--key %s ", info->key);
+	printf("--block-size %u ", info->block_size);
+}
+
+static void print (const struct ipt_ip *ip,
+	const struct ipt_entry_target *target, int numeric)
+{
+	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
+
+	printf("key: %s ", info->key);
+	printf("block-size: %u ", info->block_size);
+}
+
+static struct option opts[] = {
+	{ "key", 1, 0, '1' },
+	{ "block-size", 1, 0, '2' },
+	{ 0 }
+};
+
+static struct iptables_target XOR = { NULL, 
+	"XOR",
+	IPTABLES_VERSION,
+	IPT_ALIGN(sizeof(struct ipt_XOR_info)),
+	IPT_ALIGN(sizeof(struct ipt_XOR_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts 
+};
+
+void _init(void)
+{
+	register_target(&XOR);
+}

-----

diff -Nru orig/documentation/HOWTO/netfilter-extensions-HOWTO.sgml new/documentation/HOWTO/netfilter-extensions-HOWTO.sgml
--- orig/documentation/HOWTO/netfilter-extensions-HOWTO.sgml	2003-03-05 19:15:22.000000000 +0100
+++ new/documentation/HOWTO/netfilter-extensions-HOWTO.sgml	2003-05-28 19:15:55.000000000 +0200
@@ -1274,6 +1274,44 @@
 <url url="http://www.gnumonks.org/projects/ulogd" name="web page"> containing the proper documentation
 for ULOG, so there is no point for me to explain this here..
 
+<sect1>XOR patch
+<p>
+This patch by Tim Vandermeersch &lt;Tim.Vandermeersch@pandora.be&gt; adds a new target that
+enables the user to encrypt TCP and UDP traffic using a simple xor encryption.
+
+<p>
+For example, if you want to encrypt all TCP and UDP traffic between host A and host B, you can do as follows :
+
+<tscreen><verb>
+(on host A, 1.2.3.4)
+# iptables -t mangle -A OUTPUT -d 1.2.3.5 -j XOR --key somekey --block-size 3
+# iptables -t mangle -A INPUT -s 1.2.3.4 -j XOR --key somekey --block-size 3
+
+# iptables -t mangle -L
+Chain OUTPUT (policy ACCEPT)
+target     prot opt source               destination         
+XOR        all  --  anywhere             1.2.3.5            key: somekey block-size: 3
+XOR        all  --  1.2.3.5              anywhere           key: somekey block-size: 3
+
+(on host B, 1.2.3.5)
+# iptables -t mangle -A OUTPUT -d 1.2.3.4 -j XOR --key somekey --block-size 3
+# iptables -t mangle -A INPUT -s 1.2.3.5 -j XOR --key somekey --block-size 3
+
+# iptables -t mangle -L
+Chain OUTPUT (policy ACCEPT)
+target     prot opt source               destination         
+XOR        all  --  anywhere             1.2.3.4            key: somekey block-size: 3
+XOR        all  --  1.2.3.4              anywhere           key: somekey block-size: 3
+</verb></tscreen>
+
+<p>
+Supported options for the TTL target are :
+
+<descrip>
+<tag>--key string</> Set the encryption key
+<tag>--block-size value</> Specify the block size
+</descrip>
+
 <sect>New connection tracking patches
 <p>
 In this sections, we will show the available connection tracking/nat patches.
