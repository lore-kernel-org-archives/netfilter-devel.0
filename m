From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Cleanup returnvalues of protocolhandlers
Date: Sun, 19 Sep 2004 22:42:20 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414DEF2C.4040207@trash.net>
References: <1095597972.8380.16.camel@tux.rsn.bth.se>
	<414DEEF0.8020508@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050709090108010907020107"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <414DEEF0.8020508@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050709090108010907020107
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> A couple of conversion where missing in ip_conntrack_proto_icmp.c,
> I've added them to the patch. BTW: shouldn't we return CONNTRACK_INVALID
> for all invalid icmp packets ? icmp_error returns CONNTRACK_INVALID for
> these packets, icmp_error_message (after simple 1:1 conversion) returns
> CONNTRACK_CONT.

Oops, forgot to attach the new patch.

>
> Regards
> Patrick
>
>


--------------050709090108010907020107
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 22:27:45+02:00 gandalf@wlug.westbo.se 
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_udp.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +6 -6
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_tcp.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +13 -13
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +10 -10
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_icmp.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +12 -12
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_generic.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +1 -1
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +11 -13
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/09/19 22:27:23+02:00 gandalf@wlug.westbo.se +8 -0
#   [NETFILTER]: Cleanup return-values of protocol handlers
#   
#   This adds new defines to be returned from conntrack protocol modules in
#   order to make it clear what they want. Most importantly, they get rid of
#   the confusing mixing of positive and negative returnvalues.
#   
#   Based on patch by Pablo Neira.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-19 22:28:48 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-09-19 22:28:48 +02:00
@@ -10,6 +10,14 @@
 #include <linux/compiler.h>
 #include <asm/atomic.h>
 
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
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-19 22:28:48 +02:00
@@ -722,14 +722,14 @@
 
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 
-	/* It may be an special packet, error, unclean...
-	 * inverse of the return code tells to the netfilter
-	 * core what to do with the packet. */
-	if (proto->error != NULL 
-	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0) {
-		CONNTRACK_STAT_INC(error);
-		CONNTRACK_STAT_INC(invalid);
-		return -ret;
+	/* It may be an special packet, error, unclean... */
+	if (proto->error != NULL) {
+		ret = proto->error(*pskb, &ctinfo, hooknum);
+		if (ret != CONNTRACK_CONT) {
+			CONNTRACK_STAT_INC(error);
+			CONNTRACK_STAT_INC(invalid);
+			return ret;
+		}
 	}
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
@@ -747,16 +747,14 @@
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, *pskb, ctinfo);
-	if (ret < 0) {
-		/* Invalid: inverse of the return code tells
-		 * the netfilter core what to do*/
+	if (ret != CONNTRACK_CONT) {
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
 		CONNTRACK_STAT_INC(invalid);
-		return -ret;
+		return ret;
 	}
 
-	if (ret != NF_DROP && ct->helper) {
+	if (ct->helper != NULL) {
 		ret = ct->helper->help(*pskb, ct, ctinfo);
 		if (ret == -1) {
 			/* Invalid */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_generic.c b/net/ipv4/netfilter/ip_conntrack_proto_generic.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-09-19 22:28:48 +02:00
@@ -53,7 +53,7 @@
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-19 22:28:48 +02:00
@@ -105,7 +105,7 @@
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
@@ -148,13 +148,13 @@
 
 	/* Not enough header? */
 	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 
 	/* Ignore ICMP's containing fragments (shouldn't happen) */
 	if (inside.ip.frag_off & htons(IP_OFFSET)) {
 		DEBUGP("icmp_error_track: fragment of proto %u\n",
 		       inside.ip.protocol);
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	}
 
 	innerproto = ip_ct_find_proto(inside.ip.protocol);
@@ -162,14 +162,14 @@
 	/* Are they talking about one of our connections? */
 	if (!ip_ct_get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
 		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	}
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
 	if (!ip_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
 		DEBUGP("icmp_error_track: Can't invert tuple\n");
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	}
 
 	*ctinfo = IP_CT_RELATED;
@@ -184,7 +184,7 @@
 
 		if (!h) {
 			DEBUGP("icmp_error_track: no match\n");
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 		/* Reverse direction from that found */
 		if (DIRECTION(h) != IP_CT_DIR_REPLY)
@@ -197,7 +197,7 @@
 	/* Update skb to refer to this connection */
 	skb->nfct = &h->ctrack->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return -NF_ACCEPT;
+	return CONNTRACK_INVALID;
 }
 
 /* Small and modified version of icmp_rcv */
@@ -212,7 +212,7 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
@@ -226,13 +226,13 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				      "ip_ct_icmp: bad HW ICMP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	case CHECKSUM_NONE:
 		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
 			if (LOG_INVALID(IPPROTO_ICMP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					      "ip_ct_icmp: bad ICMP checksum ");
-			return -NF_ACCEPT;
+			return CONNTRACK_INVALID;
 		}
 	default:
 		break;
@@ -249,7 +249,7 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: invalid ICMP type ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 
 	/* Need to track icmp error message? */
@@ -258,7 +258,7 @@
 	    && icmph.type != ICMP_TIME_EXCEEDED
 	    && icmph.type != ICMP_PARAMETERPROB
 	    && icmph.type != ICMP_REDIRECT)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-19 22:28:48 +02:00
@@ -322,10 +322,10 @@
 	DEBUGP("\n");
 
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &sctph, sizeof(sctph)) != 0)
-		return -1;
+		return CONNTRACK_INVALID;
 
 	if (do_basic_checks(conntrack, skb, map) != 0)
-		return -1;
+		return CONNTRACK_INVALID;
 
 	/* Check the verification tag (Sec 8.5) */
 	if (!test_bit(SCTP_CID_INIT, (void *)map)
@@ -335,7 +335,7 @@
 		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
 		&& (sctph.vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 		DEBUGP("Verification tag check failed\n");
-		return -1;
+		return CONNTRACK_INVALID;
 	}
 
 	oldsctpstate = newconntrack = SCTP_CONNTRACK_MAX;
@@ -347,7 +347,7 @@
 			/* Sec 8.5.1 (A) */
 			if (sctph.vtag != 0) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type == SCTP_CID_ABORT) {
 			/* Sec 8.5.1 (B) */
@@ -355,7 +355,7 @@
 				&& !(sctph.vtag == conntrack->proto.sctp.vtag
 							[1 - CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type == SCTP_CID_SHUTDOWN_COMPLETE) {
 			/* Sec 8.5.1 (C) */
@@ -364,13 +364,13 @@
 							[1 - CTINFO2DIR(ctinfo)] 
 					&& (sch.flags & 1))) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		} else if (sch.type == SCTP_CID_COOKIE_ECHO) {
 			/* Sec 8.5.1 (D) */
 			if (!(sctph.vtag == conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
 				WRITE_UNLOCK(&sctp_lock);
-				return -1;
+				return CONNTRACK_INVALID;
 			}
 		}
 
@@ -382,7 +382,7 @@
 			DEBUGP("ip_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
 			       CTINFO2DIR(ctinfo), sch.type, oldsctpstate);
 			WRITE_UNLOCK(&sctp_lock);
-			return -1;
+			return CONNTRACK_INVALID;
 		}
 
 		/* If it is an INIT or an INIT ACK note down the vtag */
@@ -393,7 +393,7 @@
 			if (skb_copy_bits(skb, offset + sizeof (sctp_chunkhdr_t),
 				&inithdr, sizeof(inithdr)) != 0) {
 					WRITE_UNLOCK(&sctp_lock);
-					return -1;
+					return CONNTRACK_INVALID;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
 					inithdr.init_tag, CTINFO2DIR(ctinfo));
@@ -413,7 +413,7 @@
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	}
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-09-19 22:28:48 +02:00
@@ -784,7 +784,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				"ip_ct_tcp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
   	}
   
 	/* Not whole TCP header or malformed packet */
