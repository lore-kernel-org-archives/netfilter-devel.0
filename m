From: netfilter@interlinx.bc.ca
Subject: [PATCH] Connection tracking/NAT for Amanda
Date: Fri, 13 Sep 2002 16:15:01 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020913201501.GD2689@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pY3vCvL1qV+PayAL"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
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


--pY3vCvL1qV+PayAL
Content-Type: multipart/mixed; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Please find attached a patch (to p-o-m) which adds both connection
tracking and NAT support for the Amanda backup protocol.

BTW: I had to actually check out a clean tree and use diff with -N to
generate a patch that included "new" files.  Is there no way to do
this with a sandbox from a CVS repository?  "cvs diff -N" did not seem
to do the trick.

Thanx,
b.

--=20
Brian J. Murrell

--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="amanda-conntrack.patch"
Content-Transfer-Encoding: quoted-printable

diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch ..=
/netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch	1969-12-31 19:00:00.00=
0000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch	2002-08-28 =
04:16:34.000000000 -0400
@@ -0,0 +1,486 @@
+diff -uNr linux-2.4.18-6mdk-pom-clean/include/linux/netfilter_ipv4/ip_conn=
track_amanda.h linux-2.4.18-6mdkuml-48um-pom/include/linux/netfilter_ipv4/i=
p_conntrack_amanda.h
+--- linux-2.4.18-6mdk-pom-clean/include/linux/netfilter_ipv4/ip_conntrack_=
amanda.h	1969-12-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/include/linux/netfilter_ipv4/ip_conntrac=
k_amanda.h	2002-08-16 04:11:23.000000000 -0400
+@@ -0,0 +1,29 @@
++#ifndef _IP_CONNTRACK_AMANDA_H
++#define _IP_CONNTRACK_AMANDA_H
++/* AMANDA tracking. */
++
++#ifdef __KERNEL__
++
++#include <linux/netfilter_ipv4/lockhelp.h>
++
++/* Protects amanda part of conntracks */
++DECLARE_LOCK_EXTERN(ip_amanda_lock);
++
++#endif
++
++struct conn {
++	char* match;
++	int matchlen;
++};
++
++#define NUM_MSGS 	3
++
++
++struct ip_ct_amanda_expect
++{
++	u_int16_t port;		/* port number of this expectation */
++	u_int16_t offset;	/* offset of the port specification in ctrl packet */
++	u_int16_t len;		/* the length of the port number specification */
++};
++
++#endif /* _IP_CONNTRACK_AMANDA_H */
+diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_aman=
da.c linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c
+--- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_amanda.c	1=
969-12-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c=
	2002-08-16 04:24:25.000000000 -0400
