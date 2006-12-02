From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/20]: nf_conntrack/nf_nat: add amanda helper port
Date: Sat,  2 Dec 2006 15:49:53 +0100 (MET)
Message-ID: <20061202145257.1381.99539.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port

Add IPv4 and IPv6 capable nf_conntrack port of the Amanda conntrack/NAT helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ff0a8e885f158f305e07bddc42071c531930db6f
tree 7cf2ed667a7f3fa43618b2062a9096716f0c4c2f
parent 3aaeacdbed7ac9ef0fbf569f45c8a9ee4323ab19
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:08 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:08 +0100

 include/linux/netfilter/nf_conntrack_amanda.h |   10 +
 net/ipv4/netfilter/Kconfig                    |    5 +
 net/ipv4/netfilter/Makefile                   |    1 
 net/ipv4/netfilter/nf_nat_amanda.c            |   78 ++++++++
 net/netfilter/Kconfig                         |   15 ++
 net/netfilter/Makefile                        |    1 
 net/netfilter/nf_conntrack_amanda.c           |  237 +++++++++++++++++++++++++
 7 files changed, 347 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
new file mode 100644
index 0000000..26c2235
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -0,0 +1,10 @@
+#ifndef _NF_CONNTRACK_AMANDA_H
+#define _NF_CONNTRACK_AMANDA_H
+/* AMANDA tracking. */
+
+extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff **pskb,
+					  enum ip_conntrack_info ctinfo,
+					  unsigned int matchoff,
+					  unsigned int matchlen,
+					  struct nf_conntrack_expect *exp);
+#endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 52f876d..6993ec5 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -512,6 +512,11 @@ config IP_NF_NAT_AMANDA
 	default IP_NF_NAT if IP_NF_AMANDA=y
 	default m if IP_NF_AMANDA=m
 
+config NF_NAT_AMANDA
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_AMANDA
+
 config IP_NF_NAT_PPTP
 	tristate
 	depends on IP_NF_NAT!=n && IP_NF_PPTP!=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index c0c6194..8893249 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_IP_NF_NAT_IRC) += ip_nat_ir
 obj-$(CONFIG_IP_NF_NAT_SIP) += ip_nat_sip.o
 
 # NAT helpers (nf_conntrack)
+obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
 
 # generic IP tables 
diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf_nat_amanda.c
new file mode 100644
index 0000000..0f17098
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_amanda.c
@@ -0,0 +1,78 @@
+/* Amanda extension for TCP NAT alteration.
+ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
+ * based on a copy of HW's ip_nat_irc.c as well as other modules
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/udp.h>
+
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_amanda.h>
+
+MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
+MODULE_DESCRIPTION("Amanda NAT helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_nat_amanda");
+
+static unsigned int help(struct sk_buff **pskb,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int matchoff,
+			 unsigned int matchlen,
+			 struct nf_conntrack_expect *exp)
+{
+	char buffer[sizeof("65535")];
+	u_int16_t port;
+	unsigned int ret;
+
+	/* Connection comes from client. */
+	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
+	exp->dir = IP_CT_DIR_ORIGINAL;
+
+	/* When you see the packet, we need to NAT it the same as the
+	 * this one (ie. same IP: it will be TCP and master is UDP). */
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
+	sprintf(buffer, "%u", port);
+	ret = nf_nat_mangle_udp_packet(pskb, exp->master, ctinfo,
+				       matchoff, matchlen,
+				       buffer, strlen(buffer));
+	if (ret != NF_ACCEPT)
+		nf_conntrack_unexpect_related(exp);
+	return ret;
+}
+
+static void __exit nf_nat_amanda_fini(void)
+{
+	rcu_assign_pointer(nf_nat_amanda_hook, NULL);
+	synchronize_rcu();
+}
+
+static int __init nf_nat_amanda_init(void)
+{
+	BUG_ON(rcu_dereference(nf_nat_amanda_hook));
+	rcu_assign_pointer(nf_nat_amanda_hook, help);
+	return 0;
+}
+
+module_init(nf_nat_amanda_init);
+module_exit(nf_nat_amanda_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index efe56f7..f85fd43 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -131,6 +131,21 @@ config NF_CT_PROTO_SCTP
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
 
+config NF_CONNTRACK_AMANDA
+	tristate "Amanda backup protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	select TEXTSEARCH
+	select TEXTSEARCH_KMP
+	help
+	  If you are running the Amanda backup package <http://www.amanda.org/>
+	  on this machine or machines that will be MASQUERADED through this
+	  machine, then you may want to enable this feature.  This allows the
+	  connection tracking and natting code to allow the sub-channels that
+	  Amanda requires for communication of the backup data, messages and
+	  index.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CONNTRACK_FTP
 	tristate "FTP support on new connection tracking (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7f0089c..a5ee938 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,6 +20,7 @@ # netlink interface for nf_conntrack
 obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
 
 # connection tracking helpers
+obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_conntrack_amanda.o
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
 
 # generic X tables 
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
new file mode 100644
index 0000000..5c495dc
--- /dev/null
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -0,0 +1,237 @@
+/* Amanda extension for IP connection tracking
+ *
+ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
+ * based on HW's ip_conntrack_irc.c as well as other modules
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/textsearch.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/udp.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_amanda.h>
+
+static unsigned int master_timeout __read_mostly = 300;
+static char *ts_algo = "kmp";
+
+MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
+MODULE_DESCRIPTION("Amanda connection tracking module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_conntrack_amanda");
+
+module_param(master_timeout, uint, 0600);
+MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
+module_param(ts_algo, charp, 0400);
+MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
+
+unsigned int (*nf_nat_amanda_hook)(struct sk_buff **pskb,
+				   enum ip_conntrack_info ctinfo,
+				   unsigned int matchoff,
+				   unsigned int matchlen,
+				   struct nf_conntrack_expect *exp)
+				   __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_amanda_hook);
+
+enum amanda_strings {
+	SEARCH_CONNECT,
+	SEARCH_NEWLINE,
+	SEARCH_DATA,
+	SEARCH_MESG,
+	SEARCH_INDEX,
+};
+
+static struct {
+	char			*string;
+	size_t			len;
+	struct ts_config	*ts;
+} search[] __read_mostly = {
+	[SEARCH_CONNECT] = {
+		.string	= "CONNECT ",
+		.len	= 8,
+	},
+	[SEARCH_NEWLINE] = {
+		.string	= "\n",
+		.len	= 1,
+	},
+	[SEARCH_DATA] = {
+		.string	= "DATA ",
+		.len	= 5,
+	},
+	[SEARCH_MESG] = {
+		.string	= "MESG ",
+		.len	= 5,
+	},
+	[SEARCH_INDEX] = {
+		.string = "INDEX ",
+		.len	= 6,
+	},
+};
+
+static int amanda_help(struct sk_buff **pskb,
+		       unsigned int protoff,
+		       struct nf_conn *ct,
+		       enum ip_conntrack_info ctinfo)
+{
+	struct ts_state ts;
+	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_tuple *tuple;
+	unsigned int dataoff, start, stop, off, i;
+	char pbuf[sizeof("65535")], *tmp;
+	u_int16_t len;
+	__be16 port;
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	int ret = NF_ACCEPT;
+	typeof(nf_nat_amanda_hook) nf_nat_amanda;
+
+	/* Only look at packets from the Amanda server */
+	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+		return NF_ACCEPT;
+
+	/* increase the UDP timeout of the master connection as replies from
+	 * Amanda clients to the server can be quite delayed */
+	nf_ct_refresh(ct, *pskb, master_timeout * HZ);
+
+	/* No data? */
+	dataoff = protoff + sizeof(struct udphdr);
+	if (dataoff >= (*pskb)->len) {
+		if (net_ratelimit())
+			printk("amanda_help: skblen = %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+	}
+
+	memset(&ts, 0, sizeof(ts));
+	start = skb_find_text(*pskb, dataoff, (*pskb)->len,
+			      search[SEARCH_CONNECT].ts, &ts);
+	if (start == UINT_MAX)
+		goto out;
+	start += dataoff + search[SEARCH_CONNECT].len;
+
+	memset(&ts, 0, sizeof(ts));
+	stop = skb_find_text(*pskb, start, (*pskb)->len,
+			     search[SEARCH_NEWLINE].ts, &ts);
+	if (stop == UINT_MAX)
+		goto out;
+	stop += start;
+
+	for (i = SEARCH_DATA; i <= SEARCH_INDEX; i++) {
+		memset(&ts, 0, sizeof(ts));
+		off = skb_find_text(*pskb, start, stop, search[i].ts, &ts);
+		if (off == UINT_MAX)
+			continue;
+		off += start + search[i].len;
+
+		len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
+		if (skb_copy_bits(*pskb, off, pbuf, len))
+			break;
+		pbuf[len] = '\0';
+
+		port = htons(simple_strtoul(pbuf, &tmp, 10));
+		len = tmp - pbuf;
+		if (port == 0 || len > 5)
+			break;
+
+		exp = nf_conntrack_expect_alloc(ct);
+		if (exp == NULL) {
+			ret = NF_DROP;
+			goto out;
+		}
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		nf_conntrack_expect_init(exp, family,
+					 &tuple->src.u3, &tuple->dst.u3,
+					 IPPROTO_TCP, NULL, &port);
+
+		nf_nat_amanda = rcu_dereference(nf_nat_amanda_hook);
+		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
+			ret = nf_nat_amanda(pskb, ctinfo, off - dataoff,
+					    len, exp);
+		else if (nf_conntrack_expect_related(exp) != 0)
+			ret = NF_DROP;
+		nf_conntrack_expect_put(exp);
+	}
+
+out:
+	return ret;
+}
+
+static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
+	{
+		.name			= "amanda",
+		.max_expected		= 3,
+		.timeout		= 180,
+		.me			= THIS_MODULE,
+		.help			= amanda_help,
+		.tuple.src.l3num	= AF_INET,
+		.tuple.src.u.udp.port	= __constant_htons(10080),
+		.tuple.dst.protonum	= IPPROTO_UDP,
+		.mask.src.l3num		= 0xFFFF,
+		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
+		.mask.dst.protonum	= 0xFF,
+	},
+	{
+		.name			= "amanda",
+		.max_expected		= 3,
+		.timeout		= 180,
+		.me			= THIS_MODULE,
+		.help			= amanda_help,
+		.tuple.src.l3num	= AF_INET6,
+		.tuple.src.u.udp.port	= __constant_htons(10080),
+		.tuple.dst.protonum	= IPPROTO_UDP,
+		.mask.src.l3num		= 0xFFFF,
+		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
+		.mask.dst.protonum	= 0xFF,
+	},
+};
+
+static void __exit nf_conntrack_amanda_fini(void)
+{
+	int i;
+
+	nf_conntrack_helper_unregister(&amanda_helper[0]);
+	nf_conntrack_helper_unregister(&amanda_helper[1]);
+	for (i = 0; i < ARRAY_SIZE(search); i++)
+		textsearch_destroy(search[i].ts);
+}
+
+static int __init nf_conntrack_amanda_init(void)
+{
+	int ret, i;
+
+	ret = -ENOMEM;
+	for (i = 0; i < ARRAY_SIZE(search); i++) {
+		search[i].ts = textsearch_prepare(ts_algo, search[i].string,
+						  search[i].len,
+						  GFP_KERNEL, TS_AUTOLOAD);
+		if (search[i].ts == NULL)
+			goto err1;
+	}
+	ret = nf_conntrack_helper_register(&amanda_helper[0]);
+	if (ret < 0)
+		goto err1;
+	ret = nf_conntrack_helper_register(&amanda_helper[1]);
+	if (ret < 0)
+		goto err2;
+	return 0;
+
+err2:
+	nf_conntrack_helper_unregister(&amanda_helper[0]);
+err1:
+	for (; i >= 0; i--) {
+		if (search[i].ts)
+			textsearch_destroy(search[i].ts);
+	}
+	return ret;
+}
+
+module_init(nf_conntrack_amanda_init);
+module_exit(nf_conntrack_amanda_fini);
