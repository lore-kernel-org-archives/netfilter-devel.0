From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH] wanted: testers for ip_nat_cuseeme module
Date: 05 Nov 2002 02:37:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1036460255.689.34.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-P2+ghuDDnqESZ+SiZ5L8"
Cc: james@penguintowne.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-P2+ghuDDnqESZ+SiZ5L8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

(cross-post to netfilter-devel & netfilter)

As per James' request, I've written a cuseeme nat module for 
netfilter/iptables.

Since I am not a CuSeeMe user (and I don't even have a webcam or 
any other video conferencing hardware), I'd like some more people 
to test it out and report their success/failure stories to me privately,
before I submit this code for patch-o-matic. Discussions about
the code are best kept on netfilter-devel though, etc...

At the very least, the module should allow SNAT/MASQUERADE like the
2.2 ip_masq_cuseeme module. DNAT should also work. 

Some points of attention:

- My patch requires the newnat-udp-helper.patch written by
  Brian J. Murrell that is currently pending for kernel
  inclusion, as it makes use of "ip_nat_mangle_udp_packet()".
  I guess that patch won't make it in 2.4.20, so you'll have
  to get it from CVS (patch-o-matic/pending/newnat-udp-helper.patch)
  or here: 
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/pending/newnat-udp-helper.patch

  and apply it manually.

- You will find that there is only an ip_nat_cuseeme module.
  Since there are no random ports being opened, but payloads
  do contain embedded IP addresses, there is only a need for
  packet payload "mangling" in NAT scenarios.
  I was quite happy to find out that netfilter/iptables
  happily supports this!

- If you're running into problems, please let me know. I will
  ask you to recompile with debugging enabled (change the "#if 0" to
  "#if 1" in ip_nat_cuseeme.c), and capture traffic on both sides of 
  the NAT box, so you know ahead.
  I am curious if a lot of people will be getting many messages like 
  this in their system logs:

    expected incoming client 195.162.210.199:7648, but got 0.0.0.0:7648

  This shouldn't happen, but from what I get from the specs,
  it's not always strictly necessary to follow the specs to get
  a working implementation.

Regards,
Filip

ps. Unless someone else has started working on this, I will probably
end up writing a conntrack/nat helper for Microsoft MSN Messenger, 
now that I still have a Windows partition on a test box, so feel free
to volunteer as a tester for that too :-)

-----Original Message-----
From:	James Bryan [mailto:james@penguintowne.com]
Sent:	Sun 27/10/2002 5:47
To:	Sneppe Filip
Cc:	
Subject:	RE: Question about Porting the cu-seeme ipchains module to
iptables.

Filip,
  I haven't found anyone else yet who's ported the module or is working
on it. I'd  be delighted if you could port it over to a conntrack/nat
module. 

Regards,
James



--=-P2+ghuDDnqESZ+SiZ5L8
Content-Disposition: attachment; filename=diff.netfilter.cuseeme.20021104-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.cuseeme.20021104-1;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-pre11/Documentation/Configure.help linux=
-2.4.20-pre11-msn/Documentation/Configure.help
--- linux-2.4.20-pre11/Documentation/Configure.help	2002-10-29 02:18:22.000=
000000 +0100
+++ linux-2.4.20-pre11-msn/Documentation/Configure.help	2002-11-05 01:57:49=
.000000000 +0100
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
diff -urN -X dontdiff linux-2.4.20-pre11/include/linux/netfilter_ipv4/ip_co=
nntrack_cuseeme.h linux-2.4.20-pre11-msn/include/linux/netfilter_ipv4/ip_co=
nntrack_cuseeme.h
--- linux-2.4.20-pre11/include/linux/netfilter_ipv4/ip_conntrack_cuseeme.h	=
1970-01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-pre11-msn/include/linux/netfilter_ipv4/ip_conntrack_cuseem=
e.h	2002-11-04 18:20:59.000000000 +0100
@@ -0,0 +1,68 @@
+#ifndef _IP_CT_CUSEEME
+#define _IP_CT_CUSEEME
+
+#define CUSEEME_PORT 7648
+
+/* These structs come from the 2.2 ip_masq_cuseeme code... */
+
+/* CuSeeMe data header */
+struct cu_header {
+	u_int16_t	dest_family;
+	u_int16_t	dest_port;
+	u_int32_t	dest_addr;
+	u_int16_t	family;
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
+	u_int32_t	stuff[8];     /* Flags, pruning bitfield, packet counts, etc */
+};
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
diff -urN -X dontdiff linux-2.4.20-pre11/net/ipv4/netfilter/Config.in linux=
-2.4.20-pre11-msn/net/ipv4/netfilter/Config.in
--- linux-2.4.20-pre11/net/ipv4/netfilter/Config.in	2002-10-29 02:19:16.000=
000000 +0100
+++ linux-2.4.20-pre11-msn/net/ipv4/netfilter/Config.in	2002-10-30 00:52:42=
.000000000 +0100
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
@@ -67,6 +69,13 @@
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
diff -urN -X dontdiff linux-2.4.20-pre11/net/ipv4/netfilter/Makefile linux-=
2.4.20-pre11-msn/net/ipv4/netfilter/Makefile
--- linux-2.4.20-pre11/net/ipv4/netfilter/Makefile	2002-10-29 02:19:16.0000=
00000 +0100
+++ linux-2.4.20-pre11-msn/net/ipv4/netfilter/Makefile	2002-11-02 21:01:26.=
000000000 +0100
@@ -45,6 +53,7 @@
 # NAT helpers=20
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_CUSEEME) +=3D ip_nat_cuseeme.o
=20
 # generic IP tables=20
 obj-$(CONFIG_IP_NF_IPTABLES) +=3D ip_tables.o
