From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: major amanda helper update
Date: Sun, 30 Nov 2003 18:20:33 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130125033.GD26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
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


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the third netfilter patch, please apply.

Author: Patrick McHardy <kaber@trash.net>

Fix various issues with the amanda conntrack+NAT helpers

ip_conntrack_amanda:
- udp checksum checked even if not set
- memory not validated to be inside packet at all or validated like
  this: if (*data and data < data_limit)
- would create expectation with port 0 which makes nat-helper throw away
  packet (which makes exploiting the race-condition trivial even on UP)
- expectation had no mask.src.* set so connections were accepted from
  anywhere
- helper_unregister called after failed helper_register

ip_nat_amanda:
- drops packet if amanda_data_fixup fails without clearing the offset
  field in the expectation which is used as a flag to indicate that the
  current packet needs mangling. Problem arises from the fact that the
  conntrack helper creates multiple expectations at once and even if it
  clears the offset field for the current expectation the following
  expectations will not have it cleared and will mangle the next packet
  they see.
- same unregister after failed register problem


diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_amanda.h b/include/li=
nux/netfilter_ipv4/ip_conntrack_amanda.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	Sun Sep 28 04:40:4=
7 2003
+++ b/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	Sun Sep 28 04:40:4=
7 2003
@@ -2,28 +2,11 @@
 #define _IP_CONNTRACK_AMANDA_H
 /* AMANDA tracking. */
=20
-#ifdef __KERNEL__
-
-#include <linux/netfilter_ipv4/lockhelp.h>
-
-/* Protects amanda part of conntracks */
-DECLARE_LOCK_EXTERN(ip_amanda_lock);
-
-#endif
-
-struct conn {
-	char* match;
-	int matchlen;
-};
-
-#define NUM_MSGS 	3
-
-
 struct ip_ct_amanda_expect
 {
 	u_int16_t port;		/* port number of this expectation */
-	u_int16_t offset;	/* offset of the port specification in ctrl packet */
-	u_int16_t len;		/* the length of the port number specification */
+	u_int16_t offset;	/* offset of port in ctrl packet */
+	u_int16_t len;		/* length of the port number string */
 };
=20
 #endif /* _IP_CONNTRACK_AMANDA_H */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/i=
p_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Sep 28 04:40:47 2003
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	Sun Sep 28 04:40:47 2003
@@ -18,13 +18,13 @@
  *
  */
=20
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
 #include <net/udp.h>
=20
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
=20
@@ -36,176 +36,96 @@
 MODULE_PARM(master_timeout, "i");
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
=20
-DECLARE_LOCK(ip_amanda_lock);
-struct module *ip_conntrack_amanda =3D THIS_MODULE;
-
-#define MAXMATCHLEN	6
-struct conn conns[NUM_MSGS] =3D {
-	{"DATA ", 5},
-	{"MESG ", 5},
-	{"INDEX ", 6},
+static struct { char *match; int len; } conns[] =3D {
+	{ "DATA ", 5},
+	{ "MESG ", 5},
+	{ "INDEX ", 6},
 };
=20
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
+#define NUM_MSGS 3
=20
=20
-/* FIXME: This should be in userspace.  Later. */
 static int help(const struct iphdr *iph, size_t len,
-		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
+                struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
+	struct ip_conntrack_expect exp;
+	struct ip_ct_amanda_expect *exp_amanda_info;
 	struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
 	u_int32_t udplen =3D len - iph->ihl * 4;
 	u_int32_t datalen =3D udplen - sizeof(struct udphdr);
 	char *data =3D (char *)udph + sizeof(struct udphdr);
-	char *datap =3D data;
-	char *data_limit =3D (char *) data + datalen;
-	int dir =3D CTINFO2DIR(ctinfo);
-	struct ip_ct_amanda *info =3D
-				(struct ip_ct_amanda *)&ct->help.ct_ftp_info;
-
-	/* Can't track connections formed before we registered */
-	if (!info)
-		return NF_ACCEPT;
-
-	/* increase the UDP timeout of the master connection as replies from
-	 * Amanda clients to the server can be quite delayed */
-	ip_ct_refresh(ct, master_timeout * HZ);
+	char *data_limit =3D data + datalen;
+	char *start =3D data, *tmp;
+	int i;
=20
-	/* If packet is coming from Amanda server */
-	if (dir =3D=3D IP_CT_DIR_ORIGINAL)
+	/* Only look at packets from the Amanda server */
+	if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL)
 		return NF_ACCEPT;
=20
-	/* Not whole UDP header? */
 	if (udplen < sizeof(struct udphdr)) {
-		printk("ip_conntrack_amanda_help: udplen =3D %u\n",
-		       (unsigned)udplen);
+		if (net_ratelimit())
+			printk("amanda_help: udplen =3D %u\n", udplen);
 		return NF_ACCEPT;
 	}
=20
-	/* Checksum invalid?  Ignore. */
-	if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
-			      csum_partial((char *)udph, udplen, 0))) {
-		DEBUGP("ip_ct_talk_help: bad csum: %p %u %u.%u.%u.%u "
-		       "%u.%u.%u.%u\n",
-		       udph, udplen, NIPQUAD(iph->saddr),
-		       NIPQUAD(iph->daddr));
+	if (udph->check &&=20
+	    csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
+	                      csum_partial((char *)udph, udplen, 0)))
 		return NF_ACCEPT;
