From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] tcp window tracking initial port to 2.6
Date: Sun, 07 Mar 2004 21:52:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404B8B72.2040500@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000509060703020105070800"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  kadlec@blackhole.kfki.hu
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
--------------000509060703020105070800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jozsef and list,

I spent my sunday evening in porting the tcp window tracking system to 
the 2.6.x tree. Attached to this email the incremental fix to the CVS 
and the merge to the 2.6.x tree.

It works fine for me, anyway please, this must be considered an initial 
port. I tried to keep everything as similar as possible to the 2.4.x 
patch, so I made minor modifications. After the port is finished, hope 
that i could give you some feedback.

Some comments:

- I drop the old helpers modifications. I think that they are not needed 
anymore.
- I change the macro SEGMENT_SEQ_PLUS_LEN for an inline function called 
segment_seq_plus_len because I had important some problems porting this 
and I needed a bit of flexibility. Anyway maybe
- I commented all the nf_log_ip stuff because the API has changed for 
2.6.x tree and I was sure of the correct use of the new one 
(nf_log_packet?).

Hope that the port is correct.

BTW I think that I experimented some problems with the nf-log patch for 
2.6.x tree, I'll have a look at them.

regards,
Pablo

--------------000509060703020105070800
Content-Type: text/plain;
 name="tcp_window-tracking-CVS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp_window-tracking-CVS.patch"

--- /home/pablo/CVS/patch-o-matic-ng/tcp-window-tracking/linux.patch	2003-12-18 19:48:03.000000000 +0100
+++ tcp_window-tracking.patch	2004-03-07 21:19:36.000000000 +0100
@@ -1,9 +1,8 @@
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.23-tcp-win/include/linux/netfilter_ipv4/ip_conntrack.h
---- linux-2.4.23-pending/include/linux/netfilter_ipv4/ip_conntrack.h	2003-12-04 17:02:36.000000000 +0100
-+++ linux-2.4.23-tcp-win/include/linux/netfilter_ipv4/ip_conntrack.h	2003-12-09 09:45:55.000000000 +0100
-@@ -262,6 +262,11 @@
- /* Fake conntrack entry for untracked connections */
- extern struct ip_conntrack ip_conntrack_untracked;
+--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-18 04:59:30.000000000 +0100
++++ linux-2.6.3-patched/include/linux/netfilter_ipv4/ip_conntrack.h	2004-03-07 18:47:15.000000000 +0100
+@@ -251,6 +251,11 @@
+ /* Call me when a conntrack is destroyed. */
+ extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
  
 +/* Update TCP window tracking data when NAT mangles the packet */
 +extern void ip_conntrack_tcp_update(struct sk_buff *skb,
@@ -13,9 +12,8 @@
  /* Returns new sk_buff, or NULL */
  struct sk_buff *
  ip_ct_gather_frags(struct sk_buff *skb);
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.4.23-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
---- linux-2.4.23-pending/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2002-11-29 00:53:15.000000000 +0100
-+++ linux-2.4.23-tcp-win/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2003-12-09 09:30:21.000000000 +0100
+--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-02-18 04:57:29.000000000 +0100
++++ linux-2.6.3-patched/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-03-07 18:48:48.000000000 +0100
 @@ -4,25 +4,41 @@
  
  enum tcp_conntrack {
@@ -67,13 +65,12 @@
  };
  
  #endif /* _IP_CONNTRACK_TCP_H */
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/include/linux/sysctl.h linux-2.4.23-tcp-win/include/linux/sysctl.h
---- linux-2.4.23-pending/include/linux/sysctl.h	2003-12-04 16:45:18.000000000 +0100
-+++ linux-2.4.23-tcp-win/include/linux/sysctl.h	2003-12-09 09:42:57.000000000 +0100
-@@ -377,6 +377,11 @@
+--- linux-2.6.3-old/include/linux/sysctl.h	2004-02-18 04:58:10.000000000 +0100
++++ linux-2.6.3-patched/include/linux/sysctl.h	2004-03-07 18:50:32.000000000 +0100
+@@ -380,6 +380,11 @@
+ 	NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM=11,
  	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
  	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
- 	NET_IPV4_NF_CONNTRACK_BUCKETS=14,
 + 	NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=15,
 + 	NET_IPV4_NF_CONNTRACK_TCP_LOG_INVALID=16,
 + 	NET_IPV4_NF_CONNTRACK_TCP_LOOSE=17,
@@ -82,127 +79,31 @@
  };
   
  /* /proc/sys/net/ipv6 */
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_core.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_core.c	2003-12-04 16:56:14.000000000 +0100
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_core.c	2003-12-09 09:30:21.000000000 +0100
-@@ -864,11 +864,12 @@
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57:11.000000000 +0100
++++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-07 18:52:45.000000000 +0100
+@@ -842,11 +842,12 @@
  	IP_NF_ASSERT((*pskb)->nfct);
  
- 	ret = proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
+ 	ret = proto->packet(ct, *pskb, ctinfo);
 -	if (ret == -1) {
 -		/* Invalid */
+-		nf_conntrack_put((*pskb)->nfct);
+-		(*pskb)->nfct = NULL;
+-		return NF_ACCEPT;
 +	if (ret < 0 ) {
 +		/* Invalid: inverse of the return code tells
 +		 * to the netfilter core what to do. */
- 		nf_conntrack_put((*pskb)->nfct);
- 		(*pskb)->nfct = NULL;
--		return NF_ACCEPT;
++ 		nf_conntrack_put((*pskb)->nfct);
++ 		(*pskb)->nfct = NULL;
 +		return -ret;
  	}
  
  	if (ret != NF_DROP && ct->helper) {
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_ftp.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_ftp.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-08-25 13:44:44.000000000 +0200
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-12-09 09:30:21.000000000 +0100
-@@ -4,7 +4,6 @@
- #include <linux/netfilter.h>
- #include <linux/ip.h>
- #include <linux/ctype.h>
--#include <net/checksum.h>
- #include <net/tcp.h>
- 
- #include <linux/netfilter_ipv4/lockhelp.h>
-@@ -233,11 +232,10 @@
- 		struct ip_conntrack *ct,
- 		enum ip_conntrack_info ctinfo)
- {
--	/* tcplen not negative guaranteed by ip_conntrack_tcp.c */
-+	/* datalen not negative guaranteed by ip_conntrack_proto_tcp.c */
- 	struct tcphdr *tcph = (void *)iph + iph->ihl * 4;
- 	const char *data = (const char *)tcph + tcph->doff * 4;
--	unsigned int tcplen = len - iph->ihl * 4;
--	unsigned int datalen = tcplen - tcph->doff * 4;
-+	unsigned int datalen = len - iph->ihl * 4 - tcph->doff * 4;
- 	u_int32_t old_seq_aft_nl;
- 	int old_seq_aft_nl_set;
- 	u_int32_t array[6] = { 0 };
-@@ -257,22 +255,6 @@
- 		return NF_ACCEPT;
- 	}
- 
--	/* Not whole TCP header? */
--	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
--		DEBUGP("ftp: tcplen = %u\n", (unsigned)tcplen);
--		return NF_ACCEPT;
--	}
--
--	/* Checksum invalid?  Ignore. */
--	/* FIXME: Source route IP option packets --RR */
--	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
--			 csum_partial((char *)tcph, tcplen, 0))) {
--		DEBUGP("ftp_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
--		       tcph, tcplen, NIPQUAD(iph->saddr),
--		       NIPQUAD(iph->daddr));
--		return NF_ACCEPT;
--	}
--
- 	LOCK_BH(&ip_ftp_lock);
- 	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
- 	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_irc.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_irc.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_irc.c	2003-11-28 19:26:21.000000000 +0100
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_irc.c	2003-12-09 09:30:21.000000000 +0100
-@@ -26,7 +26,6 @@
- #include <linux/module.h>
- #include <linux/netfilter.h>
- #include <linux/ip.h>
--#include <net/checksum.h>
- #include <net/tcp.h>
- 
- #include <linux/netfilter_ipv4/lockhelp.h>
-@@ -109,13 +108,12 @@
- static int help(const struct iphdr *iph, size_t len,
- 		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
- {
--	/* tcplen not negative guarenteed by ip_conntrack_tcp.c */
-+	/* datalen not negative guarenteed by ip_conntrack_proto_tcp.c */
- 	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
- 	const char *data = (const char *) tcph + tcph->doff * 4;
- 	const char *_data = data;
- 	char *data_limit;
--	u_int32_t tcplen = len - iph->ihl * 4;
--	u_int32_t datalen = tcplen - tcph->doff * 4;
-+	u_int32_t datalen = len - iph->ihl * 4 - tcph->doff * 4;
- 	int dir = CTINFO2DIR(ctinfo);
- 	struct ip_conntrack_expect expect, *exp = &expect;
- 	struct ip_ct_irc_expect *exp_irc_info = &exp->help.exp_irc_info;
-@@ -138,22 +136,6 @@
- 		return NF_ACCEPT;
- 	}
- 
--	/* Not whole TCP header? */
--	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4) {
--		DEBUGP("tcplen = %u\n", (unsigned) tcplen);
--		return NF_ACCEPT;
--	}
--
--	/* Checksum invalid?  Ignore. */
--	/* FIXME: Source route IP option packets --RR */
--	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
--			 csum_partial((char *) tcph, tcplen, 0))) {
--		DEBUGP("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
--		     tcph, tcplen, NIPQUAD(iph->saddr),
--		     NIPQUAD(iph->daddr));
--		return NF_ACCEPT;
--	}
--
- 	data_limit = (char *) data + datalen;
- 
- 	/* strlen("\1DCC SEND t AAAAAAAA P\1\n")=24
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2003-11-28 19:26:21.000000000 +0100
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2003-12-10 12:45:55.000000000 +0100
-@@ -1,3 +1,20 @@
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-02-18 04:59:50.000000000 +0100
++++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-03-07 20:49:57.000000000 +0100
+@@ -1,11 +1,20 @@
+-/* (C) 1999-2001 Paul `Rusty' Russell
+- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 +/*
 + * TCP connection tracking
 + */
