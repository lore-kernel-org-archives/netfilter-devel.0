From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/*]: nf_conntrack/nf_nat: add TFTP helper port
Date: Sun, 05 Nov 2006 00:58:22 +0100
Message-ID: <454D291E.9010708@trash.net>
References: <454D1C8F.5060302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000601010908010503070008"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <454D1C8F.5060302@trash.net>
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
--------------000601010908010503070008
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Port the TFTP conntrack/NAT helpers.


--------------000601010908010503070008
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack/nf_nat: add TFTP helper port

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6cd9f9c0864b0a18a99b722bb15949effc0758a7
tree cc7aa5c69b11c96800f1179d43aaabdc703cf7b8
parent a6c08049039463f18272fa8e7139aadb8a950d22
author Patrick McHardy <kaber@trash.net> Sun, 05 Nov 2006 00:53:38 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 05 Nov 2006 00:53:38 +0100

 include/linux/netfilter/nf_conntrack_tftp.h |   20 +++
 net/ipv4/netfilter/Kconfig                  |    5 +
 net/ipv4/netfilter/Makefile                 |    1 
 net/ipv4/netfilter/nf_nat_tftp.c            |   51 ++++++++
 net/netfilter/Kconfig                       |   11 ++
 net/netfilter/Makefile                      |    1 
 net/netfilter/nf_conntrack_tftp.c           |  164 +++++++++++++++++++++++++++
 7 files changed, 253 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
new file mode 100644
index 0000000..93f3c18
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -0,0 +1,20 @@
+#ifndef _NF_CONNTRACK_TFTP_H
+#define _NF_CONNTRACK_TFTP_H
+
+#define TFTP_PORT 69
+
+struct tftphdr {
+	u_int16_t opcode;
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
index 5867f7b..598865e 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -513,6 +513,11 @@ config IP_NF_NAT_TFTP
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
index 30e470d..fcf3460 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_IP_NF_NAT_SIP) += ip_nat_si
 
 # NAT helpers (nf_conntrack) 
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
+obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 obj-$(CONFIG_NF_NAT_SIP) += nf_nat_sip.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
new file mode 100644
index 0000000..2fc063b
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -0,0 +1,51 @@
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
+	nf_nat_tftp_hook = NULL;
+	synchronize_net();
+}
+
+static int __init nf_nat_tftp_init(void)
+{
+	BUG_ON(nf_nat_tftp_hook);
+	nf_nat_tftp_hook = help;
+	return 0;
+}
+
+module_init(nf_nat_tftp_init);
+module_exit(nf_nat_tftp_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f3be7f4..65844d7 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -150,6 +150,17 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_TFTP
+	tristate "TFTP support on new connection tracking (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  TFTP connection tracking helper, this is required depending
+	  on how restrictive your ruleset is.
+	  If you are using a tftp client behind -j SNAT or -j MASQUERADING
+	  you will need this.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CONNTRACK_SIP
 	tristate "SIP support on new connection tracking (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e50eed6..747bb78 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_NF_CT_NETLINK) += nf_conntr
 
 # connection tracking helpers
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
+obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 
 # generic X tables 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
new file mode 100644
index 0000000..6c592bf
--- /dev/null
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -0,0 +1,164 @@
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
+				 struct nf_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
+
+static int tftp_help(struct sk_buff **pskb,
+		     unsigned int protoff,
+		     struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo)
+{
+	struct tftphdr _tftph, *tfh;
+	struct nf_conntrack_expect *exp;
+	unsigned int ret = NF_ACCEPT;
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
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
+
+		exp->tuple.src.l3num = family;
+		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		exp->mask.src.l3num = htons(0xFFFF);
+		if (family == AF_INET) {
+			exp->mask.src.u3.ip = htonl(0xffffffff);
+			exp->mask.dst.u3.ip = htonl(0xffffffff);
+		} else {
+			memset(&exp->mask.src.u3, 0xff, sizeof(exp->mask.src.u3));
+			memset(&exp->mask.dst.u3, 0xff, sizeof(exp->mask.src.u3));
+		}
+		exp->mask.src.u.udp.port = 0;
+		exp->mask.dst.u.udp.port = htons(0xffff);
+		exp->mask.dst.protonum = 0xff;
+		exp->expectfn = NULL;
+		exp->flags = 0;
+
+		DEBUGP("expect: ");
+		NF_CT_DUMP_TUPLE(&exp->tuple);
+		NF_CT_DUMP_TUPLE(&exp->mask);
+		if (nf_nat_tftp_hook && ct->status & IPS_NAT_MASK)
+			ret = nf_nat_tftp_hook(pskb, ctinfo, exp);
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
+static struct nf_conntrack_helper tftp[MAX_PORTS][2];
+static char tftp_names[MAX_PORTS][2][sizeof("tftp-65535")];
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

--------------000601010908010503070008--
