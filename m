From: Roberto Nibali <ratz@tac.ch>
Subject: {Spam?} [PATCH 2.4] TCP window tracking: core implementation
Date: Mon, 21 Nov 2005 11:16:18 +0100
Message-ID: <43819E72.5060704@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090808060703040907060301"
Cc: Willy Tarreau <willy@w.ods.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------090808060703040907060301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

This is the core tcp window tracking patch, updated for 2.4.32 and
enhanced with some 2.6.x fixes in the tcp state verifier. Notably the
following two flag combinations are allowed as well:

TCP_SYN|TCP_PSH
TCP_SYN|TCP_ACK|TCP_PSH

NOTE: This is the work of the excellent netfilter hacker Jozsef
Kadlecsik, so all credit goes to him for the 2.4.x implementation. I
just rediffed and backported some minor things from 2.6.x.

A former version of this patch has been in production on a dozen nodes
for about 8 months now, and besides unmotivated DROPs invoked by
"non-RFC-comformant" applications, it works reasonably well. The added
TCP flag combinations in this patch should resolve most of the observed
issues we've gathered from various customers over the past half year.

We'd hoped to overcome remaining "broken" applications by using the
NOTRACK flag to a filter rule. This would allow one to have a general
stateful packet filter with a few stateless rules for "broken"
applications; a feature most commercial firewall suites don't offer.
Unfortunately there is still an issue with regard to SMP and rmmod'ing
ip_conntrack while having NOTRACK rules loaded and network traffic
hitting NOTRACK and conntrack. Otherwise it works flawlessly. Patch will
follow shortly.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------

--------------090808060703040907060301
Content-Type: text/plain;
 name="linux-2.4.32-tcp-window-tracking-3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linux-2.4.32-tcp-window-tracking-3.diff"

diff -X dontdiff -Nur linux-2.4.32-orig/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.32-pab2/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.32-orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-11-16 20:12:54 +0100
+++ linux-2.4.32-pab2/include/linux/netfilter_ipv4/ip_conntrack.h	2005-11-21 10:41:19 +0100
@@ -246,6 +246,11 @@
 			  unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
+/* Update TCP window tracking data after NAT successfully mangled the packet */
+extern int ip_conntrack_tcp_update(struct sk_buff *skb,
+				   struct ip_conntrack *conntrack, 
+				   int dir);
+
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
 
diff -X dontdiff -Nur linux-2.4.32-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.4.32-pab2/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- linux-2.4.32-orig/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2002-11-29 00:53:15 +0100
+++ linux-2.4.32-pab2/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-11-21 10:41:19 +0100
@@ -4,25 +4,47 @@
 
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
+#define IP_CT_TCP_FLAG_WINDOW_SCALE		0x01
+
+/* SACK is permitted by the sender */
+#define IP_CT_TCP_FLAG_SACK_PERM		0x02
+
+/* This sender sent FIN first */
+#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
+
+struct ip_ct_tcp_state {
+	u_int32_t	td_end;		/* max of seq + len */
+	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
+	u_int32_t	td_maxwin;	/* max(win) */
+	u_int8_t	td_scale;	/* window scale factor */
+	u_int8_t	loose;		/* used when connection picked up from the middle */
+	u_int8_t	flags;		/* per direction options */
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
+	u_int8_t	last_index;	/* Index of the last packet */
+	u_int32_t	last_seq;	/* Last sequence number seen in dir */
+	u_int32_t	last_end;	/* Last seq + len */
 };
 
 #endif /* _IP_CONNTRACK_TCP_H */
diff -X dontdiff -Nur linux-2.4.32-orig/include/linux/sysctl.h linux-2.4.32-pab2/include/linux/sysctl.h
--- linux-2.4.32-orig/include/linux/sysctl.h	2005-04-04 03:42:20 +0200
+++ linux-2.4.32-pab2/include/linux/sysctl.h	2005-11-21 10:41:19 +0100
@@ -396,6 +396,11 @@
 	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
 	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
 	NET_IPV4_NF_CONNTRACK_BUCKETS=14,
+	NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS=15,
+	NET_IPV4_NF_CONNTRACK_TCP_LOG_INVALID=16,
+	NET_IPV4_NF_CONNTRACK_TCP_LOOSE=17,
+	NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL=18,
+	NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS=19,
 };
  
 /* /proc/sys/net/ipv6 */
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/Makefile linux-2.4.32-pab2/net/ipv4/netfilter/Makefile
--- linux-2.4.32-orig/net/ipv4/netfilter/Makefile	2003-08-25 13:44:44 +0200
+++ linux-2.4.32-pab2/net/ipv4/netfilter/Makefile	2005-11-21 10:41:19 +0100
@@ -31,6 +31,10 @@
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
 