@@ -214,16 +115,19 @@
 + *	- Real stateful connection tracking
 + *	- Modified state transitions table
 + *	- Window scaling support added
-+ *
+  *
+- * This program is free software; you can redistribute it and/or modify
+- * it under the terms of the GNU General Public License version 2 as
+- * published by the Free Software Foundation.
 + * version 2.1
-+ */
-+
+  */
+ 
 +#define __NO_VERSION__
 +#include <linux/config.h>
  #include <linux/types.h>
  #include <linux/sched.h>
  #include <linux/timer.h>
-@@ -6,101 +23,268 @@
+@@ -14,101 +23,268 @@
  #include <linux/in.h>
  #include <linux/ip.h>
  #include <linux/tcp.h>
@@ -277,19 +181,23 @@
 -   the conntrack of the connection) is required.  RSN.  --RR */
 -
  static const char *tcp_conntrack_names[] = {
- 	"NONE",
--	"ESTABLISHED",
- 	"SYN_SENT",
- 	"SYN_RECV",
-+	"ESTABLISHED",
- 	"FIN_WAIT",
--	"TIME_WAIT",
--	"CLOSE",
- 	"CLOSE_WAIT",
- 	"LAST_ACK",
-+	"TIME_WAIT",
-+	"CLOSE",
- 	"LISTEN"
+-	"NONE",
++ 	"NONE",
++ 	"SYN_SENT",
++ 	"SYN_RECV",
+ 	"ESTABLISHED",
+-	"SYN_SENT",
+-	"SYN_RECV",
+-	"FIN_WAIT",
++ 	"FIN_WAIT",
++ 	"CLOSE_WAIT",
++ 	"LAST_ACK",
+ 	"TIME_WAIT",
+ 	"CLOSE",
+-	"CLOSE_WAIT",
+-	"LAST_ACK",
+-	"LISTEN"
++ 	"LISTEN"
  };
  
 -#define SECS *HZ
@@ -476,7 +384,7 @@
 +/*rst*/    { sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV },
 +/*none*/   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
  	},
- 	{
+-	{
 -/*	REPLY */
 -/* 	  sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI 	*/
 -/*syn*/	{sSR, sES, sSR, sSR, sSR, sSR, sSR, sSR, sSR, sSR },
@@ -484,6 +392,7 @@
 -/*ack*/	{sCL, sES, sSS, sSR, sFW, sTW, sCL, sCW, sCL, sLI },
 -/*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
 -/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
++ 	{
 +/* REPLY */
 +/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
 +/*syn*/	   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV },
@@ -540,18 +449,13 @@
  	}
  };
  
-@@ -145,13 +329,370 @@
+@@ -158,13 +334,373 @@
  	return sprintf(buffer, "%s ", tcp_conntrack_names[state]);
  }
  
 -static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 +static inline unsigned int get_conntrack_index(const struct tcphdr *tcph)
- {
--	if (tcph->rst) return 3;
--	else if (tcph->syn) return 0;
--	else if (tcph->fin) return 1;
--	else if (tcph->ack) return 2;
--	else return 4;
++{
 +	if (tcph->rst) return TCP_RST_SET;
 +	else if (tcph->syn) return (tcph->ack ? TCP_SYNACK_SET : TCP_SYN_SET);
 +	else if (tcph->fin) return TCP_FIN_SET;
@@ -580,9 +484,12 @@
 +   we doesn't have to deal with fragments. 
 +*/
 +
-+#define SEGMENT_SEQ_PLUS_LEN(seq, len, iph, tcph)	\
-+	(seq + len - (iph->ihl + tcph->doff)*4		\
-+	 + (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0))
++static inline __u32 segment_seq_plus_len(__u32 seq, size_t len, struct iphdr *iph, 
++				 struct tcphdr *tcph)
++{
++	return (seq + len - (iph->ihl + tcph->doff)*4 \
++		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
++}
 +
 +/* Fixme: what about big packets? */
 +#define MAXACKWINCONST			66000
@@ -641,7 +548,12 @@
 +                         enum ip_conntrack_dir dir,
 +                         struct iphdr *iph, size_t len,
 +                         struct tcphdr *tcph)
-+{
+ {
+-	if (tcph->rst) return 3;
+-	else if (tcph->syn) return 0;
+-	else if (tcph->fin) return 1;
+-	else if (tcph->ack) return 2;
+-	else return 4;
 +	struct ip_ct_tcp_state *sender = &state->seen[dir];
 +	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 +	__u32 seq, ack, end, win;
@@ -653,7 +565,7 @@
 +	seq = ntohl(tcph->seq);
 +	ack = ntohl(tcph->ack_seq);
 +	win = ntohs(tcph->window);
-+	end = SEGMENT_SEQ_PLUS_LEN(seq, len, iph, tcph);
++	end = segment_seq_plus_len(seq, len, iph, tcph);
 +	
 +	DEBUGP("tcp_in_window: START\n");
 +	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu seq=%u ack=%u win=%u end=%u\n",
@@ -799,7 +711,7 @@
 +		
 +		res = 1;
 +	} else {
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 +			nf_log_ip((char *)iph, len,
 +				"ip_conntrack_tcp: IGNORED: Out of window data; %s\n",
 +				before(end, sender->td_maxend + 1) ?
@@ -809,7 +721,7 @@
 +							: "ACK is under the lower bound (possibly overly delayed ACK)"
 +						: "ACK is over the upper bound (ACKed data has never seen yet)"
 +					: "SEQ is under the lower bound (retransmitted already ACKed data)"
-+				: "SEQ is over the upper bound (over the window of the receiver)");
++				: "SEQ is over the upper bound (over the window of the receiver)");*/
 +
 +		res = ip_ct_tcp_be_liberal && !tcph->rst;
 +	}
@@ -835,7 +747,7 @@
 +	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
 +#endif
 +
-+	end = SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), skb->len, iph, tcph);
++	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, iph, tcph);
 +	
 +	WRITE_LOCK(&tcp_lock);
 +	/*
@@ -888,18 +800,18 @@
 +
 +	/* Not whole TCP header? */
 +	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++		/* if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 +			nf_log_ip((char *)iph, len, 
-+				  "ip_conntrack_tcp: INVALID: truncated packet ");
++				  "ip_conntrack_tcp: INVALID: truncated packet ");*/
 +		return 1;
 +	}
 +
 +	/* Check TCP flags. */
 +	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
 +	if (!tcp_valid_flags[tcpflags]) {
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++		/*if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 +			nf_log_ip((char *)iph, len, 
-+				  "ip_conntrack_tcp: INVALID: invalid TCP flag combination ");
++				  "ip_conntrack_tcp: INVALID: invalid TCP flag combination ");*/
 +		return 1;
 +	}
 +
@@ -907,9 +819,9 @@
 +	/* FIXME: Source route IP option packets --RR */
 +	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
 +			 csum_partial((char *)tcph, tcplen, 0))) {
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
 +			nf_log_ip((char *)iph, len, 
-+				  "ip_conntrack_tcp: INVALID: bad TCP checksum ");
++				  "ip_conntrack_tcp: INVALID: bad TCP checksum ");*/
 +		return 1;
 +	}
 +
@@ -917,41 +829,40 @@
  }
  
  /* Returns verdict for packet, or -1 for invalid. */
