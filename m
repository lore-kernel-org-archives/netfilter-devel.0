From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Tue, 11 May 2004 23:55:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A14BDE.7010506@eurodev.net>
References: <Pine.LNX.4.33.0405110935320.13357-100000@blackhole.kfki.hu> <020101c43732$7acb8ff0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000601060709040509040607"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <020101c43732$7acb8ff0$2601010a@bluereef.local>
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
--------------000601060709040509040607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef,

Andrew Hall wrote:

>Your tcp_window_tracking patch fails to install with the new 2.6.6 kernel
>  
>

attached a patch which applies to pom-ng to fix the problem. Now it 
applies cleanly. I tested it and works fine. If there's something wrong, 
please let me know.

regards,
Pablo

--------------000601060709040509040607
Content-Type: text/x-patch;
 name="tcp-window-2.6-pom-ng.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp-window-2.6-pom-ng.patch"

--- linux-2.6.patch	2004-05-11 23:45:29.000000000 +0200
+++ tcp-window-2.6.patch	2004-05-11 23:41:53.000000000 +0200
@@ -1,7 +1,7 @@
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.6.3-tcp-win/include/linux/netfilter_ipv4/ip_conntrack.h
---- linux-2.6.3-nf-log/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-18 04:59:30.000000000 +0100
-+++ linux-2.6.3-tcp-win/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-24 16:33:22.000000000 +0100
-@@ -248,6 +248,11 @@
+diff -u -r1.1.1.1 ip_conntrack.h
+--- a/include/linux/netfilter_ipv4/ip_conntrack.h	11 May 2004 13:35:40 -0000	1.1.1.1
++++ b/include/linux/netfilter_ipv4/ip_conntrack.h	11 May 2004 19:44:53 -0000
+@@ -249,6 +249,11 @@
  			  unsigned long extra_jiffies);
  
  /* These are for NAT.  Icky. */
@@ -13,9 +13,9 @@
  /* Call me when a conntrack is destroyed. */
  extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
  
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.6.3-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
---- linux-2.6.3-nf-log/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-02-18 04:57:29.000000000 +0100
-+++ linux-2.6.3-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-02-24 16:33:22.000000000 +0100
+diff -u -r1.1.1.1 ip_conntrack_tcp.h
+--- a/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	11 May 2004 13:35:39 -0000	1.1.1.1
++++ b/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	11 May 2004 19:44:53 -0000
 @@ -4,25 +4,41 @@
  
  enum tcp_conntrack {
@@ -67,10 +67,10 @@
  };
  
  #endif /* _IP_CONNTRACK_TCP_H */
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/include/linux/sysctl.h linux-2.6.3-tcp-win/include/linux/sysctl.h
---- linux-2.6.3-nf-log/include/linux/sysctl.h	2004-02-24 16:27:33.000000000 +0100
-+++ linux-2.6.3-tcp-win/include/linux/sysctl.h	2004-02-24 16:33:22.000000000 +0100
-@@ -391,6 +391,11 @@
+diff -u -r1.1.1.1 sysctl.h
+--- a/include/linux/sysctl.h	11 May 2004 13:35:37 -0000	1.1.1.1
++++ b/include/linux/sysctl.h	11 May 2004 19:44:53 -0000
+@@ -406,6 +406,11 @@
  	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
  	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
  	NET_IPV4_NF_CONNTRACK_BUCKETS=14,
@@ -82,10 +82,10 @@
  };
   
  /* /proc/sys/net/ipv6 */
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_core.c
---- linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-24 16:27:34.000000000 +0100
-+++ linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-24 16:33:22.000000000 +0100
-@@ -842,11 +842,12 @@
+diff -u -r1.1.1.1 ip_conntrack_core.c
+--- a/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 13:07:08 -0000	1.1.1.1
++++ b/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 19:44:53 -0000
+@@ -844,11 +844,12 @@
  	IP_NF_ASSERT((*pskb)->nfct);
  
  	ret = proto->packet(ct, *pskb, ctinfo);