+ifdef CONFIG_IP_NF_NAT_NEEDED
+	export-objs += ip_conntrack_proto_tcp.o
+endif
+
 # connection tracking helpers
 obj-$(CONFIG_IP_NF_AMANDA) += ip_conntrack_amanda.o
 ifdef CONFIG_IP_NF_AMANDA
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-04-04 03:42:20 +0200
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_core.c	2005-11-21 10:41:19 +0100
@@ -874,11 +874,12 @@
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
-	if (ret == -1) {
-		/* Invalid */
+	if (ret < 0 ) {
+		/* Invalid: inverse of the return code tells
+		 * to the netfilter core what to do. */
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		return NF_ACCEPT;
+		return -ret;
 	}
 
 	if (ret != NF_DROP && ct->helper) {
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_ftp.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-11-17 12:54:22 +0100
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-11-21 10:41:19 +0100
@@ -4,7 +4,6 @@
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <linux/ctype.h>
-#include <net/checksum.h>
 #include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/lockhelp.h>
@@ -233,11 +232,10 @@
 		struct ip_conntrack *ct,
 		enum ip_conntrack_info ctinfo)
 {
-	/* tcplen not negative guaranteed by ip_conntrack_tcp.c */
+	/* datalen not negative guaranteed by ip_conntrack_proto_tcp.c */
 	struct tcphdr *tcph = (void *)iph + iph->ihl * 4;
 	const char *data = (const char *)tcph + tcph->doff * 4;
-	unsigned int tcplen = len - iph->ihl * 4;
-	unsigned int datalen = tcplen - tcph->doff * 4;
+	unsigned int datalen = len - iph->ihl * 4 - tcph->doff * 4;
 	u_int32_t old_seq_aft_nl;
 	int old_seq_aft_nl_set;
 	u_int32_t array[6] = { 0 };
@@ -257,22 +255,6 @@
 		return NF_ACCEPT;
 	}
 
-	/* Not whole TCP header? */
-	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
-		DEBUGP("ftp: tcplen = %u\n", (unsigned)tcplen);
-		return NF_ACCEPT;
-	}
-
-	/* Checksum invalid?  Ignore. */
-	/* FIXME: Source route IP option packets --RR */
-	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-			 csum_partial((char *)tcph, tcplen, 0))) {
-		DEBUGP("ftp_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
-		       tcph, tcplen, NIPQUAD(iph->saddr),
-		       NIPQUAD(iph->daddr));
-		return NF_ACCEPT;
-	}
-
 	LOCK_BH(&ip_ftp_lock);
 	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
 	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_irc.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_irc.c	2004-11-17 12:54:22 +0100
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_irc.c	2005-11-21 10:41:19 +0100
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
-#include <net/checksum.h>
 #include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -107,13 +106,12 @@
 static int help(const struct iphdr *iph, size_t len,
 		struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
-	/* tcplen not negative guarenteed by ip_conntrack_tcp.c */
+	/* datalen not negative guarenteed by ip_conntrack_proto_tcp.c */
 	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
 	const char *data = (const char *) tcph + tcph->doff * 4;
 	const char *_data = data;
 	char *data_limit;
-	u_int32_t tcplen = len - iph->ihl * 4;
-	u_int32_t datalen = tcplen - tcph->doff * 4;
+	u_int32_t datalen = len - iph->ihl * 4 - tcph->doff * 4;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_conntrack_expect expect, *exp = &expect;
 	struct ip_ct_irc_expect *exp_irc_info = &exp->help.exp_irc_info;
@@ -136,22 +134,6 @@
 		return NF_ACCEPT;
 	}
 
-	/* Not whole TCP header? */
-	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4) {
-		DEBUGP("tcplen = %u\n", (unsigned) tcplen);
-		return NF_ACCEPT;
-	}
-
-	/* Checksum invalid?  Ignore. */
-	/* FIXME: Source route IP option packets --RR */
-	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-			 csum_partial((char *) tcph, tcplen, 0))) {
-		DEBUGP("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
-		     tcph, tcplen, NIPQUAD(iph->saddr),
-		     NIPQUAD(iph->daddr));
-		return NF_ACCEPT;
-	}
-
 	data_limit = (char *) data + datalen;
 
 	/* strlen("\1DCC SEND t AAAAAAAA P\1\n")=24
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2003-11-28 19:26:21 +0100
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-11-21 10:49:06 +0100
@@ -1,3 +1,25 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
+ *	- Real stateful connection tracking
+ *	- Modified state transitions table
+ *	- Window scaling support added
+ *	- SACK support added
+ *
+ * Willy Tarreau:
+ *	- State table bugfixes
+ *	- More robust state changes
+ *	- Tuning timer parameters
+ *
+ * version 2.2
+ */
+
+#include <linux/config.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -6,45 +28,66 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/string.h>
+#include <linux/spinlock.h>
 
 #include <net/tcp.h>
 