-@@ -159,60 +700,130 @@
- 		      struct iphdr *iph, size_t len,
+@@ -172,82 +708,223 @@
+ 		      const struct sk_buff *skb,
  		      enum ip_conntrack_info ctinfo)
  {
 -	enum tcp_conntrack newconntrack, oldtcpstate;
 +	enum tcp_conntrack new_state, old_state;
 +	enum ip_conntrack_dir dir;
- 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
--
--	/* We're guaranteed to have the base header, but maybe not the
--           options. */
--	if (len < (iph->ihl + tcph->doff) * 4) {
--		DEBUGP("ip_conntrack_tcp: Truncated packet.\n");
--		return -1;
--	}
--
+ 	struct tcphdr tcph;
 +	unsigned long timeout;
 +	unsigned int index;
+ 
++	/* FIXME: does unclean do the same? */
+ 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
+ 		return -1;
 +	
 +	/* Do not handle unclean packets, which could cause false alarms */
-+	if (unclean(iph, len))
++	if (unclean(skb->nh.iph, skb->len))
 +		return -NF_ACCEPT;
-+	
+ 
  	WRITE_LOCK(&tcp_lock);
 -	oldtcpstate = conntrack->proto.tcp.state;
 -	newconntrack
 -		= tcp_conntracks
 -		[CTINFO2DIR(ctinfo)]
--		[get_conntrack_index(tcph)][oldtcpstate];
+-		[get_conntrack_index(&tcph)][oldtcpstate];
 -
 -	/* Invalid */
 -	if (newconntrack == TCP_CONNTRACK_MAX) {
+-		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
+-		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
+-		       conntrack->proto.tcp.state);
 +	old_state = conntrack->proto.tcp.state;
 +	dir = CTINFO2DIR(ctinfo);
-+	index = get_conntrack_index(tcph);
++	index = get_conntrack_index(&tcph);
 +	new_state = tcp_conntracks[dir][index][old_state];
 +
 +	switch (new_state) {
@@ -960,7 +871,7 @@
 +		if (index == TCP_SYNACK_SET
 +		    && conntrack->proto.tcp.stored_seq == TCP_SYN_SET
 +		    && conntrack->proto.tcp.last_dir != dir
-+		    && after(ntohl(tcph->ack_seq), conntrack->proto.tcp.last_seq)) {
++		    && after(ntohl(tcph.ack_seq), conntrack->proto.tcp.last_seq)) {
 +			/* This SYN/ACK acknowledges a SYN that we earlier ignored 
 +			 * as invalid. This means that the client and the server 
 +			 * are both in sync, while the firewall is not. We kill 
@@ -969,39 +880,64 @@
 +			 * clean new session.
 +			 */
 +		    	WRITE_UNLOCK(&tcp_lock);
-+			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
-+				nf_log_ip((char *)iph, len, 
-+					  "ip_conntrack_tcp: INVALID: killing out of sync session ");
++		/*	if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++				nf_log_ip((char *)skb->nh.iph, skb->len, 
++					  "ip_conntrack_tcp: INVALID: killing out of sync session ");*/
 +		    	if (del_timer(&conntrack->timeout))
 +		    		conntrack->timeout.function((unsigned long)conntrack);
 +		    	return -NF_ACCEPT;
 +		}
 +		conntrack->proto.tcp.stored_seq = index;
 +		conntrack->proto.tcp.last_dir = dir;
-+		conntrack->proto.tcp.last_seq = ntohl(tcph->seq);
++		conntrack->proto.tcp.last_seq = ntohl(tcph.seq);
 +		
-+		WRITE_UNLOCK(&tcp_lock);
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
-+			nf_log_ip((char *)iph, len, 
-+				  "ip_conntrack_tcp: INVALID: invalid SYN (ignored) ");
+ 		WRITE_UNLOCK(&tcp_lock);
+-		return -1;
+-	}
+-
+-	conntrack->proto.tcp.state = newconntrack;
+-
+-	/* Poor man's window tracking: record SYN/ACK for handshake check */
+-	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
+-	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
+-	    && tcph.syn && tcph.ack)
+-		conntrack->proto.tcp.handshake_ack
+-			= htonl(ntohl(tcph.seq) + 1);
+-
+-	/* If only reply is a RST, we can consider ourselves not to
+-	   have an established connection: this is a fairly common
+-	   problem case, so we can delete the conntrack
+-	   immediately.  --RR */
+-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
++/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++			nf_log_ip((char *)skb->nh.iph, skb->len, 
++				  "ip_conntrack_tcp: INVALID: invalid SYN (ignored) ");*/
 +		return NF_ACCEPT;
++		break;
 +	case TCP_CONNTRACK_MAX:
 +		/* Invalid packet */
- 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
--		       CTINFO2DIR(ctinfo), get_conntrack_index(tcph),
--		       conntrack->proto.tcp.state);
-+		       dir, get_conntrack_index(tcph),
++ 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
++		       dir, get_conntrack_index(&tcph),
 +		       old_state);
  		WRITE_UNLOCK(&tcp_lock);
--		return -1;
-+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
-+			nf_log_ip((char *)iph, len, 
-+				  "ip_conntrack_tcp: INVALID: invalid state ");
+-		if (del_timer(&conntrack->timeout))
+-			conntrack->timeout.function((unsigned long)conntrack);
+-	} else {
+-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
+-		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
+-		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
+-		    && tcph.ack && !tcph.syn
+-		    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
+-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+ 
++/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++			nf_log_ip((char *)skb->nh.iph, skb->len, 
++				  "ip_conntrack_tcp: INVALID: invalid state ");*/
 +		return -NF_ACCEPT;
 +	case TCP_CONNTRACK_SYN_SENT:
-+		if (old_state >= TCP_CONNTRACK_TIME_WAIT) {	
++		if (old_state >= TCP_CONNTRACK_TIME_WAIT) { 
 +		    	/* Attempt to reopen a closed connection.
-+		    	* Delete this connection and look up again. */
++		    	 * Delete this connection and look up again. */
 +		    	WRITE_UNLOCK(&tcp_lock);
 +		    	if (del_timer(&conntrack->timeout))
 +		    		conntrack->timeout.function((unsigned long)conntrack);
@@ -1012,56 +948,31 @@
 +		if (index == TCP_RST_SET
 +		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
 +		    && conntrack->proto.tcp.stored_seq <= TCP_SYNACK_SET
-+		    && after(ntohl(tcph->ack), conntrack->proto.tcp.last_seq)) {
++		    && after(ntohl(tcph.ack), conntrack->proto.tcp.last_seq)) {
 +			/* Ignore RST closing down invalid SYN we had let trough. */ 
 +		    	WRITE_UNLOCK(&tcp_lock);
-+			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
-+				nf_log_ip((char *)iph, len, 
-+					  "ip_conntrack_tcp: INVALID: invalid RST (ignored) ");
++/*			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
++				nf_log_ip((char *)skb->nh.iph, skb->len, 
++					  "ip_conntrack_tcp: INVALID: invalid RST (ignored) ");*/
 +			return NF_ACCEPT;
 +		}
 +		/* Just fall trough */
 +	default:
 +		/* Keep compilers happy. */
- 	}
- 
--	conntrack->proto.tcp.state = newconntrack;
--
--	/* Poor man's window tracking: record SYN/ACK for handshake check */
--	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
--	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
--	    && tcph->syn && tcph->ack)
--		conntrack->proto.tcp.handshake_ack
--			= htonl(ntohl(tcph->seq) + 1);
--
--	/* If only reply is a RST, we can consider ourselves not to
--	   have an established connection: this is a fairly common
--	   problem case, so we can delete the conntrack
--	   immediately.  --RR */
--	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph->rst) {
++	}
++
 +	conntrack->proto.tcp.stored_seq = index;
-+	if (!tcp_in_window(&conntrack->proto.tcp, dir, iph, len, tcph)) {
++	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb->nh.iph, skb->len, &tcph)) {
 +		/* Invalid packet */
  		WRITE_UNLOCK(&tcp_lock);
--		if (del_timer(&conntrack->timeout))
--			conntrack->timeout.function((unsigned long)conntrack);
--	} else {
--		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
--		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
--		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
--		    && tcph->ack && !tcph->syn
--		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
--			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 +		return -NF_ACCEPT;
-+	}
+ 	}
 +	/* If FIN was trimmed off, don't change state. */
 +	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
- 
--		WRITE_UNLOCK(&tcp_lock);
--		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 +	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
-+		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
-+		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0), (tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
++		NIPQUAD(iph->saddr), ntohs(tcph.source), NIPQUAD(iph->daddr), ntohs(tcph.dest),
++		(tcph.syn ? 1 : 0), (tcph.ack ? 1 : 0), (tcph.fin ? 1 : 0), (tcph.rst ? 1 : 0),
 +		old_state, new_state);
 +
 +	conntrack->proto.tcp.state = new_state;
@@ -1074,7 +985,7 @@
 +		   have an established connection: this is a fairly common
 +		   problem case, so we can delete the conntrack
 +		   immediately.  --RR */
-+		if (tcph->rst) {
++		if (tcph.rst) {
 +			WRITE_UNLOCK(&tcp_lock);
 +			if (del_timer(&conntrack->timeout))
 +				conntrack->timeout.function((unsigned long)conntrack);
@@ -1087,32 +998,39 @@
 +			    && new_state == TCP_CONNTRACK_ESTABLISHED)
 +				set_bit(IPS_ASSURED_BIT, &conntrack->status);
 +		}
- 	}
++ 	}
 +	WRITE_UNLOCK(&tcp_lock);
 +	ip_ct_refresh(conntrack, timeout);
  
- 	return NF_ACCEPT;
+-	return NF_ACCEPT;
++ 	return NF_ACCEPT;
  }
-@@ -221,21 +832,80 @@
- static int tcp_new(struct ip_conntrack *conntrack,
- 		   struct iphdr *iph, size_t len)
+ 
++	
+ /* Called when a new connection for this protocol found. */
+ static int tcp_new(struct ip_conntrack *conntrack, const struct sk_buff *skb)
  {
 -	enum tcp_conntrack newconntrack;
 +	enum tcp_conntrack new_state;
- 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+ 	struct tcphdr tcph;
+ 
 +#ifdef DEBUGP_VARS
 +	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
 +	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
 +#endif
 +
++	/* FIXME: do the same as unclean does? Anyway I needed */
+ 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
+ 		return -1;
+ 
 +	/* Skip unclean packets */
-+	if (unclean(iph, len))
++	if (unclean(skb->nh.iph, skb->len))
 +		return 0;
- 
++
  	/* Don't need lock here: this conntrack not in circulation yet */
 -	newconntrack
 +	new_state
- 		= tcp_conntracks[0][get_conntrack_index(tcph)]
+ 		= tcp_conntracks[0][get_conntrack_index(&tcph)]
  		[TCP_CONNTRACK_NONE];
  
  	/* Invalid: delete conntrack */
@@ -1123,17 +1041,18 @@
  	}
  
 -	conntrack->proto.tcp.state = newconntrack;
+-	return 1;
 +	if (new_state == TCP_CONNTRACK_SYN_SENT) {
 +		/* SYN packet */
 +		conntrack->proto.tcp.seen[0].td_end =
-+			SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), len, iph, tcph);
-+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
++			segment_seq_plus_len(ntohl(tcph.seq), skb->len, skb->nh.iph, &tcph);
++		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
 +		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
 +			conntrack->proto.tcp.seen[0].td_maxwin = 1;
 +		conntrack->proto.tcp.seen[0].td_maxend =
 +			conntrack->proto.tcp.seen[0].td_end;
 +
