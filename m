From: Sven Schuster <schuster.sven@gmx.de>
Subject: [PATCH 1/3] pom-ng: update mms-conntrack-nat for 2.6.12
Date: Tue, 26 Jul 2005 21:04:14 +0200
Message-ID: <20050726190414.GA2036@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
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


--ftEhullJWpWg/VHq
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

the attached patch updates the mms-conntrack-nat patchlet in pom-ng
for 2.6.12.

Compile-tested by J=E9r=F4me Poulin and me on 2.6.13-rc3-mm1, functionality
tested by J=E9r=F4me, works.


Regards,

Sven


--=20
Linux zion 2.6.13-rc3-mm1 #12 PREEMPT Sun Jul 24 02:04:45 CEST 2005 i686 at=
hlon i386 GNU/Linux
 21:03:54 up 1 day, 21:13,  1 user,  load average: 0.47, 0.70, 0.35

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mms.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/include/linux/netfilter_ipv4/ip_conntrack.h.ladd pom-ng-edit/patchlets=
/mms-conntrack-nat/linux-2.6.12/include/linux/netfilter_ipv4/ip_conntrack.h=
=2Eladd
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netfi=
lter_ipv4/ip_conntrack.h.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd	2005-07-03 22:40:06.000000000 +0200
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_mms_master ct_mms_info;
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2 pom-ng-edit/patchle=
ts/mms-conntrack-nat/linux-2.6.12/include/linux/netfilter_ipv4/ip_conntrack=
=2Eh.ladd_2
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netfi=
lter_ipv4/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_2	2005-07-03 22:40:06.000000000 +0200
@@ -0,0 +1,2 @@
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/include/linux/netfilter_ipv4/ip_conntrack_mms.h pom-ng-edit/patchlets/=
mms-conntrack-nat/linux-2.6.12/include/linux/netfilter_ipv4/ip_conntrack_mm=
s.h
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netfi=
lter_ipv4/ip_conntrack_mms.h	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/include/linux/netf=
ilter_ipv4/ip_conntrack_mms.h	2005-07-22 14:02:32.000000000 +0200
@@ -0,0 +1,36 @@
+#ifndef _IP_CONNTRACK_MMS_H
+#define _IP_CONNTRACK_MMS_H
+/* MMS tracking. */
+
+#ifdef __KERNEL__
+
+extern spinlock_t ip_mms_lock;
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
+	u_int32_t offset;
+	u_int32_t len;
+	u_int32_t padding;
+	u_int16_t port;
+};
+
+/* This structure exists only once per master */
+struct ip_ct_mms_master {
+};
+
+struct ip_conntrack_expect;
+extern unsigned int (*ip_nat_mms_hook)(struct sk_buff **pskb,
+				       enum ip_conntrack_info ctinfo,
+				       const struct ip_ct_mms_expect *exp_mms_info,
+				       struct ip_conntrack_expect *exp);
+#endif
+#endif /* _IP_CONNTRACK_MMS_H */
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/ip_conntrack_mms.c pom-ng-edit/patchlets/mms-conntr=
ack-nat/linux-2.6.12/net/ipv4/netfilter/ip_conntrack_mms.c
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_conntrack_mms.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_conntrack_mms.c	2005-07-22 10:32:22.000000000 +0200
@@ -0,0 +1,352 @@
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
+ *
+ *  2005-02-13: Harald Welte <laforge@netfilter.org>
+ *  	- port to 2.6.x
+ *  	- update to work with post 2.6.11 helper API changes
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
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
+
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c;
+module_param_array(ports, int, &ports_c, 0400);
+MODULE_PARM_DESC(ports, "port numbers of MMS");
+
+static char mms_buffer[65536];
+static DEFINE_SPINLOCK(mms_buffer_lock);
+
+unsigned int (*ip_nat_mms_hook)(struct sk_buff **pskb,
+				enum ip_conntrack_info ctinfo,
+				const struct ip_ct_mms_expect *exp_mms_info,
+				struct ip_conntrack_expect *exp);
+EXPORT_SYMBOL(ip_nat_mms_hook);
+
+#if 0=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
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
+	*mms_padding_e =3D (char *)(data + datalen); /* looks funny, doesn't it */
+	return 0;
+}
+
+
+/* FIXME: This should be in userspace.  Later. */
+static int help(struct sk_buff **pskb,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	int ret =3D NF_DROP;
+	struct tcphdr _tcph, *th;
+	char *data, *mb_ptr;
+	unsigned int datalen, dataoff;
+
+
+	//struct tcphdr *tcph =3D (void *)iph + iph->ihl * 4;
+	//unsigned int tcplen =3D len - iph->ihl * 4;
+	//unsigned int datalen =3D tcplen - tcph->doff * 4;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_mms_expect _emmi, *exp_mms_info =3D &_emmi;
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
+	th =3D skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				sizeof(_tcph), &_tcph);
+	if (!th)
+		return NF_ACCEPT;
+
+	/* No data ? */
+	dataoff =3D (*pskb)->nh.iph->ihl*4 + th->doff*4;
+	datalen =3D (*pskb)->len - dataoff;
+	if (dataoff >=3D (*pskb)->len)
+		return NF_ACCEPT;
+
+	spin_lock_bh(&mms_buffer_lock);
+	mb_ptr =3D skb_header_pointer(*pskb, dataoff,
+				    (*pskb)->len - dataoff, mms_buffer);
+	BUG_ON(mb_ptr =3D=3D NULL);
+
+	data =3D mb_ptr;
+
+#if 0
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+	    csum_partial((char *)tcph, tcplen, 0))) {
+		DEBUGP("mms_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
+		       tcph, tcplen, NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
+#endif
+=09
+	/* Only look at packets with 0x00030002/196610 on bytes 36->39 of TCP
+	 * payload */
+
+	/* FIXME: There is an issue with only looking at this packet: before
+	 * this packet, the client has already sent a packet to the server with
+	 * the server's hostname according to the client (think of it as the
+	 * "Host: " header in HTTP/1.1). The server will break the connection
+	 * if this doesn't correspond to its own host header. The client can
+	 * also connect to an IP address; if it's the server's IP address, it
+	 * will not break the connection. When doing DNAT on a connection where
+	 * the client uses a server's IP address, the nat module should detect
+	 * this and change this string accordingly to the DNATed address. This
+	 * should probably be done by checking for an IP address, then storing
+	 * it as a member of struct ip_ct_mms_expect and checking for it in
+	 * ip_nat_mms...
+	 */
+	if ((MMS_SRV_MSG_OFFSET < datalen) &&=20
+	    ((*(u32 *)(data+MMS_SRV_MSG_OFFSET)) =3D=3D MMS_SRV_MSG_ID)) {
+		DEBUGP("ip_conntrack_mms: offset 37: %u %u %u %u, datalen:%u\n",=20
+		       (u8)*(data+36), (u8)*(data+37),=20
+		       (u8)*(data+38), (u8)*(data+39),
+		       datalen);
+		if (parse_mms(data, datalen, &mms_ip, &mms_proto, &mms_port,
+		             &mms_string_b, &mms_string_e, &mms_padding_e))
+			if (net_ratelimit())
+				/* FIXME: more verbose debugging ? */
+				printk(KERN_WARNING
+				       "ip_conntrack_mms: Unable to parse "
+				       "data payload\n");
+
+		sprintf(mms_proto_string, "(%u)", mms_proto);
+		DEBUGP("ip_conntrack_mms: adding %s expectation "
+		       "%u.%u.%u.%u -> %u.%u.%u.%u:%u\n",
+		       mms_proto =3D=3D IPPROTO_TCP ? "TCP"
+		       : mms_proto =3D=3D IPPROTO_UDP ? "UDP":mms_proto_string,
+		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
+		       NIPQUAD(mms_ip),
+		       mms_port);
+	=09
+		/* it's possible that the client will just ask the server to
+		 * tunnel the stream over the same TCP session (from port
+		 * 1755): there's shouldn't be a need to add an expectation in
+		 * that case, but it makes NAT packet mangling so much easier
+		 * */
+
+		DEBUGP("ip_conntrack_mms: tcph->seq =3D %u\n", tcph->seq);
+
+		exp =3D ip_conntrack_expect_alloc();
+		if (!exp) {
+			ret =3D NF_DROP;
+			goto out;
+		}
+	=09
+		exp_mms_info->offset  =3D (mms_string_b - data);
+		exp_mms_info->len     =3D (mms_string_e  - mms_string_b);
+		exp_mms_info->padding =3D (mms_padding_e - mms_string_e);
+		exp_mms_info->port    =3D mms_port;
+	=09
+		DEBUGP("ip_conntrack_mms: wrote info seq=3D%u (ofs=3D%u), "
+		       "len=3D%d, padding=3D%u\n", exp->seq, (mms_string_e - data),
+		       exp_mms_info->len, exp_mms_info->padding);
+	=09
+		exp->tuple =3D ((struct ip_conntrack_tuple)
+		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+		              { mms_ip,
+		                { .tcp =3D { (__u16) ntohs(mms_port) } },
+		                mms_proto } }
+		             );
+		exp->mask  =3D ((struct ip_conntrack_tuple)
+		             { { 0xFFFFFFFF, { 0 } },
+		               { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFF }});
+		exp->expectfn =3D NULL;
+		exp->master =3D ct;
+
+		if (ip_nat_mms_hook)
+			ret =3D ip_nat_mms_hook(pskb, ctinfo, exp_mms_info, exp);
+		else if (ip_conntrack_expect_related(exp) !=3D 0) {
+			ip_conntrack_expect_free(exp);
+			ret =3D NF_DROP;
+		}
+		goto out;
+	}
+out:
+	spin_unlock_bh(&mms_buffer_lock);
+	return ret;
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
+		mms[i].mask.dst.protonum =3D 0xFF;
+		mms[i].max_expected =3D 1;
+		mms[i].timeout =3D 120;
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
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/ip_nat_mms.c pom-ng-edit/patchlets/mms-conntrack-na=
t/linux-2.6.12/net/ipv4/netfilter/ip_nat_mms.c
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
ip_nat_mms.c	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/ip_nat_mms.c	2005-07-22 10:33:48.000000000 +0200
@@ -0,0 +1,195 @@
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
+ *
+ *  2005-02-13: Harald Welte <laforge@netfilter.org>
+ *  	- port to 2.6.x
+ *  	- update to work with post 2.6.11 helper API changes
+
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
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) NAT module");
+MODULE_LICENSE("GPL");
+
+static unsigned int mms_data_fixup(struct sk_buff **pskb,
+                          enum ip_conntrack_info ctinfo,
+			  const struct ip_ct_mms_expect *ct_mms_info,
+                          struct ip_conntrack_expect *expect)
+{
+	u_int32_t newip;
+	struct ip_conntrack *ct =3D expect->master;
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
+	char buffer[28];         /* "\\255.255.255.255\UDP\65635" * 2=20
+				    (for unicode) */
+	char unicode_buffer[75]; /* 27*2 (unicode) + 20 + 1 */
+	char proto_string[6];
+
+	/* what was the protocol again ? */
+	mms_proto =3D expect->tuple.dst.protonum;
+	sprintf(proto_string, "%u", mms_proto);
+=09
+	DEBUGP("ip_nat_mms: mms_data_fixup: info (seq %u + %u) "
+	       "in %u, proto %s\n",
+	       expect->seq, ct_mms_info->len, ntohl(tcph->seq),
+	       mms_proto =3D=3D IPPROTO_UDP ? "UDP"
+	       : mms_proto =3D=3D IPPROTO_TCP ? "TCP":proto_string);
+=09
+	newip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+	expect->saved_proto.tcp.port =3D expect->tuple.dst.u.tcp.port;
+	expect->expectfn =3D ip_nat_follow_master;
+
+	/* Alter conntrack's expectations. */
+	for (port =3D ct_mms_info->port; port !=3D 0; port++) {
+		expect->tuple.dst.u.tcp.port =3D htons(port);
+		if (ip_conntrack_expect_related(expect) =3D=3D 0) {
+			DEBUGP("ip_nat_mms: mms_data_fixup: using port %d\n",
+				port);=20
+			break;
+		}
+	}
+=09
+	if (port =3D=3D 0) {
+		ip_conntrack_expect_free(expect);
+		return NF_DROP;
+	}
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
+	DEBUGP("ip_nat_mms: mms_data_fixup: padding: %u len: %u\n",=20
+		ct_mms_info->padding, ct_mms_info->len);
+	DEBUGP("ip_nat_mms: mms_data_fixup: offset: %u\n",=20
+		MMS_SRV_UNICODE_STRING_OFFSET+ct_mms_info->len);
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
+	DEBUGP("ip_nat_mms: mms_data_fixup: zero_padding =3D %u\n", zero_padding);
+	DEBUGP("ip_nat_mms: original=3D> chunkLenLV=3D%u chunkLenLM=3D%u "
+	       "messageLength=3D%u\n", *mms_chunkLenLV, *mms_chunkLenLM,
+	       *mms_messageLength);
+=09
+	/* explanation, before I forget what I did:
+	   strlen(buffer)*2 + ct_mms_info->padding + 4 must be divisable by 8;
+	   divide by 8 and add 3 to compute the mms_chunkLenLM field,
+	   but note that things may have to be padded with zeroes to align by 8=
=20
+	   bytes, hence we add 7 and divide by 8 to get the correct length */=20
+	*mms_chunkLenLM    =3D (u_int32_t) (3+(strlen(buffer)*2+ct_mms_info->padd=
ing+11)/8);
+	*mms_chunkLenLV    =3D *mms_chunkLenLM+2;
+	*mms_messageLength =3D *mms_chunkLenLV*8;
+=09
+	DEBUGP("ip_nat_mms: modified=3D> chunkLenLV=3D%u chunkLenLM=3D%u"
+	       " messageLength=3D%u\n", *mms_chunkLenLV, *mms_chunkLenLM,
+	       *mms_messageLength);
+=09
+	ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,=20
+	                         ct_mms_info->offset,
+	                         ct_mms_info->len + ct_mms_info->padding,
+				 unicode_buffer, strlen(buffer)*2 +
+				 ct_mms_info->padding + zero_padding);
+	DUMP_BYTES(unicode_buffer, 60);
+=09
+	return NF_ACCEPT;
+}
+
+static void __exit fini(void)
+{
+	ip_nat_mms_hook =3D NULL;
+	synchronize_net();
+}
+
+static int __init init(void)
+{
+	BUG_ON(ip_nat_mms_hook);
+	ip_nat_mms_hook =3D &mms_data_fixup;
+
+	return 0;
+}
+
+module_init(init);
+module_exit(fini);
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/Kconfig.ladd pom-ng-edit/patchlets/mms-conntrack-na=
t/linux-2.6.12/net/ipv4/netfilter/Kconfig.ladd
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/Kconfig.ladd	2005-07-03 22:40:06.000000000 +0200
@@ -0,0 +1,17 @@
+config IP_NF_NAT_MMS
+	tristate
+	depends on IP_NF_CONNTRACK!=3Dn && IP_NF_NAT!=3Dn
+	default IP_NF_NAT if IP_NF_MMS=3Dy
+	default m if IP_NF_MMS=3Dm
+
+config IP_NF_MMS
+	tristate  'MMS protocol support'
+	depends on IP_NF_CONNTRACK
+	help
+	  Tracking MMS (Microsoft Windows Media Services) connections
+	  could be problematic if random ports are used to send the
+	  streaming content. This option allows users to track streaming
+	  connections over random UDP or TCP ports.
+=09
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/Makefile.ladd pom-ng-edit/patchlets/mms-conntrack-n=
at/linux-2.6.12/net/ipv4/netfilter/Makefile.ladd
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/Makefile.ladd	2005-07-03 22:40:06.000000000 +0200
@@ -0,0 +1,2 @@
+# NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_MMS) +=3D ip_nat_mms.o
diff -Nrup --exclude=3D.svn pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.=
6.12/net/ipv4/netfilter/Makefile.ladd_2 pom-ng-edit/patchlets/mms-conntrack=
-nat/linux-2.6.12/net/ipv4/netfilter/Makefile.ladd_2
--- pom-ng-svn/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter/=
Makefile.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ pom-ng-edit/patchlets/mms-conntrack-nat/linux-2.6.12/net/ipv4/netfilter=
/Makefile.ladd_2	2005-07-03 22:40:06.000000000 +0200
@@ -0,0 +1,2 @@
+# connection tracking helpers
+obj-$(CONFIG_IP_NF_MMS) +=3D ip_conntrack_mms.o

--KsGdsel6WgEHnImy--

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC5okuo4FAdB2PneQRAvFUAJ0VT5x5BnM1rPP8S3kbDBXPgOR6nwCbBGae
6alr6JkMgLsBQQGyuc5TYLA=
=KmM/
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
