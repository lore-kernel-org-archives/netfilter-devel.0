From: Martin Renold <martinxyz@gmx.ch>
Subject: [patch] tcp connection tracking 2.4.19
Date: Wed, 16 Oct 2002 09:48:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021016074837.GA18011@old.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

There is a bug in the stable 2.4.19 kernel in the ip_conntrack code that
allows the final ACK of a SYN - SYN/ACK - ACK tcp handshake to establish
an ASSURED connection even if it has a wrong sequence number. The current
code only checks the ACK number.

This allows a DoS attack:
http://old.homeip.net/martin/cdos.tgz

I already sent this to linux-kernel, and was redirected:
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0210.1/0297.html

I know about the TCP window tracking patch, but I expect from the
unpatched "stable" kernel no such behaviour.

So I wrote a simple patch against 2.4.19, but I must admit that I do not
really understand the code around it, especially why it does not mark
such a packet as invalid (I'm new to most things here). It's running
right now on 3-4 machines.

diff -urN -X dontdiff kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Fri Aug  4 22:07:24 2000
+++ kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Sat Oct  5 19:07:44 2002
@@ -24,8 +24,9 @@
 {
 	enum tcp_conntrack state;
 
-	/* Poor man's window tracking: sequence number of valid ACK
-           handshake completion packet */
+	/* Poor man's window tracking: expected sequence and acknowledge 
+	   number of valid ACK handshake completion packet */
+	u_int32_t handshake_seq;
 	u_int32_t handshake_ack;
 };
 
diff -urN -X dontdiff kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Fri Oct  4 08:13:38 2002
+++ kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Sat Oct  5 20:45:49 2002
@@ -180,6 +180,8 @@
 	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 	    && tcph->syn && tcph->ack)
+		conntrack->proto.tcp.handshake_seq
+			= tcph->ack_seq;
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph->seq) + 1);
 	WRITE_UNLOCK(&tcp_lock);
@@ -196,6 +198,7 @@
 		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
 		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
 		    && tcph->ack && !tcph->syn
+		    && tcph->seq == conntrack->proto.tcp.handshake_seq
 		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
-- 
Thunder's just a noise, boys, lightnin' does the work
-- (Chad Brock/John Hadley/Kelly Garrett)