-+		tcp_options(iph, len, tcph, &conntrack->proto.tcp.seen[0]);
++		tcp_options(skb->nh.iph, skb->len, &tcph, &conntrack->proto.tcp.seen[0]);
 +		conntrack->proto.tcp.seen[1].flags = 0;
 +		conntrack->proto.tcp.seen[0].loose = 
 +		conntrack->proto.tcp.seen[1].loose = 0;
@@ -1147,8 +1066,8 @@
 +		 * Let's try to use the data from the packet.
 +		 */
 +		conntrack->proto.tcp.seen[0].td_end =
-+			SEGMENT_SEQ_PLUS_LEN(ntohl(tcph->seq), len, iph, tcph);
-+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
++			segment_seq_plus_len(ntohl(tcph.seq), skb->len, skb->nh.iph, &tcph);
++		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
 +		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
 +			conntrack->proto.tcp.seen[0].td_maxwin = 1;
 +		conntrack->proto.tcp.seen[0].td_maxend =
@@ -1162,7 +1081,7 @@
 +		conntrack->proto.tcp.seen[0].loose = 
 +		conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
 +	}
-+    
++   
 +	conntrack->proto.tcp.seen[1].td_end = 0;
 +	conntrack->proto.tcp.seen[1].td_maxend = 0;
 +	conntrack->proto.tcp.seen[1].td_maxwin = 1;
@@ -1175,13 +1094,13 @@
 +	DEBUGP("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 +		sender->td_end, sender->td_maxend, sender->td_maxwin, sender->td_scale, 
 +		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, receiver->td_scale);
- 	return 1;
++ 	return 1;
  }
  
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_standalone.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-12-04 16:56:14.000000000 +0100
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-12-09 09:30:21.000000000 +0100
-@@ -289,6 +289,11 @@
+ static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18 04:57:46.000000000 +0100
++++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-07 19:12:08.000000000 +0100
+@@ -285,6 +285,11 @@
  extern unsigned long ip_ct_tcp_timeout_last_ack;
  extern unsigned long ip_ct_tcp_timeout_time_wait;
  extern unsigned long ip_ct_tcp_timeout_close;
@@ -1193,7 +1112,7 @@
  
  /* From ip_conntrack_proto_udp.c */
  extern unsigned long ip_ct_udp_timeout;
-@@ -345,6 +350,21 @@
+@@ -338,6 +343,21 @@
  	{NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT, "ip_conntrack_generic_timeout",
  	 &ip_ct_generic_timeout, sizeof(unsigned int), 0644, NULL,
  	 &proc_dointvec_jiffies},
@@ -1215,15 +1134,29 @@
  	{0}
  };
  
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.23-pending/net/ipv4/netfilter/ip_nat_helper.c linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_nat_helper.c
---- linux-2.4.23-pending/net/ipv4/netfilter/ip_nat_helper.c	2003-11-28 19:26:21.000000000 +0100
-+++ linux-2.4.23-tcp-win/net/ipv4/netfilter/ip_nat_helper.c	2003-12-09 09:30:21.000000000 +0100
-@@ -452,6 +452,8 @@
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_nat_helper.c	2004-02-18 04:57:17.000000000 +0100
++++ linux-2.6.3-patched/net/ipv4/netfilter/ip_nat_helper.c	2004-03-07 20:07:27.000000000 +0100
+@@ -353,8 +353,8 @@
+ 		  enum ip_conntrack_info ctinfo)
+ {
+ 	struct tcphdr *tcph;
+-	int dir, newseq, newack;
+-	struct ip_nat_seq *this_way, *other_way;	
++	int dir, newseq, newack, ret;
++	struct ip_nat_seq *this_way, *other_way;
+ 
+ 	dir = CTINFO2DIR(ctinfo);
  
- 	ip_nat_sack_adjust(skb, ct, ctinfo);
+@@ -395,7 +395,11 @@
+ 	tcph->seq = newseq;
+ 	tcph->ack_seq = newack;
  
-+	ip_conntrack_tcp_update(skb, ct, dir);
+-	return ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
++	ret = ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
++
++	ip_conntrack_tcp_update(*pskb, ct, dir);
 +
- 	return 0;
++	return ret;
  }
  
+ static inline int

--------------000509060703020105070800
Content-Type: text/plain;
 name="tcp_window-tracking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tcp_window-tracking.patch"

--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-18 04:59:30.000000000 +0100
+++ linux-2.6.3-patched/include/linux/netfilter_ipv4/ip_conntrack.h	2004-03-07 18:47:15.000000000 +0100
@@ -251,6 +251,11 @@
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
 
+/* Update TCP window tracking data when NAT mangles the packet */
+extern void ip_conntrack_tcp_update(struct sk_buff *skb,
+				    struct ip_conntrack *conntrack, 
+				    int dir);
+
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb);
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-02-18 04:57:29.000000000 +0100
+++ linux-2.6.3-patched/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-03-07 18:48:48.000000000 +0100
@@ -4,25 +4,41 @@
 
 enum tcp_conntrack {
 	TCP_CONNTRACK_NONE,
-	TCP_CONNTRACK_ESTABLISHED,
 	TCP_CONNTRACK_SYN_SENT,
 	TCP_CONNTRACK_SYN_RECV,
+	TCP_CONNTRACK_ESTABLISHED,
 	TCP_CONNTRACK_FIN_WAIT,
-	TCP_CONNTRACK_TIME_WAIT,
-	TCP_CONNTRACK_CLOSE,
 	TCP_CONNTRACK_CLOSE_WAIT,
 	TCP_CONNTRACK_LAST_ACK,
+	TCP_CONNTRACK_TIME_WAIT,
+	TCP_CONNTRACK_CLOSE,
 	TCP_CONNTRACK_LISTEN,
-	TCP_CONNTRACK_MAX
+	TCP_CONNTRACK_MAX,
+	TCP_CONNTRACK_IGNORE
+};
+
+/* Window scaling is advertised by the sender */
+#define IP_CT_TCP_STATE_FLAG_WINDOW_SCALE	0x01
+
+struct ip_ct_tcp_state {
+	u_int32_t	td_end;		/* max of seq + len */
+	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
+	u_int32_t	td_maxwin;	/* max(win) */
+	u_int8_t	td_scale;	/* window scale factor */
+	u_int8_t	loose;		/* used when connection picked up from the middle */
+	u_int8_t	flags;		/* per direction state flags */
 };
 
 struct ip_ct_tcp
 {
-	enum tcp_conntrack state;
-
-	/* Poor man's window tracking: sequence number of valid ACK
-           handshake completion packet */
-	u_int32_t handshake_ack;
+	struct ip_ct_tcp_state seen[2];	/* connection parameters per direction */
+	u_int8_t	state;		/* state of the connection (enum tcp_conntrack) */
+	/* For detecting stale connections */
+	u_int8_t	last_dir;	/* Direction of the last packet (enum ip_conntrack_dir) */
+	u_int8_t	retrans;	/* Number of retransmitted packets */
+	u_int8_t	stored_seq;	/* What is stored in last_seq */
+	u_int32_t	last_seq;	/* Last sequence number seen in dir */
+	u_int32_t	last_end;	/* Last seq + len */
 };
 
 #endif /* _IP_CONNTRACK_TCP_H */
--- linux-2.6.3-old/include/linux/sysctl.h	2004-02-18 04:58:10.000000000 +0100
+++ linux-2.6.3-patched/include/linux/sysctl.h	2004-03-07 18:50:32.000000000 +0100
@@ -380,6 +380,11 @@
 	NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM=11,
 	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
 	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
