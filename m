From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/20]: nf_conntrack/nf_nat: add TFTP helper port
Date: Sat,  2 Dec 2006 15:50:05 +0100 (MET)
Message-ID: <20061202145309.1381.33027.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack/nf_nat: add TFTP helper port

Add IPv4 and IPv6 capable nf_conntrack port of the TFTP conntrack/NAT helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e95138a41a63f7da0d8969c6a00f6f632b912b28
tree 90fa078d527fdca0c67d40f1de0243c8016c2e4b
parent b83f09c4c816919e00f9f78ffe12dc4bf81aa2c4
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:23 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:23 +0100

 include/linux/netfilter/nf_conntrack_tftp.h |   20 +++
 net/ipv4/netfilter/Kconfig                  |    5 +
 net/ipv4/netfilter/Makefile                 |    1 
 net/ipv4/netfilter/nf_nat_tftp.c            |   52 +++++++++
 net/netfilter/Kconfig                       |   11 ++
 net/netfilter/Makefile                      |    1 
 net/netfilter/nf_conntrack_tftp.c           |  159 +++++++++++++++++++++++++++
 7 files changed, 249 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
new file mode 100644
index 0000000..0d79b7a
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -0,0 +1,20 @@
+#ifndef _NF_CONNTRACK_TFTP_H
+#define _NF_CONNTRACK_TFTP_H
+
+#define TFTP_PORT 69
+
+struct tftphdr {
+	__be16 opcode;
+};
+
+#define TFTP_OPCODE_READ	1
+#define TFTP_OPCODE_WRITE	2
+#define TFTP_OPCODE_DATA	3
+#define TFTP_OPCODE_ACK		4
+#define TFTP_OPCODE_ERROR	5
+
+extern unsigned int (*nf_nat_tftp_hook)(struct sk_buff **pskb,
+				        enum ip_conntrack_info ctinfo,
+				        struct nf_conntrack_expect *exp);
+
+#endif /* _NF_CONNTRACK_TFTP_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 83e83f5..1c0018b 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -515,6 +515,11 @@ config IP_NF_NAT_TFTP
 	default IP_NF_NAT if IP_NF_TFTP=y
 	default m if IP_NF_TFTP=m
 
+config NF_NAT_TFTP
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_TFTP
+
 config IP_NF_NAT_AMANDA
 	tristate
 	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 167b65e..3ca0af0 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_NF_NAT_H323) += nf_nat_h323
 obj-$(CONFIG_NF_NAT_IRC) += nf_nat_irc.o
 obj-$(CONFIG_NF_NAT_PPTP) += nf_nat_pptp.o
 obj-$(CONFIG_NF_NAT_SIP) += nf_nat_sip.o
+obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
new file mode 100644
index 0000000..2566b79
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -0,0 +1,52 @@
+/* (C) 2001-2002 Magnus Boden <mb@ozaba.mine.nu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/udp.h>
+
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_tftp.h>
+
+MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
+MODULE_DESCRIPTION("TFTP NAT helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_nat_tftp");
+
+static unsigned int help(struct sk_buff **pskb,
+			 enum ip_conntrack_info ctinfo,
+			 struct nf_conntrack_expect *exp)
+{
+	struct nf_conn *ct = exp->master;
+
+	exp->saved_proto.udp.port
+		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	exp->dir = IP_CT_DIR_REPLY;
+	exp->expectfn = nf_nat_follow_master;
+	if (nf_conntrack_expect_related(exp) != 0)
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+
+static void __exit nf_nat_tftp_fini(void)
+{
+	rcu_assign_pointer(nf_nat_tftp_hook, NULL);
+	synchronize_rcu();
+}
+
+static int __init nf_nat_tftp_init(void)
+{
+	BUG_ON(rcu_dereference(nf_nat_tftp_hook));
+	rcu_assign_pointer(nf_nat_tftp_hook, help);
+	return 0;
+}
+
+module_init(nf_nat_tftp_init);
+module_exit(nf_nat_tftp_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e738911..e0deac1 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -248,6 +248,17 @@ config NF_CONNTRACK_SIP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_TFTP
+	tristate "TFTP protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  TFTP connection tracking helper, this is required depending
+	  on how restrictive your ruleset is.
+	  If you are using a tftp client behind -j SNAT or -j MASQUERADING
+	  you will need this.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 86da217..5dc5574 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_con
 obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o
 obj-$(CONFIG_NF_CONNTRACK_PPTP) += nf_conntrack_pptp.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
+obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
new file mode 100644
index 0000000..d46a126
--- /dev/null
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -0,0 +1,159 @@
+/* (C) 2001-2002 Magnus Boden <mb@ozaba.mine.nu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/in.h>
+#include <linux/udp.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_tftp.h>
+
+MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
+MODULE_DESCRIPTION("TFTP connection tracking helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_conntrack_tftp");
+
+#define MAX_PORTS 8
+static unsigned short ports[MAX_PORTS];
+static int ports_c;
+module_param_array(ports, ushort, &ports_c, 0400);
+MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
+
+#if 0
+#define DEBUGP(format, args...) printk("%s:%s:" format, \
+                                       __FILE__, __FUNCTION__ , ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+
+unsigned int (*nf_nat_tftp_hook)(struct sk_buff **pskb,
+				 enum ip_conntrack_info ctinfo,
+				 struct nf_conntrack_expect *exp) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
+
+static int tftp_help(struct sk_buff **pskb,
+		     unsigned int protoff,
+		     struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tftphdr _tftph, *tfh;
+	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_tuple *tuple;
+	unsigned int ret = NF_ACCEPT;
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	typeof(nf_nat_tftp_hook) nf_nat_tftp;
+
+	tfh = skb_header_pointer(*pskb, protoff + sizeof(struct udphdr),
+				 sizeof(_tftph), &_tftph);
+	if (tfh == NULL)
+		return NF_ACCEPT;
+
+	switch (ntohs(tfh->opcode)) {
+	case TFTP_OPCODE_READ:
+	case TFTP_OPCODE_WRITE:
+		/* RRQ and WRQ works the same way */
+		DEBUGP("");
+		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+		exp = nf_conntrack_expect_alloc(ct);
+		if (exp == NULL)
+			return NF_DROP;
+		tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		nf_conntrack_expect_init(exp, family,
+					 &tuple->src.u3, &tuple->dst.u3,
+					 IPPROTO_UDP,
+					 NULL, &tuple->dst.u.udp.port);
+
+		DEBUGP("expect: ");
+		NF_CT_DUMP_TUPLE(&exp->tuple);
+		NF_CT_DUMP_TUPLE(&exp->mask);
+
+		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
+		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
+			ret = nf_nat_tftp(pskb, ctinfo, exp);
+		else if (nf_conntrack_expect_related(exp) != 0)
+			ret = NF_DROP;
+		nf_conntrack_expect_put(exp);
+		break;
+	case TFTP_OPCODE_DATA:
+	case TFTP_OPCODE_ACK:
+		DEBUGP("Data/ACK opcode\n");
+		break;
+	case TFTP_OPCODE_ERROR:
+		DEBUGP("Error opcode\n");
+		break;
+	default:
+		DEBUGP("Unknown opcode\n");
+	}
+	return ret;
+}
+
+static struct nf_conntrack_helper tftp[MAX_PORTS][2] __read_mostly;
+static char tftp_names[MAX_PORTS][2][sizeof("tftp-65535")] __read_mostly;
+
+static void nf_conntrack_tftp_fini(void)
+{
+	int i, j;
+
+	for (i = 0; i < ports_c; i++) {
+		for (j = 0; j < 2; j++)
+			nf_conntrack_helper_unregister(&tftp[i][j]);
+	}
+}
+
+static int __init nf_conntrack_tftp_init(void)
+{
+	int i, j, ret;
+	char *tmpname;
+
+	if (ports_c == 0)
+		ports[ports_c++] = TFTP_PORT;
+
+	for (i = 0; i < ports_c; i++) {
+		memset(&tftp[i], 0, sizeof(tftp[i]));
+
+		tftp[i][0].tuple.src.l3num = AF_INET;
+		tftp[i][1].tuple.src.l3num = AF_INET6;
+		for (j = 0; j < 2; j++) {
+			tftp[i][j].tuple.dst.protonum = IPPROTO_UDP;
+			tftp[i][j].tuple.src.u.udp.port = htons(ports[i]);
+			tftp[i][j].mask.src.l3num = 0xFFFF;
+			tftp[i][j].mask.dst.protonum = 0xFF;
+			tftp[i][j].mask.src.u.udp.port = htons(0xFFFF);
+			tftp[i][j].max_expected = 1;
+			tftp[i][j].timeout = 5 * 60; /* 5 minutes */
+			tftp[i][j].me = THIS_MODULE;
+			tftp[i][j].help = tftp_help;
+
+			tmpname = &tftp_names[i][j][0];
+			if (ports[i] == TFTP_PORT)
+				sprintf(tmpname, "tftp");
+			else
+				sprintf(tmpname, "tftp-%u", i);
+			tftp[i][j].name = tmpname;
+
+			ret = nf_conntrack_helper_register(&tftp[i][j]);
+			if (ret) {
+				printk("nf_ct_tftp: failed to register helper "
+				       "for pf: %u port: %u\n",
+					tftp[i][j].tuple.src.l3num, ports[i]);
+				nf_conntrack_tftp_fini();
+				return ret;
+			}
+		}
+	}
+	return 0;
+}
+
+module_init(nf_conntrack_tftp_init);
+module_exit(nf_conntrack_tftp_fini);