@@ -101,9 +101,9 @@
  	}
  
  	if (ret != NF_DROP && ct->helper) {
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
---- linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-02-18 04:59:50.000000000 +0100
-+++ linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-05-07 07:59:52.000000000 +0200
+diff -u -r1.1.1.1 ip_conntrack_proto_tcp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	11 May 2004 13:07:08 -0000	1.1.1.1
++++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	11 May 2004 20:16:47 -0000
 @@ -4,8 +4,21 @@
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 as
@@ -451,7 +451,7 @@
  {
  	struct tcphdr hdr;
  
-@@ -158,13 +338,373 @@
+@@ -158,97 +338,609 @@
  	return sprintf(buffer, "%s ", tcp_conntrack_names[state]);
  }
  
@@ -468,8 +468,12 @@
 +	else if (tcph->fin) return TCP_FIN_SET;
 +	else if (tcph->ack) return TCP_ACK_SET;
 +	else return TCP_NONE_SET;
-+}
-+
+ }
+ 
+-/* Returns verdict for packet, or -1 for invalid. */
+-static int tcp_packet(struct ip_conntrack *conntrack,
+-		      const struct sk_buff *skb,
+-		      enum ip_conntrack_info ctinfo)
 +/* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
 +   in IP Filter' by Guido van Rooij.
 +   
@@ -505,7 +509,9 @@
 + */
 +static void tcp_options(struct tcphdr *tcph, 
 +			struct ip_ct_tcp_state *state)
-+{
+ {
+-	enum tcp_conntrack newconntrack, oldtcpstate;
+-	struct tcphdr tcph;
 +	unsigned char *ptr = (unsigned char *)(tcph + 1);
 +	int length = (tcph->doff*4) - sizeof(struct tcphdr);
 +	
@@ -545,7 +551,9 @@
 +		}
 +	}
 +}
-+
+ 
+-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
+-		return -1;
 +static int tcp_in_window(struct ip_ct_tcp *state, 
 +                         enum ip_conntrack_dir dir,
 +                         const struct sk_buff *skb,
@@ -616,7 +624,15 @@
 +		sender->td_end =
 +		sender->td_maxend = end;
 +		sender->td_maxwin = (win == 0 ? 1 : win);
-+
+ 
+-	/* If only reply is a RST, we can consider ourselves not to
+-	   have an established connection: this is a fairly common
+-	   problem case, so we can delete the conntrack
+-	   immediately.  --RR */
+-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
+-		if (del_timer(&conntrack->timeout))
+-			conntrack->timeout.function((unsigned long)conntrack);
+-		return NF_ACCEPT;
 +		tcp_options(tcph, sender);
 +	}
 +	
@@ -632,8 +648,22 @@
 +		 * with zero ack value.
 +		 */
 +		ack = receiver->td_end;
-+	}
-+
+ 	}
+ 
+-	WRITE_LOCK(&tcp_lock);
+-	oldtcpstate = conntrack->proto.tcp.state;
+-	newconntrack
+-		= tcp_conntracks
+-		[CTINFO2DIR(ctinfo)]
+-		[get_conntrack_index(&tcph)][oldtcpstate];
+-
+-	/* Invalid */
+-	if (newconntrack == TCP_CONNTRACK_MAX) {
+-		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
+-		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
+-		       conntrack->proto.tcp.state);
+-		WRITE_UNLOCK(&tcp_lock);
+-		return -1;
 +	if (seq == end)
 +		/*
 +		 * Packets contains no data: we assume it is valid
@@ -658,7 +688,7 @@
 +		end = sender->td_maxend;
 +		if (state->stored_seq == TCP_FIN_SET)
 +			state->stored_seq = TCP_ACK_SET;
-+	}
+ 	}
 +	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
 +		before(end, sender->td_maxend + 1) 
 +			|| before(seq, sender->td_maxend + 1),
@@ -720,10 +750,18 @@
 +						: "ACK is over the upper bound (ACKed data has never seen yet)"
 +					: "SEQ is under the lower bound (retransmitted already ACKed data)"
 +				: "SEQ is over the upper bound (over the window of the receiver)");
-+
+ 
+-	conntrack->proto.tcp.state = newconntrack;
 +		res = ip_ct_tcp_be_liberal && !tcph->rst;
 +	}
-+
+ 
+-	/* Poor man's window tracking: record SYN/ACK for handshake check */
+-	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
+-	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
+-	    && tcph.syn && tcph.ack) {
+-		conntrack->proto.tcp.handshake_ack
+-			= htonl(ntohl(tcph.seq) + 1);
+-		goto out;
 +	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u receiver end=%u maxend=%u maxwin=%u\n",
 +		res, sender->td_end, sender->td_maxend, sender->td_maxwin, 
 +		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
@@ -803,8 +841,14 @@
 +			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 +				  "ip_conntrack_tcp: INVALID: truncated/malformed packet ");
 +		return 1;