-	}
+
+	/* increase the UDP timeout of the master connection as replies from
+	 * Amanda clients to the server can be quite delayed */
+	ip_ct_refresh(ct, master_timeout * HZ);
 =09
-	/* Search for the CONNECT string */
-	while (data < data_limit) {
+	/* Search for "CONNECT " string */
+	do {
+		if (data + 8 >=3D data_limit)
+			return NF_ACCEPT;
 		if (!memcmp(data, "CONNECT ", 8)) {
+			data +=3D 8;
 			break;
 		}
 		data++;
-	}
-	if (memcmp(data, "CONNECT ", 8))
-		return NF_ACCEPT;
+	} while(1);
=20
-	DEBUGP("ip_conntrack_amanda_help: CONNECT found in connection "
-		   "%u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
-		   NIPQUAD(iph->saddr), htons(udph->source),
-		   NIPQUAD(iph->daddr), htons(udph->dest));
-	data +=3D 8;
-	while (*data !=3D 0x0a && data < data_limit) {
-
-		int i;
-
-		for (i =3D 0; i < NUM_MSGS; i++) {
-			if (!memcmp(data, conns[i].match,
-				   conns[i].matchlen)) {
-
-				char *portchr;
-				struct ip_conntrack_expect expect;
-				struct ip_ct_amanda_expect
-				    *exp_amanda_info =3D
-					&expect.help.exp_amanda_info;
-
-				memset(&expect, 0, sizeof(expect));
-
-				data +=3D conns[i].matchlen;
-				/* this is not really tcp, but let's steal an
-				 * idea from a tcp stream helper :-)
-				 */
-				// XXX expect.seq =3D data - datap;
-				exp_amanda_info->offset =3D data - datap;
-// XXX DEBUGP("expect.seq =3D %p - %p =3D %d\n", data, datap, expect.seq);
-DEBUGP("exp_amanda_info->offset =3D %p - %p =3D %d\n", data, datap, exp_am=
anda_info->offset);
-				portchr =3D data;
-				exp_amanda_info->port =3D
-				    simple_strtoul(data, &data, 10);
-				exp_amanda_info->len =3D data - portchr;
-
-				/* eat whitespace */
-				while (*data =3D=3D ' ')
-					data++;
-				DEBUGP ("ip_conntrack_amanda_help: "
-					"CONNECT %s request with port "
-					"%u found\n", conns[i].match,
-					exp_amanda_info->port);
-
-				LOCK_BH(&ip_amanda_lock);
-
-				expect.tuple =3D ((struct ip_conntrack_tuple)
-						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
-						  { 0 } },
-				  		{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
-						  { htons(exp_amanda_info->port) },
-				    	  IPPROTO_TCP }});
-				expect.mask =3D ((struct ip_conntrack_tuple)
-							   { { 0, { 0 } },
-				  				 { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
-
-				expect.expectfn =3D NULL;
-
-				DEBUGP ("ip_conntrack_amanda_help: "
-					"expect_related: %u.%u.%u.%u:%u - "
-					"%u.%u.%u.%u:%u\n",
-					NIPQUAD(expect.tuple.src.ip),
-					ntohs(expect.tuple.src.u.tcp.port),
-					NIPQUAD(expect.tuple.dst.ip),
-					ntohs(expect.tuple.dst.u.tcp.port));
-				if (ip_conntrack_expect_related(ct, &expect) =3D=3D
-				    -EEXIST) {
-					;
-					/* this must be a packet being resent */
-					/* XXX - how do I get the
-					 *       ip_conntrack_expect that
-					 *       already exists so that I can
-					 *       update the .seq so that the
-					 *       nat module rewrites the port
-					 *       numbers?
-					 *       Perhaps I should use the
-					 *       exp_amanda_info instead of
-					 *       .seq.
-					 */
-				}
-				UNLOCK_BH(&ip_amanda_lock);
-			} /* if memcmp(conns) */
-		} /* for .. NUM_MSGS */
-		data++;
-	} /* while (*data !=3D 0x0a && data < data_limit) */
+	memset(&exp, 0, sizeof(exp));
+	exp.tuple.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	exp.tuple.dst.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	exp.tuple.dst.protonum =3D IPPROTO_TCP;
+	exp.mask.src.ip =3D 0xFFFFFFFF;
+	exp.mask.dst.ip =3D 0xFFFFFFFF;
+	exp.mask.dst.protonum =3D 0xFFFF;
+	exp.mask.dst.u.tcp.port =3D 0xFFFF;
+
+	exp_amanda_info =3D &exp.help.exp_amanda_info;
+	for (i =3D 0; data + conns[i].len < data_limit && *data !=3D '\n'; data++=
) {
+		if (memcmp(data, conns[i].match, conns[i].len))
+			continue;
+		tmp =3D data +=3D conns[i].len;
+		exp_amanda_info->offset =3D data - start;
+		exp_amanda_info->port   =3D simple_strtoul(data, &data, 10);
+		exp_amanda_info->len    =3D data - tmp;
+		if (exp_amanda_info->port =3D=3D 0 || exp_amanda_info->len > 5)
+			break;
+
+		exp.tuple.dst.u.tcp.port =3D htons(exp_amanda_info->port);
+		ip_conntrack_expect_related(ct, &exp);
+		if (++i =3D=3D NUM_MSGS)
+			break;
+	}
=20
 	return NF_ACCEPT;
 }
