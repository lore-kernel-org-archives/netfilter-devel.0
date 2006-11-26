From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
Subject: [PATCH] SANE conntrack helper
Date: Sun, 26 Nov 2006 21:09:32 +0100
Message-ID: <4569F47C.2080203@stud.feec.vutbr.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080203020103000803090605"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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
--------------080203020103000803090605
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached is nf_conntrack_sane, a netfilter connection tracking helper 
module for the SANE protocol used by the 'saned' daemon to make scanners 
available via network.
The SANE protocol uses separate control & data connections, similar to 
passive FTP. The helper module is needed to recognize the data 
connection as RELATED to the control one.

Signed-off-by: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>

--------------080203020103000803090605
Content-Type: text/x-patch;
 name="conntrack-sane.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-sane.patch"

diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
new file mode 100644
index 0000000..3119173
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -0,0 +1,21 @@
+#ifndef _NF_CONNTRACK_SANE_H
+#define _NF_CONNTRACK_SANE_H
+/* SANE tracking. */
+
+#ifdef __KERNEL__
+
+#define SANE_PORT	6566
+
+enum sane_state {
+	SANE_STATE_NORMAL,
+	SANE_STATE_START_REQUESTED,
+};
+
+/* This structure exists only once per master */
+struct ip_ct_sane_master {
+	enum sane_state state;
+};
+
+#endif /* __KERNEL__ */
+
+#endif /* _NF_CONNTRACK_SANE_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 1fbd819..a4fbdcb 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -41,11 +41,13 @@ union nf_conntrack_expect_proto {
 
 /* Add protocol helper include file here */
 #include <linux/netfilter/nf_conntrack_ftp.h>
+#include <linux/netfilter/nf_conntrack_sane.h>
 
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
 	/* insert conntrack helper private data (master) here */
 	struct ip_ct_ftp_master ct_ftp_info;
