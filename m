From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.5.x new amanda conntrack + NAT support
Date: Mon, 31 Mar 2003 18:23:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331162343.GF28962@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 2.5.x merge of the 2.4.x amanda patch I've sent you
yesterday.

It also includes a small cosmetic update to net/ipv4/netfilter/Makefile

Please apply, thanks.


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/include/l=
inux/netfilter_ipv4/ip_conntrack.h linxu-2.5.66-tftp-amanda/include/linux/n=
etfilter_ipv4/ip_conntrack.h
--- linux-2.5.66-tftp/include/linux/netfilter_ipv4/ip_conntrack.h	Mon Mar 2=
4 23:01:27 2003
+++ linxu-2.5.66-tftp-amanda/include/linux/netfilter_ipv4/ip_conntrack.h	Mo=
n Mar 31 18:12:35 2003
@@ -63,12 +63,14 @@
 };
=20
 /* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
=20
 /* per expectation: application helper private data */
 union ip_conntrack_expect_help {
 	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_amanda_expect exp_amanda_info;
 	struct ip_ct_ftp_expect exp_ftp_info;
 	struct ip_ct_irc_expect exp_irc_info;
=20
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/include/l=
inux/netfilter_ipv4/ip_conntrack_amanda.h linxu-2.5.66-tftp-amanda/include/=
linux/netfilter_ipv4/ip_conntrack_amanda.h
--- linux-2.5.66-tftp/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	Th=
u Jan  1 01:00:00 1970
+++ linxu-2.5.66-tftp-amanda/include/linux/netfilter_ipv4/ip_conntrack_aman=
da.h	Mon Mar 31 18:12:35 2003
@@ -0,0 +1,29 @@
+#ifndef _IP_CONNTRACK_AMANDA_H
+#define _IP_CONNTRACK_AMANDA_H
+/* AMANDA tracking. */
+
+#ifdef __KERNEL__
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+/* Protects amanda part of conntracks */
+DECLARE_LOCK_EXTERN(ip_amanda_lock);
+
+#endif
+
+struct conn {
+	char* match;
+	int matchlen;
+};
+
+#define NUM_MSGS 	3
+
+
+struct ip_ct_amanda_expect
+{
+	u_int16_t port;		/* port number of this expectation */
+	u_int16_t offset;	/* offset of the port specification in ctrl packet */
+	u_int16_t len;		/* the length of the port number specification */
+};
+
+#endif /* _IP_CONNTRACK_AMANDA_H */
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/net/ipv4/=
netfilter/Kconfig linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/Kconfig
--- linux-2.5.66-tftp/net/ipv4/netfilter/Kconfig	Mon Mar 31 18:07:09 2003
+++ linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/Kconfig	Mon Mar 31 18:15:34=
 2003
@@ -59,6 +59,20 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
+config IP_NF_AMANDA
+	tristate "Amanda backup protocol support"
+	depends on IP_NF_CONNTRACK
+	help
+	  If you are running the Amanda backup package (http://www.amanda.org/)
+	  on this machine or machines that will be MASQUERADED through this
+	  machine, then you may want to enable this feature.  This allows the
+	  connection tracking and natting code to allow the sub-channels that
+	  Amanda requires for communication of the backup data, messages and
+	  index.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
+
 config IP_NF_QUEUE
 	tristate "Userspace queueing via NETLINK (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -393,6 +407,12 @@
 	default m if IP_NF_FTP=3Dm
=20
 config IP_NF_NAT_TFTP
+	tristate
+	depends on IP_NF_IPTABLES!=3Dn && IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
+	default IP_NF_NAT if IP_NF_TFTP=3Dy
+	default m if IP_NF_TFTP=3Dm
+
+config IP_NF_NAT_AMANDA
 	tristate
 	depends on IP_NF_IPTABLES!=3Dn && IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
 	default IP_NF_NAT if IP_NF_TFTP=3Dy
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/net/ipv4/=
netfilter/Makefile linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/Makefile
--- linux-2.5.66-tftp/net/ipv4/netfilter/Makefile	Mon Mar 31 18:00:56 2003
+++ linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/Makefile	Mon Mar 31 18:13:2=
7 2003
@@ -20,15 +20,13 @@
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
=20
 # connection tracking helpers
+obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o
 obj-$(CONFIG_IP_NF_TFTP) +=3D ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o
-ifdef CONFIG_IP_NF_NAT_FTP
-endif
 obj-$(CONFIG_IP_NF_IRC) +=3D ip_conntrack_irc.o
-ifdef CONFIG_IP_NF_NAT_IRC
-endif
=20
 # NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
 obj-$(CONFIG_IP_NF_NAT_TFTP) +=3D ip_nat_tftp.o
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/net/ipv4/=
netfilter/ip_conntrack_amanda.c linxu-2.5.66-tftp-amanda/net/ipv4/netfilter=
/ip_conntrack_amanda.c
--- linux-2.5.66-tftp/net/ipv4/netfilter/ip_conntrack_amanda.c	Thu Jan  1 0=
1:00:00 1970
+++ linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/ip_conntrack_amanda.c	Mon M=
ar 31 18:12:35 2003
@@ -0,0 +1,233 @@
+/* Amanda extension for IP connection tracking, Version 0.2
+ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
+ * based on HW's ip_conntrack_irc.c as well as other modules
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *	Module load syntax:
+ * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]
+ *=09
+ *	Where master_timeout is the timeout (in seconds) of the master
+ *	connection (port 10080).  This defaults to 5 minutes but if
+ *	your clients take longer than 5 minutes to do their work
+ *	before getting back to the Amanda server, you can increase
+ *	this value.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/udp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
+
+static unsigned int master_timeout =3D 300;
+
+MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
+MODULE_DESCRIPTION("Amanda connection tracking module");
+MODULE_LICENSE("GPL");
+MODULE_PARM(master_timeout, "i");
+MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
+
+DECLARE_LOCK(ip_amanda_lock);
+struct module *ip_conntrack_amanda =3D THIS_MODULE;
+
+#define MAXMATCHLEN	6
+struct conn conns[NUM_MSGS] =3D {
+	{"DATA ", 5},
+	{"MESG ", 5},
+	{"INDEX ", 6},
+};
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+
+/* FIXME: This should be in userspace.  Later. */
+static int help(const struct iphdr *iph, size_t len,
+		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
+{
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	u_int32_t udplen =3D len - iph->ihl * 4;
+	u_int32_t datalen =3D udplen - sizeof(struct udphdr);
+	char *data =3D (char *)udph + sizeof(struct udphdr);
+	char *datap =3D data;
+	char *data_limit =3D (char *) data + datalen;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_ct_amanda *info =3D
+				(struct ip_ct_amanda *)&ct->help.ct_ftp_info;
+
+	/* Can't track connections formed before we registered */
+	if (!info)
+		return NF_ACCEPT;
+
+	/* increase the UDP timeout of the master connection as replies from
+	 * Amanda clients to the server can be quite delayed */
+	ip_ct_refresh(ct, master_timeout * HZ);
+
+	/* If packet is coming from Amanda server */
+	if (dir =3D=3D IP_CT_DIR_ORIGINAL)
+		return NF_ACCEPT;
+
+	/* Not whole UDP header? */
+	if (udplen < sizeof(struct udphdr)) {
+		printk("ip_conntrack_amanda_help: udplen =3D %u\n",
+		       (unsigned)udplen);
+		return NF_ACCEPT;
+	}
+
+	/* Checksum invalid?  Ignore. */
+	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
+			      csum_partial((char *)udph, udplen, 0))) {
+		DEBUGP("ip_ct_talk_help: bad csum: %p %u %u.%u.%u.%u "
+		       "%u.%u.%u.%u\n",
+		       udph, udplen, NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
+=09
+	/* Search for the CONNECT string */
+	while (data < data_limit) {
+		if (!memcmp(data, "CONNECT ", 8)) {
+			break;
+		}
+		data++;
+	}
+	if (memcmp(data, "CONNECT ", 8))
+		return NF_ACCEPT;
+
+	DEBUGP("ip_conntrack_amanda_help: CONNECT found in connection "
+		   "%u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
+		   NIPQUAD(iph->saddr), htons(udph->source),
+		   NIPQUAD(iph->daddr), htons(udph->dest));
+	data +=3D 8;
+	while (*data !=3D 0x0a && data < data_limit) {
+
+		int i;
+
+		for (i =3D 0; i < NUM_MSGS; i++) {
+			if (!memcmp(data, conns[i].match,
+				   conns[i].matchlen)) {
+
+				char *portchr;
+				struct ip_conntrack_expect expect;
+				struct ip_ct_amanda_expect
+				    *exp_amanda_info =3D
+					&expect.help.exp_amanda_info;
+
+				memset(&expect, 0, sizeof(expect));
+
+				data +=3D conns[i].matchlen;
+				/* this is not really tcp, but let's steal an
+				 * idea from a tcp stream helper :-)
+				 */
+				// XXX expect.seq =3D data - datap;
+				exp_amanda_info->offset =3D data - datap;
+// XXX DEBUGP("expect.seq =3D %p - %p =3D %d\n", data, datap, expect.seq);
+DEBUGP("exp_amanda_info->offset =3D %p - %p =3D %d\n", data, datap, exp_am=
anda_info->offset);
+				portchr =3D data;
+				exp_amanda_info->port =3D
+				    simple_strtoul(data, &data, 10);
+				exp_amanda_info->len =3D data - portchr;
+
+				/* eat whitespace */
+				while (*data =3D=3D ' ')
+					data++;
+				DEBUGP ("ip_conntrack_amanda_help: "
+					"CONNECT %s request with port "
+					"%u found\n", conns[i].match,
+					exp_amanda_info->port);
+
+				LOCK_BH(&ip_amanda_lock);
+
+				expect.tuple =3D ((struct ip_conntrack_tuple)
+						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
+						  { 0 } },
+				  		{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
+						  { htons(exp_amanda_info->port) },
+				    	  IPPROTO_TCP }});
+				expect.mask =3D ((struct ip_conntrack_tuple)
+							   { { 0, { 0 } },
+				  				 { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+
+				expect.expectfn =3D NULL;
+
+				DEBUGP ("ip_conntrack_amanda_help: "
+					"expect_related: %u.%u.%u.%u:%u - "
+					"%u.%u.%u.%u:%u\n",
+					NIPQUAD(expect.tuple.src.ip),
+					ntohs(expect.tuple.src.u.tcp.port),
+					NIPQUAD(expect.tuple.dst.ip),
+					ntohs(expect.tuple.dst.u.tcp.port));
+				if (ip_conntrack_expect_related(ct, &expect) =3D=3D
+				    -EEXIST) {
+					;
+					/* this must be a packet being resent */
+					/* XXX - how do I get the
+					 *       ip_conntrack_expect that
+					 *       already exists so that I can
+					 *       update the .seq so that the
+					 *       nat module rewrites the port
+					 *       numbers?
+					 *       Perhaps I should use the
+					 *       exp_amanda_info instead of
+					 *       .seq.
+					 */
+				}
+				UNLOCK_BH(&ip_amanda_lock);
+			} /* if memcmp(conns) */
+		} /* for .. NUM_MSGS */
+		data++;
+	} /* while (*data !=3D 0x0a && data < data_limit) */
+
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper amanda_helper;
+
+static void fini(void)
+{
+	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
+	ip_conntrack_helper_unregister(&amanda_helper);
+}
+
+static int __init init(void)
+{
+	int ret;
+
+	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
+	amanda_helper.tuple.src.u.udp.port =3D htons(10080);
+	amanda_helper.tuple.dst.protonum =3D IPPROTO_UDP;
+	amanda_helper.mask.src.u.udp.port =3D 0xFFFF;
+	amanda_helper.mask.dst.protonum =3D 0xFFFF;
+	amanda_helper.max_expected =3D NUM_MSGS;
+	amanda_helper.timeout =3D 180;
+	amanda_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+	amanda_helper.me =3D ip_conntrack_amanda;
+	amanda_helper.help =3D help;
+	amanda_helper.name =3D "amanda";
+
+	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
+
+	ret =3D ip_conntrack_helper_register(&amanda_helper);
+
+	if (ret) {
+		printk("ip_ct_amanda: ERROR registering helper\n");
+		fini();
+		return -EBUSY;
+	}
+	return 0;
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-tftp/net/ipv4/=
netfilter/ip_nat_amanda.c linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/ip_na=
t_amanda.c
--- linux-2.5.66-tftp/net/ipv4/netfilter/ip_nat_amanda.c	Thu Jan  1 01:00:0=
0 1970
+++ linxu-2.5.66-tftp-amanda/net/ipv4/netfilter/ip_nat_amanda.c	Mon Mar 31 =
18:12:35 2003
@@ -0,0 +1,226 @@
+/* Amanda extension for TCP NAT alteration.
+ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
+ * based on a copy of HW's ip_nat_irc.c as well as other modules
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *	Module load syntax:
+ * 	insmod ip_nat_amanda.o
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/kernel.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
+
+
+#if 0
+#define DEBUGP printk
+#define DUMP_OFFSET(x)	printk("offset_before=3D%d, offset_after=3D%d, corr=
ection_pos=3D%u\n", x->offset_before, x->offset_after, x->correction_pos);
+#else
+#define DEBUGP(format, args...)
+#define DUMP_OFFSET(x)
+#endif
+
+MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
+MODULE_DESCRIPTION("Amanda network address translation module");
+MODULE_LICENSE("GPL");
+
+/* protects amanda part of conntracks */
+DECLARE_LOCK_EXTERN(ip_amanda_lock);
+
+static unsigned int
+amanda_nat_expected(struct sk_buff **pskb,
+		 unsigned int hooknum,
+		 struct ip_conntrack *ct,
+		 struct ip_nat_info *info)
+{
+	struct ip_nat_multi_range mr;
+	u_int32_t newdstip, newsrcip, newip;
+	u_int16_t port;
+	struct ip_ct_amanda_expect *exp_info;
+	struct ip_conntrack *master =3D master_ct(ct);
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+
+	DEBUGP("nat_expected: We have a connection!\n");
+	exp_info =3D &ct->master->help.exp_amanda_info;
+
+	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
+	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	DEBUGP("nat_expected: %u.%u.%u.%u->%u.%u.%u.%u\n",
+	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
+
+	port =3D exp_info->port;
+
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
+		newip =3D newsrcip;
+	else
+		newip =3D newdstip;
+
+	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
+
+	mr.rangesize =3D 1;
+	/* We don't want to manip the per-protocol, just the IPs. */
+	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
+	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
+
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {
+		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
+		mr.range[0].min =3D mr.range[0].max
+			=3D ((union ip_conntrack_manip_proto)
+				{ htons(port) });
+	}
+
+	return ip_nat_setup_info(ct, &mr, hooknum);
+}
+
+static int amanda_data_fixup(struct ip_conntrack *ct,
+			  struct sk_buff **pskb,
+			  enum ip_conntrack_info ctinfo,
+			  struct ip_conntrack_expect *expect)
+{
+	u_int32_t newip;
+	/* DATA 99999 MESG 99999 INDEX 99999 */
+	char buffer[6];
+	struct ip_conntrack_expect *exp =3D expect;
+	struct ip_ct_amanda_expect *ct_amanda_info =3D &exp->help.exp_amanda_info;
+	struct ip_conntrack_tuple t =3D exp->tuple;
+	int port;
+
+	MUST_BE_LOCKED(&ip_amanda_lock);
+
+	newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	DEBUGP ("ip_nat_amanda_help: newip =3D %u.%u.%u.%u\n", NIPQUAD(newip));
+
+	/* Alter conntrack's expectations. */
+
+	/* We can read expect here without conntrack lock, since it's
+	   only set in ip_conntrack_amanda, with ip_amanda_lock held
+	   writable */
+
+	t.dst.ip =3D newip;
+	for (port =3D ct_amanda_info->port + 10; port !=3D 0; port++) {
+		t.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)
+			break;
+	}
+
+	if (port =3D=3D 0)
+		return 0;
+
+	sprintf(buffer, "%u", port);
+
+	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, /* XXX exp->seq */ ct_a=
manda_info->offset,=20
+					ct_amanda_info->len, buffer, strlen(buffer));
+}
+
+static unsigned int help(struct ip_conntrack *ct,
+			 struct ip_conntrack_expect *exp,
+			 struct ip_nat_info *info,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int hooknum,
+			 struct sk_buff **pskb)
+{
+	int dir;
+
+	if (!exp)
+		DEBUGP("ip_nat_amanda: no exp!!");
+	=09
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	dir =3D CTINFO2DIR(ctinfo);
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL)
+	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)=
)) {
+		DEBUGP("ip_nat_amanda_help: Not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
+		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
+		return NF_ACCEPT;
+	}
+	DEBUGP("ip_nat_amanda_help: got beyond not touching: dir %s at hook %s fo=
r expect: ",
+		   dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		   hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		   : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		     : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
+		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
+	DUMP_TUPLE(&exp->tuple);
+
+	LOCK_BH(&ip_amanda_lock);
+// XXX	if (exp->seq !=3D 0)
+	if (exp->help.exp_amanda_info.offset !=3D 0)
+		/*  if this packet has a "seq" it needs to have it's content mangled */
+		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
+			UNLOCK_BH(&ip_amanda_lock);
+			DEBUGP("ip_nat_amanda: NF_DROP\n");
+			return NF_DROP;
+		}
+	exp->help.exp_amanda_info.offset =3D 0;
+	UNLOCK_BH(&ip_amanda_lock);
+
+	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
+	return NF_ACCEPT;
+}
+
+static struct ip_nat_helper ip_nat_amanda_helper;
+
+/* This function is intentionally _NOT_ defined as  __exit, because
+ * it is needed by init() */
+static void fini(void)
+{
+	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
+	ip_nat_helper_unregister(&ip_nat_amanda_helper);
+}
+
+static int __init init(void)
+{
+	int ret =3D 0;
+	struct ip_nat_helper *hlpr;
+
+	hlpr =3D &ip_nat_amanda_helper;
+	memset(hlpr, 0, sizeof(struct ip_nat_helper));
+
+	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
+	hlpr->tuple.src.u.udp.port =3D htons(10080);
+	hlpr->mask.src.u.udp.port =3D 0xFFFF;
+	hlpr->mask.dst.protonum =3D 0xFFFF;
+	hlpr->help =3D help;
+	hlpr->flags =3D 0;
+	hlpr->me =3D THIS_MODULE;
+	hlpr->expect =3D amanda_nat_expected;
+
+	hlpr->name =3D "amanda";
+
+	DEBUGP
+	    ("ip_nat_amanda: Trying to register nat helper\n");
+	ret =3D ip_nat_helper_register(hlpr);
+
+	if (ret) {
+		printk
+		    ("ip_nat_amanda: error registering nat helper\n");
+		fini();
+		return 1;
+	}
+	return ret;
+}
+
+
+module_init(init);
+module_exit(fini);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iGuPXaXGVTD0i/8RAuZrAJ0SmcNqbnGcpImoVknHgODoUs83qwCdEuAw
hAEcSvoKGCsCmhBWXeruD10=
=xqVk
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
