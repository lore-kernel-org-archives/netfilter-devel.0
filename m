From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Wed, 19 May 2004 12:14:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AB3372.5030606@eurodev.net>
References: <Pine.LNX.4.33.0405191030380.2202-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020607080100010701070206"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0405191030380.2202-100000@blackhole.kfki.hu>
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
--------------020607080100010701070206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef,

Jozsef Kadlecsik wrote:

>>>>f) Do you think that it's interesting adding fine grain locking in
>>>>tcp-window-tracking?
>>>>http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015166.html
>>>>        
>>>>
>>>First I was not quite convinced, but yes, I think it'd worth. However I
>>>believe we should introduce a generic per data locking in ip_conntrack
>>>instead of just a per TCP data locking. Thus there were no need the extra
>>>per protocol-helper locks either.
>>>
>>>      
>>>
>>yes, that would be also ok, but some other helpers like udp don't need
>>it, so is it worthy adding that field to the conntrack structure?
>>    
>>
>
>After thinking on it again, you're right, but I meant the
>application protocol-helper locks. If there is a TCP data lock, then there
>is no need for (TCP based) application protocol-helper locks.
>  
>

so you mean that we could use a single lock to protect both protocol and 
application helper private information, don't you? but in the case of 
the ftp helper the lock is protecting that global buffer, so your 
assumption would be wrong, wouldn't it?

I know that connection tracking shouldn't drop packets (in theory), but 
I think that it would be ok if we can add set an option via sysctl with 
the default return value. I mean, if we saw an unclean packet, return 
NF_DROP, just let the administrator choose how aggresive his tcp 
tracking is.

More feedback, I restructured the skeleton of the tcp_packet function, 
attached a patch. I moved up the call to the tcp_in_window function, so 
at first we check if a packets complies with Guido's four boundaries. 
Then we check if we saw a FIN packet which is out the boundaries so we 
came to the old state. And we get in the switch... I added both 
checkings which were performed after tcp_in_window (rst and set 
connection as assured) in the switch. Can you see any problem on this 
approach? if it's ok, I think it could sanitize the current structure of 
tcp_packet.

regards,
Pablo

--------------020607080100010701070206
Content-Type: text/x-patch;
 name="pablo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pablo.patch"

--- net/ipv4/netfilter/ip_conntrack_proto_tcp.c~	2004-05-18 11:51:02.000000000 +0200
+++ net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-05-19 11:42:20.000000000 +0200
@@ -518,9 +518,6 @@
 		 */
 		seq = end = sender->td_end;
 		
-	if (sender->loose)
-		sender->loose--;
-
 	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu seq=%u ack=%u win=%u end=%u trim=%u\n",
 		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
 		seq, ack, win, end, 
@@ -549,6 +546,8 @@
 	     after(seq, sender->td_end - receiver->td_maxwin - 1) &&
 	     before(ack, receiver->td_end + 1) &&
 	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
+
+		sender->loose--;
 	    	/*
 		 * Take into account window scaling (RFC 1323).
 		 */
@@ -719,6 +718,7 @@
 	struct tcphdr *tcph = (struct tcphdr *)buff;
 	unsigned long timeout;
 	unsigned int index;
+	enum ip_conntrack_dir last_dir = conntrack->proto.tcp.last_dir;
 	
 	/* Smaller that minimal TCP header? */
 	if (skb_copy_bits(skb, iph->ihl * 4, buff, sizeof(*tcph)) != 0)
@@ -734,19 +734,34 @@
 	if (unclean(skb, iph, tcph))
 		return -NF_ACCEPT;
 	
