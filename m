From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 2/2] Cleanup returnvalues of protocolhandlers
Date: Sun, 19 Sep 2004 14:46:12 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095597972.8380.16.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-nB0FNmOly8PD3qxzDrvo"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-nB0FNmOly8PD3qxzDrvo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick

Here's the second of two patches based on Pablo Neiras patch.

This adds new defines to be returned from conntrack protocol modules in
order to make it clear what they want. Most importantly, they get rid of
the confusing mixing of positive and negative returnvalues.

This patch is incremental to the first one ([PATCH 1/2] Cleanup ctstat)

Please submit for 2.6

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/include/linux/netfilter_i=
pv4/ip_conntrack.h linux-2.6.9-rc1-bk16/include/linux/netfilter_ipv4/ip_con=
ntrack.h
--- linux-2.6.9-rc1-bk16.stats/include/linux/netfilter_ipv4/ip_conntrack.h	=
2004-09-10 11:33:31.000000000 +0200
+++ linux-2.6.9-rc1-bk16/include/linux/netfilter_ipv4/ip_conntrack.h	2004-0=
9-11 14:00:13.000000000 +0200
@@ -10,6 +10,14 @@
 #include <linux/compiler.h>
 #include <asm/atomic.h>
=20
+/* Protocol specific functions (packet and error) return one of the
+ * return values defined below. Return CONNTRACK_CONT to perform no action
+ * on a packet. */
+#define CONNTRACK_CONT -1
+#define CONNTRACK_INVALID NF_ACCEPT
+#define CONNTRACK_DROP NF_DROP
+#define CONNTRACK_REPEAT NF_REPEAT
+
 enum ip_conntrack_info
 {
 	/* Part of an established connection (either direction). */
diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_con=
ntrack_core.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_core.c	2004-=
09-11 13:28:41.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-11 =
13:43:12.000000000 +0200
@@ -786,14 +786,14 @@ unsigned int ip_conntrack_in(unsigned in
=20
 	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
=20
-	/* It may be an special packet, error, unclean...
-	 * inverse of the return code tells to the netfilter
-	 * core what to do with the packet. */
-	if (proto->error !=3D NULL=20
-	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0) {
-		CONNTRACK_STAT_INC(error);
-		CONNTRACK_STAT_INC(invalid);
-		return -ret;
+	/* It may be an special packet, error, unclean... */
+	if (proto->error !=3D NULL) {
+		ret =3D proto->error(*pskb, &ctinfo, hooknum);
+		if (ret !=3D CONNTRACK_CONT) {
+			CONNTRACK_STAT_INC(error);
+			CONNTRACK_STAT_INC(invalid);
+			return ret;
+		}
 	}
=20
 	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))=
 {
@@ -811,16 +811,14 @@ unsigned int ip_conntrack_in(unsigned in
 	IP_NF_ASSERT((*pskb)->nfct);
=20
 	ret =3D proto->packet(ct, *pskb, ctinfo);
-	if (ret < 0) {
-		/* Invalid: inverse of the return code tells
-		 * the netfilter core what to do*/
+	if (ret !=3D CONNTRACK_CONT) {
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct =3D NULL;
 		CONNTRACK_STAT_INC(invalid);
-		return -ret;
+		return ret;
 	}
=20
-	if (ret !=3D NF_DROP && ct->helper) {
+	if (ct->helper !=3D NULL) {
 		ret =3D ct->helper->help(*pskb, ct, ctinfo);
 		if (ret =3D=3D -1) {
 			/* Invalid */
diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_con=
ntrack_proto_generic.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack=
_proto_generic.c
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_proto_generi=
c.c	2004-09-10 11:33:19.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_proto_generic.c	20=
04-09-11 13:37:13.000000000 +0200
@@ -53,7 +53,7 @@ static int packet(struct ip_conntrack *c
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 /* Called when a new connection for this protocol found. */
diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_con=
ntrack_proto_icmp.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_pr=
oto_icmp.c
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=
	2004-09-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-=
09-11 13:37:13.000000000 +0200
@@ -104,7 +104,7 @@ static int icmp_packet(struct ip_conntra
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
=20
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 /* Called when a new connection for this protocol found. */
@@ -195,7 +195,7 @@ icmp_error_message(struct sk_buff *skb,
=20
 	/* Update skb to refer to this connection */
 	skb->nfct =3D &h->ctrack->infos[*ctinfo];
-	return -NF_ACCEPT;
+	return CONNTRACK_INVALID;
 }
=20
 /* Small and modified version of icmp_rcv */
@@ -210,7 +210,7 @@ icmp_error(struct sk_buff *skb, enum ip_
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
=20
 	/* See ip_conntrack_proto_tcp.c */
@@ -224,13 +224,13 @@ icmp_error(struct sk_buff *skb, enum ip_
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				      "ip_ct_icmp: bad HW ICMP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	case CHECKSUM_NONE:
 		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
 			if (LOG_INVALID(IPPROTO_ICMP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 					      "ip_ct_icmp: bad ICMP checksum ");
-			return -NF_ACCEPT;
+			return CONNTRACK_INVALID;
 		}
 	default:
 		break;
@@ -247,7 +247,7 @@ checksum_skipped:
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: invalid ICMP type ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
=20
 	/* Need to track icmp error message? */
@@ -256,7 +256,7 @@ checksum_skipped:
 	    && icmph.type !=3D ICMP_TIME_EXCEEDED
 	    && icmph.type !=3D ICMP_PARAMETERPROB
 	    && icmph.type !=3D ICMP_REDIRECT)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
=20
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_con=
ntrack_proto_tcp.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_pro=
to_tcp.c
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	=
2004-09-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-0=
9-11 13:37:13.000000000 +0200
@@ -784,7 +784,7 @@ static int tcp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				"ip_ct_tcp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
   	}
  =20
 	/* Not whole TCP header or malformed packet */
@@ -792,7 +792,7 @@ static int tcp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				"ip_ct_tcp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
  =20
 	/* Checksum invalid? Ignore.
@@ -808,7 +808,7 @@ static int tcp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_tcp: bad TCP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
=20
 	/* Check TCP flags. */
@@ -817,10 +817,10 @@ static int tcp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_tcp: invalid TCP flag combination ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
=20
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 /* Returns verdict for packet, or -1 for invalid. */
@@ -867,7 +867,7 @@ static int tcp_packet(struct ip_conntrac
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_DROP;
+		    	return CONNTRACK_DROP;
 		}
 		conntrack->proto.tcp.last_index =3D index;
 		conntrack->proto.tcp.last_dir =3D dir;
@@ -877,7 +877,7 @@ static int tcp_packet(struct ip_conntrac
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_tcp: invalid SYN (ignored) ");
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
 		DEBUGP("ip_ct_tcp: Invalid dir=3D%i index=3D%u ostate=3D%u\n",
@@ -887,7 +887,7 @@ static int tcp_packet(struct ip_conntrac
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_tcp: invalid state ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state >=3D TCP_CONNTRACK_TIME_WAIT) {=09
 		    	/* Attempt to reopen a closed connection.
@@ -896,7 +896,7 @@ static int tcp_packet(struct ip_conntrac
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_REPEAT;
+		    	return CONNTRACK_REPEAT;
 		}
 		break;
 	case TCP_CONNTRACK_CLOSE:
@@ -911,7 +911,7 @@ static int tcp_packet(struct ip_conntrac
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 					  "ip_ct_tcp: invalid RST (ignored) ");
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 		/* Just fall trough */
 	default:
@@ -922,7 +922,7 @@ static int tcp_packet(struct ip_conntrac
 	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index,=20
 			   skb, iph, th)) {
 		WRITE_UNLOCK(&tcp_lock);
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 	/* From now on we have got in-window packets */
 =09
@@ -953,7 +953,7 @@ static int tcp_packet(struct ip_conntrac
 			if (del_timer(&conntrack->timeout))
 				conntrack->timeout.function((unsigned long)
 							    conntrack);
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
 		   && (old_state =3D=3D TCP_CONNTRACK_SYN_RECV
@@ -966,7 +966,7 @@ static int tcp_packet(struct ip_conntrac
 	}
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
=20
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 =20
   /* Called when a new connection for this protocol found. */
diff -urNp -x '*.orig' linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_con=
ntrack_proto_udp.c linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_pro=
to_udp.c
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_proto_udp.c	=
2004-09-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-0=
9-11 13:37:13.000000000 +0200
@@ -76,7 +76,7 @@ static int udp_packet(struct ip_conntrac
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
=20
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 /* Called when a new connection for this protocol found. */
@@ -97,7 +97,7 @@ static int udp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_udp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 =09
 	/* Truncated/malformed packets */
@@ -105,12 +105,12 @@ static int udp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_udp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 =09
 	/* Packet with no checksum */
 	if (!hdr.check)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
=20
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
@@ -124,10 +124,10 @@ static int udp_error(struct sk_buff *skb
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
 				  "ip_ct_udp: bad UDP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 =09
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 struct ip_conntrack_protocol ip_conntrack_protocol_udp =3D
--- linux-2.6.9-rc1-bk16.stats/net/ipv4/netfilter/ip_conntrack_proto_sctp.c=
	2004-09-10 11:33:32.000000000 +0200
+++ linux-2.6.9-rc1-bk16/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-=
09-11 13:49:31.000000000 +0200
@@ -321,10 +321,10 @@ static int sctp_packet(struct ip_conntra
 	DEBUGP("\n");
=20
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &sctph, sizeof(sctph)) !=3D =
0)
-		return -1;
+		return CONNTRACK_INVALID;
=20
 	if (do_basic_checks(conntrack, skb, map) !=3D 0)
-		return -1;
+		return CONNTRACK_INVALID;
=20
 	/* Check the verification tag (Sec 8.5) */
 	if (!test_bit(SCTP_CID_INIT, (void *)map)
@@ -334,7 +334,7 @@ static int sctp_packet(struct ip_conntra
 		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
 		&& (sctph.vtag !=3D conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 		DEBUGP("Verification tag check failed\n");
-		return -1;
+		return CONNTRACK_INVALID;
 	}
=20
 	oldsctpstate =3D newconntrack =3D SCTP_CONNTRACK_MAX;
@@ -346,7 +346,7 @@ static int sctp_packet(struct ip_conntra
 			/* Sec 8.5.1 (A) */
 			if (sctph.vtag !=3D 0) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type =3D=3D SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
@@ -354,7 +354,7 @@ static int sctp_packet(struct ip_conntra
 				&& !(sctph.vtag =3D=3D conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type =3D=3D SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
@@ -363,13 +363,13 @@ static int sctp_packet(struct ip_conntra
 							[1 - CTINFO2DIR(ctinfo)]=20
 					&& (sch.flags & 1))) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type =3D=3D SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
 			if (!(sctph.vtag =3D=3D conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])=
) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		}
=20
@@ -381,7 +381,7 @@ static int sctp_packet(struct ip_conntra
 			DEBUGP("ip_conntrack_sctp: Invalid dir=3D%i ctype=3D%u conntrack=3D%u\n=
",
 			       CTINFO2DIR(ctinfo), sch.type, oldsctpstate);
 			WRITE_UNLOCK(&sctp_lock);
-			return -1;
+			return CONNTRACK_INVALID;
 		}
=20
 		/* If it is an INIT or an INIT ACK note down the vtag */
@@ -392,7 +392,7 @@ static int sctp_packet(struct ip_conntra
 			if (skb_copy_bits(skb, offset + sizeof (sctp_chunkhdr_t),
 				&inithdr, sizeof(inithdr)) !=3D 0) {
 					WRITE_UNLOCK(&sctp_lock);
-					return -1;
+					return CONNTRACK_INVALID;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n",=20
 					inithdr.init_tag, CTINFO2DIR(ctinfo));
@@ -412,7 +412,7 @@ static int sctp_packet(struct ip_conntra
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	}
=20
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
=20
 /* Called when a new connection for this protocol found. */

--=20
/Martin

--=-nB0FNmOly8PD3qxzDrvo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBTX+UWm2vlfa207ERAnrNAJwNhia0fSYO05wKKsVZYC5up7l/BACfYCTT
ZqeTjmuAonD4yyz3SIdecpw=
=lOqM
-----END PGP SIGNATURE-----

--=-nB0FNmOly8PD3qxzDrvo--
