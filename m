From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH] conntracker/nat helper for Microsoft Media Services
Date: 23 Sep 2002 00:15:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032732902.574.99.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-9KuH5JnxKTx2HnF0PZK1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-9KuH5JnxKTx2HnF0PZK1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This is a connection tracking/nat helper for Microsoft (Streaming) Media
Services, both in patch-o-matic format and as a diff against
2.4.20-pre7 (the patch requires newnat).

By default, an MMS client connects to TCP port 1755 of the server, and
client and server determine whether to stream the content over UDP or
TCP. This is discussed here:

http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnwmt/html/MMSFirewall.asp

This link points to some Open Source people who are in the process of
reverse engineering this MS proprietary protocol, and a link to a
Linux MMS client:

http://get.to/sdp

Furthermore, I would like to publicly thank Martin Josefsson for
answering my netfilter programming related questions on IRC many
moons ago (#lartc on irc.oftc.net). He may already have forgotten
about it but his advise was most helpful to me.

Note that ip_conntrack_mms and ip_nat_mms has got *nothing* to do
with ip_masq_mms from 2.2 kernels.

Regards,
Filip


--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=diff.netfilter.mms.20020922-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.mms.20020922-1; charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-pre7/Documentation/Configure.help linux-=
2.4.20-pre7-mms/Documentation/Configure.help
--- linux-2.4.20-pre7/Documentation/Configure.help	2002-09-22 19:49:39.0000=
00000 +0200
+++ linux-2.4.20-pre7-mms/Documentation/Configure.help	2002-09-17 01:29:20.=
000000000 +0200
@@ -2499,6 +2499,16 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
+MMS protocol support
+CONFIG_IP_NF_MMS
+  Tracking MMS (Microsoft Windows Media Services) connections
+  could be problematic if random ports are used to send the
+  streaming content. This option allows users to track streaming
+  connections over random UDP or TCP ports.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `Y'.
+
 User space queueing via NETLINK
 CONFIG_IP_NF_QUEUE
   Netfilter has the ability to queue packets to user space: the
diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_con=
ntrack.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack.h	2002-09-2=
2 19:50:53.000000000 +0200
+++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h	2002-=
09-17 04:08:25.000000000 +0200
@@ -60,12 +60,14 @@
 /* Add protocol helper include file here */
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
=20
 /* per expectation: application helper private data */
 union ip_conntrack_expect_help {
 	/* insert conntrack helper private data (expect) here */
 	struct ip_ct_ftp_expect exp_ftp_info;
 	struct ip_ct_irc_expect exp_irc_info;
+	struct ip_ct_mms_expect exp_mms_info;
=20
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	union {
@@ -79,6 +81,7 @@
 	/* insert conntrack helper private data (master) here */
 	struct ip_ct_ftp_master ct_ftp_info;
 	struct ip_ct_irc_master ct_irc_info;
+	struct ip_ct_mms_master ct_mms_info;
 };
=20
 #ifdef CONFIG_IP_NF_NAT_NEEDED
diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_con=
ntrack_mms.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrac=
k_mms.h
--- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack_mms.h	1970-=
01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack_mms.h	2=
002-09-17 04:08:25.000000000 +0200
@@ -0,0 +1,33 @@
+#ifndef _IP_CONNTRACK_MMS_H
+#define _IP_CONNTRACK_MMS_H
+/* MMS tracking. */
+
+#ifndef __KERNEL__
+#error Only in kernel.
+#endif
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+DECLARE_LOCK_EXTERN(ip_mms_lock);
+
+#define MMS_PORT                         1755
+#define MMS_SRV_MSG_ID                   196610
+
+#define MMS_SRV_MSG_OFFSET               36
+#define MMS_SRV_UNICODE_STRING_OFFSET    60
+#define MMS_SRV_CHUNKLENLV_OFFSET        16
+#define MMS_SRV_CHUNKLENLM_OFFSET        32
+#define MMS_SRV_MESSAGELENGTH_OFFSET     8
+
+/* This structure is per expected connection */
+struct ip_ct_mms_expect {
+	u_int32_t len;
+	u_int32_t padding;
+	u_int16_t port;
+};
+
+/* This structure exists only once per master */
+struct ip_ct_mms_master {
+};
+
+#endif /* _IP_CONNTRACK_MMS_H */
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/Config.in linux-=
2.4.20-pre7-mms/net/ipv4/netfilter/Config.in
--- linux-2.4.20-pre7/net/ipv4/netfilter/Config.in	2002-09-22 19:50:57.0000=
00000 +0200
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/Config.in	2002-09-17 01:29:20.=
000000000 +0200
@@ -8,6 +8,7 @@
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  MMS protocol support' CONFIG_IP_NF_MMS $CONFIG_IP_NF_CON=
NTRACK
 fi
=20
 if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
@@ -60,6 +61,13 @@
       if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
         dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)' CONFIG_IP=
_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
       fi
+      if [ "$CONFIG_IP_NF_MMS" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_MMS m
+      else
+        if [ "$CONFIG_IP_NF_MMS" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_MMS $CONFIG_IP_NF_NAT
+        fi
+      fi
       if [ "$CONFIG_IP_NF_IRC" =3D "m" ]; then
         define_tristate CONFIG_IP_NF_NAT_IRC m
       else
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/Makefile linux-2=
.4.20-pre7-mms/net/ipv4/netfilter/Makefile
--- linux-2.4.20-pre7/net/ipv4/netfilter/Makefile	2002-09-22 19:50:57.00000=
0000 +0200
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/Makefile	2002-09-17 01:29:20.0=
00000000 +0200
@@ -42,9 +42,15 @@
 	export-objs +=3D ip_conntrack_irc.o
 endif
=20
+obj-$(CONFIG_IP_NF_MMS) +=3D ip_conntrack_mms.o
+ifdef CONFIG_IP_NF_NAT_MMS
+	export-objs +=3D ip_conntrack_mms.o
+endif
+
 # NAT helpers=20
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_MMS) +=3D ip_nat_mms.o
=20
 # generic IP tables=20
 obj-$(CONFIG_IP_NF_IPTABLES) +=3D ip_tables.o
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mms=
.c linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c
--- linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mms.c	1970-01-01 01:0=
0:00.000000000 +0100
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c	2002-09-17 =
01:29:20.000000000 +0200
@@ -0,0 +1,310 @@
+/* MMS extension for IP connection tracking
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_conntrack_ftp.c and ip_conntrack_irc.c
+ *
+ * ip_conntrack_mms.c v0.3 2002-09-22
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_conntrack_mms.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MMS servers You wish to connect to.
+ *      If you don't specify ports, the default will be TCP port 1755.
+ *
+ *      More info on MMS protocol, firewalls and NAT:
+ *      http://msdn.microsoft.com/library/default.asp?url=3D/library/en-us=
/dnwmt/html/MMSFirewall.asp
+ *      http://www.microsoft.com/windows/windowsmedia/serve/firewall.asp
+ *
+ *      The SDP project people are reverse-engineering MMS:
+ *      http://get.to/sdp
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ctype.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
+
+DECLARE_LOCK(ip_mms_lock);
+struct module *ip_conntrack_mms =3D THIS_MODULE;
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+#endif
+
+#if 0=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+EXPORT_SYMBOL(ip_mms_lock);
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) connection trac=
king module");
+MODULE_LICENSE("GPL");
+
+/* #define isdigit(c) (c >=3D '0' && c <=3D '9') */
+
+/* copied from drivers/usb/serial/io_edgeport.c - not perfect but will do =
the trick */
+static void unicode_to_ascii (char *string, short *unicode, int unicode_si=
ze)
+{
+	int i;
+	for (i =3D 0; i < unicode_size; ++i) {
+		string[i] =3D (char)(unicode[i]);
+	}
+	string[unicode_size] =3D 0x00;
+}
+
+__inline static int atoi(char *s)=20
+{
+	int i=3D0;
+	while (isdigit(*s)) {
+		i =3D i*10 + *(s++) - '0';
+	}
+	return i;
+}
+
+/* convert ip address string like "192.168.0.10" to unsigned int */
+__inline static u_int32_t asciiiptoi(char *s)
+{
+	unsigned int i, j, k;
+
+	for(i=3Dk=3D0; k<3; ++k, ++s, i<<=3D8) {
+		i+=3Datoi(s);
+		for(j=3D0; (*(++s) !=3D '.') && (j<3); ++j)
+			;
+	}
+	i+=3Datoi(s);
+	return ntohl(i);
+}
+
+int parse_mms(const char *data,=20
+	      const unsigned int datalen,
+	      u_int32_t *mms_ip,
+	      u_int16_t *mms_proto,
+	      u_int16_t *mms_port,
+	      char **mms_string_b,
+	      char **mms_string_e,
+	      char **mms_padding_e)
+{
+	int unicode_size, i;
+	char tempstring[28];       /* "\\255.255.255.255\UDP\65535" */
+	char getlengthstring[28];
+=09
+	for(unicode_size=3D0;=20
+	    (char) *(data+(MMS_SRV_UNICODE_STRING_OFFSET+unicode_size*2)) !=3D (c=
har)0;
+	    unicode_size++)
+		if ((unicode_size =3D=3D 28) || (MMS_SRV_UNICODE_STRING_OFFSET+unicode_s=
ize*2 >=3D datalen))=20
+			return -1; /* out of bounds - incomplete packet */
+=09
+	unicode_to_ascii(tempstring, (short *)(data+MMS_SRV_UNICODE_STRING_OFFSET=
), unicode_size);
+	DEBUGP("ip_conntrack_mms: offset 60: %s\n", (const char *)(tempstring));
+=09
+	/* IP address ? */
+	*mms_ip =3D asciiiptoi(tempstring+2);
+=09
+	i=3Dsprintf(getlengthstring, "%u.%u.%u.%u", HIPQUAD(*mms_ip));
+	=09
+	/* protocol ? */
+	if(strncmp(tempstring+3+i, "TCP", 3)=3D=3D0)
+		*mms_proto =3D IPPROTO_TCP;
+	else if(strncmp(tempstring+3+i, "UDP", 3)=3D=3D0)
+		*mms_proto =3D IPPROTO_UDP;
+
+	/* port ? */
+	*mms_port =3D atoi(tempstring+7+i);
+
+	/* we store a pointer to the beginning of the "\\a.b.c.d\proto\port"=20
+	   unicode string, one to the end of the string, and one to the end=20
+	   of the packet, since we must keep track of the number of bytes=20
+	   between end of the unicode string and the end of packet (padding) */
+	*mms_string_b  =3D (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET);
+	*mms_string_e  =3D (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET + unicod=
e_size * 2);
+	*mms_padding_e =3D (char *)(data + datalen); /* looks funny, doesn't it *=
/
+	return 0;
+}
+
+
+/* FIXME: This should be in userspace.  Later. */
+static int help(const struct iphdr *iph, size_t len,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	/* tcplen not negative guaranteed by ip_conntrack_tcp.c */
+	struct tcphdr *tcph =3D (void *)iph + iph->ihl * 4;
+	const char *data =3D (const char *)tcph + tcph->doff * 4;
+	unsigned int tcplen =3D len - iph->ihl * 4;
+	unsigned int datalen =3D tcplen - tcph->doff * 4;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect expect, *exp =3D &expect;=20
+	struct ip_ct_mms_expect *exp_mms_info =3D &exp->help.exp_mms_info;
+=09
+	u_int32_t mms_ip;
+	u_int16_t mms_proto;
+	char mms_proto_string[8];
+	u_int16_t mms_port;
+	char *mms_string_b, *mms_string_e, *mms_padding_e;
+	    =20
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
+		DEBUGP("ip_conntrack_mms: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	/* Not whole TCP header? */
+	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+		DEBUGP("ip_conntrack_mms: tcplen =3D %u\n", (unsigned)tcplen);
+		return NF_ACCEPT;
+	}
+
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+	    csum_partial((char *)tcph, tcplen, 0))) {
+		DEBUGP("mms_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
+		       tcph, tcplen, NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
+=09
+	/* Only look at packets with 0x00030002/196610 on bytes 36->39 of TCP pay=
load */
+	/* FIXME: There is an issue with only looking at this packet: before this=
 packet,=20
+	   the client has already sent a packet to the server with the server's h=
ostname=20
+	   according to the client (think of it as the "Host: " header in HTTP/1.=
1). The=20
+	   server will break the connection if this doesn't correspond to its own=
 host=20
+	   header. The client can also connect to an IP address; if it's the serv=
er's IP
+	   address, it will not break the connection. When doing DNAT on a connec=
tion=20
+	   where the client uses a server's IP address, the nat module should det=
ect
+	   this and change this string accordingly to the DNATed address. This sh=
ould
+	   probably be done by checking for an IP address, then storing it as a m=
ember
+	   of struct ip_ct_mms_expect and checking for it in ip_nat_mms...
+	   */
+	if( (MMS_SRV_MSG_OFFSET < datalen) &&=20
+	    ((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) =3D=3D MMS_SRV_MSG_ID)) {
+		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",=20
+		       (u8)*(data+36), (u8)*(data+37),=20
+		       (u8)*(data+38), (u8)*(data+39),
+		       datalen);
+		if(parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
+		             &mms_string_b, &mms_string_e, &mms_padding_e))
+			if(net_ratelimit())
+				/* FIXME: more verbose debugging ? */
+				printk(KERN_WARNING
+				       "ip_conntrack_mms: Unable to parse data payload\n");
+
+		memset(&expect, 0, sizeof(expect));
+
+		sprintf(mms_proto_string, "(%u)", mms_proto);
+		DEBUGP("ip_conntrack_mms: adding %s expectation %u.%u.%u.%u -> %u.%u.%u.=
%u:%u\n",
+		       mms_proto =3D=3D IPPROTO_TCP ? "TCP"
+		       : mms_proto =3D=3D IPPROTO_UDP ? "UDP":mms_proto_string,
+		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+		       NIPQUAD(mms_ip),
+		       mms_port);
+	=09
+		/* it's possible that the client will just ask the server to tunnel
+		   the stream over the same TCP session (from port 1755): there's=20
+		   shouldn't be a need to add an expectation in that case, but it
+		   makes NAT packet mangling so much easier */
+		LOCK_BH(&ip_mms_lock);
+
+		DEBUGP("ip_conntrack_mms: tcph->seq =3D %u\n", tcph->seq);
+	=09
+		exp->seq =3D ntohl(tcph->seq) + (mms_string_b - data);
+		exp_mms_info->len     =3D (mms_string_e  - mms_string_b);
+		exp_mms_info->padding =3D (mms_padding_e - mms_string_e);
+		exp_mms_info->port    =3D mms_port;
+	=09
+		DEBUGP("ip_conntrack_mms: wrote info seq=3D%u (ofs=3D%u), len=3D%d, padd=
ing=3D%u\n",
+		       exp->seq, (mms_string_e - data), exp_mms_info->len, exp_mms_info-=
>padding);
+	=09
+		exp->tuple =3D ((struct ip_conntrack_tuple)
+		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+		              { mms_ip,
+		                { (__u16) ntohs(mms_port) },
+		                mms_proto } }
+		             );
+		exp->mask  =3D ((struct ip_conntrack_tuple)
+		             { { 0xFFFFFFFF, { 0 } },
+		               { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+		exp->expectfn =3D NULL;
+		ip_conntrack_expect_related(ct, &expect);
+		UNLOCK_BH(&ip_mms_lock);
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper mms[MAX_PORTS];
+static char mms_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		DEBUGP("ip_conntrack_mms: unregistering helper for port %d\n",
+				ports[i]);
+		ip_conntrack_helper_unregister(&mms[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MMS_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&mms[i], 0, sizeof(struct ip_conntrack_helper));
+		mms[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		mms[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		mms[i].mask.src.u.tcp.port =3D 0xFFFF;
+		mms[i].mask.dst.protonum =3D 0xFFFF;
+		mms[i].max_expected =3D 1;
+		mms[i].timeout =3D 0;
+		mms[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		mms[i].me =3D THIS_MODULE;
+		mms[i].help =3D help;
+
+		tmpname =3D &mms_names[i][0];
+		if (ports[i] =3D=3D MMS_PORT)
+			sprintf(tmpname, "mms");
+		else
+			sprintf(tmpname, "mms-%d", ports[i]);
+		mms[i].name =3D tmpname;
+
+		DEBUGP("ip_conntrack_mms: registering helper for port %d\n",=20
+				ports[i]);
+		ret =3D ip_conntrack_helper_register(&mms[i]);
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
+module_init(init);
+module_exit(fini);
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/ip_nat_mms.c lin=
ux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_nat_mms.c
--- linux-2.4.20-pre7/net/ipv4/netfilter/ip_nat_mms.c	1970-01-01 01:00:00.0=
00000000 +0100
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_nat_mms.c	2002-09-22 19:25:=
27.000000000 +0200
@@ -0,0 +1,350 @@
+/* MMS extension for TCP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_nat_ftp.c and ip_nat_irc.c
+ *
+ * ip_nat_mms.c v0.3 2002-09-22
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_nat_mms.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MMS servers You wish to connect to.
+ *      If you don't specify ports, the default will be TCP port 1755.
+ *
+ *      More info on MMS protocol, firewalls and NAT:
+ *      http://msdn.microsoft.com/library/default.asp?url=3D/library/en-us=
/dnwmt/html/MMSFirewall.asp
+ *      http://www.microsoft.com/windows/windowsmedia/serve/firewall.asp
+ *
+ *      The SDP project people are reverse-engineering MMS:
+ *      http://get.to/sdp
+ */
+
+/* FIXME: issue with UDP & fragmentation with this URL:=20
+   http://www.cnn.com/video/world/2002/01/21/jb.shoe.bomb.cafe.cnn.low.asx=
=20
+   may be related to out-of-order first packets:
+   basically the expectation is set up correctly, then the server sends
+   a first UDP packet which is fragmented plus arrives out-of-order.
+   the MASQUERADING firewall with ip_nat_mms loaded responds with
+   an ICMP unreachable back to the server */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <net/tcp.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+
+#if 0=20
+#define DEBUGP printk
+#define DUMP_BYTES(address, counter)                                \
+({                                                                  \
+	int temp_counter;                                           \
+	for(temp_counter=3D0; temp_counter<counter; ++temp_counter) { \
+		DEBUGP("%u ", (u8)*(address+temp_counter));         \
+	};                                                          \
+	DEBUGP("\n");                                               \
+})
+#else
+#define DEBUGP(format, args...)
+#define DUMP_BYTES(address, counter)
+#endif
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) NAT module");
+MODULE_LICENSE("GPL");
+
+DECLARE_LOCK_EXTERN(ip_mms_lock);
+
+/* FIXME: Time out? --RR */
+
+static int mms_data_fixup(const struct ip_ct_mms_expect *ct_mms_info,
+                          struct ip_conntrack *ct,
+                          struct sk_buff **pskb,
+                          enum ip_conntrack_info ctinfo,
+                          struct ip_conntrack_expect *expect)
+{
+	u_int32_t newip;
+	struct ip_conntrack_tuple t;
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
+	char *data =3D (char *)tcph + tcph->doff * 4;
+	int i, j, k, port;
+	u_int16_t mms_proto;
+
+	u_int32_t *mms_chunkLenLV    =3D (u_int32_t *)(data + MMS_SRV_CHUNKLENLV_=
OFFSET);
+	u_int32_t *mms_chunkLenLM    =3D (u_int32_t *)(data + MMS_SRV_CHUNKLENLM_=
OFFSET);
+	u_int32_t *mms_messageLength =3D (u_int32_t *)(data + MMS_SRV_MESSAGELENG=
TH_OFFSET);
+
+	int zero_padding;
+
+	char buffer[28];         /* "\\255.255.255.255\UDP\65635" * 2 (for unicod=
e) */
+	char unicode_buffer[75]; /* 27*2 (unicode) + 20 + 1 */
+	char proto_string[6];
+=09
+	MUST_BE_LOCKED(&ip_mms_lock);
+
+	/* what was the protocol again ? */
+	mms_proto =3D expect->tuple.dst.protonum;
+	sprintf(proto_string, "%u", mms_proto);
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: info (seq %u + %u) in %u, proto %s\n"=
,
+	       expect->seq, ct_mms_info->len, ntohl(tcph->seq),
+	       mms_proto =3D=3D IPPROTO_UDP ? "UDP"
+	       : mms_proto =3D=3D IPPROTO_TCP ? "TCP":proto_string);
+=09
+	newip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+
+	/* Alter conntrack's expectations. */
+	t =3D expect->tuple;
+	t.dst.ip =3D newip;
+	for (port =3D ct_mms_info->port; port !=3D 0; port++) {
+		t.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_change_expect(expect, &t) =3D=3D 0) {
+			DEBUGP("ip_nat_mms: mms_data_fixup: using port %d\n", port);
+			break;
+		}
+	}
+=09
+	if(port =3D=3D 0)
+		return 0;
+
+	sprintf(buffer, "\\\\%u.%u.%u.%u\\%s\\%u",
+	        NIPQUAD(newip),
+		expect->tuple.dst.protonum =3D=3D IPPROTO_UDP ? "UDP"
+		: expect->tuple.dst.protonum =3D=3D IPPROTO_TCP ? "TCP":proto_string,
+		port);
+	DEBUGP("ip_nat_mms: new unicode string=3D%s\n", buffer);
+=09
+	memset(unicode_buffer, 0, sizeof(char)*75);
+
+	for (i=3D0; i<strlen(buffer); ++i)
+		*(unicode_buffer+i*2)=3D*(buffer+i);
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: padding: %u len: %u\n", ct_mms_info->=
padding, ct_mms_info->len);
+	DEBUGP("ip_nat_mms: mms_data_fixup: offset: %u\n", MMS_SRV_UNICODE_STRING=
_OFFSET+ct_mms_info->len);
+	DUMP_BYTES(data+MMS_SRV_UNICODE_STRING_OFFSET, 60);
+=09
+	/* add end of packet to it */
+	for (j=3D0; j<ct_mms_info->padding; ++j) {
+		DEBUGP("ip_nat_mms: mms_data_fixup: i=3D%u j=3D%u byte=3D%u\n",=20
+		       i, j, (u8)*(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len+j=
));
+		*(unicode_buffer+i*2+j) =3D *(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_=
info->len+j);
+	}
+
+	/* pad with zeroes at the end ? see explanation of weird math below */
+	zero_padding =3D (8-(strlen(buffer)*2 + ct_mms_info->padding + 4)%8)%8;
+	for (k=3D0; k<zero_padding; ++k)
+		*(unicode_buffer+i*2+j+k)=3D (char)0;
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: zero_padding =3D %u\n", zero_padding)=
;
+	DEBUGP("ip_nat_mms: original=3D> chunkLenLV=3D%u chunkLenLM=3D%u messageL=
ength=3D%u\n",
+	       *mms_chunkLenLV, *mms_chunkLenLM, *mms_messageLength);
+=09
+	/* explanation, before I forget what I did:
+	   strlen(buffer)*2 + ct_mms_info->padding + 4 must be divisable by 8;
+	   divide by 8 and add 3 to compute the mms_chunkLenLM field,
+	   but note that things may have to be padded with zeroes to align by 8=20
+	   bytes, hence we add 7 and divide by 8 to get the correct length */=20
+	*mms_chunkLenLM    =3D (u_int32_t) (3+(strlen(buffer)*2+ct_mms_info->padd=
ing+11)/8);
+	*mms_chunkLenLV    =3D *mms_chunkLenLM+2;
+	*mms_messageLength =3D *mms_chunkLenLV*8;
+=09
+	DEBUGP("ip_nat_mms: modified=3D> chunkLenLV=3D%u chunkLenLM=3D%u messageL=
ength=3D%u\n",
+	       *mms_chunkLenLV, *mms_chunkLenLM, *mms_messageLength);
+=09
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,=20
+	                         expect->seq - ntohl(tcph->seq),
+	                         ct_mms_info->len + ct_mms_info->padding, unicode=
_buffer,
+	                         strlen(buffer)*2 + ct_mms_info->padding + zero_p=
adding);
+	DUMP_BYTES(unicode_buffer, 60);
+=09
+	return 1;
+}
+
+static unsigned int
+mms_nat_expected(struct sk_buff **pskb,
+                 unsigned int hooknum,
+                 struct ip_conntrack *ct,
+                 struct ip_nat_info *info)
+{
+	struct ip_nat_multi_range mr;
+	u_int32_t newdstip, newsrcip, newip;
+
+	struct ip_conntrack *master =3D master_ct(ct);
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+
+	DEBUGP("ip_nat_mms: mms_nat_expected: We have a connection!\n");
+
+	newdstip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	newsrcip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	DEBUGP("ip_nat_mms: mms_nat_expected: hook %s: newsrc->newdst %u.%u.%u.%u=
->%u.%u.%u.%u\n",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???",
+	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
+
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
+		newip =3D newsrcip;
+	else
+		newip =3D newdstip;
+
+	DEBUGP("ip_nat_mms: mms_nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip=
));
+
+	mr.rangesize =3D 1;
+	/* We don't want to manip the per-protocol, just the IPs. */
+	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
+	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
+
+	return ip_nat_setup_info(ct, &mr, hooknum);
+}
+
+
+static unsigned int mms_nat_help(struct ip_conntrack *ct,
+			 struct ip_conntrack_expect *exp,
+			 struct ip_nat_info *info,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int hooknum,
+			 struct sk_buff **pskb)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
+	unsigned int datalen;
+	int dir;
+	struct ip_ct_mms_expect *ct_mms_info;
+
+	if (!exp)
+		DEBUGP("ip_nat_mms: no exp!!");
+
+	ct_mms_info =3D &exp->help.exp_mms_info;
+=09
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	dir =3D CTINFO2DIR(ctinfo);
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL=
)
+	    ||(hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY))) =
{
+		DEBUGP("ip_nat_mms: mms_nat_help: not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+		return NF_ACCEPT;
+	}
+	DEBUGP("ip_nat_mms: mms_nat_help: beyond not touching (dir %s at hook %s)=
\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+=09
+	datalen =3D (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
+=09
+	DEBUGP("ip_nat_mms: mms_nat_help: %u+%u=3D%u %u %u\n", exp->seq, ct_mms_i=
nfo->len,
+	       exp->seq + ct_mms_info->len,
+	       ntohl(tcph->seq),
+	       ntohl(tcph->seq) + datalen);
+=09
+	LOCK_BH(&ip_mms_lock);
+	/* Check wether the whole IP/proto/port pattern is carried in the payload=
 */
+	if (between(exp->seq + ct_mms_info->len,
+	    ntohl(tcph->seq),
+	    ntohl(tcph->seq) + datalen)) {
+		if (!mms_data_fixup(ct_mms_info, ct, pskb, ctinfo, exp)) {
+			UNLOCK_BH(&ip_mms_lock);
+			return NF_DROP;
+		}
+	} else {
+		/* Half a match?  This means a partial retransmisison.
+		   It's a cracker being funky. */
+		if (net_ratelimit()) {
+			printk("ip_nat_mms: partial packet %u/%u in %u/%u\n",
+			       exp->seq, ct_mms_info->len,
+			       ntohl(tcph->seq),
+			       ntohl(tcph->seq) + datalen);
+		}
+		UNLOCK_BH(&ip_mms_lock);
+		return NF_DROP;
+	}
+	UNLOCK_BH(&ip_mms_lock);
+=09
+	return NF_ACCEPT;
+}
+
+static struct ip_nat_helper mms[MAX_PORTS];
+static char mms_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		DEBUGP("ip_nat_mms: unregistering helper for port %d\n", ports[i]);
+		ip_nat_helper_unregister(&mms[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret =3D 0;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MMS_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+
+		memset(&mms[i], 0, sizeof(struct ip_nat_helper));
+
+		mms[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		mms[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		mms[i].mask.dst.protonum =3D 0xFFFF;
+		mms[i].mask.src.u.tcp.port =3D 0xFFFF;
+		mms[i].help =3D mms_nat_help;
+		mms[i].me =3D THIS_MODULE;
+		mms[i].flags =3D 0;
+		mms[i].expect =3D mms_nat_expected;
+
+		tmpname =3D &mms_names[i][0];
+		if (ports[i] =3D=3D MMS_PORT)
+			sprintf(tmpname, "mms");
+		else
+			sprintf(tmpname, "mms-%d", i);
+		mms[i].name =3D tmpname;
+
+		DEBUGP("ip_nat_mms: register helper for port %d\n",
+				ports[i]);
+		ret =3D ip_nat_helper_register(&mms[i]);
+
+		if (ret) {
+			printk("ip_nat_mms: error registering "
+			       "helper for port %d\n", ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
+	}
+
+	return ret;
+}
+
+module_init(init);
+module_exit(fini);

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=mms-conntrack-nat.patch; charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_con=
ntrack.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack.h	2002-09-2=
2 19:50:53.000000000 +0200
+++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h	2002-=
09-17 04:08:25.000000000 +0200
@@ -60,12 +60,14 @@
 /* Add protocol helper include file here */
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
=20
 /* per expectation: application helper private data */
 union ip_conntrack_expect_help {
 	/* insert conntrack helper private data (expect) here */
 	struct ip_ct_ftp_expect exp_ftp_info;
 	struct ip_ct_irc_expect exp_irc_info;
+	struct ip_ct_mms_expect exp_mms_info;
=20
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	union {
@@ -79,6 +81,7 @@
 	/* insert conntrack helper private data (master) here */
 	struct ip_ct_ftp_master ct_ftp_info;
 	struct ip_ct_irc_master ct_irc_info;
+	struct ip_ct_mms_master ct_mms_info;
 };
=20
 #ifdef CONFIG_IP_NF_NAT_NEEDED
diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_con=
ntrack_mms.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrac=
k_mms.h
--- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack_mms.h	1970-=
01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack_mms.h	2=
002-09-17 04:08:25.000000000 +0200
@@ -0,0 +1,33 @@
+#ifndef _IP_CONNTRACK_MMS_H
+#define _IP_CONNTRACK_MMS_H
+/* MMS tracking. */
+
+#ifndef __KERNEL__
+#error Only in kernel.
+#endif
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+DECLARE_LOCK_EXTERN(ip_mms_lock);
+
+#define MMS_PORT                         1755
+#define MMS_SRV_MSG_ID                   196610
+
+#define MMS_SRV_MSG_OFFSET               36
+#define MMS_SRV_UNICODE_STRING_OFFSET    60
+#define MMS_SRV_CHUNKLENLV_OFFSET        16
+#define MMS_SRV_CHUNKLENLM_OFFSET        32
+#define MMS_SRV_MESSAGELENGTH_OFFSET     8
+
+/* This structure is per expected connection */
+struct ip_ct_mms_expect {
+	u_int32_t len;
+	u_int32_t padding;
+	u_int16_t port;
+};
+
+/* This structure exists only once per master */
+struct ip_ct_mms_master {
+};
+
+#endif /* _IP_CONNTRACK_MMS_H */
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mms=
.c linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c
--- linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mms.c	1970-01-01 01:0=
0:00.000000000 +0100
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c	2002-09-17 =
01:29:20.000000000 +0200
@@ -0,0 +1,310 @@
+/* MMS extension for IP connection tracking
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_conntrack_ftp.c and ip_conntrack_irc.c
+ *
+ * ip_conntrack_mms.c v0.3 2002-09-22
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_conntrack_mms.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MMS servers You wish to connect to.
+ *      If you don't specify ports, the default will be TCP port 1755.
+ *
+ *      More info on MMS protocol, firewalls and NAT:
+ *      http://msdn.microsoft.com/library/default.asp?url=3D/library/en-us=
/dnwmt/html/MMSFirewall.asp
+ *      http://www.microsoft.com/windows/windowsmedia/serve/firewall.asp
+ *
+ *      The SDP project people are reverse-engineering MMS:
+ *      http://get.to/sdp
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ctype.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
+
+DECLARE_LOCK(ip_mms_lock);
+struct module *ip_conntrack_mms =3D THIS_MODULE;
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+#endif
+
+#if 0=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+EXPORT_SYMBOL(ip_mms_lock);
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) connection trac=
king module");
+MODULE_LICENSE("GPL");
+
+/* #define isdigit(c) (c >=3D '0' && c <=3D '9') */
+
+/* copied from drivers/usb/serial/io_edgeport.c - not perfect but will do =
the trick */
+static void unicode_to_ascii (char *string, short *unicode, int unicode_si=
ze)
+{
+	int i;
+	for (i =3D 0; i < unicode_size; ++i) {
+		string[i] =3D (char)(unicode[i]);
+	}
+	string[unicode_size] =3D 0x00;
+}
+
+__inline static int atoi(char *s)=20
+{
+	int i=3D0;
+	while (isdigit(*s)) {
+		i =3D i*10 + *(s++) - '0';
+	}
+	return i;
+}
+
+/* convert ip address string like "192.168.0.10" to unsigned int */
+__inline static u_int32_t asciiiptoi(char *s)
+{
+	unsigned int i, j, k;
+
+	for(i=3Dk=3D0; k<3; ++k, ++s, i<<=3D8) {
+		i+=3Datoi(s);
+		for(j=3D0; (*(++s) !=3D '.') && (j<3); ++j)
+			;
+	}
+	i+=3Datoi(s);
+	return ntohl(i);
+}
+
+int parse_mms(const char *data,=20
+	      const unsigned int datalen,
+	      u_int32_t *mms_ip,
+	      u_int16_t *mms_proto,
+	      u_int16_t *mms_port,
+	      char **mms_string_b,
+	      char **mms_string_e,
+	      char **mms_padding_e)
+{
+	int unicode_size, i;
+	char tempstring[28];       /* "\\255.255.255.255\UDP\65535" */
+	char getlengthstring[28];
+=09
+	for(unicode_size=3D0;=20
+	    (char) *(data+(MMS_SRV_UNICODE_STRING_OFFSET+unicode_size*2)) !=3D (c=
har)0;
+	    unicode_size++)
+		if ((unicode_size =3D=3D 28) || (MMS_SRV_UNICODE_STRING_OFFSET+unicode_s=
ize*2 >=3D datalen))=20
+			return -1; /* out of bounds - incomplete packet */
+=09
+	unicode_to_ascii(tempstring, (short *)(data+MMS_SRV_UNICODE_STRING_OFFSET=
), unicode_size);
+	DEBUGP("ip_conntrack_mms: offset 60: %s\n", (const char *)(tempstring));
+=09
+	/* IP address ? */
+	*mms_ip =3D asciiiptoi(tempstring+2);
+=09
+	i=3Dsprintf(getlengthstring, "%u.%u.%u.%u", HIPQUAD(*mms_ip));
+	=09
+	/* protocol ? */
+	if(strncmp(tempstring+3+i, "TCP", 3)=3D=3D0)
+		*mms_proto =3D IPPROTO_TCP;
+	else if(strncmp(tempstring+3+i, "UDP", 3)=3D=3D0)
+		*mms_proto =3D IPPROTO_UDP;
+
+	/* port ? */
+	*mms_port =3D atoi(tempstring+7+i);
+
+	/* we store a pointer to the beginning of the "\\a.b.c.d\proto\port"=20
+	   unicode string, one to the end of the string, and one to the end=20
+	   of the packet, since we must keep track of the number of bytes=20
+	   between end of the unicode string and the end of packet (padding) */
+	*mms_string_b  =3D (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET);
+	*mms_string_e  =3D (char *)(data + MMS_SRV_UNICODE_STRING_OFFSET + unicod=
e_size * 2);
+	*mms_padding_e =3D (char *)(data + datalen); /* looks funny, doesn't it *=
/
+	return 0;
+}
+
+
+/* FIXME: This should be in userspace.  Later. */
+static int help(const struct iphdr *iph, size_t len,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	/* tcplen not negative guaranteed by ip_conntrack_tcp.c */
+	struct tcphdr *tcph =3D (void *)iph + iph->ihl * 4;
+	const char *data =3D (const char *)tcph + tcph->doff * 4;
+	unsigned int tcplen =3D len - iph->ihl * 4;
+	unsigned int datalen =3D tcplen - tcph->doff * 4;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect expect, *exp =3D &expect;=20
+	struct ip_ct_mms_expect *exp_mms_info =3D &exp->help.exp_mms_info;
+=09
+	u_int32_t mms_ip;
+	u_int16_t mms_proto;
+	char mms_proto_string[8];
+	u_int16_t mms_port;
+	char *mms_string_b, *mms_string_e, *mms_padding_e;
+	    =20
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
+		DEBUGP("ip_conntrack_mms: Conntrackinfo =3D %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
+
+	/* Not whole TCP header? */
+	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+		DEBUGP("ip_conntrack_mms: tcplen =3D %u\n", (unsigned)tcplen);
+		return NF_ACCEPT;
+	}
+
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+	    csum_partial((char *)tcph, tcplen, 0))) {
+		DEBUGP("mms_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
+		       tcph, tcplen, NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
+=09
+	/* Only look at packets with 0x00030002/196610 on bytes 36->39 of TCP pay=
load */
+	/* FIXME: There is an issue with only looking at this packet: before this=
 packet,=20
+	   the client has already sent a packet to the server with the server's h=
ostname=20
+	   according to the client (think of it as the "Host: " header in HTTP/1.=
1). The=20
+	   server will break the connection if this doesn't correspond to its own=
 host=20
+	   header. The client can also connect to an IP address; if it's the serv=
er's IP
+	   address, it will not break the connection. When doing DNAT on a connec=
tion=20
+	   where the client uses a server's IP address, the nat module should det=
ect
+	   this and change this string accordingly to the DNATed address. This sh=
ould
+	   probably be done by checking for an IP address, then storing it as a m=
ember
+	   of struct ip_ct_mms_expect and checking for it in ip_nat_mms...
+	   */
+	if( (MMS_SRV_MSG_OFFSET < datalen) &&=20
+	    ((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) =3D=3D MMS_SRV_MSG_ID)) {
+		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",=20
+		       (u8)*(data+36), (u8)*(data+37),=20
+		       (u8)*(data+38), (u8)*(data+39),
+		       datalen);
+		if(parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
+		             &mms_string_b, &mms_string_e, &mms_padding_e))
+			if(net_ratelimit())
+				/* FIXME: more verbose debugging ? */
+				printk(KERN_WARNING
+				       "ip_conntrack_mms: Unable to parse data payload\n");
+
+		memset(&expect, 0, sizeof(expect));
+
+		sprintf(mms_proto_string, "(%u)", mms_proto);
+		DEBUGP("ip_conntrack_mms: adding %s expectation %u.%u.%u.%u -> %u.%u.%u.=
%u:%u\n",
+		       mms_proto =3D=3D IPPROTO_TCP ? "TCP"
+		       : mms_proto =3D=3D IPPROTO_UDP ? "UDP":mms_proto_string,
+		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+		       NIPQUAD(mms_ip),
+		       mms_port);
+	=09
+		/* it's possible that the client will just ask the server to tunnel
+		   the stream over the same TCP session (from port 1755): there's=20
+		   shouldn't be a need to add an expectation in that case, but it
+		   makes NAT packet mangling so much easier */
+		LOCK_BH(&ip_mms_lock);
+
+		DEBUGP("ip_conntrack_mms: tcph->seq =3D %u\n", tcph->seq);
+	=09
+		exp->seq =3D ntohl(tcph->seq) + (mms_string_b - data);
+		exp_mms_info->len     =3D (mms_string_e  - mms_string_b);
+		exp_mms_info->padding =3D (mms_padding_e - mms_string_e);
+		exp_mms_info->port    =3D mms_port;
+	=09
+		DEBUGP("ip_conntrack_mms: wrote info seq=3D%u (ofs=3D%u), len=3D%d, padd=
ing=3D%u\n",
+		       exp->seq, (mms_string_e - data), exp_mms_info->len, exp_mms_info-=
>padding);
+	=09
+		exp->tuple =3D ((struct ip_conntrack_tuple)
+		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+		              { mms_ip,
+		                { (__u16) ntohs(mms_port) },
+		                mms_proto } }
+		             );
+		exp->mask  =3D ((struct ip_conntrack_tuple)
+		             { { 0xFFFFFFFF, { 0 } },
+		               { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+		exp->expectfn =3D NULL;
+		ip_conntrack_expect_related(ct, &expect);
+		UNLOCK_BH(&ip_mms_lock);
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper mms[MAX_PORTS];
+static char mms_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		DEBUGP("ip_conntrack_mms: unregistering helper for port %d\n",
+				ports[i]);
+		ip_conntrack_helper_unregister(&mms[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MMS_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		memset(&mms[i], 0, sizeof(struct ip_conntrack_helper));
+		mms[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		mms[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		mms[i].mask.src.u.tcp.port =3D 0xFFFF;
+		mms[i].mask.dst.protonum =3D 0xFFFF;
+		mms[i].max_expected =3D 1;
+		mms[i].timeout =3D 0;
+		mms[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		mms[i].me =3D THIS_MODULE;
+		mms[i].help =3D help;
+
+		tmpname =3D &mms_names[i][0];
+		if (ports[i] =3D=3D MMS_PORT)
+			sprintf(tmpname, "mms");
+		else
+			sprintf(tmpname, "mms-%d", ports[i]);
+		mms[i].name =3D tmpname;
+
+		DEBUGP("ip_conntrack_mms: registering helper for port %d\n",=20
+				ports[i]);
+		ret =3D ip_conntrack_helper_register(&mms[i]);
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
+module_init(init);
+module_exit(fini);
diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/ip_nat_mms.c lin=
ux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_nat_mms.c
--- linux-2.4.20-pre7/net/ipv4/netfilter/ip_nat_mms.c	1970-01-01 01:00:00.0=
00000000 +0100
+++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_nat_mms.c	2002-09-22 19:25:=
27.000000000 +0200
@@ -0,0 +1,350 @@
+/* MMS extension for TCP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_nat_ftp.c and ip_nat_irc.c
+ *
+ * ip_nat_mms.c v0.3 2002-09-22
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_nat_mms.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MMS servers You wish to connect to.
+ *      If you don't specify ports, the default will be TCP port 1755.
+ *
+ *      More info on MMS protocol, firewalls and NAT:
+ *      http://msdn.microsoft.com/library/default.asp?url=3D/library/en-us=
/dnwmt/html/MMSFirewall.asp
+ *      http://www.microsoft.com/windows/windowsmedia/serve/firewall.asp
+ *
+ *      The SDP project people are reverse-engineering MMS:
+ *      http://get.to/sdp
+ */
+
+/* FIXME: issue with UDP & fragmentation with this URL:=20
+   http://www.cnn.com/video/world/2002/01/21/jb.shoe.bomb.cafe.cnn.low.asx=
=20
+   may be related to out-of-order first packets:
+   basically the expectation is set up correctly, then the server sends
+   a first UDP packet which is fragmented plus arrives out-of-order.
+   the MASQUERADING firewall with ip_nat_mms loaded responds with
+   an ICMP unreachable back to the server */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <net/tcp.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+
+#if 0=20
+#define DEBUGP printk
+#define DUMP_BYTES(address, counter)                                \
+({                                                                  \
+	int temp_counter;                                           \
+	for(temp_counter=3D0; temp_counter<counter; ++temp_counter) { \
+		DEBUGP("%u ", (u8)*(address+temp_counter));         \
+	};                                                          \
+	DEBUGP("\n");                                               \
+})
+#else
+#define DEBUGP(format, args...)
+#define DUMP_BYTES(address, counter)
+#endif
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) NAT module");
+MODULE_LICENSE("GPL");
+
+DECLARE_LOCK_EXTERN(ip_mms_lock);
+
+/* FIXME: Time out? --RR */
+
+static int mms_data_fixup(const struct ip_ct_mms_expect *ct_mms_info,
+                          struct ip_conntrack *ct,
+                          struct sk_buff **pskb,
+                          enum ip_conntrack_info ctinfo,
+                          struct ip_conntrack_expect *expect)
+{
+	u_int32_t newip;
+	struct ip_conntrack_tuple t;
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
+	char *data =3D (char *)tcph + tcph->doff * 4;
+	int i, j, k, port;
+	u_int16_t mms_proto;
+
+	u_int32_t *mms_chunkLenLV    =3D (u_int32_t *)(data + MMS_SRV_CHUNKLENLV_=
OFFSET);
+	u_int32_t *mms_chunkLenLM    =3D (u_int32_t *)(data + MMS_SRV_CHUNKLENLM_=
OFFSET);
+	u_int32_t *mms_messageLength =3D (u_int32_t *)(data + MMS_SRV_MESSAGELENG=
TH_OFFSET);
+
+	int zero_padding;
+
+	char buffer[28];         /* "\\255.255.255.255\UDP\65635" * 2 (for unicod=
e) */
+	char unicode_buffer[75]; /* 27*2 (unicode) + 20 + 1 */
+	char proto_string[6];
+=09
+	MUST_BE_LOCKED(&ip_mms_lock);
+
+	/* what was the protocol again ? */
+	mms_proto =3D expect->tuple.dst.protonum;
+	sprintf(proto_string, "%u", mms_proto);
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: info (seq %u + %u) in %u, proto %s\n"=
,
+	       expect->seq, ct_mms_info->len, ntohl(tcph->seq),
+	       mms_proto =3D=3D IPPROTO_UDP ? "UDP"
+	       : mms_proto =3D=3D IPPROTO_TCP ? "TCP":proto_string);
+=09
+	newip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+
+	/* Alter conntrack's expectations. */
+	t =3D expect->tuple;
+	t.dst.ip =3D newip;
+	for (port =3D ct_mms_info->port; port !=3D 0; port++) {
+		t.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_change_expect(expect, &t) =3D=3D 0) {
+			DEBUGP("ip_nat_mms: mms_data_fixup: using port %d\n", port);
+			break;
+		}
+	}
+=09
+	if(port =3D=3D 0)
+		return 0;
+
+	sprintf(buffer, "\\\\%u.%u.%u.%u\\%s\\%u",
+	        NIPQUAD(newip),
+		expect->tuple.dst.protonum =3D=3D IPPROTO_UDP ? "UDP"
+		: expect->tuple.dst.protonum =3D=3D IPPROTO_TCP ? "TCP":proto_string,
+		port);
+	DEBUGP("ip_nat_mms: new unicode string=3D%s\n", buffer);
+=09
+	memset(unicode_buffer, 0, sizeof(char)*75);
+
+	for (i=3D0; i<strlen(buffer); ++i)
+		*(unicode_buffer+i*2)=3D*(buffer+i);
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: padding: %u len: %u\n", ct_mms_info->=
padding, ct_mms_info->len);
+	DEBUGP("ip_nat_mms: mms_data_fixup: offset: %u\n", MMS_SRV_UNICODE_STRING=
_OFFSET+ct_mms_info->len);
+	DUMP_BYTES(data+MMS_SRV_UNICODE_STRING_OFFSET, 60);
+=09
+	/* add end of packet to it */
+	for (j=3D0; j<ct_mms_info->padding; ++j) {
+		DEBUGP("ip_nat_mms: mms_data_fixup: i=3D%u j=3D%u byte=3D%u\n",=20
+		       i, j, (u8)*(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len+j=
));
+		*(unicode_buffer+i*2+j) =3D *(data+MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_=
info->len+j);
+	}
+
+	/* pad with zeroes at the end ? see explanation of weird math below */
+	zero_padding =3D (8-(strlen(buffer)*2 + ct_mms_info->padding + 4)%8)%8;
+	for (k=3D0; k<zero_padding; ++k)
+		*(unicode_buffer+i*2+j+k)=3D (char)0;
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: zero_padding =3D %u\n", zero_padding)=
;
+	DEBUGP("ip_nat_mms: original=3D> chunkLenLV=3D%u chunkLenLM=3D%u messageL=
ength=3D%u\n",
+	       *mms_chunkLenLV, *mms_chunkLenLM, *mms_messageLength);
+=09
+	/* explanation, before I forget what I did:
+	   strlen(buffer)*2 + ct_mms_info->padding + 4 must be divisable by 8;
+	   divide by 8 and add 3 to compute the mms_chunkLenLM field,
+	   but note that things may have to be padded with zeroes to align by 8=20
+	   bytes, hence we add 7 and divide by 8 to get the correct length */=20
+	*mms_chunkLenLM    =3D (u_int32_t) (3+(strlen(buffer)*2+ct_mms_info->padd=
ing+11)/8);
+	*mms_chunkLenLV    =3D *mms_chunkLenLM+2;
+	*mms_messageLength =3D *mms_chunkLenLV*8;
+=09
+	DEBUGP("ip_nat_mms: modified=3D> chunkLenLV=3D%u chunkLenLM=3D%u messageL=
ength=3D%u\n",
+	       *mms_chunkLenLV, *mms_chunkLenLM, *mms_messageLength);
+=09
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,=20
+	                         expect->seq - ntohl(tcph->seq),
+	                         ct_mms_info->len + ct_mms_info->padding, unicode=
_buffer,
+	                         strlen(buffer)*2 + ct_mms_info->padding + zero_p=
adding);
+	DUMP_BYTES(unicode_buffer, 60);
+=09
+	return 1;
+}
+
+static unsigned int
+mms_nat_expected(struct sk_buff **pskb,
+                 unsigned int hooknum,
+                 struct ip_conntrack *ct,
+                 struct ip_nat_info *info)
+{
+	struct ip_nat_multi_range mr;
+	u_int32_t newdstip, newsrcip, newip;
+
+	struct ip_conntrack *master =3D master_ct(ct);
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+
+	DEBUGP("ip_nat_mms: mms_nat_expected: We have a connection!\n");
+
+	newdstip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	newsrcip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	DEBUGP("ip_nat_mms: mms_nat_expected: hook %s: newsrc->newdst %u.%u.%u.%u=
->%u.%u.%u.%u\n",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???",
+	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
+
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
+		newip =3D newsrcip;
+	else
+		newip =3D newdstip;
+
+	DEBUGP("ip_nat_mms: mms_nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip=
));
+
+	mr.rangesize =3D 1;
+	/* We don't want to manip the per-protocol, just the IPs. */
+	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
+	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
+
+	return ip_nat_setup_info(ct, &mr, hooknum);
+}
+
+
+static unsigned int mms_nat_help(struct ip_conntrack *ct,
+			 struct ip_conntrack_expect *exp,
+			 struct ip_nat_info *info,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int hooknum,
+			 struct sk_buff **pskb)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
+	unsigned int datalen;
+	int dir;
+	struct ip_ct_mms_expect *ct_mms_info;
+
+	if (!exp)
+		DEBUGP("ip_nat_mms: no exp!!");
+
+	ct_mms_info =3D &exp->help.exp_mms_info;
+=09
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	dir =3D CTINFO2DIR(ctinfo);
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL=
)
+	    ||(hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY))) =
{
+		DEBUGP("ip_nat_mms: mms_nat_help: not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+		return NF_ACCEPT;
+	}
+	DEBUGP("ip_nat_mms: mms_nat_help: beyond not touching (dir %s at hook %s)=
\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+=09
+	datalen =3D (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
+=09
+	DEBUGP("ip_nat_mms: mms_nat_help: %u+%u=3D%u %u %u\n", exp->seq, ct_mms_i=
nfo->len,
+	       exp->seq + ct_mms_info->len,
+	       ntohl(tcph->seq),
+	       ntohl(tcph->seq) + datalen);
+=09
+	LOCK_BH(&ip_mms_lock);
+	/* Check wether the whole IP/proto/port pattern is carried in the payload=
 */
+	if (between(exp->seq + ct_mms_info->len,
+	    ntohl(tcph->seq),
+	    ntohl(tcph->seq) + datalen)) {
+		if (!mms_data_fixup(ct_mms_info, ct, pskb, ctinfo, exp)) {
+			UNLOCK_BH(&ip_mms_lock);
+			return NF_DROP;
+		}
+	} else {
+		/* Half a match?  This means a partial retransmisison.
+		   It's a cracker being funky. */
+		if (net_ratelimit()) {
+			printk("ip_nat_mms: partial packet %u/%u in %u/%u\n",
+			       exp->seq, ct_mms_info->len,
+			       ntohl(tcph->seq),
+			       ntohl(tcph->seq) + datalen);
+		}
+		UNLOCK_BH(&ip_mms_lock);
+		return NF_DROP;
+	}
+	UNLOCK_BH(&ip_mms_lock);
+=09
+	return NF_ACCEPT;
+}
+
+static struct ip_nat_helper mms[MAX_PORTS];
+static char mms_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+		DEBUGP("ip_nat_mms: unregistering helper for port %d\n", ports[i]);
+		ip_nat_helper_unregister(&mms[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret =3D 0;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MMS_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+
+		memset(&mms[i], 0, sizeof(struct ip_nat_helper));
+
+		mms[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		mms[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		mms[i].mask.dst.protonum =3D 0xFFFF;
+		mms[i].mask.src.u.tcp.port =3D 0xFFFF;
+		mms[i].help =3D mms_nat_help;
+		mms[i].me =3D THIS_MODULE;
+		mms[i].flags =3D 0;
+		mms[i].expect =3D mms_nat_expected;
+
+		tmpname =3D &mms_names[i][0];
+		if (ports[i] =3D=3D MMS_PORT)
+			sprintf(tmpname, "mms");
+		else
+			sprintf(tmpname, "mms-%d", i);
+		mms[i].name =3D tmpname;
+
+		DEBUGP("ip_nat_mms: register helper for port %d\n",
+				ports[i]);
+		ret =3D ip_nat_helper_register(&mms[i]);
+
+		if (ret) {
+			printk("ip_nat_mms: error registering "
+			       "helper for port %d\n", ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
+	}
+
+	return ret;
+}
+
+module_init(init);
+module_exit(fini);

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.config.in
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=mms-conntrack-nat.patch.config.in;
	charset=ANSI_X3.4-1968

  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CONN=
TRACK
  dep_tristate '  MMS protocol support' CONFIG_IP_NF_MMS $CONFIG_IP_NF_CONN=
TRACK

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.config.in-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=mms-conntrack-nat.patch.config.in-2;
	charset=ANSI_X3.4-1968

          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
        fi
      fi
      if [ "$CONFIG_IP_NF_MMS" =3D "m" ]; then
        define_tristate CONFIG_IP_NF_NAT_MMS m
      else
        if [ "$CONFIG_IP_NF_MMS" =3D "y" ]; then
          define_tristate CONFIG_IP_NF_NAT_MMS $CONFIG_IP_NF_NAT

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.configure.help
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=mms-conntrack-nat.patch.configure.help;
	charset=ANSI_X3.4-1968

CONFIG_IP_NF_IRC
MMS protocol support
CONFIG_IP_NF_MMS
  Tracking MMS (Microsoft Windows Media Services) connections
  could be problematic if random ports are used to send the
  streaming content. This option allows users to track streaming
  connections over random UDP or TCP ports.

  If you want to compile it as a module, say M here and read
  <file:Documentation/modules.txt>.  If unsure, say `Y'.

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.help
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=mms-conntrack-nat.patch.help; charset=ANSI_X3.4-1968

Author: Filip Sneppe <filip.sneppe@cronos.be>
Status: WorksForMe(tm)

This adds CONFIG_IP_NF_MMS: support for Microsoft Streaming Media=20
Services. This allows client (Windows Media Player) and server
to negotiate protocol (UDP, TCP) and port for the media stream.

A partially reverse engineered protocol analysis is available=20
from http://get.to/sdp, together with a link to a Linux client.

By default, the helper module tracks TCP traffic over port 1755
and adds the necessary UPD or TCP expectation. It is recommended=20
to also open UDP port 1755 to the server, as this port is used=20
for retransmission requests.

This helper has been tested in SNAT and DNAT setups.

Note that this helper has *nothing* to do with ip_masq_mms for=20
2.2 kernels!

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.makefile
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-makefile; name=mms-conntrack-nat.patch.makefile;
	charset=ANSI_X3.4-1968

# connection tracking helpers
obj-$(CONFIG_IP_NF_MMS) +=3D ip_conntrack_mms.o
ifdef CONFIG_IP_NF_NAT_MMS
	export-objs +=3D ip_conntrack_mms.o
endif

--=-9KuH5JnxKTx2HnF0PZK1
Content-Disposition: attachment; filename=mms-conntrack-nat.patch.makefile-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-makefile; name=mms-conntrack-nat.patch.makefile-2;
	charset=ANSI_X3.4-1968

obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
obj-$(CONFIG_IP_NF_NAT_MMS) +=3D ip_nat_mms.o

--=-9KuH5JnxKTx2HnF0PZK1--