+@@ -0,0 +1,219 @@
++/* Amanda extension for IP connection tracking, Version 0.1
++ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
++ * based on HW's ip_conntrack_irc.c	as well as other modules
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *	Module load syntax:
++ * 	insmod ip_conntrack_amanda.o
++ *
++ */
++
++#include <linux/module.h>
++#include <linux/netfilter.h>
++#include <linux/ip.h>
++#include <net/checksum.h>
++#include <net/udp.h>
++
++#include <linux/netfilter_ipv4/lockhelp.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
++
++MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
++MODULE_DESCRIPTION("Amanda connection tracking module");
++MODULE_LICENSE("GPL");
++
++DECLARE_LOCK(ip_amanda_lock);
++struct module *ip_conntrack_amanda =3D THIS_MODULE;
++
++#define MAXMATCHLEN	6
++struct conn conns[NUM_MSGS] =3D {
++	{"DATA ", 5},
++	{"MESG ", 5},
++	{"INDEX ", 6},
++};
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++
++/* FIXME: This should be in userspace.  Later. */
++static int help(const struct iphdr *iph, size_t len,
++		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
++{
++	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
++	u_int32_t udplen =3D len - iph->ihl * 4;
++	u_int32_t datalen =3D udplen - sizeof(struct udphdr);
++	char *data =3D (char *)udph + sizeof(struct udphdr);
++	char *datap =3D data;
++	char *data_limit =3D (char *) data + datalen;
++	int dir =3D CTINFO2DIR(ctinfo);
++	struct ip_ct_amanda *info =3D
++				(struct ip_ct_amanda *)&ct->help.ct_ftp_info;
++
++	/* Can't track connections formed before we registered */
++	if (!info)
++		return NF_ACCEPT;
++
++	/* If packet is coming from Amanda server */
++	if (dir =3D=3D IP_CT_DIR_ORIGINAL)
++		return NF_ACCEPT;
++
++	/* Not whole UDP header? */
++	if (udplen < sizeof(struct udphdr)) {
++		printk("ip_conntrack_amanda_help: udplen =3D %u\n",
++		       (unsigned)udplen);
++		return NF_ACCEPT;
++	}
++
++	/* Checksum invalid?  Ignore. */
++	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
++			      csum_partial((char *)udph, udplen, 0))) {
++		DEBUGP("ip_ct_talk_help: bad csum: %p %u %u.%u.%u.%u "
++		       "%u.%u.%u.%u\n",
++		       udph, udplen, NIPQUAD(iph->saddr),
++		       NIPQUAD(iph->daddr));
++		return NF_ACCEPT;
++	}
++=09
++	/* Search for the CONNECT string */
++	while (data < data_limit) {
++		if (!memcmp(data, "CONNECT ", 8)) {
++			break;
++		}
++		data++;
++	}
++	if (memcmp(data, "CONNECT ", 8))
++		return NF_ACCEPT;
++
++	DEBUGP("ip_conntrack_amanda_help: CONNECT found in connection "
++		   "%u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
++		   NIPQUAD(iph->saddr), htons(udph->source),
++		   NIPQUAD(iph->daddr), htons(udph->dest));
++	data +=3D 8;
++	while (*data !=3D 0x0a && data < data_limit) {
++
++		int i;
++
++		for (i =3D 0; i < NUM_MSGS; i++) {
++			if (!memcmp(data, conns[i].match,
++				   conns[i].matchlen)) {
++
++				char *portchr;
++				struct ip_conntrack_expect expect;
++				struct ip_ct_amanda_expect
++				    *exp_amanda_info =3D
++					&expect.help.exp_amanda_info;
++
++				memset(&expect, 0, sizeof(expect));
++
++				data +=3D conns[i].matchlen;
++				/* this is not really tcp, but let's steal an
++				 * idea from a tcp stream helper :-)
++				 */
++				// XXX expect.seq =3D data - datap;
++				exp_amanda_info->offset =3D data - datap;
++// XXX DEBUGP("expect.seq =3D %p - %p =3D %d\n", data, datap, expect.seq);
++DEBUGP("exp_amanda_info->offset =3D %p - %p =3D %d\n", data, datap, exp_a=
manda_info->offset);
++				portchr =3D data;
++				exp_amanda_info->port =3D
++				    simple_strtoul(data, &data, 10);
++				exp_amanda_info->len =3D data - portchr;
++
++				/* eat whitespace */
++				while (*data =3D=3D ' ')
++					data++;
++				DEBUGP ("ip_conntrack_amanda_help: "
++					"CONNECT %s request with port "
++					"%u found\n", conns[i].match,
++					exp_amanda_info->port);
++
++				LOCK_BH(&ip_amanda_lock);
++
++				expect.tuple =3D ((struct ip_conntrack_tuple)
++						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
++						  { 0 } },
++				  		{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
++						  { htons(exp_amanda_info->port) },
++				    	  IPPROTO_TCP }});
++				expect.mask =3D ((struct ip_conntrack_tuple)
++							   { { 0, { 0 } },
++				  				 { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
++
++				expect.expectfn =3D NULL;
++
++				DEBUGP ("ip_conntrack_amanda_help: "
++					"expect_related: %u.%u.%u.%u:%u - "
++					"%u.%u.%u.%u:%u\n",
++					NIPQUAD(expect.tuple.src.ip),
++					ntohs(expect.tuple.src.u.tcp.port),
++					NIPQUAD(expect.tuple.dst.ip),
++					ntohs(expect.tuple.dst.u.tcp.port));
++				if (ip_conntrack_expect_related(ct, &expect) =3D=3D
++				    -EEXIST) {
++					;
++					/* this must be a packet being resent */
++					/* XXX - how do I get the
++					 *       ip_conntrack_expect that
++					 *       already exists so that I can
++					 *       update the .seq so that the
++					 *       nat module rewrites the port
++					 *       numbers?
++					 *       Perhaps I should use the
++					 *       exp_amanda_info instead of
++					 *       .seq.
++					 */
++				}
++				UNLOCK_BH(&ip_amanda_lock);
++			} /* if memcmp(conns) */
++		} /* for .. NUM_MSGS */
++		data++;
++	} /* while (*data !=3D 0x0a && data < data_limit) */
++
++	return NF_ACCEPT;
++}
++
++static struct ip_conntrack_helper amanda_helper;
++
++static void fini(void)
++{
++	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
++	ip_conntrack_helper_unregister(&amanda_helper);
++}
++
++static int __init init(void)
++{
++	int ret;
++
++	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
++	amanda_helper.tuple.src.u.udp.port =3D htons(10080);
++	amanda_helper.tuple.dst.protonum =3D IPPROTO_UDP;
++	amanda_helper.mask.src.u.udp.port =3D 0xFFFF;
++	amanda_helper.mask.dst.protonum =3D 0xFFFF;
++	amanda_helper.max_expected =3D NUM_MSGS;
++	amanda_helper.timeout =3D 180;
++	amanda_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
++	amanda_helper.me =3D ip_conntrack_amanda;
++	amanda_helper.help =3D help;
++	amanda_helper.name =3D "amanda";
++
++	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
++
++	ret =3D ip_conntrack_helper_register(&amanda_helper);
++
++	if (ret) {
++		printk("ip_ct_amanda: ERROR registering helper\n");
++		fini();
++		return -EBUSY;
++	}
++	return 0;
++}
++
++module_init(init);
++module_exit(fini);
+diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_nat_amanda.c l=
inux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_nat_amanda.c
+--- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_nat_amanda.c	1969-12=
-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_nat_amanda.c	2002-=
08-16 04:24:51.000000000 -0400
+@@ -0,0 +1,226 @@
++/* Amanda extension for TCP NAT alteration.
++ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
++ * based on a copy of HW's ip_nat_irc.c as well as other modules
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *	Module load syntax:
++ * 	insmod ip_nat_amanda.o
++ */
++
++#include <linux/module.h>
++#include <linux/netfilter_ipv4.h>
++#include <linux/ip.h>
++#include <linux/udp.h>
++#include <linux/kernel.h>
++#include <net/tcp.h>
++#include <net/udp.h>
++
++#include <linux/netfilter_ipv4/ip_nat.h>
++#include <linux/netfilter_ipv4/ip_nat_helper.h>
++#include <linux/netfilter_ipv4/ip_nat_rule.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
++
++
++#if 0
++#define DEBUGP printk
++#define DUMP_OFFSET(x)	printk("offset_before=3D%d, offset_after=3D%d, cor=
rection_pos=3D%u\n", x->offset_before, x->offset_after, x->correction_pos);
++#else
++#define DEBUGP(format, args...)
++#define DUMP_OFFSET(x)
++#endif
++
++MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
++MODULE_DESCRIPTION("Amanda network address translation module");
++MODULE_LICENSE("GPL");
++
++/* protects amanda part of conntracks */
++DECLARE_LOCK_EXTERN(ip_amanda_lock);
++
++static unsigned int
++amanda_nat_expected(struct sk_buff **pskb,
++		 unsigned int hooknum,
++		 struct ip_conntrack *ct,
++		 struct ip_nat_info *info)
++{
++	struct ip_nat_multi_range mr;
++	u_int32_t newdstip, newsrcip, newip;
++	u_int16_t port;
++	struct ip_ct_amanda_expect *exp_info;
++	struct ip_conntrack *master =3D master_ct(ct);
++
++	IP_NF_ASSERT(info);
++	IP_NF_ASSERT(master);
++
++	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
++
++	DEBUGP("nat_expected: We have a connection!\n");
++	exp_info =3D &ct->master->help.exp_amanda_info;
++
++	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
++	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
++	DEBUGP("nat_expected: %u.%u.%u.%u->%u.%u.%u.%u\n",
++	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
++
++	port =3D exp_info->port;
++
++	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
++		newip =3D newsrcip;
++	else
++		newip =3D newdstip;
++
++	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
++
++	mr.rangesize =3D 1;
++	/* We don't want to manip the per-protocol, just the IPs. */
++	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
++	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
++
++	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {
++		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
++		mr.range[0].min =3D mr.range[0].max
++			=3D ((union ip_conntrack_manip_proto)
++				{ htons(port) });
++	}
++
++	return ip_nat_setup_info(ct, &mr, hooknum);
++}
++
++static int amanda_data_fixup(struct ip_conntrack *ct,
++			  struct sk_buff **pskb,
++			  enum ip_conntrack_info ctinfo,
++			  struct ip_conntrack_expect *expect)
++{
++	u_int32_t newip;
++	/* DATA 99999 MESG 99999 INDEX 99999 */
++	char buffer[6];
++	struct ip_conntrack_expect *exp =3D expect;
++	struct ip_ct_amanda_expect *ct_amanda_info =3D &exp->help.exp_amanda_inf=
o;
++	struct ip_conntrack_tuple t =3D exp->tuple;
++	int port;
++
++	MUST_BE_LOCKED(&ip_amanda_lock);
++
++	newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
++	DEBUGP ("ip_nat_amanda_help: newip =3D %u.%u.%u.%u\n", NIPQUAD(newip));
++
++	/* Alter conntrack's expectations. */
++
++	/* We can read expect here without conntrack lock, since it's
++	   only set in ip_conntrack_amanda, with ip_amanda_lock held
++	   writable */
++
++	t.dst.ip =3D newip;
++	for (port =3D ct_amanda_info->port + 10; port !=3D 0; port++) {
++		t.dst.u.tcp.port =3D htons(port);
++		if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)
++			break;
++	}
++
++	if (port =3D=3D 0)
++		return 0;
++
++	sprintf(buffer, "%u", port);
++
++	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, /* XXX exp->seq */ ct_=
amanda_info->offset,=20
++					ct_amanda_info->len, buffer, strlen(buffer));
++}
++
++static unsigned int help(struct ip_conntrack *ct,
++			 struct ip_conntrack_expect *exp,
++			 struct ip_nat_info *info,
++			 enum ip_conntrack_info ctinfo,
++			 unsigned int hooknum,
++			 struct sk_buff **pskb)
++{
++	int dir;
++
++	if (!exp)
++		DEBUGP("ip_nat_amanda: no exp!!");
++	=09
++	/* Only mangle things once: original direction in POST_ROUTING
++	   and reply direction on PRE_ROUTING. */
++	dir =3D CTINFO2DIR(ctinfo);
++	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINA=
L)
++	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY=
))) {
++		DEBUGP("ip_nat_amanda_help: Not touching dir %s at hook %s\n",
++		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
++		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
++		return NF_ACCEPT;
++	}
++	DEBUGP("ip_nat_amanda_help: got beyond not touching: dir %s at hook %s f=
or expect: ",
++		   dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		   hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		   : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		     : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
++		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
++	DUMP_TUPLE(&exp->tuple);
++
++	LOCK_BH(&ip_amanda_lock);
++// XXX	if (exp->seq !=3D 0)
++	if (exp->help.exp_amanda_info.offset !=3D 0)
++		/*  if this packet has a "seq" it needs to have it's content mangled */
++		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
++			UNLOCK_BH(&ip_amanda_lock);
++			DEBUGP("ip_nat_amanda: NF_DROP\n");
++			return NF_DROP;
++		}
++	exp->help.exp_amanda_info.offset =3D 0;
++	UNLOCK_BH(&ip_amanda_lock);
++
++	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
++	return NF_ACCEPT;
++}
++
++static struct ip_nat_helper ip_nat_amanda_helper;
++
++/* This function is intentionally _NOT_ defined as  __exit, because
++ * it is needed by init() */
++static void fini(void)
++{
++	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
++	ip_nat_helper_unregister(&ip_nat_amanda_helper);
++}
++
++static int __init init(void)
++{
++	int ret =3D 0;
++	struct ip_nat_helper *hlpr;
++
++	hlpr =3D &ip_nat_amanda_helper;
++	memset(hlpr, 0, sizeof(struct ip_nat_helper));
++
++	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
++	hlpr->tuple.src.u.udp.port =3D htons(10080);
++	hlpr->mask.src.u.udp.port =3D 0xFFFF;
++	hlpr->mask.dst.protonum =3D 0xFFFF;
++	hlpr->help =3D help;
++	hlpr->flags =3D 0;
++	hlpr->me =3D THIS_MODULE;
++	hlpr->expect =3D amanda_nat_expected;
++
++	hlpr->name =3D "amanda";
++
++	DEBUGP
++	    ("ip_nat_amanda: Trying to register nat helper\n");
++	ret =3D ip_nat_helper_register(hlpr);
++
++	if (ret) {
++		printk
++		    ("ip_nat_amanda: error registering nat helper\n");
++		fini();
++		return 1;
++	}
++	return ret;
++}
++
++
++module_init(init);
++module_exit(fini);
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch~ .=
./netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch~
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch~	1969-12-31 19:00:00.0=
00000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch~	2002-08-28=
 04:15:43.000000000 -0400