+	struct ip_ct_sane_master ct_sane_info;
 };
 
 #include <linux/types.h>
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f619c65..a979042 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -107,6 +107,23 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_SANE
+	tristate "SANE support on new connection tracking (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  SANE is a protocol for remote access to scanners as implemented
+	  by the 'saned' daemon. Like FTP, it uses separate control and
+	  data connections.
+	  Tracking SANE connections is problematic: special helpers are
+	  required for tracking them, and doing masquerading and other forms
+	  of Network Address Translation on them.
+
+	  This is SANE support on Layer 3 independent connection tracking.
+	  Layer 3 independent connection tracking is experimental scheme
+	  which generalize ip_conntrack to support other layer 3 protocols.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index a74be49..f139e06 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_NF_CT_NETLINK) += nf_conntr
 
 # connection tracking helpers
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
+obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
new file mode 100644
index 0000000..129fffb
--- /dev/null
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -0,0 +1,286 @@
+/* SANE connection tracking helper
+ * (SANE = Scanner Access Now Easy)
+ */
+
+/* (C) 2006 Michal Schmidt
+ * Based on the FTP conntrack helper (net/netfilter/nf_conntrack_ftp.c)
+ * (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ * (C) 2003 Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * For documentation about the SANE network protocol see
+ * http://www.sane-project.org/html/doc015.html
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/ctype.h>
+#include <linux/inet.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_sane.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michal Schmidt <xschmi00@stud.feec.vutbr.cz>");
+MODULE_DESCRIPTION("SANE connection tracking helper");
+
+static char *sane_buffer;
+
+static DEFINE_SPINLOCK(nf_sane_lock);
+
+#define MAX_PORTS 8
+static u_int16_t ports[MAX_PORTS];
+static unsigned int ports_c;
+module_param_array(ports, ushort, &ports_c, 0400);
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#define SANE_NET_START      7   /* RPC code */
+#define SANE_STATUS_SUCCESS 0   /* RPC reply */
+
+static int help(struct sk_buff **pskb,
+		unsigned int protoff,
+		struct nf_conn *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	unsigned int dataoff, datalen;
+	struct tcphdr _tcph, *th;
+	char *sb_ptr;
+	int ret;
+	u32 seq;
+	int dir = CTINFO2DIR(ctinfo);
+	struct ip_ct_sane_master *ct_sane_info = &nfct_help(ct)->help.ct_sane_info;
+	struct nf_conntrack_expect *exp;
+
+	u32 sane_command;
+	u32 sane_status;
+	u32 sane_port;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED
+	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
+		DEBUGP("sane: Conntrackinfo = %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	th = skb_header_pointer(*pskb, protoff, sizeof(_tcph), &_tcph);
+	if (th == NULL)
+		return NF_ACCEPT;
+
+	dataoff = protoff + th->doff * 4;
+	/* No data? */
+	if (dataoff >= (*pskb)->len) {
+		return NF_ACCEPT;
+	}
+	datalen = (*pskb)->len - dataoff;
+
+	spin_lock_bh(&nf_sane_lock);
+	sb_ptr = skb_header_pointer(*pskb, dataoff, datalen, sane_buffer);
+	BUG_ON(sb_ptr == NULL);
+
+	seq = ntohl(th->seq) + datalen;
+
+	if (dir == IP_CT_DIR_ORIGINAL) {
+		if (datalen < 4) {
+			if (net_ratelimit())
+				printk(KERN_NOTICE "conntrack_sane: data "
+				       "too short (%u bytes)\n", datalen);
+			ret = NF_DROP;
+			goto out;
+		}
+
+		sane_command = ntohl(*(u32 *)sb_ptr);
+
+		if (sane_command != SANE_NET_START) {
+			/* Not an interesting command */
+			ct_sane_info->state = SANE_STATE_NORMAL;
+			ret = NF_ACCEPT;
+			goto out;
+		}
+
+		/* We're interested in the next reply */
+		ct_sane_info->state = SANE_STATE_START_REQUESTED;
+		ret = NF_ACCEPT;
+		goto out;
+	}
+
+	/* It's a reply ... */
+
+	if (ct_sane_info->state != SANE_STATE_START_REQUESTED) {
+		/* ... to an uninteresting command. */
+		ret = NF_ACCEPT;
+		goto out;
+	}
+
+	/* It's a reply to SANE_NET_START */
+	if (datalen < 8) {
+		if (net_ratelimit())
+			printk(KERN_NOTICE "conntrack_sane: reply "
+			       "too short (%u bytes)\n", datalen);
+		ret = NF_DROP;
+		goto out;
+	}
+
+	/* OK, we're picking it up. Reset the state. */
+	ct_sane_info->state = SANE_STATE_NORMAL;
+
+	sane_status = ntohl(*(u32 *)sb_ptr);
+	if (sane_status != SANE_STATUS_SUCCESS) {
+		/* saned refused the command */
+		DEBUGP("sane: unsuccessful SANE_STATUS = %u\n",
+			sane_status);
+		ret = NF_ACCEPT;
+		goto out;
+	}
+
+	sane_port = ntohl(*(u32 *)(sb_ptr+4));
+	if (sane_port > 0xffff)	{
+		if (net_ratelimit())
+			printk(KERN_NOTICE "conntrack_sane: invalid port "
+			                   "in reply: %u\n", sane_port);
+		ret = NF_ACCEPT;
+		goto out;
+	}
+	DEBUGP("sane: Expecting data connection to port %u.\n", sane_port);
+
+	exp = nf_conntrack_expect_alloc(ct);
+	if (exp == NULL) {
+		ret = NF_DROP;
+		goto out;
+	}
+
+	exp->tuple.dst.u3 = ct->tuplehash[!dir].tuple.dst.u3;
+	exp->tuple.src.u3 = ct->tuplehash[!dir].tuple.src.u3;
+	exp->tuple.src.l3num = ct->tuplehash[dir].tuple.src.l3num;
+	exp->tuple.src.u.tcp.port = 0;
+	exp->tuple.dst.u.tcp.port = htons(sane_port);
+	exp->tuple.dst.protonum = IPPROTO_TCP;
+
+	exp->mask = (struct nf_conntrack_tuple)
+		    { .src = { .l3num = 0xFFFF,
+			       .u = { .tcp = { 0 }},
+			     },
+		      .dst = { .protonum = 0xFF,
+			       .u = { .tcp = { 0xFFFF }},
+			     },
+		    };
+	if (ct->tuplehash[dir].tuple.src.l3num == PF_INET) {
+		exp->mask.src.u3.ip = 0xFFFFFFFF;
+		exp->mask.dst.u3.ip = 0xFFFFFFFF;
+	} else {
+		memset(exp->mask.src.u3.ip6, 0xFF,
+		       sizeof(exp->mask.src.u3.ip6));
+		memset(exp->mask.dst.u3.ip6, 0xFF,
+		       sizeof(exp->mask.src.u3.ip6));
+	}
+
+	exp->expectfn = NULL;
+	exp->flags = 0;
+
+	/* Can't expect this?  Best to drop packet now. */
+	if (nf_conntrack_expect_related(exp) != 0)
+		ret = NF_DROP;
+	else
+		ret = NF_ACCEPT;
+
+
+	/* TODO: NAT */
+
+	nf_conntrack_expect_put(exp);
+
+out:
+	spin_unlock_bh(&nf_sane_lock);
+	return ret;
+}
+
+static struct nf_conntrack_helper sane[MAX_PORTS][2];
+static char sane_names[MAX_PORTS][2][sizeof("sane-65535")];
+
+/* don't make this __exit, since it's called from __init ! */
+static void nf_conntrack_sane_fini(void)
+{
+	int i, j;
+	for (i = 0; i < ports_c; i++) {
+		for (j = 0; j < 2; j++) {
+			if (sane[i][j].me == NULL)
+				continue;
+
+			DEBUGP("nf_ct_sane: unregistering helper for pf: %d "
+			       "port: %d\n",
+				sane[i][j].tuple.src.l3num, ports[i]);
+			nf_conntrack_helper_unregister(&sane[i][j]);
+		}
+	}
+
+	kfree(sane_buffer);
+}
+
+static int __init nf_conntrack_sane_init(void)
+{
+	int i, j = -1, ret = 0;
+	char *tmpname;
+
+	sane_buffer = kmalloc(65536, GFP_KERNEL);
+	if (!sane_buffer)
+		return -ENOMEM;
+
+	if (ports_c == 0)
+		ports[ports_c++] = SANE_PORT;
+
+	/* FIXME should be configurable whether IPv4 and IPv6 SANE connections
+		 are tracked or not - YK */
+	for (i = 0; i < ports_c; i++) {
+		sane[i][0].tuple.src.l3num = PF_INET;
+		sane[i][1].tuple.src.l3num = PF_INET6;
+		for (j = 0; j < 2; j++) {
+			sane[i][j].tuple.src.u.tcp.port = htons(ports[i]);
+			sane[i][j].tuple.dst.protonum = IPPROTO_TCP;
+			sane[i][j].mask.src.u.tcp.port = 0xFFFF;
+			sane[i][j].mask.dst.protonum = 0xFF;
+			sane[i][j].max_expected = 1;
+			sane[i][j].timeout = 5 * 60;	/* 5 Minutes */
+			sane[i][j].me = THIS_MODULE;
+			sane[i][j].help = help;
+			tmpname = &sane_names[i][j][0];
+			if (ports[i] == SANE_PORT)
+				sprintf(tmpname, "sane");
+			else
+				sprintf(tmpname, "sane-%d", ports[i]);
+			sane[i][j].name = tmpname;
+
+			DEBUGP("nf_ct_sane: registering helper for pf: %d "
+			       "port: %d\n",
+				sane[i][j].tuple.src.l3num, ports[i]);
+			ret = nf_conntrack_helper_register(&sane[i][j]);
+			if (ret) {
+				printk(KERN_ERR "nf_ct_sane: failed to "
+				       "register helper for pf: %d port: %d\n",
+					sane[i][j].tuple.src.l3num, ports[i]);
+				nf_conntrack_sane_fini();
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+module_init(nf_conntrack_sane_init);
+module_exit(nf_conntrack_sane_fini);

--------------080203020103000803090605--
