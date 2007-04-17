From: Carlos Munoz <carlos@kenati.com>
Subject: [PATCH 2.6.20.4] Connection tracking: New SIP ALG that actually
	works
Date: Tue, 17 Apr 2007 13:51:27 -0700
Message-ID: <4625334F.40308@kenati.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020003050108040700070101"
Cc: Ranjit Deshpande <ranjit@kenati.com>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020003050108040700070101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a SIP ALG that actually works. It has been tested extensively
with Asterisk, Vonage, and other SIP servers. It allows for VOIP
applications to run on the router itself as well as behind the router.
We have been shipping this SIP ALG for some time now. We tested the SIP
ALG distributed with kernel 2.6.20.4 and it didn't work (none of the
SIP ALGs distributed with the kernel that we've tested have ever worked).

Signed-off-by: Carlos Munoz <carlos@kenati.com>




--------------020003050108040700070101
Content-Type: text/x-patch;
 name="sip-alg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sip-alg.patch"

diff -uNpr 2.6.20.4.orig/include/linux/netfilter_ipv4/ip_conntrack.h 2.6.20.4/include/linux/netfilter_ipv4/ip_conntrack.h
--- 2.6.20.4.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2007-03-23 12:52:51.000000000 -0700
+++ 2.6.20.4/include/linux/netfilter_ipv4/ip_conntrack.h	2007-04-13 15:26:07.000000000 -0700
@@ -34,6 +34,7 @@ union ip_conntrack_expect_proto {
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+#include <linux/netfilter_ipv4/ip_conntrack_sip.h>
 
 /* per conntrack: application helper private data */
 union ip_conntrack_help {
@@ -42,6 +43,7 @@ union ip_conntrack_help {
 	struct ip_ct_pptp_master ct_pptp_info;
 	struct ip_ct_ftp_master ct_ftp_info;
 	struct ip_ct_irc_master ct_irc_info;
+	struct ip_ct_sip_master ct_sip_info;
 };
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
diff -uNpr 2.6.20.4.orig/include/linux/netfilter_ipv4/ip_conntrack_sip.h 2.6.20.4/include/linux/netfilter_ipv4/ip_conntrack_sip.h
--- 2.6.20.4.orig/include/linux/netfilter_ipv4/ip_conntrack_sip.h	2007-03-23 12:52:51.000000000 -0700
+++ 2.6.20.4/include/linux/netfilter_ipv4/ip_conntrack_sip.h	2007-04-17 13:34:02.000000000 -0700
@@ -1,40 +1,46 @@
-#ifndef __IP_CONNTRACK_SIP_H__
-#define __IP_CONNTRACK_SIP_H__
+/* SIP extension for IP connection tracking.
+ *
+ * Copyright 2006-2007 Kenati Technologies
+ * Carlos Munoz <carlos@kenati.com>
+ */
+
+#ifndef _IP_CONNTRACK_SIP_H
+#define _IP_CONNTRACK_SIP_H
+/* H.323 connection tracking. */
+
 #ifdef __KERNEL__
+extern spinlock_t ip_sip_lock;
+#endif
 
+/* Default H.225 port */
 #define SIP_PORT	5060
-#define SIP_TIMEOUT	3600
 
-enum sip_header_pos {
-	POS_REG_REQ_URI,
-	POS_REQ_URI,
-	POS_FROM,
-	POS_TO,
-	POS_VIA,
-	POS_CONTACT,
-	POS_CONTENT,
-	POS_MEDIA,
-	POS_OWNER,
-	POS_CONNECTION,
-	POS_SDP_HEADER,
+#define SIP_IPTABLES_VOICE_MARK_VALUE "0xdeafdeaf"
+#define SIP_RTP_VOICE_MARK_VALUE 0xdeafdeafU
+
+#define SIP_DEBUG 0
+
+#if SIP_DEBUG
+#define SIP_PRINTK(fmt, args...) \
+printk("<0>" "SIP:%s:%d: " fmt "\n", __FUNCTION__, __LINE__, ##args)
+#else
+#define SIP_PRINTK(fmt, args...) /* (fmt, ##args)*/
+#endif
+
+/* This structure exists only once per master */
+struct ip_ct_sip_master {
+	
+	int is_sip;				/* SIP or RTP connection */
+	
+	int is_ready;				/* All RTP connection details ready */
+
+	u_int32_t ip[IP_CT_DIR_MAX];
+	int rtp_port[IP_CT_DIR_MAX];		
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	enum ip_conntrack_dir dir;		/* Direction of the original connection */
+#endif
+	
 };
 
-extern unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb,
-				       enum ip_conntrack_info ctinfo,
-				       struct ip_conntrack *ct,
-				       const char **dptr);
-extern unsigned int (*ip_nat_sdp_hook)(struct sk_buff **pskb,
-				       enum ip_conntrack_info ctinfo,
-				       struct ip_conntrack_expect *exp,
-				       const char *dptr);
-
-extern int ct_sip_get_info(const char *dptr, size_t dlen,
-			   unsigned int *matchoff,
-			   unsigned int *matchlen,
-			   enum sip_header_pos pos);
-extern int ct_sip_lnlen(const char *line, const char *limit);
-extern const char *ct_sip_search(const char *needle, const char *haystack,
-				 size_t needle_len, size_t haystack_len,
-				 int case_sensitive);
-#endif /* __KERNEL__ */
-#endif /* __IP_CONNTRACK_SIP_H__ */
+#endif /* _IP_CONNTRACK_SIP_H */
diff -uNpr 2.6.20.4.orig/net/ipv4/netfilter/ip_conntrack_sip.c 2.6.20.4/net/ipv4/netfilter/ip_conntrack_sip.c
--- 2.6.20.4.orig/net/ipv4/netfilter/ip_conntrack_sip.c	2007-03-23 12:52:51.000000000 -0700
+++ 2.6.20.4/net/ipv4/netfilter/ip_conntrack_sip.c	2007-04-16 11:16:45.000000000 -0700
@@ -1,520 +1,449 @@
 /* SIP extension for IP connection tracking.
  *
- * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
- * based on RR's ip_conntrack_ftp.c and other modules.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Copyright 2006-2007 Kenati Technologies
+ * Carlos Munoz <carlos@kenati.com>
  */
 
 #include <linux/module.h>
-#include <linux/ctype.h>
-#include <linux/skbuff.h>
-#include <linux/in.h>
+#include <linux/netfilter.h>
+#include <linux/kmod.h>
+#include <linux/kthread.h>
 #include <linux/ip.h>
-#include <linux/udp.h>
+#include <net/checksum.h>
+#include <net/udp.h>
 
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sip.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
+MODULE_AUTHOR("Carlos Munoz <carlos@kenati.com>");
+MODULE_DESCRIPTION("SIP RTP connection tracking module.");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
-MODULE_DESCRIPTION("SIP connection tracking helper");
 
-#define MAX_PORTS	8
-static unsigned short ports[MAX_PORTS];
-static int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of sip servers");
-
-static unsigned int sip_timeout = SIP_TIMEOUT;
-module_param(sip_timeout, uint, 0600);
-MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
+DEFINE_SPINLOCK(ip_sip_lock);
+struct module *ip_conntrack_sip = THIS_MODULE;
 
-unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb,
-				enum ip_conntrack_info ctinfo,
+unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb, 
 				struct ip_conntrack *ct,
-				const char **dptr);
-EXPORT_SYMBOL_GPL(ip_nat_sip_hook);
-
-unsigned int (*ip_nat_sdp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
-				struct ip_conntrack_expect *exp,
-				const char *dptr);
-EXPORT_SYMBOL_GPL(ip_nat_sdp_hook);
-
-static int digits_len(const char *dptr, const char *limit, int *shift);
-static int epaddr_len(const char *dptr, const char *limit, int *shift);
-static int skp_digits_len(const char *dptr, const char *limit, int *shift);
-static int skp_epaddr_len(const char *dptr, const char *limit, int *shift);
-
-struct sip_header_nfo {
-	const char	*lname;
-	const char	*sname;
-	const char	*ln_str;
-	size_t		lnlen;
-	size_t		snlen;
-	size_t		ln_strlen;
-	int		case_sensitive;
-	int		(*match_len)(const char *, const char *, int *);
-};
-
-static struct sip_header_nfo ct_sip_hdrs[] = {
-	[POS_REG_REQ_URI] = { 	/* SIP REGISTER request URI */
-		.lname		= "sip:",
-		.lnlen		= sizeof("sip:") - 1,
-		.ln_str		= ":",
-		.ln_strlen	= sizeof(":") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_REQ_URI] = { 	/* SIP request URI */
-		.lname		= "sip:",
-		.lnlen		= sizeof("sip:") - 1,
-		.ln_str		= "@",
-		.ln_strlen	= sizeof("@") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_FROM] = {		/* SIP From header */
-		.lname		= "From:",
-		.lnlen		= sizeof("From:") - 1,
-		.sname		= "\r\nf:",
-		.snlen		= sizeof("\r\nf:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len,
-	},
-	[POS_TO] = {		/* SIP To header */
-		.lname		= "To:",
-		.lnlen		= sizeof("To:") - 1,
-		.sname		= "\r\nt:",
-		.snlen		= sizeof("\r\nt:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len,
-	},
-	[POS_VIA] = { 		/* SIP Via header */
-		.lname		= "Via:",
-		.lnlen		= sizeof("Via:") - 1,
-		.sname		= "\r\nv:",
-		.snlen		= sizeof("\r\nv:") - 1, /* rfc3261 "\r\n" */
-		.ln_str		= "UDP ",
-		.ln_strlen	= sizeof("UDP ") - 1,
-		.match_len	= epaddr_len,
-	},
-	[POS_CONTACT] = { 	/* SIP Contact header */
-		.lname		= "Contact:",
-		.lnlen		= sizeof("Contact:") - 1,
-		.sname		= "\r\nm:",
-		.snlen		= sizeof("\r\nm:") - 1,
-		.ln_str		= "sip:",
-		.ln_strlen	= sizeof("sip:") - 1,
-		.match_len	= skp_epaddr_len
-	},
-	[POS_CONTENT] = { 	/* SIP Content length header */
-		.lname		= "Content-Length:",
-		.lnlen		= sizeof("Content-Length:") - 1,
-		.sname		= "\r\nl:",
-		.snlen		= sizeof("\r\nl:") - 1,
-		.ln_str		= ":",
-		.ln_strlen	= sizeof(":") - 1,
-		.match_len	= skp_digits_len
-	},
-	[POS_MEDIA] = {		/* SDP media info */
-		.case_sensitive	= 1,
-		.lname		= "\nm=",
-		.lnlen		= sizeof("\nm=") - 1,
-		.sname		= "\rm=",
-		.snlen		= sizeof("\rm=") - 1,
-		.ln_str		= "audio ",
-		.ln_strlen	= sizeof("audio ") - 1,
-		.match_len	= digits_len
-	},
-	[POS_OWNER] = { 	/* SDP owner address*/
-		.case_sensitive	= 1,
-		.lname		= "\no=",
-		.lnlen		= sizeof("\no=") - 1,
-		.sname		= "\ro=",
-		.snlen		= sizeof("\ro=") - 1,
-		.ln_str		= "IN IP4 ",
-		.ln_strlen	= sizeof("IN IP4 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_CONNECTION] = { 	/* SDP connection info */
-		.case_sensitive	= 1,
-		.lname		= "\nc=",
-		.lnlen		= sizeof("\nc=") - 1,
-		.sname		= "\rc=",
-		.snlen		= sizeof("\rc=") - 1,
-		.ln_str		= "IN IP4 ",
-		.ln_strlen	= sizeof("IN IP4 ") - 1,
-		.match_len	= epaddr_len
-	},
-	[POS_SDP_HEADER] = { 	/* SDP version header */
-		.case_sensitive	= 1,
-		.lname		= "\nv=",
-		.lnlen		= sizeof("\nv=") - 1,
-		.sname		= "\rv=",
-		.snlen		= sizeof("\rv=") - 1,
-		.ln_str		= "=",
-		.ln_strlen	= sizeof("=") - 1,
-		.match_len	= digits_len
-	}
-};
+				struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL_GPL(ip_nat_sip_hook);
 
-/* get line lenght until first CR or LF seen. */
-int ct_sip_lnlen(const char *line, const char *limit)
-{
-	const char *k = line;
+#define MASTER_CONN_TIMEOUT	180
 
-	while ((line <= limit) && (*line == '\r' || *line == '\n'))
-		line++;
+/* Requests we know about */ 
+#define REGISTER_CMD "REGISTER sip:"
+#define INVITE_CMD   "INVITE sip:"
+#define BYE_CMD      "BYE sip:"
+#define CANCEL_CMD   "CANCEL sip:"
+#define OPTIONS_CMD  "OPTIONS sip:"
+#define ACK_CMD      "ACK sip:"
+/* Responses we know about */ 
+#define TRYING_CMD   "SIP/2.0 100 Trying"
+#define RINGING_CMD  "SIP/2.0 180 Ringing"
+#define OK_CMD       "SIP/2.0 200 Ok"
+#define TERM_CMD     "SIP/2.0 487 Request Terminated"
+
+
+typedef union sip_msg {
+    unsigned int	all;
+
+    struct {
+        /* Requests */
+	unsigned int	rgster		:1;
+	unsigned int	invite		:1;
+	unsigned int	bye		:1;
+	unsigned int	cancel		:1;
+	unsigned int	options		:1;
+	unsigned int	ack		:1;
+        /* Responses */
+	unsigned int	trying		:1;
+	unsigned int	ringing		:1;
+	unsigned int	ok		:1;
+	unsigned int	term		:1;
+    } bits;
+} sip_msg_t;
+
+
+/* This function is called for each RTP packet in both directions. It updates 
+   the timer of the RTP's control connection (master connection) to keep the 
+   control connection up. This allows packets from the remote agent to be 
+   properly routed to the local agent. If the control connection goes down, 
+   packets from the remote agent would not be routed properly or might be 
+   dropped. Also, it marks the packets as voice packets. Voice packets are 
+   given higher priority by the ethernet driver.
+*/
+static int rtp_help(struct sk_buff		**pskb,
+		    struct ip_conntrack 	*ct,
+		    enum ip_conntrack_info	ctinfo)
+{
+	/* Make sure the control connection stays up by updating its timer */
+	ip_ct_refresh_acct(ct->master, ctinfo, NULL, MASTER_CONN_TIMEOUT * HZ);
+
+#ifdef CONFIG_IP_NF_NAT_SIP_MARK_VOICE
+	/* Mark the packet as a voice packet. Used by the ethernet driver */
+	(*pskb)->nfmark = SIP_RTP_VOICE_MARK_VALUE;
+#endif
 
-	while (line <= limit) {
-		if (*line == '\r' || *line == '\n')
-			break;
-		line++;
-	}
-	return line - k;
+	return NF_ACCEPT;
 }
-EXPORT_SYMBOL_GPL(ct_sip_lnlen);
 
-/* Linear string search, case sensitive. */
-const char *ct_sip_search(const char *needle, const char *haystack,
-			  size_t needle_len, size_t haystack_len,
-			  int case_sensitive)
-{
-	const char *limit = haystack + (haystack_len - needle_len);
+static struct ip_conntrack_helper rtp = 
+    { { NULL, NULL },			/* list */
+      "rtp_helper",			/* name */
+      THIS_MODULE,			/* me */
+      1,				/* max_expected */
+      240,				/* timeout */
+      { { 0, { 0 } }, 			/* tuple */
+	{ 0, { 0 }, IPPROTO_UDP } },
+      { { 0, { 0 } }, 			/* mask */
+	{ 0, { 0 }, 0xFF } },
+      rtp_help,				/* help */
+      NULL
+};
 
-	while (haystack <= limit) {
-		if (case_sensitive) {
-			if (strncmp(haystack, needle, needle_len) == 0)
-				return haystack;
-		} else {
-			if (strnicmp(haystack, needle, needle_len) == 0)
-				return haystack;
-		}
-		haystack++;
+/* This function gets called when the first packet of the RTP connection
+   (the expected related connection) is received. It sets up connection
+   tracking for the expected connection and adds the RTP helper to it.
+*/
+static void sip_exp_rtp(struct ip_conntrack 		*ct,
+			struct ip_conntrack_expect	*exp)
+{
+	SIP_PRINTK ("ct->tuplehash[Original] src=%u.%u.%u.%u:%u "
+		    "dst=%u.%u.%u.%u:%d",
+		    NIPQUAD(ct->tuplehash[0].tuple.src.ip),
+		    ntohs(ct->tuplehash[0].tuple.src.u.udp.port),
+		    NIPQUAD(ct->tuplehash[0].tuple.dst.ip),
+		    ntohs(ct->tuplehash[0].tuple.dst.u.udp.port));
+
+	SIP_PRINTK ("ct->tuplehash[Replay] src=%u.%u.%u.%u:%u "
+		    "dst=%u.%u.%u.%u:%d",
+		    NIPQUAD(ct->tuplehash[1].tuple.src.ip),
+		    ntohs(ct->tuplehash[1].tuple.src.u.udp.port),
+		    NIPQUAD(ct->tuplehash[1].tuple.dst.ip),
+		    ntohs(ct->tuplehash[1].tuple.dst.u.udp.port));
+
+	/* Nat the this packet the same as the master */
+	ip_nat_follow_master(ct, exp);
+
+	if (!ct->helper) {
+		ct->helper = &rtp;
+	} else {
+	    printk(KERN_ERR "sip_exp_rtp(): ct->helper != NULL\n");
 	}
-	return NULL;
 }
-EXPORT_SYMBOL_GPL(ct_sip_search);
 
-static int digits_len(const char *dptr, const char *limit, int *shift)
-{
-	int len = 0;
-	while (dptr <= limit && isdigit(*dptr)) {
-		dptr++;
-		len++;
-	}
-	return len;
-}
+/* Extract the data port from the m= line. This line looks like this:
+   m=audio 49172 RTP/AVP 3 97 98 8 0 101
+*/
+static u_int16_t get_data_port(char		*data,
+			       char		*data_limit)
+
+{
+	u_int16_t	data_port = 0;
+
+	/* Find out the port from m= line */
+	while (data < data_limit) {
+		/* Find the m= line */
+		if (strnicmp(data, "\nm=", 3) && strnicmp(data, "\rm=", 3)) {
+			data++;
+			continue;
+		}
+		data += 3;
 
-/* get digits lenght, skiping blank spaces. */
-static int skp_digits_len(const char *dptr, const char *limit, int *shift)
-{
-	for (; dptr <= limit && *dptr == ' '; dptr++)
-		(*shift)++;
+		/* Make sure it's an audio stream */
+		if (strnicmp(data, "audio ", 6))
+			continue;
+		data += 6;
 
-	return digits_len(dptr, limit, shift);
-}
+		/* skip white space */
+		while (*data == ' ') {
+			if (data == data_limit)
+				return 0;
+			data++;
+		}
 
-/* Simple ipaddr parser.. */
-static int parse_ipaddr(const char *cp,	const char **endp,
-			__be32 *ipaddr, const char *limit)
-{
-	unsigned long int val;
-	int i, digit = 0;
+		data_port = simple_strtoul(data, &data, 10);
 
-	for (i = 0, *ipaddr = 0; cp <= limit && i < 4; i++) {
-		digit = 0;
-		if (!isdigit(*cp))
-			break;
-
-		val = simple_strtoul(cp, (char **)&cp, 10);
-		if (val > 0xFF)
-			return -1;
-
-		((u_int8_t *)ipaddr)[i] = val;
-		digit = 1;
-
-		if (*cp != '.')
-			break;
-		cp++;
+		break;
 	}
-	if (!digit)
-		return -1;
-
-	if (endp)
-		*endp = cp;
 
-	return 0;
+	return data_port;
 }
 
-/* skip ip address. returns it lenght. */
-static int epaddr_len(const char *dptr, const char *limit, int *shift)
-{
-	const char *aux = dptr;
-	__be32 ip;
-
-	if (parse_ipaddr(dptr, &dptr, &ip, limit) < 0) {
-		DEBUGP("ip: %s parse failed.!\n", dptr);
-		return 0;
-	}
+/* Extract the ip address from the c= line. This line looks like this:
+   c=IN IP4 192.168.1.75
 
-	/* Port number */
-	if (*dptr == ':') {
-		dptr++;
-		dptr += digits_len(dptr, limit, shift);
-	}
-	return dptr - aux;
-}
+*/
+static u_int32_t get_remote_addr(char		*data,
+				 char		*data_limit)
 
-/* get address length, skiping user info. */
-static int skp_epaddr_len(const char *dptr, const char *limit, int *shift)
 {
-	int s = *shift;
-
-	/* Search for @, but stop at the end of the line.
-	 * We are inside a sip: URI, so we don't need to worry about
-	 * continuation lines. */
-	while (dptr <= limit &&
-	       *dptr != '@' && *dptr != '\r' && *dptr != '\n') {
-		(*shift)++;
-		dptr++;
-	}
-
-	if (dptr <= limit && *dptr == '@') {
-		dptr++;
-		(*shift)++;
-	} else
-		*shift = s;
-
-	return epaddr_len(dptr, limit, shift);
-}
+	u_int32_t	ip = 0;
+	int		p1;
+	int		p2;
+	int		p3;
+	int		p4;
 
-/* Returns 0 if not found, -1 error parsing. */
-int ct_sip_get_info(const char *dptr, size_t dlen,
-		    unsigned int *matchoff,
-		    unsigned int *matchlen,
-		    enum sip_header_pos pos)
-{
-	struct sip_header_nfo *hnfo = &ct_sip_hdrs[pos];
-	const char *limit, *aux, *k = dptr;
-	int shift = 0;
-
-	limit = dptr + (dlen - hnfo->lnlen);
-
-	while (dptr <= limit) {
-		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
-		    (hnfo->sname == NULL ||
-		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
-			dptr++;
+	/* Find out the remote address from c= line */
+	while (data < data_limit) {
+		/* find the c= line */
+		if (strnicmp(data, "\nc=", 3) && strnicmp(data, "\rc=", 3)) {
+			data++;
 			continue;
 		}
-		aux = ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,
-		                    ct_sip_lnlen(dptr, limit),
-				    hnfo->case_sensitive);
-		if (!aux) {
-			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str,
-			       hnfo->lname);
-			return -1;
-		}
-		aux += hnfo->ln_strlen;
+		data += 3;
+
+		/* Make sure it's has an ip address */
+		if (strnicmp(data, "IN IP4 ", 7))
+			continue;
+		data += 7;
 
-		*matchlen = hnfo->match_len(aux, limit, &shift);
-		if (!*matchlen)
-			return -1;
+		p1 = simple_strtoul(data, &data, 10);
+		if (*data != '.')
+			return 0;
+		p2 = simple_strtoul(data + 1, &data, 10);
+		if (*data != '.')
+			return 0;
+		p3 = simple_strtoul(data + 1, &data, 10);
+		if (*data != '.')
+			return 0;
+		p4 = simple_strtoul(data + 1, &data, 10);
+
+		ip = (p1 << 24) | (p2 << 16) | (p3 << 8) | p4;
+
+		break;
+	}
+
+	return ip;
+}
+
+/* This function is called for every UDP packet with the source port set to
+   the SIP port (see init()).
+*/
+static int sip_help(struct sk_buff		**pskb,
+		    struct ip_conntrack 	*ct,
+		    enum ip_conntrack_info	ctinfo)
+{
+	const struct iphdr *iph = (*pskb)->nh.iph;
+	struct udphdr *udph = (void *)(iph) + (iph)->ihl * 4;
+	u_int32_t udplen = (*pskb)->len - (iph)->ihl * 4;
+	char *data = (char *)udph + sizeof(struct udphdr);
+	u_int32_t datalen = udplen - sizeof(struct udphdr);
+	char *data_limit = data + datalen;
+	int dir = CTINFO2DIR(ctinfo);
+	struct ip_ct_sip_master *info = &ct->help.ct_sip_info;
+	sip_msg_t msg;
+	struct ip_conntrack_expect *exp = NULL;
+	int ret = NF_ACCEPT;
 
-		*matchoff = (aux - k) + shift;
+	/* Check if this packet was originated from the gateway itself. If it
+	   was, accept it without any further processing */
+	if (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip == 
+	    ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip)
+		return NF_ACCEPT;
 
-		DEBUGP("%s match succeeded! - len: %u\n", hnfo->lname,
-		       *matchlen);
-		return 1;
+	SIP_PRINTK ("\n############SIP Packet#############");
+	SIP_PRINTK ("%u.%u.%u.%u:%u->%u.%u.%u.%u:%u (dir=%s)",
+		    NIPQUAD(iph->saddr), 
+		    ntohs(udph->source),
+		    NIPQUAD(iph->daddr), 
+		    ntohs(udph->dest),
+		    (dir == IP_CT_DIR_ORIGINAL) ? "original" : "reply");
+
+	SIP_PRINTK ("ct->tuplehash[Original] src=%u.%u.%u.%u:%u "
+		    "dst=%u.%u.%u.%u:%d",
+		    NIPQUAD(ct->tuplehash[0].tuple.src.ip),
+		    ntohs(ct->tuplehash[0].tuple.src.u.udp.port),
+		    NIPQUAD(ct->tuplehash[0].tuple.dst.ip),
+		    ntohs(ct->tuplehash[0].tuple.dst.u.udp.port));
+
+	SIP_PRINTK ("ct->tuplehash[Replay] src=%u.%u.%u.%u:%u "
+		    "dst=%u.%u.%u.%u:%d",
+		    NIPQUAD(ct->tuplehash[1].tuple.src.ip),
+		    ntohs(ct->tuplehash[1].tuple.src.u.udp.port),
+		    NIPQUAD(ct->tuplehash[1].tuple.dst.ip),
+		    ntohs(ct->tuplehash[1].tuple.dst.u.udp.port));
+
+	/* Can't track connections formed before we registered */
+	if (!info) {
+		
+		SIP_PRINTK ("info == NULL");
+		
+		return NF_ACCEPT;
+	}
+		
+	/* Not whole UDP header? */
+	if (udplen < sizeof(struct udphdr)) {
+		
+		SIP_PRINTK("updlen too short for udp header, udplen = %u",
+				(unsigned)udplen);
+		
+		return NF_ACCEPT;
 	}
-	DEBUGP("%s header not found.\n", hnfo->lname);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ct_sip_get_info);
 
-static int set_expected_rtp(struct sk_buff **pskb,
-			    struct ip_conntrack *ct,
-			    enum ip_conntrack_info ctinfo,
-			    __be32 ipaddr, u_int16_t port,
-			    const char *dptr)
-{
-	struct ip_conntrack_expect *exp;
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	int ret;
-	typeof(ip_nat_sdp_hook) ip_nat_sdp;
-
-	exp = ip_conntrack_expect_alloc(ct);
-	if (exp == NULL)
-		return NF_DROP;
-
-	exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
-	exp->tuple.src.u.udp.port = 0;
-	exp->tuple.dst.ip = ipaddr;
-	exp->tuple.dst.u.udp.port = htons(port);
-	exp->tuple.dst.protonum = IPPROTO_UDP;
-
-	exp->mask.src.ip = htonl(0xFFFFFFFF);
-	exp->mask.src.u.udp.port = 0;
-	exp->mask.dst.ip = htonl(0xFFFFFFFF);
-	exp->mask.dst.u.udp.port = htons(0xFFFF);
-	exp->mask.dst.protonum = 0xFF;
-
-	exp->expectfn = NULL;
-	exp->flags = 0;
-
-	ip_nat_sdp = rcu_dereference(ip_nat_sdp_hook);
-	if (ip_nat_sdp)
-		ret = ip_nat_sdp(pskb, ctinfo, exp, dptr);
-	else {
-		if (ip_conntrack_expect_related(exp) != 0)
-			ret = NF_DROP;
-		else
-			ret = NF_ACCEPT;
+	/* Checksum invalid?  Ignore. */
+	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
+				csum_partial((char *)udph, udplen, 0))) {
+		
+		SIP_PRINTK("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u",
+				udph, 
+				udplen, 
+				NIPQUAD(iph->saddr),
+				NIPQUAD(iph->daddr));
+		
+		return NF_ACCEPT;
 	}
-	ip_conntrack_expect_put(exp);
 
-	return ret;
-}
+	/* Find the type of message we are handling */
+	msg.all = 0;
+	if (!strnicmp(data, REGISTER_CMD, strlen(REGISTER_CMD))) {
+	        SIP_PRINTK("SIP Register Packet Arrived:");
+		msg.bits.rgster = 1;
+	} else if (!strnicmp(data, INVITE_CMD, strlen(INVITE_CMD))) {
+	        SIP_PRINTK("SIP Invite Packet Arrived:");
+		msg.bits.invite = 1;
+	} else if (!strnicmp(data, BYE_CMD, strlen(BYE_CMD))) {
+	        SIP_PRINTK("SIP Bye Packet Arrived:");
+		msg.bits.bye = 1;
+	} else if (!strnicmp(data, CANCEL_CMD, strlen(CANCEL_CMD))) {
+	        SIP_PRINTK("SIP Cancel Packet Arrived:");
+		msg.bits.cancel = 1;
+	} else if (!strnicmp(data, OPTIONS_CMD, strlen(OPTIONS_CMD))) {
+	        SIP_PRINTK("SIP Options Packet Arrived:");
+		msg.bits.options = 1;
+	} else if (!strnicmp(data, ACK_CMD, strlen(ACK_CMD))) {
+	        SIP_PRINTK("SIP Ack Packet Arrived:");
+		msg.bits.ack = 1;
+	} else if (!strnicmp(data, TRYING_CMD, strlen(TRYING_CMD))) {
+	        SIP_PRINTK("SIP Trying Packet Arrived:");
+		msg.bits.trying = 1;
+	} else if (!strnicmp(data, RINGING_CMD, strlen(RINGING_CMD))) {
+	        SIP_PRINTK("SIP Ringing Packet Arrived:");
+		msg.bits.ringing = 1;
+	} else if (!strnicmp(data, OK_CMD, strlen(OK_CMD))) {
+	        SIP_PRINTK("SIP Ok Packet Arrived:");
+		msg.bits.ok = 1;
+	} else if (!strnicmp(data, TERM_CMD, strlen(TERM_CMD))) {
+	        SIP_PRINTK("SIP Term Packet Arrived:");
+		msg.bits.term = 1;
+	} else {
+		unsigned char buf[80];
+		int i;
+		for (i = 0; i < 80 - 1 && (buf[i] = data[i] != '\n'); i++);
+		buf[i] = 0;
+	        SIP_PRINTK("SIP Unkown Packet Type Arrived: %s", buf);
+	}
+
+	/* We need to set up a expected related connection for the RTP traffic
+	   from the remote host to the our local rtp port. We get the remote 
+	   host's ip address from the invite request or OK response in the reply 
+	   direction. We get our local rtp port from the invite request or OK 
+	   response in the original direction. (Note this ALG assumes the 
+	   control SIP connection is always initiated from the LAN side making 
+	   the original direction always from LAN to the internet/WAN). The 
+	   expected related connection set ups connection tracking to accept 
+	   packets to our local RTP port from the remote host. The expected 
+	   related connection is set up only when sending/receiving the OK 
+	   response since that's when we have all the information. */
+	if (msg.bits.invite || msg.bits.ok) {
+		u_int16_t	port = 0;
+		u_int32_t	ip = 0;
+
+		/* In the original direction we get the local rtp port */
+		if (dir == IP_CT_DIR_ORIGINAL) {
+			port = get_data_port(data, data_limit);
+			if (port)
+				info->rtp_port[dir] = port;
+		} else {
+			/* In the reply direction we get the remote ip 
+			   address */
+			ip = get_remote_addr(data, data_limit);
+			if (ip)
+				info->ip[dir] = ip;
+		}
 
-static int sip_help(struct sk_buff **pskb,
-		    struct ip_conntrack *ct,
-		    enum ip_conntrack_info ctinfo)
-{
-	unsigned int dataoff, datalen;
-	const char *dptr;
-	int ret = NF_ACCEPT;
-	int matchoff, matchlen;
-	__be32 ipaddr;
-	u_int16_t port;
-	typeof(ip_nat_sip_hook) ip_nat_sip;
-
-	/* No Data ? */
-	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
-	if (dataoff >= (*pskb)->len) {
-		DEBUGP("skb->len = %u\n", (*pskb)->len);
-		return NF_ACCEPT;
-        }
+		/* Set up the expected connection when we get the OK and we
+		   either got the port or ip out of it. This is needed because
+		   OK responses to other requests should not setup expected
+		   connections */
+		if (msg.bits.ok && (port || ip)) {
+			/* Allocate expectation which will be inserted */
+			exp = ip_conntrack_expect_alloc(ct);
+			if (exp == NULL) {
+				return NF_DROP;
+			}
 
-	ip_ct_refresh(ct, *pskb, sip_timeout * HZ);
+			/* Remember the expeced related connection expects
+			   something from the remote end to us. */
+			exp->tuple.src.ip = htonl(info->ip[IP_CT_DIR_REPLY]);
+			exp->tuple.src.u.udp.port = 0;
+			exp->tuple.dst.ip = 
+				ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+			exp->tuple.dst.u.udp.port = 
+				htons(info->rtp_port[IP_CT_DIR_ORIGINAL]);
+			exp->tuple.dst.protonum = IPPROTO_UDP;
+			exp->mask = ((struct ip_conntrack_tuple)
+				{ { 0xFFFFFFFF, { 0 } },
+				  { 0xFFFFFFFF, { .udp = { 0xFFFF } }, 0xFF }});
+			exp->expectfn = sip_exp_rtp;
+			exp->dir = IP_CT_DIR_REPLY;
 
-	if (!skb_is_nonlinear(*pskb))
-		dptr = (*pskb)->data + dataoff;
-	else {
-		DEBUGP("Copy of skbuff not supported yet.\n");
-		goto out;
+		}
 	}
 
-	ip_nat_sip = rcu_dereference(ip_nat_sip_hook);
-	if (ip_nat_sip) {
-		if (!ip_nat_sip(pskb, ctinfo, ct, &dptr)) {
+	spin_lock_bh(&ip_sip_lock);
+
+	/* Modify the payload now */
+	if (ip_nat_sip_hook) {
+		if (!ip_nat_sip_hook(pskb, ct, ctinfo, exp)) {
 			ret = NF_DROP;
-			goto out;
 		}
+	} else if (exp) {
+		/* Can't expect this?  Best to drop packet now. */
+		if (ip_conntrack_expect_related(exp) != 0)
+			ret = NF_DROP;
 	}
 
-	/* After this point NAT, could have mangled skb, so
-	   we need to recalculate payload lenght. */
-	datalen = (*pskb)->len - dataoff;
-
-	if (datalen < (sizeof("SIP/2.0 200") - 1))
-		goto out;
-
-	/* RTP info only in some SDP pkts */
-	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) != 0 &&
-	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) != 0) {
-		goto out;
-	}
-	/* Get ip and port address from SDP packet. */
-	if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,
-	                    POS_CONNECTION) > 0) {
-
-		/* We'll drop only if there are parse problems. */
-		if (parse_ipaddr(dptr + matchoff, NULL, &ipaddr,
-		                 dptr + datalen) < 0) {
-			ret = NF_DROP;
-			goto out;
-		}
-		if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,
-		                    POS_MEDIA) > 0) {
+	if (exp)
+		ip_conntrack_expect_put(exp);
 
-			port = simple_strtoul(dptr + matchoff, NULL, 10);
-			if (port < 1024) {
-				ret = NF_DROP;
-				goto out;
-			}
-			ret = set_expected_rtp(pskb, ct, ctinfo,
-					       ipaddr, port, dptr);
-		}
-	}
-out:
+	spin_unlock_bh(&ip_sip_lock);
 	return ret;
+
 }
 
-static struct ip_conntrack_helper sip[MAX_PORTS];
-static char sip_names[MAX_PORTS][10];
+static struct ip_conntrack_helper sip;
+static char *sip_name = "SIP";
 
-static void fini(void)
+static int __init init(void)
 {
-	int i;
-	for (i = 0; i < ports_c; i++) {
-		DEBUGP("unregistering helper for port %d\n", ports[i]);
-		ip_conntrack_helper_unregister(&sip[i]);
-	}
+	SIP_PRINTK ("INIT function: %s\n", sip_name);
+	sip.name = sip_name;
+	sip.tuple.src.u.udp.port = htons(SIP_PORT);
+	sip.tuple.dst.protonum = IPPROTO_UDP;
+	sip.mask.src.u.udp.port = 0xFFFF;
+	sip.mask.dst.protonum = 0xFF;
+	sip.max_expected = 1;
+	sip.timeout = 4 * 60; /* 4 minutes */
+	sip.me = THIS_MODULE;
+	sip.help = sip_help;
+
+	return ip_conntrack_helper_register(&sip);
 }
 
-static int __init init(void)
+static void __exit fini(void)
 {
-	int i, ret;
-	char *tmpname;
-
-	if (ports_c == 0)
-		ports[ports_c++] = SIP_PORT;
+	SIP_PRINTK ("EXIT function: %s\n", sip_name);
+	/* Unregister SIP helper */	
+	ip_conntrack_helper_unregister(&sip);
 
-	for (i = 0; i < ports_c; i++) {
-		/* Create helper structure */
-		memset(&sip[i], 0, sizeof(struct ip_conntrack_helper));
-
-		sip[i].tuple.dst.protonum = IPPROTO_UDP;
-		sip[i].tuple.src.u.udp.port = htons(ports[i]);
-		sip[i].mask.src.u.udp.port = htons(0xFFFF);
-		sip[i].mask.dst.protonum = 0xFF;
-		sip[i].max_expected = 2;
-		sip[i].timeout = 3 * 60; /* 3 minutes */
-		sip[i].me = THIS_MODULE;
-		sip[i].help = sip_help;
-
-		tmpname = &sip_names[i][0];
-		if (ports[i] == SIP_PORT)
-			sprintf(tmpname, "sip");
-		else
-			sprintf(tmpname, "sip-%d", i);
-		sip[i].name = tmpname;
-
-		DEBUGP("port #%d: %d\n", i, ports[i]);
-
-		ret = ip_conntrack_helper_register(&sip[i]);
-		if (ret) {
-			printk("ERROR registering helper for port %d\n",
-				ports[i]);
-			fini();
-			return ret;
-		}
-	}
-	return 0;
 }
 
+EXPORT_SYMBOL(ip_sip_lock);
+
 module_init(init);
 module_exit(fini);
diff -uNpr 2.6.20.4.orig/net/ipv4/netfilter/ip_nat_sip.c 2.6.20.4/net/ipv4/netfilter/ip_nat_sip.c
--- 2.6.20.4.orig/net/ipv4/netfilter/ip_nat_sip.c	2007-03-23 12:52:51.000000000 -0700
+++ 2.6.20.4/net/ipv4/netfilter/ip_nat_sip.c	2007-04-16 11:14:13.000000000 -0700
@@ -1,282 +1,593 @@
-/* SIP extension for UDP NAT alteration.
+/* 
+ * SIP 'brute force' extension for NAT alteration. 
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *
- * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
- * based on RR's ip_nat_ftp.c and other modules.
+ * Copyright 2006-2007 Kenati Technologies
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Based on ip_masq_sip.c for 2.2 kernels from CoRiTel, Sofia project.
+ * (http://www.coritel.it/projects/sofia/nat.html)
+ * Uses Sampsa Ranta's excellent idea on using expectfn to 'bind'
+ * the unregistered helpers to the conntrack entries.
+ */
+/*
+ * Modification history net/ipv4/netfilter/ip_nat_sip.c
+ * 
+ * 2006-01-20	Carlos Munoz <carlos@kenati.com>
+ *      Major rewrite to properly update sip/sdp payload.
  */
 
 #include <linux/module.h>
-#include <linux/skbuff.h>
+#include <linux/netfilter.h>
 #include <linux/ip.h>
-#include <linux/udp.h>
+#include <net/checksum.h>
+#include <net/udp.h>
 
-#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sip.h>
 
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_DESCRIPTION("SIP 'brute force' connection tracking module");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
-MODULE_DESCRIPTION("SIP NAT helper");
+
+struct module *ip_nat_sip_mod = THIS_MODULE;
+
+//#define SIP_DEBUG
 
 #if 0
 #define DEBUGP printk
+#define PRINTK_M(fmt, args...) printk("%s:%d "fmt, __FILE__, __LINE__, ##args)
 #else
 #define DEBUGP(format, args...)
 #endif
 
-struct addr_map {
-	struct {
-		char		src[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
-		char		dst[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
-		unsigned int	srclen, srciplen;
-		unsigned int	dstlen, dstiplen;
-	} addr[IP_CT_DIR_MAX];
-};
+#define SDP_DELIM	"\r\n\r\n"
+
+#define ISALPHA(c) (((c) >= 'A' && (c) <= 'Z') || ((c) >= 'a' && (c) <= 'z'))
+#define ISDIGIT(c) (((c) >= '0') && ((c) <= '9'))
+
+#define	IS_IP_ADDR_CHAR(c)				\
+    (((c) >= '0' && (c) <= '9') || (c) == '.')
 
-static void addr_map_init(struct ip_conntrack *ct, struct addr_map *map)
+extern unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb, 
+				       struct ip_conntrack *ct,
+				       enum ip_conntrack_info ctinfo,
+				       struct ip_conntrack_expect *exp);
+
+typedef struct sip_fqdn_parse_info {
+	/* Offset of the FQDN in the via field of the SIP header */
+	unsigned int	via_offset;
+	int 		via_len;
+	int		via_flag;
+
+	/* Offset of the FQDN in the contact field of the SIP header */
+	int 		contact_offset;
+	int 		contact_len;
+	int 		contact_flag;
+
+	/* Offset of the FQDN in the from field of the SIP header */
+	int 		from_adrs_ip_offset;
+	int		from_adrs_ip_len;
+	int		from_adrs_ip_flag;
+} sip_fqdn_parse_info_t;
+
+/* Parse the via line. We need to extract the FQDN from the via line. The
+   via line can have a FQDN or IP address and it looks like this:
+   Via: SIP/2.0/UDP 192.168.22.50;rport;branch=z9hG4bKc0a81632000000
+   Via: SIP/2.0/UDP pc33.atlanta.com;branch=z9hG4bKhjhs8ass877
+*/
+static void parse_via(char			*data,
+		      char			*data_limit,
+		      sip_fqdn_parse_info_t	*fqdn_parse_info)
 {
-	struct ip_conntrack_tuple *t;
-	enum ip_conntrack_dir dir;
-	unsigned int n;
-
-	for (dir = 0; dir < IP_CT_DIR_MAX; dir++) {
-		t = &ct->tuplehash[dir].tuple;
-
-		n = sprintf(map->addr[dir].src, "%u.%u.%u.%u",
-			    NIPQUAD(t->src.ip));
-		map->addr[dir].srciplen = n;
-		n += sprintf(map->addr[dir].src + n, ":%u",
-			     ntohs(t->src.u.udp.port));
-		map->addr[dir].srclen = n;
-
-		n = sprintf(map->addr[dir].dst, "%u.%u.%u.%u",
-			    NIPQUAD(t->dst.ip));
-		map->addr[dir].dstiplen = n;
-		n += sprintf(map->addr[dir].dst + n, ":%u",
-			     ntohs(t->dst.u.udp.port));
-		map->addr[dir].dstlen = n;
+        char		*data_start = data;
+	char		*addrstart;
+	char		*addrend;
+
+	/* Look for via: */
+	while (data < data_limit) {
+		/* Find the topmost tag */
+		if (strnicmp(data, "\nVia:", 5) && strnicmp(data, "\nv:", 3) && 
+		    strnicmp(data, "\rVia:", 5) && strnicmp(data, "\rv:", 3)) {
+			data++;
+			continue;
+		}
+		data += 3;
+
+		/* Look for UDP, since this masq module only does udp anyways */
+		while (*data != 'U' && *data != 'u') {
+			if (data >= data_limit)
+				return;
+			data++;
+		}
+		data += 3;
+
+		if (data >= data_limit)
+			return;
+
+		/* Skip white space */
+		while (*data == ' ') {
+			data++;
+			if (data == data_limit)
+				return;
+		}
+
+		/* Mark the start of the FQDN or IP address */
+		addrstart = data;
+
+		/* Mark the end of the FQDN or IP address */
+		while (ISALPHA(*data) || ISDIGIT(*data) || (*data == '.') || 
+		       (*data == '-')) {
+			data++;
+			if (data == data_limit)
+				return;
+		}
+		addrend = data;
+
+		/* We are only interested in FQDNs. Check if it is a FQDN */
+		for (data = addrstart; data < addrend ; data++) {
+		        /* If is not an IP address, it must be a FQDN */
+		        if ( !IS_IP_ADDR_CHAR(*data)) {
+			        fqdn_parse_info->via_offset = 
+				    addrstart - data_start;
+				fqdn_parse_info->via_len = addrend - addrstart;
+				fqdn_parse_info->via_flag = 1;
+				break;
+			}
+		}
 	}
 }
 
-static int map_sip_addr(struct sk_buff **pskb, enum ip_conntrack_info ctinfo,
-			struct ip_conntrack *ct, const char **dptr, size_t dlen,
-			enum sip_header_pos pos, struct addr_map *map)
+/* Parse the contact line. We need to extract the FQDN. The contact line
+   can have a FQDN or IP address and it looks like this:
+   Contact: <sip:192.168.22.50:5060>
+   Contact: <sip:alice@pc33.atlanta.com>
+   Contact: <sip:bob@192.0.2.4>
+   Contact: sip:caller@u1.example.com
+*/
+static void parse_contact(char			*data,
+			  char			*data_limit,
+			  sip_fqdn_parse_info_t	*fqdn_parse_info)
 {
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	unsigned int matchlen, matchoff, addrlen;
-	char *addr;
+        char		*data_start = data;
+	char		*addrstart;
+	char		*addrend;
+
+	while (data < data_limit) {
+		/* Find the topmost tag */
+		if (strnicmp(data, "\nContact:", 9) && 
+		    strnicmp(data, "\nm:", 3) && 
+		    strnicmp(data, "\rContact:", 9) && 
+		    strnicmp(data, "\rm:", 3)) {
+			data++;
+			continue;
+		}
+		data += 3;
 
-	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, pos) <= 0)
-		return 1;
+		/* Look for sip: */
+		while (strnicmp(data, "sip:", 4)) {
+			data++;
+			if (data >= data_limit)
+				break;
+		}
+		data += 4;
 
-	if ((matchlen == map->addr[dir].srciplen ||
-	     matchlen == map->addr[dir].srclen) &&
-	    memcmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
-		addr    = map->addr[!dir].dst;
-		addrlen = map->addr[!dir].dstlen;
-	} else if ((matchlen == map->addr[dir].dstiplen ||
-		    matchlen == map->addr[dir].dstlen) &&
-		   memcmp(*dptr + matchoff, map->addr[dir].dst, matchlen) == 0) {
-		addr    = map->addr[!dir].src;
-		addrlen = map->addr[!dir].srclen;
-	} else
-		return 1;
+		/* We have to look to see if there's user info in the contact 
+		   field */
+		addrstart = data;
+
+		while (*data != '@' && *data != '>' && *data != ';' && 
+		       *data != '\n' && *data != '\r' && *data != '?' && 
+		       *data != ',' && *data != ':') {
+			data++;
+			if (data >= data_limit)
+				break;
+		}
+
+		/* Skip userinfo */
+		if (*data == '@') {
+			data++;
+		} else {
+			data = addrstart;
+		}
 
-	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
-	                              matchoff, matchlen, addr, addrlen))
-		return 0;
-	*dptr = (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
-	return 1;
+		/* Mark the start of the FQDN or IP address */
+		addrstart = data;
+
+		/* Mark the end of the FQDN or IP address */
+		while (ISALPHA(*data) || ISDIGIT(*data) || (*data=='.') || 
+		       (*data=='-')) {
+			data++;
+			if (data == data_limit)
+				break;
+		}
+		addrend = data;
 
+		/* We are only interested in FQDNs. Check if it is a FQDN */
+		for (data = addrstart; data < addrend ; data++) {
+		        /* If is not an IP address, it must be a FQDN */
+		        if ( !IS_IP_ADDR_CHAR(*data)) {
+			        fqdn_parse_info->contact_offset = 
+				    addrstart - data_start;
+				fqdn_parse_info->contact_len = 
+				    addrend - addrstart;
+				fqdn_parse_info->contact_flag = 1;
+				break;
+			}
+		}
+	}
 }
 
-static unsigned int ip_nat_sip(struct sk_buff **pskb,
-			       enum ip_conntrack_info ctinfo,
-			       struct ip_conntrack *ct,
-			       const char **dptr)
+/* Parse the from line. We need to extract the FQDN. The from line
+   can have a FQDN or ip address and it looks like this:
+   From: "unknown"<sip:192.168.22.50>;tag=3163159485542
+   From: "Bob" <sips:bob@biloxi.com> ;tag=a48s
+   From: sip:+12125551212@phone2net.com;tag=887s
+*/
+static void parse_from(char			*data,
+		       char			*data_limit,
+		       sip_fqdn_parse_info_t	*fqdn_parse_info)
 {
-	enum sip_header_pos pos;
-	struct addr_map map;
-	int dataoff, datalen;
-
-	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
-	datalen = (*pskb)->len - dataoff;
-	if (datalen < sizeof("SIP/2.0") - 1)
-		return NF_DROP;
-
-	addr_map_init(ct, &map);
-
-	/* Basic rules: requests and responses. */
-	if (strncmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) != 0) {
-		/* 10.2: Constructing the REGISTER Request:
-		 *
-		 * The "userinfo" and "@" components of the SIP URI MUST NOT
-		 * be present.
-		 */
-		if (datalen >= sizeof("REGISTER") - 1 &&
-		    strncmp(*dptr, "REGISTER", sizeof("REGISTER") - 1) == 0)
-			pos = POS_REG_REQ_URI;
+        char		*data_start = data;
+	char		*addrstart;
+	char		*addrend;
+
+	while (data < data_limit) {
+		/* Find the From: tag */
+		if (strnicmp(data, "\nFrom:", 6) && 
+		    strnicmp(data, "\rFrom:", 6)) {
+			data++;
+			continue;
+		}
+		data += 6;
+
+		while (*data != ':' && *data != '\n' && *data!= '\r') {
+			data++;
+			if (data >= data_limit)
+			        return;
+		}
+
+		if (*data == '\n' || *data == '\r')
+		        return;
+
+		/* We have to look to see if there's user info in the from 
+		   field */
+		addrstart = ++data;
+
+		/* Check for userinfo */
+		while (*data != '>'  && *data != '@' && *data != ';' &&
+		       *data != '\n' && *data!= '\r') {
+		        data++;
+			if (data >= data_limit)
+			        return;
+		}
+
+		if (*data == '@')
+			data++;
 		else
-			pos = POS_REQ_URI;
+		        data = addrstart;
 
-		if (!map_sip_addr(pskb, ctinfo, ct, dptr, datalen, pos, &map))
-			return NF_DROP;
-	}
 
-	if (!map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_FROM, &map) ||
-	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_TO, &map) ||
-	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_VIA, &map) ||
-	    !map_sip_addr(pskb, ctinfo, ct, dptr, datalen, POS_CONTACT, &map))
-		return NF_DROP;
-	return NF_ACCEPT;
+		/* Mark the start of the FQDN or IP address */
+		addrstart = data;
+
+		/* Mark the end of the FQDN or IP address */
+		while (ISALPHA(*data) || ISDIGIT(*data) || (*data=='.') || 
+		       (*data=='-')) {
+			data++;
+			if (data == data_limit)
+				break;
+		}
+		addrend = data;
+
+		/* We are only interested in FQDNs. Check if it is a FQDN */
+		for (data = addrstart; data < addrend ; data++) {
+		        /* If is not an IP address, it must be a FQDN */
+		        if ( !IS_IP_ADDR_CHAR(*data)) {
+			        fqdn_parse_info->from_adrs_ip_offset = 
+				    addrstart - data_start;
+				fqdn_parse_info->from_adrs_ip_len = 
+				    addrend - addrstart;
+				fqdn_parse_info->from_adrs_ip_flag = 1;
+				break;
+			}
+		}
+	}
 }
 
