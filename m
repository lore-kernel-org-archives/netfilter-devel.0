From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Mon, 17 May 2004 01:51:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A7FE72.60305@eurodev.net>
References: <40A7FDB1.8080607@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050409030207000004000609"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40A7FDB1.8080607@eurodev.net>
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
--------------050409030207000004000609
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi again,

please wrong patch, use this one instead.

Sorry,
Pablo

--------------050409030207000004000609
Content-Type: text/x-patch;
 name="tcp-win.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp-win.patch"

--- net/ipv4/netfilter/ip_conntrack_proto_tcp.c~	2004-05-17 00:35:52.000000000 +0200
+++ net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-05-17 00:58:42.000000000 +0200
@@ -368,9 +368,12 @@
    we doesn't have to deal with fragments. 
 */
 
-#define SEGMENT_SEQ_PLUS_LEN(seq, len, iph, tcph)	\
-	(seq + len - (iph->ihl + tcph->doff)*4		\
-	 + (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0))
+static inline __u32 segment_seq_plus_len(__u32 seq, size_t len, struct iphdr *iph, 
+				 struct tcphdr *tcph)
+{
+	return (seq + len - (iph->ihl + tcph->doff)*4 \
+		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
+}
 
 /* Fixme: what about big packets? */
 #define MAXACKWINCONST			66000
@@ -440,7 +443,7 @@
 	seq = ntohl(tcph->seq);
 	ack = ntohl(tcph->ack_seq);
 	win = ntohs(tcph->window);
-	end = SEGMENT_SEQ_PLUS_LEN(seq, skb->len, iph, tcph);
+	end = segment_seq_plus_len(seq, skb->len, iph, tcph);
 	
 	DEBUGP("tcp_in_window: START\n");
 	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu seq=%u ack=%u win=%u end=%u\n",
@@ -622,7 +625,7 @@
 	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
 #endif
 
-	end = SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), skb->len, iph, tcph);
+	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, iph, tcph);
 	
 	WRITE_LOCK(&tcp_lock);
 	/*
@@ -641,41 +644,34 @@
 EXPORT_SYMBOL(ip_conntrack_tcp_update);
 #endif
 
-#define	TH_FIN	0x01
-#define	TH_SYN	0x02
-#define	TH_RST	0x04
-#define	TH_PUSH	0x08
-#define	TH_ACK	0x10
-#define	TH_URG	0x20
-#define	TH_ECE	0x40
-#define	TH_CWR	0x80
-
 /* table of valid flag combinations - ECE and CWR are always valid */
-static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+static u8 tcp_valid_flags[(TCPCB_FLAG_FIN|TCPCB_FLAG_SYN|TCPCB_FLAG_RST|TCPCB_FLAG_PSH|TCPCB_FLAG_ACK|TCPCB_FLAG_URG) + 1] =
 {
-	[TH_SYN]			= 1,
-	[TH_SYN|TH_ACK]			= 1,
-	[TH_RST]			= 1,
-	[TH_RST|TH_ACK]			= 1,
-	[TH_RST|TH_ACK|TH_PUSH]		= 1,
-	[TH_FIN|TH_ACK]			= 1,
-	[TH_ACK]			= 1,
-	[TH_ACK|TH_PUSH]		= 1,
-	[TH_ACK|TH_URG]			= 1,
-	[TH_ACK|TH_URG|TH_PUSH]		= 1,
-	[TH_FIN|TH_ACK|TH_PUSH]		= 1,
-	[TH_FIN|TH_ACK|TH_URG]		= 1,
-	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	= 1,
+	[TCPCB_FLAG_SYN]				= 1,
+	[TCPCB_FLAG_SYN|TCPCB_FLAG_ACK]			= 1,
+	[TCPCB_FLAG_RST]				= 1,
+	[TCPCB_FLAG_RST|TCPCB_FLAG_ACK]			= 1,
+	[TCPCB_FLAG_RST|TCPCB_FLAG_ACK|TCPCB_FLAG_PSH]	= 1,
+	[TCPCB_FLAG_FIN|TCPCB_FLAG_ACK]			= 1,
+	[TCPCB_FLAG_ACK]				= 1,
+	[TCPCB_FLAG_ACK|TCPCB_FLAG_PSH]			= 1,
+	[TCPCB_FLAG_ACK|TCPCB_FLAG_URG]			= 1,
+	[TCPCB_FLAG_ACK|TCPCB_FLAG_URG|TCPCB_FLAG_PSH]	= 1,
+	[TCPCB_FLAG_FIN|TCPCB_FLAG_ACK|TCPCB_FLAG_PSH]	= 1,
+	[TCPCB_FLAG_FIN|TCPCB_FLAG_ACK|TCPCB_FLAG_URG]	= 1,
+	[TCPCB_FLAG_FIN|TCPCB_FLAG_ACK|TCPCB_FLAG_URG|TCPCB_FLAG_PSH]	= 1,
 };
 