@@ -0,0 +1,486 @@
+diff -uNr linux-2.4.18-6mdk-pom-clean/include/linux/netfilter_ipv4/ip_conn=
track_amanda.h linux-2.4.18-6mdkuml-48um-pom/include/linux/netfilter_ipv4/i=
p_conntrack_amanda.h
+--- linux-2.4.18-6mdk-pom-clean/include/linux/netfilter_ipv4/ip_conntrack_=
amanda.h	1969-12-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/include/linux/netfilter_ipv4/ip_conntrac=
k_amanda.h	2002-08-16 04:11:23.000000000 -0400
+@@ -0,0 +1,28 @@
++#ifndef _IP_CONNTRACK_AMANDA_H
++#define _IP_CONNTRACK_AMANDA_H
++/* AMANDA tracking. */
++
++#ifdef __KERNEL__
++
++#include <linux/netfilter_ipv4/lockhelp.h>
++
++/* Protects amanda part of conntracks */
++DECLARE_LOCK_EXTERN(ip_amanda_lock);
++
++#endif
++
++struct conn {
++	char* match;
++	int matchlen;
++};
++
++#define NUM_MSGS 	3
++
++
++struct ip_ct_amanda_expect
++{
++	u_int16_t port;		/* port number of this expectation */
++	u_int16_t offset;	/* offset of the port specification in ctrl packet */
++	u_int16_t len;		/* the length of the port number specification */
++};
++
++#endif /* _IP_CONNTRACK_AMANDA_H */
+diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_aman=
da.c linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c
+--- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_amanda.c	1=
969-12-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c=
	2002-08-16 04:24:25.000000000 -0400