+ 	NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=15,
+ 	NET_IPV4_NF_CONNTRACK_TCP_LOG_INVALID=16,
+ 	NET_IPV4_NF_CONNTRACK_TCP_LOOSE=17,
+ 	NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL=18,
+ 	NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS=19,
 };
  
 /* /proc/sys/net/ipv6 */
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57:11.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-07 18:52:45.000000000 +0100
@@ -842,11 +842,12 @@
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, *pskb, ctinfo);
-	if (ret == -1) {
-		/* Invalid */
-		nf_conntrack_put((*pskb)->nfct);
-		(*pskb)->nfct = NULL;
-		return NF_ACCEPT;
+	if (ret < 0 ) {
+		/* Invalid: inverse of the return code tells
+		 * to the netfilter core what to do. */
+ 		nf_conntrack_put((*pskb)->nfct);
+ 		(*pskb)->nfct = NULL;
+		return -ret;
 	}
 
 	if (ret != NF_DROP && ct->helper) {
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-02-18 04:59:50.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-03-07 20:49:57.000000000 +0100
@@ -1,11 +1,20 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+/*
+ * TCP connection tracking
+ */
+
+/* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
+ * Public Licence. 
+ *
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
+ *	- Real stateful connection tracking
+ *	- Modified state transitions table
+ *	- Window scaling support added
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * version 2.1
  */
 
+#define __NO_VERSION__
+#include <linux/config.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -14,101 +23,268 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/string.h>
+#include <linux/spinlock.h>
 
 #include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
+#include <linux/netfilter_ipv4/ip_logging.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
 
 #if 0
 #define DEBUGP printk
+#define DEBUGP_VARS
+#define NET_RATELIMIT(foo)	(foo)
 #else
 #define DEBUGP(format, args...)
+#define NET_RATELIMIT(foo)	((foo) && net_ratelimit())
 #endif
 
 /* Protects conntrack->proto.tcp */
 static DECLARE_RWLOCK(tcp_lock);
 
+/* Log invalid/ignored packets */
+int ip_ct_tcp_log_invalid = 1;
+
+/* "Be conservative in what you do, 
+    be liberal in what you accept from others." 
+    If it's non-zero, we mark only out of window RST segments as INVALID. */
+int ip_ct_tcp_be_liberal = 0;
+
+/* When connection is picked up from the middle, how many packets are required
+   to pass in each direction when we assume we are in sync - if any side uses
+   window scaling, we lost the game. 
+   If it is set to zero, we disable picking up already established connections. */
+int ip_ct_tcp_loose = 3;
+
+/* Max number of the retransmitted packets without receiving an (acceptable) 
+   ACK from the destination. If this number is reached, a shorter timer 
+   will be started. */
+int ip_ct_tcp_max_retrans = 3;
+
 /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
    closely.  They're more complex. --RR */
 
-/* Actually, I believe that neither ipmasq (where this code is stolen
-   from) nor ipfilter do it exactly right.  A new conntrack machine taking
-   into account packet loss (which creates uncertainty as to exactly
-   the conntrack of the connection) is required.  RSN.  --RR */
-
 static const char *tcp_conntrack_names[] = {
-	"NONE",
+ 	"NONE",
+ 	"SYN_SENT",
+ 	"SYN_RECV",
 	"ESTABLISHED",
-	"SYN_SENT",
-	"SYN_RECV",
-	"FIN_WAIT",
+ 	"FIN_WAIT",
+ 	"CLOSE_WAIT",
+ 	"LAST_ACK",
 	"TIME_WAIT",
 	"CLOSE",
-	"CLOSE_WAIT",
-	"LAST_ACK",
-	"LISTEN"
+ 	"LISTEN"
 };
 
-#define SECS *HZ
+#define SECS * HZ
 #define MINS * 60 SECS
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-unsigned long ip_ct_tcp_timeout_syn_sent =      2 MINS;
-unsigned long ip_ct_tcp_timeout_syn_recv =     60 SECS;
-unsigned long ip_ct_tcp_timeout_established =   5 DAYS;
-unsigned long ip_ct_tcp_timeout_fin_wait =      2 MINS;
-unsigned long ip_ct_tcp_timeout_close_wait =   60 SECS;
-unsigned long ip_ct_tcp_timeout_last_ack =     30 SECS;
-unsigned long ip_ct_tcp_timeout_time_wait =     2 MINS;
-unsigned long ip_ct_tcp_timeout_close =        10 SECS;
+unsigned long ip_ct_tcp_timeout_syn_sent =	 2 MINS;
+unsigned long ip_ct_tcp_timeout_syn_recv =	60 SECS;
+unsigned long ip_ct_tcp_timeout_established =	 5 DAYS;
+unsigned long ip_ct_tcp_timeout_fin_wait =	 2 MINS;
+unsigned long ip_ct_tcp_timeout_close_wait =	10 MINS;
+unsigned long ip_ct_tcp_timeout_last_ack =	30 SECS;
+unsigned long ip_ct_tcp_timeout_time_wait =	 2 MINS;
+unsigned long ip_ct_tcp_timeout_close =		10 SECS;
+
+/* RFC1122 says the R2 limit should be at least 100 seconds.
+   Linux uses 15 packets as limit, which corresponds 
+   to ~13-30min depending on RTO. */
+unsigned long ip_ct_tcp_timeout_max_retrans =     5 MINS;
 
 static unsigned long * tcp_timeouts[]
-= { 0,                                 /*      TCP_CONNTRACK_NONE */
-    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED,      */
-    &ip_ct_tcp_timeout_syn_sent,       /*      TCP_CONNTRACK_SYN_SENT, */
-    &ip_ct_tcp_timeout_syn_recv,       /*      TCP_CONNTRACK_SYN_RECV, */
-    &ip_ct_tcp_timeout_fin_wait,       /*      TCP_CONNTRACK_FIN_WAIT, */
-    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,        */
-    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
-    &ip_ct_tcp_timeout_close_wait,     /*      TCP_CONNTRACK_CLOSE_WAIT,       */
-    &ip_ct_tcp_timeout_last_ack,       /*      TCP_CONNTRACK_LAST_ACK, */
-    0,                                 /*      TCP_CONNTRACK_LISTEN */
- };
- 
+= { 0,					/*	TCP_CONNTRACK_NONE */
+    &ip_ct_tcp_timeout_syn_sent,	/*	TCP_CONNTRACK_SYN_SENT,	*/
+    &ip_ct_tcp_timeout_syn_recv,	/*	TCP_CONNTRACK_SYN_RECV,	*/
+    &ip_ct_tcp_timeout_established,	/*	TCP_CONNTRACK_ESTABLISHED,	*/
+    &ip_ct_tcp_timeout_fin_wait,	/*	TCP_CONNTRACK_FIN_WAIT,	*/
+    &ip_ct_tcp_timeout_close_wait,	/*	TCP_CONNTRACK_CLOSE_WAIT,	*/
+    &ip_ct_tcp_timeout_last_ack,	/*	TCP_CONNTRACK_LAST_ACK,	*/
+    &ip_ct_tcp_timeout_time_wait,	/*	TCP_CONNTRACK_TIME_WAIT,	*/
+    &ip_ct_tcp_timeout_close,		/*	TCP_CONNTRACK_CLOSE,	*/
+    0,					/*	TCP_CONNTRACK_LISTEN */
+};
+
 #define sNO TCP_CONNTRACK_NONE
-#define sES TCP_CONNTRACK_ESTABLISHED
 #define sSS TCP_CONNTRACK_SYN_SENT
 #define sSR TCP_CONNTRACK_SYN_RECV
+#define sES TCP_CONNTRACK_ESTABLISHED
 #define sFW TCP_CONNTRACK_FIN_WAIT
-#define sTW TCP_CONNTRACK_TIME_WAIT
-#define sCL TCP_CONNTRACK_CLOSE
 #define sCW TCP_CONNTRACK_CLOSE_WAIT
 #define sLA TCP_CONNTRACK_LAST_ACK
+#define sTW TCP_CONNTRACK_TIME_WAIT
+#define sCL TCP_CONNTRACK_CLOSE
 #define sLI TCP_CONNTRACK_LISTEN
 #define sIV TCP_CONNTRACK_MAX
+#define sIG TCP_CONNTRACK_IGNORE
 
-static enum tcp_conntrack tcp_conntracks[2][5][TCP_CONNTRACK_MAX] = {
+/* What TCP flags are set from RST/SYN/FIN/ACK. */
+enum tcp_bit_set {
+	TCP_SYN_SET,
+	TCP_SYNACK_SET,
+	TCP_FIN_SET,
+	TCP_ACK_SET,
+	TCP_RST_SET,
+	TCP_NONE_SET,
+};
+
+/*
+ * The TCP state transition table needs a few words...
+ *
+ * We are the man in the middle. All the packets go through us
+ * but might get lost in transit to the destination.
+ * It is assumed that the destinations can't receive segments 
+ * we haven't seen.
+ *
+ * The checked segment is in window, but our windows are *not*
+ * equivalent with the ones of the sender/receiver. We always
+ * try to guess the state of the current sender.
+ *
+ * The meaning of the states are:
+ *
+ * NONE:	initial state
+ * SYN_SENT:	SYN-only packet seen 
+ * SYN_RECV:	SYN-ACK packet seen
+ * ESTABLISHED:	ACK packet seen
+ * FIN_WAIT:	FIN packet seen
+ * CLOSE_WAIT:	ACK seen (after FIN) 
+ * LAST_ACK:	FIN seen (after FIN)
+ * TIME_WAIT:	last ACK seen
+ * CLOSE:	closed connection
+ *
+ * LISTEN state is not used.
+ *
+ * Packets marked as IGNORED (sIG):
+ *	if they may be either invalid or valid 
+ *	and the receiver may send back a connection 
+ *	closing RST or a SYN/ACK.
+ *
+ * Packets marked as INVALID (sIV):
+ *	if they are invalid
+ *	or we do not support the request (simultaneous open)
+ */
+static enum tcp_conntrack tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	{
-/*	ORIGINAL */
-/* 	  sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI 	*/
-/*syn*/	{sSS, sES, sSS, sSR, sSS, sSS, sSS, sSS, sSS, sLI },
-/*fin*/	{sTW, sFW, sSS, sTW, sFW, sTW, sCL, sTW, sLA, sLI },
-/*ack*/	{sES, sES, sSS, sES, sFW, sTW, sCL, sCW, sLA, sES },
-/*rst*/ {sCL, sCL, sSS, sCL, sCL, sTW, sCL, sCL, sCL, sCL },
-/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
+/* ORIGINAL */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*syn*/	   { sSS, sSS, sIG, sIG, sIG, sIG, sIG, sSS, sSS, sIV },
+/*
+ *	sNO -> sSS	Initialize a new connection
+ *	sSS -> sSS	Retransmitted SYN
+ *	sSR -> sIG	Late retransmitted SYN?
+ *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
+ *			are errors. Receiver will reply with RST 
+ *			and close the connection.
+ *			Or we are not in sync and hold a dead connection.
+ *	sFW -> sIG
+ *	sCW -> sIG
+ *	sLA -> sIG
+ *	sTW -> sSS	Reopened connection (RFC 1122).
+ *	sCL -> sSS
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*synack*/ { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV },
+/*
+ * A SYN/ACK from the client is always invalid:
+ *	- either it tries to set up a simultaneous open, which is 
+ *	  not supported;
+ *	- or the firewall has just been inserted between the two hosts
+ *	  during the session set-up. The SYN will be retransmitted 
+ *	  by the true client (or it'll time out).
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
+/*
+ *	sNO -> sIV	Too late and no reason to do anything...
+ *	sSS -> sIV	Client migth not send FIN in this state:
+ *			we enforce waiting for a SYN/ACK reply first.
+ *	sSR -> sFW	Close started.
+ *	sES -> sFW	
+ *	sFW -> sLA	FIN seen in both directions, waiting for
+ *			the last ACK. 
+ *			Migth be a retransmitted FIN as well...
+ *	sCW -> sLA
+ *	sLA -> sLA	Retransmitted FIN. Remain in the same state.
+ *	sTW -> sTW
+ *	sCL -> sCL
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*ack*/	   { sES, sIV, sES, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*
+ *	sNO -> sES	Assumed.
+ *	sSS -> sIV	ACK is invalid: we haven't seen a SYN/ACK yet.
+ *	sSR -> sES	Established state is reached.
+ *	sES -> sES	:-)
+ *	sFW -> sCW	Normal close request answered by ACK.
+ *	sCW -> sCW
+ *	sLA -> sTW	Last ACK detected.
+ *	sTW -> sTW	Retransmitted last ACK. Remain in the same state.
+ *	sCL -> sCL
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*rst*/    { sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV },
+/*none*/   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
 	},
-	{
-/*	REPLY */
-/* 	  sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI 	*/
-/*syn*/	{sSR, sES, sSR, sSR, sSR, sSR, sSR, sSR, sSR, sSR },
-/*fin*/	{sCL, sCW, sSS, sTW, sTW, sTW, sCL, sCW, sLA, sLI },
-/*ack*/	{sCL, sES, sSS, sSR, sFW, sTW, sCL, sCW, sCL, sLI },
-/*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
-/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
+ 	{
+/* REPLY */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*syn*/	   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV },
+/*
+ *	sNO -> sIV	Never reached.
+ *	sSS -> sIV	Simultaneous open, not supported
+ *	sSR -> sIV	Simultaneous open, not supported.
+ *	sES -> sIV	Server may not initiate a connection.
+ *	sFW -> sIV
+ *	sCW -> sIV
+ *	sLA -> sIV
+ *	sTW -> sIV	Reopened connection, but server may not do it.
+ *	sCL -> sIV
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*synack*/ { sIV, sSR, sSR, sIG, sIG, sIG, sIG, sIG, sIG, sIV },
+/*
+ *	sSS -> sSR	Standard open.
+ *	sSR -> sSR	Retransmitted SYN/ACK.
+ *	sES -> sIG	Late retransmitted SYN/ACK?
+ *	sFW -> sIG
+ *	sCW -> sIG
+ *	sLA -> sIG
+ *	sTW -> sIG
+ *	sCL -> sIG
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
+/*
+ *	sSS -> sIV	Server might not send FIN in this state.
+ *	sSR -> sFW	Close started.
+ *	sES -> sFW
+ *	sFW -> sLA	FIN seen in both directions.
+ *	sCW -> sLA
+ *	sLA -> sLA	Retransmitted FIN.
+ *	sTW -> sTW
+ *	sCL -> sCL
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*ack*/	   { sIV, sIV, sIV, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*
+ *	sSS -> sIV	ACK is invalid: we haven't seen a SYN/ACK yet.
+ *	sSR -> sIV	Simultaneous open.
+ *	sES -> sES	:-)
+ *	sFW -> sCW	Normal close request answered by ACK.
+ *	sCW -> sCW
+ *	sLA -> sTW	Last ACK detected.
+ *	sTW -> sTW	Retransmitted last ACK.
+ *	sCL -> sCL
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*rst*/    { sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV },
+/*none*/   { sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
 	}
 };
 
@@ -158,13 +334,373 @@
 	return sprintf(buffer, "%s ", tcp_conntrack_names[state]);
 }
 
-static unsigned int get_conntrack_index(const struct tcphdr *tcph)
+static inline unsigned int get_conntrack_index(const struct tcphdr *tcph)
+{
+	if (tcph->rst) return TCP_RST_SET;
+	else if (tcph->syn) return (tcph->ack ? TCP_SYNACK_SET : TCP_SYN_SET);
+	else if (tcph->fin) return TCP_FIN_SET;
+	else if (tcph->ack) return TCP_ACK_SET;
+	else return TCP_NONE_SET;
+}
+
+/* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
+   in IP Filter' by Guido van Rooij.
+   
+   http://www.nluug.nl/events/sane2000/papers.html
+   http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
+   
+   The boundaries and the conditions:
+   
+   	td_maxend = max(ack + max(win,1)) seen in reply packets
+	td_maxwin = max(max(win, 1)) seen in sent packets
+	td_end    = max(seq + len) seen in sent packets
+   
+   I. 	Upper bound for valid data:	seq + len <= sender.td_maxend
+   II. 	Lower bound for valid data:	seq >= sender.td_end - receiver.td_maxwin
+   III.	Upper bound for valid ack:      ack <= receiver.td_end
+   IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
+   	
+   The upper bound limit for a valid ack is not ignored - 
+   we doesn't have to deal with fragments. 
+*/
+
+static inline __u32 segment_seq_plus_len(__u32 seq, size_t len, struct iphdr *iph, 
+				 struct tcphdr *tcph)
+{
+	return (seq + len - (iph->ihl + tcph->doff)*4 \
+		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
+}
+
+/* Fixme: what about big packets? */
+#define MAXACKWINCONST			66000
+#define MAXACKWINDOW(sender)		\
+	((sender)->td_maxwin > MAXACKWINCONST ? (sender)->td_maxwin : MAXACKWINCONST)
+
+/*
+ * Simplified tcp_parse_options routine from tcp_input.c
+ */
+static void tcp_options(struct iphdr *iph, size_t len,
+			struct tcphdr *tcph, 
+			struct ip_ct_tcp_state *state)
+{
+	unsigned char *ptr;
+	int length = (tcph->doff*4) - sizeof(struct tcphdr);
+	
+	ptr = (unsigned char *)(tcph + 1);
+	state->td_scale = 
+	state->flags = 0;
+	
+	while (length > 0) {
+		int opcode=*ptr++;
+		int opsize;
+		
+		switch (opcode) {
+			case TCPOPT_EOL:
+				return;
+			case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+				length--;
+				continue;
+			default:
+				opsize=*ptr++;
+				if (opsize < 2) /* "silly options" */
+					return;
+				if (opsize > length)
+					break;	/* don't parse partial options */
+
+				if (opcode == TCPOPT_WINDOW && opsize == TCPOLEN_WINDOW) {
+					state->td_scale = *(u_int8_t *)ptr;
+					
+					if (state->td_scale > 14) {
+						/* See RFC1323 for an explanation of the limit to 14 */
+						state->td_scale = 14;
+					}
+					state->flags |= IP_CT_TCP_STATE_FLAG_WINDOW_SCALE;
+
+					return;
+				}
+				ptr += opsize - 2;
+				length -= opsize;
+		}
+	}
+}
+
+static int tcp_in_window(struct ip_ct_tcp *state, 
+                         enum ip_conntrack_dir dir,
+                         struct iphdr *iph, size_t len,
+                         struct tcphdr *tcph)
 {
-	if (tcph->rst) return 3;
-	else if (tcph->syn) return 0;
-	else if (tcph->fin) return 1;
-	else if (tcph->ack) return 2;
-	else return 4;
+	struct ip_ct_tcp_state *sender = &state->seen[dir];
+	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
+	__u32 seq, ack, end, win;
+	int res;
+	
+	/*
+	 * Get the required data from the packet.
+	 */
+	seq = ntohl(tcph->seq);
+	ack = ntohl(tcph->ack_seq);
+	win = ntohs(tcph->window);
+	end = segment_seq_plus_len(seq, len, iph, tcph);
+	
+	DEBUGP("tcp_in_window: START\n");
+	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu seq=%u ack=%u win=%u end=%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, win, end);
+	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin, sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, receiver->td_scale);
+		
+	if (sender->td_end == 0) {
+		/*
+		 * Initialize sender data.
+		 */
+		if (tcph->syn && tcph->ack) {
+			/*
+			 * Outgoing SYN-ACK in reply to a SYN.
+			 */
+			sender->td_end = 
+			sender->td_maxend = end;
+			sender->td_maxwin = (win == 0 ? 1 : win);
+
+			tcp_options(iph, len, tcph, sender);
+			/* 
+			 * RFC 1323:
+			 * Both sides must send the Window Scale option
+			 * to enable window scaling in either direction.
+			 */
+			if (!(sender->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE
+			      && receiver->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE))
+				sender->td_scale = 
+				receiver->td_scale = 0;
+		} else {
+			/*
+			 * We are in the middle of a connection,
+			 * its history is lost for us.
+			 * Let's try to use the data from the packet.
+		 	 */
+			sender->td_end = end;
+			sender->td_maxwin = (win == 0 ? 1 : win);
+			sender->td_maxend = end + sender->td_maxwin;
+		}
+	} else if (state->state == TCP_CONNTRACK_SYN_SENT
+		   && dir == IP_CT_DIR_ORIGINAL
+		   && after(end, sender->td_end)) {
+		/*
+		 * RFC 793: "if a TCP is reinitialized ... then it need
+		 * not wait at all; it must only be sure to use sequence 
+		 * numbers larger than those recently used."
+		 */
+		sender->td_end =
+		sender->td_maxend = end;
+		sender->td_maxwin = (win == 0 ? 1 : win);
+
+		tcp_options(iph, len, tcph, sender);
+	}
+	
+	if (!(tcph->ack)) {
+		/*
+		 * If there is no ACK, just pretend it was set and OK.
+		 */
+		ack = receiver->td_end;
+	} else if (((tcp_flag_word(tcph) & (TCP_FLAG_ACK|TCP_FLAG_RST)) == (TCP_FLAG_ACK|TCP_FLAG_RST)) 
+		   && (ack == 0)) {
+		/*
+		 * Broken TCP stacks, that set ACK in RST packets as well
+		 * with zero ack value.
+		 */
+		ack = receiver->td_end;
+	}
+
+	if (seq == end)
+		/*
+		 * Packets contains no data: we assume it is valid
+		 * and check the ack value only.
+		 */
+		seq = end = sender->td_end;
+		
+	if (sender->loose)
+		sender->loose--;
+
+	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu seq=%u ack=%u win=%u end=%u trim=%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source), NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, win, end, 
+		after(end, sender->td_maxend) && before(seq, sender->td_maxend) ? sender->td_maxend : end);
+	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin, sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, receiver->td_scale);
+	
+	/* Ignore data over the right edge of the receiver's window. */
+	if (after(end, sender->td_maxend) &&
+	    before(seq, sender->td_maxend)) {
+		end = sender->td_maxend;
+		if (state->stored_seq == TCP_FIN_SET)
+			state->stored_seq = TCP_ACK_SET;
+	}
+	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
+		before(end, sender->td_maxend + 1) 
+			|| before(seq, sender->td_maxend + 1),
+	    	after(seq, sender->td_end - receiver->td_maxwin - 1) 
+	    		|| after(end, sender->td_end - receiver->td_maxwin - 1),
+	    	before(ack, receiver->td_end + 1),
+	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+	
+	if (sender->loose || receiver->loose ||
+	    (before(end, sender->td_maxend + 1) &&
+	     after(seq, sender->td_end - receiver->td_maxwin - 1) &&
+	     before(ack, receiver->td_end + 1) &&
+	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
+	    	/*
+		 * Take into account window scaling (RFC 1323).
+		 */
+		if (!tcph->syn)
+			win <<= sender->td_scale;
+		
+		/*
+		 * Update sender data.
+		 */
+		if (sender->td_maxwin < win)
+			sender->td_maxwin = win;
+		if (after(end, sender->td_end))
+			sender->td_end = end;
+		if (after(ack + win, receiver->td_maxend - 1)) {
+			receiver->td_maxend = ack + win;
+			if (win == 0)
+				receiver->td_maxend++;
+		}
+
+		/* 
+		 * Check retransmissions.
+		 */
+		if (state->stored_seq == TCP_ACK_SET) {
+			if (state->last_dir == dir
+			    && state->last_seq == seq
+			    && state->last_end == end)
+				state->retrans++;
+			else {
+				state->last_dir = dir;
+				state->last_seq = seq;
+				state->last_end = end;
+				state->retrans = 0;
+			}
+		}
+		
+		res = 1;
+	} else {
+/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)iph, len,
+				"ip_conntrack_tcp: IGNORED: Out of window data; %s\n",
+				before(end, sender->td_maxend + 1) ?
+					after(seq, sender->td_end - receiver->td_maxwin - 1) ?
+						before(ack, receiver->td_end + 1) ?
+							after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
+							: "ACK is under the lower bound (possibly overly delayed ACK)"
+						: "ACK is over the upper bound (ACKed data has never seen yet)"
+					: "SEQ is under the lower bound (retransmitted already ACKed data)"
+				: "SEQ is over the upper bound (over the window of the receiver)");*/
+
+		res = ip_ct_tcp_be_liberal && !tcph->rst;
+	}
+
+	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u receiver end=%u maxend=%u maxwin=%u\n",
+		res, sender->td_end, sender->td_maxend, sender->td_maxwin, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
+
+	return res;
+}
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+/* Update sender->td_end after NAT successfully mangled the packet */
+void ip_conntrack_tcp_update(struct sk_buff *skb,
+			     struct ip_conntrack *conntrack, 
+			     int dir)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct tcphdr *tcph = (void *)skb->nh.iph + skb->nh.iph->ihl*4;
+	__u32 end;
+#ifdef DEBUGP_VARS
+	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[dir];
+	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
+#endif
+
+	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, iph, tcph);
+	
+	WRITE_LOCK(&tcp_lock);
+	/*
+	 * We have to worry for the ack in the reply packet only...
+	 */
+	if (after(end, conntrack->proto.tcp.seen[dir].td_end))
+		conntrack->proto.tcp.seen[dir].td_end = end;
+	WRITE_UNLOCK(&tcp_lock);
+	DEBUGP("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin, sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, receiver->td_scale);
+}
+ 
+EXPORT_SYMBOL(ip_conntrack_tcp_update);
+#endif
+
+#define	TH_FIN	0x01
+#define	TH_SYN	0x02
+#define	TH_RST	0x04
+#define	TH_PUSH	0x08
+#define	TH_ACK	0x10
+#define	TH_URG	0x20
+#define	TH_ECE	0x40
+#define	TH_CWR	0x80
+
+/* table of valid flag combinations - ECE and CWR are always valid */
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+{
+	[TH_SYN]			= 1,
+	[TH_SYN|TH_ACK]			= 1,
+	[TH_RST]			= 1,
+	[TH_RST|TH_ACK]			= 1,
+	[TH_RST|TH_ACK|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK]			= 1,
+	[TH_ACK]			= 1,
+	[TH_ACK|TH_PUSH]		= 1,
+	[TH_ACK|TH_URG]			= 1,
+	[TH_ACK|TH_URG|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK|TH_PUSH]		= 1,
+	[TH_FIN|TH_ACK|TH_URG]		= 1,
+	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	= 1,
+};
+
+/* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
+static int unclean(struct iphdr *iph, size_t len)
+{
+	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+	unsigned int tcplen = len - iph->ihl * 4;
+	u_int8_t tcpflags;
+
+	/* Not whole TCP header? */
+	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+		/* if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)iph, len, 
+				  "ip_conntrack_tcp: INVALID: truncated packet ");*/
+		return 1;
+	}
+
+	/* Check TCP flags. */
+	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
+	if (!tcp_valid_flags[tcpflags]) {
+		/*if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)iph, len, 
+				  "ip_conntrack_tcp: INVALID: invalid TCP flag combination ");*/
+		return 1;
+	}
+
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+			 csum_partial((char *)tcph, tcplen, 0))) {
+/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)iph, len, 
+				  "ip_conntrack_tcp: INVALID: bad TCP checksum ");*/
+		return 1;
+	}
+
+	return 0;
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
@@ -172,82 +708,223 @@
 		      const struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
