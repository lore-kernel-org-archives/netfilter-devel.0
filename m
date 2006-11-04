From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: nf_conntrack/nf_nat: add SIP helper port
Date: Sun, 05 Nov 2006 00:04:50 +0100
Message-ID: <454D1C92.1020503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030101060508010309020202"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
--------------030101060508010309020202
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

A port of the SIP conntrack/NAT helpers to nf_conntrack.
Only IPv4 tested, which works fine so far.



--------------030101060508010309020202
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_conntrack/nf_nat: add SIP helper port

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a6c08049039463f18272fa8e7139aadb8a950d22
tree aaf3f5caed98ee4363dd3ce3d63931b4f76c8ac8
parent 49993257192a278f6dc7f288e6ef62059ba88762
author Patrick McHardy <kaber@trash.net> Sat, 04 Nov 2006 23:58:50 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 04 Nov 2006 23:58:50 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   44 ++
 net/ipv4/netfilter/Kconfig                 |    5 
 net/ipv4/netfilter/Makefile                |    1 
 net/ipv4/netfilter/nf_nat_sip.c            |  250 ++++++++++++++
 net/netfilter/Kconfig                      |   12 +
 net/netfilter/Makefile                     |    1 
 net/netfilter/nf_conntrack_sip.c           |  505 ++++++++++++++++++++++++++++
 7 files changed, 818 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
new file mode 100644
index 0000000..587c65b
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -0,0 +1,44 @@
+#ifndef __NF_CONNTRACK_SIP_H__
+#define __NF_CONNTRACK_SIP_H__
+#ifdef __KERNEL__
+
+#define SIP_PORT	5060
+#define SIP_TIMEOUT	3600
+
+#define POS_VIA		0
+#define POS_CONTACT	1
+#define POS_CONTENT	2
+#define POS_MEDIA	3
+#define POS_OWNER	4
+#define POS_CONNECTION	5
+#define POS_REQ_HEADER	6
+#define POS_SDP_HEADER	7
+
+struct sip_header_nfo {
+	const char	*lname;
+	const char	*sname;
+	const char	*ln_str;
+	size_t		lnlen;
+	size_t		snlen;
+	size_t		ln_strlen;
+	int		(*match_len)(struct nf_conn *, const char *,
+				     const char *, int *);
+};
+
+extern unsigned int (*nf_nat_sip_hook)(struct sk_buff **pskb,
+				       enum ip_conntrack_info ctinfo,
+				       struct nf_conn *ct,
+				       const char **dptr);
+extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff **pskb,
+				       enum ip_conntrack_info ctinfo,
+				       struct nf_conntrack_expect *exp,
+				       const char *dptr);
+
+extern int ct_sip_get_info(struct nf_conn *, const char *dptr, size_t dlen,
+			   unsigned int *matchoff, unsigned int *matchlen,
+			   struct sip_header_nfo *hnfo);
+extern int ct_sip_lnlen(const char *line, const char *limit);
+extern const char *ct_sip_search(const char *needle, const char *haystack,
+                                 size_t needle_len, size_t haystack_len);
+#endif /* __KERNEL__ */
+#endif /* __NF_CONNTRACK_SIP_H__ */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 5358961..5867f7b 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -537,6 +537,11 @@ config IP_NF_NAT_SIP
 	default IP_NF_NAT if IP_NF_SIP=y
 	default m if IP_NF_SIP=m
 
+config NF_NAT_SIP
+	tristate
+	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	default NF_NAT && NF_CONNTRACK_SIP
+
 # mangle + specific targets
 config IP_NF_MANGLE
 	tristate "Packet mangling"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index eee78aa..30e470d 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_IP_NF_NAT_SIP) += ip_nat_si
 
 # NAT helpers (nf_conntrack) 
 obj-$(CONFIG_NF_NAT_FTP) += nf_nat_ftp.o