+@@ -0,0 +1,219 @@
++/* Amanda extension for IP connection tracking, Version 0.1
++ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
++ * based on HW's ip_conntrack_irc.c	as well as other modules
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *	Module load syntax:
++ * 	insmod ip_conntrack_amanda.o
++ *
++ */
++
++#include <linux/module.h>
++#include <linux/netfilter.h>
++#include <linux/ip.h>
++#include <net/checksum.h>
++#include <net/udp.h>
++
++#include <linux/netfilter_ipv4/lockhelp.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
++
++MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
++MODULE_DESCRIPTION("Amanda connection tracking module");
++MODULE_LICENSE("GPL");
++
++DECLARE_LOCK(ip_amanda_lock);
++struct module *ip_conntrack_amanda =3D THIS_MODULE;
++
++#define MAXMATCHLEN	6
++struct conn conns[NUM_MSGS] =3D {
++	{"DATA ", 5},
++	{"MESG ", 5},
++	{"INDEX ", 6},
++};
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++
++/* FIXME: This should be in userspace.  Later. */
++static int help(const struct iphdr *iph, size_t len,
++		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
++{
++	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
++	u_int32_t udplen =3D len - iph->ihl * 4;
++	u_int32_t datalen =3D udplen - sizeof(struct udphdr);
++	char *data =3D (char *)udph + sizeof(struct udphdr);
++	char *datap =3D data;
++	char *data_limit =3D (char *) data + datalen;
++	int dir =3D CTINFO2DIR(ctinfo);
++	struct ip_ct_amanda *info =3D
++				(struct ip_ct_amanda *)&ct->help.ct_ftp_info;
++
++	/* Can't track connections formed before we registered */
++	if (!info)
++		return NF_ACCEPT;
++
++	/* If packet is coming from Amanda server */
++	if (dir =3D=3D IP_CT_DIR_ORIGINAL)
++		return NF_ACCEPT;
++
++	/* Not whole UDP header? */
++	if (udplen < sizeof(struct udphdr)) {
++		printk("ip_conntrack_amanda_help: udplen =3D %u\n",
++		       (unsigned)udplen);
++		return NF_ACCEPT;
++	}
++
++	/* Checksum invalid?  Ignore. */
++	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
++			      csum_partial((char *)udph, udplen, 0))) {
++		DEBUGP("ip_ct_talk_help: bad csum: %p %u %u.%u.%u.%u "
++		       "%u.%u.%u.%u\n",
++		       udph, udplen, NIPQUAD(iph->saddr),
++		       NIPQUAD(iph->daddr));
++		return NF_ACCEPT;
++	}
++=09
++	/* Search for the CONNECT string */
++	while (data < data_limit) {
++		if (!memcmp(data, "CONNECT ", 8)) {
++			break;
++		}
++		data++;
++	}
++	if (memcmp(data, "CONNECT ", 8))
++		return NF_ACCEPT;
++
++	DEBUGP("ip_conntrack_amanda_help: CONNECT found in connection "
++		   "%u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
++		   NIPQUAD(iph->saddr), htons(udph->source),
++		   NIPQUAD(iph->daddr), htons(udph->dest));
++	data +=3D 8;
++	while (*data !=3D 0x0a && data < data_limit) {
++
++		int i;
++
++		for (i =3D 0; i < NUM_MSGS; i++) {
++			if (!memcmp(data, conns[i].match,
++				   conns[i].matchlen)) {
++
++				char *portchr;
++				struct ip_conntrack_expect expect;
++				struct ip_ct_amanda_expect
++				    *exp_amanda_info =3D
++					&expect.help.exp_amanda_info;
++
++				memset(&expect, 0, sizeof(expect));
++
++				data +=3D conns[i].matchlen;
++				/* this is not really tcp, but let's steal an
++				 * idea from a tcp stream helper :-)
++				 */
++				// XXX expect.seq =3D data - datap;
++				exp_amanda_info->offset =3D data - datap;
++// XXX DEBUGP("expect.seq =3D %p - %p =3D %d\n", data, datap, expect.seq);
++DEBUGP("exp_amanda_info->offset =3D %p - %p =3D %d\n", data, datap, exp_a=
manda_info->offset);
++				portchr =3D data;
++				exp_amanda_info->port =3D
++				    simple_strtoul(data, &data, 10);
++				exp_amanda_info->len =3D data - portchr;
++
++				/* eat whitespace */
++				while (*data =3D=3D ' ')
++					data++;
++				DEBUGP ("ip_conntrack_amanda_help: "
++					"CONNECT %s request with port "
++					"%u found\n", conns[i].match,
++					exp_amanda_info->port);
++
++				LOCK_BH(&ip_amanda_lock);
++
++				expect.tuple =3D ((struct ip_conntrack_tuple)
++						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
++						  { 0 } },
++				  		{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
++						  { htons(exp_amanda_info->port) },
++				    	  IPPROTO_TCP }});
++				expect.mask =3D ((struct ip_conntrack_tuple)
++							   { { 0, { 0 } },
++				  				 { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
++
++				expect.expectfn =3D NULL;
++
++				DEBUGP ("ip_conntrack_amanda_help: "
++					"expect_related: %u.%u.%u.%u:%u - "
++					"%u.%u.%u.%u:%u\n",
++					NIPQUAD(expect.tuple.src.ip),
++					ntohs(expect.tuple.src.u.tcp.port),
++					NIPQUAD(expect.tuple.dst.ip),
++					ntohs(expect.tuple.dst.u.tcp.port));
++				if (ip_conntrack_expect_related(ct, &expect) =3D=3D
++				    -EEXIST) {
++					;
++					/* this must be a packet being resent */
++					/* XXX - how do I get the
++					 *       ip_conntrack_expect that
++					 *       already exists so that I can
++					 *       update the .seq so that the
++					 *       nat module rewrites the port
++					 *       numbers?
++					 *       Perhaps I should use the
++					 *       exp_amanda_info instead of
++					 *       .seq.
++					 */
++				}
++				UNLOCK_BH(&ip_amanda_lock);
++			} /* if memcmp(conns) */
++		} /* for .. NUM_MSGS */
++		data++;
++	} /* while (*data !=3D 0x0a && data < data_limit) */
++
++	return NF_ACCEPT;
++}
++
++static struct ip_conntrack_helper amanda_helper;
++
++static void fini(void)
++{
++	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
++	ip_conntrack_helper_unregister(&amanda_helper);
++}
++
++static int __init init(void)
++{
++	int ret;
++
++	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
++	amanda_helper.tuple.src.u.udp.port =3D htons(10080);
++	amanda_helper.tuple.dst.protonum =3D IPPROTO_UDP;
++	amanda_helper.mask.src.u.udp.port =3D 0xFFFF;
++	amanda_helper.mask.dst.protonum =3D 0xFFFF;
++	amanda_helper.max_expected =3D NUM_MSGS;
++	amanda_helper.timeout =3D 180;
++	amanda_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
++	amanda_helper.me =3D ip_conntrack_amanda;
++	amanda_helper.help =3D help;
++	amanda_helper.name =3D "amanda";
++
++	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
++
++	ret =3D ip_conntrack_helper_register(&amanda_helper);
++
++	if (ret) {
++		printk("ip_ct_amanda: ERROR registering helper\n");
++		fini();
++		return -EBUSY;
++	}
++	return 0;
++}
++
++module_init(init);
++module_exit(fini);
+diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_nat_amanda.c l=
inux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_nat_amanda.c
+--- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_nat_amanda.c	1969-12=
-31 19:00:00.000000000 -0500
++++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_nat_amanda.c	2002-=
08-16 04:24:51.000000000 -0400
+@@ -0,0 +1,226 @@
++/* Amanda extension for TCP NAT alteration.
++ * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
++ * based on a copy of HW's ip_nat_irc.c as well as other modules
++ *
++ *      This program is free software; you can redistribute it and/or
++ *      modify it under the terms of the GNU General Public License
++ *      as published by the Free Software Foundation; either version
++ *      2 of the License, or (at your option) any later version.
++ *
++ *	Module load syntax:
++ * 	insmod ip_nat_amanda.o
++ */
++
++#include <linux/module.h>
++#include <linux/netfilter_ipv4.h>
++#include <linux/ip.h>
++#include <linux/udp.h>
++#include <linux/kernel.h>
++#include <net/tcp.h>
++#include <net/udp.h>
++
++#include <linux/netfilter_ipv4/ip_nat.h>
++#include <linux/netfilter_ipv4/ip_nat_helper.h>
++#include <linux/netfilter_ipv4/ip_nat_rule.h>
++#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
++#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
++
++
++#if 0
++#define DEBUGP printk
++#define DUMP_OFFSET(x)	printk("offset_before=3D%d, offset_after=3D%d, cor=
rection_pos=3D%u\n", x->offset_before, x->offset_after, x->correction_pos);
++#else
++#define DEBUGP(format, args...)
++#define DUMP_OFFSET(x)
++#endif
++
++MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
++MODULE_DESCRIPTION("Amanda network address translation module");
++MODULE_LICENSE("GPL");
++
++/* protects amanda part of conntracks */
++DECLARE_LOCK_EXTERN(ip_amanda_lock);
++
++static unsigned int
++amanda_nat_expected(struct sk_buff **pskb,
++		 unsigned int hooknum,
++		 struct ip_conntrack *ct,
++		 struct ip_nat_info *info)
++{
++	struct ip_nat_multi_range mr;
++	u_int32_t newdstip, newsrcip, newip;
++	u_int16_t port;
++	struct ip_ct_amanda_expect *exp_info;
++	struct ip_conntrack *master =3D master_ct(ct);
++
++	IP_NF_ASSERT(info);
++	IP_NF_ASSERT(master);
++
++	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
++
++	DEBUGP("nat_expected: We have a connection!\n");
++	exp_info =3D &ct->master->help.exp_amanda_info;
++
++	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
++	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
++	DEBUGP("nat_expected: %u.%u.%u.%u->%u.%u.%u.%u\n",
++	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
++
++	port =3D exp_info->port;
++
++	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
++		newip =3D newsrcip;
++	else
++		newip =3D newdstip;
++
++	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
++
++	mr.rangesize =3D 1;
++	/* We don't want to manip the per-protocol, just the IPs. */
++	mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS;
++	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
++
++	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {
++		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
++		mr.range[0].min =3D mr.range[0].max
++			=3D ((union ip_conntrack_manip_proto)
++				{ htons(port) });
++	}
++
++	return ip_nat_setup_info(ct, &mr, hooknum);
++}
++
++static int amanda_data_fixup(struct ip_conntrack *ct,
++			  struct sk_buff **pskb,
++			  enum ip_conntrack_info ctinfo,
++			  struct ip_conntrack_expect *expect)
++{
++	u_int32_t newip;
++	/* DATA 99999 MESG 99999 INDEX 99999 */
++	char buffer[6];
++	struct ip_conntrack_expect *exp =3D expect;
++	struct ip_ct_amanda_expect *ct_amanda_info =3D &exp->help.exp_amanda_inf=
o;
++	struct ip_conntrack_tuple t =3D exp->tuple;
++	int port;
++
++	MUST_BE_LOCKED(&ip_amanda_lock);
++
++	newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
++	DEBUGP ("ip_nat_amanda_help: newip =3D %u.%u.%u.%u\n", NIPQUAD(newip));
++
++	/* Alter conntrack's expectations. */
++
++	/* We can read expect here without conntrack lock, since it's
++	   only set in ip_conntrack_amanda, with ip_amanda_lock held
++	   writable */
++
++	t.dst.ip =3D newip;
++	for (port =3D ct_amanda_info->port + 10; port !=3D 0; port++) {
++		t.dst.u.tcp.port =3D htons(port);
++		if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)
++			break;
++	}
++
++	if (port =3D=3D 0)
++		return 0;
++
++	sprintf(buffer, "%u", port);
++
++	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, /* XXX exp->seq */ ct_=
amanda_info->offset,=20
++					ct_amanda_info->len, buffer, strlen(buffer));
++}
++
++static unsigned int help(struct ip_conntrack *ct,
++			 struct ip_conntrack_expect *exp,
++			 struct ip_nat_info *info,
++			 enum ip_conntrack_info ctinfo,
++			 unsigned int hooknum,
++			 struct sk_buff **pskb)
++{
++	int dir;
++
++	if (!exp)
++		DEBUGP("ip_nat_amanda: no exp!!");
++	=09
++	/* Only mangle things once: original direction in POST_ROUTING
++	   and reply direction on PRE_ROUTING. */
++	dir =3D CTINFO2DIR(ctinfo);
++	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINA=
L)
++	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY=
))) {
++		DEBUGP("ip_nat_amanda_help: Not touching dir %s at hook %s\n",
++		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
++		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
++		return NF_ACCEPT;
++	}
++	DEBUGP("ip_nat_amanda_help: got beyond not touching: dir %s at hook %s f=
or expect: ",
++		   dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
++		   hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
++		   : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
++		     : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
++		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
++	DUMP_TUPLE(&exp->tuple);
++
++	LOCK_BH(&ip_amanda_lock);
++// XXX	if (exp->seq !=3D 0)
++	if (exp->help.exp_amanda_info.offset !=3D 0)
++		/*  if this packet has a "seq" it needs to have it's content mangled */
++		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
++			UNLOCK_BH(&ip_amanda_lock);
++			DEBUGP("ip_nat_amanda: NF_DROP\n");
++			return NF_DROP;
++		}
++	exp->help.exp_amanda_info.offset =3D 0;
++	UNLOCK_BH(&ip_amanda_lock);
++
++	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
++	return NF_ACCEPT;
++}
++
++static struct ip_nat_helper ip_nat_amanda_helper;
++
++/* This function is intentionally _NOT_ defined as  __exit, because
++ * it is needed by init() */
++static void fini(void)
++{
++	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
++	ip_nat_helper_unregister(&ip_nat_amanda_helper);
++}
++
++static int __init init(void)
++{
++	int ret =3D 0;
++	struct ip_nat_helper *hlpr;
++
++	hlpr =3D &ip_nat_amanda_helper;
++	memset(hlpr, 0, sizeof(struct ip_nat_helper));
++
++	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
++	hlpr->tuple.src.u.udp.port =3D htons(10080);
++	hlpr->mask.src.u.udp.port =3D 0xFFFF;
++	hlpr->mask.dst.protonum =3D 0xFFFF;
++	hlpr->help =3D help;
++	hlpr->flags =3D 0;
++	hlpr->me =3D THIS_MODULE;
++	hlpr->expect =3D amanda_nat_expected;
++
++	hlpr->name =3D "amanda";
++
++	DEBUGP
++	    ("ip_nat_amanda: Trying to register nat helper\n");
++	ret =3D ip_nat_helper_register(hlpr);
++
++	if (ret) {
++		printk
++		    ("ip_nat_amanda: error registering nat helper\n");
++		fini();
++		return 1;
++	}
++	return ret;
++}
++
++
++module_init(init);
++module_exit(fini);
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.co=
nfig.in ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.config.=
in
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.config.in	1969-12-31 1=
9:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.config.in	2=
002-08-16 14:00:31.000000000 -0400
@@ -0,0 +1,2 @@
+  dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  Amanda protocol support' CONFIG_IP_NF_AMANDA $CONFIG_IP_=
NF_CONNTRACK
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.co=
nfig.in-2 ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.confi=
g.in-2
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.config.in-2	1969-12-31=
 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.config.in-2=
	2002-08-16 14:03:01.000000000 -0400
