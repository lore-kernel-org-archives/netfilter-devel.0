From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [BUG] UDP connection tracking failure
Date: 08 Sep 2002 00:59:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031439594.5760.405.camel@tux>
References: <200208271837.g7RIbkm02830@vindaloo.ras.ucalgary.ca>
	<1030623591.5131.295.camel@tux>
	<200208311650.g7VGooe19044@vindaloo.ras.ucalgary.ca>
	<1030815452.2313.1.camel@tux>
	<20020905084830.GE1064@naboo.lincon.Uni-Koeln.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-O076qCNd46xHhDePK+fG"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020905084830.GE1064@naboo.lincon.Uni-Koeln.DE>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-O076qCNd46xHhDePK+fG
Content-Type: multipart/mixed; boundary="=-fZx262d+p/CzK5owkHzo"


--=-fZx262d+p/CzK5owkHzo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2002-09-05 at 10:48, Harald Welte wrote:

> > I will run it by the coreteam, they know the internals better than I do=
,
> > This fix might not be 100% correct for all cases.
>=20
> The problem is that TCP is making an assumption on the old behaviour in
> line 194 of ip_conntrack_proto_tcp.c
>=20
> In general I think the way you have fixed the UDP case is correct - but
> you should somehow make sure that the TCP RST codepath is still working.

Ok, now I have two diffrent approaches to this.
#1 moves set_bit() into the protocol-handlers, this allows tcp to set
the bit after the check.
(I've attached the changes to gre separately)

#2.moves set_bit() into resolve_normal_ct() and modifies the way we
detect the RST to be the same way as we detect a SYN-ACK.
This changes the tcp behavior slightly, now we only trigger that case if
the previous sent out packet was a SYN and the packet we recieve in the
REPLY direction is a RST. Before we could trigger on a RST sent in the
ORIGINAL direction before we got a reply aswell, this behaviour is easy
to get back (remove one line). The main diffrence is that we depend on
the SYN_SENT state instead of no_other_reply_before_this_packet pseudo
state.

Which one do you like best?
I kind of like #2.

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-fZx262d+p/CzK5owkHzo
Content-Disposition: attachment; filename=conntrack-reply-1.diff
Content-Type: text/plain; name=conntrack-reply-1.diff; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_core.c.orig	2002-08-2=
9 14:13:04.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_core.c	2002-09-08 00:=
08:24.000000000 +0200
@@ -751,7 +751,6 @@
 static inline struct ip_conntrack *
 resolve_normal_ct(struct sk_buff *skb,
 		  struct ip_conntrack_protocol *proto,
-		  int *set_reply,
 		  unsigned int hooknum,
 		  enum ip_conntrack_info *ctinfo)
 {
@@ -776,8 +775,6 @@
 	/* It exists; we have (non-exclusive) reference. */
 	if (DIRECTION(h) =3D=3D IP_CT_DIR_REPLY) {
 		*ctinfo =3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY;
-		/* Please set reply bit if this packet OK */
-		*set_reply =3D 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (h->ctrack->status & IPS_SEEN_REPLY) {
@@ -793,7 +792,6 @@
 			       h->ctrack);
 			*ctinfo =3D IP_CT_NEW;
 		}
-		*set_reply =3D 0;
 	}
 	skb->nfct =3D &h->ctrack->infos[*ctinfo];
 	return h->ctrack;
@@ -809,7 +806,6 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack_protocol *proto;
-	int set_reply;
 	int ret;
=20
 	/* FIXME: Do this right please. --RR */
@@ -849,7 +845,7 @@
 	    && icmp_error_track(*pskb, &ctinfo, hooknum))
 		return NF_ACCEPT;
=20
-	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
+	if (!(ct =3D resolve_normal_ct(*pskb, proto, hooknum, &ctinfo)))
 		/* Not valid part of a connection */
 		return NF_ACCEPT;
=20
@@ -877,8 +873,6 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
=20
 	return ret;
 }
--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_generic.c.orig	=
2002-09-08 00:30:14.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2002-=
09-08 00:20:33.000000000 +0200
@@ -43,6 +43,10 @@
 		       struct iphdr *iph, size_t len,
 		       enum ip_conntrack_info conntrackinfo)
 {
+	/* This is a reply packet, set conntrack to replied. */
+	if (CTINFO2DIR(conntrackinfo) =3D=3D IP_CT_DIR_REPLY)
+		set_bit(IPS_SEEN_REPLY_BIT, &conntrack->status);
+
 	ip_ct_refresh(conntrack, GENERIC_TIMEOUT);
 	return NF_ACCEPT;
 }
--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_icmp.c.orig	200=
2-09-08 00:30:04.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2002-09-=
08 00:20:23.000000000 +0200
@@ -72,6 +72,11 @@
 		       struct iphdr *iph, size_t len,
 		       enum ip_conntrack_info ctinfo)
 {
+	/* This is a reply packet, set conntrack to replied.
+	 * Not needed for icmp but it's here for completeness */
+	if (CTINFO2DIR(conntrackinfo) =3D=3D IP_CT_DIR_REPLY)
+		set_bit(IPS_SEEN_REPLY_BIT, &conntrack->status);
+
 	/* Try to delete connection immediately after all replies:
            won't actually vanish as we still have skb, and del_timer
            means this will only run once even if count hits zero twice
--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	2002=
-09-08 00:29:41.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-09-0=
8 00:27:07.000000000 +0200
@@ -222,7 +222,12 @@
 		if (del_timer(&conntrack->timeout))
 			conntrack->timeout.function((unsigned long)conntrack);
 	} else {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
+		/* This is a reply packet, set conntrack to replied. */
+		if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_REPLY)
+			set_bit(IPS_SEEN_REPLY_BIT, &conntrack->status);
+
+		/* Set ASSURED if we see valid ack in
+		 * ESTABLISHED after SYN_RECV */
 		if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_RECV
 		    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL
 		    && tcph->ack && !tcph->syn
