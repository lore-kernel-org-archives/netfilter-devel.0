From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (11/x): move error tracking into conntrack protocol helper
Date: Sat, 24 Jul 2004 11:16:44 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724151644.GT2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mdGUb96ZZNqpHCXz"
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


--mdGUb96ZZNqpHCXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch moves icmp_error_track out of the generic conntrack core and
into the icmp helper, where it really belongs.  It also adds some
generic infrastructure for logging packets that are 'out of spec'.

Signed-off-by: Pablo Neira <pablo@eurodev.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//include/linux/netfilter_ipv4/ip_conntrack_core.h linux=
-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-er=
ror/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-06-16 01:20:2=
6.000000000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-07-24 11=
:11:28.815671440 -0400
@@ -21,15 +21,17 @@
 extern struct ip_conntrack_protocol *__ip_ct_find_proto(u_int8_t protocol);
 extern struct list_head protocol_list;
=20
-/* Returns conntrack if it dealt with ICMP, and filled in skb->nfct */
-extern struct ip_conntrack *icmp_error_track(struct sk_buff *skb,
-					     enum ip_conntrack_info *ctinfo,
-					     unsigned int hooknum);
-extern int get_tuple(const struct iphdr *iph,
-		     const struct sk_buff *skb,
-		     unsigned int dataoff,
-		     struct ip_conntrack_tuple *tuple,
-		     const struct ip_conntrack_protocol *protocol);
+extern int
+ip_ct_get_tuple(const struct iphdr *iph,
+		const struct sk_buff *skb,
+		unsigned int dataoff,
+		struct ip_conntrack_tuple *tuple,
+		const struct ip_conntrack_protocol *protocol);
+
+extern int
+ip_ct_invert_tuple(struct ip_conntrack_tuple *inverse,
+		   const struct ip_conntrack_tuple *orig,
+		   const struct ip_conntrack_protocol *protocol);
=20
 /* Find a connection corresponding to a tuple. */
 struct ip_conntrack_tuple_hash *
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//include/linux/netfilter_ipv4/ip_conntrack_protocol.h l=
inux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctop=
t-error/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-07-24 10:=
40:14.023683000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-07-2=
4 11:11:28.817671136 -0400
@@ -55,6 +55,9 @@
 	int (*exp_matches_pkt)(struct ip_conntrack_expect *exp,
 			       const struct sk_buff *skb);
=20
+	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+		     unsigned int hooknum);
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
@@ -68,4 +71,17 @@
 extern struct ip_conntrack_protocol ip_conntrack_protocol_udp;
 extern struct ip_conntrack_protocol ip_conntrack_protocol_icmp;
 extern int ip_conntrack_protocol_tcp_init(void);
+
+/* Log invalid packets */
+extern unsigned int ip_ct_log_invalid;
+
+#ifdef DEBUG_INVALID_PACKETS
+#define LOG_INVALID(proto) \
+	(ip_ct_log_invalid =3D=3D (proto) || ip_ct_log_invalid =3D=3D IPPROTO_RAW)
+#else
+#define LOG_INVALID(proto) \
+	((ip_ct_log_invalid =3D=3D (proto) || ip_ct_log_invalid =3D=3D IPPROTO_RA=
W) \
+	 && net_ratelimit())
+#endif
+
 #endif /*_IP_CONNTRACK_PROTOCOL_H*/
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.8-rc2=
-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-error/net/ip=
v4/netfilter/ip_conntrack_core.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_core.c	2004-07-24 10:59:09.17411404=
8 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-24 11:11:29.939=
500592 -0400
@@ -128,11 +128,11 @@
 }
=20
 int
