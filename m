From: Martin Renold <martinxyz@gmx.ch>
Subject: Re: [patch] tcp connection tracking 2.4.19
Date: Thu, 17 Oct 2002 10:53:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021017085344.GA738@old.homeip.net>
References: <20021016074837.GA18011@old.homeip.net> <5.1.0.14.2.20021017101600.00bc4328@sss.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Svenning Sorensen <sss@sss.dnsalias.net>,
	Stephane Ouellette <ouellettes@videotron.ca>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <5.1.0.14.2.20021017101600.00bc4328@sss.dnsalias.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 17, 2002 at 10:26:48AM +0200, Svenning Sorensen wrote:
> I believe there is a bug in it:

Oops! Stephane Ouelle also just reported, thank you.

> Note that the original statement will now be unconditionally executed.
> You need to enclose the statements by brackets.

So here it is again, corrected (I'm going to test this in a minute):

diff -urN -X dontdiff kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- kernel-source-2.4.19.origin/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Fri Aug  4 22:07:24 2000
+++ kernel-source-2.4.19.patch/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	Sun Oct  6 12:35:19 2002
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
--- kernel-source-2.4.19.origin/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Sat Aug  3 02:39:46 2002
+++ kernel-source-2.4.19.patch/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Thu Oct 17 09:41:03 2002
@@ -179,9 +179,12 @@
 	/* Poor man's window tracking: record SYN/ACK for handshake check */
 	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-	    && tcph->syn && tcph->ack)
+	    && tcph->syn && tcph->ack) {
+		conntrack->proto.tcp.handshake_seq
+			= tcph->ack_seq;
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph->seq) + 1);
+	}
 	WRITE_UNLOCK(&tcp_lock);
 
 	/* If only reply is a RST, we can consider ourselves not to
@@ -196,6 +199,7 @@
 		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
 		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
 		    && tcph->ack && !tcph->syn
+		    && tcph->seq == conntrack->proto.tcp.handshake_seq
 		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
bye,
Martin