=20
 static struct ip_conntrack_helper amanda_helper;
=20
-static void fini(void)
+static void __exit fini(void)
 {
-	DEBUGP("ip_ct_amanda: unregistering helper for port 10080\n");
 	ip_conntrack_helper_unregister(&amanda_helper);
 }
=20
 static int __init init(void)
 {
-	int ret;
-
-	memset(&amanda_helper, 0, sizeof(struct ip_conntrack_helper));
 	amanda_helper.tuple.src.u.udp.port =3D htons(10080);
 	amanda_helper.tuple.dst.protonum =3D IPPROTO_UDP;
 	amanda_helper.mask.src.u.udp.port =3D 0xFFFF;
@@ -213,23 +133,12 @@
 	amanda_helper.max_expected =3D NUM_MSGS;
 	amanda_helper.timeout =3D 180;
 	amanda_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
-	amanda_helper.me =3D ip_conntrack_amanda;
+	amanda_helper.me =3D THIS_MODULE;
 	amanda_helper.help =3D help;
 	amanda_helper.name =3D "amanda";
=20
-	DEBUGP("ip_ct_amanda: registering helper for port 10080\n");
-
-	ret =3D ip_conntrack_helper_register(&amanda_helper);
-
-	if (ret) {
-		printk("ip_ct_amanda: ERROR registering helper\n");
-		fini();
-		return -EBUSY;
-	}
-	return 0;
+	return ip_conntrack_helper_register(&amanda_helper);
 }
-
-EXPORT_SYMBOL(ip_amanda_lock);
=20
 module_init(init);
 module_exit(fini);
diff -Nru a/net/ipv4/netfilter/ip_nat_amanda.c b/net/ipv4/netfilter/ip_nat_=
amanda.c
--- a/net/ipv4/netfilter/ip_nat_amanda.c	Sun Sep 28 04:40:47 2003
+++ b/net/ipv4/netfilter/ip_nat_amanda.c	Sun Sep 28 04:40:47 2003
@@ -11,69 +11,45 @@
  * 	insmod ip_nat_amanda.o
  */