-	enum tcp_conntrack newconntrack, oldtcpstate;
+	enum tcp_conntrack new_state, old_state;
+	enum ip_conntrack_dir dir;
 	struct tcphdr tcph;
+	unsigned long timeout;
+	unsigned int index;
 
+	/* FIXME: does unclean do the same? */
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
 		return -1;
+	
+	/* Do not handle unclean packets, which could cause false alarms */
+	if (unclean(skb->nh.iph, skb->len))
+		return -NF_ACCEPT;
 
 	WRITE_LOCK(&tcp_lock);
-	oldtcpstate = conntrack->proto.tcp.state;
-	newconntrack
-		= tcp_conntracks
-		[CTINFO2DIR(ctinfo)]
-		[get_conntrack_index(&tcph)][oldtcpstate];
-
-	/* Invalid */
-	if (newconntrack == TCP_CONNTRACK_MAX) {
-		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
-		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
-		       conntrack->proto.tcp.state);
+	old_state = conntrack->proto.tcp.state;
+	dir = CTINFO2DIR(ctinfo);
+	index = get_conntrack_index(&tcph);
+	new_state = tcp_conntracks[dir][index][old_state];
+
+	switch (new_state) {
+	case TCP_CONNTRACK_IGNORE:
+		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
+		if (index == TCP_SYNACK_SET
+		    && conntrack->proto.tcp.stored_seq == TCP_SYN_SET
+		    && conntrack->proto.tcp.last_dir != dir
+		    && after(ntohl(tcph.ack_seq), conntrack->proto.tcp.last_seq)) {
+			/* This SYN/ACK acknowledges a SYN that we earlier ignored 
+			 * as invalid. This means that the client and the server 
+			 * are both in sync, while the firewall is not. We kill 
+			 * this session and block the SYN/ACK so that the client 
+			 * cannot but retransmit its SYN and thus initiate a 
+			 * clean new session.
+			 */
+		    	WRITE_UNLOCK(&tcp_lock);
+		/*	if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+				nf_log_ip((char *)skb->nh.iph, skb->len, 
+					  "ip_conntrack_tcp: INVALID: killing out of sync session ");*/
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)conntrack);
+		    	return -NF_ACCEPT;
+		}
+		conntrack->proto.tcp.stored_seq = index;
+		conntrack->proto.tcp.last_dir = dir;
+		conntrack->proto.tcp.last_seq = ntohl(tcph.seq);
+		
 		WRITE_UNLOCK(&tcp_lock);