+obj-$(CONFIG_NF_NAT_SIP) += nf_nat_sip.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
new file mode 100644
index 0000000..be82221
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -0,0 +1,250 @@
+/* SIP extension for UDP NAT alteration.
+ *
+ * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
+ * based on RR's ip_nat_ftp.c and other modules.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_sip.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
+MODULE_DESCRIPTION("SIP NAT helper");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+extern struct sip_header_nfo ct_sip_hdrs[];
+
+static unsigned int mangle_sip_packet(struct sk_buff **pskb,
+				      enum ip_conntrack_info ctinfo,
+				      struct nf_conn *ct,
+				      const char **dptr, size_t dlen,
+				      char *buffer, int bufflen,
+				      struct sip_header_nfo *hnfo)
+{
+	unsigned int matchlen, matchoff;
+
+	if (ct_sip_get_info(ct, *dptr, dlen, &matchoff, &matchlen, hnfo) <= 0)
+		return 0;
+
+	if (!nf_nat_mangle_udp_packet(pskb, ct, ctinfo,
+	                              matchoff, matchlen, buffer, bufflen))
+		return 0;
+
+	/* We need to reload this. Thanks Patrick. */
+	*dptr = (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	return 1;
+}
+
+static unsigned int ip_nat_sip(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       struct nf_conn *ct,
+			       const char **dptr)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+	unsigned int bufflen, dataoff;
+	__be32 ip;
+	__be16 port;
+
+	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+
+	ip   = ct->tuplehash[!dir].tuple.dst.u3.ip;
+	port = ct->tuplehash[!dir].tuple.dst.u.udp.port;
+	bufflen = sprintf(buffer, "%u.%u.%u.%u:%u", NIPQUAD(ip), ntohs(port));
+
+	/* short packet ? */
+	if (((*pskb)->len - dataoff) < (sizeof("SIP/2.0") - 1))
+		return 0;
+
+	/* Basic rules: requests and responses. */
+	if (memcmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) == 0) {
+		const char *aux;
+
+		if ((ctinfo) < IP_CT_IS_REPLY) {
+			mangle_sip_packet(pskb, ctinfo, ct, dptr,
+			                  (*pskb)->len - dataoff,
+			                  buffer, bufflen,
+			                  &ct_sip_hdrs[POS_CONTACT]);
+			return 1;
+		}
+
+		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
+				       (*pskb)->len - dataoff,
+		                       buffer, bufflen, &ct_sip_hdrs[POS_VIA]))
+			return 0;
+
+		/* This search should ignore case, but later.. */
+		aux = ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1,
+		                    (*pskb)->len - dataoff);
+		if (!aux)
+			return 0;
+
+		if (!ct_sip_search("REGISTER", aux, sizeof("REGISTER"),
+		    ct_sip_lnlen(aux, *dptr + (*pskb)->len - dataoff)))
+			return 1;
+
+		return mangle_sip_packet(pskb, ctinfo, ct, dptr,
+					 (*pskb)->len - dataoff,
+		                         buffer, bufflen,
+					 &ct_sip_hdrs[POS_CONTACT]);
+	}
+	if ((ctinfo) < IP_CT_IS_REPLY) {
+		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
+				       (*pskb)->len - dataoff,
+		                       buffer, bufflen, &ct_sip_hdrs[POS_VIA]))
+			return 0;
+
+		/* Mangle Contact if exists only. - watch udp_nat_mangle()! */
+		mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,
+		                  buffer, bufflen, &ct_sip_hdrs[POS_CONTACT]);
+		return 1;
+	}
+	/* This mangle requests headers. */
+	return mangle_sip_packet(pskb, ctinfo, ct, dptr,
+	                         ct_sip_lnlen(*dptr,
+				              *dptr + (*pskb)->len - dataoff),
+	                         buffer, bufflen, &ct_sip_hdrs[POS_REQ_HEADER]);
+}
+
+static int mangle_content_len(struct sk_buff **pskb,
+			      enum ip_conntrack_info ctinfo,
+			      struct nf_conn *ct,
+			      const char *dptr)
+{
+	unsigned int dataoff, matchoff, matchlen;
+	char buffer[sizeof("65536")];
+	int bufflen;
+
+	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+
+	/* Get actual SDP lenght */
+	if (ct_sip_get_info(ct, dptr, (*pskb)->len - dataoff, &matchoff,
+	                    &matchlen, &ct_sip_hdrs[POS_SDP_HEADER]) > 0) {
+
+		/* since ct_sip_get_info() give us a pointer passing 'v='
+		   we need to add 2 bytes in this count. */
+		int c_len = (*pskb)->len - dataoff - matchoff + 2;
+
+		/* Now, update SDP lenght */
+		if (ct_sip_get_info(ct, dptr, (*pskb)->len - dataoff, &matchoff,
+		                    &matchlen, &ct_sip_hdrs[POS_CONTENT]) > 0) {
+
+			bufflen = sprintf(buffer, "%u", c_len);
+
+			return nf_nat_mangle_udp_packet(pskb, ct, ctinfo,
+							matchoff, matchlen,
+							buffer, bufflen);
+		}
+	}
+	return 0;
+}
+
+static unsigned int mangle_sdp(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       struct nf_conn *ct,
+			       __be32 newip, u_int16_t port,
+			       const char *dptr)
+{
+	char buffer[sizeof("nnn.nnn.nnn.nnn")];
+	unsigned int dataoff, bufflen;
+
+	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+
+	/* Mangle owner and contact info. */
+	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	                       buffer, bufflen, &ct_sip_hdrs[POS_OWNER]))
+		return 0;
+
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	                       buffer, bufflen, &ct_sip_hdrs[POS_CONNECTION]))
+		return 0;
+
+	/* Mangle media port. */
+	bufflen = sprintf(buffer, "%u", port);
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	                       buffer, bufflen, &ct_sip_hdrs[POS_MEDIA]))
+		return 0;
+
+	return mangle_content_len(pskb, ctinfo, ct, dptr);
+}
+
+/* So, this packet has hit the connection tracking matching code.
+   Mangle it, and change the expectation to match the new version. */
+static unsigned int ip_nat_sdp(struct sk_buff **pskb,
+			       enum ip_conntrack_info ctinfo,
+			       struct nf_conntrack_expect *exp,
+			       const char *dptr)
+{
+	struct nf_conn *ct = exp->master;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	__be32 newip;
+	u_int16_t port;
+
+	DEBUGP("ip_nat_sdp():\n");
+
+	/* Connection will come from reply */
+	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+
+	exp->tuple.dst.u3.ip = newip;
+	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
+	exp->dir = !dir;
+
+	/* When you see the packet, we need to NAT it the same as the
+	   this one. */
+	exp->expectfn = nf_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
+		exp->tuple.dst.u.udp.port = htons(port);
+		if (nf_conntrack_expect_related(exp) == 0)
+			break;
+	}
+
+	if (port == 0)
+		return NF_DROP;
+
+	if (!mangle_sdp(pskb, ctinfo, ct, newip, port, dptr)) {
+		nf_conntrack_unexpect_related(exp);
+		return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
+static void __exit nf_nat_sip_fini(void)
+{
+	nf_nat_sip_hook = NULL;
+	nf_nat_sdp_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
+}
+
+static int __init nf_nat_sip_init(void)
+{
+	BUG_ON(nf_nat_sip_hook);
+	BUG_ON(nf_nat_sdp_hook);
+	nf_nat_sip_hook = ip_nat_sip;
+	nf_nat_sdp_hook = ip_nat_sdp;
+	return 0;
+}
+
+module_init(nf_nat_sip_init);
+module_exit(nf_nat_sip_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ab6b234..f3be7f4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -150,6 +150,18 @@ config NF_CONNTRACK_FTP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_SIP
+	tristate "SIP support on new connection tracking (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  SIP is an application-layer control protocol that can establish,
+	  modify, and terminate multimedia sessions (conferences) such as
+	  Internet telephony calls. With the ip_conntrack_sip and
+	  the nf_nat_sip modules you can support the protocol on a connection
+	  tracking/NATing firewall.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 627105d..e50eed6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_NF_CT_NETLINK) += nf_conntr
 
 # connection tracking helpers
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
+obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
new file mode 100644
index 0000000..0ac881e
--- /dev/null
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -0,0 +1,505 @@
+/* SIP extension for IP connection tracking.
+ *
+ * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
+ * based on RR's ip_conntrack_ftp.c and other modules.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/skbuff.h>
+#include <linux/inet.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <linux/netfilter/nf_conntrack_sip.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
+MODULE_DESCRIPTION("SIP connection tracking helper");
+
+#define MAX_PORTS	8
+static unsigned short ports[MAX_PORTS];
+static int ports_c;
+module_param_array(ports, ushort, &ports_c, 0400);
+MODULE_PARM_DESC(ports, "port numbers of sip servers");
+
+static unsigned int sip_timeout = SIP_TIMEOUT;
+module_param(sip_timeout, uint, 0600);
+MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
+
+unsigned int (*nf_nat_sip_hook)(struct sk_buff **pskb,
+				enum ip_conntrack_info ctinfo,
+				struct nf_conn *ct,
+				const char **dptr);
+EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
+
+unsigned int (*nf_nat_sdp_hook)(struct sk_buff **pskb,
+				enum ip_conntrack_info ctinfo,
+				struct nf_conntrack_expect *exp,
+				const char *dptr);
+EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
+
+int ct_sip_get_info(struct nf_conn *ct, const char *dptr, size_t dlen,
+		    unsigned int *matchoff, unsigned int *matchlen,
+		    struct sip_header_nfo *hnfo);
+EXPORT_SYMBOL_GPL(ct_sip_get_info);
+
+
+static int digits_len(struct nf_conn *, const char *, const char *, int *);
+static int epaddr_len(struct nf_conn *, const char *, const char *, int *);
+static int skp_digits_len(struct nf_conn *, const char *, const char *, int *);
+static int skp_epaddr_len(struct nf_conn *, const char *, const char *, int *);
+
+struct sip_header_nfo ct_sip_hdrs[] = {
+	{ 	/* Via header */
+		.lname		= "Via:",
+		.lnlen		= sizeof("Via:") - 1,
+		.sname		= "\r\nv:",
+		.snlen		= sizeof("\r\nv:") - 1, /* rfc3261 "\r\n" */
+		.ln_str		= "UDP ",
+		.ln_strlen	= sizeof("UDP ") - 1,
+		.match_len	= epaddr_len,
+	},
+	{ 	/* Contact header */
+		.lname		= "Contact:",
+		.lnlen		= sizeof("Contact:") - 1,
+		.sname		= "\r\nm:",
+		.snlen		= sizeof("\r\nm:") - 1,
+		.ln_str		= "sip:",
+		.ln_strlen	= sizeof("sip:") - 1,
+		.match_len	= skp_epaddr_len
+	},
+	{ 	/* Content length header */
+		.lname		= "Content-Length:",
+		.lnlen		= sizeof("Content-Length:") - 1,
+		.sname		= "\r\nl:",
+		.snlen		= sizeof("\r\nl:") - 1,
+		.ln_str		= ":",
+		.ln_strlen	= sizeof(":") - 1,
+		.match_len	= skp_digits_len
+	},
+	{	/* SDP media info */
+		.lname		= "\nm=",
+		.lnlen		= sizeof("\nm=") - 1,
+		.sname		= "\rm=",
+		.snlen		= sizeof("\rm=") - 1,
+		.ln_str		= "audio ",
+		.ln_strlen	= sizeof("audio ") - 1,
+		.match_len	= digits_len
+	},
+	{ 	/* SDP owner address*/
+		.lname		= "\no=",
+		.lnlen		= sizeof("\no=") - 1,
+		.sname		= "\ro=",
+		.snlen		= sizeof("\ro=") - 1,
+		.ln_str		= "IN IP4 ",
+		.ln_strlen	= sizeof("IN IP4 ") - 1,
+		.match_len	= epaddr_len
+	},
+	{ 	/* SDP connection info */
+		.lname		= "\nc=",
+		.lnlen		= sizeof("\nc=") - 1,
+		.sname		= "\rc=",
+		.snlen		= sizeof("\rc=") - 1,
+		.ln_str		= "IN IP4 ",
+		.ln_strlen	= sizeof("IN IP4 ") - 1,
+		.match_len	= epaddr_len
+	},
+	{ 	/* Requests headers */
+		.lname		= "sip:",
+		.lnlen		= sizeof("sip:") - 1,
+		.sname		= "sip:",
+		.snlen		= sizeof("sip:") - 1, /* yes, i know.. ;) */
+		.ln_str		= "@",
+		.ln_strlen	= sizeof("@") - 1,
+		.match_len	= epaddr_len
+	},
+	{ 	/* SDP version header */
+		.lname		= "\nv=",
+		.lnlen		= sizeof("\nv=") - 1,
+		.sname		= "\rv=",
+		.snlen		= sizeof("\rv=") - 1,
+		.ln_str		= "=",
+		.ln_strlen	= sizeof("=") - 1,
+		.match_len	= digits_len
+	}
+};
+EXPORT_SYMBOL_GPL(ct_sip_hdrs);
+
+/* get line lenght until first CR or LF seen. */
+int ct_sip_lnlen(const char *line, const char *limit)
+{
+	const char *k = line;
+
+	while ((line <= limit) && (*line == '\r' || *line == '\n'))
+		line++;
+
+	while (line <= limit) {
+		if (*line == '\r' || *line == '\n')
+			break;
+		line++;
+	}
+	return line - k;
+}
+EXPORT_SYMBOL_GPL(ct_sip_lnlen);
+
+/* Linear string search, case sensitive. */
+const char *ct_sip_search(const char *needle, const char *haystack,
+                          size_t needle_len, size_t haystack_len)
+{
+	const char *limit = haystack + (haystack_len - needle_len);
+
+	while (haystack <= limit) {
+		if (memcmp(haystack, needle, needle_len) == 0)
+			return haystack;
+		haystack++;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ct_sip_search);
+
+static int digits_len(struct nf_conn *ct, const char *dptr,
+		      const char *limit, int *shift)
+{
+	int len = 0;
+	while (dptr <= limit && isdigit(*dptr)) {
+		dptr++;
+		len++;
+	}
+	return len;
+}
+
+/* get digits lenght, skiping blank spaces. */
+static int skp_digits_len(struct nf_conn *ct, const char *dptr,
+			  const char *limit, int *shift)
+{
+	for (; dptr <= limit && *dptr == ' '; dptr++)
+		(*shift)++;
+
+	return digits_len(ct, dptr, limit, shift);
+}
+
+/* Simple ipaddr parser.. */
+static int parse_ipaddr(const char *cp,	const char **endp,
+			__be32 *ipaddr, const char *limit)
+{
+	unsigned long int val;
+	int i, digit = 0;
+
+	for (i = 0, *ipaddr = 0; cp <= limit && i < 4; i++) {
+		digit = 0;
+		if (!isdigit(*cp))
+			break;
+
+		val = simple_strtoul(cp, (char **)&cp, 10);
+		if (val > 0xFF)
+			return -1;
+
+		((u_int8_t *)ipaddr)[i] = val;
+		digit = 1;
+
+		if (*cp != '.')
+			break;
+		cp++;
+	}
+	if (!digit)
+		return -1;
+
+	if (endp)
+		*endp = cp;
+
+	return 0;
+}
+
+static int parse_addr(struct nf_conn *ct, const char *cp, const char **endp,
+		      struct nf_conntrack_man *addr, const char *limit)
+{
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+
+	switch (family) {
+	case AF_INET:
+		return parse_ipaddr(cp, endp, &addr->u3.ip, limit);
+	case AF_INET6:
+		return in6_pton(cp, limit - cp, (u8 *)&addr->u3.ip6, 0, endp);
+	default:
+		BUG();
+		return 0;
+	}
+}
+
+/* skip ip address. returns its length. */
+static int epaddr_len(struct nf_conn *ct, const char *dptr,
+		      const char *limit, int *shift)
+{
+	struct nf_conntrack_man addr;
+	const char *aux = dptr;
+
+	if (parse_addr(ct, dptr, &dptr, &addr, limit) < 0) {
+		DEBUGP("ip: %s parse failed.!\n", dptr);
+		return 0;
+	}
+
+	/* Port number */
+	if (*dptr == ':') {
+		dptr++;
+		dptr += digits_len(ct, dptr, limit, shift);
+	}
+	return dptr - aux;
+}
+
+/* get address length, skiping user info. */
+static int skp_epaddr_len(struct nf_conn *ct, const char *dptr,
+			  const char *limit, int *shift)
+{
+	int s = *shift;
+
+	for (; dptr <= limit && *dptr != '@'; dptr++)
+		(*shift)++;
+
+	if (*dptr == '@') {
+		dptr++;
+		(*shift)++;
+	} else
+		*shift = s;
+
+	return epaddr_len(ct, dptr, limit, shift);
+}
+
+/* Returns 0 if not found, -1 error parsing. */
+int ct_sip_get_info(struct nf_conn *ct,
+		    const char *dptr, size_t dlen,
+		    unsigned int *matchoff,
+		    unsigned int *matchlen,
+		    struct sip_header_nfo *hnfo)
+{
+	const char *limit, *aux, *k = dptr;
+	int shift = 0;
+
+	limit = dptr + (dlen - hnfo->lnlen);
+
+	while (dptr <= limit) {
+		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
+		    (strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
+			dptr++;
+			continue;
+		}
+		aux = ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,
+		                    ct_sip_lnlen(dptr, limit));
+		if (!aux) {
+			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str,
+			       hnfo->lname);
+			return -1;
+		}
+		aux += hnfo->ln_strlen;
+
+		*matchlen = hnfo->match_len(ct, aux, limit, &shift);
+		if (!*matchlen)
+			return -1;
+
+		*matchoff = (aux - k) + shift;
+
+		DEBUGP("%s match succeeded! - len: %u\n", hnfo->lname,
+		       *matchlen);
+		return 1;
+	}
+	DEBUGP("%s header not found.\n", hnfo->lname);
+	return 0;
+}
+
+static int set_expected_rtp(struct sk_buff **pskb,
+			    struct nf_conn *ct,
+			    enum ip_conntrack_info ctinfo,
+			    struct nf_conntrack_man *addr,
+			    const char *dptr)
+{
+	struct nf_conntrack_expect *exp;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	int family = ct->tuplehash[!dir].tuple.src.l3num;
+	int ret;
+
+	exp = nf_conntrack_expect_alloc(ct);
+	if (exp == NULL)
+		return NF_DROP;
+
+	exp->tuple.src.l3num = family;
+	exp->tuple.src.u3 = ct->tuplehash[!dir].tuple.src.u3;
+	exp->tuple.src.u.udp.port = 0;
+	memcpy(&exp->tuple.dst.u3, &addr->u3, sizeof(exp->tuple.dst.u3));
+	exp->tuple.dst.u.udp.port = addr->u.udp.port;
+	exp->tuple.dst.protonum = IPPROTO_UDP;
+
+	exp->mask.src.l3num = 0xFFFF;
+	if (family == AF_INET) {
+		exp->mask.src.u3.ip = htonl(0xFFFFFFFF);
+		exp->mask.dst.u3.ip = htonl(0xFFFFFFFF);
+	} else {
+		memset(&exp->mask.src.u3, 0xff, sizeof(exp->mask.src.u3));
+		memset(&exp->mask.dst.u3, 0xff, sizeof(exp->mask.src.u3));
+	}
+	exp->mask.src.u.udp.port = 0;
+	exp->mask.dst.u.udp.port = htons(0xFFFF);
+	exp->mask.dst.protonum = 0xFF;
+
+	exp->expectfn = NULL;
+	exp->flags = 0;
+
+	if (nf_nat_sdp_hook)
+		ret = nf_nat_sdp_hook(pskb, ctinfo, exp, dptr);
+	else {
+		if (nf_conntrack_expect_related(exp) != 0)
+			ret = NF_DROP;
+		else
+			ret = NF_ACCEPT;
+	}
+	nf_conntrack_expect_put(exp);
+
+	return ret;
+}
+
+static int sip_help(struct sk_buff **pskb,
+		    unsigned int protoff,
+		    struct nf_conn *ct,
+		    enum ip_conntrack_info ctinfo)
+{
+	struct nf_conntrack_man addr;
+	unsigned int dataoff, datalen;
+	const char *dptr;
+	int ret = NF_ACCEPT;
+	int matchoff, matchlen;
+	u_int16_t port;
+
+	/* No Data ? */
+	dataoff = protoff + sizeof(struct udphdr);
+	if (dataoff >= (*pskb)->len) {
+		DEBUGP("skb->len = %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+        }
+
+	nf_ct_refresh(ct, *pskb, sip_timeout * HZ);
+
+	if (!skb_is_nonlinear(*pskb))
+		dptr = (*pskb)->data + dataoff;
+	else {
+		DEBUGP("Copy of skbuff not supported yet.\n");
+		goto out;
+	}
+
+	if (nf_nat_sip_hook && ct->status & IPS_NAT_MASK) {
+		if (!nf_nat_sip_hook(pskb, ctinfo, ct, &dptr)) {
+			ret = NF_DROP;
+			goto out;
+		}
+	}
+
+	datalen = (*pskb)->len - dataoff;
+	if (datalen < (sizeof("SIP/2.0 200") - 1))
+		goto out;
+
+	/* RTP info only in some SDP pkts */
+	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) != 0 &&
+	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) != 0) {
+		goto out;
+	}
+	/* Get address and port from SDP packet. */
+	if (ct_sip_get_info(ct, dptr, datalen, &matchoff, &matchlen,
+	                    &ct_sip_hdrs[POS_CONNECTION]) > 0) {
+
+		/* We'll drop only if there are parse problems. */
+		if (parse_addr(ct, dptr + matchoff, NULL, &addr,
+			       dptr + datalen) < 0) {
+			ret = NF_DROP;
+			goto out;
+		}
+		if (ct_sip_get_info(ct, dptr, datalen, &matchoff, &matchlen,
+		                    &ct_sip_hdrs[POS_MEDIA]) > 0) {
+
+			port = simple_strtoul(dptr + matchoff, NULL, 10);
+			if (port < 1024) {
+				ret = NF_DROP;
+				goto out;
+			}
+			addr.u.udp.port = htons(port);
+			ret = set_expected_rtp(pskb, ct, ctinfo, &addr, dptr);
+		}
+	}
+out:
+	return ret;
+}
+
+static struct nf_conntrack_helper sip[MAX_PORTS][2];
+static char sip_names[MAX_PORTS][2][sizeof("sip-65535")];
+
+static void nf_conntrack_sip_fini(void)
+{
+	int i, j;
+
+	for (i = 0; i < ports_c; i++) {
+		for (j = 0; j < 2; j++) {
+			if (sip[i][j].me == NULL)
+				continue;
+			nf_conntrack_helper_unregister(&sip[i][j]);
+		}
+	}
+}
+
+static int __init nf_conntrack_sip_init(void)
+{
+	int i, j, ret;
+	char *tmpname;
+
+	if (ports_c == 0)
+		ports[ports_c++] = SIP_PORT;
+
+	for (i = 0; i < ports_c; i++) {
+		memset(&sip[i], 0, sizeof(struct nf_conntrack_helper));
+
+		sip[i][0].tuple.src.l3num = AF_INET;
+		sip[i][1].tuple.src.l3num = AF_INET6;
+		for (j = 0; j < 2; j++) {
+			sip[i][j].tuple.dst.protonum = IPPROTO_UDP;
+			sip[i][j].tuple.src.u.udp.port = htons(ports[i]);
+			sip[i][j].mask.src.u.udp.port = htons(0xFFFF);
+			sip[i][j].mask.dst.protonum = 0xFF;
+			sip[i][j].max_expected = 2;
+			sip[i][j].timeout = 3 * 60; /* 3 minutes */
+			sip[i][j].me = THIS_MODULE;
+			sip[i][j].help = sip_help;
+
+			tmpname = &sip_names[i][j][0];
+			if (ports[i] == SIP_PORT)
+				sprintf(tmpname, "sip");
+			else
+				sprintf(tmpname, "sip-%d", i);
+			sip[i][j].name = tmpname;
+
+			DEBUGP("port #%d: %d\n", i, ports[i]);
+
+			ret = nf_conntrack_helper_register(&sip[i][j]);
+			if (ret) {
+				printk("ERROR registering helper for port %d\n",
+					ports[i]);
+				nf_conntrack_sip_fini();
+				return ret;
+			}
+		}
+	}
+	return 0;
+}
+
+module_init(nf_conntrack_sip_init);
+module_exit(nf_conntrack_sip_fini);

--------------030101060508010309020202--