=20
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
-#include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/udp.h>
=20
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
-#include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
=20
=20
-#if 0
-#define DEBUGP printk
-#define DUMP_OFFSET(x)	printk("offset_before=3D%d, offset_after=3D%d, corr=
ection_pos=3D%u\n", x->offset_before, x->offset_after, x->correction_pos);
-#else
-#define DEBUGP(format, args...)
-#define DUMP_OFFSET(x)
-#endif
-
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
-MODULE_DESCRIPTION("Amanda network address translation module");
+MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
=20
-/* protects amanda part of conntracks */
-DECLARE_LOCK_EXTERN(ip_amanda_lock);
-
 static unsigned int
 amanda_nat_expected(struct sk_buff **pskb,
-		 unsigned int hooknum,
-		 struct ip_conntrack *ct,
-		 struct ip_nat_info *info)
+                    unsigned int hooknum,
+                    struct ip_conntrack *ct,
+                    struct ip_nat_info *info)
 {
-	struct ip_nat_multi_range mr;
-	u_int32_t newdstip, newsrcip, newip;
-	u_int16_t port;
-	struct ip_ct_amanda_expect *exp_info;
 	struct ip_conntrack *master =3D master_ct(ct);
+	struct ip_ct_amanda_expect *exp_amanda_info;
+	struct ip_nat_multi_range mr;
+	u_int32_t newip;
=20
 	IP_NF_ASSERT(info);
 	IP_NF_ASSERT(master);
-
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
=20
-	DEBUGP("nat_expected: We have a connection!\n");
-	exp_info =3D &ct->master->help.exp_amanda_info;
-
-	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	DEBUGP("nat_expected: %u.%u.%u.%u->%u.%u.%u.%u\n",
-	       NIPQUAD(newsrcip), NIPQUAD(newdstip));
-
-	port =3D exp_info->port;
-
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_SRC)
-		newip =3D newsrcip;
+		newip =3D master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 	else
-		newip =3D newdstip;
-
-	DEBUGP("nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
+		newip =3D master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
=20
 	mr.rangesize =3D 1;
 	/* We don't want to manip the per-protocol, just the IPs. */
@@ -81,121 +57,79 @@
 	mr.range[0].min_ip =3D mr.range[0].max_ip =3D newip;
=20
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {
+		exp_amanda_info =3D &ct->master->help.exp_amanda_info;
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min =3D mr.range[0].max
 			=3D ((union ip_conntrack_manip_proto)
-				{ .udp =3D { htons(port) } });
+				{ .udp =3D { htons(exp_amanda_info->port) } });
 	}
=20
 	return ip_nat_setup_info(ct, &mr, hooknum);
 }
=20
 static int amanda_data_fixup(struct ip_conntrack *ct,
-			  struct sk_buff **pskb,
-			  enum ip_conntrack_info ctinfo,
-			  struct ip_conntrack_expect *expect)
+                             struct sk_buff **pskb,
+                             enum ip_conntrack_info ctinfo,
+                             struct ip_conntrack_expect *exp)
 {
-	u_int32_t newip;
-	/* DATA 99999 MESG 99999 INDEX 99999 */
-	char buffer[6];
-	struct ip_conntrack_expect *exp =3D expect;
-	struct ip_ct_amanda_expect *ct_amanda_info =3D &exp->help.exp_amanda_info;
+	struct ip_ct_amanda_expect *exp_amanda_info;
 	struct ip_conntrack_tuple t =3D exp->tuple;
+	char buffer[sizeof("65535")];
 	u_int16_t port;
=20
-	MUST_BE_LOCKED(&ip_amanda_lock);
-
-	newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	DEBUGP ("ip_nat_amanda_help: newip =3D %u.%u.%u.%u\n", NIPQUAD(newip));
-
 	/* Alter conntrack's expectations. */
-
-	/* We can read expect here without conntrack lock, since it's
-	   only set in ip_conntrack_amanda, with ip_amanda_lock held
-	   writable */
-
-	t.dst.ip =3D newip;
-	for (port =3D ct_amanda_info->port; port !=3D 0; port++) {
+	exp_amanda_info =3D &exp->help.exp_amanda_info;
+	t.dst.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	for (port =3D exp_amanda_info->port; port !=3D 0; port++) {
 		t.dst.u.tcp.port =3D htons(port);
 		if (ip_conntrack_change_expect(exp, &t) =3D=3D 0)
 			break;
 	}
-
 	if (port =3D=3D 0)
 		return 0;
=20
 	sprintf(buffer, "%u", port);
-
-	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo, /* XXX exp->seq */ ct_a=
manda_info->offset,=20
-					ct_amanda_info->len, buffer, strlen(buffer));
+	return ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+	                                exp_amanda_info->offset,
+	                                exp_amanda_info->len,
+	                                buffer, strlen(buffer));
 }
