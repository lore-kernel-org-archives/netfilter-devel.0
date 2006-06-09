From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: [H.323 Helper 5/5]: Add support for Call Forwarding
Date: Fri, 9 Jun 2006 00:28:14 -0400
Message-ID: <BAY109-DAV8EE386988FB9A08769123B3880@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0089_01C68B5B.989F0140"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0089_01C68B5B.989F0140
Content-Type: text/plain;
	charset="GB18030"
Content-Transfer-Encoding: base64

QWRkIHN1cHBvcnQgZm9yIENhbGwgRm9yd2FyZGluZy4NCg0KU2lnbmVkLW9mZi1ieTogSmluZyBN
aW4gWmhhbyA8emhhb2ppbmdtaW5AdXNlcnMuc291cmNlZm9yZ2UubmV0Pg0K

------=_NextPart_000_0089_01C68B5B.989F0140
Content-Type: application/octet-stream;
	name="patch5-call-forwarding"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch5-call-forwarding"

diff -pruN linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack.h =
linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack.h=0A=
--- linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack.h	=
2006-06-08 14:19:47.000000000 -0400=0A=
+++ linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack.h	2006-06-08 =
21:10:38.000000000 -0400=0A=
@@ -154,6 +154,7 @@ struct ip_conntrack_expect=0A=
 	unsigned int flags;=0A=
 =0A=
 #ifdef CONFIG_IP_NF_NAT_NEEDED=0A=
+	u_int32_t saved_ip;=0A=
 	/* This is the original per-proto part, used to map the=0A=
 	 * expected connection the way the recipient expects. */=0A=
 	union ip_conntrack_manip_proto saved_proto;=0A=
