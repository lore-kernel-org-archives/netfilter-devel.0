From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: improve out-of-sync situation in TCP
	tracking
Date: Sat, 14 Nov 2009 12:10:04 +0100
Message-ID: <20091114111004.7461.37215.stgit@decadence>
References: <20091114110651.7461.84924.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZKNLKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:10:03 -0500
In-Reply-To: <20091114110651.7461.84924.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this patch, if we receive a SYN packet from the client while
the firewall is out-of-sync, we let it go through. Then, if we see
the SYN/ACK reply coming from the server, we destroy the conntrack
entry and drop the packet to trigger a new retransmission. Then,
the retransmision from the client is used to start a new clean
session.

This patch improves the current handling. Basically, if we see an
unexpected SYN packet, we annotate the TCP options. Then, if we
see the reply SYN/ACK, this means that the firewall was indeed
out-of-sync. Therefore, we set a clean new session from the existing
entry based on the annotated values.

This patch adds two new 8-bits fields that fit in a 16-bits gap of
the ip_ct_tcp structure.

This patch is particularly useful for conntrackd since the
asynchronous nature of the state-synchronization allows to have
backup nodes that are not perfect copies of the master. This helps
to improve the recovery under some worst-case scenarios.

I have tested this by creating lots of conntrack entries in wrong
state:

for ((i=1024;i<65535;i++)); do conntrack -I -p tcp -s 192.168.2.101 -d 192.168.2.2 --sport $i --dport 80 -t 800 --state ESTABLISHED -u ASSURED,SEEN_REPLY; done

Then, I make some TCP connections:

$ echo GET / | nc 192.168.2.2 80

The events show the result:

 [UPDATE] tcp      6 60 SYN_RECV src=192.168.2.101 dst=192.168.2.2 sport=33220 dport=80 src=192.168.2.2 dst=192.168.2.101 sport=80 dport=33220 [ASSURED]
 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.2.101 dst=192.168.2.2 sport=33220 dport=80 src=192.168.2.2 dst=192.168.2.101 sport=80 dport=33220 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.2.101 dst=192.168.2.2 sport=33220 dport=80 src=192.168.2.2 dst=192.168.2.101 sport=80 dport=33220 [ASSURED]
 [UPDATE] tcp      6 30 LAST_ACK src=192.168.2.101 dst=192.168.2.2 sport=33220 dport=80 src=192.168.2.2 dst=192.168.2.101 sport=80 dport=33220 [ASSURED]
 [UPDATE] tcp      6 120 TIME_WAIT src=192.168.2.101 dst=192.168.2.2 sport=33220 dport=80 src=192.168.2.2 dst=192.168.2.101 sport=80 dport=33220 [ASSURED]

and tcpdump shows no retransmissions:

20:47:57.271951 IP 192.168.2.101.33221 > 192.168.2.2.www: S 435402517:435402517(0) win 5840 <mss 1460,sackOK,timestamp 4294961827 0,nop,wscale 6>
20:47:57.273538 IP 192.168.2.2.www > 192.168.2.101.33221: S 3509927945:3509927945(0) ack 435402518 win 5792 <mss 1460,sackOK,timestamp 235681024 4294961827,nop,wscale 4>
20:47:57.273608 IP 192.168.2.101.33221 > 192.168.2.2.www: . ack 3509927946 win 92 <nop,nop,timestamp 4294961827 235681024>
20:47:57.273693 IP 192.168.2.101.33221 > 192.168.2.2.www: P 435402518:435402524(6) ack 3509927946 win 92 <nop,nop,timestamp 4294961827 235681024>
20:47:57.275492 IP 192.168.2.2.www > 192.168.2.101.33221: . ack 435402524 win 362 <nop,nop,timestamp 235681024 4294961827>
20:47:57.276492 IP 192.168.2.2.www > 192.168.2.101.33221: P 3509927946:3509928082(136) ack 435402524 win 362 <nop,nop,timestamp 235681025 4294961827>
20:47:57.276515 IP 192.168.2.101.33221 > 192.168.2.2.www: . ack 3509928082 win 108 <nop,nop,timestamp 4294961828 235681025>
20:47:57.276521 IP 192.168.2.2.www > 192.168.2.101.33221: F 3509928082:3509928082(0) ack 435402524 win 362 <nop,nop,timestamp 235681025 4294961827>
20:47:57.277369 IP 192.168.2.101.33221 > 192.168.2.2.www: F 435402524:435402524(0) ack 3509928083 win 108 <nop,nop,timestamp 4294961828 235681025>
20:47:57.279491 IP 192.168.2.2.www > 192.168.2.101.33221: . ack 435402525 win 362 <nop,nop,timestamp 235681025 4294961828>