+#include <linux/netfilter.h>
+#include <linux/netfilter_logging.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
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
 
-/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR */
+/* Log invalid/ignored packets */
+int ip_ct_tcp_log_invalid = 0;
+
+/* "Be conservative in what you do, 
+    be liberal in what you accept from others." 
+    If it's non-zero, we mark only out of window RST segments as INVALID. */
+int ip_ct_tcp_be_liberal = 0;
+
+/* When connection is picked up from the middle, how many packets are required
+   to pass in each direction when we assume we are in sync - if any side uses
+   window scaling, we lost the game. 
+   If it is set to zero, we disable picking up already established 
+   connections. */
+int ip_ct_tcp_loose = 3;
+
+/* Max number of the retransmitted packets without receiving an (acceptable) 
+   ACK from the destination. If this number is reached, a shorter timer 
+   will be started. */
+int ip_ct_tcp_max_retrans = 3;
 
-/* Actually, I believe that neither ipmasq (where this code is stolen
-   from) nor ipfilter do it exactly right.  A new conntrack machine taking
-   into account packet loss (which creates uncertainty as to exactly
-   the conntrack of the connection) is required.  RSN.  --RR */
+  /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
+     closely.  They're more complex. --RR */
 
 static const char *tcp_conntrack_names[] = {
 	"NONE",
-	"ESTABLISHED",
 	"SYN_SENT",
 	"SYN_RECV",
+	"ESTABLISHED",
 	"FIN_WAIT",
-	"TIME_WAIT",
-	"CLOSE",
 	"CLOSE_WAIT",
 	"LAST_ACK",
+	"TIME_WAIT",
+	"CLOSE",
 	"LISTEN"
 };
-
-#define SECS *HZ
+  
+#define SECS * HZ
 #define MINS * 60 SECS
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
@@ -58,50 +101,199 @@
 unsigned long ip_ct_tcp_timeout_time_wait =     2 MINS;
 unsigned long ip_ct_tcp_timeout_close =        10 SECS;
 
+/* RFC1122 says the R2 limit should be at least 100 seconds.
+   Linux uses 15 packets as limit, which corresponds 
+   to ~13-30min depending on RTO. */
+unsigned long ip_ct_tcp_timeout_max_retrans =     5 MINS;
+ 
 static unsigned long * tcp_timeouts[]
