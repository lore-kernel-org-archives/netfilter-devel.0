From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking has bad side effects
Date: Fri, 10 Dec 2004 11:03:29 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412101052450.14449@blackhole.kfki.hu>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
	<20041201153903.GA16807@suse.de>
	<Pine.LNX.4.58.0412030942320.30157@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412060934050.5880@blackhole.kfki.hu>
	<20041209162656.GA9569@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
In-Reply-To: <20041209162656.GA9569@suse.de>
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

Hi Ludwing,

On Thu, 9 Dec 2004, Ludwig Nussel wrote:

> Seems to work. The client machine no longer drops the packet and
> properly sends RST.

Thank you for the bug and test reports. Attached is the patch for kernel
inclusion by Dave: Patrick rewived the previous one and noted that a
condition was errorneously dropped - it's back now and a typo in logging
is fixed as well. If you run the previous code on a production machine,
please replace it with the new one.

Best regards,
Jozsef

-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.6.9-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- linux-2.6.9-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-10-18 23:53:51.000000000 +0200
+++ linux-2.6.9-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-12-06 06:52:07.000000000 +0100
@@ -18,7 +18,7 @@
 };

 /* Window scaling is advertised by the sender */
-#define IP_CT_TCP_STATE_FLAG_WINDOW_SCALE	0x01
+#define IP_CT_TCP_FLAG_WINDOW_SCALE		0x01

 /* SACK is permitted by the sender */
 #define IP_CT_TCP_FLAG_SACK_PERM		0x02
diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.6.9-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-18 23:55:29.000000000 +0200
+++ linux-2.6.9-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-10 08:52:55.000000000 +0100
@@ -273,9 +273,9 @@
  *	sCL -> sCL
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
-/*ack*/	   { sIV, sIV, sIV, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*ack*/	   { sIV, sIG, sIV, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sSS -> sIV	ACK is invalid: we haven't seen a SYN/ACK yet.
+ *	sSS -> sIG	Might be a half-open connection.
  *	sSR -> sIV	Simultaneous open.
  *	sES -> sES	:-)
  *	sFW -> sCW	Normal close request answered by ACK.
@@ -436,7 +436,7 @@
 					state->td_scale = 14;
 				}
 				state->flags |=
-					IP_CT_TCP_STATE_FLAG_WINDOW_SCALE;
+					IP_CT_TCP_FLAG_WINDOW_SCALE;
 			}
 			ptr += opsize - 2;
 			length -= opsize;
@@ -552,8 +552,8 @@
 			 * Both sides must send the Window Scale option
 			 * to enable window scaling in either direction.
 			 */
-			if (!(sender->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE
-			      && receiver->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE))
+			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
+			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
 				sender->td_scale =
 				receiver->td_scale = 0;
 		} else {
@@ -566,9 +566,11 @@
 			sender->td_maxwin = (win == 0 ? 1 : win);
 			sender->td_maxend = end + sender->td_maxwin;
 		}
-	} else if (state->state == TCP_CONNTRACK_SYN_SENT
-		   && dir == IP_CT_DIR_ORIGINAL
-		   && after(end, sender->td_end)) {
+	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
+		     && dir == IP_CT_DIR_ORIGINAL)
+		    || (state->state == TCP_CONNTRACK_SYN_RECV
+		        && dir == IP_CT_DIR_REPLY))
+		    && after(end, sender->td_end)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
 		 * not wait at all; it must only be sure to use sequence
@@ -685,7 +687,7 @@
 			"ip_ct_tcp: %s ",
 			before(end, sender->td_maxend + 1) ?
 			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
-			before(ack, receiver->td_end + 1) ?
+			before(sack, receiver->td_end + 1) ?
 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
 			: "ACK is under the lower bound (possibly overly delayed ACK)"
 			: "ACK is over the upper bound (ACKed data has never seen yet)"
@@ -847,7 +849,9 @@

 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
-		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
+		/* Either SYN in ORIGINAL
+		 * or SYN/ACK in REPLY
+		 * or ACK in REPLY direction (half-open connection). */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
@@ -876,7 +880,7 @@
 		WRITE_UNLOCK(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
-				  "ip_ct_tcp: invalid SYN (ignored) ");
+				  "ip_ct_tcp: invalid packet ignored ");
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
@@ -901,11 +905,12 @@
 		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET
+		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
+		        || conntrack->proto.tcp.last_index == TCP_ACK_SET)
 		    && after(ntohl(th->ack_seq),
 		    	     conntrack->proto.tcp.last_seq)) {
-			/* Ignore RST closing down invalid SYN
+			/* Ignore RST closing down invalid SYN or ACK
 			   we had let trough. */
 		    	WRITE_UNLOCK(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