-static unsigned int mangle_sip_packet(struct sk_buff **pskb,
-				      enum ip_conntrack_info ctinfo,
-				      struct ip_conntrack *ct,
-				      const char **dptr, size_t dlen,
-				      char *buffer, int bufflen,
-				      enum sip_header_pos pos)
+/* Calculate the size of the SDP part.
+   returns	 0 if no SDP found
+		-1 if no end string "\r\n\r\n"
+		>0 size of SDP
+*/
+static int sdp_size(char	*data, 
+		    char 	*endsip, 
+		    char 	*endstr)
 {
-	unsigned int matchlen, matchoff;
+        char *dp = data;
 
-	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, pos) <= 0)
-		return 0;
-
-	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
-	                              matchoff, matchlen, buffer, bufflen))
-		return 0;
-
-	/* We need to reload this. Thanks Patrick. */
-	*dptr = (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
-	return 1;
+	while(dp <= endsip) {
+	    if(!strnicmp(dp, endstr, strlen(endstr)))
+		    break;
+	    dp++;
+	}
+	return (endsip-dp);
 }
 
-static int mangle_content_len(struct sk_buff **pskb,
-			      enum ip_conntrack_info ctinfo,
-			      struct ip_conntrack *ct,
-			      const char *dptr)
+static void search_and_mangle( struct sk_buff 		**pskb, 
+			       struct ip_conntrack 	*ct,
+			       enum ip_conntrack_info 	ctinfo,
+			       char			*data,
+			       uint32_t			datalen,
+			       char			*search_addr,
+			       int			search_addr_len,
+			       char			*new_addr,
+			       int			new_addr_len)
 {
-	unsigned int dataoff, matchoff, matchlen;
-	char buffer[sizeof("65536")];
-	int bufflen;
+        char	*curr = data;
 
-	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	while(curr <= data + datalen - search_addr_len) {
+	        if(!memcmp(curr, search_addr, search_addr_len)) {
+		        ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+						 curr - data, 
+						 search_addr_len,
+						 new_addr, new_addr_len);
+			curr += new_addr_len - 1;
+		}
+		curr++;
+	}
+}
 
