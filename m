From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH] ip_nat_cuseeme NAT helper
Date: 18 Feb 2003 02:13:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1045530785.1570.12.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XwGHLMByEf2sqc2kJ4CY"
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


--=-XwGHLMByEf2sqc2kJ4CY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Harald & others,

This implements a NAT helper for the CuSeeMe protocol, both as a
patch against 2.4.20 and as a patch-o-matic patch.

Note that it requires Brian J. Murrell's newnat-udp-helper.patch
that should be in 2.4.21+ kernels (the 2.4.20 patch has Brian's
patch in it).

The module should work in DNAT and SNAT scenarios - I posted an
earlier version a couple of months ago, but that code had one
bug where one would see his/her own messages, yet others didn't
see anything. This version works in all my SNAT/DNAT tests...

Regards,
Filip




--=-XwGHLMByEf2sqc2kJ4CY
Content-Disposition: attachment; filename=diff.netfilter-cvs.cuseeme.20030218-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter-cvs.cuseeme.20030218-1;
	charset=ANSI_X3.4-1968

diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch netfilter-cuseeme=
/patch-o-matic/extra/cuseeme-nat.patch
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch	1970-01-01 01:00:00.000=
000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch	2003-02-18 01:5=
8:31.000000000 +0100
@@ -0,0 +1,367 @@
+diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_co=
nntrack_cuseeme.h linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_conn=
track_cuseeme.h
+--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_conntrack_cuseeme.h	=
1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_conntrack_cuseeme=
.h	2003-02-05 20:58:20.000000000 +0100
+@@ -0,0 +1,70 @@
++#ifndef _IP_CT_CUSEEME
++#define _IP_CT_CUSEEME
++
++#define CUSEEME_PORT 7648
++
++/* These structs come from the 2.2 ip_masq_cuseeme code... */
++
++#pragma pack(1)
++/* CuSeeMe data header */
++struct cu_header {
++	u_int16_t	dest_family;
++	u_int16_t	dest_port;
++	u_int32_t	dest_addr;
++	int16_t		family;
++	u_int16_t	port;
++	u_int32_t	addr;
++	u_int32_t	seq;
++	u_int16_t	msg;
++	u_int16_t	data_type;
++				/* possible values:
++				 * 1	small video
++				 * 2	big video
++				 * 3	audio
++				 * 100	acknowledge connectivity when there
++				 * 	is nothing else to send
++				 * 101	OpenContinue packet
++				 * 104	display a text message and=20
++				 * 	disconnect (used by reflector to
++				 * 	kick clients off)
++				 * 105	display a text message (welcome
++				 * 	message from reflector)
++				 * 106	exchanged among reflectors for
++				 * 	reflector interoperation
++				 * 107	carry aux stream data when there is
++				 *	no video to piggy-back on
++				 * 108	obsolete (used in Mac alpha version)
++				 * 109	obsolete (used in Mac alpha version)
++				 * 110	used for data rate control
++				 * 111	used for data rate control
++				 * 256	aux data control messages
++				 * 257	aux data packets
++				 * */
++	u_int16_t	packet_len;
++};
++
++/* Open Continue Header */
++struct oc_header {
++	struct cu_header	cu_head;
++	u_int16_t	client_count; /* Number of client info structs */
++	u_int32_t	seq_no;
++	char		user_name[20];
++	char		stuff[4];     /* Flags, version stuff, etc */
++};
++
++/* Client info structures */
++struct client_info {
++	u_int32_t	address;      /* Client address */
++	char		stuff[8];     /* Flags, pruning bitfield, packet counts, etc */
++};
++#pragma pack()
++
++/* This structure is per expected connection */
++struct ip_ct_cuseeme_expect {
++};
++
++/* This structure exists only once per master */
++struct ip_ct_cuseeme_master {
++};
++
++#endif /* _IP_CT_CUSEEME */
+diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_cuseeme.=
c linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_cuseeme.c
+--- linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_cuseeme.c	1970-01-01 01:00=
:00.000000000 +0100
++++ linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_cuseeme.c	2003-02-18 00=
:37:52.000000000 +0100
+@@ -0,0 +1,289 @@
++/* CuSeeMe extension for UDP NAT alteration.
++ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
++ * based on ip_masq_cuseeme.c in 2.2 kernels
++ *
++ * ip_nat_cuseeme.c v0.0.7 2003-02-18
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *      Module load syntax:
++ *      insmod ip_nat_cuseeme.o ports=3Dport1,port2,...port<MAX_PORTS>
++ *
++ *      Please give the ports of the CuSeeMe traffic you want to track.
++ *      If you don't specify ports, the default will be UDP port 7648.
++ *
++ *      CuSeeMe Protocol Documentation:
++ *      http://cu-seeme.net/squeek/tech/contents.html
++ *
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
++#include <linux/netfilter_ipv4/ip_conntrack_cuseeme.h>
++#include <linux/netfilter_ipv4/ip_nat_helper.h>
++#include <linux/netfilter_ipv4/ip_nat_rule.h>
++
++MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
++MODULE_DESCRIPTION("Netfilter NAT helper for CuSeeMe");
++MODULE_LICENSE("GPL");
++
++#define MAX_PORTS 8
++
++static int ports[MAX_PORTS];
++static int ports_c =3D 0;
++#ifdef MODULE_PARM
++MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
++MODULE_PARM_DESC(ports, "port numbers of CuSeeMe reflectors");
++#endif
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++/* process packet from client->reflector, possibly manipulate client IP i=
n payload */
++void cuseeme_mangle_outgoing(struct ip_conntrack *ct,
++                             struct ip_nat_info *info,
++                             enum ip_conntrack_info ctinfo,
++                             struct sk_buff **pskb,
++                             char *data,
++                             unsigned int datalen)
++{
++	char new_port_ip[6];
++	struct cu_header *cu_head=3D(struct cu_header *)data;
++=09
++	DEBUGP("ip_nat_cuseeme: outgoing packet, ID %u, dest_family %u\n",=20
++	       ntohs(cu_head->data_type), ntohs(cu_head->dest_family));
++	=09
++	/* At least check that the data at offset 10 is the client's port and IP=
 address */
++	if ((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip =3D=3D cu_head->addr=
) &&
++	    (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port =3D=3D cu_he=
ad->port)) {
++		DEBUGP("ip_nat_cuseeme: rewrite outgoing client %u.%u.%u.%u:%u->%u.%u.%=
u.%u:%u at offset 10\n",=20
++		       NIPQUAD(cu_head->addr),
++		       ntohs(cu_head->port),
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port));
++		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.ds=
t.u.udp.port;
++		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_REPLY].tupl=
e.dst.ip;
++		/* at offset 10, replace 6 bytes containing port + IP address */
++		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
++		                         10, 6, (char *)(new_port_ip), 6);
++	} else=20
++		DEBUGP("ip_nat_cuseeme: expected outgoing client %u.%u.%u.%u:%u, but go=
t %u.%u.%u.%u:%u\n",
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port),
++		       NIPQUAD(cu_head->addr),
++		       ntohs(cu_head->port));
++}
++
++/* process packet from reflector->client, possibly manipulate client IP &=
 reflector IP in payload */
