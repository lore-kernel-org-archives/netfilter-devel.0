From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/20]: nf_conntrack/nf_nat: add IRC helper port
Date: Sat,  2 Dec 2006 15:49:58 +0100 (MET)
Message-ID: <20061202145303.1381.11734.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port

Add nf_conntrack port of the IRC conntrack/NAT helper. Since DCC doesn't
support IPv6 yet, the helper is still IPv4 only.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 40f6096353cbb0a314c42355ad927c54a849d092
tree 38e7783febc87a8b53c27c09ebdb28c4d5001b0f
parent b8dfee1057b0a3515ec561fd928e49204bbc4c4a
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:14 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:14 +0100

 include/linux/netfilter/nf_conntrack_irc.h |   15 +
 net/ipv4/netfilter/Kconfig                 |    5 
 net/ipv4/netfilter/Makefile                |    1 
 net/ipv4/netfilter/nf_nat_irc.c            |  101 ++++++++++
 net/netfilter/Kconfig                      |   15 +
 net/netfilter/Makefile                     |    1 
 net/netfilter/nf_conntrack_irc.c           |  281 ++++++++++++++++++++++++++++
 7 files changed, 419 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
new file mode 100644
index 0000000..2ab6b82
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -0,0 +1,15 @@
+#ifndef _NF_CONNTRACK_IRC_H
+#define _NF_CONNTRACK_IRC_H
+
+#ifdef __KERNEL__
+
+#define IRC_PORT	6667
+
+extern unsigned int (*nf_nat_irc_hook)(struct sk_buff **pskb,
+				       enum ip_conntrack_info ctinfo,
+				       unsigned int matchoff,
+				       unsigned int matchlen,
+				       struct nf_conntrack_expect *exp);
+
+#endif /* __KERNEL__ */
+#endif /* _NF_CONNTRACK_IRC_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index e14156d..4555f72 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -500,6 +500,11 @@ config IP_NF_NAT_IRC
 	default IP_NF_NAT if IP_NF_IRC=y
 	default m if IP_NF_IRC=m
 
+config NF_NAT_IRC
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_IRC
+
 config IP_NF_NAT_TFTP
 	tristate
 	depends on IP_NF_IPTABLES!=n && IP_NF_CONNTRACK!=n && IP_NF_NAT!=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index bdaba47..56733c3 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -53,6 +53,7 @@ # NAT helpers (nf_conntrack)
 obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
 obj-$(CONFIG_NF_NAT_H323) += nf_nat_h323.o