-	/* Get actual SDP lenght */
-	if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,
-	                    &matchlen, POS_SDP_HEADER) > 0) {
+static int get_content_length(char		*data,
+			      char		*data_limit,
+			      int		*cont_len_offset,
+			      int		*cont_len_len,
+			      int		*cont_len)
+{
+        char		*data_start = data;
+	char		*cont_len_start;
 
-		/* since ct_sip_get_info() give us a pointer passing 'v='
-		   we need to add 2 bytes in this count. */
-		int c_len = (*pskb)->len - dataoff - matchoff + 2;
+	while (data < data_limit) {
+		/* find the content length line */
+		if (strnicmp(data, "\nContent-Length: ", 17) && 
+		    strnicmp(data, "\rContent-Length: ", 17)) {
+			data++;
+			continue;
+		}
+		data += 17;
 
-		/* Now, update SDP lenght */
-		if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,
-		                    &matchlen, POS_CONTENT) > 0) {
+		cont_len_start = data;
 
-			bufflen = sprintf(buffer, "%u", c_len);
+		*cont_len = simple_strtoul(data, &data, 10);
+		*cont_len_offset = cont_len_start - data_start;
+		*cont_len_len = data - cont_len_start;
 
-			return ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
-							matchoff, matchlen,
-							buffer, bufflen);
-		}
+		return 1;
 	}