++void cuseeme_mangle_incoming(struct ip_conntrack *ct,
++                             struct ip_nat_info *info,
++                             enum ip_conntrack_info ctinfo,
++                             struct sk_buff **pskb,
++                             char *data,
++                             unsigned int datalen)
++{
++	char new_port_ip[6];
++	struct cu_header *cu_head =3D (struct cu_header *)data;
++	struct oc_header *oc_head =3D (struct oc_header *)data;=20
++	struct client_info *ci;=20
++	int i, off;
++
++=09
++	DEBUGP("ip_nat_cuseeme: incoming packet, ID %u, dest_family %u\n",=20
++	       ntohs(cu_head->data_type), ntohs(cu_head->dest_family));
++	=09
++	/* Check if we're really dealing with the client's port + IP address bef=
ore rewriting */
++	if((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip =3D=3D cu_head->dest_add=
r) &&
++	   (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port =3D=3D cu_head->=
dest_port)) {
++		DEBUGP("ip_nat_cuseeme: rewrite incoming client %u.%u.%u.%u:%u->%u.%u.%=
u.%u:%u at offset 2\n",
++		       NIPQUAD(cu_head->dest_addr),
++		       ntohs(cu_head->dest_port),
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port));
++		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple=
.src.u.udp.port;
++		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.src.ip;
++		/* at offset 2, replace 6 bytes containing port + IP address */
++		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
++		                         2, 6, (char *)(new_port_ip), 6);
++	} else=20
++		DEBUGP("ip_nat_cuseeme: expected incoming client %u.%u.%u.%u:%u, but go=
t %u.%u.%u.%u:%u\n",
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port),
++		       NIPQUAD(cu_head->dest_addr),
++		       ntohs(cu_head->dest_port));
++=09
++	/* Check if we're really dealing with the server's port + IP address bef=
ore rewriting.=20
++	   In some cases, the IP address =3D=3D 0.0.0.0 so we don't rewrite anyt=
hing */
++	if((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip =3D=3D cu_head->addr) &&
++	   (ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.udp.port =3D=3D cu_head->=
port)) {
++		DEBUGP("in_nat_cuseeme: rewrite incoming server %u.%u.%u.%u:%u->%u.%u.%=
u.%u:%u at offset 10\n",
++		       NIPQUAD(cu_head->addr),
++		       ntohs(cu_head->port),
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port));
++		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple=
.dst.u.udp.port;
++		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.dst.ip;
++		/* at offset 10, replace 6 bytes containing port + IP address */
++		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
++		                         10, 6, (char *)(new_port_ip), 6);
++	} else=20
++		/* Sometimes we find 0.0.0.0, sometimes an IP address - the docs say th=
is field
++		   is not that important so we're not logging this unless we're debuggi=
ng */
++		DEBUGP("ip_nat_cuseeme: no biggie, expected incoming server %u.%u.%u.%u=
:%u, but got %u.%u.%u.%u:%u\n",
++		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip),
++		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.udp.port),
++		       NIPQUAD(cu_head->addr),
++		       ntohs(cu_head->port));
++=09
++	/* Spin through client_info structs until we find our own */
++	if((ntohs(cu_head->data_type) =3D=3D 101) && (datalen >=3D sizeof(struct=
 oc_header))) {
++		DEBUGP("ip_nat_cuseeme: looping through %u client_info structs\n", oc_h=
ead->client_count);
++		for(i=3D0, off=3Dsizeof(struct oc_header);
++		    (i < oc_head->client_count &&=20
++		    off+sizeof(struct client_info) <=3D datalen);=20
++		    i++) {
++			ci=3D(struct client_info *)(data+off);
++			DEBUGP("ip_nat_cuseeme: comparing %u.%u.%u.%u with %u.%u.%u.%u at offs=
et %u\n",=20
++			       NIPQUAD(ci->address), NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tu=
ple.dst.ip),=20
++			       (unsigned int)((void *)&(ci->address) - (void *)cu_head));
++			if(ci->address =3D=3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip) {
++				/* mangle this IP address */
++				DEBUGP("ip_nat_cuseeme: changing %u.%u.%u.%u->%u.%u.%u.%u at offset %=
u\n",
++				       NIPQUAD(ci->address),=20
++				       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
++				       (unsigned int)((void *)&(ci->address) - (void *)cu_head));
++				ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
++				                         (unsigned int)((void *)&(ci->address) - (voi=
d *)cu_head), 4,=20
++				                         (char *)(&(ct->tuplehash[IP_CT_DIR_ORIGINAL]=
.tuple.src.ip)), 4);
++				break;
++			} else=20
++				off+=3Dsizeof(struct client_info);
++		}
++	} else
++		DEBUGP("ip_nat_cuseeme: data_type %u, datalen %u < sizeof(struct oc_hea=
der) %u\n",=20
++		       ntohs(cu_head->data_type), datalen, sizeof(struct oc_header));
++}
++
++static unsigned int=20
++cuseeme_nat_help(struct ip_conntrack *ct,
++                 struct ip_conntrack_expect *exp,
++                 struct ip_nat_info *info,
++                 enum ip_conntrack_info ctinfo,
++                 unsigned int hooknum,
++                 struct sk_buff **pskb)
++{
++	struct iphdr *iph =3D (*pskb)->nh.iph;
++	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
++	int dir =3D CTINFO2DIR(ctinfo);
++	unsigned int datalen =3D (*pskb)->len - iph->ihl * 4 - sizeof(struct udp=
hdr);
++	char *data =3D (char *) &udph[1];
++=09
++	DEBUGP("ip_nat_cuseeme: cuseeme_nat_help, direction: %s hook: %s\n",
++	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???"
++	      );
++=09
++	/* Only mangle things once: original direction in POST_ROUTING
++	   and reply direction on PRE_ROUTING. */
++	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINA=
L)
++	    || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY))=
) {
++		DEBUGP("ip_nat_cuseeme: not touching dir %s at hook %s\n",
++		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????");
++		return NF_ACCEPT;
++	}
++=09
++	if(datalen < sizeof(struct cu_header)) {
++		/* packet too small */
++		if (net_ratelimit())
++			printk("ip_nat_cuseeme: payload too small (%u, should be >=3D %u)\n",=20
++			       datalen, sizeof(struct cu_header));
++		return NF_ACCEPT;
++	}
++
++
++	/* In the debugging output, "outgoing" is from client to server, and
++	   "incoming" is from server to client */
++	if(HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)=20
++		cuseeme_mangle_outgoing(ct, info, ctinfo, pskb, data, datalen);
++	else=20
++		cuseeme_mangle_incoming(ct, info, ctinfo, pskb, data, datalen);
++
++	return NF_ACCEPT;
++}
++
++static struct ip_nat_helper cuseeme[MAX_PORTS];
++static char cuseeme_names[MAX_PORTS][14];  /* cuseeme-65535 */
++
++static void fini(void)
++{
++	int i;
++=09
++	for (i =3D 0 ; i < ports_c; i++) {
++		DEBUGP("ip_nat_cuseeme: unregistering helper for port %d\n", ports[i]);
++		       ip_nat_helper_unregister(&cuseeme[i]);
++	}
++}
++
++static int __init init(void)
++{
++	int i, ret =3D 0;
++	char *tmpname;
++
++	if (!ports[0])
++		ports[0] =3D CUSEEME_PORT;
++	=09
++	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
++		memset(&cuseeme[i], 0, sizeof(struct ip_nat_helper));
++
++		cuseeme[i].tuple.dst.protonum =3D IPPROTO_UDP;
++		cuseeme[i].tuple.dst.u.udp.port =3D htons(ports[i]);
++		cuseeme[i].mask.dst.protonum =3D 0xFFFF;
++		cuseeme[i].mask.dst.u.udp.port =3D 0xFFFF;
++		cuseeme[i].help =3D cuseeme_nat_help;
++		cuseeme[i].flags =3D IP_NAT_HELPER_F_STANDALONE +=20
++		                   IP_NAT_HELPER_F_ALWAYS; /* dunno if IP_NAT_HELPER_F_=
ALWAYS
++		                                              is stricly needed... */
++		cuseeme[i].me =3D THIS_MODULE;
++		cuseeme[i].expect =3D NULL; /* cuseeme_nat_expected; */
++		=09
++		tmpname =3D &cuseeme_names[i][0];
++		if (ports[i] =3D=3D CUSEEME_PORT)
++			sprintf(tmpname, "cuseeme");
++		else
++			sprintf(tmpname, "cuseeme-%d", ports[i]);
++		cuseeme[i].name =3D tmpname;
++		=09
++		DEBUGP("ip_nat_cuseeme: registering helper for port %d: name %s\n",
++		       ports[i], cuseeme[i].name);
++		ret =3D ip_nat_helper_register(&cuseeme[i]);
++		=09
++		if (ret) {
++			printk("ip_nat_cuseeme: unable to register helper for port %d\n",
++			       ports[i]);
++			fini();
++			return ret;
++		}
++		ports_c++;
++	}
++	return ret;
++}
++=09
++module_init(init);
++module_exit(fini);
diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch.config.in netfilt=
er-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.config.in
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch.config.in	1970-01-01 01=
:00:00.000000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.config.in	2003-=
02-18 01:28:59.000000000 +0100
@@ -0,0 +1,2 @@
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  CuSeeMe protocol support' CONFIG_IP_NF_CUSEEME $CONFIG_I=
P_NF_CONNTRACK
diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch.config.in-2 netfi=
lter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.config.in-2
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch.config.in-2	1970-01-01 =
01:00:00.000000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.config.in-2	200=
3-02-18 01:30:22.000000000 +0100
@@ -0,0 +1,8 @@
+          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
+        fi
+      fi
+      if [ "$CONFIG_IP_NF_CUSEEME" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_CUSEEME m
+      else
+        if [ "$CONFIG_IP_NF_CUSEEME" =3D "y" ]; then
+         define_tristate CONFIG_IP_NF_NAT_CUSEEME $CONFIG_IP_NF_NAT
diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch.configure.help ne=
tfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.configure.help
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch.configure.help	1970-01-=
01 01:00:00.000000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.configure.help	=
2003-02-18 01:32:41.000000000 +0100
@@ -0,0 +1,11 @@
+CONFIG_IP_NF_IRC
+CuSeeMe protocol support
+CONFIG_IP_NF_CUSEEME
+  The CuSeeMe conferencing protocol is problematic when used in
+  conjunction with NAT; even though there are no random ports used for
+  extra connections, the messages contain IP addresses inside them.
+  This NAT helper mangles the IP address inside packets so both
+  parties don't get confused.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `Y'.
diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch.help netfilter-cu=
seeme/patch-o-matic/extra/cuseeme-nat.patch.help
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch.help	1970-01-01 01:00:0=
0.000000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.help	2003-02-18=
 01:35:04.000000000 +0100
@@ -0,0 +1,21 @@
+Author: Filip Sneppe <filip.sneppe@cronos.be>
+Status: WorksForMe(tm) - lightly tested - needs more success stories
+
+This adds CONFIG_IP_NF_CUSEEME: support for the CuSeeMe messaging=20
+protocol.=20
+
+Unlike protocols like FTP or IRC, CuSeeMe doesn't open any
+seemingly random ports for data transfers. It does, however,=20
+contain IP addresses of clients and server (reflector) inside the
+packet payload, making it impossible to use with NAT
+scenario's.
+
+There is only a NAT module, ip_nat_cuseeme.o, and no=20
+connection tracking helper.=20
+
+By default, the helper module tracks UDP traffic over port 7648.
+
+This helper has been tested in SNAT and DNAT setups.=20
+
+Note that this helper requires Brian J. Murrell's=20
+newnat-udp-helper.patch (submitted at 2.4.21-pre3 time)
diff -urN netfilter/patch-o-matic/extra/cuseeme-nat.patch.makefile netfilte=
r-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.makefile
--- netfilter/patch-o-matic/extra/cuseeme-nat.patch.makefile	1970-01-01 01:=
00:00.000000000 +0100
+++ netfilter-cuseeme/patch-o-matic/extra/cuseeme-nat.patch.makefile	2003-0=
2-18 01:35:49.000000000 +0100
@@ -0,0 +1,2 @@
+# NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_CUSEEME) +=3D ip_nat_cuseeme.o

--=-XwGHLMByEf2sqc2kJ4CY
Content-Disposition: attachment; filename=diff.netfilter-kernel.cuseeme.20030218-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter-kernel.cuseeme.20030218-1;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-orig/Documentation/Configure.help linux-=
2.4.20-cuseeme/Documentation/Configure.help
--- linux-2.4.20-orig/Documentation/Configure.help	2002-11-29 00:53:08.0000=
00000 +0100
+++ linux-2.4.20-cuseeme/Documentation/Configure.help	2003-02-05 20:58:03.0=
00000000 +0100
@@ -2508,6 +2508,17 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+CuSeeMe protocol support
+CONFIG_IP_NF_CUSEEME
+  The CuSeeMe conferencing protocol is problematic when used in
+  conjunction with NAT; even though there are no random ports used for
+  extra connections, the messages contain IP addresses inside them.
+  This NAT helper mangles the IP address inside packets so both
+  parties don't get confused.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `Y'.
+
 IRC Send/Chat protocol support
 CONFIG_IP_NF_IRC
   There is a commonly-used extension to IRC called
diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_con=
ntrack_cuseeme.h linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_connt=
rack_cuseeme.h
--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_conntrack_cuseeme.h	1=
970-01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_conntrack_cuseeme.=
h	2003-02-05 20:58:20.000000000 +0100
@@ -0,0 +1,70 @@
+#ifndef _IP_CT_CUSEEME
+#define _IP_CT_CUSEEME
+
+#define CUSEEME_PORT 7648
+
+/* These structs come from the 2.2 ip_masq_cuseeme code... */
+
+#pragma pack(1)
+/* CuSeeMe data header */
+struct cu_header {
+	u_int16_t	dest_family;
+	u_int16_t	dest_port;
+	u_int32_t	dest_addr;
+	int16_t		family;
+	u_int16_t	port;
+	u_int32_t	addr;
+	u_int32_t	seq;
+	u_int16_t	msg;
+	u_int16_t	data_type;
+				/* possible values:
+				 * 1	small video
+				 * 2	big video
+				 * 3	audio
+				 * 100	acknowledge connectivity when there
+				 * 	is nothing else to send
+				 * 101	OpenContinue packet
+				 * 104	display a text message and=20
+				 * 	disconnect (used by reflector to
+				 * 	kick clients off)
+				 * 105	display a text message (welcome
+				 * 	message from reflector)
+				 * 106	exchanged among reflectors for
+				 * 	reflector interoperation
+				 * 107	carry aux stream data when there is
+				 *	no video to piggy-back on
+				 * 108	obsolete (used in Mac alpha version)
+				 * 109	obsolete (used in Mac alpha version)
+				 * 110	used for data rate control
+				 * 111	used for data rate control
+				 * 256	aux data control messages
+				 * 257	aux data packets
+				 * */
+	u_int16_t	packet_len;
+};
+
+/* Open Continue Header */
+struct oc_header {
+	struct cu_header	cu_head;
+	u_int16_t	client_count; /* Number of client info structs */
+	u_int32_t	seq_no;
+	char		user_name[20];
+	char		stuff[4];     /* Flags, version stuff, etc */
+};
+
+/* Client info structures */
+struct client_info {
+	u_int32_t	address;      /* Client address */
+	char		stuff[8];     /* Flags, pruning bitfield, packet counts, etc */
+};
+#pragma pack()
+
+/* This structure is per expected connection */
+struct ip_ct_cuseeme_expect {
+};
+
+/* This structure exists only once per master */
+struct ip_ct_cuseeme_master {
+};
+
+#endif /* _IP_CT_CUSEEME */
diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_nat=
_helper.h linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_nat_helper.h
--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_nat_helper.h	2002-11-=
29 00:53:15.000000000 +0100
+++ linux-2.4.20-cuseeme/include/linux/netfilter_ipv4/ip_nat_helper.h	2003-=
02-05 20:58:20.000000000 +0100
@@ -50,6 +50,13 @@
 				unsigned int match_len,
 				char *rep_buffer,
 				unsigned int rep_len);