-+	}
-+
+ 	}
+ 
+-	/* Set ASSURED if we see valid ack in ESTABLISHED after SYN_RECV */
+-	if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
+-	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
+-	    && tcph.ack && !tcph.syn
+-	    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
+-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 +	/* Checksum invalid?  Ignore. */
 +	/* FIXME: Source route IP option packets --RR */
 +	if (csum_tcpudp_magic(iph->saddr, iph->daddr,
@@ -817,7 +861,9 @@
 +				  "ip_conntrack_tcp: INVALID: bad TCP checksum ");
 +		return 1;
 +	}
-+
+ 
+-out:	WRITE_UNLOCK(&tcp_lock);
+-	ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 +	/* Check TCP flags. */
 +	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
 +	if (!tcp_valid_flags[tcpflags]) {
@@ -828,19 +874,14 @@
 +	}
 +
 +	return 0;
- }
++}
  
- /* Returns verdict for packet, or -1 for invalid. */
-@@ -172,56 +712,142 @@
- 		      const struct sk_buff *skb,
- 		      enum ip_conntrack_info ctinfo)
- {
--	enum tcp_conntrack newconntrack, oldtcpstate;
--	struct tcphdr tcph;
--
--	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
--		return -1;
--
+-	return NF_ACCEPT;
++/* Returns verdict for packet, or -1 for invalid. */
++static int tcp_packet(struct ip_conntrack *conntrack,
++		      const struct sk_buff *skb,
++		      enum ip_conntrack_info ctinfo)
++{
 +	enum tcp_conntrack new_state, old_state;
 +	enum ip_conntrack_dir dir;
 +	struct iphdr *iph = skb->nh.iph;
@@ -863,15 +904,7 @@
 +	if (unclean(skb, iph, tcph))
 +		return -NF_ACCEPT;
 +	
- 	WRITE_LOCK(&tcp_lock);
--	oldtcpstate = conntrack->proto.tcp.state;
--	newconntrack
--		= tcp_conntracks
--		[CTINFO2DIR(ctinfo)]
--		[get_conntrack_index(&tcph)][oldtcpstate];
--
--	/* Invalid */
--	if (newconntrack == TCP_CONNTRACK_MAX) {
++ 	WRITE_LOCK(&tcp_lock);
 +	old_state = conntrack->proto.tcp.state;
 +	dir = CTINFO2DIR(ctinfo);
 +	index = get_conntrack_index(tcph);
@@ -910,13 +943,10 @@
 +		return NF_ACCEPT;
 +	case TCP_CONNTRACK_MAX:
 +		/* Invalid packet */
- 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
--		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
--		       conntrack->proto.tcp.state);
++ 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
 +		       dir, get_conntrack_index(tcph),
 +		       old_state);
- 		WRITE_UNLOCK(&tcp_lock);
--		return -1;
++ 		WRITE_UNLOCK(&tcp_lock);
 +		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 +			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 +				  "ip_conntrack_tcp: INVALID: invalid state ");
@@ -947,42 +977,17 @@
 +	default:
 +		/* Keep compilers happy. */
 +		break;