-		return -1;
-	}
-
-	conntrack->proto.tcp.state = newconntrack;
-
-	/* Poor man's window tracking: record SYN/ACK for handshake check */
-	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
-	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-	    && tcph.syn && tcph.ack)
-		conntrack->proto.tcp.handshake_ack
-			= htonl(ntohl(tcph.seq) + 1);
-
-	/* If only reply is a RST, we can consider ourselves not to
-	   have an established connection: this is a fairly common
-	   problem case, so we can delete the conntrack
-	   immediately.  --RR */
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
+/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)skb->nh.iph, skb->len, 
+				  "ip_conntrack_tcp: INVALID: invalid SYN (ignored) ");*/
+		return NF_ACCEPT;
+		break;
+	case TCP_CONNTRACK_MAX:
+		/* Invalid packet */
+ 		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
+		       dir, get_conntrack_index(&tcph),
+		       old_state);
 		WRITE_UNLOCK(&tcp_lock);
-		if (del_timer(&conntrack->timeout))
-			conntrack->timeout.function((unsigned long)conntrack);
-	} else {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
-		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
-		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
-		    && tcph.ack && !tcph.syn
-		    && tcph.ack_seq == conntrack->proto.tcp.handshake_ack)
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 
+/*		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log_ip((char *)skb->nh.iph, skb->len, 
+				  "ip_conntrack_tcp: INVALID: invalid state ");*/
+		return -NF_ACCEPT;
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state >= TCP_CONNTRACK_TIME_WAIT) { 
+		    	/* Attempt to reopen a closed connection.
+		    	 * Delete this connection and look up again. */
+		    	WRITE_UNLOCK(&tcp_lock);
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)conntrack);
+		    	return -NF_REPEAT;
+		}
+		break;
+	case TCP_CONNTRACK_CLOSE:
+		if (index == TCP_RST_SET
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && conntrack->proto.tcp.stored_seq <= TCP_SYNACK_SET
+		    && after(ntohl(tcph.ack), conntrack->proto.tcp.last_seq)) {
+			/* Ignore RST closing down invalid SYN we had let trough. */ 
+		    	WRITE_UNLOCK(&tcp_lock);
+/*			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+				nf_log_ip((char *)skb->nh.iph, skb->len, 
+					  "ip_conntrack_tcp: INVALID: invalid RST (ignored) ");*/
+			return NF_ACCEPT;
+		}
+		/* Just fall trough */
+	default:
+		/* Keep compilers happy. */
+	}
+
+	conntrack->proto.tcp.stored_seq = index;
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, skb->nh.iph, skb->len, &tcph)) {
+		/* Invalid packet */
 		WRITE_UNLOCK(&tcp_lock);
-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
+		return -NF_ACCEPT;
 	}
