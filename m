From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Resend: TCP window tracking fixes
Date: Tue, 1 Feb 2005 15:25:04 -0800
Message-ID: <20050201232504.GA27476@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Resending two patches which have not yet made it to mainline, and
which (IMO) are fairly important and should go in before 2.6.11.

1) retransmission handling -- window tracking needs to look at both
   seq numbers in determining whether a retransmission has occurred

   http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018241.html

2) over-window handling -- window tracking should not adjust down
   the maximum seq number which it thinks a client has received --
   the client may disagree with this number

   http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018278.html

Patches attached below, comments welcomed.

Phil




--IJpNTDwzlM2Ie8A6
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

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-overwindow

diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:48:10.620973992 -0500
+++ linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:54:02.799434728 -0500
@@ -622,7 +622,6 @@
 	/* Ignore data over the right edge of the receiver's window. */
 	if (after(end, sender->td_maxend) &&
 	    before(seq, sender->td_maxend)) {
-		end = sender->td_maxend;
 		if (*index == TCP_FIN_SET)
 			*index = TCP_ACK_SET;
 	}
@@ -691,9 +690,9 @@
 			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
 			before(sack, receiver->td_end + 1) ?
 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
-			: "ACK is under the lower bound (possibly overly delayed ACK)"
-			: "ACK is over the upper bound (ACKed data has never seen yet)"
-			: "SEQ is under the lower bound (retransmitted already ACKed data)"
+			: "ACK is under the lower bound (possible overly delayed ACK)"
+			: "ACK is over the upper bound (ACKed data not seen yet)"
+			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
 
 		res = ip_ct_tcp_be_liberal && !tcph->rst;

--IJpNTDwzlM2Ie8A6--