diff -pruN =
linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h =
linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack_h323.h=0A=
--- linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
2006-06-08 14:19:47.000000000 -0400=0A=
+++ linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack_h323.h	=
2006-06-08 21:11:31.000000000 -0400=0A=
@@ -29,6 +29,7 @@ struct ip_ct_h323_master {=0A=
 =0A=
 struct ip_conntrack_expect;=0A=
 =0A=
+extern int have_direct_route(u_int32_t src, u_int32_t dst);=0A=
 extern int get_h225_addr(unsigned char *data, TransportAddress * addr,=0A=
 			 u_int32_t * ip, u_int16_t * port);=0A=
 extern void ip_conntrack_h245_expect(struct ip_conntrack *new,=0A=
@@ -71,6 +72,13 @@ extern int (*nat_h245_hook) (struct sk_b=0A=
 			     unsigned char **data, int dataoff,=0A=
 			     TransportAddress * addr, u_int16_t port,=0A=
 			     struct ip_conntrack_expect * exp);=0A=
+extern int (*nat_callforwarding_hook) (struct sk_buff ** pskb,=0A=
+				       struct ip_conntrack * ct,=0A=
+				       enum ip_conntrack_info ctinfo,=0A=
+				       unsigned char **data, int dataoff,=0A=
+				       TransportAddress * addr,=0A=
+				       u_int16_t port,=0A=
+				       struct ip_conntrack_expect * exp);=0A=
 extern int (*nat_q931_hook) (struct sk_buff ** pskb, struct =
ip_conntrack * ct,=0A=
 			     enum ip_conntrack_info ctinfo,=0A=
 			     unsigned char **data, TransportAddress * addr,=0A=
diff -pruN =
linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_t=
ypes.h =
linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_types.=
h=0A=
--- =
linux-2.6.17.orig/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_t=
ypes.h	2006-06-08 20:59:43.000000000 -0400=0A=
+++ =
linux-2.6.17/include/linux/netfilter_ipv4/ip_conntrack_helper_h323_types.=
h	2006-06-08 21:12:14.000000000 -0400=0A=
@@ -412,6 +412,7 @@ typedef struct Facility_UUIE {	/* SEQUEN=0A=
 		eFacility_UUIE_destinationInfo =3D (1 << 14),=0A=
 		eFacility_UUIE_h245SecurityMode =3D (1 << 13),=0A=
 	} options;=0A=
+	TransportAddress alternativeAddress;=0A=
 	FacilityReason reason;=0A=
 	TransportAddress h245Address;=0A=
 	Facility_UUIE_fastStart fastStart;=0A=
diff -pruN =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c =
linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 21:08:53.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 21:20:13.000000000 -0400=0A=
@@ -22,6 +22,8 @@=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>=0A=
 #include <linux/netfilter_ipv4/ip_conntrack_h323.h>=0A=
 #include <linux/moduleparam.h>=0A=
+#include <linux/ctype.h>=0A=
+#include <linux/inet.h>=0A=
 =0A=
 #if 0=0A=
 #define DEBUGP printk=0A=
@@ -38,6 +40,13 @@ static int gkrouted_only =3D 1;=0A=
 module_param(gkrouted_only, int, 0600);=0A=
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");=0A=
 =0A=
+static char *internal_net =3D NULL;=0A=
+static u_int32_t internal_net_addr =3D 0;=0A=
+static u_int32_t internal_net_mask =3D 0;=0A=
+module_param(internal_net, charp, 0600);=0A=
+MODULE_PARM_DESC(internal_net, "specify your internal network using =
format "=0A=
+		 "address/mask");=0A=
+=0A=
 /* Hooks for NAT */=0A=
 int (*set_h245_addr_hook) (struct sk_buff ** pskb,=0A=
 			   unsigned char **data, int dataoff,=0A=
@@ -77,6 +86,12 @@ int (*nat_h245_hook) (struct sk_buff ** =0A=
 		      unsigned char **data, int dataoff,=0A=
 		      TransportAddress * addr, u_int16_t port,=0A=
 		      struct ip_conntrack_expect * exp);=0A=
+int (*nat_callforwarding_hook) (struct sk_buff ** pskb,=0A=
+				struct ip_conntrack * ct,=0A=
+				enum ip_conntrack_info ctinfo,=0A=
+				unsigned char **data, int dataoff,=0A=
+				TransportAddress * addr, u_int16_t port,=0A=
+				struct ip_conntrack_expect * exp);=0A=
 int (*nat_q931_hook) (struct sk_buff ** pskb,=0A=
 		      struct ip_conntrack * ct,=0A=
 		      enum ip_conntrack_info ctinfo,=0A=
@@ -88,6 +103,44 @@ static DEFINE_SPINLOCK(ip_h323_lock);=0A=
 static char *h323_buffer;=0A=
 =0A=
 =
/************************************************************************=
****/=0A=
+int have_direct_route(u_int32_t src, u_int32_t dst)=0A=
+{=0A=
+	struct flowi fl_src =3D {.fl4_dst =3D src };=0A=
+	struct flowi fl_dst =3D {.fl4_dst =3D dst };=0A=
+	struct rtable *rt_src, *rt_dst;=0A=
+	int ret =3D 0;=0A=
+=0A=
+	if (internal_net) {=0A=
+		if (((src & internal_net_mask) =3D=3D internal_net_addr) =3D=3D=0A=
+		    ((dst & internal_net_mask) =3D=3D internal_net_addr))=0A=
+			return 1;=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	if (ip_route_output_key(&rt_dst, &fl_dst) !=3D 0)=0A=
+		goto out;=0A=
+=0A=
+	if (ip_route_output_key(&rt_src, &fl_src) !=3D 0)=0A=
+		goto out1;=0A=
+=0A=
+	if (rt_dst->u.dst.dev =3D=3D rt_src->u.dst.dev &&=0A=
+	    rt_dst->rt_src =3D=3D rt_src->rt_src) {=0A=
+		if ((rt_dst->u.dst.flags & DST_HOST) ||=0A=
+		    (rt_src->u.dst.flags & DST_HOST) ||=0A=
+		    (rt_dst->rt_gateway =3D=3D rt_src->rt_gateway)) {=0A=
+			DEBUGP("ip_ct_h323: dst has direct route to src\n");=0A=
+			ret =3D 1;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	dst_release(&rt_src->u.dst);=0A=
+      out1:=0A=
+	dst_release(&rt_dst->u.dst);=0A=
+      out:=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
 static int get_tpkt_data(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
 			 enum ip_conntrack_info ctinfo,=0A=
 			 unsigned char **data, int *datalen, int *dataoff)=0A=
@@ -693,6 +746,73 @@ static int expect_h245(struct sk_buff **=0A=
 	return ret;=0A=
 }=0A=
 =0A=
+/* Forwarding declaration */=0A=
+void ip_conntrack_q931_expect(struct ip_conntrack *new,=0A=
+			      struct ip_conntrack_expect *this);=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int expect_callforwarding(struct sk_buff **pskb,=0A=
+				 struct ip_conntrack *ct,=0A=
+				 enum ip_conntrack_info ctinfo,=0A=
+				 unsigned char **data, int dataoff,=0A=
+				 TransportAddress * addr)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	int ret =3D 0;=0A=
+	u_int32_t ip;=0A=
+	u_int16_t port;=0A=
+	struct ip_conntrack_expect *exp =3D NULL;=0A=
+=0A=
+	/* Read alternativeAddress */=0A=
+	if (!get_h225_addr(*data, addr, &ip, &port) || port =3D=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	/* If the calling party has direct route to the forward-to party,=0A=
+	 * we don't need to track the second call */=0A=
+	if (have_direct_route(ct->tuplehash[!dir].tuple.src.ip, ip)) {=0A=
+		DEBUGP("ip_ct_q931: Call Forwarding not tracked\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Create expect for the second call leg */=0A=
+	if ((exp =3D ip_conntrack_expect_alloc(ct)) =3D=3D NULL)=0A=
+		return -1;=0A=
+	exp->tuple.src.ip =3D ct->tuplehash[!dir].tuple.src.ip;=0A=
+	exp->tuple.src.u.tcp.port =3D 0;=0A=
+	exp->tuple.dst.ip =3D ip;=0A=
+	exp->tuple.dst.u.tcp.port =3D htons(port);=0A=
+	exp->tuple.dst.protonum =3D IPPROTO_TCP;=0A=
+	exp->mask.src.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.src.u.tcp.port =3D 0;=0A=
+	exp->mask.dst.ip =3D 0xFFFFFFFF;=0A=
+	exp->mask.dst.u.tcp.port =3D 0xFFFF;=0A=
+	exp->mask.dst.protonum =3D 0xFF;=0A=
+	exp->flags =3D 0;=0A=
+=0A=
+	if (ct->tuplehash[dir].tuple.src.ip !=3D=0A=
+	    ct->tuplehash[!dir].tuple.dst.ip && nat_callforwarding_hook) {=0A=
+		/* Need NAT */=0A=
+		ret =3D nat_callforwarding_hook(pskb, ct, ctinfo, data, dataoff,=0A=
+					      addr, port, exp);=0A=
+	} else {		/* Conntrack only */=0A=
+		exp->expectfn =3D ip_conntrack_q931_expect;=0A=
+=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0) {=0A=
+			DEBUGP("ip_ct_q931: expect Call Forwarding "=0A=
+			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+			       NIPQUAD(exp->tuple.src.ip),=0A=
+			       ntohs(exp->tuple.src.u.tcp.port),=0A=
+			       NIPQUAD(exp->tuple.dst.ip),=0A=
+			       ntohs(exp->tuple.dst.u.tcp.port));=0A=
+		} else=0A=
+			ret =3D -1;=0A=
+	}=0A=
+=0A=
+	ip_conntrack_expect_put(exp);=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
 =
/************************************************************************=
****/=0A=
 static int process_setup(struct sk_buff **pskb, struct ip_conntrack *ct,=0A=
 			 enum ip_conntrack_info ctinfo,=0A=
@@ -888,6 +1008,15 @@ static int process_facility(struct sk_bu=0A=
 =0A=
 	DEBUGP("ip_ct_q931: Facility\n");=0A=
 =0A=
+	if (facility->reason.choice =3D=3D eFacilityReason_callForwarded) {=0A=
+		if (facility->options & eFacility_UUIE_alternativeAddress)=0A=
+			return expect_callforwarding(pskb, ct, ctinfo, data,=0A=
+						     dataoff,=0A=
+						     &facility->=0A=
+						     alternativeAddress);=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
 	if (facility->options & eFacility_UUIE_h245Address) {=0A=
 		ret =3D expect_h245(pskb, ct, ctinfo, data, dataoff,=0A=
 				  &facility->h245Address);=0A=
@@ -1680,6 +1809,7 @@ static void fini(void)=0A=
 static int __init init(void)=0A=
 {=0A=
 	int ret;=0A=
+	char *p;=0A=
 =0A=
 	h323_buffer =3D kmalloc(65536, GFP_KERNEL);=0A=
 	if (!h323_buffer)=0A=
@@ -1690,6 +1820,22 @@ static int __init init(void)=0A=
 		return ret;=0A=
 	}=0A=
 =0A=
+	if (internal_net) {=0A=
+		if ((p =3D strchr(internal_net, '/')))=0A=
+			*p++ =3D 0;=0A=
+		if (isdigit(internal_net[0])) {=0A=
+			internal_net_addr =3D in_aton(internal_net);=0A=
+			if (p && isdigit(p[0]))=0A=
+				internal_net_mask =3D in_aton(p);=0A=
+			else=0A=
+				internal_net_mask =3D 0xffffffff;=0A=
+			internal_net_addr &=3D internal_net_mask;=0A=
+		}=0A=
+		DEBUGP("ip_ct_h323: internal_net =3D %u.%u.%u.%u/%u.%u.%u.%u\n",=0A=
+		       NIPQUAD(internal_net_addr),=0A=
+		       NIPQUAD(internal_net_mask));=0A=
+	}=0A=
+=0A=
 	DEBUGP("ip_ct_h323: init success\n");=0A=
 	return 0;=0A=
 }=0A=
@@ -1698,6 +1844,7 @@ static int __init init(void)=0A=
 module_init(init);=0A=
 module_exit(fini);=0A=
 =0A=
+EXPORT_SYMBOL_GPL(have_direct_route);=0A=
 EXPORT_SYMBOL_GPL(get_h225_addr);=0A=
 EXPORT_SYMBOL_GPL(ip_conntrack_h245_expect);=0A=
 EXPORT_SYMBOL_GPL(ip_conntrack_q931_expect);=0A=
@@ -1708,6 +1855,7 @@ EXPORT_SYMBOL_GPL(set_ras_addr_hook);=0A=
 EXPORT_SYMBOL_GPL(nat_rtp_rtcp_hook);=0A=
 EXPORT_SYMBOL_GPL(nat_t120_hook);=0A=
 EXPORT_SYMBOL_GPL(nat_h245_hook);=0A=
+EXPORT_SYMBOL_GPL(nat_callforwarding_hook);=0A=
 EXPORT_SYMBOL_GPL(nat_q931_hook);=0A=
 =0A=
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");=0A=
diff -pruN =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c =
linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c=0A=
--- =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c	=
2006-06-08 20:59:43.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323_types.c	=
2006-06-08 21:13:42.000000000 -0400=0A=
@@ -1069,8 +1069,8 @@ static field_t _Facility_UUIE_fastStart[=0A=
 =0A=
 static field_t _Facility_UUIE[] =3D {	/* SEQUENCE */=0A=
 	{FNAME("protocolIdentifier") OID, BYTE, 0, 0, SKIP, 0, NULL},=0A=
-	{FNAME("alternativeAddress") CHOICE, 3, 7, 7, SKIP | EXT | OPT, 0,=0A=
-	 _TransportAddress},=0A=
+	{FNAME("alternativeAddress") CHOICE, 3, 7, 7, DECODE | EXT | OPT,=0A=
+	 offsetof(Facility_UUIE, alternativeAddress), _TransportAddress},=0A=
 	{FNAME("alternativeAliasAddress") SEQOF, SEMI, 0, 0, SKIP | OPT, 0,=0A=
 	 _Facility_UUIE_alternativeAliasAddress},=0A=
 	{FNAME("conferenceID") OCTSTR, FIXD, 16, 0, SKIP | OPT, 0, NULL},=0A=
diff -pruN linux-2.6.17.orig/net/ipv4/netfilter/ip_nat_helper_h323.c =
linux-2.6.17/net/ipv4/netfilter/ip_nat_helper_h323.c=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/ip_nat_helper_h323.c	2006-06-08 =
14:19:49.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_nat_helper_h323.c	2006-06-08 =
21:25:13.000000000 -0400=0A=
@@ -30,6 +30,24 @@=0A=
 #endif=0A=
 =0A=
 =
/************************************************************************=
****/=0A=
+static u_int32_t get_source_ip(u_int32_t dst)=0A=
+{=0A=
+	struct rtable *rt;=0A=
+	struct flowi fl;=0A=
+	u_int32_t src;=0A=
+=0A=
+	memset(&fl, 0, sizeof(fl));=0A=
+	fl.fl4_dst =3D dst;=0A=
+	if (ip_route_output_key(&rt, &fl) !=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	src =3D rt->rt_src;=0A=
+=0A=
+	dst_release(&rt->u.dst);=0A=
+	return src;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
 static int set_addr(struct sk_buff **pskb,=0A=
 		    unsigned char **data, int dataoff,=0A=
 		    unsigned int addroff, u_int32_t ip, u_int16_t port)=0A=
@@ -487,6 +505,87 @@ static int nat_q931(struct sk_buff **psk=0A=
 }=0A=
 =0A=
 =
/************************************************************************=
****/=0A=
+static void ip_nat_callforwarding_expect(struct ip_conntrack *new,=0A=
+					 struct ip_conntrack_expect *this)=0A=
+{=0A=
+	struct ip_nat_range range;=0A=
+	u_int32_t src_ip;=0A=
+=0A=
+	/* This must be a fresh one. */=0A=
+	BUG_ON(new->status & IPS_NAT_DONE_MASK);=0A=
+=0A=
+	/* Change src to where master sends to */=0A=
+	range.flags =3D IP_NAT_RANGE_MAP_IPS;=0A=
+	if (!have_direct_route(new->master->tuplehash[!this->dir].tuple.src.ip,=0A=
+			       this->saved_ip) &&=0A=
+	    (src_ip =3D get_source_ip(this->saved_ip)))=0A=
+		range.min_ip =3D range.max_ip =3D src_ip;=0A=
+	else=0A=
+		range.min_ip =3D range.max_ip =3D=0A=
+		    new->tuplehash[this->dir].tuple.src.ip;=0A=
+=0A=
+	/* hook doesn't matter, but it has to do source manip */=0A=
+	ip_nat_setup_info(new, &range, NF_IP_POST_ROUTING);=0A=
+=0A=
+	/* For DST manip, map port here to where it's expected. */=0A=
+	range.flags =3D (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);=0A=
+	range.min =3D range.max =3D this->saved_proto;=0A=
+	range.min_ip =3D range.max_ip =3D this->saved_ip;=0A=
+=0A=
+	/* hook doesn't matter, but it has to do destination manip */=0A=
+	ip_nat_setup_info(new, &range, NF_IP_PRE_ROUTING);=0A=
+=0A=
+	ip_conntrack_q931_expect(new, this);=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
+static int nat_callforwarding(struct sk_buff **pskb, struct =
ip_conntrack *ct,=0A=
+			      enum ip_conntrack_info ctinfo,=0A=
+			      unsigned char **data, int dataoff,=0A=
+			      TransportAddress * addr, u_int16_t port,=0A=
+			      struct ip_conntrack_expect *exp)=0A=
+{=0A=
+	int dir =3D CTINFO2DIR(ctinfo);=0A=
+	u_int16_t nated_port;=0A=
+=0A=
+	/* Set expectations for NAT */=0A=
+	exp->saved_ip =3D exp->tuple.dst.ip;=0A=
+	exp->tuple.dst.ip =3D ct->tuplehash[!dir].tuple.dst.ip;=0A=
+	exp->saved_proto.tcp.port =3D exp->tuple.dst.u.tcp.port;=0A=
+	exp->expectfn =3D ip_nat_callforwarding_expect;=0A=
+	exp->dir =3D !dir;=0A=
+=0A=
+	/* Try to get same port: if not, try to change it. */=0A=
+	for (nated_port =3D port; nated_port !=3D 0; nated_port++) {=0A=
+		exp->tuple.dst.u.tcp.port =3D htons(nated_port);=0A=
+		if (ip_conntrack_expect_related(exp) =3D=3D 0)=0A=
+			break;=0A=
+	}=0A=
+=0A=
+	if (nated_port =3D=3D 0) {	/* No port available */=0A=
+		if (net_ratelimit())=0A=
+			printk("ip_nat_q931: out of TCP ports\n");=0A=
+		return 0;=0A=
+	}=0A=
+=0A=
+	/* Modify signal */=0A=
+	if (!set_h225_addr(pskb, data, dataoff, addr,=0A=
+			   ct->tuplehash[!dir].tuple.dst.ip,=0A=
+			   nated_port) =3D=3D 0) {=0A=
+		ip_conntrack_unexpect_related(exp);=0A=
+		return -1;=0A=
+	}=0A=
+=0A=
+	/* Success */=0A=
+	DEBUGP("ip_nat_q931: expect Call Forwarding "=0A=
+	       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",=0A=
+	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),=0A=
+	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/***********************************************************************=
*****/=0A=
 static int __init init(void)=0A=
 {=0A=
 	BUG_ON(set_h245_addr_hook !=3D NULL);=0A=
@@ -496,6 +595,7 @@ static int __init init(void)=0A=
 	BUG_ON(nat_rtp_rtcp_hook !=3D NULL);=0A=
 	BUG_ON(nat_t120_hook !=3D NULL);=0A=
 	BUG_ON(nat_h245_hook !=3D NULL);=0A=
+	BUG_ON(nat_callforwarding_hook !=3D NULL);=0A=
 	BUG_ON(nat_q931_hook !=3D NULL);=0A=
 =0A=
 	set_h245_addr_hook =3D set_h245_addr;=0A=
@@ -505,6 +605,7 @@ static int __init init(void)=0A=
 	nat_rtp_rtcp_hook =3D nat_rtp_rtcp;=0A=
 	nat_t120_hook =3D nat_t120;=0A=
 	nat_h245_hook =3D nat_h245;=0A=
+	nat_callforwarding_hook =3D nat_callforwarding;=0A=
 	nat_q931_hook =3D nat_q931;=0A=
 =0A=
 	DEBUGP("ip_nat_h323: init success\n");=0A=
@@ -521,6 +622,7 @@ static void __exit fini(void)=0A=
 	nat_rtp_rtcp_hook =3D NULL;=0A=
 	nat_t120_hook =3D NULL;=0A=
 	nat_h245_hook =3D NULL;=0A=
+	nat_callforwarding_hook =3D NULL;=0A=
 	nat_q931_hook =3D NULL;=0A=
 	synchronize_net();=0A=
 }=0A=
diff -pruN linux-2.6.17.orig/net/ipv4/netfilter/Kconfig =
linux-2.6.17/net/ipv4/netfilter/Kconfig=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/Kconfig	2006-06-08 =
14:19:49.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/Kconfig	2006-06-08 =
21:27:13.000000000 -0400=0A=
@@ -181,10 +181,10 @@ config IP_NF_H323=0A=
 	  With this module you can support H.323 on a connection tracking/NAT=0A=
 	  firewall.=0A=
 =0A=
-	  This module supports RAS, Fast-start, H.245 tunnelling, RTP/RTCP=0A=
-	  and T.120 based data and applications including audio, video, FAX,=0A=
-	  chat, whiteboard, file transfer, etc. For more information, please=0A=
-	  see http://nath323.sourceforge.net/.=0A=
+	  This module supports RAS, Fast Start, H.245 Tunnelling, Call=0A=
+	  Forwarding, RTP/RTCP and T.120 based audio, video, fax, chat,=0A=
+	  whiteboard, file transfer, etc. For more information, please=0A=
+	  visit http://nath323.sourceforge.net/.=0A=
 =0A=
 	  If you want to compile it as a module, say 'M' here and read=0A=
 	  Documentation/modules.txt.  If unsure, say 'N'.=0A=

------=_NextPart_000_0089_01C68B5B.989F0140--
