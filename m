From: "Robert Iakobashvili" <roberti@GoNetworks.com>
Subject: Patch SIP-conntrack for 2.4.20
Date: Wed, 26 Jan 2005 09:24:19 +0200
Message-ID: <699F7BBB368A10479166148511F5241782A328@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

This is a cut from Lynksys GPL code, device WRT54GS, firmware version
3_37_2=20
following tip from Richard.

It is ok for basic calls.
Limitations/problems/issues up to Richard:
1. For two phones behind the same NAT - CANCEL message processing
problem;=20
2. SIP message has default of 3 minutes and may require=20
   to change the timeout for a jump TARGET;=20
3. One can use rtp proxy on public Internet to pass the media;

The patch is a simple diff of the lynksys code versus vanilla kernel=20
2.4.20 with a cut of SIP-only issues.
No testing has been done.

Hope it will be useful as a starting point.
Sincerely,
Robert Iakobashvili
roberti dot gonetworks dot com
------------------------------------------------------------------------
----------------------------
diff -Nur linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack.h
linux-2.4.20-sip/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack.h
2002-11-29 01:53:15.000000000 +0200
+++ linux-2.4.20-sip/include/linux/netfilter_ipv4/ip_conntrack.h
2005-01-25 18:56:01.722048512 +0200
@@ -58,12 +58,14 @@
 };
=20
 /* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_sip.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
=20
 /* per expectation: application helper private data */  union