-get_tuple(const struct iphdr *iph,
-	  const struct sk_buff *skb,
-	  unsigned int dataoff,
-	  struct ip_conntrack_tuple *tuple,
-	  const struct ip_conntrack_protocol *protocol)
+ip_ct_get_tuple(const struct iphdr *iph,
+		const struct sk_buff *skb,
+		unsigned int dataoff,
+		struct ip_conntrack_tuple *tuple,
+		const struct ip_conntrack_protocol *protocol)
 {
 	/* Never happen */
 	if (iph->frag_off & htons(IP_OFFSET)) {
@@ -148,10 +148,10 @@
 	return protocol->pkt_to_tuple(skb, dataoff, tuple);
 }
=20
-static int
-invert_tuple(struct ip_conntrack_tuple *inverse,
-	     const struct ip_conntrack_tuple *orig,
-	     const struct ip_conntrack_protocol *protocol)
+int
+ip_ct_invert_tuple(struct ip_conntrack_tuple *inverse,
+		   const struct ip_conntrack_tuple *orig,
+		   const struct ip_conntrack_protocol *protocol)
 {
 	inverse->src.ip =3D orig->dst.ip;
 	inverse->dst.ip =3D orig->src.ip;
@@ -497,83 +497,6 @@
 	return h !=3D NULL;
 }
=20
-/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
-struct ip_conntrack *
-icmp_error_track(struct sk_buff *skb,
-		 enum ip_conntrack_info *ctinfo,
-		 unsigned int hooknum)
-{
-	struct ip_conntrack_tuple innertuple, origtuple;
-	struct {
-		struct icmphdr icmp;
-		struct iphdr ip;
-	} inside;
-	struct ip_conntrack_protocol *innerproto;
-	struct ip_conntrack_tuple_hash *h;
-	int dataoff;
-
-	IP_NF_ASSERT(skb->nfct =3D=3D NULL);
-
-	/* Not enough header? */
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=3D0)
-		return NULL;
-
-	if (inside.icmp.type !=3D ICMP_DEST_UNREACH
-	    && inside.icmp.type !=3D ICMP_SOURCE_QUENCH
-	    && inside.icmp.type !=3D ICMP_TIME_EXCEEDED
-	    && inside.icmp.type !=3D ICMP_PARAMETERPROB
-	    && inside.icmp.type !=3D ICMP_REDIRECT)
-		return NULL;
-
-	/* Ignore ICMP's containing fragments (shouldn't happen) */
-	if (inside.ip.frag_off & htons(IP_OFFSET)) {
-		DEBUGP("icmp_error_track: fragment of proto %u\n",
-		       inside.ip.protocol);
-		return NULL;
-	}
-
-	innerproto =3D ip_ct_find_proto(inside.ip.protocol);
-	dataoff =3D skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
-	/* Are they talking about one of our connections? */
-	if (!get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
-		DEBUGP("icmp_error: ! get_tuple p=3D%u", inside.ip.protocol);
-		return NULL;
-	}
-
-	/* Ordinarily, we'd expect the inverted tupleproto, but it's
-	   been preserved inside the ICMP. */
-	if (!invert_tuple(&innertuple, &origtuple, innerproto)) {
-		DEBUGP("icmp_error_track: Can't invert tuple\n");
-		return NULL;
-	}
-
-	*ctinfo =3D IP_CT_RELATED;
-
-	h =3D ip_conntrack_find_get(&innertuple, NULL);
-	if (!h) {
-		/* Locally generated ICMPs will match inverted if they
-		   haven't been SNAT'ed yet */
-		/* FIXME: NAT code has to handle half-done double NAT --RR */
-		if (hooknum =3D=3D NF_IP_LOCAL_OUT)
-			h =3D ip_conntrack_find_get(&origtuple, NULL);
-
-		if (!h) {
-			DEBUGP("icmp_error_track: no match\n");
-			return NULL;
-		}
-		/* Reverse direction from that found */
-		if (DIRECTION(h) !=3D IP_CT_DIR_REPLY)
-			*ctinfo +=3D IP_CT_IS_REPLY;
-	} else {
-		if (DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
-			*ctinfo +=3D IP_CT_IS_REPLY;
-	}
-
-	/* Update skb to refer to this connection */
-	skb->nfct =3D &h->ctrack->infos[*ctinfo];
-	return h->ctrack;
-}
-
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
@@ -655,7 +578,7 @@
 		}
 	}
