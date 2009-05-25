From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Fix accepting invalid RST segments
Date: Mon, 25 May 2009 12:35:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905251204300.19770@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34972 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZEYKfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2009 06:35:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Robert L Mathews discovered that some clients send evil TCP RST segments, 
which are accepted by netfilter conntrack but discarded by the 
destination. Thus the conntrack entry is destroyed but the destination 
retransmits data until timeout.

The same technique, i.e. sending properly crafted RST segments, can easily 
be used to bypass connlimit/connbytes based restrictions (the sample 
script written by Robert can be found in the netfilter mailing list 
archives).

The patch below adds a new flag and new field to struct ip_ct_tcp_state so 
that checking RST segments can be made more strict and thus TCP conntrack 
can catch the invalid ones: the RST segment is accepted only if its 
sequence number higher than or equal to the highest ack we seen from the 
other direction. (The last_ack field cannot be reused because it is used 
to catch resent packets.)

Please send the patch for kernel inclusion.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 3066789..b2f384d 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -35,6 +35,9 @@ enum tcp_conntrack {
 /* Has unacknowledged data */
 #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
 
+/* The field td_maxack has been set */
+#define IP_CT_TCP_FLAG_MAXACK_SET		0x20
+
 struct nf_ct_tcp_flags {
 	__u8 flags;
 	__u8 mask;
@@ -46,6 +49,7 @@ struct ip_ct_tcp_state {
 	u_int32_t	td_end;		/* max of seq + len */
 	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
 	u_int32_t	td_maxwin;	/* max(win) */
+	u_int32_t	td_maxack;	/* max of ack */
 	u_int8_t	td_scale;	/* window scale factor */
 	u_int8_t	flags;		/* per direction options */
 };
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b5ccf2b..97a6e93 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -634,6 +634,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			sender->td_end = end;
 			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 		}
+		if (tcph->ack) {
+			if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
+				sender->td_maxack = ack;
+				sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
+			} else if (after(ack, sender->td_maxack))
+				sender->td_maxack = ack;
+		}
+
 		/*
 		 * Update receiver data.
 		 */
@@ -919,6 +927,16 @@ static int tcp_packet(struct nf_conn *ct,
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
+		    && (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET)
+		    && before(ntohl(th->seq), ct->proto.tcp.seen[!dir].td_maxack)) {
+			/* Invalid RST  */
+			write_unlock_bh(&tcp_lock);
+			if (LOG_INVALID(net, IPPROTO_TCP))
+				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
+					  "nf_ct_tcp: invalid RST ");
+			return -NF_ACCEPT;
+		}
+		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
 			 && ct->proto.tcp.last_index == TCP_SYN_SET)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