- 	}
- 
--	conntrack->proto.tcp.state = newconntrack;
--
--	/* Poor man's window tracking: record SYN/ACK for handshake check */
--	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
--	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
--	    && tcph.syn && tcph.ack)
--		conntrack->proto.tcp.handshake_ack
--			= htonl(ntohl(tcph.seq) + 1);
--
--	/* If only reply is a RST, we can consider ourselves not to
--	   have an established connection: this is a fairly common
--	   problem case, so we can delete the conntrack
--	   immediately.  --RR */
--	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
++ 	}
++ 
 +	conntrack->proto.tcp.stored_seq = index;
 +	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb, iph, tcph)) {
 +		/* Invalid packet */
- 		WRITE_UNLOCK(&tcp_lock);
--		if (del_timer(&conntrack->timeout))
--			conntrack->timeout.function((unsigned long)conntrack);
--	} else {
--		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
--		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
--		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
--		    && tcph.ack && !tcph.syn
--		    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
--			set_bit(IPS_ASSURED_BIT, &conntrack->status);
++ 		WRITE_UNLOCK(&tcp_lock);
 +		return -NF_ACCEPT;
 +	}
 +	/* If FIN was trimmed off, don't change state. */
 +	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
- 
--		WRITE_UNLOCK(&tcp_lock);
--		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
++ 
 +	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
 +		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
 +		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0), (tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
@@ -1010,13 +1015,13 @@
 +		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV 
 +		   or a valid answer for a picked up connection. */
 +			set_bit(IPS_ASSURED_BIT, &conntrack->status);
- 	}
++ 	}
 +	WRITE_UNLOCK(&tcp_lock);
 +	ip_ct_refresh(conntrack, timeout);
- 
- 	return NF_ACCEPT;
++ 
++ 	return NF_ACCEPT;
  }
-@@ -229,24 +855,92 @@
+ 
  /* Called when a new connection for this protocol found. */
  static int tcp_new(struct ip_conntrack *conntrack, const struct sk_buff *skb)
  {
@@ -1117,7 +1122,7 @@
  	return 1;
  }
  
-@@ -257,14 +951,22 @@
+@@ -259,14 +951,22 @@
  	struct tcphdr tcph;
  	unsigned int datalen;
  
@@ -1145,10 +1150,10 @@
 +	.new 			= tcp_new,
 +	.exp_matches_pkt	= tcp_exp_matches_pkt,
 +};
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_standalone.c
---- linux-2.6.3-nf-log/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-24 16:27:34.000000000 +0100
-+++ linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-24 16:37:08.000000000 +0100
-@@ -286,6 +286,11 @@
+diff -u -r1.1.1.1 ip_conntrack_standalone.c
+--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	11 May 2004 13:07:08 -0000	1.1.1.1
++++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	11 May 2004 19:44:53 -0000
+@@ -322,6 +322,11 @@
  extern unsigned long ip_ct_tcp_timeout_last_ack;
  extern unsigned long ip_ct_tcp_timeout_time_wait;
  extern unsigned long ip_ct_tcp_timeout_close;
@@ -1160,7 +1165,7 @@
  
  /* From ip_conntrack_proto_udp.c */
  extern unsigned long ip_ct_udp_timeout;
-@@ -412,6 +417,41 @@
+@@ -448,6 +453,41 @@
  		.mode		= 0644,
  		.proc_handler	= &proc_dointvec_jiffies,
  	},
@@ -1202,9 +1207,9 @@
  	{ .ctl_name = 0 }
  };
  
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.3-nf-log/net/ipv4/netfilter/ip_nat_helper.c linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_nat_helper.c
---- linux-2.6.3-nf-log/net/ipv4/netfilter/ip_nat_helper.c	2004-02-18 04:57:17.000000000 +0100
-+++ linux-2.6.3-tcp-win/net/ipv4/netfilter/ip_nat_helper.c	2004-02-24 16:33:22.000000000 +0100
+diff -u -r1.1.1.1 ip_nat_helper.c
+--- a/net/ipv4/netfilter/ip_nat_helper.c	11 May 2004 13:07:08 -0000	1.1.1.1
++++ b/net/ipv4/netfilter/ip_nat_helper.c	11 May 2004 19:44:53 -0000
 @@ -395,7 +395,8 @@
  	tcph->seq = newseq;
  	tcph->ack_seq = newack;

--------------000601060709040509040607--