--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_udp.c.orig	2002=
-09-08 00:29:15.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2002-09-0=
8 00:20:56.000000000 +0200
@@ -49,6 +49,10 @@
 		      struct iphdr *iph, size_t len,
 		      enum ip_conntrack_info conntrackinfo)
 {
+	/* This is a reply packet, set conntrack to replied. */
+	if (CTINFO2DIR(conntrackinfo) =3D=3D IP_CT_DIR_REPLY)
+		set_bit(IPS_SEEN_REPLY_BIT, &conntrack->status);
+=09
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (conntrack->status & IPS_SEEN_REPLY) {

--=-fZx262d+p/CzK5owkHzo
Content-Disposition: attachment; filename=conntrack-reply-1-gre.diff
Content-Type: text/plain; name=conntrack-reply-1-gre.diff; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_gre.c.orig	2002=
-09-08 00:29:55.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_gre.c	2002-09-0=
8 00:20:45.000000000 +0200
@@ -230,6 +230,10 @@
 		      struct iphdr *iph, size_t len,
 		      enum ip_conntrack_info conntrackinfo)
 {
+	/* This is a reply packet, set conntrack to replied. */
+	if (CTINFO2DIR(conntrackinfo) =3D=3D IP_CT_DIR_REPLY)
+		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+
 	/* If we've seen traffic both ways, this is a GRE connection.
 	 * Extend timeout. */
 	if (ct->status & IPS_SEEN_REPLY) {

--=-fZx262d+p/CzK5owkHzo
Content-Disposition: attachment; filename=conntrack-reply-2.diff
Content-Type: text/plain; name=conntrack-reply-2.diff; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_core.c.orig	2002-08-2=
9 14:13:04.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_core.c	2002-09-08 00:=
39:22.000000000 +0200
@@ -751,7 +751,6 @@
 static inline struct ip_conntrack *
 resolve_normal_ct(struct sk_buff *skb,
 		  struct ip_conntrack_protocol *proto,
-		  int *set_reply,
 		  unsigned int hooknum,
 		  enum ip_conntrack_info *ctinfo)
 {
@@ -776,8 +775,8 @@
 	/* It exists; we have (non-exclusive) reference. */
 	if (DIRECTION(h) =3D=3D IP_CT_DIR_REPLY) {
 		*ctinfo =3D IP_CT_ESTABLISHED + IP_CT_IS_REPLY;
-		/* Please set reply bit if this packet OK */
-		*set_reply =3D 1;
+		/* This is a reply packet, set conntrack to replied. */
+		set_bit(IPS_SEEN_REPLY_BIT, &h->ctrack->status);
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (h->ctrack->status & IPS_SEEN_REPLY) {
@@ -793,7 +792,6 @@
 			       h->ctrack);
 			*ctinfo =3D IP_CT_NEW;
 		}
-		*set_reply =3D 0;
 	}
 	skb->nfct =3D &h->ctrack->infos[*ctinfo];
 	return h->ctrack;
@@ -809,7 +807,6 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack_protocol *proto;
-	int set_reply;
 	int ret;
=20
 	/* FIXME: Do this right please. --RR */
@@ -849,7 +846,7 @@
 	    && icmp_error_track(*pskb, &ctinfo, hooknum))
 		return NF_ACCEPT;
=20
-	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
+	if (!(ct =3D resolve_normal_ct(*pskb, proto, hooknum, &ctinfo)))
 		/* Not valid part of a connection */
 		return NF_ACCEPT;
=20
@@ -877,8 +874,6 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
=20
 	return ret;
 }
--- linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	2002=
-09-08 00:29:41.000000000 +0200
+++ linux-2.4.19-rsn1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-09-0=
8 00:41:51.000000000 +0200
@@ -218,7 +218,9 @@
 	   have an established connection: this is a fairly common
 	   problem case, so we can delete the conntrack
 	   immediately.  --RR */
-	if (!(conntrack->status & IPS_SEEN_REPLY) && tcph->rst) {
+	if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_SENT
+	    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_REPLY
+	    && tcph->rst) {
 		if (del_timer(&conntrack->timeout))
 			conntrack->timeout.function((unsigned long)conntrack);
 	} else {

--=-fZx262d+p/CzK5owkHzo--

--=-O076qCNd46xHhDePK+fG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA9eoTqWm2vlfa207ERAuyrAJ4/DSGDmxLOxwnj+nfmsQ5ro2dVmACePV/i
dOZnPpZ+rsHC9+niQZSgRtI=
=WOoa
-----END PGP SIGNATURE-----

--=-O076qCNd46xHhDePK+fG--