ip_conntrack_expect_help {
 	/* insert conntrack helper private data (expect) here */
+        struct ip_ct_sip_expect exp_sip_info;
 	struct ip_ct_ftp_expect exp_ftp_info;
 	struct ip_ct_irc_expect exp_irc_info;
=20
@@ -77,6 +79,7 @@
 /* per conntrack: application helper private data */  union
ip_conntrack_help {
 	/* insert conntrack helper private data (master) here */
+        struct ip_ct_sip_master ct_sip_info;
 	struct ip_ct_ftp_master ct_ftp_info;
 	struct ip_ct_irc_master ct_irc_info;
 };
diff -Nur linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack_sip.h
linux-2.4.20-sip/include/linux/netfilter_ipv4/ip_conntrack_sip.h
--- linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack_sip.h
1970-01-01 02:00:00.000000000 +0200
+++ linux-2.4.20-sip/include/linux/netfilter_ipv4/ip_conntrack_sip.h
2005-01-25 19:04:03.675780408 +0200
@@ -0,0 +1,56 @@
+#ifndef _IP_CONNTRACK_SIP_H
+#define _IP_CONNTRACK_SIP_H
+/* SIP tracking. */
+
+#ifdef __KERNEL__
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+/* Protects sip part of conntracks */
+DECLARE_LOCK_EXTERN(ip_sip_lock);
+
+#define SIP_PORT	5060	/* UDP */
+#define SIP_EXPIRES 	3600	/* seconds */
+#define RTP_TIMEOUT	180	/* seconds */
+
+#endif /* __KERNEL__ */
+
+/* SIP Request */
+#define SIP_INVITE		0x01
+#define SIP_ACK			0x02
+#define SIP_BYE			0x04
+/* SIP Response */
+#define SIP_100			0x10
+#define SIP_200			0x20
+#define SIP_200_BYE		0x40
+/* SIP session direction */
+#define SIP_OUTGOING		0
+#define SIP_INCOMING		1
+
+enum ip_ct_conntype
+{
+	CONN_SIP,
+	CONN_RTP,
+	CONN_RTCP,
+};
+
+/* This structure is per expected connection */ struct ip_ct_sip_expect

+{
+	u_int16_t port; 		/* TCP port that was to be used
*/
+
+	enum ip_ct_conntype type;
+	int nated;
+};
+
+/* This structure exists only once per master */ struct=20
+ip_ct_sip_master {
+	int mangled;
+	u_int16_t rtpport;
+};
+
+extern u_int16_t find_sdp_audio_port(const char *data, size_t dlen,
+		unsigned int *numoff, unsigned int *numlen); extern int=20
+find_sdp_rtp_addr(const char *data, size_t dlen,
+			unsigned int *numoff, unsigned int *numlen,
u_int32_t *addr); #endif=20
+/* _IP_CONNTRACK_SIP_H */
diff -Nur linux-2.4.20/net/ipv4/netfilter/Config.in
linux-2.4.20-sip/net/ipv4/netfilter/Config.in
--- linux-2.4.20/net/ipv4/netfilter/Config.in	2002-11-29
01:53:15.000000000 +0200
+++ linux-2.4.20-sip/net/ipv4/netfilter/Config.in	2005-01-25
18:59:35.124606392 +0200
@@ -8,6 +8,7 @@
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP
$CONFIG_IP_NF_CONNTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC
$CONFIG_IP_NF_CONNTRACK
+  dep_tristate '  SIP protocol support' CONFIG_IP_NF_SIP=20
+ $CONFIG_IP_NF_CONNTRACK
 fi
=20
 if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then @@ -56,6 +57,13 @@
       define_bool CONFIG_IP_NF_NAT_NEEDED y
       dep_tristate '    MASQUERADE target support'
CONFIG_IP_NF_TARGET_MASQUERADE $CONFIG_IP_NF_NAT
       dep_tristate '    REDIRECT target support'
CONFIG_IP_NF_TARGET_REDIRECT $CONFIG_IP_NF_NAT
+      if [ "$CONFIG_IP_NF_SIP" =3D "m" ]; then
+       define_tristate CONFIG_IP_NF_NAT_SIP m
+      else
+        if [ "$CONFIG_IP_NF_SIP" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_SIP $CONFIG_IP_NF_NAT
+        fi
+      fi
       bool '    NAT of local connections (READ HELP)'
CONFIG_IP_NF_NAT_LOCAL
       if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
         dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)'
CONFIG_IP_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
diff -Nur linux-2.4.20/net/ipv4/netfilter/ip_conntrack_sip.c
linux-2.4.20-sip/net/ipv4/netfilter/ip_conntrack_sip.c
--- linux-2.4.20/net/ipv4/netfilter/ip_conntrack_sip.c	1970-01-01
02:00:00.000000000 +0200
+++ linux-2.4.20-sip/net/ipv4/netfilter/ip_conntrack_sip.c
2005-01-25 19:04:46.269305208 +0200
@@ -0,0 +1,312 @@
+/*
+ * SIP extension for IP connection tracking.=20
+ *
+ * Copyright (C) 2004, CyberTAN Corporation
+ * All Rights Reserved.
+ *
+ * THIS SOFTWARE IS OFFERED "AS IS", AND CYBERTAN GRANTS NO WARRANTIES=20
+OF ANY
+ * KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE.=20
+CYBERTAN
+ * SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY,=20
+FITNESS
+ * FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ctype.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h> #include=20
+<linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_sip.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+
+DECLARE_LOCK(ip_sip_lock);
+=20
+struct module *ip_conntrack_sip =3D THIS_MODULE;
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i"); #endif
+
+#if 0
+ #define DEBUGP printk
+#else
+  #define DEBUGP(format, args...)
+#endif
+
+#define RTCP_SUPPORT
+
+static int set_expected_rtp(struct ip_conntrack *ct, u_int32_t dstip,
+		u_int16_t dstport, unsigned int conntype) {
+	struct ip_conntrack_expect expect, *exp =3D &expect;
+	struct ip_ct_sip_expect *exp_sip_info =3D &exp->help.exp_sip_info;
+	int ret =3D 0;
+
+	memset(&expect, 0, sizeof(expect));
+	LOCK_BH(&ip_sip_lock);
+
+	DEBUGP("conntrack_sip: %s: [%s]: DST=3D%u.%u.%u.%u:%u\n",
__FUNCTION__,=20
+			conntype =3D=3D CONN_RTP ? "RTP" : "RTCP",
NIPQUAD(dstip), dstport);
+
+	/* exp_sip_info */
+	exp_sip_info->port =3D dstport;
+	exp_sip_info->type =3D conntype;
+	exp_sip_info->nated =3D 0;
+
+	/* new expectation */
+	exp->tuple =3D ((struct ip_conntrack_tuple)
+		{ { 0, { 0 } },
+		  { dstip, { htons(dstport) }, IPPROTO_UDP }});
+	exp->mask =3D ((struct ip_conntrack_tuple)
+		{ { 0, { 0 } },
+		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+	exp->expectfn =3D NULL;
+
+	if ((ret=3Dip_conntrack_expect_related(ct, exp)) !=3D 0) {
+		DEBUGP("Can't add new expectation. \n");
+	}
+
+	UNLOCK_BH(&ip_sip_lock);
+
+	return ret;
+}
+
+/*
+static int unset_expected_rtp(struct ip_conntrack *ct, u_int32_t dstip,

+u_int16_t dstport) {
+	struct ip_conntrack_expect *exp;
+	const struct ip_conntrack_tuple tuple =3D { { 0, { 0 } },
+			{ dstip, { htons(dstport) }, IPPROTO_UDP }};
+
+	LOCK_BH(&ip_sip_lock);
+
+	exp =3D ip_conntrack_expect_find_get(&tuple);
+	if (exp) {
+		DEBUGP("Find the expectation %p, then delete it.\n",
exp);
+		ip_conntrack_unexpect_related(exp);
+	}
+
+	UNLOCK_BH(&ip_sip_lock);
+
+	return 0;
+}*/
+
+/* return:
+ *       0 : Not found
+ *       1 : Found domain name
+ *       2 : Found dotted quads
+ */
+int find_sdp_rtp_addr(const char *data, size_t dlen,
+			unsigned int *numoff, unsigned int *numlen,
u_int32_t *addr) {
+	char *st, *p =3D (char *)data;
+	const char *limit =3D data + dlen;
+	unsigned char p1, p2, p3, p4;
+
+	while (p < limit) {
+		/* find 'c=3D' line */
+		if (strncmp(p, "\nc=3D",3) && strncmp(p, "\rc=3D",3)) {
+			p++;
+			continue;
+		}
+		p +=3D 3;
+
+		if (strncmp(p, "IN IP4 ",7))
+			continue;
+		p +=3D 7;
+
+		/* IP address */
+		st =3D p;
+
+		/* FQDNs or dotted quads */
+		while (isalpha(*p) || isdigit(*p) || (*p=3D=3D'.') ||
(*p=3D=3D'-')) {
+			p++;
+			if (p =3D=3D limit)
+				return 0;
+		}
+
+		*numoff =3D st - data;
+		*numlen =3D p - st;
+
+		/* Convert the IP address */
+		p1 =3D simple_strtoul(st, &st ,10);
+		if (*st !=3D '.')
+			return 1;
+		p2 =3D simple_strtoul(st+1, &st, 10);
+		if (*st !=3D '.')
+			return 1;
+		p3 =3D simple_strtoul(st+1, &st, 10);
+		if (*st !=3D '.')
+			return 1;
+		p4 =3D simple_strtoul(st+1, &st, 10);
+
+		*addr =3D (p1<<24) | (p2<<16) | (p3<<8) | p4;
+
+		return 2;
+	}
+
+	return 0;
+}
+
+u_int16_t find_sdp_audio_port(const char *data, size_t dlen,
+			unsigned int *numoff, unsigned int *numlen) {
+	char *st, *p =3D (char *)data;
+	const char *limit =3D data + dlen;
+	u_int16_t port =3D 0;
+
+	while (p < limit) {
+		/* find 'm=3D' */
+		if (strncmp(p, "\nm=3D", 3) && strncmp(p, "\rm=3D", 3)) {
+			p++;
+			continue;
+		}
+		p +=3D 3;
+
+		/* audio stream */
+		if (strncmp(p ,"audio ",6))
+			continue;
+		p +=3D 6;
+
+		st =3D p;
+		port =3D simple_strtoul(p, &p, 10);
+
+		*numoff =3D st - data;
+		*numlen =3D p - st;
+
+		return port;
+	}
+
+	return 0;
+}
+
+static int help(const struct iphdr *iph, size_t len,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	int dir =3D CTINFO2DIR(ctinfo);
+	unsigned int matchlen, matchoff;
+
+	u_int32_t ipaddr=3D0;
+	u_int16_t port =3D 0;
+
+	int found =3D 0;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	const char *data =3D (const char *)udph + 8;
+	unsigned int udplen =3D len - iph->ihl * 4;
+	unsigned int datalen =3D udplen - 8;
+	struct ip_ct_sip_master *ct_sip_info =3D &ct->help.ct_sip_info;
+
+	DEBUGP("\nconntrack_sip: help(): DIR=3D%d, conntrackinfo=3D%u\n",
dir, ctinfo);
+	DEBUGP("conntrack_sip: %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n",=20
+		        NIPQUAD(ct->tuplehash[dir].tuple.src.ip),
+		        ntohs(ct->tuplehash[dir].tuple.src.u.udp.port),
+		        NIPQUAD(ct->tuplehash[dir].tuple.dst.ip),=20
+		        ntohs(ct->tuplehash[dir].tuple.dst.u.udp.port)
);
+
+	/* Reset for a new incoming packet */
+	ct_sip_info->mangled =3D 0;=09
+
+	/* keep the connection alive */
+	ip_ct_refresh(ct, (SIP_EXPIRES * HZ));
+
+	/* Don't need to set the expectation for upstream direction */
+	if (dir =3D=3D IP_CT_DIR_REPLY)
+		return NF_ACCEPT;
+
+	/* Need to set the expected connection for further incoming RTP
stream */
+	if (strncmp(data, "INVITE", 6) !=3D 0 && strncmp(data, "SIP/2.0
200", 11) !=3D 0) {
+		DEBUGP("conntrack_sip: Not interesting packet.\n");
+		return NF_ACCEPT;
+	}
+
+	/* Find RTP address */
+	found =3D find_sdp_rtp_addr(data, datalen, &matchoff, &matchlen,
&ipaddr);
+	if (!found)
+		return NF_ACCEPT;
+
+	DEBUGP("conntrack_sip: 'IN IP4' is %s.\n", (found =3D=3D 1) ?
"FQDNs" :=20
+"dotted quads");
+
+	/* If it's a null address, then the call is on hold */
+	if (found =3D=3D 2 && ipaddr =3D=3D 0) {
+		DEBUGP("conntrack_sip: Null address is found.\n");
+		return NF_ACCEPT;
+	}
+
+	/* Find audio port, and we don't like the well-known ports,
+	 * which is less than 1024 */
+	port =3D find_sdp_audio_port(data, datalen, &matchoff, &matchlen);
+	if (port < 1024)
+		return NF_ACCEPT;
+
+	DEBUGP("conntrack_sip: audio port=3D%d.\n", port);
+
+	ipaddr =3D ct->tuplehash[dir].tuple.src.ip;=20
+	ct_sip_info->rtpport =3D port;
+
+	/* RFC1889 - RTP uses an even port number and the corresponding
RTCP
+	 * stream uses the next higher (odd) port number. */
+	if (set_expected_rtp(ct, ipaddr, port, CONN_RTP) =3D=3D 0) { #ifdef=20
+RTCP_SUPPORT
+		set_expected_rtp(ct, ipaddr, port + 1, CONN_RTCP);
#endif
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper sip[MAX_PORTS];
+
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		DEBUGP("ip_ct_sip: unregistering helper for port %d\n",
+				ports[i]);
+		ip_conntrack_helper_unregister(&sip[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D SIP_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&sip[i], 0, sizeof(struct ip_conntrack_helper));
+		sip[i].tuple.dst.u.udp.port =3D htons(ports[i]);
+		sip[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		sip[i].mask.dst.u.udp.port =3D 0xF0FF;
+		sip[i].mask.dst.protonum =3D 0xFFFF;
+		sip[i].help =3D help;
+		sip[i].timeout =3D RTP_TIMEOUT;
+		DEBUGP("ip_ct_sip: registering helper for port %d\n",=20
+				ports[i]);
+		ret =3D ip_conntrack_helper_register(&sip[i]);
+
+		if (ret) {
+			fini();
+			return ret;
+		}
+		ports_c++;
+	}
+	return 0;
+}
+
+
+EXPORT_SYMBOL(ip_sip_lock);
+EXPORT_SYMBOL(ip_conntrack_sip);
+
+module_init(init);
+module_exit(fini);
diff -Nur linux-2.4.20/net/ipv4/netfilter/Makefile
linux-2.4.20-sip/net/ipv4/netfilter/Makefile
--- linux-2.4.20/net/ipv4/netfilter/Makefile	2002-11-29
01:53:15.000000000 +0200
+++ linux-2.4.20-sip/net/ipv4/netfilter/Makefile	2005-01-25
19:01:16.653171704 +0200
@@ -30,8 +30,16 @@
=20
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
++obj-$(CONFIG_IP_NF_SIP) +=3D ip_conntrack_sip.o
+ifdef CONFIG_IP_NF_NAT_SIP
+	export-objs +=3D ip_conntrack_sip.o
+endif
=20
 # connection tracking helpers
+obj-$(CONFIG_IP_NF_SIP) +=3D ip_conntrack_sip.o ifdef=20
+CONFIG_IP_NF_NAT_SIP
+	export-objs +=3D ip_conntrack_sip.o
+endif
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o  ifdef
CONFIG_IP_NF_NAT_FTP
 	export-objs +=3D ip_conntrack_ftp.o