-= { 0,                                 /*      TCP_CONNTRACK_NONE */
-    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED,      */
+= { NULL,                              /*      TCP_CONNTRACK_NONE */
     &ip_ct_tcp_timeout_syn_sent,       /*      TCP_CONNTRACK_SYN_SENT, */
     &ip_ct_tcp_timeout_syn_recv,       /*      TCP_CONNTRACK_SYN_RECV, */
+    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED,      */
     &ip_ct_tcp_timeout_fin_wait,       /*      TCP_CONNTRACK_FIN_WAIT, */
-    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,        */
-    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
     &ip_ct_tcp_timeout_close_wait,     /*      TCP_CONNTRACK_CLOSE_WAIT,       */
     &ip_ct_tcp_timeout_last_ack,       /*      TCP_CONNTRACK_LAST_ACK, */
-    0,                                 /*      TCP_CONNTRACK_LISTEN */
+    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,        */
+    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
+    NULL,                              /*      TCP_CONNTRACK_LISTEN */
  };
  
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
 	{
-/*	REPLY */
-/* 	  sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI 	*/
-/*syn*/	{sSR, sES, sSR, sSR, sSR, sSR, sSR, sSR, sSR, sSR },
-/*fin*/	{sCL, sCW, sSS, sTW, sTW, sTW, sCL, sCW, sLA, sLI },
-/*ack*/	{sCL, sES, sSS, sSR, sFW, sTW, sCL, sCW, sCL, sLI },
-/*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
-/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
-	}
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
+ *	sFW -> sIG	Might be SYN/ACK answering ignored SYN
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
+/*ack*/	   { sIV, sIV, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*
+ *	sSS -> sIV	Might be a half-open connection.
+ *	sSR -> sSR	Might answer late resent SYN.
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
+  	}
 };
 
 static int tcp_pkt_to_tuple(const void *datah, size_t datalen,
@@ -147,11 +339,486 @@
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 {
-	if (tcph->rst) return 3;
-	else if (tcph->syn) return 0;
-	else if (tcph->fin) return 1;
-	else if (tcph->ack) return 2;
-	else return 4;
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
+   The boundaries and the conditions are changed according to RFC793:
+   the packet must intersect the window (i.e. segments may be
+   after the right or before the left edge) and thus receivers may ACK
+   segments after the right edge of the window.
+
+   	td_maxend = max(sack + max(win,1)) seen in reply packets
+	td_maxwin = max(max(win, 1)) + (sack - ack) seen in sent packets
+	td_maxwin += seq + len - sender.td_maxend
+			if seq + len > sender.td_maxend
+	td_end    = max(seq + len) seen in sent packets
+   
+   I.   Upper bound for valid data:	seq <= sender.td_maxend
+   II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
+   III.	Upper bound for valid ack:      sack <= receiver.td_end
+   IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
+   	
+   where sack is the highest right edge of sack block found in the packet.
+   	
+   The upper bound limit for a valid ack is not ignored - 
+   we doesn't have to deal with fragments. 
+*/
+
+static inline __u32 segment_seq_plus_len(__u32 seq,
+					 size_t len,
+					 struct iphdr *iph,
+					 struct tcphdr *tcph)
+{
+	return (seq + len - (iph->ihl + tcph->doff)*4
+		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
+}
+  
+/* Fixme: what about big packets? */
+#define MAXACKWINCONST			66000
+#define MAXACKWINDOW(sender)						\
+	((sender)->td_maxwin > MAXACKWINCONST ? (sender)->td_maxwin	\
+					      : MAXACKWINCONST)
+  
+/*
+ * Simplified tcp_parse_options routine from tcp_input.c
+ */
+static void tcp_options(struct tcphdr *tcph, 
+			struct ip_ct_tcp_state *state)
+{
+	unsigned char *ptr;
+	int length = (tcph->doff*4) - sizeof(struct tcphdr);
+	
+	if (!length)
+		return;
+
+	ptr = (unsigned char *)(tcph + 1);
+
+	state->td_scale = 
+	state->flags = 0;
+	
+	while (length > 0) {
+		int opcode=*ptr++;
+		int opsize;
+		
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			opsize=*ptr++;
+			if (opsize < 2) /* "silly options" */
+				return;
+			if (opsize > length)
+				break;	/* don't parse partial options */
+
+			if (opcode == TCPOPT_SACK_PERM 
+			    && opsize == TCPOLEN_SACK_PERM)
+				state->flags |= IP_CT_TCP_FLAG_SACK_PERM;
+			else if (opcode == TCPOPT_WINDOW
+				 && opsize == TCPOLEN_WINDOW) {
+				state->td_scale = *(u_int8_t *)ptr;
+				
+				if (state->td_scale > 14) {
+					/* See RFC1323 */
+					state->td_scale = 14;
+				}
+				state->flags |=
+					IP_CT_TCP_FLAG_WINDOW_SCALE;
+			}
+			ptr += opsize - 2;
+			length -= opsize;
+		}
+	}
+}
+
+static void tcp_sack(struct tcphdr *tcph,
+		     __u32 *sack)
+{
+	unsigned char *ptr;
+	int length = (tcph->doff*4) - sizeof(struct tcphdr);
+	__u32 tmp;
+
+	if (!length)
+		return;
+
+	ptr = (unsigned char *)(tcph + 1);
+	/* Fast path for timestamp-only option */
+	if (length == TCPOLEN_TSTAMP_ALIGNED*4
+	    && *(__u32 *)ptr ==
+	        __constant_ntohl((TCPOPT_NOP << 24) 
+	        		 | (TCPOPT_NOP << 16)
+	        		 | (TCPOPT_TIMESTAMP << 8)
+	        		 | TCPOLEN_TIMESTAMP))
+		return;
+		
+	while (length > 0) {
+		int opcode=*ptr++;
+		int opsize, i;
+		
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			opsize=*ptr++;
+			if (opsize < 2) /* "silly options" */
+				return;
+			if (opsize > length)
+				break;	/* don't parse partial options */
+
+			if (opcode == TCPOPT_SACK 
+			    && opsize >= (TCPOLEN_SACK_BASE 
+			    		  + TCPOLEN_SACK_PERBLOCK)
+			    && !((opsize - TCPOLEN_SACK_BASE) 
+			    	 % TCPOLEN_SACK_PERBLOCK)) {
+			    	for (i = 0;
+			    	     i < (opsize - TCPOLEN_SACK_BASE);
+			    	     i += TCPOLEN_SACK_PERBLOCK) {
+					tmp = ntohl(*((u_int32_t *)(ptr+i)+1));
+					
+					if (after(tmp, *sack))
+						*sack = tmp;
+				}
+				return;
+			}
+			ptr += opsize - 2;
+			length -= opsize;
+		}
+	}
+}
+
+static int tcp_in_window(struct ip_ct_tcp *state, 
+                         enum ip_conntrack_dir dir,
+                         unsigned int index,
+                         struct iphdr *iph, size_t len,
+                         struct tcphdr *tcph)
+{
+	struct ip_ct_tcp_state *sender = &state->seen[dir];
+	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
+	__u32 seq, ack, sack, end, win, swin;
+	int res;
+	
+	/*
+	 * Get the required data from the packet.
+	 */
+	seq = ntohl(tcph->seq);
+	ack = sack = ntohl(tcph->ack_seq);
+	win = ntohs(tcph->window);
+	end = segment_seq_plus_len(seq, len, iph, tcph);
+	
+	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
+		tcp_sack(tcph, &sack);
+		
+	DEBUGP("tcp_in_window: START\n");
+	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
+	       "seq=%u ack=%u sack=%u win=%u end=%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source), 
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, sack, win, end);
+	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin, 
+		receiver->td_scale);
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
+			tcp_options(tcph, sender);
+			/* 
+			 * RFC 1323:
+			 * Both sides must send the Window Scale option
+			 * to enable window scaling in either direction.
+			 */
+			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
+			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
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
+	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
+		     && dir == IP_CT_DIR_ORIGINAL)
+		    || (state->state == TCP_CONNTRACK_SYN_RECV
+		        && dir == IP_CT_DIR_REPLY))
+		    && after(end, sender->td_end)) {
+		/*
+		 * RFC 793: "if a TCP is reinitialized ... then it need
+		 * not wait at all; it must only be sure to use sequence 
+		 * numbers larger than those recently used."
+		 */
+		sender->td_end =
+		sender->td_maxend = end;
+		sender->td_maxwin = (win == 0 ? 1 : win);
+
+		tcp_options(tcph, sender);
+	}
+	
+	if (!(tcph->ack)) {
+		/*
+		 * If there is no ACK, just pretend it was set and OK.
+		 */
+		ack = sack = receiver->td_end;
+	} else if (((tcp_flag_word(tcph) & (TCP_FLAG_ACK|TCP_FLAG_RST)) == 
+		    (TCP_FLAG_ACK|TCP_FLAG_RST)) 
+		   && (ack == 0)) {
+		/*
+		 * Broken TCP stacks, that set ACK in RST packets as well
+		 * with zero ack value.
+		 */
+		ack = sack = receiver->td_end;
+	}
+
+	if (seq == end
+	    && (!tcph->rst 
+	        || (seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)))
+		/*
+		 * Packets contains no data: we assume it is valid
+		 * and check the ack value only.
+		 * However RST segments are always validated by their
+		 * SEQ number, except when seq == 0 (reset sent answering
+		 * SYN.
+		 */
+		seq = end = sender->td_end;
+		
+	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
+	       "seq=%u ack=%u sack =%u win=%u end=%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, sack, win, end);
+	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
+	
+	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
+		before(seq, sender->td_maxend + 1),
+	    	after(end, sender->td_end - receiver->td_maxwin - 1),
+	    	before(sack, receiver->td_end + 1),
+	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+	
+	if (sender->loose || receiver->loose ||
+	    (before(seq, sender->td_maxend + 1) &&
+	     after(end, sender->td_end - receiver->td_maxwin - 1) &&
+	     before(sack, receiver->td_end + 1) &&
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
+		swin = win + (sack - ack);
+		if (sender->td_maxwin < swin)
+			sender->td_maxwin = swin;
+		if (after(end, sender->td_end))
+			sender->td_end = end;
+		/*
+		 * Update receiver data.
+		 */
+		if (after(end, sender->td_maxend))
+			receiver->td_maxwin += end - sender->td_maxend;
+		if (after(sack + win, receiver->td_maxend - 1)) {
+			receiver->td_maxend = sack + win;
+			if (win == 0)
+				receiver->td_maxend++;
+		}
+
+		/* 
+		 * Check retransmissions.
+		 */
+		if (index == TCP_ACK_SET) {
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
+		/*
+		 * Close the window of disabled window tracking :-)
+		 */
+		if (sender->loose)
+			sender->loose--;
+		
+		res = 1;
+	} else {
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len,
+			"ip_ct_tcp: %s ",
+			before(seq, sender->td_maxend + 1) ?
+			after(end, sender->td_end - receiver->td_maxwin - 1) ?
+			before(sack, receiver->td_end + 1) ?
+			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
+			: "ACK is under the lower bound (possible overly delayed ACK)"
+			: "ACK is over the upper bound (ACKed data not seen yet)"
+			: "SEQ is under the lower bound (already ACKed data retransmitted)"
+			: "SEQ is over the upper bound (over the window of the receiver)");
+
+		res = ip_ct_tcp_be_liberal;
+  	}
+  
+	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
+	       "receiver end=%u maxend=%u maxwin=%u\n",
+		res, sender->td_end, sender->td_maxend, sender->td_maxwin, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
+
+	return res;
+}
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+/* Update sender->td_end after NAT successfully mangled the packet */
+int ip_conntrack_tcp_update(struct sk_buff *skb,
+			    struct ip_conntrack *conntrack, 
+			    int dir)
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
+	conntrack->proto.tcp.last_end = end;
+	WRITE_UNLOCK(&tcp_lock);
+	DEBUGP("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
+	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
+		
+	return 1;
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
+	[TH_SYN|TH_PUSH] 		= 1,
+	[TH_SYN|TH_ACK|TH_PUSH] 	= 1,
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
+static int tcp_error(struct iphdr *iph, size_t len)
+{
+	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+	unsigned int tcplen = len - iph->ihl * 4;
+	u_int8_t tcpflags;
+
+	/* Smaller that minimal TCP header? Should be always false. */
+	if (len < iph->ihl * 4 + sizeof(struct tcphdr)) {
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: short packet ");
+		return -NF_ACCEPT;
+  	}
+  
+	/* Not whole TCP header or malformed packet */
+	if (tcph->doff*4 < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: truncated/malformed packet ");
+		return -NF_ACCEPT;
+	}
+  
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the semantic of CHECKSUM_HW is different there 
+	 * and moreover root might send raw packets.
+	 */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+			 csum_partial((char *)tcph, tcplen, 0))) {
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: bad TCP checksum ");
+		return -NF_ACCEPT;
+	}
+
+	/* Check TCP flags. */
+	tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
+	if (!tcp_valid_flags[tcpflags]) {
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: invalid TCP flag combination ");
+		return -NF_ACCEPT;
+	}
+
+	return NF_ACCEPT;
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
@@ -159,90 +826,248 @@
 		      struct iphdr *iph, size_t len,
 		      enum ip_conntrack_info ctinfo)
 {
-	enum tcp_conntrack newconntrack, oldtcpstate;
+	enum tcp_conntrack new_state, old_state;
+	enum ip_conntrack_dir dir;
 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
-
-	/* We're guaranteed to have the base header, but maybe not the
-           options. */
-	if (len < (iph->ihl + tcph->doff) * 4) {
-		DEBUGP("ip_conntrack_tcp: Truncated packet.\n");
-		return -1;
-	}
-
+	unsigned long timeout;
+	unsigned int index;
+	
+	/* Do not handle unclean packets, which could cause false alarms. */
+	if (tcp_error(iph, len) != NF_ACCEPT)
+		return -NF_ACCEPT;
+	
 	WRITE_LOCK(&tcp_lock);
-	oldtcpstate = conntrack->proto.tcp.state;
-	newconntrack
-		= tcp_conntracks
-		[CTINFO2DIR(ctinfo)]
-		[get_conntrack_index(tcph)][oldtcpstate];
-
-	/* Invalid */
-	if (newconntrack == TCP_CONNTRACK_MAX) {
-		DEBUGP("ip_conntrack_tcp: Invalid dir=%i index=%u conntrack=%u\n",
-		       CTINFO2DIR(ctinfo), get_conntrack_index(tcph),
-		       conntrack->proto.tcp.state);
+	old_state = conntrack->proto.tcp.state;
+	dir = CTINFO2DIR(ctinfo);
+	index = get_conntrack_index(tcph);
+	new_state = tcp_conntracks[dir][index][old_state];
+
+	switch (new_state) {
+	case TCP_CONNTRACK_IGNORE:
+		/* Either SYN in ORIGINAL
+		 * or SYN/ACK in REPLY. */
+		if (index == TCP_SYNACK_SET
+		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
+		    && conntrack->proto.tcp.last_dir != dir
+		    && ntohl(tcph->ack_seq) ==
+		    	     conntrack->proto.tcp.last_end) {
+			/* This SYN/ACK acknowledges a SYN that we earlier 
+			 * ignored as invalid. This means that the client and
+			 * the server are both in sync, while the firewall is
+			 * not. We kill this session and block the SYN/ACK so
+			 * that the client cannot but retransmit its SYN and 
+			 * thus initiate a clean new session.
+			 */
+		    	WRITE_UNLOCK(&tcp_lock);
+			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+				nf_log(PF_INET, (char *)iph, len, 
+					"ip_ct_tcp: killing out of sync session ");
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)
+		    					    conntrack);
+		    	return -NF_DROP;
+		}
+		conntrack->proto.tcp.last_index = index;
+		conntrack->proto.tcp.last_dir = dir;
+		conntrack->proto.tcp.last_seq = ntohl(tcph->seq);
+		conntrack->proto.tcp.last_end = 
+		    segment_seq_plus_len(ntohl(tcph->seq), len, iph, tcph);
+		
+		WRITE_UNLOCK(&tcp_lock);
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: invalid packet ignored ");
+		return NF_ACCEPT;
+	case TCP_CONNTRACK_MAX:
+		/* Invalid packet */
+		DEBUGP("ip_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
+		       dir, get_conntrack_index(tcph),
+		       old_state);
 		WRITE_UNLOCK(&tcp_lock);
-		return -1;
+		if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+			nf_log(PF_INET, (char *)iph, len, 
+				"ip_ct_tcp: invalid state ");
+		return -NF_ACCEPT;
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if ((conntrack->proto.tcp.seen[dir].flags &
+		         IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || after(ntohl(tcph->seq),
+		    	     conntrack->proto.tcp.seen[dir].td_end)) {	
+		    	/* Attempt to reopen a closed connection.
+		    	* Delete this connection and look up again. */
+		    	WRITE_UNLOCK(&tcp_lock);
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)
+		    					    conntrack);
+		    	return -NF_REPEAT;
+		} else {
+			WRITE_UNLOCK(&tcp_lock);
+			if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
+				nf_log(PF_INET, (char *)iph, len, 
+					"ip_ct_tcp: invalid SYN ");
+			return -NF_ACCEPT;
+		}
+	case TCP_CONNTRACK_CLOSE:
+		if (index == TCP_RST_SET
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
+		    && ntohl(tcph->ack_seq) == conntrack->proto.tcp.last_end) {
+			/* RST sent to invalid SYN we had let trough 
+			 * SYN was in window then, tear down connection.
+			 * We skip window checking, because packet might ACK
+			 * segments we ignored in the SYN. */
+			goto in_window;
+		}
+		/* Just fall trough */
+	default:
+		/* Keep compilers happy. */
+		break;
 	}
 
