From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] clean up for tcp_packet function
Date: Wed, 10 Mar 2004 22:56:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404F8F1C.5080608@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020000030402010607050909"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020000030402010607050909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

I sent this patch to Harald but I forgot to redirect it to the maillist. 
If a tcp packet with the rst flag set  and it also hasn't seen the reply 
yet hits the connection tracking, the conntrack will be drop 
inmediately. The current implemented of this condition is:

if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst)
		WRITE_UNLOCK(&tcp_lock);
		if (del_timer(&conntrack->timeout))
			conntrack->timeout.function((unsigned long)conntrack);

if this condition is true: drop the conntrack and return NF_ACCEPT;

but all the needed updates for the conntrack are done before anyway. 
Attached to this email a patch which fix this.

regards,
Pablo

--------------020000030402010607050909
Content-Type: text/plain;
 name="tcp_packet-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp_packet-cleanup.patch"

--- /usr/src/experimental2.6/linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-02-18 04:59:50.000000000 +0100
+++ /usr/src/experimental2.6/linux-2.6.3/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-03-02 03:11:10.000000000 +0100
@@ -178,6 +178,16 @@
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
 		return -1;
 
+	/* If only reply is a RST, we can consider ourselves not to
+	   have an established connection: this is a fairly common
+	   problem case, so we can delete the conntrack
+	   immediately.  --RR */
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
+		if (del_timer(&conntrack->timeout))
+			conntrack->timeout.function((unsigned long)conntrack);
+		return NF_ACCEPT;
+	}
+
 	WRITE_LOCK(&tcp_lock);
 	oldtcpstate = conntrack->proto.tcp.state;
 	newconntrack
@@ -199,29 +209,21 @@
 	/* Poor man's window tracking: record SYN/ACK for handshake check */
 	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
 	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-	    && tcph.syn && tcph.ack)
+	    && tcph.syn && tcph.ack) {
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph.seq) + 1);
+		goto out;
+	}
 
-	/* If only reply is a RST, we can consider ourselves not to
-	   have an established connection: this is a fairly common
-	   problem case, so we can delete the conntrack
-	   immediately.  --RR */
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
-		WRITE_UNLOCK(&tcp_lock);
-		if (del_timer(&conntrack->timeout))
-			conntrack->timeout.function((unsigned long)conntrack);
-	} else {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
-		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
-		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
-		    && tcph.ack && !tcph.syn
-		    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+	/* Set ASSURED if we see valid ack in ESTABLISHED after SYN_RECV */
+	if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
+	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
+	    && tcph.ack && !tcph.syn
+	    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
+		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
-		WRITE_UNLOCK(&tcp_lock);
-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
-	}
+out:	WRITE_UNLOCK(&tcp_lock);
+	ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 
 	return NF_ACCEPT;
 }

--------------020000030402010607050909--
