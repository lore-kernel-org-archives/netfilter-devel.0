From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/20]: nf_nat: add FTP NAT helper port
Date: Sat,  2 Dec 2006 15:49:50 +0100 (MET)
Message-ID: <20061202145254.1381.82950.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: add FTP NAT helper port

Add FTP NAT helper.

Split out from Jozsef's big nf_nat patch with a few small fixes by myself.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c36fe54cbb2515da933901095b4df503d9943bfd
tree bbf545c88377c653114b4fb759e3e52438690962
parent 1c341bc77a3d189d65ce0455640ac03a1dc293da
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:05 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:05 +0100

 include/linux/netfilter/nf_conntrack_ftp.h      |   20 +--
 include/linux/netfilter_ipv4/ip_conntrack_ftp.h |   40 +++++
 include/net/netfilter/nf_conntrack.h            |    2 
 net/ipv4/netfilter/Kconfig                      |   25 ++-
 net/ipv4/netfilter/Makefile                     |    5 +
 net/ipv4/netfilter/nf_nat_ftp.c                 |  179 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_ftp.c                |   20 +--
 7 files changed, 260 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index ad4a41c..81453ea 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -3,16 +3,16 @@ #define _NF_CONNTRACK_FTP_H
 /* FTP tracking. */
 
 /* This enum is exposed to userspace */
-enum ip_ct_ftp_type
+enum nf_ct_ftp_type
 {
 	/* PORT command from client */
-	IP_CT_FTP_PORT,
+	NF_CT_FTP_PORT,
 	/* PASV response from server */
-	IP_CT_FTP_PASV,
+	NF_CT_FTP_PASV,
 	/* EPRT command from client */
-	IP_CT_FTP_EPRT,
+	NF_CT_FTP_EPRT,
 	/* EPSV response from server */
-	IP_CT_FTP_EPSV,
+	NF_CT_FTP_EPSV,
 };
 
 #ifdef __KERNEL__
@@ -21,23 +21,23 @@ #define FTP_PORT	21
 
 #define NUM_SEQ_TO_REMEMBER 2
 /* This structure exists only once per master */
-struct ip_ct_ftp_master {
+struct nf_ct_ftp_master {
 	/* Valid seq positions for cmd matching after newline */
 	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
 	/* 0 means seq_match_aft_nl not set */
 	int seq_aft_nl_num[IP_CT_DIR_MAX];
 };
 
-struct ip_conntrack_expect;
+struct nf_conntrack_expect;
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
+extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				       enum ip_conntrack_info ctinfo,
-				       enum ip_ct_ftp_type type,
+				       enum nf_ct_ftp_type type,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
-				       struct ip_conntrack_expect *exp,
+				       struct nf_conntrack_expect *exp,
 				       u32 *seq);
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/netfilter_ipv4/ip_conntrack_ftp.h b/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
index 6381193..2129fc3 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
@@ -1,6 +1,44 @@
 #ifndef _IP_CONNTRACK_FTP_H
 #define _IP_CONNTRACK_FTP_H
+/* FTP tracking. */
 
-#include <linux/netfilter/nf_conntrack_ftp.h>
+/* This enum is exposed to userspace */
+enum ip_ct_ftp_type
+{
+	/* PORT command from client */
+	IP_CT_FTP_PORT,
+	/* PASV response from server */
+	IP_CT_FTP_PASV,
+	/* EPRT command from client */
+	IP_CT_FTP_EPRT,
+	/* EPSV response from server */
+	IP_CT_FTP_EPSV,
+};
+
+#ifdef __KERNEL__
+
+#define FTP_PORT	21
+
+#define NUM_SEQ_TO_REMEMBER 2
+/* This structure exists only once per master */
+struct ip_ct_ftp_master {
+	/* Valid seq positions for cmd matching after newline */
+	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
+	/* 0 means seq_match_aft_nl not set */
+	int seq_aft_nl_num[IP_CT_DIR_MAX];
+};
+
+struct ip_conntrack_expect;
+
+/* For NAT to hook in when we find a packet which describes what other
+ * connection we should expect. */
+extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
+				       enum ip_conntrack_info ctinfo,
+				       enum ip_ct_ftp_type type,
+				       unsigned int matchoff,
+				       unsigned int matchlen,
+				       struct ip_conntrack_expect *exp,
+				       u32 *seq);
+#endif /* __KERNEL__ */
 
 #endif /* _IP_CONNTRACK_FTP_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9948af0..83694cf 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,7 +45,7 @@ #include <linux/netfilter/nf_conntrack_f
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
 	/* insert conntrack helper private data (master) here */