+
 	return 0;
 }
 
-static unsigned int mangle_sdp(struct sk_buff **pskb,
-			       enum ip_conntrack_info ctinfo,
-			       struct ip_conntrack *ct,
-			       __be32 newip, u_int16_t port,
-			       const char *dptr)
+/* Mangle the port in the SDP body. The port line look like this:
+   m=audio 49172 RTP/AVP 3 97 98 8 0 101
+*/
+static void mangle_port(struct sk_buff		**pskb, 
+			struct ip_conntrack	*ct,
+			enum ip_conntrack_info	ctinfo,
+			char			*data,
+			uint32_t		datalen,
+			u_int16_t 		port)
 {
-	char buffer[sizeof("nnn.nnn.nnn.nnn")];
-	unsigned int dataoff, bufflen;
+	char *data_start = data;
+	char *data_limit = data + datalen;
+	char *port_start;
+	int port_offset;
+	int port_len;
+	char new_port[16];
+	int new_port_len;
+
+	printk(KERN_ERR "Got to mangle_port()\n");
+
+	/* Find out the port from m= line */
+	while (data < data_limit) {
+		/* Find the m= line */
+		if (strnicmp(data, "\nm=", 3) && strnicmp(data, "\rm=", 3)) {
+			data++;
+			continue;
+		}
+		data += 3;
+
+		/* Make sure it's an audio stream */
+		if (strnicmp(data, "audio ", 6))
+			continue;
+		data += 6;
+
+		/* skip white space */
+		while (*data == ' ') {
+			if (data == data_limit)
+				return;
+			data++;
+		}
 
-	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+		port_start = data;
+		port_offset = port_start - data_start;
+		simple_strtoul(data,&data,10);
+		port_len = data - port_start;
 
-	/* Mangle owner and contact info. */
-	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
-	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, POS_OWNER))
-		return 0;
-
-	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, POS_CONNECTION))
-		return 0;
-
-	/* Mangle media port. */
-	bufflen = sprintf(buffer, "%u", port);
-	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, POS_MEDIA))
-		return 0;
+		sprintf(new_port, "%u", port);
+		new_port_len = strlen(new_port);
 