diff -urN -X dontdiff linux-2.4.20-pre11/net/ipv4/netfilter/ip_nat_cuseeme.=
c linux-2.4.20-pre11-msn/net/ipv4/netfilter/ip_nat_cuseeme.c
--- linux-2.4.20-pre11/net/ipv4/netfilter/ip_nat_cuseeme.c	1970-01-01 01:00=
:00.000000000 +0100
+++ linux-2.4.20-pre11-msn/net/ipv4/netfilter/ip_nat_cuseeme.c	2002-11-05 0=
1:45:42.000000000 +0100
@@ -0,0 +1,285 @@
+/* CuSeeMe extension for UDP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_masq_cuseeme.c in 2.2 kernels
+ *
+ * ip_nat_cuseeme.c v0.0.4 2002-11-04
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
+MODULE_PARM_DESC(ports, "port numbers of CuSeeMe hosts");
+#endif
+
+#if 0=20
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
+		if (net_ratelimit())
+			printk("ip_nat_cuseeme: expected outgoing client %u.%u.%u.%u:%u, but go=
t %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
+			       ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port),
+			       NIPQUAD(cu_head->addr),
+			       ntohs(cu_head->port));
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
+	unsigned int client_info_size =3D sizeof(struct oc_header);
+	int i;
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
+		if (net_ratelimit())
+			printk("ip_nat_cuseeme: expected incoming client %u.%u.%u.%u:%u, but go=
t %u.%u.%u.%u:%u\n",
+			       NIPQUAD(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
+			       ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.udp.port),
+			       NIPQUAD(cu_head->dest_addr),
+			       ntohs(cu_head->dest_port));
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
+/*		oc_head =3D (struct oc_header *) &udph[1]; */
+/*		client_info_size =3D sizeof(struct oc_header); */
+		DEBUGP("ip_nat_cuseeme: looping through %u client_info structs\n", oc_he=
ad->client_count);
+		for(i=3D0;=20
+		    (i<oc_head->client_count) &&=20
+		    (sizeof(struct client_info)+client_info_size<=3Ddatalen);=20
+		    ++i, client_info_size+=3Dsizeof(struct client_info)) {
+			ci=3D(struct client_info *)(cu_head+client_info_size);
+			DEBUGP("ip_nat_cuseeme: here's a possible address: %u.%u.%u.%u\n", NIPQ=
UAD(ci->address));
+			if(ci->address =3D=3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip) {
+				/* mangle this IP address */
+				ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+				                         (unsigned int)((void *)&ci->address - (void *=
)cu_head), 4,=20
+				                         (char *)(&ct->tuplehash[IP_CT_DIR_ORIGINAL].t=
uple.src.ip), 4);
+				break;
+			}
+		}
+	}
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
+/*	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple); */
+/*	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple); */
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
+			sprintf(tmpname, "cuseeme-%d", i);
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

--=-P2+ghuDDnqESZ+SiZ5L8--