@@ -0,0 +1,8 @@
+      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
+      if [ "$CONFIG_IP_NF_AMANDA" =3D "m" ]; then
+       define_tristate CONFIG_IP_NF_NAT_AMANDA m
+      else
+        if [ "$CONFIG_IP_NF_AMANDA" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_AMANDA $CONFIG_IP_NF_NAT
+        fi
+      fi
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.co=
nfigure.help ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.co=
nfigure.help
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.configure.help	1969-12=
-31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.configure.h=
elp	2002-08-16 13:53:48.000000000 -0400
@@ -0,0 +1,13 @@
+CONFIG_IP_NF_IRC
+Amanda protocol support
+CONFIG_IP_NF_AMANDA
+  If you are running the Amanda backup package (http://www.amanda.org/)
+  on this machine or machines that will be MASQUERADED through this
+  machine, then you may want to enable this feature.  This allows the
+  connection tracking and natting code to allow the sub-channels that
+  Amanda requires for communication of the backup data, messages and
+  index.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.he=
lp ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.help
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.help	1969-12-31 19:00:=
00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.help	2002-0=
8-16 13:56:26.000000000 -0400
@@ -0,0 +1,5 @@
+Author: Brian J. Murrell <netfilter@interlinx.bc.ca>
+Status: Works for me
+
+This adds CONFIG_IP_NF_AMANDA:
+Connection tracking and NATting for the Amanda backup protocol.
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip=
_conntrack.h ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.ip=
_conntrack.h
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrack.h	1969-12=
-31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrac=
k.h	2002-08-16 14:05:08.000000000 -0400
@@ -0,0 +1,3 @@
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
+
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip=
_conntrack.h-2 ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.=
ip_conntrack.h-2
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrack.h-2	1969-=
12-31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrac=
k.h-2	2002-08-21 05:57:34.000000000 -0400
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_amanda_expect exp_amanda_info;
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip=
_conntrack.h-2~ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch=
.ip_conntrack.h-2~
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrack.h-2~	1969=
-12-31 19:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.ip_conntrac=
k.h-2~	2002-08-16 15:02:23.000000000 -0400
@@ -0,0 +1,2 @@
+		/* insert conntrack helper private data (expect) here */
+		struct ip_ct_amanda_expect exp_amanda_info;
diff --exclude CVS -Nur ./patch-o-matic/extra/amanda-conntrack-nat.patch.ma=
kefile ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.makefile
--- ./patch-o-matic/extra/amanda-conntrack-nat.patch.makefile	1969-12-31 19=
:00:00.000000000 -0500
+++ ../netfilter/patch-o-matic/extra/amanda-conntrack-nat.patch.makefile	20=
02-08-16 14:09:25.000000000 -0400
@@ -0,0 +1,9 @@
+obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
+
+# Amanda protocol support
+obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o
+obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
+ifdef CONFIG_IP_NF_NAT_AMANDA
+	export-objs +=3D ip_conntrack_amanda.o
+endif
+

--at6+YcpfzWZg/htY--

--pY3vCvL1qV+PayAL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9gkdFl3EQlGLyuXARAtO6AJ4zIYhAYPzth08/BydRcQmksbiKkQCgym20
541nrzXOqs3eOIEdFq5BWCY=
=qrXH
-----END PGP SIGNATURE-----

--pY3vCvL1qV+PayAL--
--pY3vCvL1qV+PayAL--
