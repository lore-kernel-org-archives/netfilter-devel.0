From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking has bad side effects
Date: Fri, 3 Dec 2004 09:44:44 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412030942320.30157@blackhole.kfki.hu>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
	<20041201153903.GA16807@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
In-Reply-To: <20041201153903.GA16807@suse.de>
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

On Wed, 1 Dec 2004, Ludwig Nussel wrote:

> My description probably wasn't unambiguous. The client has the
> packetfilter, crashes and reboots.

I see - that case was not handled in the code. Please try the patch below
and report the result.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.6.9-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.6.9-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-18 23:55:29.000000000 +0200
+++ linux-2.6.9-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-03 07:06:55.000000000 +0100
@@ -275,7 +275,7 @@
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
 /*ack*/	   { sIV, sIV, sIV, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sSS -> sIV	ACK is invalid: we haven't seen a SYN/ACK yet.
+ *	sSS -> sIG	Might be a half-open connection.
  *	sSR -> sIV	Simultaneous open.
  *	sES -> sES	:-)
  *	sFW -> sCW	Normal close request answered by ACK.
@@ -847,7 +847,9 @@

 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
-		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
+		/* Either SYN in ORIGINAL
+		 * or SYN/ACK in REPLY
+		 * or ACK in REPLY direction. */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
@@ -876,7 +878,7 @@
 		WRITE_UNLOCK(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
-				  "ip_ct_tcp: invalid SYN (ignored) ");
+				  "ip_ct_tcp: invalid packet ignored ");
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
@@ -901,11 +903,11 @@
 		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET
+		    && (conntrack->proto.tcp.last_index <= TCP_SYNACK_SET
+		        || conntrack->proto.tcp.last_index == TCP_ACK_SET)
 		    && after(ntohl(th->ack_seq),
 		    	     conntrack->proto.tcp.last_seq)) {
-			/* Ignore RST closing down invalid SYN
+			/* Ignore RST closing down invalid SYN or ACK
 			   we had let trough. */
 		    	WRITE_UNLOCK(&tcp_lock);
 			if (LOG_INVALID(IPPROTO_TCP))
