From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/15]: Add SANE connection tracking helper
Date: Wed,  7 Feb 2007 09:22:30 +0100 (MET)
Message-ID: <20070207082230.27478.24679.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Add SANE connection tracking helper

This is nf_conntrack_sane, a netfilter connection tracking helper module
for the SANE protocol used by the 'saned' daemon to make scanners available
via network. The SANE protocol uses separate control & data connections,
similar to passive FTP. The helper module is needed to recognize the data
connection as RELATED to the control one.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 75a10dc02458b33d7b14b388ca51ad2b91e81fd4
tree 29cf5cb4e665f67d28616fe50e29b8de40562294
parent 3d2362a6ba4b73a93179fdd340b961f9ef6fe1d8
author Michal Schmidt <mschmidt@redhat.com> Tue, 06 Feb 2007 07:36:47 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:47 +0100

 include/linux/netfilter/nf_conntrack_sane.h |   21 ++
 include/net/netfilter/nf_conntrack.h        |    2 
 net/netfilter/Kconfig                       |   13 +
 net/netfilter/Makefile                      |    1 
 net/netfilter/nf_conntrack_sane.c           |  242 +++++++++++++++++++++++++++
 5 files changed, 279 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
new file mode 100644
index 0000000..4767d6e
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
+struct nf_ct_sane_master {
+	enum sane_state state;
+};
+
+#endif /* __KERNEL__ */
+
+#endif /* _NF_CONNTRACK_SANE_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bd01b46..68ec274 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,6 +45,7 @@ union nf_conntrack_expect_proto {
 #include <linux/netfilter/nf_conntrack_ftp.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
+#include <linux/netfilter/nf_conntrack_sane.h>
 
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
@@ -52,6 +53,7 @@ union nf_conntrack_help {
 	struct nf_ct_ftp_master ct_ftp_info;
 	struct nf_ct_pptp_master ct_pptp_info;
 	struct nf_ct_h323_master ct_h323_info;
+	struct nf_ct_sane_master ct_sane_info;
 };
 
 #include <linux/types.h>
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 80107d4..614c92c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -235,6 +235,19 @@ config NF_CONNTRACK_PPTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_SANE
+	tristate "SANE protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  SANE is a protocol for remote access to scanners as implemented
+	  by the 'saned' daemon. Like FTP, it uses separate control and
+	  data connections.
+
+	  With this module you can support SANE on a connection tracking
+	  firewall.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CONNTRACK_SIP
 	tristate "SIP protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5dc5574..5054b0f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_NF_CONNTRACK_H323) += nf_co
 obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_conntrack_irc.o
 obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o
 obj-$(CONFIG_NF_CONNTRACK_PPTP) += nf_conntrack_pptp.o
+obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
new file mode 100644
index 0000000..eb2d1dc
--- /dev/null
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -0,0 +1,242 @@
+/* SANE connection tracking helper
+ * (SANE = Scanner Access Now Easy)
+ * For documentation about the SANE network protocol see
+ * http://www.sane-project.org/html/doc015.html
+ */
+
+/* Copyright (C) 2007 Red Hat, Inc.
+ * Author: Michal Schmidt <mschmidt@redhat.com>
+ * Based on the FTP conntrack helper (net/netfilter/nf_conntrack_ftp.c):
+ *  (C) 1999-2001 Paul `Rusty' Russell
+ *  (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *  (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ *  (C) 2003 Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netfilter.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_sane.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
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
+struct sane_request {
+	__be32 RPC_code;
+#define SANE_NET_START      7   /* RPC code */
+
+	__be32 handle;
+};
+
+struct sane_reply_net_start {
+	__be32 status;
+#define SANE_STATUS_SUCCESS 0
+
+	__be16 zero;
+	__be16 port;
+	/* other fields aren't interesting for conntrack */
+};
+
+static int help(struct sk_buff **pskb,
+		unsigned int protoff,
+		struct nf_conn *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	unsigned int dataoff, datalen;
+	struct tcphdr _tcph, *th;
+	char *sb_ptr;
+	int ret = NF_ACCEPT;
+	int dir = CTINFO2DIR(ctinfo);
+	struct nf_ct_sane_master *ct_sane_info;
+	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_tuple *tuple;
+	struct sane_request *req;
+	struct sane_reply_net_start *reply;
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+
+	ct_sane_info = &nfct_help(ct)->help.ct_sane_info;
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED &&
+	    ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
+		return NF_ACCEPT;
+
+	/* Not a full tcp header? */
+	th = skb_header_pointer(*pskb, protoff, sizeof(_tcph), &_tcph);
+	if (th == NULL)
+		return NF_ACCEPT;
+
+	/* No data? */
+	dataoff = protoff + th->doff * 4;
+	if (dataoff >= (*pskb)->len)
+		return NF_ACCEPT;
+
+	datalen = (*pskb)->len - dataoff;
+
+	spin_lock_bh(&nf_sane_lock);
+	sb_ptr = skb_header_pointer(*pskb, dataoff, datalen, sane_buffer);
+	BUG_ON(sb_ptr == NULL);
+
+	if (dir == IP_CT_DIR_ORIGINAL) {
+		if (datalen != sizeof(struct sane_request))
+			goto out;
+
+		req = (struct sane_request *)sb_ptr;
+		if (req->RPC_code != htonl(SANE_NET_START)) {
+			/* Not an interesting command */
+			ct_sane_info->state = SANE_STATE_NORMAL;
+			goto out;
+		}
+
+		/* We're interested in the next reply */
+		ct_sane_info->state = SANE_STATE_START_REQUESTED;
+		goto out;
+	}
+
+	/* Is it a reply to an uninteresting command? */
+	if (ct_sane_info->state != SANE_STATE_START_REQUESTED)
+		goto out;
+
+	/* It's a reply to SANE_NET_START. */
+	ct_sane_info->state = SANE_STATE_NORMAL;
+
+	if (datalen < sizeof(struct sane_reply_net_start)) {
+		DEBUGP("nf_ct_sane: NET_START reply too short\n");
+		goto out;
+	}
+
+	reply = (struct sane_reply_net_start *)sb_ptr;
+	if (reply->status != htonl(SANE_STATUS_SUCCESS)) {
+		/* saned refused the command */
+		DEBUGP("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
+			ntohl(reply->status));
+		goto out;
+	}
+
+	/* Invalid saned reply? Ignore it. */
+	if (reply->zero != 0)
+		goto out;
+
+	exp = nf_conntrack_expect_alloc(ct);
+	if (exp == NULL) {
+		ret = NF_DROP;
+		goto out;
+	}
+
+	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	nf_conntrack_expect_init(exp, family,
+				 &tuple->src.u3, &tuple->dst.u3,
+				 IPPROTO_TCP,
+				 NULL, &reply->port);
+
+	DEBUGP("nf_ct_sane: expect: ");
+	NF_CT_DUMP_TUPLE(&exp->tuple);
+	NF_CT_DUMP_TUPLE(&exp->mask);
+
+	/* Can't expect this?  Best to drop packet now. */
+	if (nf_conntrack_expect_related(exp) != 0)
+		ret = NF_DROP;
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
+
+	for (i = 0; i < ports_c; i++) {
+		for (j = 0; j < 2; j++) {
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
+	/* FIXME should be configurable whether IPv4 and IPv6 connections
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