+extern int ip_nat_mangle_udp_packet(struct sk_buff **skb,
+				struct ip_conntrack *ct,
+				enum ip_conntrack_info ctinfo,
+				unsigned int match_offset,
+				unsigned int match_len,
+				char *rep_buffer,
+				unsigned int rep_len);
 extern int ip_nat_seq_adjust(struct sk_buff *skb,
 				struct ip_conntrack *ct,
 				enum ip_conntrack_info ctinfo);
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/Config.in linux-=
2.4.20-cuseeme/net/ipv4/netfilter/Config.in
--- linux-2.4.20-orig/net/ipv4/netfilter/Config.in	2002-11-29 00:53:15.0000=
00000 +0100
+++ linux-2.4.20-cuseeme/net/ipv4/netfilter/Config.in	2003-02-05 20:58:20.0=
00000000 +0100
@@ -8,6 +8,7 @@
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  CuSeeMe protocol support' CONFIG_IP_NF_CUSEEME $CONFIG_I=
P_NF_CONNTRACK
 fi
=20
 if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
@@ -67,6 +68,13 @@
           define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
         fi
       fi
+      if [ "$CONFIG_IP_NF_CUSEEME" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_CUSEEME m
+      else
+        if [ "$CONFIG_IP_NF_CUSEEME" =3D "y" ]; then
+         define_tristate CONFIG_IP_NF_NAT_CUSEEME $CONFIG_IP_NF_NAT
+        fi
+      fi
       # If they want FTP, set to $CONFIG_IP_NF_NAT (m or y),=20
       # or $CONFIG_IP_NF_FTP (m or y), whichever is weaker.  Argh.
       if [ "$CONFIG_IP_NF_FTP" =3D "m" ]; then
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/Makefile linux-2=
.4.20-cuseeme/net/ipv4/netfilter/Makefile
--- linux-2.4.20-orig/net/ipv4/netfilter/Makefile	2002-11-29 00:53:15.00000=
0000 +0100
+++ linux-2.4.20-cuseeme/net/ipv4/netfilter/Makefile	2003-02-05 20:58:20.00=
0000000 +0100
@@ -45,6 +45,7 @@
 # NAT helpers=20
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_CUSEEME) +=3D ip_nat_cuseeme.o
=20
 # generic IP tables=20
 obj-$(CONFIG_IP_NF_IPTABLES) +=3D ip_tables.o
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_cuseeme.c=
 linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_cuseeme.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_cuseeme.c	1970-01-01 01:00:=