+	/* If FIN was trimmed off, don't change state. */
+	new_state = tcp_conntracks[dir][conntrack->proto.tcp.stored_seq][old_state];
+	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
+		NIPQUAD(iph->saddr), ntohs(tcph.source), NIPQUAD(iph->daddr), ntohs(tcph.dest),
+		(tcph.syn ? 1 : 0), (tcph.ack ? 1 : 0), (tcph.fin ? 1 : 0), (tcph.rst ? 1 : 0),
+		old_state, new_state);
+
+	conntrack->proto.tcp.state = new_state;
+	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
+		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans ?
+		  ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+		/* If only reply is a RST, we can consider ourselves not to
+		   have an established connection: this is a fairly common
+		   problem case, so we can delete the conntrack
+		   immediately.  --RR */
+		if (tcph.rst) {
+			WRITE_UNLOCK(&tcp_lock);
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)conntrack);
+			return NF_ACCEPT;
+		} else {
+			/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV 
+			   or a valid answer for a picked up connection. */
+			if ((old_state == TCP_CONNTRACK_SYN_RECV
+			     || old_state == TCP_CONNTRACK_ESTABLISHED)
+			    && new_state == TCP_CONNTRACK_ESTABLISHED)
+				set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		}
+ 	}
+	WRITE_UNLOCK(&tcp_lock);
+	ip_ct_refresh(conntrack, timeout);
 
-	return NF_ACCEPT;
+ 	return NF_ACCEPT;
 }
 
+	
 /* Called when a new connection for this protocol found. */
 static int tcp_new(struct ip_conntrack *conntrack, const struct sk_buff *skb)
 {
-	enum tcp_conntrack newconntrack;
+	enum tcp_conntrack new_state;
 	struct tcphdr tcph;
 
+#ifdef DEBUGP_VARS
+	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
+	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
+#endif
+
+	/* FIXME: do the same as unclean does? Anyway I needed */
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 0)
 		return -1;
 
+	/* Skip unclean packets */
+	if (unclean(skb->nh.iph, skb->len))
+		return 0;
+
 	/* Don't need lock here: this conntrack not in circulation yet */
-	newconntrack
+	new_state
 		= tcp_conntracks[0][get_conntrack_index(&tcph)]
 		[TCP_CONNTRACK_NONE];
 
 	/* Invalid: delete conntrack */
-	if (newconntrack == TCP_CONNTRACK_MAX) {
+	if (new_state >= TCP_CONNTRACK_MAX) {
 		DEBUGP("ip_conntrack_tcp: invalid new deleting.\n");
 		return 0;
 	}
 
-	conntrack->proto.tcp.state = newconntrack;
-	return 1;
+	if (new_state == TCP_CONNTRACK_SYN_SENT) {
+		/* SYN packet */
+		conntrack->proto.tcp.seen[0].td_end =
+			segment_seq_plus_len(ntohl(tcph.seq), skb->len, skb->nh.iph, &tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+			conntrack->proto.tcp.seen[0].td_maxwin = 1;
+		conntrack->proto.tcp.seen[0].td_maxend =
+			conntrack->proto.tcp.seen[0].td_end;
+
+		tcp_options(skb->nh.iph, skb->len, &tcph, &conntrack->proto.tcp.seen[0]);
+		conntrack->proto.tcp.seen[1].flags = 0;
+		conntrack->proto.tcp.seen[0].loose = 
+		conntrack->proto.tcp.seen[1].loose = 0;
+	} else if (ip_ct_tcp_loose == 0) {
+		/* Don't try to pick up connections. */
+		return 0;
+	} else {
+		/*
+		 * We are in the middle of a connection,
+		 * its history is lost for us.
+		 * Let's try to use the data from the packet.
+		 */
+		conntrack->proto.tcp.seen[0].td_end =
+			segment_seq_plus_len(ntohl(tcph.seq), skb->len, skb->nh.iph, &tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph.window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+			conntrack->proto.tcp.seen[0].td_maxwin = 1;
+		conntrack->proto.tcp.seen[0].td_maxend =
+			conntrack->proto.tcp.seen[0].td_end + 
+			conntrack->proto.tcp.seen[0].td_maxwin;
+		conntrack->proto.tcp.seen[0].td_scale = 0;
+
+		/* Should we assume window scaling? */
+		conntrack->proto.tcp.seen[0].flags =
+		conntrack->proto.tcp.seen[1].flags = 0;
+		conntrack->proto.tcp.seen[0].loose = 
+		conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+	}
+   
+	conntrack->proto.tcp.seen[1].td_end = 0;
+	conntrack->proto.tcp.seen[1].td_maxend = 0;
+	conntrack->proto.tcp.seen[1].td_maxwin = 1;
+	conntrack->proto.tcp.seen[1].td_scale = 0;      
+
+	/* tcp_packet will set them */
+	conntrack->proto.tcp.state = TCP_CONNTRACK_NONE;
+	conntrack->proto.tcp.stored_seq = TCP_NONE_SET;
+ 
+	DEBUGP("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin, sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, receiver->td_scale);
+ 	return 1;
 }
 
 static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18 04:57:46.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-07 19:12:08.000000000 +0100
@@ -285,6 +285,11 @@
 extern unsigned long ip_ct_tcp_timeout_last_ack;
 extern unsigned long ip_ct_tcp_timeout_time_wait;
 extern unsigned long ip_ct_tcp_timeout_close;
+extern unsigned long ip_ct_tcp_timeout_max_retrans;
+extern int ip_ct_tcp_log_invalid;
+extern int ip_ct_tcp_loose;
+extern int ip_ct_tcp_be_liberal;
+extern int ip_ct_tcp_max_retrans;
 
 /* From ip_conntrack_proto_udp.c */
 extern unsigned long ip_ct_udp_timeout;
@@ -338,6 +343,21 @@
 	{NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT, "ip_conntrack_generic_timeout",
 	 &ip_ct_generic_timeout, sizeof(unsigned int), 0644, NULL,
 	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS, "ip_conntrack_tcp_timeout_max_retrans",
+	 &ip_ct_tcp_timeout_max_retrans, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec_jiffies},
+	{NET_IPV4_NF_CONNTRACK_TCP_LOG_INVALID, "ip_conntrack_tcp_log_invalid",
+	 &ip_ct_tcp_log_invalid, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_TCP_LOOSE, "ip_conntrack_tcp_loose",
+	 &ip_ct_tcp_loose, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL, "ip_conntrack_tcp_be_liberal",
+	 &ip_ct_tcp_be_liberal, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS, "ip_conntrack_tcp_max_retrans",
+	 &ip_ct_tcp_max_retrans, sizeof(unsigned int), 0644, NULL,
+	 &proc_dointvec},
 	{0}
 };
 
--- linux-2.6.3-old/net/ipv4/netfilter/ip_nat_helper.c	2004-02-18 04:57:17.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_nat_helper.c	2004-03-07 20:07:27.000000000 +0100
@@ -353,8 +353,8 @@
 		  enum ip_conntrack_info ctinfo)
 {
 	struct tcphdr *tcph;
-	int dir, newseq, newack;
-	struct ip_nat_seq *this_way, *other_way;	
+	int dir, newseq, newack, ret;
+	struct ip_nat_seq *this_way, *other_way;
 
 	dir = CTINFO2DIR(ctinfo);
 
@@ -395,7 +395,11 @@
 	tcph->seq = newseq;
 	tcph->ack_seq = newack;
 
-	return ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
+	ret = ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
+
+	ip_conntrack_tcp_update(*pskb, ct, dir);
+
+	return ret;
 }
 
 static inline int

--------------000509060703020105070800--