-	conntrack->proto.tcp.state = newconntrack;
-
-	/* Poor man's window tracking: record SYN/ACK for handshake check */
-	if (oldtcpstate == TCP_CONNTRACK_SYN_SENT
-	    && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
-	    && tcph->syn && tcph->ack)
-		conntrack->proto.tcp.handshake_ack
-			= htonl(ntohl(tcph->seq) + 1);
-
-	/* If only reply is a RST, we can consider ourselves not to
-	   have an established connection: this is a fairly common
-	   problem case, so we can delete the conntrack
-	   immediately.  --RR */
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph->rst) {
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, index, 
+			   iph, len, tcph)) {
 		WRITE_UNLOCK(&tcp_lock);
-		if (del_timer(&conntrack->timeout))
-			conntrack->timeout.function((unsigned long)conntrack);
-	} else {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED after SYN_RECV */
-		if (oldtcpstate == TCP_CONNTRACK_SYN_RECV
-		    && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL
-		    && tcph->ack && !tcph->syn
-		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack)
+		return -NF_ACCEPT;
+	}
+    in_window:
+	/* From now on we have got in-window packets */	
+	conntrack->proto.tcp.last_index = index;
+
+	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
+	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0),
+		(tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
+		old_state, new_state);
+
+	conntrack->proto.tcp.state = new_state;
+	if (old_state != new_state 
+	    && (new_state == TCP_CONNTRACK_FIN_WAIT
+	    	|| new_state == TCP_CONNTRACK_CLOSE))
+		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
+	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
+		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans
+		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+	WRITE_UNLOCK(&tcp_lock);
+
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+		/* If only reply is a RST, we can consider ourselves not to
+		   have an established connection: this is a fairly common
+		   problem case, so we can delete the conntrack
+		   immediately.  --RR */
+		if (tcph->rst) {
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)
+							    conntrack);
+			return NF_ACCEPT;
+		}
+	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+		   && (old_state == TCP_CONNTRACK_SYN_RECV
+		       || old_state == TCP_CONNTRACK_ESTABLISHED)
+		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
+		/* Set ASSURED if we see see valid ack in ESTABLISHED 
+		   after SYN_RECV or a valid answer for a picked up 
+		   connection. */
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
-
-		WRITE_UNLOCK(&tcp_lock);
-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 	}
+	ip_ct_refresh(conntrack, timeout);
 
 	return NF_ACCEPT;
 }