-	struct ip_ct_ftp_master ct_ftp_info;
+	struct nf_ct_ftp_master ct_ftp_info;
 };
 
 #include <linux/types.h>
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 01789ae..52f876d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -477,20 +477,29 @@ config IP_NF_NAT_SNMP_BASIC
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+# If they want FTP, set to $CONFIG_IP_NF_NAT (m or y),
+# or $CONFIG_IP_NF_FTP (m or y), whichever is weaker.
+# From kconfig-language.txt:
+#
+#           <expr> '&&' <expr>                   (6)
+#
+# (6) Returns the result of min(/expr/, /expr/).
+config IP_NF_NAT_FTP
+	tristate
+	depends on IP_NF_IPTABLES && IP_NF_CONNTRACK && IP_NF_NAT
+	default IP_NF_NAT && IP_NF_FTP
+
+config NF_NAT_FTP
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_FTP
+
 config IP_NF_NAT_IRC
 	tristate
 	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
 	default IP_NF_NAT if IP_NF_IRC=y
 	default m if IP_NF_IRC=m
 
-# If they want FTP, set to $CONFIG_IP_NF_NAT (m or y), 
-# or $CONFIG_IP_NF_FTP (m or y), whichever is weaker.  Argh.
-config IP_NF_NAT_FTP
-	tristate
-	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
-	default IP_NF_NAT if IP_NF_FTP=y
-	default m if IP_NF_FTP=m
-
 config IP_NF_NAT_TFTP
 	tristate
 	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index ec31690..c0c6194 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_IP_NF_IRC) += ip_conntrack_
 obj-$(CONFIG_IP_NF_SIP) += ip_conntrack_sip.o
 obj-$(CONFIG_IP_NF_NETBIOS_NS) += ip_conntrack_netbios_ns.o
 
-# NAT helpers 
+# NAT helpers (ip_conntrack)
 obj-$(CONFIG_IP_NF_NAT_H323) += ip_nat_h323.o
 obj-$(CONFIG_IP_NF_NAT_PPTP) += ip_nat_pptp.o
 obj-$(CONFIG_IP_NF_NAT_AMANDA) += ip_nat_amanda.o
@@ -49,6 +49,9 @@ obj-$(CONFIG_IP_NF_NAT_FTP) += ip_nat_ft
 obj-$(CONFIG_IP_NF_NAT_IRC) += ip_nat_irc.o
 obj-$(CONFIG_IP_NF_NAT_SIP) += ip_nat_sip.o
 
