From: Sven Schuster <schuster.sven@gmx.de>
Subject: [PATCH 3/3] pom-ng: update sip-conntrack-nat for 2.6.12
Date: Tue, 26 Jul 2005 21:05:19 +0200
Message-ID: <20050726190519.GA2128@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--wzJLGUyc3ArbnUjN
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

the attached patch updates the sip-conntrack-nat patchlet in pom-ng
for 2.6.12.

Compile-tested by me on 2.6.13-rc3-mm1, I haven't been able to verify
the functionality, but at least the module loads :-)


Regards,

Sven


--=20
Linux zion 2.6.13-rc3-mm1 #12 PREEMPT Sun Jul 24 02:04:45 CEST 2005 i686 at=
hlon i386 GNU/Linux
 21:05:06 up 1 day, 21:14,  1 user,  load average: 0.30, 0.58, 0.33

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="sip.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.=
6.12/include/linux/netfilter_ipv4/ip_conntrack_sip.h pom-ng-sip/patchlets/s=
ip-conntrack-nat/linux-2.6.12/include/linux/netfilter_ipv4/ip_conntrack_sip=
=2Eh
--- pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.6.12/include/linux/netfi=
lter_ipv4/ip_conntrack_sip.h	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-sip/patchlets/sip-conntrack-nat/linux-2.6.12/include/linux/netfi=
lter_ipv4/ip_conntrack_sip.h	2005-07-03 22:40:24.000000000 +0200
@@ -0,0 +1,78 @@
+#ifndef __IP_CONNTRACK_SIP_H__
+#define __IP_CONNTRACK_SIP_H__
+/* SIP tracking. */
+
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
+#define POS_CONECTION	5
+#define POS_REQ_HEADER	6
+#define POS_SDP_HEADER	7
+
+struct sip_header_nfo {
+	const char *lname;
+	size_t lnlen;
+	const char *sname;
+	size_t snlen;
+	const char *ln_str;
+	size_t ln_strlen;
+	int (*match_len)(const char *, const char *, int *);
+
+};
+
+extern unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb,=20
+				enum ip_conntrack_info ctinfo,
+				struct ip_conntrack *ct,
+				const char **dptr);
+			=09
+/* For NAT to hook in when on expect. */
+extern unsigned int (*ip_nat_sdp_hook)(struct sk_buff **pskb,=20
+				enum ip_conntrack_info ctinfo,
+				struct ip_conntrack_expect *exp,
+				const char *dptr);
+
+extern int ct_sip_get_info(const char *dptr, size_t dlen,=20
+				unsigned int *matchoff,=20
+				unsigned int *matchlen,=20
+				struct sip_header_nfo *hnfo);
+
+/* get line lenght until first CR or LF seen. */
+static __inline__ int ct_sip_lnlen(const char *line, const char *limit)
+{
+        const char *k =3D line;
+
+        while ((line <=3D limit) && (*line =3D=3D '\r' || *line =3D=3D '\n=
'))
+                line++;
+
+        while (line <=3D limit) {
+                if (*line =3D=3D '\r' || *line =3D=3D '\n')
+                        break;
+                line++;
+        }
+        return line - k;
+}
+
+/* Linear string search, case sensitive. */
+static __inline__=20
+const char *ct_sip_search(const char *needle, const char *haystack,=20
+			size_t needle_len, size_t haystack_len)=20
+{
+	const char *limit =3D haystack + (haystack_len - needle_len);
+
+	while (haystack <=3D limit) {
+		if (memcmp(haystack, needle, needle_len) =3D=3D 0)
+			return haystack;
+		haystack++;
+	}
+	return NULL;
+}
+#endif /* __KERNEL__ */
+
+#endif /* __IP_CONNTRACK_SIP_H__ */
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/ip_conntrack_sip.c pom-ng-sip/patchlets/sip-conntra=
ck-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_sip.c
--- pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_conntrack_sip.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-sip/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_conntrack_sip.c	2005-07-24 01:33:51.000000000 +0200
@@ -0,0 +1,407 @@
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
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ctype.h>
+#include <net/checksum.h>
+#include <net/udp.h>
+
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_sip.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
+MODULE_DESCRIPTION("SIP connection tracking helper");
+
+static DEFINE_SPINLOCK(sipbf_lock);
+
+#define MAX_PORTS	8
+static int ports[MAX_PORTS];
+static int ports_c;
+module_param_array(ports, int, &ports_c, 0400);
+MODULE_PARM_DESC(ports, " port numbers of sip servers");
+
+static unsigned int sip_timeout =3D SIP_TIMEOUT;
+
+module_param(sip_timeout, int, 0600);
+MODULE_PARM_DESC(sip_timeout, "timeout for the master sip session");
+
+unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb,=20
+				enum ip_conntrack_info ctinfo,
+				struct ip_conntrack *ct,
+				const char **dptr);
+EXPORT_SYMBOL_GPL(ip_nat_sip_hook);
+			=09
+unsigned int (*ip_nat_sdp_hook)(struct sk_buff **pskb,=20
+				enum ip_conntrack_info ctinfo,
+				struct ip_conntrack_expect *exp,
+				const char *dptr);
+EXPORT_SYMBOL_GPL(ip_nat_sdp_hook);
+
+int ct_sip_get_info(const char *dptr, size_t dlen,=20
+				unsigned int *matchoff,=20
+				unsigned int *matchlen,=20
+				struct sip_header_nfo *hnfo);
+EXPORT_SYMBOL(ct_sip_get_info);
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int digits_len(const char *dptr, const char *limit, int *shift);
+static int epaddr_len(const char *dptr, const char *limit, int *shift);
+static int skp_digits_len(const char *dptr, const char *limit, int *shift);
+static int skp_epaddr_len(const char *dptr, const char *limit, int *shift);
+
+struct sip_header_nfo ct_sip_hdrs[] =3D {
+	{ 	/* Via header */
+		"Via:",		sizeof("Via:") - 1,
+		"\r\nv:",	sizeof("\r\nv:") - 1, /* rfc3261 "\r\n" */
+		"UDP ", 	sizeof("UDP ") - 1,
+		epaddr_len
+	},
+	{ 	/* Contact header */
+		"Contact:",	sizeof("Contact:") - 1,
+		"\r\nm:",	sizeof("\r\nm:") - 1,
+		"sip:",		sizeof("sip:") - 1,
+		skp_epaddr_len
+	},
+	{ 	/* Content length header */
+		"Content-Length:", sizeof("Content-Length:") - 1,
+		"\r\nl:",	sizeof("\r\nl:") - 1,
+		":",		sizeof(":") - 1,=20
+		skp_digits_len
+	},
+	{	/* SDP media info */
+		"\nm=3D",		sizeof("\nm=3D") - 1,=09
+		"\rm=3D",		sizeof("\rm=3D") - 1,
+		"audio ",	sizeof("audio ") - 1,
+		digits_len
+	},
+	{ 	/* SDP owner address*/=09
+		"\no=3D",		sizeof("\no=3D") - 1,=20
+		"\ro=3D",		sizeof("\ro=3D") - 1,
+		"IN IP4 ",	sizeof("IN IP4 ") - 1,
+		epaddr_len
+	},
+	{ 	/* SDP connection info */
+		"\nc=3D",		sizeof("\nc=3D") - 1,=20
+		"\rc=3D",		sizeof("\rc=3D") - 1,
+		"IN IP4 ",	sizeof("IN IP4 ") - 1,
+		epaddr_len
+	},
+	{ 	/* Requests headers */
+		"sip:",		sizeof("sip:") - 1,
+		"sip:",		sizeof("sip:") - 1, /* yes, i know.. ;) */
+		"@", 		sizeof("@") - 1,=20
+		epaddr_len
+	},
+	{ 	/* SDP version header */
+		"\nv=3D",		sizeof("\nv=3D") - 1,
+		"\rv=3D",		sizeof("\rv=3D") - 1,
+		"=3D", 		sizeof("=3D") - 1,=20
+		digits_len
+	}
+};
+EXPORT_SYMBOL(ct_sip_hdrs);
+
+
+static int digits_len(const char *dptr, const char *limit, int *shift)
+{
+	int len =3D 0;=09
+	while (dptr <=3D limit && isdigit(*dptr)) {
+		dptr++;
+		len++;
+	}
+	return len;
+}=20
+
+/* get digits lenght, skiping blank spaces. */
+static int skp_digits_len(const char *dptr, const char *limit, int *shift)
+{
+	for (; dptr <=3D limit && *dptr =3D=3D ' '; dptr++)
+		(*shift)++;
+	=09
+	return digits_len(dptr, limit, shift);
+}
+
+/* Simple ipaddr parser.. */
+static int parse_ipaddr(const char *cp,	const char **endp,=20
+			uint32_t *ipaddr, const char *limit)
+{
+	unsigned long int val;
+	int i, digit =3D 0;
+=09
+	for (i =3D 0, *ipaddr =3D 0; cp <=3D limit && i < 4; i++) {
+		digit =3D 0;
+		if (!isdigit(*cp))
+			break;
+	=09
+		val =3D simple_strtoul(cp, (char **)&cp, 10);
+		if (val > 0xFF)
+			return -1;
+=09
+		((uint8_t *)ipaddr)[i] =3D val;=09
+		digit =3D 1;
+=09
+		if (*cp !=3D '.')
+			break;
+		cp++;
+	}
+	if (!digit)
+		return -1;
+=09
+	if (endp)
+		*endp =3D cp;
+
+	return 0;
+}
+
+/* skip ip address. returns it lenght. */
+static int epaddr_len(const char *dptr, const char *limit, int *shift)
+{
+	const char *aux =3D dptr;
+	uint32_t ip;
+=09
+	if (parse_ipaddr(dptr, &dptr, &ip, limit) < 0) {
+		DEBUGP("ip: %s parse failed.!\n", dptr);
+		return 0;
+	}
+
+	/* Port number */
+	if (*dptr =3D=3D ':') {
+		dptr++;
+		dptr +=3D digits_len(dptr, limit, shift);
+	}
+	return dptr - aux;
+}
+
+/* get address lenght, skiping user info. */
+static int skp_epaddr_len(const char *dptr, const char *limit, int *shift)
+{
+	for (; dptr <=3D limit && *dptr !=3D '@'; dptr++)
+		(*shift)++;=09
+=09
+	if (*dptr =3D=3D '@') {
+		dptr++;
+		(*shift)++;
+		return epaddr_len(dptr, limit, shift);
+	}=09
+	return  0;
+}
+
+/* Returns 0 if not found, -1 error parsing. */
+int ct_sip_get_info(const char *dptr, size_t dlen,=20
+		unsigned int *matchoff,=20
+		unsigned int *matchlen,
+		struct sip_header_nfo *hnfo)
+{
+	const char *limit, *aux, *k =3D dptr;
+	int shift =3D 0;
+=09
+	limit =3D dptr + (dlen - hnfo->lnlen);
+
+	while (dptr <=3D limit) {
+		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) !=3D 0) &&
+			(strncmp(dptr, hnfo->sname, hnfo->snlen) !=3D 0))
+		{
+			dptr++;
+			continue;
+		}
+		aux =3D ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,=20
+						ct_sip_lnlen(dptr, limit));
+		if (!aux) {
+			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str, hnfo->lname);
+			return -1;
+		}
+		aux +=3D hnfo->ln_strlen;
+	=09
+		*matchlen =3D hnfo->match_len(aux, limit, &shift);
+		if (!*matchlen)
+			return -1;
+
+		*matchoff =3D (aux - k) + shift;=20
+	=09
+		DEBUGP("%s match succeeded! - len: %u\n", hnfo->lname, *matchlen);
+		return 1;
+	}
+	DEBUGP("%s header not found.\n", hnfo->lname);
+	return 0;
+}
+
+static int set_expected_rtp(struct sk_buff **pskb,=20
+			struct ip_conntrack *ct,
+			enum ip_conntrack_info ctinfo,=20
+			uint32_t ipaddr, uint16_t port,
+			const char *dptr)
+{
+	struct ip_conntrack_expect *exp;
+=09
+	exp =3D ip_conntrack_expect_alloc();
+	if (exp =3D=3D NULL)
+		return NF_DROP;
+
+	exp->tuple =3D ((struct ip_conntrack_tuple)
+		{ { ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip, { 0 } },
+		  { ipaddr, { .udp =3D { htons(port) } }, IPPROTO_UDP }});
+		 =20
+	exp->mask =3D ((struct ip_conntrack_tuple)=20
+		{ { 0xFFFFFFFF, { 0 } },
+		  { 0xFFFFFFFF, { .udp =3D { 0xFFFF } }, 0xFF }});
+
+	exp->expectfn =3D NULL;
+	exp->master =3D ct;
+=09
+	if (ip_nat_sdp_hook)
+		return ip_nat_sdp_hook(pskb, ctinfo, exp, dptr);
+	else if (ip_conntrack_expect_related(exp) !=3D 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
+static int sip_help(struct sk_buff **pskb,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	unsigned int dataoff, datalen;
+	const char *dptr;
+	int ret =3D NF_ACCEPT;
+	int matchoff, matchlen;
+	uint32_t ipaddr;
+	uint16_t port;
+=09
+	/* No Data ? */=20
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+	if (dataoff >=3D (*pskb)->len) {
+		DEBUGP("skb->len =3D %u\n", (*pskb)->len);
+		return NF_ACCEPT;
+        }
+       =20
+	ip_ct_refresh_acct(ct, ctinfo, NULL, sip_timeout * HZ);
+	=09
+	spin_lock_bh(&sipbf_lock);
+=09
+	if ((dataoff + (*pskb)->len - dataoff) <=3D skb_headlen(*pskb))
+		dptr =3D (*pskb)->data + dataoff;
+	else {
+		DEBUGP("Copy of skbuff not supported yet.\n");
+		goto out;
+	}
+=09
+	if (ip_nat_sip_hook) {
+		if (!ip_nat_sip_hook(pskb, ctinfo, ct, &dptr)) {
+			ret =3D NF_DROP;
+			goto out;
+		}
+	}
+=09
+	if ((ctinfo) >=3D IP_CT_IS_REPLY)
+		goto out;
+
+	/* After this point NAT, could have mangled skb, so=20
+	   we need to recalculate payload lenght. */
+	datalen =3D (*pskb)->len - dataoff;
+
+	if (datalen < (sizeof("SIP/2.0 200") - 1))
+		goto out;
+=09
+	/* RTP info only in some SDP pkts */
+	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) !=3D 0 &&=20
+	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) !=3D 0) {
+		goto out;
+	}
+	/* Get ip and port address from SDP packet. */
+	if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,=20
+	    &ct_sip_hdrs[POS_CONECTION]) > 0) {
+
+		/* We'll drop only if there are parse problems. */
+		if (parse_ipaddr(dptr + matchoff, NULL, &ipaddr,=20
+		    dptr + datalen) < 0) {
+			ret =3D NF_DROP;
+			goto out;
+		}
+		if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,=20
+		    &ct_sip_hdrs[POS_MEDIA]) > 0) {
+
+			port =3D simple_strtoul(dptr + matchoff, NULL, 10);
+			if (port < 1024) {
+				ret =3D NF_DROP;
+				goto out;
+			}
+			ret =3D set_expected_rtp(pskb, ct, ctinfo,
+						ipaddr, port, dptr);
+		}
+	}
+out:	spin_unlock_bh(&sipbf_lock);
+	return ret;
+}
+
+static struct ip_conntrack_helper sip[MAX_PORTS];
+static char sip_names[MAX_PORTS][10];
+
+static void fini(void)
+{
+	int i =3D 0;
+	for (; i < ports_c; i++) {
+		DEBUGP("unregistering helper for port %d\n", ports[i]);
+		ip_conntrack_helper_unregister(&sip[i]);
+	}=20
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (ports_c =3D=3D 0)
+		ports[ports_c++] =3D SIP_PORT;
+
+	for (i =3D 0; i < ports_c; i++) {
+		/* Create helper structure */
+		memset(&sip[i], 0, sizeof(struct ip_conntrack_helper));
+
+		sip[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		sip[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		sip[i].mask.src.u.udp.port =3D 0xFFFF;
+		sip[i].mask.dst.protonum =3D 0xFF;
+		sip[i].max_expected =3D 1;
+		sip[i].timeout =3D 3 * 60; /* 3 minutes */
+		sip[i].me =3D THIS_MODULE;
+		sip[i].help =3D sip_help;
+
+		tmpname =3D &sip_names[i][0];
+		if (ports[i] =3D=3D SIP_PORT)
+			sprintf(tmpname, "sip");
+		else
+			sprintf(tmpname, "sip-%d", i);
+		sip[i].name =3D tmpname;
+
+		DEBUGP("port #%d: %d\n", i, ports[i]);
+
+		ret=3Dip_conntrack_helper_register(&sip[i]);
+		if (ret) {
+			printk("ERROR registering helper for port %d\n",
+				ports[i]);
+			fini();
+			return(ret);
+		}
+	}
+	return(0);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/ip_nat_sip.c pom-ng-sip/patchlets/sip-conntrack-nat=
/linux-2.6.12/net/ipv4/netfilter/ip_nat_sip.c
--- pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_nat_sip.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-sip/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_nat_sip.c	2005-07-03 22:40:24.000000000 +0200
@@ -0,0 +1,253 @@
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
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/moduleparam.h>
+#include <net/udp.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_sip.h>
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
+static unsigned int mangle_sip_packet(struct sk_buff **pskb,=20
+			enum ip_conntrack_info ctinfo,
+			struct ip_conntrack *ct,=20
+			const char **dptr, size_t dlen,
+			char *buffer, int bufflen,
+			struct sip_header_nfo *hnfo)
+{
+	unsigned int matchlen, matchoff;
+=09
+	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, hnfo) <=3D 0)
+		return 0;
+
+	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,=20
+	    matchoff, matchlen, buffer, bufflen)) {
+		return 0;
+	}
+	/* We need to reload this. Thanks Patrick. */
+	*dptr =3D (*pskb)->data + (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);=
=20
+	return 1;
+}
+
+static unsigned int ip_nat_sip(struct sk_buff **pskb,=20
+			enum ip_conntrack_info ctinfo,
+			struct ip_conntrack *ct,
+			const char **dptr)
+{
+	char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];=09
+	unsigned int bufflen, dataoff;
+	uint32_t ip;
+	uint16_t port;
+=09
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+=09
+	if ((ctinfo) >=3D IP_CT_IS_REPLY) {
+		ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		port =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	} else {
+		ip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+		port =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port;
+	}
+	bufflen =3D sprintf(buffer, "%u.%u.%u.%u:%u", NIPQUAD(ip), ntohs(port));
+=09
+	/* short packet ? */
+	if (((*pskb)->len - dataoff) < (sizeof("SIP/2.0") - 1))
+		return 0;
+=09
+	/* Basic rules: requests and responses. */
+	if (memcmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) =3D=3D 0) {
+=09
+		if ((ctinfo) < IP_CT_IS_REPLY) {
+			mangle_sip_packet(pskb, ctinfo, ct, dptr,=20
+				(*pskb)->len - dataoff, buffer, bufflen,
+				&ct_sip_hdrs[POS_CONTACT]);
+			return 1;
+		}
+
+		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,
+		    buffer, bufflen, &ct_sip_hdrs[POS_VIA])) {
+			return 0;
+		}
+	=09
+		/* This search should ignore case, but later.. */
+		const char *aux =3D ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1,=
=20
+								(*pskb)->len - dataoff);
+		if (!aux)
+			return 0;
+	=09
+		if (!ct_sip_search("REGISTER", aux, sizeof("REGISTER"),=20
+		    ct_sip_lnlen(aux, *dptr + (*pskb)->len - dataoff))) {
+			return 1;
+		}
+		return mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,=
=20
+						buffer, bufflen, &ct_sip_hdrs[POS_CONTACT]);
+	}
+	if ((ctinfo) < IP_CT_IS_REPLY) {
+		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,
+		    buffer, bufflen, &ct_sip_hdrs[POS_VIA])) {
+			return 0;
+		}
+	=09
+		/* Mangle Contact if exists only. - watch udp_nat_mangle()! */
+		mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,=20
+						buffer, bufflen, &ct_sip_hdrs[POS_CONTACT]);
+		return 1;
+	}
+	/* This mangle requests headers. */
+	return mangle_sip_packet(pskb, ctinfo, ct, dptr,=20
+			ct_sip_lnlen(*dptr, *dptr + (*pskb)->len - dataoff),
+			buffer, bufflen, &ct_sip_hdrs[POS_REQ_HEADER]);
+}
+
+static int mangle_content_len(struct sk_buff **pskb,=20
+			enum ip_conntrack_info ctinfo,
+			struct ip_conntrack *ct,
+			const char *dptr)
+{
+	unsigned int dataoff, matchoff, matchlen;
+	char buffer[sizeof("65536")];
+	int bufflen;
+=09
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+=09
+	/* Get actual SDP lenght */
+	if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,=20
+	    &matchlen, &ct_sip_hdrs[POS_SDP_HEADER]) > 0) {
+	=09
+		/* since ct_sip_get_info() give us a pointer passing 'v=3D'
+		   we need to add 2 bytes in this count. */
+		int c_len =3D (*pskb)->len - dataoff - matchoff + 2;
+	=09
+		/* Now, update SDP lenght */
+		if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,=20
+		    &matchlen, &ct_sip_hdrs[POS_CONTENT]) > 0) {
+		   =20
+			bufflen =3D sprintf(buffer, "%u", c_len);
+		=09
+			return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, matchoff,
+							matchlen, buffer, bufflen);
+		}
+	}
+	return 0;
+}
+
+static unsigned int mangle_sdp(struct sk_buff **pskb,=20
+			enum ip_conntrack_info ctinfo,
+			struct ip_conntrack *ct,
+			uint32_t newip, uint16_t port,
+			const char *dptr)
+{
+	char buffer[sizeof("nnn.nnn.nnn.nnn")];
+	unsigned int dataoff, bufflen;
+
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
+=09
+	/* Mangle owner and contact info. */
+	bufflen =3D sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	    buffer, bufflen, &ct_sip_hdrs[POS_OWNER])) {
+		return 0;=09
+	}
+=09
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	    buffer, bufflen, &ct_sip_hdrs[POS_CONECTION])) {
+		return 0;
+	}
+=09
+	/* Mangle media port. */
+	bufflen =3D sprintf(buffer, "%u", port);
+	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
+	    buffer, bufflen, &ct_sip_hdrs[POS_MEDIA])) {
+		return 0;
+	}
+=09
+	return mangle_content_len(pskb, ctinfo, ct, dptr);
+}
+
+/* So, this packet has hit the connection tracking matching code.
+   Mangle it, and change the expectation to match the new version. */
+static unsigned int ip_nat_sdp(struct sk_buff **pskb,=20
+			enum ip_conntrack_info ctinfo,
+			struct ip_conntrack_expect *exp,
+			const char *dptr)
+{
+	struct ip_conntrack *ct =3D exp->master;
+	uint32_t newip;
+	uint16_t port;
+=09
+	DEBUGP("ip_nat_sdp():\n");
+
+	/* Connection will come from reply */
+	newip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+=09
+	exp->tuple.dst.ip =3D newip;
+	exp->saved_proto.udp.port =3D exp->tuple.dst.u.udp.port;
+	exp->dir =3D IP_CT_DIR_REPLY;
+
+	/* When you see the packet, we need to NAT it the same as the
+	   this one. */
+	exp->expectfn =3D ip_nat_follow_master;
+
+	/* Try to get same port: if not, try to change it. */
+	for (port =3D ntohs(exp->saved_proto.udp.port); port !=3D 0; port++) {
+		exp->tuple.dst.u.udp.port =3D htons(port);
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)
+			break;
+	}
+=09
+	if (port =3D=3D 0) {
+		ip_conntrack_expect_free(exp);
+		return NF_DROP;
+	}
+=09
+	if (!mangle_sdp(pskb, ctinfo, ct, newip, port, dptr)) {
+		ip_conntrack_unexpect_related(exp);
+		return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
+static void __exit fini(void)
+{
+	ip_nat_sip_hook =3D NULL;
+	ip_nat_sdp_hook =3D NULL;
+	/* Make sure noone calls it, meanwhile. */
+	synchronize_net();
+}
+
+static int __init init(void)
+{
+	BUG_ON(ip_nat_sip_hook);
+	BUG_ON(ip_nat_sdp_hook);
+	ip_nat_sip_hook =3D ip_nat_sip;
+	ip_nat_sdp_hook =3D ip_nat_sdp;
+	return 0;
+}
+
+module_init(init);
+module_exit(fini);
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/Kconfig.ladd pom-ng-sip/patchlets/sip-conntrack-nat=
/linux-2.6.12/net/ipv4/netfilter/Kconfig.ladd
--- pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-sip/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Kconfig.ladd	2005-07-03 22:40:24.000000000 +0200
@@ -0,0 +1,18 @@
+config IP_NF_NAT_SIP
+	tristate
+	depends on IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
+	default IP_NF_NAT if IP_NF_SIP=3Dy
+	default m if IP_NF_SIP=3Dm
+
+config IP_NF_SIP
+	tristate  'SIP support'
+	depends on IP_NF_CONNTRACK
+	help
+	  SIP is an application-layer control protocol that can establish,
+   	  modify, and terminate multimedia sessions (conferences) such as
+   	  Internet telephony calls. With the ip_conntrack_sip and
+	  the ip_nat_sip modules you can support the protocol on a connection
+	  tracking/NATing firewall.
+=09
+	  If you want to compile it as a module, say 'M' here and read
+	  Documentation/modules.txt.  If unsure, say 'N'.
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/Makefile.ladd pom-ng-sip/patchlets/sip-conntrack-na=
t/linux-2.6.12/net/ipv4/netfilter/Makefile.ladd
--- pom-ng-svn/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-sip/patchlets/sip-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Makefile.ladd	2005-07-03 22:40:24.000000000 +0200
@@ -0,0 +1,6 @@
+obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
+=20
+# SIP support
+obj-$(CONFIG_IP_NF_SIP) +=3D ip_conntrack_sip.o
+obj-$(CONFIG_IP_NF_NAT_SIP) +=3D ip_nat_sip.o
+

--6TrnltStXW4iwmi0--

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC5olvo4FAdB2PneQRAjS9AJ9tuGOQ+3OHQ6n4qX6y0qkA2nBzMgCffFxK
1wSnYMGzXvbzl5jsbU5ieqk=
=JOF0
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