@@ -792,7 +792,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				"ip_ct_tcp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
   
 	/* Checksum invalid? Ignore.
@@ -808,7 +808,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: bad TCP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 
 	/* Check TCP flags. */
@@ -817,10 +817,10 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid TCP flag combination ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
@@ -867,7 +867,7 @@
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_DROP;
+		    	return CONNTRACK_DROP;
 		}
 		conntrack->proto.tcp.last_index = index;
 		conntrack->proto.tcp.last_dir = dir;
@@ -877,7 +877,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid SYN (ignored) ");
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
 		DEBUGP("ip_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
@@ -887,7 +887,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid state ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state >= TCP_CONNTRACK_TIME_WAIT) {	
 		    	/* Attempt to reopen a closed connection.
@@ -896,7 +896,7 @@
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_REPEAT;
+		    	return CONNTRACK_REPEAT;
 		}
 		break;
 	case TCP_CONNTRACK_CLOSE:
@@ -911,7 +911,7 @@
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					  "ip_ct_tcp: invalid RST (ignored) ");
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 		/* Just fall trough */
 	default:
@@ -922,7 +922,7 @@
 	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index, 
 			   skb, iph, th)) {
 		WRITE_UNLOCK(&tcp_lock);
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 	/* From now on we have got in-window packets */
 	
@@ -953,7 +953,7 @@
 			if (del_timer(&conntrack->timeout))
 				conntrack->timeout.function((unsigned long)
 							    conntrack);
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
@@ -966,7 +966,7 @@
 	}
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
  
   /* Called when a new connection for this protocol found. */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-09-19 22:28:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-09-19 22:28:48 +02:00
@@ -77,7 +77,7 @@
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
@@ -98,7 +98,7 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: short packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 	
 	/* Truncated/malformed packets */
@@ -106,12 +106,12 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 	
 	/* Packet with no checksum */
 	if (!hdr.check)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
@@ -125,10 +125,10 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: bad UDP checksum ");
-		return -NF_ACCEPT;
+		return CONNTRACK_INVALID;
 	}
 	
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 struct ip_conntrack_protocol ip_conntrack_protocol_udp =

--------------050709090108010907020107--