I also added a rule to log invalid packets, with no occurrences :-).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nf_conntrack_tcp.h |    3 ++
 net/netfilter/nf_conntrack_proto_tcp.c     |   51 +++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index f6d97f6..6e135f9 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -66,6 +66,9 @@ struct ip_ct_tcp {
 	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
 	u_int32_t	last_end;	/* Last seq + len */
 	u_int16_t	last_win;	/* Last window advertisement seen in dir */
+	/* For SYN packets while we may be out-of-sync */
+	u_int8_t	last_wscale;	/* Last window scaling factor seen */
+	u_int8_t	last_flags;	/* Last flags set */
 };
 
 #endif /* __KERNEL__ */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ba2b769..37a8c74 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -896,23 +896,54 @@ static int tcp_packet(struct nf_conn *ct,
 			/* b) This SYN/ACK acknowledges a SYN that we earlier
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
-			 * not. We kill this session and block the SYN/ACK so
-			 * that the client cannot but retransmit its SYN and
-			 * thus initiate a clean new session.
+			 * not. We get in sync from the previously annotated
+			 * values.
 			 */
-			spin_unlock_bh(&ct->lock);
-			if (LOG_INVALID(net, IPPROTO_TCP))
-				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-					  "nf_ct_tcp: killing out of sync session ");
-			nf_ct_kill(ct);
-			return NF_DROP;
+			old_state = TCP_CONNTRACK_SYN_SENT;
+			new_state = TCP_CONNTRACK_SYN_RECV;
+			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_end =
+				ct->proto.tcp.last_end;
+			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxend =
+				ct->proto.tcp.last_end;
+			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxwin =
+				ct->proto.tcp.last_win == 0 ?
+					1 : ct->proto.tcp.last_win;
+			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_scale =
+				ct->proto.tcp.last_wscale;
+			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
+				ct->proto.tcp.last_flags;
+			memset(&ct->proto.tcp.seen[dir], 0,
+			       sizeof(struct ip_ct_tcp_state));
+			break;
 		}
 		ct->proto.tcp.last_index = index;
 		ct->proto.tcp.last_dir = dir;
 		ct->proto.tcp.last_seq = ntohl(th->seq);
 		ct->proto.tcp.last_end =
 		    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
-
+		ct->proto.tcp.last_win = ntohs(th->window);
+
+		/* a) This is a SYN in ORIGINAL. The client and the server
+		 * may be in sync but we are not. In that case, we annotate
+		 * the TCP options and let the packet go through. If it is a
+		 * valid SYN packet, the server will reply with a SYN/ACK, and
+		 * then we'll get in sync. Otherwise, the server ignores it. */
+		if (index == TCP_SYN_SET && dir == IP_CT_DIR_ORIGINAL) {
+			struct ip_ct_tcp_state seen = {};
+
+			ct->proto.tcp.last_flags =
+			ct->proto.tcp.last_wscale = 0;
+			tcp_options(skb, dataoff, th, &seen);
+			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+				ct->proto.tcp.last_flags |=
+					IP_CT_TCP_FLAG_WINDOW_SCALE;
+				ct->proto.tcp.last_wscale = seen.td_scale;
+			}
+			if (seen.flags & IP_CT_TCP_FLAG_SACK_PERM) {
+				ct->proto.tcp.last_flags |=
+					IP_CT_TCP_FLAG_SACK_PERM;
+			}
+		}
 		spin_unlock_bh(&ct->lock);
 		if (LOG_INVALID(net, IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,

