From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/*]: nf_conntrack/nf_nat: add amanda helper port
Date: Sun, 05 Nov 2006 01:32:55 +0100
Message-ID: <454D3137.40109@trash.net>
References: <454D1C8F.5060302@trash.net> <454D291E.9010708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050008030103040605080304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <454D291E.9010708@trash.net>
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
--------------050008030103040605080304
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit



--------------050008030103040605080304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 22f4d1e132bd33107e8793466cae9695472843a8
tree 2cbff613e5117166047fc50ddb514a324b8717d2
parent 6cd9f9c0864b0a18a99b722bb15949effc0758a7
author Patrick McHardy <kaber@trash.net> Sun, 05 Nov 2006 01:30:55 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 05 Nov 2006 01:30:55 +0100

 include/linux/netfilter/nf_conntrack_amanda.h |   10 +
 net/ipv4/netfilter/Kconfig                    |    5 +
 net/ipv4/netfilter/Makefile                   |    1 
 net/ipv4/netfilter/nf_nat_amanda.c            |   78 ++++++++
 net/netfilter/Kconfig                         |   15 ++
 net/netfilter/Makefile                        |    1 
 net/netfilter/nf_conntrack_amanda.c           |  246 +++++++++++++++++++++++++
 7 files changed, 356 insertions(+), 0 deletions(-)

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
index 598865e..bdc59fa 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -524,6 +524,11 @@ config IP_NF_NAT_AMANDA
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
index fcf3460..39cebc4 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_IP_NF_NAT_SIP) += ip_nat_si
 
 # NAT helpers (nf_conntrack) 
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
+obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
 obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 obj-$(CONFIG_NF_NAT_SIP) += nf_nat_sip.o
 
diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf_nat_amanda.c
new file mode 100644
index 0000000..efbc07f
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
+	nf_nat_amanda_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
+}
+
+static int __init nf_nat_amanda_init(void)
+{
+	BUG_ON(nf_nat_amanda_hook);
+	nf_nat_amanda_hook = help;
+	return 0;
+}
+
+module_init(nf_nat_amanda_init);
+module_exit(nf_nat_amanda_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 65844d7..ebe2fee 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -150,6 +150,21 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_AMANDA
+	tristate "Amanda backup support on new connection tracking (EXPERIMENTAL)"
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
 config NF_CONNTRACK_TFTP
 	tristate "TFTP support on new connection tracking (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 747bb78..3fd1cc3 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_NF_CT_NETLINK) += nf_conntr
 
 # connection tracking helpers
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
+obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_conntrack_amanda.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
new file mode 100644
index 0000000..2d7703f
--- /dev/null
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -0,0 +1,246 @@
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
+static unsigned int master_timeout = 300;
+static char *ts_algo = "kmp";
+
+MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
+MODULE_DESCRIPTION("Amanda connection tracking module");
+MODULE_LICENSE("GPL");
+module_param(master_timeout, uint, 0600);
+MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
+module_param(ts_algo, charp, 0400);
+MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
+
+unsigned int (*nf_nat_amanda_hook)(struct sk_buff **pskb,
+				   enum ip_conntrack_info ctinfo,
+				   unsigned int matchoff,
+				   unsigned int matchlen,
+				   struct nf_conntrack_expect *exp);
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
+} search[] = {
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
+	unsigned int dataoff, start, stop, off, i;
+	char pbuf[sizeof("65535")], *tmp;
+	u_int16_t port, len;
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	int ret = NF_ACCEPT;
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
+		port = simple_strtoul(pbuf, &tmp, 10);
+		len = tmp - pbuf;
+		if (port == 0 || len > 5)
+			break;
+
+		exp = nf_conntrack_expect_alloc(ct);
+		if (exp == NULL) {
+			ret = NF_DROP;
+			goto out;
+		}
+
+		exp->expectfn = NULL;
+		exp->flags = 0;
+
+		exp->tuple.src.l3num = family;
+		exp->tuple.src.u3 = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3;
+		exp->tuple.src.u.tcp.port = 0;
+		exp->tuple.dst.u3 = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3;
+		exp->tuple.dst.protonum = IPPROTO_TCP;
+		exp->tuple.dst.u.tcp.port = htons(port);
+
+		exp->mask.src.l3num = htons(0xFFFF);
+		if (family == AF_INET) {
+			exp->mask.src.u3.ip = htonl(0xFFFFFFFF);
+			exp->mask.dst.u3.ip = htonl(0xFFFFFFFF);
+		} else {
+			memset(&exp->mask.src.u3, 0xff, sizeof(exp->mask.src.u3));
+			memset(&exp->mask.dst.u3, 0xff, sizeof(exp->mask.dst.u3));
+		}
+		exp->mask.src.u.tcp.port = 0;
+		exp->mask.dst.protonum = 0xFF;
+		exp->mask.dst.u.tcp.port = htons(0xFFFF);
+
+		if (nf_nat_amanda_hook && ct->status & IPS_NAT_MASK)
+			ret = nf_nat_amanda_hook(pskb, ctinfo, off - dataoff,
+						 len, exp);
+		else if (nf_conntrack_expect_related(exp) != 0)
+			ret = NF_DROP;
+		nf_conntrack_expect_put(exp);
+	}
+
+out:
+	return ret;
+}
+
+static struct nf_conntrack_helper amanda_helper[2] = {
+	{
+		.name			= "amanda",
+		.max_expected		= 3,
+		.timeout		= 180,
+		.me			= THIS_MODULE,
+		.help			= amanda_help,
+		.tuple.src.l3num	= AF_INET,
+		.tuple.src.u.udp.port	= __constant_htons(10080),
+		.tuple.dst.protonum	= IPPROTO_UDP,
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

--------------050008030103040605080304--