=20
-	if (!invert_tuple(&repl_tuple, tuple, protocol)) {
+	if (!ip_ct_invert_tuple(&repl_tuple, tuple, protocol)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
@@ -751,7 +674,8 @@
=20
 	IP_NF_ASSERT((skb->nh.iph->frag_off & htons(IP_OFFSET)) =3D=3D 0);
=20
-	if (!get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple, proto))
+	if (!ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4,=20
+				&tuple,proto))
 		return NULL;
=20
 	/* look for tuple match */
@@ -836,10 +760,12 @@
=20
 	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
=20
-	/* It may be an icmp error... */
-	if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP=20
-	    && icmp_error_track(*pskb, &ctinfo, hooknum))
-		return NF_ACCEPT;
+	/* It may be an special packet, error, unclean...
+	 * inverse of the return code tells to the netfilter
+	 * core what to do with the packet. */
+	if (proto->error !=3D NULL=20
+	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0)
+		return -ret;
=20
 	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
 		/* Not valid part of a connection */
@@ -877,7 +803,8 @@
 int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 		   const struct ip_conntrack_tuple *orig)
 {
-	return invert_tuple(inverse, orig, ip_ct_find_proto(orig->dst.protonum));
+	return ip_ct_invert_tuple(inverse, orig,=20
+				  ip_ct_find_proto(orig->dst.protonum));
 }
=20
 static inline int resent_expect(const struct ip_conntrack_expect *i,
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_proto_generic.c linux-=
2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-err=
or/net/ipv4/netfilter/ip_conntrack_proto_generic.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-07-24 10:36:35=
=2E268938000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-07-24 11:=
11:29.940500440 -0400
@@ -62,8 +62,14 @@
 	return 1;
 }
=20
-struct ip_conntrack_protocol ip_conntrack_generic_protocol
-=3D { { NULL, NULL }, 0, "unknown",
-    generic_pkt_to_tuple, generic_invert_tuple, generic_print_tuple,
-    generic_print_conntrack, packet, new, NULL, NULL, NULL };
-
+struct ip_conntrack_protocol ip_conntrack_generic_protocol =3D
+{
+	.proto			=3D 0,
+	.name			=3D "unknown",
+	.pkt_to_tuple		=3D generic_pkt_to_tuple,
+	.invert_tuple		=3D generic_invert_tuple,
+	.print_tuple		=3D generic_print_tuple,
+	.print_conntrack	=3D generic_print_conntrack,
+	.packet			=3D packet,
+	.new			=3D new,
+};
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_proto_icmp.c linux-2.6=
=2E8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-erro=
r/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-07-24 10:36:35.26=
9938000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-07-24 11:11:=
32.692082136 -0400
@@ -12,6 +12,11 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/icmp.h>
+#include <net/ip.h>
+#include <net/checksum.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
 unsigned long ip_ct_icmp_timeout =3D 30*HZ;
@@ -122,7 +127,147 @@
 	return 1;
 }