+obj-$(CONFIG_NF_NAT_IRC) += nf_nat_irc.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_nat_irc.c b/net/ipv4/netfilter/nf_nat_irc.c
new file mode 100644
index 0000000..9b8c0da
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_irc.c
@@ -0,0 +1,101 @@
+/* IRC extension for TCP NAT alteration.
+ *
+ * (C) 2000-2001 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2004 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * based on a copy of RR's ip_nat_ftp.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/tcp.h>
+#include <linux/kernel.h>
+
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_irc.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
+MODULE_DESCRIPTION("IRC (DCC) NAT helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_nat_irc");
+
+static unsigned int help(struct sk_buff **pskb,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int matchoff,
+			 unsigned int matchlen,
+			 struct nf_conntrack_expect *exp)
+{
+	char buffer[sizeof("4294967296 65635")];
+	u_int32_t ip;
+	u_int16_t port;
+	unsigned int ret;
+
+	DEBUGP("IRC_NAT: info (seq %u + %u) in %u\n",
+	       expect->seq, exp_irc_info->len, ntohl(tcph->seq));
+
+	/* Reply comes from server. */
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = IP_CT_DIR_REPLY;
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
+	ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
+	sprintf(buffer, "%u %u", ip, port);
+	DEBUGP("nf_nat_irc: inserting '%s' == %u.%u.%u.%u, port %u\n",
+	       buffer, NIPQUAD(ip), port);
+
+	ret = nf_nat_mangle_tcp_packet(pskb, exp->master, ctinfo,
+				       matchoff, matchlen, buffer,
+				       strlen(buffer));
+	if (ret != NF_ACCEPT)
+		nf_conntrack_unexpect_related(exp);
+	return ret;
+}
+
+static void __exit nf_nat_irc_fini(void)
+{
+	rcu_assign_pointer(nf_nat_irc_hook, NULL);
+	synchronize_rcu();
+}
+
+static int __init nf_nat_irc_init(void)
+{
+	BUG_ON(rcu_dereference(nf_nat_irc_hook));
+	rcu_assign_pointer(nf_nat_irc_hook, help);
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
+module_init(nf_nat_irc_init);
+module_exit(nf_nat_irc_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d8f3451..bd50897 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -179,6 +179,21 @@ config NF_CONNTRACK_H323
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_IRC
+	tristate "IRC protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  There is a commonly-used extension to IRC called
+	  Direct Client-to-Client Protocol (DCC).  This enables users to send
+	  files to each other, and also chat to each other without the need
+	  of a server.  DCC Sending is used anywhere you send files over IRC,
+	  and DCC Chat is most commonly used by Eggdrop bots.  If you are
+	  using NAT, this extension will enable you to send files and initiate
+	  chats.  Note that you do NOT need this extension to get files or
+	  have others initiate chats, or everything else in IRC.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 69b5545..343fd48 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -25,6 +25,7 @@ nf_conntrack_h323-objs := nf_conntrack_h
 obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_conntrack_amanda.o
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
 obj-$(CONFIG_NF_CONNTRACK_H323) += nf_conntrack_h323.o
+obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_conntrack_irc.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
new file mode 100644
index 0000000..ed01db6
--- /dev/null
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -0,0 +1,281 @@
+/* IRC extension for IP connection tracking, Version 1.21
+ * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ * based on RR's ip_conntrack_ftp.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
+#include <linux/netfilter.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_irc.h>
+
+#define MAX_PORTS 8
+static unsigned short ports[MAX_PORTS];
+static int ports_c;
+static unsigned int max_dcc_channels = 8;
+static unsigned int dcc_timeout __read_mostly = 300;
+/* This is slow, but it's simple. --RR */
+static char *irc_buffer;
+static DEFINE_SPINLOCK(irc_buffer_lock);
+
+unsigned int (*nf_nat_irc_hook)(struct sk_buff **pskb,
+				enum ip_conntrack_info ctinfo,
+				unsigned int matchoff,
+				unsigned int matchlen,
+				struct nf_conntrack_expect *exp) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_conntrack_irc");
+
+module_param_array(ports, ushort, &ports_c, 0400);
+MODULE_PARM_DESC(ports, "port numbers of IRC servers");
+module_param(max_dcc_channels, uint, 0400);
+MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
+				   "IRC session");
+module_param(dcc_timeout, uint, 0400);
+MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
+
+static const char *dccprotos[] = {
+	"SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT "
+};
+
+#define MINMATCHLEN	5
+
+#if 0
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s:" format, \
+                                       __FILE__, __FUNCTION__ , ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* tries to get the ip_addr and port out of a dcc command
+ * return value: -1 on failure, 0 on success
+ *	data		pointer to first byte of DCC command data
+ *	data_end	pointer to last byte of dcc command data
+ *	ip		returns parsed ip of dcc command
+ *	port		returns parsed port of dcc command
+ *	ad_beg_p	returns pointer to first byte of addr data
+ *	ad_end_p	returns pointer to last byte of addr data
+ */
+static int parse_dcc(char *data, char *data_end, u_int32_t *ip,
+		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
+{
+	/* at least 12: "AAAAAAAA P\1\n" */
+	while (*data++ != ' ')
+		if (data > data_end - 12)
+			return -1;
+
+	*ad_beg_p = data;
+	*ip = simple_strtoul(data, &data, 10);
+
+	/* skip blanks between ip and port */
+	while (*data == ' ') {
+		if (data >= data_end)
+			return -1;
+		data++;
+	}
+
+	*port = simple_strtoul(data, &data, 10);
+	*ad_end_p = data;
+
+	return 0;
+}
+
+static int help(struct sk_buff **pskb, unsigned int protoff,
+		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	unsigned int dataoff;
+	struct tcphdr _tcph, *th;
+	char *data, *data_limit, *ib_ptr;
+	int dir = CTINFO2DIR(ctinfo);
+	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_tuple *tuple;
+	u_int32_t dcc_ip;
+	u_int16_t dcc_port;
+	__be16 port;
+	int i, ret = NF_ACCEPT;
+	char *addr_beg_p, *addr_end_p;
+	typeof(nf_nat_irc_hook) nf_nat_irc;
+
+	/* If packet is coming from IRC server */
+	if (dir == IP_CT_DIR_REPLY)
+		return NF_ACCEPT;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED &&
+	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY)
+		return NF_ACCEPT;
+
+	/* Not a full tcp header? */
+	th = skb_header_pointer(*pskb, protoff, sizeof(_tcph), &_tcph);
+	if (th == NULL)
+		return NF_ACCEPT;
+
+	/* No data? */
+	dataoff = protoff + th->doff*4;
+	if (dataoff >= (*pskb)->len)
+		return NF_ACCEPT;
+
+	spin_lock_bh(&irc_buffer_lock);
+	ib_ptr = skb_header_pointer(*pskb, dataoff, (*pskb)->len - dataoff,
+				    irc_buffer);
+	BUG_ON(ib_ptr == NULL);
+
+	data = ib_ptr;
+	data_limit = ib_ptr + (*pskb)->len - dataoff;
+
+	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
+	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
+	while (data < data_limit - (19 + MINMATCHLEN)) {
+		if (memcmp(data, "\1DCC ", 5)) {
+			data++;
+			continue;
+		}
+		data += 5;
+		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
+
+		DEBUGP("DCC found in master %u.%u.%u.%u:%u %u.%u.%u.%u:%u...\n",
+			NIPQUAD(iph->saddr), ntohs(th->source),
+			NIPQUAD(iph->daddr), ntohs(th->dest));
+
+		for (i = 0; i < ARRAY_SIZE(dccprotos); i++) {
+			if (memcmp(data, dccprotos[i], strlen(dccprotos[i]))) {
+				/* no match */
+				continue;
+			}
+			data += strlen(dccprotos[i]);
+			DEBUGP("DCC %s detected\n", dccprotos[i]);
+
+			/* we have at least
+			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
+			 * data left (== 14/13 bytes) */
+			if (parse_dcc((char *)data, data_limit, &dcc_ip,
+				       &dcc_port, &addr_beg_p, &addr_end_p)) {
+				DEBUGP("unable to parse dcc command\n");
+				continue;
+			}
+			DEBUGP("DCC bound ip/port: %u.%u.%u.%u:%u\n",
+				HIPQUAD(dcc_ip), dcc_port);
+
+			/* dcc_ip can be the internal OR external (NAT'ed) IP */
+			tuple = &ct->tuplehash[dir].tuple;
+			if (tuple->src.u3.ip != htonl(dcc_ip) &&
+			    tuple->dst.u3.ip != htonl(dcc_ip)) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+						"Forged DCC command from "
+						"%u.%u.%u.%u: %u.%u.%u.%u:%u\n",
+						NIPQUAD(tuple->src.u3.ip),
+						HIPQUAD(dcc_ip), dcc_port);
+				continue;
+			}
+
+			exp = nf_conntrack_expect_alloc(ct);
+			if (exp == NULL) {
+				ret = NF_DROP;
+				goto out;
+			}
+			tuple = &ct->tuplehash[!dir].tuple;
+			port = htons(dcc_port);
+			nf_conntrack_expect_init(exp, tuple->src.l3num,
+						 NULL, &tuple->dst.u3,
+						 IPPROTO_TCP, NULL, &port);
+
+			nf_nat_irc = rcu_dereference(nf_nat_irc_hook);
+			if (nf_nat_irc && ct->status & IPS_NAT_MASK)
+				ret = nf_nat_irc(pskb, ctinfo,
+						 addr_beg_p - ib_ptr,
+						 addr_end_p - addr_beg_p,
+						 exp);
+			else if (nf_conntrack_expect_related(exp) != 0)
+				ret = NF_DROP;
+			nf_conntrack_expect_put(exp);
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_bh(&irc_buffer_lock);
+	return ret;
+}
+
+static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
+static char irc_names[MAX_PORTS][sizeof("irc-65535")] __read_mostly;
+
+static void nf_conntrack_irc_fini(void);
+
+static int __init nf_conntrack_irc_init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (max_dcc_channels < 1) {
+		printk("nf_ct_irc: max_dcc_channels must not be zero\n");
+		return -EINVAL;
+	}
+
+	irc_buffer = kmalloc(65536, GFP_KERNEL);
+	if (!irc_buffer)
+		return -ENOMEM;
+
+	/* If no port given, default to standard irc port */
+	if (ports_c == 0)
+		ports[ports_c++] = IRC_PORT;
+
+	for (i = 0; i < ports_c; i++) {
+		irc[i].tuple.src.l3num = AF_INET;
+		irc[i].tuple.src.u.tcp.port = htons(ports[i]);
+		irc[i].tuple.dst.protonum = IPPROTO_TCP;
+		irc[i].mask.src.l3num = 0xFFFF;
+		irc[i].mask.src.u.tcp.port = htons(0xFFFF);
+		irc[i].mask.dst.protonum = 0xFF;
+		irc[i].max_expected = max_dcc_channels;
+		irc[i].timeout = dcc_timeout;
+		irc[i].me = THIS_MODULE;
+		irc[i].help = help;
+
+		tmpname = &irc_names[i][0];
+		if (ports[i] == IRC_PORT)
+			sprintf(tmpname, "irc");
+		else
+			sprintf(tmpname, "irc-%u", i);
+		irc[i].name = tmpname;
+
+		ret = nf_conntrack_helper_register(&irc[i]);
+		if (ret) {
+			printk("nf_ct_irc: failed to register helper "
+			       "for pf: %u port: %u\n",
+			       irc[i].tuple.src.l3num, ports[i]);
+			nf_conntrack_irc_fini();
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/* This function is intentionally _NOT_ defined as __exit, because
+ * it is needed by the init function */
+static void nf_conntrack_irc_fini(void)
+{
+	int i;
+
+	for (i = 0; i < ports_c; i++)
+		nf_conntrack_helper_unregister(&irc[i]);
+	kfree(irc_buffer);
+}
+
+module_init(nf_conntrack_irc_init);
+module_exit(nf_conntrack_irc_fini);
