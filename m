From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Sat, 15 Dec 2007 13:06:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr>
 <475E639A.9040501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59976 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbXLOMGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:06:07 -0500
In-Reply-To: <475E639A.9040501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 11 2007 11:16, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> A few netfilter modules provide their own union of IPv4 and IPv6
>> address storage. Will unify that in this patch series.
>>=20
>> (1/4): Rename union nf_conntrack_address to union nf_inet_addr and
>> move it to x_tables.h.
>
> netfilter.h seems more appropriate for this than x_tables.h,
> so I'll move it unless there are good reasons not to.
>

Userspace iptables does not seem to properly cope with it, though:

In file included from /ws/linux-2.6/include/linux/netfilter_ipv4.h:8,
                 from=20
/ws/linux-2.6/include/linux/netfilter_ipv4/ip_tables.h:26,
                 from include/libiptc/libiptc.h:6,
                 from libiptc/libip4tc.c:29:
/ws/linux-2.6/include/linux/netfilter.h:53: error: expected=20
specifier-qualifier-list before =E2=80=98__be32=E2=80=99
make: *** [libiptc/libip4tc.o] Error 1


=3D=3D=3D=20

A few netfilter modules provide their own union of IPv4 and IPv6
address storage. Will unify that over time.

This patch will rename union nf_conntrack_address to
union nf_inet_addr and move it to <linux/netfilter.h>.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter.h                   |    6 ++++
 include/linux/netfilter/nf_conntrack_h323.h |    6 ++--
 include/net/netfilter/nf_conntrack_expect.h |    4 +--
 include/net/netfilter/nf_conntrack_tuple.h  |   17 ++++----------
 net/ipv4/netfilter/nf_nat_h323.c            |   10 ++++----
 net/netfilter/nf_conntrack_expect.c         |    4 +--
 net/netfilter/nf_conntrack_ftp.c            |    2 -
 net/netfilter/nf_conntrack_h323_main.c      |   34 ++++++++++++++-----=
---------
 net/netfilter/nf_conntrack_sip.c            |    8 +++---
 net/netfilter/xt_connlimit.c                |   20 ++++++++--------
 10 files changed, 55 insertions(+), 56 deletions(-)

Index: linux-2.6/include/linux/netfilter.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/netfilter.h
+++ linux-2.6/include/linux/netfilter.h
@@ -48,6 +48,12 @@ enum nf_inet_hooks {
 	NF_INET_NUMHOOKS
 };
=20
+union nf_inet_addr {
+	u_int32_t all[4];
+	__be32 ip;
+	__be32 ip6[4];
+};
+
 #ifdef __KERNEL__
 #ifdef CONFIG_NETFILTER
=20
Index: linux-2.6/include/linux/netfilter/nf_conntrack_h323.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/netfilter/nf_conntrack_h323.h
+++ linux-2.6/include/linux/netfilter/nf_conntrack_h323.h
@@ -31,7 +31,7 @@ struct nf_conn;
=20
 extern int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 			 TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 *port);