=20
-struct ip_conntrack_protocol ip_conntrack_protocol_icmp
-=3D { { NULL, NULL }, IPPROTO_ICMP, "icmp",
-    icmp_pkt_to_tuple, icmp_invert_tuple, icmp_print_tuple,
-    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, NULL };
+static int
+icmp_error_message(struct sk_buff *skb,
+		   enum ip_conntrack_info *ctinfo,
+		   unsigned int hooknum)
+{
+	struct ip_conntrack_tuple innertuple, origtuple;
+	struct {
+		struct icmphdr icmp;
+		struct iphdr ip;
+	} inside;
+	struct ip_conntrack_protocol *innerproto;
+	struct ip_conntrack_tuple_hash *h;
+	int dataoff;
+
+	IP_NF_ASSERT(skb->nfct =3D=3D NULL);
+
+	/* Not enough header? */
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=3D0)
+		return NF_ACCEPT;
+
+	/* Ignore ICMP's containing fragments (shouldn't happen) */
+	if (inside.ip.frag_off & htons(IP_OFFSET)) {
+		DEBUGP("icmp_error_track: fragment of proto %u\n",
+		       inside.ip.protocol);
+		return NF_ACCEPT;
+	}
+
+	innerproto =3D ip_ct_find_proto(inside.ip.protocol);
+	dataoff =3D skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
+	/* Are they talking about one of our connections? */
+	if (!ip_ct_get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
+		DEBUGP("icmp_error: ! get_tuple p=3D%u", inside.ip.protocol);
+		return NF_ACCEPT;
+	}
+
+	/* Ordinarily, we'd expect the inverted tupleproto, but it's
+	   been preserved inside the ICMP. */
+	if (!ip_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
+		DEBUGP("icmp_error_track: Can't invert tuple\n");
+		return NF_ACCEPT;
+	}
+
+	*ctinfo =3D IP_CT_RELATED;
+
+	h =3D ip_conntrack_find_get(&innertuple, NULL);
+	if (!h) {
+		/* Locally generated ICMPs will match inverted if they
+		   haven't been SNAT'ed yet */
+		/* FIXME: NAT code has to handle half-done double NAT --RR */
+		if (hooknum =3D=3D NF_IP_LOCAL_OUT)
+			h =3D ip_conntrack_find_get(&origtuple, NULL);
+
+		if (!h) {
+			DEBUGP("icmp_error_track: no match\n");
+			return NF_ACCEPT;
+		}
+		/* Reverse direction from that found */
+		if (DIRECTION(h) !=3D IP_CT_DIR_REPLY)
+			*ctinfo +=3D IP_CT_IS_REPLY;
+	} else {
+		if (DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
+			*ctinfo +=3D IP_CT_IS_REPLY;
+	}
+
+	/* Update skb to refer to this connection */
+	skb->nfct =3D &h->ctrack->infos[*ctinfo];
+	return -NF_ACCEPT;
+}
+
+/* Small and modified version of icmp_rcv */
+static int
+icmp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+	   unsigned int hooknum)
+{
+	struct icmphdr icmph;
+
+	/* Not enough header? */
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &icmph, sizeof(icmph))!=3D0) {
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+				      "ip_ct_icmp: short packet ");
+		return -NF_ACCEPT;
+	}
+
+	/* See ip_conntrack_proto_tcp.c */
+	if (hooknum !=3D NF_IP_PRE_ROUTING)
+		goto checksum_skipped;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_HW:
+		if (!(u16)csum_fold(skb->csum))=20
+			break;
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				      "ip_ct_icmp: bad HW ICMP checksum ");
+		return -NF_ACCEPT;
+	case CHECKSUM_NONE:
+		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
+			if (LOG_INVALID(IPPROTO_ICMP))
+				nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+					      "ip_ct_icmp: bad ICMP checksum ");
+			return -NF_ACCEPT;
+		}
+	default:
+		break;
+	}
+
+checksum_skipped:
+	/*
+	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
+	 *
+	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
+	 *		  discarded.
+	 */
+	if (icmph.type > NR_ICMP_TYPES) {
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+				      "ip_ct_icmp: invalid ICMP type ");
+		return -NF_ACCEPT;
+	}
+
+	/* Need to track icmp error message? */
+	if (icmph.type !=3D ICMP_DEST_UNREACH
+	    && icmph.type !=3D ICMP_SOURCE_QUENCH
+	    && icmph.type !=3D ICMP_TIME_EXCEEDED
+	    && icmph.type !=3D ICMP_PARAMETERPROB
+	    && icmph.type !=3D ICMP_REDIRECT)
+		return NF_ACCEPT;
+
+	return icmp_error_message(skb, ctinfo, hooknum);
+}
+
+struct ip_conntrack_protocol ip_conntrack_protocol_icmp =3D
+{
+	.proto 			=3D IPPROTO_ICMP,
+	.name 			=3D "icmp",
+	.pkt_to_tuple		=3D icmp_pkt_to_tuple,
+	.invert_tuple		=3D icmp_invert_tuple,
+	.print_tuple		=3D icmp_print_tuple,
+	.print_conntrack	=3D icmp_print_conntrack,
+	.packet			=3D icmp_packet,
+	.new			=3D icmp_new,
+	.error			=3D icmp_error,
+};
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.6.=
8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-error/n=
et/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-07-24 10:36:35.270=
938000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-07-24 11:11:2=
9.951498768 -0400
@@ -268,7 +268,15 @@
 	return between(exp->seq, ntohl(tcph.seq), ntohl(tcph.seq) + datalen);
 }