00.000000000 +0100
+++ linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_cuseeme.c	2003-02-18 00:=
37:52.000000000 +0100
@@ -0,0 +1,289 @@
+/* CuSeeMe extension for UDP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_masq_cuseeme.c in 2.2 kernels
+ *
+ * ip_nat_cuseeme.c v0.0.7 2003-02-18
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_nat_cuseeme.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of the CuSeeMe traffic you want to track.
+ *      If you don't specify ports, the default will be UDP port 7648.
+ *
+ *      CuSeeMe Protocol Documentation:
+ *      http://cu-seeme.net/squeek/tech/contents.html
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
+#include <linux/netfilter_ipv4/ip_conntrack_cuseeme.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Netfilter NAT helper for CuSeeMe");
+MODULE_LICENSE("GPL");
+
+#define MAX_PORTS 8
+
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of CuSeeMe reflectors");
+#endif
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* process packet from client->reflector, possibly manipulate client IP in=
 payload */
+void cuseeme_mangle_outgoing(struct ip_conntrack *ct,
+                             struct ip_nat_info *info,
+                             enum ip_conntrack_info ctinfo,
+                             struct sk_buff **pskb,
+                             char *data,
+                             unsigned int datalen)
+{
+	char new_port_ip[6];
+	struct cu_header *cu_head=3D(struct cu_header *)data;
+=09
+	DEBUGP("ip_nat_cuseeme: outgoing packet, ID %u, dest_family %u\n",=20
+	       ntohs(cu_head->data_type), ntohs(cu_head->dest_family));
+	=09
+	/* At least check that the data at offset 10 is the client's port and IP =
address */
+	if ((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip =3D=3D cu_head->addr)=
 &&
+	    (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port =3D=3D cu_hea=
d->port)) {
+		DEBUGP("ip_nat_cuseeme: rewrite outgoing client %u.%u.%u.%u:%u->%u.%u.%u=
.%u:%u at offset 10\n",=20
+		       NIPQUAD(cu_head->addr),
+		       ntohs(cu_head->port),
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port));
+		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst=
.u.udp.port;
+		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple=
.dst.ip;
+		/* at offset 10, replace 6 bytes containing port + IP address */
+		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+		                         10, 6, (char *)(new_port_ip), 6);
+	} else=20
+		DEBUGP("ip_nat_cuseeme: expected outgoing client %u.%u.%u.%u:%u, but got=
 %u.%u.%u.%u:%u\n",
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port),
+		       NIPQUAD(cu_head->addr),
+		       ntohs(cu_head->port));
+}
+
+/* process packet from reflector->client, possibly manipulate client IP & =
reflector IP in payload */
+void cuseeme_mangle_incoming(struct ip_conntrack *ct,
+                             struct ip_nat_info *info,
+                             enum ip_conntrack_info ctinfo,
+                             struct sk_buff **pskb,
+                             char *data,
+                             unsigned int datalen)
+{
+	char new_port_ip[6];
+	struct cu_header *cu_head =3D (struct cu_header *)data;
+	struct oc_header *oc_head =3D (struct oc_header *)data;=20
+	struct client_info *ci;=20
+	int i, off;
+
+=09
+	DEBUGP("ip_nat_cuseeme: incoming packet, ID %u, dest_family %u\n",=20
+	       ntohs(cu_head->data_type), ntohs(cu_head->dest_family));
+	=09
+	/* Check if we're really dealing with the client's port + IP address befo=
re rewriting */
+	if((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip =3D=3D cu_head->dest_addr=
) &&
+	   (ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port =3D=3D cu_head->d=
est_port)) {
+		DEBUGP("ip_nat_cuseeme: rewrite incoming client %u.%u.%u.%u:%u->%u.%u.%u=
.%u:%u at offset 2\n",
+		       NIPQUAD(cu_head->dest_addr),
+		       ntohs(cu_head->dest_port),
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port));
+		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.=
src.u.udp.port;
+		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tu=
ple.src.ip;
+		/* at offset 2, replace 6 bytes containing port + IP address */
+		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+		                         2, 6, (char *)(new_port_ip), 6);
+	} else=20
+		DEBUGP("ip_nat_cuseeme: expected incoming client %u.%u.%u.%u:%u, but got=
 %u.%u.%u.%u:%u\n",
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port),
+		       NIPQUAD(cu_head->dest_addr),
+		       ntohs(cu_head->dest_port));
+=09
+	/* Check if we're really dealing with the server's port + IP address befo=
re rewriting.=20
+	   In some cases, the IP address =3D=3D 0.0.0.0 so we don't rewrite anyth=
ing */
+	if((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip =3D=3D cu_head->addr) &&
+	   (ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.udp.port =3D=3D cu_head->p=
ort)) {
+		DEBUGP("in_nat_cuseeme: rewrite incoming server %u.%u.%u.%u:%u->%u.%u.%u=
.%u:%u at offset 10\n",
+		       NIPQUAD(cu_head->addr),
+		       ntohs(cu_head->port),
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port));
+		*((u_int16_t *)new_port_ip) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.=
dst.u.udp.port;
+		*((u_int32_t *)(new_port_ip+2)) =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tu=
ple.dst.ip;
+		/* at offset 10, replace 6 bytes containing port + IP address */
+		ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+		                         10, 6, (char *)(new_port_ip), 6);
+	} else=20
+		/* Sometimes we find 0.0.0.0, sometimes an IP address - the docs say thi=
s field
+		   is not that important so we're not logging this unless we're debuggin=
g */
+		DEBUGP("ip_nat_cuseeme: no biggie, expected incoming server %u.%u.%u.%u:=
%u, but got %u.%u.%u.%u:%u\n",
+		       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip),
+		       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.udp.port),
+		       NIPQUAD(cu_head->addr),
+		       ntohs(cu_head->port));
+=09
+	/* Spin through client_info structs until we find our own */
+	if((ntohs(cu_head->data_type) =3D=3D 101) && (datalen >=3D sizeof(struct =
oc_header))) {
+		DEBUGP("ip_nat_cuseeme: looping through %u client_info structs\n", oc_he=
ad->client_count);
+		for(i=3D0, off=3Dsizeof(struct oc_header);
+		    (i < oc_head->client_count &&=20
+		    off+sizeof(struct client_info) <=3D datalen);=20
+		    i++) {
+			ci=3D(struct client_info *)(data+off);
+			DEBUGP("ip_nat_cuseeme: comparing %u.%u.%u.%u with %u.%u.%u.%u at offse=
t %u\n",=20
+			       NIPQUAD(ci->address), NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tup=
le.dst.ip),=20
+			       (unsigned int)((void *)&(ci->address) - (void *)cu_head));
+			if(ci->address =3D=3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip) {
+				/* mangle this IP address */
+				DEBUGP("ip_nat_cuseeme: changing %u.%u.%u.%u->%u.%u.%u.%u at offset %u=
\n",
+				       NIPQUAD(ci->address),=20
+				       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+				       (unsigned int)((void *)&(ci->address) - (void *)cu_head));
+				ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+				                         (unsigned int)((void *)&(ci->address) - (void=
 *)cu_head), 4,=20
+				                         (char *)(&(ct->tuplehash[IP_CT_DIR_ORIGINAL].=
tuple.src.ip)), 4);
+				break;
+			} else=20
+				off+=3Dsizeof(struct client_info);
+		}
+	} else
+		DEBUGP("ip_nat_cuseeme: data_type %u, datalen %u < sizeof(struct oc_head=
er) %u\n",=20
+		       ntohs(cu_head->data_type), datalen, sizeof(struct oc_header));
+}
+
+static unsigned int=20
+cuseeme_nat_help(struct ip_conntrack *ct,
+                 struct ip_conntrack_expect *exp,
+                 struct ip_nat_info *info,
+                 enum ip_conntrack_info ctinfo,
+                 unsigned int hooknum,
+                 struct sk_buff **pskb)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	int dir =3D CTINFO2DIR(ctinfo);
+	unsigned int datalen =3D (*pskb)->len - iph->ihl * 4 - sizeof(struct udph=
dr);
+	char *data =3D (char *) &udph[1];
+=09
+	DEBUGP("ip_nat_cuseeme: cuseeme_nat_help, direction: %s hook: %s\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???"
+	      );
+=09
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL=
)
+	    || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)))=
 {
+		DEBUGP("ip_nat_cuseeme: not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "????");
+		return NF_ACCEPT;
+	}
+=09
+	if(datalen < sizeof(struct cu_header)) {
+		/* packet too small */
+		if (net_ratelimit())
+			printk("ip_nat_cuseeme: payload too small (%u, should be >=3D %u)\n",=20
+			       datalen, sizeof(struct cu_header));
+		return NF_ACCEPT;
+	}
+
+
+	/* In the debugging output, "outgoing" is from client to server, and
+	   "incoming" is from server to client */
+	if(HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)=20
+		cuseeme_mangle_outgoing(ct, info, ctinfo, pskb, data, datalen);
+	else=20
+		cuseeme_mangle_incoming(ct, info, ctinfo, pskb, data, datalen);
+
+	return NF_ACCEPT;
+}
+
+static struct ip_nat_helper cuseeme[MAX_PORTS];
+static char cuseeme_names[MAX_PORTS][14];  /* cuseeme-65535 */
+
+static void fini(void)
+{
+	int i;
+=09
+	for (i =3D 0 ; i < ports_c; i++) {
+		DEBUGP("ip_nat_cuseeme: unregistering helper for port %d\n", ports[i]);
+		       ip_nat_helper_unregister(&cuseeme[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret =3D 0;
+	char *tmpname;
+
+	if (!ports[0])
+		ports[0] =3D CUSEEME_PORT;
+	=09
+	for (i =3D 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+		memset(&cuseeme[i], 0, sizeof(struct ip_nat_helper));
+
+		cuseeme[i].tuple.dst.protonum =3D IPPROTO_UDP;
+		cuseeme[i].tuple.dst.u.udp.port =3D htons(ports[i]);
+		cuseeme[i].mask.dst.protonum =3D 0xFFFF;
+		cuseeme[i].mask.dst.u.udp.port =3D 0xFFFF;
+		cuseeme[i].help =3D cuseeme_nat_help;
+		cuseeme[i].flags =3D IP_NAT_HELPER_F_STANDALONE +=20
+		                   IP_NAT_HELPER_F_ALWAYS; /* dunno if IP_NAT_HELPER_F_A=
LWAYS
+		                                              is stricly needed... */
+		cuseeme[i].me =3D THIS_MODULE;
+		cuseeme[i].expect =3D NULL; /* cuseeme_nat_expected; */
+		=09
+		tmpname =3D &cuseeme_names[i][0];
+		if (ports[i] =3D=3D CUSEEME_PORT)
+			sprintf(tmpname, "cuseeme");
+		else
+			sprintf(tmpname, "cuseeme-%d", ports[i]);
+		cuseeme[i].name =3D tmpname;
+		=09
+		DEBUGP("ip_nat_cuseeme: registering helper for port %d: name %s\n",
+		       ports[i], cuseeme[i].name);
+		ret =3D ip_nat_helper_register(&cuseeme[i]);
+		=09
+		if (ret) {
+			printk("ip_nat_cuseeme: unable to register helper for port %d\n",
+			       ports[i]);
+			fini();
+			return ret;
+		}
+		ports_c++;
+	}
+	return ret;
+}
+=09
+module_init(init);
+module_exit(fini);
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_helper.c =
linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_helper.c	2002-11-29 00:53:1=
5.000000000 +0100
+++ linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_helper.c	2003-02-05 20:5=
8:20.000000000 +0100
@@ -8,6 +8,9 @@
  *		- add support for SACK adjustment=20
  *	14 Mar 2002 Harald Welte <laforge@gnumonks.org>:
  *		- merge SACK support into newnat API
+ *	16 Aug 2002 Brian J. Murrell <netfilter@interlinx.bc.ca>:
+ *		- make ip_nat_resize_packet more generic (TCP and UDP)
+ *		- add ip_nat_mangle_udp_packet
  */
 #include <linux/version.h>
 #include <linux/config.h>
@@ -22,6 +25,7 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
+#include <net/udp.h>
=20
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
@@ -51,18 +55,12 @@
 		     int new_size)
 {
 	struct iphdr *iph;
-	struct tcphdr *tcph;
-	void *data;
 	int dir;
 	struct ip_nat_seq *this_way, *other_way;
=20
 	DEBUGP("ip_nat_resize_packet: old_size =3D %u, new_size =3D %u\n",
 		(*skb)->len, new_size);
=20
-	iph =3D (*skb)->nh.iph;
-	tcph =3D (void *)iph + iph->ihl*4;
-	data =3D (void *)tcph + tcph->doff*4;
-
 	dir =3D CTINFO2DIR(ctinfo);
=20
 	this_way =3D &ct->nat.info.seq[dir];
@@ -84,37 +82,41 @@
 	}
=20
 	iph =3D (*skb)->nh.iph;
-	tcph =3D (void *)iph + iph->ihl*4;
-	data =3D (void *)tcph + tcph->doff*4;
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
-	DUMP_OFFSET(this_way);
+	if (iph->protocol =3D=3D IPPROTO_TCP) {
+		struct tcphdr *tcph =3D (void *)iph + iph->ihl*4;
+		void *data =3D (void *)tcph + tcph->doff*4;
+
+		DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
+		DUMP_OFFSET(this_way);
+
+		LOCK_BH(&ip_nat_seqofs_lock);
+
+		/* SYN adjust. If it's uninitialized, of this is after last=20
+		 * correction, record it: we don't handle more than one=20
+		 * adjustment in the window, but do deal with common case of a=20
+		 * retransmit */
+		if (this_way->offset_before =3D=3D this_way->offset_after
+		    || before(this_way->correction_pos, ntohl(tcph->seq))) {
+			this_way->correction_pos =3D ntohl(tcph->seq);
+			this_way->offset_before =3D this_way->offset_after;
+			this_way->offset_after =3D (int32_t)
+				this_way->offset_before + new_size -
+				(*skb)->len;
+		}
=20
-	LOCK_BH(&ip_nat_seqofs_lock);
+		UNLOCK_BH(&ip_nat_seqofs_lock);
=20
-	/* SYN adjust. If it's uninitialized, of this is after last=20
-	 * correction, record it: we don't handle more than one=20
-	 * adjustment in the window, but do deal with common case of a=20
-	 * retransmit */
-	if (this_way->offset_before =3D=3D this_way->offset_after
-	    || before(this_way->correction_pos, ntohl(tcph->seq))) {
-		this_way->correction_pos =3D ntohl(tcph->seq);
-		this_way->offset_before =3D this_way->offset_after;
-		this_way->offset_after =3D (int32_t)
-			this_way->offset_before + new_size - (*skb)->len;
+		DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
+		DUMP_OFFSET(this_way);
 	}
-
-	UNLOCK_BH(&ip_nat_seqofs_lock);
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
-	DUMP_OFFSET(this_way);
 =09
 	return 1;
 }
=20
=20
 /* Generic function for mangling variable-length address changes inside
- * NATed connections (like the PORT XXX,XXX,XXX,XXX,XXX,XXX command in FTP=
).
+ * NATed TCP connections (like the PORT XXX,XXX,XXX,XXX,XXX,XXX
+ * command in FTP).
  *
  * Takes care about all the nasty sequence number changes, checksumming,
  * skb enlargement, ...
@@ -174,10 +176,11 @@
 	tcph =3D (void *)iph + iph->ihl*4;
 	data =3D (void *)tcph + tcph->doff*4;
=20
-	/* move post-replacement */
-	memmove(data + match_offset + rep_len,
-		 data + match_offset + match_len,
-		 (*skb)->tail - (data + match_offset + match_len));
+	if (rep_len !=3D match_len)
+		/* move post-replacement */
+		memmove(data + match_offset + rep_len,
+			data + match_offset + match_len,
+			(*skb)->tail - (data + match_offset + match_len));
=20
 	/* insert data from buffer */
 	memcpy(data + match_offset, rep_buffer, rep_len);
@@ -207,6 +210,114 @@
=20
 	return 1;
 }
+		=09
+/* Generic function for mangling variable-length address changes inside
+ * NATed UDP connections (like the CONNECT DATA XXXXX MESG XXXXX INDEX XXX=
XX
+ * command in the Amanda protocol)
+ *
+ * Takes care about all the nasty sequence number changes, checksumming,
+ * skb enlargement, ...
+ *
+ * XXX - This function could be merged with ip_nat_mangle_tcp_packet which
+ *       should be fairly easy to do.
+ */
+int=20
+ip_nat_mangle_udp_packet(struct sk_buff **skb,
+			 struct ip_conntrack *ct,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int match_offset,
+			 unsigned int match_len,
+			 char *rep_buffer,
+			 unsigned int rep_len)
+{
+	struct iphdr *iph =3D (*skb)->nh.iph;
+	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
+	unsigned char *data;
+	u_int32_t udplen, newlen, newudplen;
+
+	udplen =3D (*skb)->len - iph->ihl*4;
+	newudplen =3D udplen - match_len + rep_len;
+	newlen =3D iph->ihl*4 + newudplen;
+
+	if (newlen > 65535) {
+		if (net_ratelimit())
+			printk("ip_nat_mangle_udp_packet: nat'ed packet "
+				"exceeds maximum packet size\n");
+		return 0;
+	}
+
+	if ((*skb)->len !=3D newlen) {
+		if (!ip_nat_resize_packet(skb, ct, ctinfo, newlen)) {
+			printk("resize_packet failed!!\n");
+			return 0;
+		}
+	}
+
+	/* Alexey says: if a hook changes _data_ ... it can break
+	   original packet sitting in tcp queue and this is fatal */
+	if (skb_cloned(*skb)) {
+		struct sk_buff *nskb =3D skb_copy(*skb, GFP_ATOMIC);
+		if (!nskb) {
+			if (net_ratelimit())
+				printk("Out of memory cloning TCP packet\n");
+			return 0;
+		}
+		/* Rest of kernel will get very unhappy if we pass it
+		   a suddenly-orphaned skbuff */
+		if ((*skb)->sk)
+			skb_set_owner_w(nskb, (*skb)->sk);
+		kfree_skb(*skb);
+		*skb =3D nskb;
+	}
+
+	/* skb may be copied !! */
+	iph =3D (*skb)->nh.iph;
+	udph =3D (void *)iph + iph->ihl*4;
+	data =3D (void *)udph + sizeof(struct udphdr);
+
+	if (rep_len !=3D match_len)
+		/* move post-replacement */
+		memmove(data + match_offset + rep_len,
+			data + match_offset + match_len,
+			(*skb)->tail - (data + match_offset + match_len));
+
+	/* insert data from buffer */
+	memcpy(data + match_offset, rep_buffer, rep_len);
+
+	/* update skb info */
+	if (newlen > (*skb)->len) {
+		DEBUGP("ip_nat_mangle_udp_packet: Extending packet by "
+			"%u to %u bytes\n", newlen - (*skb)->len, newlen);
+		skb_put(*skb, newlen - (*skb)->len);
+	} else {
+		DEBUGP("ip_nat_mangle_udp_packet: Shrinking packet from "
+			"%u to %u bytes\n", (*skb)->len, newlen);
+		skb_trim(*skb, newlen);
+	}
+
+	/* update the length of the UDP and IP packets to the new values*/
+	udph->len =3D htons((*skb)->len - iph->ihl*4);
+	iph->tot_len =3D htons(newlen);
+
+	/* fix udp checksum if udp checksum was previously calculated */
+	if ((*skb)->csum !=3D 0) {
+		(*skb)->csum =3D csum_partial((char *)udph +
+					    sizeof(struct udphdr),
+					    newudplen - sizeof(struct udphdr),
+					    0);
+
+		udph->check =3D 0;
+		udph->check =3D csum_tcpudp_magic(iph->saddr, iph->daddr,
+						newudplen, IPPROTO_UDP,
+						csum_partial((char *)udph,
+							 sizeof(struct udphdr),
+							(*skb)->csum));
+	}
+
+	ip_send_check(iph);
+
+	return 1;
+}
=20
 /* Adjust one found SACK option including checksum correction */
 static void
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_standalon=
e.c linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_standalone.c	2002-11-29 00:=
53:15.000000000 +0100
+++ linux-2.4.20-cuseeme/net/ipv4/netfilter/ip_nat_standalone.c	2003-02-05 =
20:58:20.000000000 +0100
@@ -358,5 +358,6 @@
 EXPORT_SYMBOL(ip_nat_helper_unregister);
 EXPORT_SYMBOL(ip_nat_cheat_check);
 EXPORT_SYMBOL(ip_nat_mangle_tcp_packet);
+EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
 EXPORT_SYMBOL(ip_nat_used_tuple);
 MODULE_LICENSE("GPL");

--=-XwGHLMByEf2sqc2kJ4CY--