-	WRITE_LOCK(&tcp_lock);
-	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(tcph);
-	new_state = tcp_conntracks[dir][index][old_state];
+	WRITE_LOCK(&tcp_lock);
+	old_state = conntrack->proto.tcp.state;
+	conntrack->proto.tcp.stored_seq = index;
+
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph)) {
+		/* Invalid packet */
+		WRITE_UNLOCK(&tcp_lock);
+		return -NF_ACCEPT;
+	}
+
+	/* If FIN was trimmed off, don't change state. */
+	if (index != conntrack->proto.tcp.stored_seq) 
+		new_state = 
+		     tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
+	else 
+		new_state = tcp_conntracks[dir][index][old_state];
+
+	conntrack->proto.tcp.state = new_state;
 
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
 		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
 		if (index == TCP_SYNACK_SET
-		    && conntrack->proto.tcp.stored_seq == TCP_SYN_SET
-		    && conntrack->proto.tcp.last_dir != dir
-		    && after(ntohl(tcph->ack_seq), conntrack->proto.tcp.last_seq)) {
+		    && (old_state == TCP_CONNTRACK_SYN_SENT 
+			    || old_state == TCP_CONNTRACK_SYN_RECV)
+		    && last_dir != dir) {
 			/* This SYN/ACK acknowledges a SYN that we earlier ignored 
 			 * as invalid. This means that the client and the server 
 			 * are both in sync, while the firewall is not. We kill 
@@ -762,9 +777,6 @@
 		    		conntrack->timeout.function((unsigned long)conntrack);
 		    	return -NF_ACCEPT;
 		}
-		conntrack->proto.tcp.stored_seq = index;
-		conntrack->proto.tcp.last_dir = dir;
-		conntrack->proto.tcp.last_seq = ntohl(tcph->seq);
 		
 		WRITE_UNLOCK(&tcp_lock);
 		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
@@ -794,8 +806,8 @@
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.stored_seq <= TCP_SYNACK_SET
-		    && after(ntohl(tcph->ack), conntrack->proto.tcp.last_seq)) {
+		    && (old_state == TCP_CONNTRACK_SYN_SENT
+			    || old_state == TCP_CONNTRACK_SYN_RECV)) {
 			/* Ignore RST closing down invalid SYN we had let trough. */ 
 		    	WRITE_UNLOCK(&tcp_lock);
 			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
@@ -803,49 +815,41 @@
 					  "ip_conntrack_tcp: INVALID: invalid RST (ignored) ");
 			return NF_ACCEPT;
 		}
+
+		if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+		/* If only reply is a RST, we can consider ourselves not to
+		   have an established connection: this is a fairly common
+		   problem case, so we can delete the conntrack
+		   immediately.  --RR */
+			if (tcph->rst) {
+				WRITE_UNLOCK(&tcp_lock);
+				if (del_timer(&conntrack->timeout))
+					conntrack->timeout.function((unsigned long)conntrack);
+				return NF_ACCEPT;
+			}
+		}
 		/* Just fall trough */
+	case TCP_CONNTRACK_ESTABLISHED:
+		if ((old_state == TCP_CONNTRACK_SYN_RECV
+		    || old_state == TCP_CONNTRACK_ESTABLISHED)
+		    && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) 
+		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV 
+		   or a valid answer for a picked up connection. */
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 	default:
 		/* Keep compilers happy. */
 		break;
 	}
 
-	conntrack->proto.tcp.stored_seq = index;
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph)) {
-		/* Invalid packet */
-		WRITE_UNLOCK(&tcp_lock);
-		return -NF_ACCEPT;
-	}
-	/* If FIN was trimmed off, don't change state. */
-	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
-
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
 		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
 		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0), (tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
 		old_state, new_state);
 
-	conntrack->proto.tcp.state = new_state;
 	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans ?
 		  ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		/* If only reply is a RST, we can consider ourselves not to
-		   have an established connection: this is a fairly common
-		   problem case, so we can delete the conntrack
-		   immediately.  --RR */
-		if (tcph->rst) {
-			WRITE_UNLOCK(&tcp_lock);
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)conntrack);
-			return NF_ACCEPT;
-		}
-	} else if ((old_state == TCP_CONNTRACK_SYN_RECV
-		    || old_state == TCP_CONNTRACK_ESTABLISHED)
-		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV 
-		   or a valid answer for a picked up connection. */
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
-	}
 	WRITE_UNLOCK(&tcp_lock);
 	ip_ct_refresh(conntrack, timeout);
 

--------------020607080100010701070206--