-/* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
+/* Protect conntrack agaist broken packets. Modified version from ipt_unclean.c.  */
 static int unclean(const struct sk_buff *skb, struct iphdr *iph, struct tcphdr *tcph)
 {
 	unsigned int tcplen = skb->len - iph->ihl * 4;
 	u_int8_t tcpflags;
 
+
 	/* Not whole TCP header or malformed packet */
-	if (tcph->doff*4 < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+	if ((skb->len - iph->ihl*4 - sizeof(struct tcphdr) == tcph->doff*4)
+	     && tcph->doff*4 < sizeof(struct tcphdr)) {
 		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_conntrack_tcp: INVALID: truncated/malformed packet ");
@@ -696,7 +692,7 @@
 	}
 
 	/* Check TCP flags. */
-	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
+	tcpflags = (((u_int8_t *)tcph)[13] & ~(TCPCB_FLAG_ECE|TCPCB_FLAG_CWR));
 	if (!tcp_valid_flags[tcpflags]) {
 		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
@@ -715,29 +711,22 @@
 	enum tcp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir;
 	struct iphdr *iph = skb->nh.iph;
-	unsigned char buff[15 * 4];
-	struct tcphdr *tcph = (struct tcphdr *)buff;
+	struct tcphdr tcph;
 	unsigned long timeout;
 	unsigned int index;
 	
 	/* Smaller that minimal TCP header? */
-	if (skb_copy_bits(skb, iph->ihl * 4, buff, sizeof(*tcph)) != 0)
-		return -NF_ACCEPT;
+	if (skb_copy_bits(skb, iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
+		return -NF_DROP;
 
-	/* Smaller than actual TCP header? */
-	if (skb_copy_bits(skb, iph->ihl * 4 + sizeof(*tcph), 
-			  buff + sizeof(*tcph), 
-			  tcph->doff * 4 - sizeof(*tcph)) != 0)
-		return -NF_ACCEPT;
-	
 	/* Do not handle unclean packets, which could cause false alarms */
-	if (unclean(skb, iph, tcph))
-		return -NF_ACCEPT;
+	if (unclean(skb, iph, &tcph))
+		return -NF_DROP;
 	
-	WRITE_LOCK(&tcp_lock);
+ 	WRITE_LOCK(&tcp_lock);
 	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
-	index = get_conntrack_index(tcph);
+	index = get_conntrack_index(&tcph);
 	new_state = tcp_conntracks[dir][index][old_state];
 
 	switch (new_state) {
@@ -746,7 +735,7 @@
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.stored_seq == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
-		    && after(ntohl(tcph->ack_seq), conntrack->proto.tcp.last_seq)) {
+		    && after(ntohl(tcph.ack_seq), conntrack->proto.tcp.last_seq)) {
 			/* This SYN/ACK acknowledges a SYN that we earlier ignored 
 			 * as invalid. This means that the client and the server 
 			 * are both in sync, while the firewall is not. We kill 
@@ -764,7 +753,7 @@
 		}
 		conntrack->proto.tcp.stored_seq = index;
 		conntrack->proto.tcp.last_dir = dir;
-		conntrack->proto.tcp.last_seq = ntohl(tcph->seq);
+		conntrack->proto.tcp.last_seq = ntohl(tcph.seq);
 		
 		WRITE_UNLOCK(&tcp_lock);
 		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
@@ -773,10 +762,10 @@
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
-		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
+ 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
 		       dir, get_conntrack_index(tcph),
 		       old_state);
-		WRITE_UNLOCK(&tcp_lock);
+ 		WRITE_UNLOCK(&tcp_lock);
 		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_conntrack_tcp: INVALID: invalid state ");
@@ -795,7 +784,7 @@
 		if (index == TCP_RST_SET
 		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
 		    && conntrack->proto.tcp.stored_seq <= TCP_SYNACK_SET
-		    && after(ntohl(tcph->ack), conntrack->proto.tcp.last_seq)) {
+		    && after(ntohl(tcph.ack), conntrack->proto.tcp.last_seq)) {
 			/* Ignore RST closing down invalid SYN we had let trough. */ 
 		    	WRITE_UNLOCK(&tcp_lock);
 			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
@@ -804,23 +793,32 @@
 			return NF_ACCEPT;
 		}
 		/* Just fall trough */
+	case TCP_CONNTRACK_ESTABLISHED:
+		if ((old_state == TCP_CONNTRACK_SYN_RECV
+		     || old_state == TCP_CONNTRACK_ESTABLISHED)
+		     && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
+			/* Set ASSURED if we see see valid ack in ESTABLISHED 
+			 * after SYN_RECV or a valid answer for a picked 
+			 * up connection. */
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		}
 	default:
 		/* Keep compilers happy. */
 		break;
-	}
-
+ 	}
+ 
 	conntrack->proto.tcp.stored_seq = index;
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph)) {
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, &tcph)) {
 		/* Invalid packet */
-		WRITE_UNLOCK(&tcp_lock);
+ 		WRITE_UNLOCK(&tcp_lock);
 		return -NF_ACCEPT;
 	}
 	/* If FIN was trimmed off, don't change state. */
 	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