+# NAT helpers (nf_conntrack)
+obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
+
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
new file mode 100644
index 0000000..751b598
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -0,0 +1,179 @@
+/* FTP extension for TCP NAT alteration. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_ftp.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("ftp NAT helper");
+MODULE_ALIAS("ip_nat_ftp");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* FIXME: Time out? --RR */
+
+static int
+mangle_rfc959_packet(struct sk_buff **pskb,
+		     __be32 newip,
+		     u_int16_t port,
+		     unsigned int matchoff,
+		     unsigned int matchlen,
+		     struct nf_conn *ct,
+		     enum ip_conntrack_info ctinfo,
+		     u32 *seq)
+{
+	char buffer[sizeof("nnn,nnn,nnn,nnn,nnn,nnn")];
+
+	sprintf(buffer, "%u,%u,%u,%u,%u,%u",
+		NIPQUAD(newip), port>>8, port&0xFF);
+
+	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+
+	*seq += strlen(buffer) - matchlen;
+	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
+					matchlen, buffer, strlen(buffer));
+}
+
+/* |1|132.235.1.2|6275| */
+static int
+mangle_eprt_packet(struct sk_buff **pskb,
+		   __be32 newip,
+		   u_int16_t port,
+		   unsigned int matchoff,
+		   unsigned int matchlen,
+		   struct nf_conn *ct,
+		   enum ip_conntrack_info ctinfo,
+		   u32 *seq)
+{
+	char buffer[sizeof("|1|255.255.255.255|65535|")];
+
+	sprintf(buffer, "|1|%u.%u.%u.%u|%u|", NIPQUAD(newip), port);
+
+	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+
+	*seq += strlen(buffer) - matchlen;
+	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
+					matchlen, buffer, strlen(buffer));
+}
+
+/* |1|132.235.1.2|6275| */
+static int
+mangle_epsv_packet(struct sk_buff **pskb,
+		   __be32 newip,
+		   u_int16_t port,
+		   unsigned int matchoff,
+		   unsigned int matchlen,
+		   struct nf_conn *ct,
+		   enum ip_conntrack_info ctinfo,
+		   u32 *seq)
+{
+	char buffer[sizeof("|||65535|")];
+
+	sprintf(buffer, "|||%u|", port);
+
+	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+
+	*seq += strlen(buffer) - matchlen;
+	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
+					matchlen, buffer, strlen(buffer));
+}
+
+static int (*mangle[])(struct sk_buff **, __be32, u_int16_t,
+		       unsigned int, unsigned int, struct nf_conn *,
+		       enum ip_conntrack_info, u32 *seq)
+= {
+	[NF_CT_FTP_PORT] = mangle_rfc959_packet,
+	[NF_CT_FTP_PASV] = mangle_rfc959_packet,
+	[NF_CT_FTP_EPRT] = mangle_eprt_packet,
+	[NF_CT_FTP_EPSV] = mangle_epsv_packet
+};
+
+/* So, this packet has hit the connection tracking matching code.
+   Mangle it, and change the expectation to match the new version. */
+static unsigned int nf_nat_ftp(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       enum nf_ct_ftp_type type,
+			       unsigned int matchoff,
+			       unsigned int matchlen,
+			       struct nf_conntrack_expect *exp,
+			       u32 *seq)
+{
+	__be32 newip;
+	u_int16_t port;
+	int dir = CTINFO2DIR(ctinfo);
+	struct nf_conn *ct = exp->master;
+
+	DEBUGP("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
+
+	/* Connection will come from wherever this packet goes, hence !dir */
+	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one. */
+	exp->expectfn = nf_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
+		exp->tuple.dst.u.tcp.port = htons(port);
+		if (nf_conntrack_expect_related(exp) == 0)
+			break;
+	}
+
+	if (port == 0)
+		return NF_DROP;
+
+	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo,
+			  seq)) {
+		nf_conntrack_unexpect_related(exp);
+		return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
+static void __exit nf_nat_ftp_fini(void)
+{
+	rcu_assign_pointer(nf_nat_ftp_hook, NULL);
+	synchronize_rcu();
+}
+
+static int __init nf_nat_ftp_init(void)
+{
+	BUG_ON(rcu_dereference(nf_nat_ftp_hook));
+	rcu_assign_pointer(nf_nat_ftp_hook, nf_nat_ftp);
+	return 0;
+}
+
+/* Prior to 2.6.11, we had a ports param.  No longer, but don't break users. */
+static int warn_set(const char *val, struct kernel_param *kp)
+{
+	printk(KERN_INFO KBUILD_MODNAME
+	       ": kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
+	return 0;
+}
+module_param_call(ports, warn_set, NULL, NULL, 0);
+
+module_init(nf_nat_ftp_init);
+module_exit(nf_nat_ftp_fini);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index e299d65..92a9471 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -51,7 +51,7 @@ module_param(loose, bool, 0600);
 
 unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
-				enum ip_ct_ftp_type type,
+				enum nf_ct_ftp_type type,
 				unsigned int matchoff,
 				unsigned int matchlen,
 				struct nf_conntrack_expect *exp,
@@ -74,7 +74,7 @@ static struct ftp_search {
 	size_t plen;
 	char skip;
 	char term;
-	enum ip_ct_ftp_type ftptype;
+	enum nf_ct_ftp_type ftptype;
 	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char);
 } search[IP_CT_DIR_MAX][2] = {
 	[IP_CT_DIR_ORIGINAL] = {
@@ -83,7 +83,7 @@ static struct ftp_search {
 			.plen		= sizeof("PORT") - 1,
 			.skip		= ' ',
 			.term		= '\r',
-			.ftptype	= IP_CT_FTP_PORT,
+			.ftptype	= NF_CT_FTP_PORT,
 			.getnum		= try_rfc959,
 		},
 		{
@@ -91,7 +91,7 @@ static struct ftp_search {
 			.plen		= sizeof("EPRT") - 1,
 			.skip		= ' ',
 			.term		= '\r',
-			.ftptype	= IP_CT_FTP_EPRT,
+			.ftptype	= NF_CT_FTP_EPRT,
 			.getnum		= try_eprt,
 		},
 	},
@@ -101,7 +101,7 @@ static struct ftp_search {
 			.plen		= sizeof("227 ") - 1,
 			.skip		= '(',
 			.term		= ')',
-			.ftptype	= IP_CT_FTP_PASV,
+			.ftptype	= NF_CT_FTP_PASV,
 			.getnum		= try_rfc959,
 		},
 		{
@@ -109,7 +109,7 @@ static struct ftp_search {
 			.plen		= sizeof("229 ") - 1,
 			.skip		= '(',
 			.term		= ')',
-			.ftptype	= IP_CT_FTP_EPSV,
+			.ftptype	= NF_CT_FTP_EPSV,
 			.getnum		= try_epsv_response,
 		},
 	},
@@ -320,7 +320,7 @@ #endif
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct nf_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -331,7 +331,7 @@ static int find_nl_seq(u32 seq, const st
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir,
+static void update_nl_seq(u32 nl_seq, struct nf_ct_ftp_master *info, int dir,
 			  struct sk_buff *skb)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
@@ -367,7 +367,7 @@ static int help(struct sk_buff **pskb,
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
-	struct ip_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
+	struct nf_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_man cmd = {};
 	unsigned int i;
@@ -523,7 +523,7 @@ static int help(struct sk_buff **pskb,
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
 	nf_nat_ftp = rcu_dereference(nf_nat_ftp_hook);
-	if (nf_nat_ftp)
+	if (nf_nat_ftp && ct->status & IPS_NAT_MASK)
 		ret = nf_nat_ftp(pskb, ctinfo, search[dir][i].ftptype,
 				 matchoff, matchlen, exp, &seq);
 	else {
