From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: RE: [PATCH] Quake III Arena conntracker
Date: 05 Oct 2002 22:55:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1033851302.577.29.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ulsRxp/rGdQHzRNaWpSy"
Cc: Brad Chapman <kakadu_croc@yahoo.com>
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


--=-ulsRxp/rGdQHzRNaWpSy
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This patch (against netfilter CVS and against 2.4.20-pre8) adds a
conntrack/NAT helper for Quake3 Arena Master server connections.

Brad Chapman showed some interest and has been running a version with 
NAT support for at least a month now (see mail below).

Feel free to include it in p-o-m.

Brad, thanks for sparking my interest in this again, and for
volunteering to test it out on your network.

Regards,
Filip


From: Brad Chapman <kakadu_croc@yahoo.com>
To: Filip Sneppe (Cronos) <filip.sneppe@cronos.be>
Subject: RE: [PATCH] Quake III Arena conntracker
Date: 29 Sep 2002 16:42:18 -0700

Mr. Filip,

--- "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be> wrote:
> On Mon, 2002-08-26 at 21:21, Brad Chapman wrote:
> > 
> > It does. ATM the only thing tested is the Quake3 helper, and not with a fully
> closed
> > rulset (I'm allowing 27950 and 27960 in TCP/UDP already). However, so far
> nothing
> > seems to be crashing or Oopsing. 
> 
> Hi Brad,
> 
> Have you had any issues with the quake3 conntrack/nat patch I sent you ?
> If not, I guess it wouldn't harm to have it in patch-o-matic so more
> people can test it.

No. I've had no issues whatsoever. The patch works great and even appears to work
for Quake2 traffic as well. It belongs in p-o-m; maybe once it's put there I'll try
it to see if it acts any differently.

> 
> Thanks for your testing,
> Filip
> 
> 

Brad


=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com


--=-ulsRxp/rGdQHzRNaWpSy
Content-Disposition: attachment; filename=diff.quake3.2.4.20-pre8.20021005-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.quake3.2.4.20-pre8.20021005-1;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-pre8/Documentation/Configure.help linux-=
2.4.20-pre8-quake3/Documentation/Configure.help
--- linux-2.4.20-pre8/Documentation/Configure.help	2002-10-01 21:11:33.0000=
00000 +0200
+++ linux-2.4.20-pre8-quake3/Documentation/Configure.help	2002-10-01 21:32:=
15.000000000 +0200
@@ -2499,6 +2499,16 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
+Quake III Arena protocol support
+CONFIG_IP_NF_QUAKE3
+  Quake III Arena  connection tracking helper. This module allows for a
+  stricter firewall rulebase if one only allows traffic to a master
+  server. Connections to Quake III server IP addresses and ports returned
+  by the master server will be tracked automatically.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `Y'.
+
 User space queueing via NETLINK
 CONFIG_IP_NF_QUEUE
   Netfilter has the ability to queue packets to user space: the
diff -urN -X dontdiff linux-2.4.20-pre8/include/linux/netfilter_ipv4/ip_con=
ntrack_quake3.h linux-2.4.20-pre8-quake3/include/linux/netfilter_ipv4/ip_co=
nntrack_quake3.h
--- linux-2.4.20-pre8/include/linux/netfilter_ipv4/ip_conntrack_quake3.h	19=
70-01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-pre8-quake3/include/linux/netfilter_ipv4/ip_conntrack_quak=
e3.h	2002-10-01 21:32:15.000000000 +0200
@@ -0,0 +1,21 @@
+#ifndef _IP_CT_QUAKE3
+#define _IP_CT_QUAKE3
+
+/* Don't confuse with 27960, often used as the Server Port */
+#define QUAKE3_MASTER_PORT 27950
+
+struct quake3_search {
+	const char marker[4]; /* always 0xff 0xff 0xff 0xff ? */
+	const char *pattern;
+	size_t plen;
+};=20
+
+/* This structure is per expected connection */
+struct ip_ct_quake3_expect {
+};
+
+/* This structure exists only once per master */
+struct ip_ct_quake3_master {
+};
+
+#endif /* _IP_CT_QUAKE3 */
diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/Config.in linux-=
2.4.20-pre8-quake3/net/ipv4/netfilter/Config.in
--- linux-2.4.20-pre8/net/ipv4/netfilter/Config.in	2002-10-01 21:12:32.0000=
00000 +0200
+++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/Config.in	2002-10-01 21:32:=
15.000000000 +0200
@@ -8,6 +8,7 @@
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  Quake III protocol support' CONFIG_IP_NF_QUAKE3 $CONFIG_=
IP_NF_CONNTRACK
 fi
=20
 if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
@@ -60,6 +61,13 @@
       if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
         dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)' CONFIG_IP=
_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
       fi
+      if [ "$CONFIG_IP_NF_QUAKE3" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_QUAKE3 m=20
+      else
+        if [ "$CONFIG_IP_NF_QUAKE3" =3D "y" ]; then
+	  define_tristate CONFIG_IP_NF_NAT_QUAKE3 $CONFIG_IP_NF_NAT
+	fi
+      fi
       if [ "$CONFIG_IP_NF_IRC" =3D "m" ]; then
         define_tristate CONFIG_IP_NF_NAT_IRC m
       else
diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/Makefile linux-2=
.4.20-pre8-quake3/net/ipv4/netfilter/Makefile
--- linux-2.4.20-pre8/net/ipv4/netfilter/Makefile	2002-10-01 21:12:32.00000=
0000 +0200
+++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/Makefile	2002-10-01 21:32:1=
5.000000000 +0200
@@ -42,9 +42,15 @@
 	export-objs +=3D ip_conntrack_irc.o
 endif
=20
+obj-$(CONFIG_IP_NF_QUAKE3) +=3D ip_conntrack_quake3.o
+ifdef CONFIG_IP_NF_NAT_QUAKE3
+	export-objs +=3D ip_conntrack_quake3.o
+endif
+
 # NAT helpers=20
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_QUAKE3) +=3D ip_nat_quake3.o
=20
 # generic IP tables=20
 obj-$(CONFIG_IP_NF_IPTABLES) +=3D ip_tables.o
diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_qua=
ke3.c linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_conntrack_quake3.c
--- linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_quake3.c	1970-01-01 0=
1:00:00.000000000 +0100
+++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_conntrack_quake3.c	2002-=
10-01 21:32:15.000000000 +0200
@@ -0,0 +1,156 @@
+/* Quake3 extension for IP connection tracking
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_conntrack_ftp.c and ip_conntrack_tftp.c
+ *
+ * ip_conntrack_quake3.c v0.04 2002-08-31
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_conntrack_quake3.o ports=3Dport1,port2,...port<MAX_PORTS=
>
+ *
+ *      please give the ports of all Quake3 master servers You wish to=20
+ *      connect to. If you don't specify ports, the default will be UDP=20
+ *      port 27950.
+ *
+ *      Thanks to the Ethereal folks for their analysis of the Quake3 prot=
ocol.
+ */
+
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_quake3.h>
+
+struct module *ip_conntrack_quake3 =3D THIS_MODULE;
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Netfilter connection tracking module for Quake III Are=
na");
+MODULE_LICENSE("GPL");
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Quake III master servers");
+#endif
+
+/* Quake3 master server reply will add > 100 expectations per reply packet=
; when
+   doing lots of printk's, klogd may not be able to read /proc/kmsg fast e=
nough */
+#if 0=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+struct quake3_search quake3s_conntrack =3D { "****", "getserversResponse",=
 sizeof("getserversResponse") - 1 };
+
+static int quake3_help(const struct iphdr *iph, size_t len,
+	struct ip_conntrack *ct,
+	enum ip_conntrack_info ctinfo)
+{
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect exp;
+	int i;
+=09
+        /* Until there's been traffic both ways, don't look in packets. no=
te: it's UDP ! */
+	if (ctinfo !=3D IP_CT_ESTABLISHED
+	    && ctinfo !=3D IP_CT_IS_REPLY) {
+	        DEBUGP("ip_conntrack_quake3: not ok ! Conntrackinfo =3D %u\n", ct=
info);
+	        return NF_ACCEPT;
+	} else { DEBUGP("ip_conntrack_quake3: it's ok ! Conntrackinfo =3D %u\n", =
ctinfo); }
+=09
+	if (strnicmp((const char *)udph + 12, quake3s_conntrack.pattern, quake3s_=
conntrack.plen) =3D=3D 0) {
+		for(i=3D31;    /* 8 bytes UDP hdr, 4 bytes filler, 18 bytes "getserversR=
esponse", 1 byte "\" */
+		    i+6 < ntohs(udph->len);
+		    i+=3D7) {
+			DEBUGP("ip_conntrack_quake3: adding server at offset %u/%u %u.%u.%u.%u:=
%u\n",
+			       i, ntohs(udph->len),
+			       NIPQUAD( (u_int32_t) *( (u_int32_t *)( (int)udph + i ) ) ),=20
+			       ntohs((__u16) *( (__u16 *)( (int)udph + i + 4 ) ) ) );
+
+			memset(&exp, 0, sizeof(exp));
+
+			exp.tuple =3D ((struct ip_conntrack_tuple)
+			             { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+			               { (u_int32_t) *((u_int32_t *)((int)udph + i)),=20
+			               { (__u16) *((__u16 *)((int)udph+i+4)) },=20
+			                 IPPROTO_UDP } }
+			            );
+			exp.mask  =3D ((struct ip_conntrack_tuple)
+			             { { 0xFFFFFFFF, { 0 } },
+		                       { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+			exp.expectfn =3D NULL;
+
+			ip_conntrack_expect_related(ct, &exp);
+		}
+
+	}
+=09
+	return(NF_ACCEPT);
+}
+
+static struct ip_conntrack_helper quake3[MAX_PORTS];
+static char quake3_names[MAX_PORTS][13];  /* quake3-65535 */
+
+static void fini(void)
+{
+	int i;
+
+	for(i =3D 0 ; (i < ports_c); i++) {
+		DEBUGP("ip_conntrack_quake3: unregistering helper for port %d\n",
+					ports[i]);
+		ip_conntrack_helper_unregister(&quake3[i]);
+	}=20
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if(!ports[0])
+		ports[0]=3DQUAKE3_MASTER_PORT;
+
+	for(i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+		/* Create helper structure */
+		memset(&quake3[i], 0, sizeof(struct ip_conntrack_helper));
+
+		quake3[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		quake3[i].tuple.src.u.udp.port =3D htons(ports[i]);
+		quake3[i].mask.dst.protonum =3D 0xFFFF;
+		quake3[i].mask.src.u.udp.port =3D 0xFFFF;
+		quake3[i].help =3D quake3_help;
+		quake3[i].me =3D THIS_MODULE;
+
+		tmpname =3D &quake3_names[i][0];
+		if (ports[i] =3D=3D QUAKE3_MASTER_PORT)
+			sprintf(tmpname, "quake3");
+		else
+			sprintf(tmpname, "quake3-%d", i);
+		quake3[i].name =3D tmpname;
+	=09
+		DEBUGP("ip_conntrack_quake3: registering helper for port %d\n",
+		       ports[i]);
+
+		ret=3Dip_conntrack_helper_register(&quake3[i]);
+		if(ret) {
+			fini();
+			return(ret);
+		}
+		ports_c++;
+	}
+
+	return(0);
+}
+
+module_init(init);
+module_exit(fini);
diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/ip_nat_quake3.c =
linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_nat_quake3.c
--- linux-2.4.20-pre8/net/ipv4/netfilter/ip_nat_quake3.c	1970-01-01 01:00:0=
0.000000000 +0100
+++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_nat_quake3.c	2002-10-01 =
21:32:15.000000000 +0200
@@ -0,0 +1,249 @@
+/* Quake3 extension for UDP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_nat_ftp.c and ip_nat_tftp.c
+ *
+ * ip_nat_quake3.c v0.0.3 2002-08-31
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_nat_quake3.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      please give the ports of all Quake3 master servers You wish to
+ *      connect to. If you don't specify ports, the default will be UDP
+ *      port 27950.
+ *
+ *      Thanks to the Ethereal folks for their analysis of the Quake3 prot=
ocol.
+ *
+ *      Notes:=20
+ *      - If you're one of those people who would try anything to lower
+ *        latency while playing Quake (and who isn't :-) ), you may want t=
o
+ *        consider not loading ip_nat_quake3 at all and just MASQUERADE al=
l
+ *        outgoing UDP traffic.
+ *        This will make ip_conntrack_quake3 add the necessary expectation=
s,
+ *        but there will be no overhead for client->server UDP streams. If
+ *        ip_nat_quake3 is loaded, quake3_nat_expected will be called per =
NAT
+ *        hook for every packet in the client->server UDP stream.
+ *      - Only SNAT/MASQUEARDE targets are useful for ip_nat_quake3.
+ *        The IP addresses in the master connection payload (=3DIP address=
es
+ *        of Quake servers) have no relation with the master server so
+ *        DNAT'ing the master connection to a server should not change the
+ *        expected connections.
+ *      - Not tested due to lack of equipment:
+ *        - multiple Quake3 clients behind one MASQUERADE gateway
+ *        - what if Quake3 client is running on router too
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
+#include <linux/netfilter_ipv4/ip_conntrack_quake3.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Netfilter NAT helper for Quake III Arena");
+MODULE_LICENSE("GPL");
+
+#define MAX_PORTS 8
+
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of Quake III master servers");
+#endif
+
+/* Quake3 master server reply will add > 100 expectations per reply packet=
; when
+   doing lots of printk's, klogd may not be able to read /proc/kmsg fast e=
nough */
+#if 0=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static struct quake3_search quake3s_nat =3D { "****", "getserversResponse"=
, sizeof("getserversResponse") - 1 };
+
+static unsigned int=20
+quake3_nat_help(struct ip_conntrack *ct,
+                struct ip_conntrack_expect *exp,
+                struct ip_nat_info *info,
+                enum ip_conntrack_info ctinfo,
+                unsigned int hooknum,
+                struct sk_buff **pskb)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	struct ip_conntrack_tuple repl;
+	int dir =3D CTINFO2DIR(ctinfo);
+	int i;
+=09
+	DEBUGP("ip_nat_quake3: quake3_nat_help, direction: %s hook: %s\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???"
+	      );
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+=09
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL=
)
+	    || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)))=
 {
+		DEBUGP("ip_nat_quake3: Not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????");
+		return NF_ACCEPT;
+	}
+
+	if (!exp) {
+		DEBUGP("no conntrack expectation to modify\n");
+		return NF_ACCEPT;
+	}
+
+	if (strnicmp((const char *)udph + 12, quake3s_nat.pattern, quake3s_nat.pl=
en) =3D=3D 0) {
+		for(i=3D31; /* 8 bytes UDP hdr, 4 bytes filler, 18 bytes "getserversResp=
onse", 1 byte "\" */
+		    i+6 < ntohs(udph->len);
+		    i+=3D7) {
+			DEBUGP("ip_nat_quake3: adding server at offset %u/%u %u.%u.%u.%u:%u\n",=
=20
+			       i, ntohs(udph->len),
+			       NIPQUAD( (u_int32_t) *( (u_int32_t *)( (int)udph + i ) ) ),
+			       ntohs((__u16) *( (__u16 *)( (int)udph + i + 4 ) ) ) );
+		=09
+			memset(&repl, 0, sizeof(repl));
+
+			repl.dst.protonum =3D IPPROTO_UDP;
+			repl.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+			repl.dst.ip =3D *( (u_int32_t *)( (int)udph + i ) );
+			repl.dst.u.udp.port =3D (__u16) *( (__u16 *)( (int)udph + i + 4 )  );
+		=09
+			ip_conntrack_change_expect(exp, &repl);
+		}
+	}
+	return NF_ACCEPT;
+}
+
+static unsigned int=20
+quake3_nat_expected(struct sk_buff **pskb,
+                    unsigned int hooknum,
+                    struct ip_conntrack *ct,=20
+                    struct ip_nat_info *info)=20
+{
+	const struct ip_conntrack *master =3D ct->master->expectant;
+	struct ip_nat_multi_range mr;
+	u_int32_t newsrcip, newdstip, newip;
+#if 0=20
+	const struct ip_conntrack_tuple *repl =3D
+		&master->tuplehash[IP_CT_DIR_REPLY].tuple;
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl*4;
+#endif
+
+	DEBUGP("ip_nat_quake3: quake3_nat_expected: here we are\n");
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+=09
+	newdstip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	newsrcip =3D master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+=09
+	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC) {
+		newip =3D newsrcip;
+		DEBUGP("hook: %s orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
+		       "newsrc: %u.%u.%u.%u\n",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????",
+		       NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->source),
+		       NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
+		       NIPQUAD(newip));
+	=09
+	} else {
+		newip =3D newdstip;
+		DEBUGP("hook: %s orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
+		       "newdst: %u.%u.%u.%u\n",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????",
+		       NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->source),
+		       NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
+		       NIPQUAD(newip));
+	}
+=09
+	mr.rangesize =3D 1;
+	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
+	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;=20
+
+	return ip_nat_setup_info(ct,&mr,hooknum);
+}
+
+static struct ip_nat_helper quake3[MAX_PORTS];
+static char quake3_names[MAX_PORTS][13];  /* quake3-65535 */
+
+static void fini(void)
+{
+	int i;
+=09
+	for (i =3D 0 ; i < ports_c; i++) {
+		DEBUGP("ip_nat_quake3: unregistering helper for port %d\n", ports[i]);
+		       ip_nat_helper_unregister(&quake3[i]);
+	}
+}
+
+static int __init init(void)
+	{
+		int i, ret =3D 0;
+		char *tmpname;
+
+		if (!ports[0])
+			ports[0] =3D QUAKE3_MASTER_PORT;
+	=09
+		for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+			memset(&quake3[i], 0, sizeof(struct ip_nat_helper));
+
+			quake3[i].tuple.dst.protonum =3D IPPROTO_UDP;
+			quake3[i].tuple.src.u.udp.port =3D htons(ports[i]);
+			quake3[i].mask.dst.protonum =3D 0xFFFF;
+			quake3[i].mask.src.u.udp.port =3D 0xFFFF;
+			quake3[i].help =3D quake3_nat_help;
+			quake3[i].flags =3D 0;
+			quake3[i].me =3D THIS_MODULE;
+			quake3[i].expect =3D quake3_nat_expected;
+		=09
+			tmpname =3D &quake3_names[i][0];
+			if (ports[i] =3D=3D QUAKE3_MASTER_PORT)
+				sprintf(tmpname, "quake3");
+			else
+				sprintf(tmpname, "quake3-%d", i);
+			quake3[i].name =3D tmpname;
+		=09
+			DEBUGP("ip_nat_quake3: registering helper for port %d: name %s\n",
+			       ports[i], quake3[i].name);
+			ret =3D ip_nat_helper_register(&quake3[i]);
+		=09
+			if (ret) {
+				printk("ip_nat_quake3: unable to register helper for port %d\n",
+				       ports[i]);
+				fini();
+				return ret;
+			}
+			ports_c++;
+		}
+		return ret;
+	}
+=09
+module_init(init);
+module_exit(fini);

--=-ulsRxp/rGdQHzRNaWpSy
Content-Disposition: attachment; filename=diff.quake3.patch-o-matic.20021005-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.quake3.patch-o-matic.20021005-1;
	charset=ANSI_X3.4-1968

diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch netfilt=
er/patch-o-matic/extra/quake3-conntrack.patch
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch	1970-01-01 01=
:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch	2002-10-05 22:19:2=
7.000000000 +0200
@@ -0,0 +1,438 @@
+diff -urN -X dontdiff linux-2.4.20-pre8/include/linux/netfilter_ipv4/ip_co=
nntrack_quake3.h linux-2.4.20-pre8-quake3/include/linux/netfilter_ipv4/ip_c=
onntrack_quake3.h
+--- linux-2.4.20-pre8/include/linux/netfilter_ipv4/ip_conntrack_quake3.h	1=
970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20-pre8-quake3/include/linux/netfilter_ipv4/ip_conntrack_qua=
ke3.h	2002-10-01 21:32:15.000000000 +0200
+@@ -0,0 +1,21 @@
++#ifndef _IP_CT_QUAKE3
++#define _IP_CT_QUAKE3
++
++/* Don't confuse with 27960, often used as the Server Port */
++#define QUAKE3_MASTER_PORT 27950
++
++struct quake3_search {
++	const char marker[4]; /* always 0xff 0xff 0xff 0xff ? */
++	const char *pattern;
++	size_t plen;
++};=20
++
++/* This structure is per expected connection */
++struct ip_ct_quake3_expect {
++};
++
++/* This structure exists only once per master */
++struct ip_ct_quake3_master {
++};
++
++#endif /* _IP_CT_QUAKE3 */
+diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_qu=
ake3.c linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_conntrack_quake3.c
+--- linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_quake3.c	1970-01-01 =
01:00:00.000000000 +0100
++++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_conntrack_quake3.c	2002=
-10-01 21:32:15.000000000 +0200
+@@ -0,0 +1,156 @@
++/* Quake3 extension for IP connection tracking
++ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
++ * based on ip_conntrack_ftp.c and ip_conntrack_tftp.c
++ *
++ * ip_conntrack_quake3.c v0.04 2002-08-31
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *      Module load syntax:
++ *      insmod ip_conntrack_quake3.o ports=3Dport1,port2,...port<MAX_PORT=
S>
++ *
++ *      please give the ports of all Quake3 master servers You wish to=20
++ *      connect to. If you don't specify ports, the default will be UDP=20
++ *      port 27950.
++ *
++ *      Thanks to the Ethereal folks for their analysis of the Quake3 pro=
tocol.
++ */
++
++#include <linux/module.h>
++#include <linux/ip.h>
++#include <linux/udp.h>
++
++#include <linux/netfilter.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_quake3.h>
++
++struct module *ip_conntrack_quake3 =3D THIS_MODULE;
++
++MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
++MODULE_DESCRIPTION("Netfilter connection tracking module for Quake III Ar=
ena");
++MODULE_LICENSE("GPL");
++
++#define MAX_PORTS 8
++static int ports[MAX_PORTS];
++static int ports_c =3D 0;
++#ifdef MODULE_PARM
++MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
++MODULE_PARM_DESC(ports, "port numbers of Quake III master servers");
++#endif
++
++/* Quake3 master server reply will add > 100 expectations per reply packe=
t; when
++   doing lots of printk's, klogd may not be able to read /proc/kmsg fast =
enough */
++#if 0=20
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++struct quake3_search quake3s_conntrack =3D { "****", "getserversResponse"=
, sizeof("getserversResponse") - 1 };
++
++static int quake3_help(const struct iphdr *iph, size_t len,
++	struct ip_conntrack *ct,
++	enum ip_conntrack_info ctinfo)
++{
++	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
++	int dir =3D CTINFO2DIR(ctinfo);
++	struct ip_conntrack_expect exp;
++	int i;
++=09
++        /* Until there's been traffic both ways, don't look in packets. n=
ote: it's UDP ! */
++	if (ctinfo !=3D IP_CT_ESTABLISHED
++	    && ctinfo !=3D IP_CT_IS_REPLY) {
++	        DEBUGP("ip_conntrack_quake3: not ok ! Conntrackinfo =3D %u\n", c=
tinfo);
++	        return NF_ACCEPT;
++	} else { DEBUGP("ip_conntrack_quake3: it's ok ! Conntrackinfo =3D %u\n",=
 ctinfo); }
++=09
++	if (strnicmp((const char *)udph + 12, quake3s_conntrack.pattern, quake3s=
_conntrack.plen) =3D=3D 0) {
++		for(i=3D31;    /* 8 bytes UDP hdr, 4 bytes filler, 18 bytes "getservers=
Response", 1 byte "\" */
++		    i+6 < ntohs(udph->len);
++		    i+=3D7) {
++			DEBUGP("ip_conntrack_quake3: adding server at offset %u/%u %u.%u.%u.%u=
:%u\n",
++			       i, ntohs(udph->len),
++			       NIPQUAD( (u_int32_t) *( (u_int32_t *)( (int)udph + i ) ) ),=20
++			       ntohs((__u16) *( (__u16 *)( (int)udph + i + 4 ) ) ) );
++
++			memset(&exp, 0, sizeof(exp));
++
++			exp.tuple =3D ((struct ip_conntrack_tuple)
++			             { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
++			               { (u_int32_t) *((u_int32_t *)((int)udph + i)),=20
++			               { (__u16) *((__u16 *)((int)udph+i+4)) },=20
++			                 IPPROTO_UDP } }
++			            );
++			exp.mask  =3D ((struct ip_conntrack_tuple)
++			             { { 0xFFFFFFFF, { 0 } },
++		                       { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
++			exp.expectfn =3D NULL;
++
++			ip_conntrack_expect_related(ct, &exp);
++		}
++
++	}
++=09
++	return(NF_ACCEPT);
++}
++
++static struct ip_conntrack_helper quake3[MAX_PORTS];
++static char quake3_names[MAX_PORTS][13];  /* quake3-65535 */
++
++static void fini(void)
++{
++	int i;
++
++	for(i =3D 0 ; (i < ports_c); i++) {
++		DEBUGP("ip_conntrack_quake3: unregistering helper for port %d\n",
++					ports[i]);
++		ip_conntrack_helper_unregister(&quake3[i]);
++	}=20
++}
++
++static int __init init(void)
++{
++	int i, ret;
++	char *tmpname;
++
++	if(!ports[0])
++		ports[0]=3DQUAKE3_MASTER_PORT;
++
++	for(i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
++		/* Create helper structure */
++		memset(&quake3[i], 0, sizeof(struct ip_conntrack_helper));
++
++		quake3[i].tuple.dst.protonum =3D IPPROTO_UDP;
++		quake3[i].tuple.src.u.udp.port =3D htons(ports[i]);
++		quake3[i].mask.dst.protonum =3D 0xFFFF;
++		quake3[i].mask.src.u.udp.port =3D 0xFFFF;
++		quake3[i].help =3D quake3_help;
++		quake3[i].me =3D THIS_MODULE;
++
++		tmpname =3D &quake3_names[i][0];
++		if (ports[i] =3D=3D QUAKE3_MASTER_PORT)
++			sprintf(tmpname, "quake3");
++		else
++			sprintf(tmpname, "quake3-%d", i);
++		quake3[i].name =3D tmpname;
++	=09
++		DEBUGP("ip_conntrack_quake3: registering helper for port %d\n",
++		       ports[i]);
++
++		ret=3Dip_conntrack_helper_register(&quake3[i]);
++		if(ret) {
++			fini();
++			return(ret);
++		}
++		ports_c++;
++	}
++
++	return(0);
++}
++
++module_init(init);
++module_exit(fini);
+diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/ip_nat_quake3.c=
 linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_nat_quake3.c
+--- linux-2.4.20-pre8/net/ipv4/netfilter/ip_nat_quake3.c	1970-01-01 01:00:=
00.000000000 +0100
++++ linux-2.4.20-pre8-quake3/net/ipv4/netfilter/ip_nat_quake3.c	2002-10-01=
 21:32:15.000000000 +0200
+@@ -0,0 +1,249 @@
++/* Quake3 extension for UDP NAT alteration.
++ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
++ * based on ip_nat_ftp.c and ip_nat_tftp.c
++ *
++ * ip_nat_quake3.c v0.0.3 2002-08-31
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *      Module load syntax:
++ *      insmod ip_nat_quake3.o ports=3Dport1,port2,...port<MAX_PORTS>
++ *
++ *      please give the ports of all Quake3 master servers You wish to
++ *      connect to. If you don't specify ports, the default will be UDP
++ *      port 27950.
++ *
++ *      Thanks to the Ethereal folks for their analysis of the Quake3 pro=
tocol.
++ *
++ *      Notes:=20
++ *      - If you're one of those people who would try anything to lower
++ *        latency while playing Quake (and who isn't :-) ), you may want =
to
++ *        consider not loading ip_nat_quake3 at all and just MASQUERADE a=
ll
++ *        outgoing UDP traffic.
++ *        This will make ip_conntrack_quake3 add the necessary expectatio=
ns,
++ *        but there will be no overhead for client->server UDP streams. I=
f
++ *        ip_nat_quake3 is loaded, quake3_nat_expected will be called per=
 NAT
++ *        hook for every packet in the client->server UDP stream.
++ *      - Only SNAT/MASQUEARDE targets are useful for ip_nat_quake3.
++ *        The IP addresses in the master connection payload (=3DIP addres=
ses
++ *        of Quake servers) have no relation with the master server so
++ *        DNAT'ing the master connection to a server should not change th=
e
++ *        expected connections.
++ *      - Not tested due to lack of equipment:
++ *        - multiple Quake3 clients behind one MASQUERADE gateway
++ *        - what if Quake3 client is running on router too
++ */
++
++#include <linux/module.h>
++#include <linux/netfilter_ipv4.h>
++#include <linux/ip.h>
++#include <linux/udp.h>
++
++#include <linux/netfilter.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_quake3.h>
++#include <linux/netfilter_ipv4/ip_nat_helper.h>
++#include <linux/netfilter_ipv4/ip_nat_rule.h>
++
++MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
++MODULE_DESCRIPTION("Netfilter NAT helper for Quake III Arena");
++MODULE_LICENSE("GPL");
++
++#define MAX_PORTS 8
++
++static int ports[MAX_PORTS];
++static int ports_c =3D 0;
++#ifdef MODULE_PARM
++MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
++MODULE_PARM_DESC(ports, "port numbers of Quake III master servers");
++#endif
++
++/* Quake3 master server reply will add > 100 expectations per reply packe=
t; when
++   doing lots of printk's, klogd may not be able to read /proc/kmsg fast =
enough */
++#if 0=20
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++static struct quake3_search quake3s_nat =3D { "****", "getserversResponse=
", sizeof("getserversResponse") - 1 };
++
++static unsigned int=20
++quake3_nat_help(struct ip_conntrack *ct,
++                struct ip_conntrack_expect *exp,
++                struct ip_nat_info *info,
++                enum ip_conntrack_info ctinfo,
++                unsigned int hooknum,
++                struct sk_buff **pskb)
++{
++	struct iphdr *iph =3D (*pskb)->nh.iph;
++	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
++	struct ip_conntrack_tuple repl;
++	int dir =3D CTINFO2DIR(ctinfo);
++	int i;
++=09
++	DEBUGP("ip_nat_quake3: quake3_nat_help, direction: %s hook: %s\n",
++	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???"
++	      );
++	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
++	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
++=09
++	/* Only mangle things once: original direction in POST_ROUTING
++	   and reply direction on PRE_ROUTING. */
++	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINA=
L)
++	    || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY))=
) {
++		DEBUGP("ip_nat_quake3: Not touching dir %s at hook %s\n",
++		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????");
++		return NF_ACCEPT;
++	}
++
++	if (!exp) {
++		DEBUGP("no conntrack expectation to modify\n");
++		return NF_ACCEPT;
++	}
++
++	if (strnicmp((const char *)udph + 12, quake3s_nat.pattern, quake3s_nat.p=
len) =3D=3D 0) {
++		for(i=3D31; /* 8 bytes UDP hdr, 4 bytes filler, 18 bytes "getserversRes=
ponse", 1 byte "\" */
++		    i+6 < ntohs(udph->len);
++		    i+=3D7) {
++			DEBUGP("ip_nat_quake3: adding server at offset %u/%u %u.%u.%u.%u:%u\n"=
,=20
++			       i, ntohs(udph->len),
++			       NIPQUAD( (u_int32_t) *( (u_int32_t *)( (int)udph + i ) ) ),
++			       ntohs((__u16) *( (__u16 *)( (int)udph + i + 4 ) ) ) );
++		=09
++			memset(&repl, 0, sizeof(repl));
++
++			repl.dst.protonum =3D IPPROTO_UDP;
++			repl.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
++			repl.dst.ip =3D *( (u_int32_t *)( (int)udph + i ) );
++			repl.dst.u.udp.port =3D (__u16) *( (__u16 *)( (int)udph + i + 4 )  );
++		=09
++			ip_conntrack_change_expect(exp, &repl);
++		}
++	}
++	return NF_ACCEPT;
++}
++
++static unsigned int=20
++quake3_nat_expected(struct sk_buff **pskb,
++                    unsigned int hooknum,
++                    struct ip_conntrack *ct,=20
++                    struct ip_nat_info *info)=20
++{
++	const struct ip_conntrack *master =3D ct->master->expectant;
++	struct ip_nat_multi_range mr;
++	u_int32_t newsrcip, newdstip, newip;
++#if 0=20
++	const struct ip_conntrack_tuple *repl =3D
++		&master->tuplehash[IP_CT_DIR_REPLY].tuple;
++	struct iphdr *iph =3D (*pskb)->nh.iph;
++	struct udphdr *udph =3D (void *)iph + iph->ihl*4;
++#endif
++
++	DEBUGP("ip_nat_quake3: quake3_nat_expected: here we are\n");
++	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
++
++	IP_NF_ASSERT(info);
++	IP_NF_ASSERT(master);
++	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
++=09
++	newdstip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
++	newsrcip =3D master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
++=09
++	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC) {
++		newip =3D newsrcip;
++		DEBUGP("hook: %s orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
++		       "newsrc: %u.%u.%u.%u\n",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????",
++		       NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->source),
++		       NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
++		       NIPQUAD(newip));
++	=09
++	} else {
++		newip =3D newdstip;
++		DEBUGP("hook: %s orig: %u.%u.%u.%u:%u <-> %u.%u.%u.%u:%u "
++		       "newdst: %u.%u.%u.%u\n",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????",
++		       NIPQUAD((*pskb)->nh.iph->saddr), ntohs(udph->source),
++		       NIPQUAD((*pskb)->nh.iph->daddr), ntohs(udph->dest),
++		       NIPQUAD(newip));
++	}
++=09
++	mr.rangesize =3D 1;
++	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
++	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;=20
++
++	return ip_nat_setup_info(ct,&mr,hooknum);
++}
++
++static struct ip_nat_helper quake3[MAX_PORTS];
++static char quake3_names[MAX_PORTS][13];  /* quake3-65535 */
++
++static void fini(void)
++{
++	int i;
++=09
++	for (i =3D 0 ; i < ports_c; i++) {
++		DEBUGP("ip_nat_quake3: unregistering helper for port %d\n", ports[i]);
++		       ip_nat_helper_unregister(&quake3[i]);
++	}
++}
++
++static int __init init(void)
++	{
++		int i, ret =3D 0;
++		char *tmpname;
++
++		if (!ports[0])
++			ports[0] =3D QUAKE3_MASTER_PORT;
++	=09
++		for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
++			memset(&quake3[i], 0, sizeof(struct ip_nat_helper));
++
++			quake3[i].tuple.dst.protonum =3D IPPROTO_UDP;
++			quake3[i].tuple.src.u.udp.port =3D htons(ports[i]);
++			quake3[i].mask.dst.protonum =3D 0xFFFF;
++			quake3[i].mask.src.u.udp.port =3D 0xFFFF;
++			quake3[i].help =3D quake3_nat_help;
++			quake3[i].flags =3D 0;
++			quake3[i].me =3D THIS_MODULE;
++			quake3[i].expect =3D quake3_nat_expected;
++		=09
++			tmpname =3D &quake3_names[i][0];
++			if (ports[i] =3D=3D QUAKE3_MASTER_PORT)
++				sprintf(tmpname, "quake3");
++			else
++				sprintf(tmpname, "quake3-%d", i);
++			quake3[i].name =3D tmpname;
++		=09
++			DEBUGP("ip_nat_quake3: registering helper for port %d: name %s\n",
++			       ports[i], quake3[i].name);
++			ret =3D ip_nat_helper_register(&quake3[i]);
++		=09
++			if (ret) {
++				printk("ip_nat_quake3: unable to register helper for port %d\n",
++				       ports[i]);
++				fini();
++				return ret;
++			}
++			ports_c++;
++		}
++		return ret;
++	}
++=09
++module_init(init);
++module_exit(fini);
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.config.=
in netfilter/patch-o-matic/extra/quake3-conntrack.patch.config.in
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.config.in	197=
0-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.config.in	2002-10-=
05 22:41:18.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  Quake III protocol support' CONFIG_IP_NF_QUAKE3 $CONFIG_=
IP_NF_CONNTRACK
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.config.=
in-2 netfilter/patch-o-matic/extra/quake3-conntrack.patch.config.in-2
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.config.in-2	1=
970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.config.in-2	2002-1=
0-05 22:45:04.000000000 +0200
@@ -0,0 +1,8 @@
+          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
+        fi
+      fi
+      if [ "$CONFIG_IP_NF_QUAKE3" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_QUAKE3 m
+      else
+        if [ "$CONFIG_IP_NF_QUAKE3" =3D "y" ]; then
+         define_tristate CONFIG_IP_NF_NAT_QUAKE3 $CONFIG_IP_NF_NAT
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.configu=
re.help netfilter/patch-o-matic/extra/quake3-conntrack.patch.configure.help
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.configure.hel=
p	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.configure.help	200=
2-10-05 22:47:52.000000000 +0200
@@ -0,0 +1,10 @@
+CONFIG_IP_NF_IRC
+Quake III Arena protocol support
+CONFIG_IP_NF_QUAKE3
+  Quake III Arena  connection tracking helper. This module allows for a
+  stricter firewall rulebase if one only allows traffic to a master
+  server. Connections to Quake III server IP addresses and ports returned
+  by the master server will be tracked automatically.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `Y'.
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.help ne=
tfilter/patch-o-matic/extra/quake3-conntrack.patch.help
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.help	1970-01-=
01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.help	2002-10-05 23=
:11:52.000000000 +0200
@@ -0,0 +1,17 @@
+Author: Filip Sneppe <filip.sneppe@cronos.be>
+Status: WorksForMe (tm)
+
+This adds CONFIG_IP_NF_QUAKE3: a Quake III Arena support module for
+netfilter connection tracking/NAT.=20
+
+Quake III Arena Internet multiplayer works by querying an Internet
+master server on UDP port 27950 for specific Quake III servers. The
+master server responds with the IP addresses and UDP ports of
+registered game servers. Those UDP ports can be randomly chosen
+(although 27960 is often used).
+
+This connection tracking module will listen for UDP replies
+from a master server, and will add the necessary expectations
+for connections from client to game servers.
+
+Note: Requires newnat !
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.makefil=
e netfilter/patch-o-matic/extra/quake3-conntrack.patch.makefile
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.makefile	1970=
-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.makefile	2002-10-0=
5 22:51:27.000000000 +0200
@@ -0,0 +1,5 @@
+# connection tracking helpers
+obj-$(CONFIG_IP_NF_QUAKE3) +=3D ip_conntrack_quake3.o
+ifdef CONFIG_IP_NF_NAT_QUAKE3
+	export-objs +=3D ip_conntrack_quake3.o
+endif
diff -urN netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.makefil=
e-2 netfilter/patch-o-matic/extra/quake3-conntrack.patch.makefile-2
--- netfilter-orig/patch-o-matic/extra/quake3-conntrack.patch.makefile-2	19=
70-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/quake3-conntrack.patch.makefile-2	2002-10=
-05 22:52:02.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_QUAKE3) +=3D ip_nat_quake3.o

--=-ulsRxp/rGdQHzRNaWpSy--
