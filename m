From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.10 1/4]: Improve TCP window tracking retransmission
	detection
Date: Fri, 04 Feb 2005 04:05:10 +0100
Message-ID: <4202E666.8020707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090308060506050508030500"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------090308060506050508030500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The TCP window tracking code detects retransmissions by counting the number
of dup-ACKs. Phil Oester points out that the current retransmission 
detection has
false positives under very common conditions, multiple ACKs for different
sequence numbers arriving back-to-back. The problem is that the window 
tracking
code doesn't look at the ACKed sequence number, but only at the start and
end sequence number of the current packet. This patch fixes the problem 
by making
the code remeber and check against the last ACKed sequence number.



--------------090308060506050508030500
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/01 14:14:17+01:00 kernel@linuxace.com 
#   [NETFILTER]: Improve TCP window tracking retransmission detection
#   
#   Under certain circumstances (high latency WAN links for instance), ack
#   packets get stacked up and arrive in bulk.  The current TCP window
#   tracking code interprets these numerous acks as retransmits, and
#   if there are >= 3 retransmits sequentially, it resets the timeout on
#   a conntrack to 5 minutes.
#   
#   The problem lies in the fact that the code currently only examines
#   the seq number of the arriving packet, but does not also look at the
#   seq number being acked.  The patch below adds this additional check.
#   Unfortunately, it adds another int32 to ip_ct_tcp, but I could think
#   of no other fool-proof way of fixing it (short of ripping out the
#   retransmission test altogether).
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_tcp.c
#   2005/02/01 14:14:08+01:00 kernel@linuxace.com +2 -0
#   [NETFILTER]: Improve TCP window tracking retransmission detection
#   
#   Under certain circumstances (high latency WAN links for instance), ack
#   packets get stacked up and arrive in bulk.  The current TCP window
#   tracking code interprets these numerous acks as retransmits, and
#   if there are >= 3 retransmits sequentially, it resets the timeout on
#   a conntrack to 5 minutes.
#   
#   The problem lies in the fact that the code currently only examines
#   the seq number of the arriving packet, but does not also look at the
#   seq number being acked.  The patch below adds this additional check.
#   Unfortunately, it adds another int32 to ip_ct_tcp, but I could think
#   of no other fool-proof way of fixing it (short of ripping out the
#   retransmission test altogether).
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_tcp.h
#   2005/02/01 14:14:07+01:00 kernel@linuxace.com +1 -0
#   [NETFILTER]: Improve TCP window tracking retransmission detection
#   
#   Under certain circumstances (high latency WAN links for instance), ack
#   packets get stacked up and arrive in bulk.  The current TCP window
#   tracking code interprets these numerous acks as retransmits, and
#   if there are >= 3 retransmits sequentially, it resets the timeout on
#   a conntrack to 5 minutes.
#   
#   The problem lies in the fact that the code currently only examines
#   the seq number of the arriving packet, but does not also look at the
#   seq number being acked.  The patch below adds this additional check.
#   Unfortunately, it adds another int32 to ip_ct_tcp, but I could think
#   of no other fool-proof way of fixing it (short of ripping out the
#   retransmission test altogether).
#   
#   Signed-off-by: Phil Oester <kernel@linuxace.com>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_tcp.h b/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-02-04 03:35:39 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-02-04 03:35:39 +01:00
@@ -41,6 +41,7 @@
 	u_int8_t	retrans;	/* Number of retransmitted packets */
 	u_int8_t	last_index;	/* Index of the last packet */
 	u_int32_t	last_seq;	/* Last sequence number seen in dir */
+	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
 	u_int32_t	last_end;	/* Last seq + len */
 };
 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-02-04 03:35:39 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-02-04 03:35:39 +01:00
@@ -665,11 +665,13 @@
 		if (*index == TCP_ACK_SET) {
 			if (state->last_dir == dir
 			    && state->last_seq == seq
+			    && state->last_ack == ack
 			    && state->last_end == end)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
+				state->last_ack = ack;
 				state->last_end = end;
 				state->retrans = 0;
 			}

--------------090308060506050508030500--