-
+ 
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
-		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0), (tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
+		NIPQUAD(iph->saddr), ntohs(tcph.source), NIPQUAD(iph->daddr), ntohs(tcph.dest),
+		(tcph.syn ? 1 : 0), (tcph.ack ? 1 : 0), (tcph.fin ? 1 : 0), (tcph.rst ? 1 : 0),
 		old_state, new_state);
 
 	conntrack->proto.tcp.state = new_state;
@@ -828,28 +826,10 @@
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
-
-	return NF_ACCEPT;
+ 
+ 	return NF_ACCEPT;
 }
 
 /* Called when a new connection for this protocol found. */
@@ -857,30 +837,23 @@
 {
 	enum tcp_conntrack new_state;
 	struct iphdr *iph = skb->nh.iph;
-	unsigned char buff[15 * 4];
-	struct tcphdr *tcph = (struct tcphdr *)buff;
+	struct tcphdr tcph;
 #ifdef DEBUGP_VARS
 	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
 	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
 #endif
 
 	/* Smaller that minimal TCP header? */
-	if (skb_copy_bits(skb, iph->ihl * 4, buff, sizeof(*tcph)) != 0)
+	if (skb_copy_bits(skb, iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
 		return 0;
 
-	/* Smaller than actual TCP header? */
-	if (skb_copy_bits(skb, iph->ihl * 4 + sizeof(*tcph), 
-			  buff + sizeof(*tcph), 
-			  tcph->doff * 4 - sizeof(*tcph)) != 0)
-		return 0;
-	
 	/* Skip unclean packets */
-	if (unclean(skb, iph, tcph))
+	if (unclean(skb, iph, &tcph))
 		return 0;
 
 	/* Don't need lock here: this conntrack not in circulation yet */
 	new_state
-		= tcp_conntracks[0][get_conntrack_index(tcph)]
+		= tcp_conntracks[0][get_conntrack_index(&tcph)]
 		[TCP_CONNTRACK_NONE];
 
 	/* Invalid: delete conntrack */
@@ -892,14 +865,14 @@
 	if (new_state == TCP_CONNTRACK_SYN_SENT) {
 		/* SYN packet */
 		conntrack->proto.tcp.seen[0].td_end =
-			SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), skb->len, iph, tcph);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
+			 segment_seq_plus_len(ntohl(tcph.seq), skb->len, iph, &tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
 		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
 			conntrack->proto.tcp.seen[0].td_maxwin = 1;
 		conntrack->proto.tcp.seen[0].td_maxend =
 			conntrack->proto.tcp.seen[0].td_end;
 
-		tcp_options(tcph, &conntrack->proto.tcp.seen[0]);
+		tcp_options(&tcph, &conntrack->proto.tcp.seen[0]);
 		conntrack->proto.tcp.seen[1].flags = 0;
 		conntrack->proto.tcp.seen[0].loose = 
 		conntrack->proto.tcp.seen[1].loose = 0;
@@ -913,8 +886,8 @@
 		 * Let's try to use the data from the packet.
 		 */
 		conntrack->proto.tcp.seen[0].td_end =
-			SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), skb->len, iph, tcph);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
+			 segment_seq_plus_len(ntohl(tcph.seq), skb->len, iph, &tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
 		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
 			conntrack->proto.tcp.seen[0].td_maxwin = 1;
 		conntrack->proto.tcp.seen[0].td_maxend =

--------------050409030207000004000609--