=20
-struct ip_conntrack_protocol ip_conntrack_protocol_tcp
-=3D { { NULL, NULL }, IPPROTO_TCP, "tcp",
-    tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntra=
ck,
-    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
+struct ip_conntrack_protocol ip_conntrack_protocol_tcp =3D
+{
+	.proto 			=3D IPPROTO_TCP,
+	.name 			=3D "tcp",
+	.pkt_to_tuple 		=3D tcp_pkt_to_tuple,
+	.invert_tuple 		=3D tcp_invert_tuple,
+	.print_tuple 		=3D tcp_print_tuple,
+	.print_conntrack 	=3D tcp_print_conntrack,
+	.packet 		=3D tcp_packet,
+	.new 			=3D tcp_new,
+	.exp_matches_pkt	=3D tcp_exp_matches_pkt,
+};
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_proto_udp.c linux-2.6.=
8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-error/n=
et/ipv4/netfilter/ip_conntrack_proto_udp.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-07-24 10:36:35.271=
938000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-07-24 11:11:3=
2.696081528 -0400
@@ -12,6 +12,8 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+#include <net/checksum.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
 unsigned long ip_ct_udp_timeout =3D 30*HZ;
@@ -81,7 +83,60 @@
 	return 1;
 }
=20
-struct ip_conntrack_protocol ip_conntrack_protocol_udp
-=3D { { NULL, NULL }, IPPROTO_UDP, "udp",
-    udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntra=
ck,
-    udp_packet, udp_new, NULL, NULL, NULL };
+static int udp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+		     unsigned int hooknum)
+{
+	struct iphdr *iph =3D skb->nh.iph;
+	unsigned int udplen =3D skb->len - iph->ihl * 4;
+	struct udphdr hdr;
+
+	/* Header is too small? */
+	if (skb_copy_bits(skb, iph->ihl*4, &hdr, sizeof(hdr)) !=3D 0) {
+		if (LOG_INVALID(IPPROTO_UDP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_udp: short packet ");
+		return -NF_ACCEPT;
+	}
+=09
+	/* Truncated/malformed packets */
+	if (ntohs(hdr.len) > udplen || ntohs(hdr.len) < sizeof(hdr)) {
+		if (LOG_INVALID(IPPROTO_UDP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_udp: truncated/malformed packet ");
+		return -NF_ACCEPT;
+	}
+=09
+	/* Packet with no checksum */
+	if (!hdr.check)
+		return NF_ACCEPT;
+
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the semantic of CHECKSUM_HW is different there=20
+	 * and moreover root might send raw packets.
+	 * FIXME: Source route IP option packets --RR */
+	if (hooknum =3D=3D NF_IP_PRE_ROUTING
+	    && csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
+			         skb->ip_summed =3D=3D CHECKSUM_HW ? skb->csum
+			      	 : skb_checksum(skb, iph->ihl*4, udplen, 0))) {
+		if (LOG_INVALID(IPPROTO_UDP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_udp: bad UDP checksum ");
+		return -NF_ACCEPT;
+	}
+=09
+	return NF_ACCEPT;
+}
+
+struct ip_conntrack_protocol ip_conntrack_protocol_udp =3D
+{
+	.proto 			=3D IPPROTO_UDP,
+	.name			=3D "udp",
+	.pkt_to_tuple		=3D udp_pkt_to_tuple,
+	.invert_tuple		=3D udp_invert_tuple,
+	.print_tuple		=3D udp_print_tuple,
+	.print_conntrack	=3D udp_print_conntrack,
+	.packet			=3D udp_packet,
+	.new			=3D udp_new,
+	.error			=3D udp_error,
+};
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6=
=2E8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-erro=
r/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_conntrack_standalone.c	2004-07-24 10:43:00.21=
5418000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-07-24 11:11:=
29.957497856 -0400
@@ -432,6 +432,11 @@
 /* From ip_conntrack_proto_icmp.c */
 extern unsigned long ip_ct_generic_timeout;
=20
+/* Log invalid packets of a given protocol */
+unsigned int ip_ct_log_invalid =3D 0;
+static int log_invalid_proto_min =3D 0;
+static int log_invalid_proto_max =3D 255;
+
 static struct ctl_table_header *ip_ct_sysctl_header;
=20
 static ctl_table ip_ct_sysctl_table[] =3D {
@@ -547,6 +552,17 @@
 		.mode		=3D 0644,
 		.proc_handler	=3D &proc_dointvec_jiffies,
 	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_LOG_INVALID,
+		.procname	=3D "ip_conntrack_log_invalid",
+		.data		=3D &ip_ct_log_invalid,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_minmax,
+		.strategy	=3D &sysctl_intvec,
+		.extra1		=3D &log_invalid_proto_min,
+		.extra2		=3D &log_invalid_proto_max,
+	},
 	{ .ctl_name =3D 0 }
 };
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt//net/ipv4/netfilter/ip_fw_compat_masq.c linux-2.6.8-rc2=
-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-error/net/ip=
v4/netfilter/ip_fw_compat_masq.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt//net/ipv4/netfilter/ip_fw_compat_masq.c	2004-07-22 11:49:13.00000000=
0 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_fw_compat_masq.c	2004-07-24 11:11:29.959=
497552 -0400
@@ -31,6 +31,7 @@
=20
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
@@ -144,7 +145,8 @@
 	switch ((*pskb)->nh.iph->protocol) {
 	case IPPROTO_ICMP:
 		/* ICMP errors. */
-		ct =3D icmp_error_track(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
+		protocol->error(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
+		ct =3D (struct ip_conntrack *)(*pskb)->nfct->master;
 		if (ct) {
 			/* We only do SNAT in the compatibility layer.
 			   So we can manipulate ICMP errors from
@@ -165,7 +167,8 @@
 	case IPPROTO_UDP:
 		IP_NF_ASSERT(((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) =3D=3D 0);
=20
-		if (!get_tuple((*pskb)->nh.iph, *pskb, (*pskb)->nh.iph->ihl*4, &tuple, p=
rotocol)) {
+		if (!ip_ct_get_tuple((*pskb)->nh.iph, *pskb,
+				     (*pskb)->nh.iph->ihl*4, &tuple, protocol)) {
 			if (net_ratelimit())
 				printk("ip_fw_compat_masq: Can't get tuple\n");
 			return NF_ACCEPT;
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mdGUb96ZZNqpHCXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAn1bXaXGVTD0i/8RAncWAJ4icvbCRtXXSR7zWdmWBmfzUTXy1ACbBO4K
I6Vd/IpR9GizblQ3yTIhIVs=
=ch3t
-----END PGP SIGNATURE-----

--mdGUb96ZZNqpHCXz--