-
+ 
 /* Called when a new connection for this protocol found. */
 static int tcp_new(struct ip_conntrack *conntrack,
 		   struct iphdr *iph, size_t len)
 {
-	enum tcp_conntrack newconntrack;
+	enum tcp_conntrack new_state;
 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+#ifdef DEBUGP_VARS
+	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
+	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
+#endif
 
+	/* Skip unclean packets */
+	if (tcp_error(iph, len) != NF_ACCEPT)
+		return 0;
+	
 	/* Don't need lock here: this conntrack not in circulation yet */
-	newconntrack
+	new_state
 		= tcp_conntracks[0][get_conntrack_index(tcph)]
 		[TCP_CONNTRACK_NONE];
 
 	/* Invalid: delete conntrack */
-	if (newconntrack == TCP_CONNTRACK_MAX) {
-		DEBUGP("ip_conntrack_tcp: invalid new deleting.\n");
+	if (new_state >= TCP_CONNTRACK_MAX) {
+		DEBUGP("ip_ct_tcp: invalid new deleting.\n");
 		return 0;
 	}
 
-	conntrack->proto.tcp.state = newconntrack;
+	if (new_state == TCP_CONNTRACK_SYN_SENT) {
+		/* SYN packet */
+		conntrack->proto.tcp.seen[0].td_end =
+			segment_seq_plus_len(ntohl(tcph->seq), len,
+					     iph, tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+			conntrack->proto.tcp.seen[0].td_maxwin = 1;
+		conntrack->proto.tcp.seen[0].td_maxend =
+			conntrack->proto.tcp.seen[0].td_end;
+
+		tcp_options(tcph, &conntrack->proto.tcp.seen[0]);
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
+			segment_seq_plus_len(ntohl(tcph->seq), len,
+					     iph, tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(tcph->window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+			conntrack->proto.tcp.seen[0].td_maxwin = 1;
+		conntrack->proto.tcp.seen[0].td_maxend =
+			conntrack->proto.tcp.seen[0].td_end + 
+			conntrack->proto.tcp.seen[0].td_maxwin;
+		conntrack->proto.tcp.seen[0].td_scale = 0;
+
+		/* We assume SACK. Should we assume window scaling too? */
+		conntrack->proto.tcp.seen[0].flags =
+		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
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
+	conntrack->proto.tcp.last_index = TCP_NONE_SET;
+	 
+	DEBUGP("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
+	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale, 
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
 	return 1;
 }
-
+  
 static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
 			       struct sk_buff **pskb)
 {
-	struct iphdr *iph = (*pskb)->nh.iph;
+	const struct iphdr *iph = (*pskb)->nh.iph;
 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
 	unsigned int datalen;
 
@@ -251,7 +1076,15 @@
 	return between(exp->seq, ntohl(tcph->seq), ntohl(tcph->seq) + datalen);
 }
 
-struct ip_conntrack_protocol ip_conntrack_protocol_tcp
-= { { NULL, NULL }, IPPROTO_TCP, "tcp",
-    tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntrack,
-    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
+struct ip_conntrack_protocol ip_conntrack_protocol_tcp =
+{
+	.proto 			= IPPROTO_TCP,
+	.name 			= "tcp",
+	.pkt_to_tuple 		= tcp_pkt_to_tuple,
+	.invert_tuple 		= tcp_invert_tuple,
+	.print_tuple 		= tcp_print_tuple,
+	.print_conntrack 	= tcp_print_conntrack,
+	.packet 		= tcp_packet,
+	.new 			= tcp_new,
+	.exp_matches_pkt	= tcp_exp_matches_pkt,
+};
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-04 03:42:20 +0200
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-11-21 10:41:19 +0100
@@ -259,6 +259,11 @@
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
@@ -315,6 +320,21 @@
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
 
diff -X dontdiff -Nur linux-2.4.32-orig/net/ipv4/netfilter/ip_nat_helper.c linux-2.4.32-pab2/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.4.32-orig/net/ipv4/netfilter/ip_nat_helper.c	2005-04-04 03:42:20 +0200
+++ linux-2.4.32-pab2/net/ipv4/netfilter/ip_nat_helper.c	2005-11-21 10:41:19 +0100
@@ -451,6 +451,8 @@
 	tcph->ack_seq = newack;
 
 	ip_nat_sack_adjust(skb, ct, ctinfo);
+	
+	ip_conntrack_tcp_update(skb, ct, dir);
 
 	return 0;
 }

--------------090808060703040907060301--
