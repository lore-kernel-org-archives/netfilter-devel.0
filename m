From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.5.x new tftp conntrack + NAT support
Date: Mon, 31 Mar 2003 18:11:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331161145.GE28962@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
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


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 2.5.x merge of the 2.4.x tftp patch I've sent you yesterday.

Please apply, thanks.

diff -Nru ../linux-2.5.66-plain/include/linux/netfilter_ipv4/ip_conntrack_t=
ftp.h ./include/linux/netfilter_ipv4/ip_conntrack_tftp.h
--- ../linux-2.5.66-plain/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	=
Thu Jan  1 01:00:00 1970
+++ ./include/linux/netfilter_ipv4/ip_conntrack_tftp.h	Mon Mar 31 18:00:56 =
2003
@@ -0,0 +1,13 @@
+#ifndef _IP_CT_TFTP
+#define _IP_CT_TFTP
+
+#define TFTP_PORT 69
+
+struct tftphdr {
+	u_int16_t opcode;
+};
+
+#define TFTP_OPCODE_READ	1
+#define TFTP_OPCODE_WRITE	2
+
+#endif /* _IP_CT_TFTP */
diff -Nru ../linux-2.5.66-plain/net/ipv4/netfilter/Kconfig ./net/ipv4/netfi=
lter/Kconfig
--- ../linux-2.5.66-plain/net/ipv4/netfilter/Kconfig	Mon Mar 24 23:01:18 20=
03
+++ ./net/ipv4/netfilter/Kconfig	Mon Mar 31 18:07:09 2003
@@ -44,8 +44,20 @@
 	  chats.  Note that you do NOT need this extension to get files or
 	  have others initiate chats, or everything else in IRC.
=20
-	  If you want to compile it as a module, say 'M' here and read
-	  Documentation/modules.txt.  If unsure, say 'N'.
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
+
+config IP_NF_TFTP
+	tristate "TFTP prtocol support"
+	depends on IP_NF_CONNTRACK
+	help
+	  TFTP connection tracking helper, this is required depending
+	  on how restrictive your ruleset is.
+	  If you are using a tftp client behind -j SNAT or -j MASQUERADING
+	  you will need this.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
 config IP_NF_QUEUE
 	tristate "Userspace queueing via NETLINK (EXPERIMENTAL)"
@@ -379,6 +391,12 @@
 	depends on IP_NF_IPTABLES!=3Dn && IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
 	default IP_NF_NAT if IP_NF_FTP=3Dy
 	default m if IP_NF_FTP=3Dm
+
+config IP_NF_NAT_TFTP
+	tristate
+	depends on IP_NF_IPTABLES!=3Dn && IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
+	default IP_NF_NAT if IP_NF_TFTP=3Dy
+	default m if IP_NF_TFTP=3Dm
=20
 config IP_NF_MANGLE
 	tristate "Packet mangling"
diff -Nru ../linux-2.5.66-plain/net/ipv4/netfilter/Makefile ./net/ipv4/netf=
ilter/Makefile
--- ../linux-2.5.66-plain/net/ipv4/netfilter/Makefile	Mon Mar 24 23:00:09 2=
003
+++ ./net/ipv4/netfilter/Makefile	Mon Mar 31 18:00:56 2003
@@ -20,6 +20,7 @@
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
=20
 # connection tracking helpers
+obj-$(CONFIG_IP_NF_TFTP) +=3D ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o
 ifdef CONFIG_IP_NF_NAT_FTP
 endif
@@ -28,6 +29,7 @@
 endif
=20
 # NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_TFTP) +=3D ip_nat_tftp.o
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
=20
diff -Nru ../linux-2.5.66-plain/net/ipv4/netfilter/ip_conntrack_tftp.c ./ne=
t/ipv4/netfilter/ip_conntrack_tftp.c
--- ../linux-2.5.66-plain/net/ipv4/netfilter/ip_conntrack_tftp.c	Thu Jan  1=
 01:00:00 1970
