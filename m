From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] TCP window tracking retransmission handling
Date: Mon, 24 Jan 2005 22:07:05 -0800
Message-ID: <20050125060705.GA32479@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Under certain circumstances (high latency WAN links for instance), ack
packets get stacked up and arrive in bulk.  The current TCP window
tracking code interprets these numerous acks as retransmits, and
if there are >= 3 retransmits sequentially, it resets the timeout on
a conntrack to 5 minutes.

This is trivially reproducible on a high latency link by an 'ls -lR'
on a large-ish tree.  In my test case, 8 ack packets arrived sequentially
at the end of the listing.  While the seq numbers on those packets
were indeed identical (which the current code tests for), they were acking
unique packets, and thus clearly do not qualify as retransmissions.

The problem lies in the fact that the code currently only examines
the seq number of the arriving packet, but does not also look at the
seq number being acked.  The patch below adds this additional check.
Unfortunately, it adds another int32 to ip_ct_tcp, but I could think
of no other fool-proof way of fixing it (short of ripping out the
retransmission test altogether).

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ack

diff -ru linux-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-new/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- linux-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-12-24 16:34:31.000000000 -0500
+++ linux-new/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-01-25 00:31:46.772442512 -0500
@@ -41,6 +41,7 @@
 	u_int8_t	retrans;	/* Number of retransmitted packets */
 	u_int8_t	last_index;	/* Index of the last packet */
 	u_int32_t	last_seq;	/* Last sequence number seen in dir */
+	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
 	u_int32_t	last_end;	/* Last seq + len */
 };
 
diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-new/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-25 00:46:13.192726608 -0500
+++ linux-new/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-25 00:43:35.340723760 -0500
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

--wRRV7LY7NUeQGEoC--