-	return mangle_content_len(pskb, ctinfo, ct, dptr);
+        	ip_nat_mangle_udp_packet(pskb, ct, ctinfo, port_offset, 
+					 port_len, new_port, new_port_len);
+
+		break;
+	}
 }
 
-/* So, this packet has hit the connection tracking matching code.
-   Mangle it, and change the expectation to match the new version. */
-static unsigned int ip_nat_sdp(struct sk_buff **pskb,
+
+static unsigned int ip_nat_sip(struct sk_buff **pskb, 
+			       struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
-			       struct ip_conntrack_expect *exp,
-			       const char *dptr)
+			       struct ip_conntrack_expect *exp)
 {
-	struct ip_conntrack *ct = exp->master;
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	__be32 newip;
-	u_int16_t port;
-
-	DEBUGP("ip_nat_sdp():\n");
-
-	/* Connection will come from reply */
-	newip = ct->tuplehash[!dir].tuple.dst.ip;
-
-	exp->tuple.dst.ip = newip;
-	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
-	exp->dir = !dir;
-
-	/* When you see the packet, we need to NAT it the same as the
-	   this one. */
-	exp->expectfn = ip_nat_follow_master;
-
-	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
-		exp->tuple.dst.u.udp.port = htons(port);
-		if (ip_conntrack_expect_related(exp) == 0)
-			break;
+	const struct iphdr *iph = (*pskb)->nh.iph;
+	struct udphdr *udph = (void *)(iph) + (iph)->ihl * 4;
+	char *data = (char *)udph + sizeof(struct udphdr);
+	uint32_t datalen = ntohs(udph->len) - sizeof(struct udphdr);
+	char *data_limit = data + datalen;
+	int dir = CTINFO2DIR(ctinfo);
+	uint32_t newip;
+	char new_addr[16];
+	int new_addr_len;
+	uint32_t searchip;
+	char search_addr[16];
+	int search_addr_len;
+	sip_fqdn_parse_info_t fqdn_parse_info;
+	int cont_len;
+	int cont_len_offset;
+	int cont_len_len;
+	int new_cont_len;
+	char new_cont_len_str[16];
+	u_int16_t port = 0;
+
+	/* Get the IP address to replace */
+	if (dir == IP_CT_DIR_REPLY) {
+		newip    = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		searchip = ct->tuplehash[IP_CT_DIR_REPLY   ].tuple.dst.ip;
+	} else {
+		newip    = ct->tuplehash[IP_CT_DIR_REPLY   ].tuple.dst.ip;
+		searchip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 	}
 
-	if (port == 0)
-		return NF_DROP;
+	/* Only NAT the packete if the ip addresses are different */
+	if (newip != searchip) {
+		sprintf(new_addr, "%u.%u.%u.%u", NIPQUAD(newip));
+		new_addr_len = strlen(new_addr);
+		sprintf (search_addr, "%u.%u.%u.%u", NIPQUAD(searchip));
+		search_addr_len = strlen(search_addr);
+
+		/* Get the offset of the FQDNs on the payload */
+		memset(&fqdn_parse_info, 0, sizeof(fqdn_parse_info));
+		if (dir == IP_CT_DIR_ORIGINAL) {
+	        	parse_via(data, data_limit, &fqdn_parse_info);
+			parse_contact(data, data_limit, &fqdn_parse_info);
+			parse_from(data, data_limit, &fqdn_parse_info);
+		}
+
+		/* Search for the last offset in the FQDN list and mangle it, 
+		   continue untill no more flags are on, this way offsets are 
+		   correct for mangling (start with last offset and go to 
+		   first) */
+		while(1) {
+	        	int 	max_off = 0;
+			int 	max_len = 0;
+			int 	*max_flagp = NULL;
+		
+			if (fqdn_parse_info.via_flag && 
+			    fqdn_parse_info.via_offset > max_off) {
+		        	max_off = fqdn_parse_info.via_offset;
+				max_len = fqdn_parse_info.via_len;
+				max_flagp = &fqdn_parse_info.via_flag;
+			}
+
+			if (fqdn_parse_info.contact_flag && 
+			    fqdn_parse_info.contact_offset > max_off) {
+		        	max_off = fqdn_parse_info.contact_offset;
+				max_len = fqdn_parse_info.contact_len;
+				max_flagp = &fqdn_parse_info.contact_flag;
+			}
+
+			if (fqdn_parse_info.from_adrs_ip_flag && 
+			    fqdn_parse_info.from_adrs_ip_offset > max_off) {
+		        	max_off = fqdn_parse_info.from_adrs_ip_offset;
+				max_len = fqdn_parse_info.from_adrs_ip_len;
+				max_flagp = &fqdn_parse_info.from_adrs_ip_flag;
+			}
+			
+			if(max_flagp && *max_flagp) {
+		        	ip_nat_mangle_udp_packet(pskb, ct, ctinfo, 
+							 max_off, max_len, 
+							 new_addr, 
+							 new_addr_len);
+				*max_flagp = 0;
+			}
+			else 
+		        	break;
+		}
+
+		/* Update the datalen since the mangling process may have 
+		   changed the size of the packet */
+		datalen = ntohs(udph->len) - sizeof(struct udphdr);
+
+		/* Now we can do a search and replace of the IP address */
+		search_and_mangle(pskb, ct, ctinfo, data, datalen, search_addr, 
+				  search_addr_len, new_addr, new_addr_len);
+	} /* if (newip != searchip) */
+
+	/* Check if we need to modify the expected connection's destination
+	   port */
+	if (exp) {
+		/* Try to get same port: if not, try to change it. */
+		exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
+		for (port = ntohs(exp->saved_proto.udp.port); port != 0; 
+		     port++) {
+			exp->tuple.dst.u.udp.port = htons(port);
+			if (ip_conntrack_expect_related(exp) == 0)
+				break;
+		}
 
-	if (!mangle_sdp(pskb, ctinfo, ct, newip, port, dptr)) {
-		ip_conntrack_unexpect_related(exp);
-		return NF_DROP;
+		/* Mangle the packet if the port changed */
+		if (ntohs(exp->saved_proto.udp.port) != port) {
+			datalen = ntohs(udph->len) - sizeof(struct udphdr);
+			mangle_port(pskb, ct, ctinfo, data, datalen, port);
+		}
 	}
-	return NF_ACCEPT;
-}
 
-static void __exit fini(void)
-{
-	rcu_assign_pointer(ip_nat_sip_hook, NULL);
-	rcu_assign_pointer(ip_nat_sdp_hook, NULL);
-	synchronize_rcu();
+	/* Check if the SDP body size changed. If it did, update the
+	   content length field. Don't forget to recalculate the datalen
+	   first since the packet size may have changed */
+	if (newip != searchip || 
+	    (exp && ntohs(exp->saved_proto.udp.port) != port)) {
+		datalen = ntohs(udph->len) - sizeof(struct udphdr);
+		new_cont_len = sdp_size(data, data + datalen - 
+					strlen(SDP_DELIM), SDP_DELIM);
+		if (get_content_length(data, data + datalen, &cont_len_offset,
+				       &cont_len_len, &cont_len)) {
+			if (cont_len != new_cont_len) {
+				snprintf(new_cont_len_str, 
+					 sizeof(new_cont_len_str), "%d", 
+					 new_cont_len);
+				new_cont_len_str[16 - 1] = 0;
+
+				ip_nat_mangle_udp_packet(pskb, ct, ctinfo, 
+							 cont_len_offset, 
+							 cont_len_len, 
+							 new_cont_len_str,
+							 strlen(new_cont_len_str));
+			}
+		}
+	}
+
+        return NF_ACCEPT;
 }
 
 static int __init init(void)
 {
-	BUG_ON(rcu_dereference(ip_nat_sip_hook));
-	BUG_ON(rcu_dereference(ip_nat_sdp_hook));
-	rcu_assign_pointer(ip_nat_sip_hook, ip_nat_sip);
-	rcu_assign_pointer(ip_nat_sdp_hook, ip_nat_sdp);
+	BUG_ON(ip_nat_sip_hook);
+	ip_nat_sip_hook = ip_nat_sip;
+
 	return 0;
 }
 
+static void __exit fini(void)
+{
+	ip_nat_sip_hook = NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
+}
+
 module_init(init);
 module_exit(fini);

--------------020003050108040700070101--
