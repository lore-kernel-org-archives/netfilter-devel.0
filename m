From: Michal Rokos <michal@rokos.info>
Subject: Re: nf_conntrack resync with 2.6.11-rc4
Date: Tue, 15 Feb 2005 16:15:23 +0100
Message-ID: <200502151615.23463.michal@rokos.info>
References: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LIhEC0v2U602e8G"
Cc: Harald Welte <laforge@netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
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

--Boundary-00=_LIhEC0v2U602e8G
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Harald,

On Tuesday 15 February 2005 13:47, Harald Welte wrote:
> Since lots of changes went into ip_conntrack over the last months, I
> went through the pain of re-synchronizing nf_conntrack with
> ip_conntrack, hopefully this was the last time.

isn't this one missing?

 Michal

-- 
        Michal Rokos

 email: <michal AT rokos DOT info>    
jabber: <majkl AT jabber DOT cz>
   icq: 36118339 

--Boundary-00=_LIhEC0v2U602e8G
Content-Type: text/x-diff;
  charset="utf-8";
  name="missing.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="missing.diff"

diff -ur ../svn/nf_conntrack/linux-2.6/include/linux/netfilter/nf_conntrack_tcp.h linux-2.6-mr/include/linux/netfilter/nf_conntrack_tcp.h
--- ../svn/nf_conntrack/linux-2.6/include/linux/netfilter/nf_conntrack_tcp.h	2005-02-15 15:07:07.000000000 +0100
+++ linux-2.6-mr/include/linux/netfilter/nf_conntrack_tcp.h	2005-02-15 16:04:44.000000000 +0100
@@ -23,7 +23,7 @@
 };
 
 /* Window scaling is advertised by the sender */
-#define NF_CT_TCP_STATE_FLAG_WINDOW_SCALE      0x01
+#define NF_CT_TCP_FLAG_WINDOW_SCALE            0x01
 
 /* SACK is permitted by the sender */
 #define NF_CT_TCP_FLAG_SACK_PERM               0x02
diff -ur ../svn/nf_conntrack/linux-2.6/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6-mr/net/netfilter/nf_conntrack_proto_tcp.c
--- ../svn/nf_conntrack/linux-2.6/net/netfilter/nf_conntrack_proto_tcp.c	2005-02-15 15:07:10.000000000 +0100
+++ linux-2.6-mr/net/netfilter/nf_conntrack_proto_tcp.c	2005-02-15 16:04:46.000000000 +0100
@@ -280,9 +280,9 @@
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
@@ -444,7 +444,7 @@
 					state->td_scale = 14;
 				}
 				state->flags |=
-					NF_CT_TCP_STATE_FLAG_WINDOW_SCALE;
+					NF_CT_TCP_FLAG_WINDOW_SCALE;
 			}
 			ptr += opsize - 2;
 			length -= opsize;
@@ -566,8 +566,8 @@
 			 * Both sides must send the Window Scale option
 			 * to enable window scaling in either direction.
 			 */
-			if (!(sender->flags & NF_CT_TCP_STATE_FLAG_WINDOW_SCALE
-			      && receiver->flags & NF_CT_TCP_STATE_FLAG_WINDOW_SCALE))
+			if (!(sender->flags & NF_CT_TCP_FLAG_WINDOW_SCALE
+			      && receiver->flags & NF_CT_TCP_FLAG_WINDOW_SCALE))
 				sender->td_scale = 
 				receiver->td_scale = 0;
 		} else {
@@ -580,8 +580,10 @@
 			sender->td_maxwin = (win == 0 ? 1 : win);
 			sender->td_maxend = end + sender->td_maxwin;
 		}
-	} else if (state->state == TCP_CONNTRACK_SYN_SENT
-		   && dir == NF_CT_DIR_ORIGINAL
+	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
+		     && dir == NF_CT_DIR_ORIGINAL)
+		   || (state->state == TCP_CONNTRACK_SYN_RECV
+		     && dir == NF_CT_DIR_REPLY))
 		   && after(end, sender->td_end)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
@@ -699,7 +701,7 @@
 			"nf_ct_tcp: %s ",
 			before(end, sender->td_maxend + 1) ?
 			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
-			before(ack, receiver->td_end + 1) ?
+			before(sack, receiver->td_end + 1) ?
 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
 			: "ACK is under the lower bound (possibly overly delayed ACK)"
 			: "ACK is over the upper bound (ACKed data has never seen yet)"
@@ -896,7 +898,9 @@
 
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
-		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
+		/* Either SYN in ORIGINAL
+		 * or SYN/ACK in REPLY
+		 * or ACK in REPLY direction (half-open connection). */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
@@ -925,7 +929,7 @@
 		WRITE_UNLOCK(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, 
-				  "nf_ct_tcp: invalid SYN (ignored) ");
+				  "nf_ct_tcp: invalid packed ignored ");
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
@@ -950,11 +954,12 @@
 		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET
+		    && ((test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)
+		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
+			|| conntrack->proto.tcp.last_index == TCP_ACK_SET)
 		    && after(ntohl(th->ack_seq),
 		    	     conntrack->proto.tcp.last_seq)) {
-			/* Ignore RST closing down invalid SYN 
+			/* Ignore RST closing down invalid SYN or ACK
 			   we had let trough. */ 
 		    	WRITE_UNLOCK(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))

--Boundary-00=_LIhEC0v2U602e8G--