+++ ./net/ipv4/netfilter/ip_conntrack_tftp.c	Mon Mar 31 18:00:56 2003
@@ -0,0 +1,131 @@
+/*
+ * Licensed under GNU GPL version 2 Copyright Magnus Boden <mb@ozaba.mine.=
nu>
+ * Version: 0.0.7
+ *
+ * Thu 21 Mar 2002 Harald Welte <laforge@gnumonks.org>
+ * 	- port to newnat API
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
+
+MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
+MODULE_DESCRIPTION("Netfilter connection tracking module for tftp");
+MODULE_LICENSE("GPL");
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of tftp servers");
+#endif
+
+#if 0
+#define DEBUGP(format, args...) printk(__FILE__ ":" __FUNCTION__ ": " \
+				       format, ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int tftp_help(const struct iphdr *iph, size_t len,
+	struct ip_conntrack *ct,
+	enum ip_conntrack_info ctinfo)
+{
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	struct tftphdr *tftph =3D (void *)udph + 8;
+	struct ip_conntrack_expect exp;
+=09
+	switch (ntohs(tftph->opcode)) {
+	/* RRQ and WRQ works the same way */
+	case TFTP_OPCODE_READ:
+	case TFTP_OPCODE_WRITE:
+		DEBUGP("");
+		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		memset(&exp, 0, sizeof(exp));
+
+		exp.tuple =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		exp.mask.src.ip =3D 0xffffffff;
+		exp.mask.dst.ip =3D 0xffffffff;
+		exp.mask.dst.u.udp.port =3D 0xffff;
+		exp.mask.dst.protonum =3D 0xffff;
+		exp.expectfn =3D NULL;
+
+		DEBUGP("expect: ");
+		DUMP_TUPLE(&exp.tuple);
+		DUMP_TUPLE(&exp.mask);
+		ip_conntrack_expect_related(ct, &exp);
+		break;
+	default:
+		DEBUGP("Unknown opcode\n");
+	}
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper tftp[MAX_PORTS];
+static char tftp_names[MAX_PORTS][10];
+
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0 ; i < ports_c; i++) {
+		DEBUGP("unregistering helper for port %d\n",
+			ports[i]);
+		ip_conntrack_helper_unregister(&tftp[i]);
+	}=20
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (!ports[0])
+		ports[0]=3DTFTP_PORT;
+
+	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+		/* Create helper structure */
+		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
+
+		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		tftp[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		tftp[i].mask.dst.protonum =3D 0xFFFF;
+		tftp[i].mask.src.u.udp.port =3D 0xFFFF;
+		tftp[i].max_expected =3D 1;
+		tftp[i].timeout =3D 0;
+		tftp[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		tftp[i].me =3D THIS_MODULE;
+		tftp[i].help =3D tftp_help;
+
+		tmpname =3D &tftp_names[i][0];
+		if (ports[i] =3D=3D TFTP_PORT)
+			sprintf(tmpname, "tftp");
+		else
+			sprintf(tmpname, "tftp-%d", i);
+		tftp[i].name =3D tmpname;
+
+		DEBUGP("port #%d: %d\n", i, ports[i]);
+
+		ret=3Dip_conntrack_helper_register(&tftp[i]);
+		if (ret) {
+			printk("ERROR registering helper for port %d\n",
+				ports[i]);
+			fini();
+			return(ret);
+		}
+		ports_c++;
+	}
+	return(0);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru ../linux-2.5.66-plain/net/ipv4/netfilter/ip_nat_tftp.c ./net/ipv4=
/netfilter/ip_nat_tftp.c
--- ../linux-2.5.66-plain/net/ipv4/netfilter/ip_nat_tftp.c	Thu Jan  1 01:00=
:00 1970
+++ ./net/ipv4/netfilter/ip_nat_tftp.c	Mon Mar 31 18:00:56 2003
@@ -0,0 +1,197 @@
+/*
+ * Licensed under GNU GPL version 2 Copyright Magnus Boden <mb@ozaba.mine.=
nu>
+ * Version: 0.0.7
+ *
+ * Thu 21 Mar 2002 Harald Welte <laforge@gnumonks.org>
+ * 	- Port to newnat API
+ *
+ * This module currently supports DNAT:
+ * iptables -t nat -A PREROUTING -d x.x.x.x -j DNAT --to-dest x.x.x.y
+ *
+ * and SNAT:
+ * iptables -t nat -A POSTROUTING { -j MASQUERADE , -j SNAT --to-source x.=
x.x.x }
+ *
+ * It has not been tested with
+ * -j SNAT --to-source x.x.x.x-x.x.x.y since I only have one external ip
+ * If you do test this please let me know if it works or not.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
+MODULE_DESCRIPTION("Netfilter NAT helper for tftp");
+MODULE_LICENSE("GPL");
+
+#define MAX_PORTS 8
+
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of tftp servers");
+#endif
+
+#if 0
+#define DEBUGP(format, args...) printk(__FILE__ ":" __FUNCTION__ ": " \
+				       format, ## args)
+#else
+#define DEBUGP(format, args...)
+#endif
+static unsigned int=20
+tftp_nat_help(struct ip_conntrack *ct,
+	      struct ip_conntrack_expect *exp,
+	      struct ip_nat_info *info,
+	      enum ip_conntrack_info ctinfo,
+	      unsigned int hooknum,
+	      struct sk_buff **pskb)
+{
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	struct tftphdr *tftph =3D (void *)udph + 8;
+	struct ip_conntrack_tuple repl;
+
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL)
+	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)=
))=20
+		return NF_ACCEPT;
+
+	if (!exp) {
+		DEBUGP("no conntrack expectation to modify\n");
+		return NF_ACCEPT;
+	}
+
+	switch (ntohs(tftph->opcode)) {
+	/* RRQ and WRQ works the same way */
+	case TFTP_OPCODE_READ:
+	case TFTP_OPCODE_WRITE:
+		repl =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		DEBUGP("");
+		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+		DEBUGP("expecting: ");
+		DUMP_TUPLE(&repl);
+		DUMP_TUPLE(&exp->mask);
+		ip_conntrack_change_expect(exp, &repl);
+		break;
+	default:
+		DEBUGP("Unknown opcode\n");
+	}              =20
+
+	return NF_ACCEPT;
+}
+
+static unsigned int=20
+tftp_nat_expected(struct sk_buff **pskb,
+		  unsigned int hooknum,
+		  struct ip_conntrack *ct,=20
+		  struct ip_nat_info *info)=20
+{
+	const struct ip_conntrack *master =3D ct->master->expectant;
+	const struct ip_conntrack_tuple *orig =3D=20
+			&master->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	struct ip_nat_multi_range mr;
+#if 0
+	const struct ip_conntrack_tuple *repl =3D
+			&master->tuplehash[IP_CT_DIR_REPLY].tuple;
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl*4;
+#endif
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+
+	mr.rangesize =3D 1;
+	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
+
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC) {
+		mr.range[0].min_ip =3D mr.range[0].max_ip =3D orig->dst.ip;=20
+		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
+			"newsrc: %u.%u.%u.%u\n",
+                        NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->sourc=
e),
+			NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
+			NIPQUAD(orig->dst.ip));
+	} else {
+		mr.range[0].min_ip =3D mr.range[0].max_ip =3D orig->src.ip;
+		mr.range[0].min.udp.port =3D mr.range[0].max.udp.port =3D=20
+							orig->src.u.udp.port;
+		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
+
+		DEBUGP("orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
+			"newdst: %u.%u.%u.%u:%u\n",
+                        NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->sourc=
e),
+                        NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
+                        NIPQUAD(orig->src.ip), ntohs(orig->src.u.udp.port)=
);
+	}
+
+	return ip_nat_setup_info(ct,&mr,hooknum);
+}
+
+static struct ip_nat_helper tftp[MAX_PORTS];
+static char tftp_names[MAX_PORTS][10];
+
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0 ; i < ports_c; i++) {
+		DEBUGP("unregistering helper for port %d\n", ports[i]);
+		ip_nat_helper_unregister(&tftp[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (!ports[0])
+		ports[0] =3D TFTP_PORT;
+
+	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
+
+		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		tftp[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		tftp[i].mask.dst.protonum =3D 0xFFFF;
+		tftp[i].mask.src.u.udp.port =3D 0xFFFF;
+		tftp[i].help =3D tftp_nat_help;
+		tftp[i].flags =3D 0;
+		tftp[i].me =3D THIS_MODULE;
+		tftp[i].expect =3D tftp_nat_expected;
+
+		tmpname =3D &tftp_names[i][0];
+		if (ports[i] =3D=3D TFTP_PORT)
+			sprintf(tmpname, "tftp");
+		else
+			sprintf(tmpname, "tftp-%d", i);
+		tftp[i].name =3D tmpname;
+	=09
+		DEBUGP("ip_nat_tftp: registering for port %d: name %s\n",
+			ports[i], tftp[i].name);
+		ret =3D ip_nat_helper_register(&tftp[i]);
+
+		if (ret) {
+			printk("ip_nat_tftp: unable to register for port %d\n",
+				ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
+	}
+	return ret;
+}
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

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iGjBXaXGVTD0i/8RAo2MAJ4urv73i6InKueC0IJSa3Q4l4/h7QCeINDS
YSyElTLMgFMOQPv88QS+Bpc=
=IPFP
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--