+			 union nf_inet_addr *addr, __be16 *port);
 extern void nf_conntrack_h245_expect(struct nf_conn *new,
 				     struct nf_conntrack_expect *this);
 extern void nf_conntrack_q931_expect(struct nf_conn *new,
@@ -39,12 +39,12 @@ extern void nf_conntrack_q931_expect(str
 extern int (*set_h245_addr_hook) (struct sk_buff *skb,
 				  unsigned char **data, int dataoff,
 				  H245_TransportAddress *taddr,
-				  union nf_conntrack_address *addr,
+				  union nf_inet_addr *addr,
 				  __be16 port);
 extern int (*set_h225_addr_hook) (struct sk_buff *skb,
 				  unsigned char **data, int dataoff,
 				  TransportAddress *taddr,
-				  union nf_conntrack_address *addr,
+				  union nf_inet_addr *addr,
 				  __be16 port);
 extern int (*set_sig_addr_hook) (struct sk_buff *skb,
 				 struct nf_conn *ct,
Index: linux-2.6/include/net/netfilter/nf_conntrack_expect.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/net/netfilter/nf_conntrack_expect.h
+++ linux-2.6/include/net/netfilter/nf_conntrack_expect.h
@@ -73,8 +73,8 @@ void nf_ct_unexpect_related(struct nf_co
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
 void nf_ct_expect_init(struct nf_conntrack_expect *, int,
-		       union nf_conntrack_address *,
-		       union nf_conntrack_address *,
+		       union nf_inet_addr *,
+		       union nf_inet_addr *,
 		       u_int8_t, __be16 *, __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related(struct nf_conntrack_expect *expect);
Index: linux-2.6/include/net/netfilter/nf_conntrack_tuple.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/net/netfilter/nf_conntrack_tuple.h
+++ linux-2.6/include/net/netfilter/nf_conntrack_tuple.h
@@ -10,6 +10,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_H
 #define _NF_CONNTRACK_TUPLE_H
=20
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
=20
 /* A `tuple' is a structure containing the information to uniquely
@@ -20,15 +21,7 @@
   "non-manipulatable" lines, for the benefit of the NAT code.
 */
=20
-#define NF_CT_TUPLE_L3SIZE	4
-
-/* The l3 protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_address {
-	u_int32_t all[NF_CT_TUPLE_L3SIZE];
-	__be32 ip;
-	__be32 ip6[4];
-};
+#define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->al=
l)
=20
 /* The protocol-specific manipulable parts of the tuple: always in
    network order! */
@@ -57,7 +50,7 @@ union nf_conntrack_man_proto
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man
 {
-	union nf_conntrack_address u3;
+	union nf_inet_addr u3;
 	union nf_conntrack_man_proto u;
 	/* Layer 3 protocol */
 	u_int16_t l3num;
@@ -70,7 +63,7 @@ struct nf_conntrack_tuple
=20
 	/* These are the parts of the tuple which are fixed. */
 	struct {
-		union nf_conntrack_address u3;
+		union nf_inet_addr u3;
 		union {
 			/* Add other protocols here. */
 			__be16 all;
@@ -103,7 +96,7 @@ struct nf_conntrack_tuple
 struct nf_conntrack_tuple_mask
 {
 	struct {
-		union nf_conntrack_address u3;
+		union nf_inet_addr u3;
 		union nf_conntrack_man_proto u;
 	} src;
 };
Index: linux-2.6/net/ipv4/netfilter/nf_nat_h323.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/ipv4/netfilter/nf_nat_h323.c
+++ linux-2.6/net/ipv4/netfilter/nf_nat_h323.c
@@ -76,7 +76,7 @@ static int set_addr(struct sk_buff *skb,
 static int set_h225_addr(struct sk_buff *skb,
 			 unsigned char **data, int dataoff,
 			 TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 port)
+			 union nf_inet_addr *addr, __be16 port)
 {
 	return set_addr(skb, data, dataoff, taddr->ipAddress.ip,
 			addr->ip, port);
@@ -86,7 +86,7 @@ static int set_h225_addr(struct sk_buff=20
 static int set_h245_addr(struct sk_buff *skb,
 			 unsigned char **data, int dataoff,
 			 H245_TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 port)
+			 union nf_inet_addr *addr, __be16 port)
 {
 	return set_addr(skb, data, dataoff,
 			taddr->unicastAddress.iPAddress.network,
@@ -103,7 +103,7 @@ static int set_sig_addr(struct sk_buff *
 	int dir =3D CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
=20
 	for (i =3D 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port)) {
@@ -155,7 +155,7 @@ static int set_ras_addr(struct sk_buff *
 	int dir =3D CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
=20
 	for (i =3D 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
@@ -412,7 +412,7 @@ static int nat_q931(struct sk_buff *skb,
 	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	u_int16_t nated_port =3D ntohs(port);
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
=20
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;
Index: linux-2.6/net/netfilter/nf_conntrack_expect.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/nf_conntrack_expect.c
+++ linux-2.6/net/netfilter/nf_conntrack_expect.c
@@ -226,8 +226,8 @@ struct nf_conntrack_expect *nf_ct_expect
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
=20
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
-		       union nf_conntrack_address *saddr,
-		       union nf_conntrack_address *daddr,
+		       union nf_inet_addr *saddr,
+		       union nf_inet_addr *daddr,
 		       u_int8_t proto, __be16 *src, __be16 *dst)
 {
 	int len;
Index: linux-2.6/net/netfilter/nf_conntrack_ftp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/nf_conntrack_ftp.c
+++ linux-2.6/net/netfilter/nf_conntrack_ftp.c
@@ -358,7 +358,7 @@ static int help(struct sk_buff *skb,
 	unsigned int matchlen, matchoff;
 	struct nf_ct_ftp_master *ct_ftp_info =3D &nfct_help(ct)->help.ct_ftp_=
info;
 	struct nf_conntrack_expect *exp;
-	union nf_conntrack_address *daddr;
+	union nf_inet_addr *daddr;
 	struct nf_conntrack_man cmd =3D {};
 	unsigned int i;
 	int found =3D 0, ends_in_nl;
Index: linux-2.6/net/netfilter/nf_conntrack_h323_main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/nf_conntrack_h323_main.c
+++ linux-2.6/net/netfilter/nf_conntrack_h323_main.c
@@ -50,12 +50,12 @@ MODULE_PARM_DESC(callforward_filter, "on
 int (*set_h245_addr_hook) (struct sk_buff *skb,
 			   unsigned char **data, int dataoff,
 			   H245_TransportAddress *taddr,
-			   union nf_conntrack_address *addr, __be16 port)
+			   union nf_inet_addr *addr, __be16 port)
 			   __read_mostly;
 int (*set_h225_addr_hook) (struct sk_buff *skb,
 			   unsigned char **data, int dataoff,
 			   TransportAddress *taddr,
-			   union nf_conntrack_address *addr, __be16 port)
+			   union nf_inet_addr *addr, __be16 port)
 			   __read_mostly;
 int (*set_sig_addr_hook) (struct sk_buff *skb,
 			  struct nf_conn *ct,
@@ -214,7 +214,7 @@ static int get_tpkt_data(struct sk_buff=20
 /*********************************************************************=
*******/
 static int get_h245_addr(struct nf_conn *ct, unsigned char *data,
 			 H245_TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 *port)
+			 union nf_inet_addr *addr, __be16 *port)
 {
 	unsigned char *p;
 	int family =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -257,7 +257,7 @@ static int expect_rtp_rtcp(struct sk_buf
 	int ret =3D 0;
 	__be16 port;
 	__be16 rtp_port, rtcp_port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *rtp_exp;
 	struct nf_conntrack_expect *rtcp_exp;
 	typeof(nat_rtp_rtcp_hook) nat_rtp_rtcp;
@@ -330,7 +330,7 @@ static int expect_t120(struct sk_buff *s
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_t120_hook) nat_t120;
=20
@@ -623,7 +623,7 @@ static struct nf_conntrack_helper nf_con
 /*********************************************************************=
*******/
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
-		  union nf_conntrack_address *addr, __be16 *port)
+		  union nf_inet_addr *addr, __be16 *port)
 {
 	unsigned char *p;
 	int family =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -662,7 +662,7 @@ static int expect_h245(struct sk_buff *s
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_h245_hook) nat_h245;
=20
@@ -704,8 +704,8 @@ static int expect_h245(struct sk_buff *s
=20
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
-static int callforward_do_filter(union nf_conntrack_address *src,
-				 union nf_conntrack_address *dst,
+static int callforward_do_filter(union nf_inet_addr *src,
+				 union nf_inet_addr *dst,
 				 int family)
 {
 	struct nf_afinfo *afinfo;
@@ -772,7 +772,7 @@ static int expect_callforwarding(struct=20
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_callforwarding_hook) nat_callforwarding;
=20
@@ -828,7 +828,7 @@ static int process_setup(struct sk_buff=20
 	int ret;
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
=20
 	pr_debug("nf_ct_q931: Setup\n");
@@ -1200,7 +1200,7 @@ static unsigned char *get_udp_data(struc
=20
 /*********************************************************************=
*******/
 static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
-					       union nf_conntrack_address *addr,
+					       union nf_inet_addr *addr,
 					       __be16 port)
 {
 	struct nf_conntrack_expect *exp;
@@ -1242,7 +1242,7 @@ static int expect_q931(struct sk_buff *s
 	int ret =3D 0;
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_q931_hook) nat_q931;
=20
@@ -1311,7 +1311,7 @@ static int process_gcf(struct sk_buff *s
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
=20
 	pr_debug("nf_ct_ras: GCF\n");
@@ -1471,7 +1471,7 @@ static int process_arq(struct sk_buff *s
 	struct nf_ct_h323_master *info =3D &nfct_help(ct)->help.ct_h323_info;
 	int dir =3D CTINFO2DIR(ctinfo);
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
=20
 	pr_debug("nf_ct_ras: ARQ\n");
@@ -1513,7 +1513,7 @@ static int process_acf(struct sk_buff *s
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
=20
@@ -1576,7 +1576,7 @@ static int process_lcf(struct sk_buff *s
 	int dir =3D CTINFO2DIR(ctinfo);
 	int ret =3D 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
=20
 	pr_debug("nf_ct_ras: LCF\n");
Index: linux-2.6/net/netfilter/nf_conntrack_sip.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/nf_conntrack_sip.c
+++ linux-2.6/net/netfilter/nf_conntrack_sip.c
@@ -247,7 +247,7 @@ static int skp_digits_len(struct nf_conn
 }
=20
 static int parse_addr(struct nf_conn *ct, const char *cp, const char *=
*endp,
-		      union nf_conntrack_address *addr, const char *limit)
+		      union nf_inet_addr *addr, const char *limit)
 {
 	const char *end;
 	int family =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -275,7 +275,7 @@ static int parse_addr(struct nf_conn *ct
 static int epaddr_len(struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	const char *aux =3D dptr;
=20
 	if (!parse_addr(ct, dptr, &dptr, &addr, limit)) {
@@ -366,7 +366,7 @@ EXPORT_SYMBOL_GPL(ct_sip_get_info);
 static int set_expected_rtp(struct sk_buff *skb,
 			    struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
-			    union nf_conntrack_address *addr,
+			    union nf_inet_addr *addr,
 			    __be16 port,
 			    const char *dptr)
 {
@@ -403,7 +403,7 @@ static int sip_help(struct sk_buff *skb,
 		    enum ip_conntrack_info ctinfo)
 {
 	int family =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	unsigned int dataoff, datalen;
 	const char *dptr;
 	int ret =3D NF_ACCEPT;
Index: linux-2.6/net/netfilter/xt_connlimit.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/xt_connlimit.c
+++ linux-2.6/net/netfilter/xt_connlimit.c
@@ -53,10 +53,10 @@ static inline unsigned int connlimit_iph
 }
=20
 static inline unsigned int
-connlimit_iphash6(const union nf_conntrack_address *addr,
-                  const union nf_conntrack_address *mask)
+connlimit_iphash6(const union nf_inet_addr *addr,
+                  const union nf_inet_addr *mask)
 {
-	union nf_conntrack_address res;
+	union nf_inet_addr res;
 	unsigned int i;
=20
 	if (unlikely(!connlimit_rnd_inited)) {
@@ -81,14 +81,14 @@ static inline bool already_closed(const=20
 }
=20
 static inline unsigned int
-same_source_net(const union nf_conntrack_address *addr,
-		const union nf_conntrack_address *mask,
-		const union nf_conntrack_address *u3, unsigned int family)
+same_source_net(const union nf_inet_addr *addr,
+		const union nf_inet_addr *mask,
+		const union nf_inet_addr *u3, unsigned int family)
 {
 	if (family =3D=3D AF_INET) {
 		return (addr->ip & mask->ip) =3D=3D (u3->ip & mask->ip);
 	} else {
-		union nf_conntrack_address lh, rh;
+		union nf_inet_addr lh, rh;
 		unsigned int i;
=20
 		for (i =3D 0; i < ARRAY_SIZE(addr->ip6); ++i) {
@@ -102,8 +102,8 @@ same_source_net(const union nf_conntrack
=20
 static int count_them(struct xt_connlimit_data *data,
 		      const struct nf_conntrack_tuple *tuple,
-		      const union nf_conntrack_address *addr,
-		      const union nf_conntrack_address *mask,
+		      const union nf_inet_addr *addr,
+		      const union nf_inet_addr *mask,
 		      const struct xt_match *match)
 {
 	struct nf_conntrack_tuple_hash *found;
@@ -185,7 +185,7 @@ connlimit_mt(const struct sk_buff *skb,=20
              bool *hotdrop)
 {
 	const struct xt_connlimit_info *info =3D matchinfo;
-	union nf_conntrack_address addr, mask;
+	union nf_inet_addr addr, mask;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr =3D &tuple;
 	enum ip_conntrack_info ctinfo;
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