=20
 static unsigned int help(struct ip_conntrack *ct,
-			 struct ip_conntrack_expect *exp,
-			 struct ip_nat_info *info,
-			 enum ip_conntrack_info ctinfo,
-			 unsigned int hooknum,
-			 struct sk_buff **pskb)
+                         struct ip_conntrack_expect *exp,
+                         struct ip_nat_info *info,
+                         enum ip_conntrack_info ctinfo,
+                         unsigned int hooknum,
+                         struct sk_buff **pskb)
 {
-	int dir;
+	int dir =3D CTINFO2DIR(ctinfo);
+	int ret =3D NF_ACCEPT;
=20
-	if (!exp)
-		DEBUGP("ip_nat_amanda: no exp!!");
-	=09
 	/* Only mangle things once: original direction in POST_ROUTING
 	   and reply direction on PRE_ROUTING. */
-	dir =3D CTINFO2DIR(ctinfo);
 	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL)
-	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)=
)) {
-		DEBUGP("ip_nat_amanda_help: Not touching dir %s at hook %s\n",
-		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
-		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
-		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
-		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
+	      || (hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY)=
))
 		return NF_ACCEPT;
-	}
-	DEBUGP("ip_nat_amanda_help: got beyond not touching: dir %s at hook %s fo=
r expect: ",
-		   dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
-		   hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
-		   : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
-		     : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT"
-		       : hooknum =3D=3D NF_IP_LOCAL_IN ? "INPUT" : "???");
-	DUMP_TUPLE(&exp->tuple);
=20
-	LOCK_BH(&ip_amanda_lock);
-// XXX	if (exp->seq !=3D 0)
+	/* if this exectation has a "offset" the packet needs to be mangled */
 	if (exp->help.exp_amanda_info.offset !=3D 0)
-		/*  if this packet has a "seq" it needs to have it's content mangled */
-		if (!amanda_data_fixup(ct, pskb, ctinfo, exp)) {
-			UNLOCK_BH(&ip_amanda_lock);
-			DEBUGP("ip_nat_amanda: NF_DROP\n");
-			return NF_DROP;
-		}
+		if (!amanda_data_fixup(ct, pskb, ctinfo, exp))
+			ret =3D NF_DROP;
 	exp->help.exp_amanda_info.offset =3D 0;
-	UNLOCK_BH(&ip_amanda_lock);
=20
-	DEBUGP("ip_nat_amanda: NF_ACCEPT\n");
-	return NF_ACCEPT;
+	return ret;
 }
=20
 static struct ip_nat_helper ip_nat_amanda_helper;
=20
-/* This function is intentionally _NOT_ defined as  __exit, because
- * it is needed by init() */
-static void fini(void)
+static void __exit fini(void)
 {
-	DEBUGP("ip_nat_amanda: unregistering nat helper\n");
 	ip_nat_helper_unregister(&ip_nat_amanda_helper);
 }
=20
 static int __init init(void)
 {
-	int ret =3D 0;
-	struct ip_nat_helper *hlpr;
-
-	hlpr =3D &ip_nat_amanda_helper;
-	memset(hlpr, 0, sizeof(struct ip_nat_helper));
+	struct ip_nat_helper *hlpr =3D &ip_nat_amanda_helper;
=20
 	hlpr->tuple.dst.protonum =3D IPPROTO_UDP;
 	hlpr->tuple.src.u.udp.port =3D htons(10080);
@@ -205,22 +139,10 @@
 	hlpr->flags =3D 0;
 	hlpr->me =3D THIS_MODULE;
 	hlpr->expect =3D amanda_nat_expected;
-
 	hlpr->name =3D "amanda";
=20
-	DEBUGP
-	    ("ip_nat_amanda: Trying to register nat helper\n");
-	ret =3D ip_nat_helper_register(hlpr);
-
-	if (ret) {
-		printk
-		    ("ip_nat_amanda: error registering nat helper\n");
-		fini();
-		return 1;
-	}
-	return ret;
+	return ip_nat_helper_register(hlpr);
 }
-
=20
 module_init(init);
 module_exit(fini);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yeevXaXGVTD0i/8RAqz+AKCQ7CsCK6HlLNauq3Q8nWOS4UpSkwCgmLT5
8u8iXX8O//dtx8wqIiraRYY=
=HcYQ
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
