From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER: tcp window tracking
Date: Sat, 24 Jul 2004 11:34:27 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724153427.GV2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xUyMHIOv46mebLva"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--xUyMHIOv46mebLva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the tcp window tracking patch, incremental to all previous
changes.  It is now by default enabled (i.e. in 'conservative' mode).
If you think it's better to leave it disabled ('liberal' mode), you can
change ip_conntrack_tcp_be_liberal to a different default value.

Cheers,

Signed-off-by: Jozsef Kadlecski <kadlec@blackhole.kfki.hu>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_=
conntrack.h linux-2.6.8-rc2-nfpending-tcpwin/include/linux/netfilter_ipv4/i=
p_conntrack.h
--- linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_conntrack.h	2=
004-07-22 16:27:41.639249840 -0400
+++ linux-2.6.8-rc2-nfpending-tcpwin/include/linux/netfilter_ipv4/ip_conntr=
ack.h	2004-07-22 16:45:55.842905600 -0400
@@ -262,6 +262,11 @@
 			       unsigned long extra_jiffies);
=20
 /* These are for NAT.  Icky. */
+/* Update TCP window tracking data when NAT mangles the packet */
+extern int ip_conntrack_tcp_update(struct sk_buff *skb,
+				   struct ip_conntrack *conntrack,
+				   int dir);
+
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_=
conntrack_tcp.h linux-2.6.8-rc2-nfpending-tcpwin/include/linux/netfilter_ip=
v4/ip_conntrack_tcp.h
--- linux-2.6.8-rc2-nfpending/include/linux/netfilter_ipv4/ip_conntrack_tcp=
=2Eh	2004-06-16 01:19:13.000000000 -0400
+++ linux-2.6.8-rc2-nfpending-tcpwin/include/linux/netfilter_ipv4/ip_conntr=
ack_tcp.h	2004-07-22 16:45:55.843905448 -0400
@@ -4,25 +4,44 @@
=20
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
+/* SACK is permitted by the sender */
+#define IP_CT_TCP_FLAG_SACK_PERM		0x02
+
+struct ip_ct_tcp_state {
+	u_int32_t	td_end;		/* max of seq + len */
+	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
+	u_int32_t	td_maxwin;	/* max(win) */
+	u_int8_t	td_scale;	/* window scale factor */
+	u_int8_t	loose;		/* used when connection picked up from the middle */
+	u_int8_t	flags;		/* per direction state flags */
 };
=20
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
+	u_int8_t	last_dir;	/* Direction of the last packet (enum ip_conntrack_dir=
) */
+	u_int8_t	retrans;	/* Number of retransmitted packets */
+	u_int8_t	last_index;	/* Index of the last packet */
+	u_int32_t	last_seq;	/* Last sequence number seen in dir */
+	u_int32_t	last_end;	/* Last seq + len */
 };
=20
 #endif /* _IP_CONNTRACK_TCP_H */
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_=
core.c linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntrack_cor=
e.c
--- linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_core.c	2004-0=
7-22 16:26:13.296679952 -0400
+++ linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntrack_core.c=
	2004-07-22 16:47:03.498620368 -0400
@@ -801,12 +801,13 @@
 	IP_NF_ASSERT((*pskb)->nfct);
=20
 	ret =3D proto->packet(ct, *pskb, ctinfo);
-	if (ret =3D=3D -1) {
-		/* Invalid */
+	if (ret < 0) {
+		/* Invalid: inverse of the return code tells
+		 * the netfilter core what to do*/
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct =3D NULL;
 		__get_cpu_var(ip_conntrack_stat).invalid++;
-		return NF_ACCEPT;
+		return -ret;
 	}
=20
 	if (ret !=3D NF_DROP && ct->helper) {
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_=
proto_tcp.c linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntrac=
k_proto_tcp.c
--- linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2=
004-07-22 16:25:43.807163040 -0400
+++ linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntrack_proto_=
tcp.c	2004-07-22 17:19:17.598592480 -0400
@@ -4,8 +4,22 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
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
  */
=20
+#include <linux/config.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -14,16 +28,18 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/string.h>
+#include <linux/spinlock.h>
=20
 #include <net/tcp.h>
=20
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
=20
 #if 0
 #define DEBUGP printk
+#define DEBUGP_VARS
 #else
 #define DEBUGP(format, args...)
 #endif
@@ -31,28 +47,40 @@
 /* Protects conntrack->proto.tcp */
 static DECLARE_RWLOCK(tcp_lock);
=20
-/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR */
+/* "Be conservative in what you do,=20
+    be liberal in what you accept from others."=20
+    If it's non-zero, we mark only out of window RST segments as INVALID. =
*/
+int ip_ct_tcp_be_liberal =3D 0;
+
+/* When connection is picked up from the middle, how many packets are requ=
ired
+   to pass in each direction when we assume we are in sync - if any side u=
ses
+   window scaling, we lost the game.=20
+   If it is set to zero, we disable picking up already established=20
+   connections. */
+int ip_ct_tcp_loose =3D 3;
+
+/* Max number of the retransmitted packets without receiving an (acceptabl=
e)=20
+   ACK from the destination. If this number is reached, a shorter timer=20
+   will be started. */
+int ip_ct_tcp_max_retrans =3D 3;
=20
-/* Actually, I believe that neither ipmasq (where this code is stolen
-   from) nor ipfilter do it exactly right.  A new conntrack machine taking
-   into account packet loss (which creates uncertainty as to exactly
-   the conntrack of the connection) is required.  RSN.  --RR */
+  /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
+     closely.  They're more complex. --RR */
=20
 static const char *tcp_conntrack_names[] =3D {
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
+ =20
+#define SECS * HZ
 #define MINS * 60 SECS
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
@@ -66,55 +94,204 @@
 unsigned long ip_ct_tcp_timeout_time_wait =3D     2 MINS;
 unsigned long ip_ct_tcp_timeout_close =3D        10 SECS;
=20
+/* RFC1122 says the R2 limit should be at least 100 seconds.
+   Linux uses 15 packets as limit, which corresponds=20
+   to ~13-30min depending on RTO. */
+unsigned long ip_ct_tcp_timeout_max_retrans =3D     5 MINS;
+=20
 static unsigned long * tcp_timeouts[]
 =3D { NULL,                              /*      TCP_CONNTRACK_NONE */
-    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED, =
     */
     &ip_ct_tcp_timeout_syn_sent,       /*      TCP_CONNTRACK_SYN_SENT, */
     &ip_ct_tcp_timeout_syn_recv,       /*      TCP_CONNTRACK_SYN_RECV, */
+    &ip_ct_tcp_timeout_established,    /*      TCP_CONNTRACK_ESTABLISHED, =
     */
     &ip_ct_tcp_timeout_fin_wait,       /*      TCP_CONNTRACK_FIN_WAIT, */
-    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,   =
     */
-    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
     &ip_ct_tcp_timeout_close_wait,     /*      TCP_CONNTRACK_CLOSE_WAIT,  =
     */
     &ip_ct_tcp_timeout_last_ack,       /*      TCP_CONNTRACK_LAST_ACK, */
+    &ip_ct_tcp_timeout_time_wait,      /*      TCP_CONNTRACK_TIME_WAIT,   =
     */
+    &ip_ct_tcp_timeout_close,          /*      TCP_CONNTRACK_CLOSE,    */
     NULL,                              /*      TCP_CONNTRACK_LISTEN */
  };
 =20
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
=20
-static enum tcp_conntrack tcp_conntracks[2][5][TCP_CONNTRACK_MAX] =3D {
+/* What TCP flags are set from RST/SYN/FIN/ACK. */
+enum tcp_bit_set {
+	TCP_SYN_SET,
+	TCP_SYNACK_SET,
+	TCP_FIN_SET,
+	TCP_ACK_SET,
+	TCP_RST_SET,
+	TCP_NONE_SET,
+};
+ =20
+/*
+ * The TCP state transition table needs a few words...
+ *
+ * We are the man in the middle. All the packets go through us
+ * but might get lost in transit to the destination.
+ * It is assumed that the destinations can't receive segments=20
+ * we haven't seen.
+ *
+ * The checked segment is in window, but our windows are *not*
+ * equivalent with the ones of the sender/receiver. We always
+ * try to guess the state of the current sender.
+ *
+ * The meaning of the states are:
+ *
+ * NONE:	initial state
+ * SYN_SENT:	SYN-only packet seen=20
+ * SYN_RECV:	SYN-ACK packet seen
+ * ESTABLISHED:	ACK packet seen
+ * FIN_WAIT:	FIN packet seen
+ * CLOSE_WAIT:	ACK seen (after FIN)=20
+ * LAST_ACK:	FIN seen (after FIN)
+ * TIME_WAIT:	last ACK seen
+ * CLOSE:	closed connection
+ *
+ * LISTEN state is not used.
+ *
+ * Packets marked as IGNORED (sIG):
+ *	if they may be either invalid or valid=20
+ *	and the receiver may send back a connection=20
+ *	closing RST or a SYN/ACK.
+ *
+ * Packets marked as INVALID (sIV):
+ *	if they are invalid
+ *	or we do not support the request (simultaneous open)
+ */
+static enum tcp_conntrack tcp_conntracks[2][6][TCP_CONNTRACK_MAX] =3D {
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
+ *			are errors. Receiver will reply with RST=20
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
+ *	- either it tries to set up a simultaneous open, which is=20
+ *	  not supported;
+ *	- or the firewall has just been inserted between the two hosts
+ *	  during the session set-up. The SYN will be retransmitted=20
+ *	  by the true client (or it'll time out).
+ */
+/* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
+/*fin*/    { sIV, sIV, sFW, sFW, sLA, sLA, sLA, sTW, sCL, sIV },
+/*
+ *	sNO -> sIV	Too late and no reason to do anything...
+ *	sSS -> sIV	Client migth not send FIN in this state:
+ *			we enforce waiting for a SYN/ACK reply first.
+ *	sSR -> sFW	Close started.
+ *	sES -> sFW=09
+ *	sFW -> sLA	FIN seen in both directions, waiting for
+ *			the last ACK.=20
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
+  	}
 };
=20
 static int tcp_pkt_to_tuple(const struct sk_buff *skb,
-			     unsigned int dataoff,
-			     struct ip_conntrack_tuple *tuple)
+			    unsigned int dataoff,
+			    struct ip_conntrack_tuple *tuple)
 {
 	struct tcphdr hdr;
=20
@@ -160,100 +337,721 @@
=20
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
 }
=20
-/* Returns verdict for packet, or -1 for invalid. */
-static int tcp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
-		      enum ip_conntrack_info ctinfo)
+/* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
+   in IP Filter' by Guido van Rooij.
+  =20
+   http://www.nluug.nl/events/sane2000/papers.html
+   http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
+  =20
+   The boundaries and the conditions are slightly changed:
+  =20
+   	td_maxend =3D max(sack + max(win,1)) seen in reply packets
+	td_maxwin =3D max(max(win, 1)) + (sack - ack) seen in sent packets
+	td_end    =3D max(seq + len) seen in sent packets
+  =20
+   I. 	Upper bound for valid data:	seq + len <=3D sender.td_maxend
+   II. 	Lower bound for valid data:	seq >=3D sender.td_end - receiver.td_m=
axwin
+   III.	Upper bound for valid ack:      sack <=3D receiver.td_end
+   IV.	Lower bound for valid ack:	ack >=3D receiver.td_end - MAXACKWINDOW
+   =09
+   where sack is the highest right edge of sack block found in the packet.
+   =09
+   The upper bound limit for a valid ack is not ignored -=20
+   we doesn't have to deal with fragments.=20
+*/
+
+static inline __u32 segment_seq_plus_len(__u32 seq,
+					 size_t len,
+					 struct iphdr *iph,
+					 struct tcphdr *tcph)
+  {
+	return (seq + len - (iph->ihl + tcph->doff)*4
+		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
+}
+ =20
+/* Fixme: what about big packets? */
+#define MAXACKWINCONST			66000
+#define MAXACKWINDOW(sender)						\
+	((sender)->td_maxwin > MAXACKWINCONST ? (sender)->td_maxwin	\
+					      : MAXACKWINCONST)
+ =20
+/*
+ * Simplified tcp_parse_options routine from tcp_input.c
+ */
+static void tcp_options(struct tcphdr *tcph,=20
+			struct ip_ct_tcp_state *state)
 {
-	enum tcp_conntrack newconntrack, oldtcpstate;
-	struct tcphdr tcph;
-
-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0)
-		return -1;
-	if (skb->len < skb->nh.iph->ihl * 4 + tcph.doff * 4)
-		return -1;
-
-	/* If only reply is a RST, we can consider ourselves not to
-	   have an established connection: this is a fairly common
-	   problem case, so we can delete the conntrack
-	   immediately.  --RR */
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph.rst) {
-		if (del_timer(&conntrack->timeout))
-			conntrack->timeout.function((unsigned long)conntrack);
-		return NF_ACCEPT;
+	unsigned char *ptr =3D (unsigned char *)(tcph + 1);
+	int length =3D (tcph->doff*4) - sizeof(struct tcphdr);
+=09
+	state->td_scale =3D=20
+	state->flags =3D 0;
+=09
+	while (length > 0) {
+		int opcode=3D*ptr++;
+		int opsize;
+	=09
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			opsize=3D*ptr++;
+			if (opsize < 2) /* "silly options" */
+				return;
+			if (opsize > length)
+				break;	/* don't parse partial options */
+
+			if (opcode =3D=3D TCPOPT_SACK_PERM=20
+			    && opsize =3D=3D TCPOLEN_SACK_PERM)
+				state->flags |=3D IP_CT_TCP_FLAG_SACK_PERM;
+			else if (opcode =3D=3D TCPOPT_WINDOW
+				 && opsize =3D=3D TCPOLEN_WINDOW) {
+				state->td_scale =3D *(u_int8_t *)ptr;
+			=09
+				if (state->td_scale > 14) {
+					/* See RFC1323 */
+					state->td_scale =3D 14;
+				}
+				state->flags |=3D
+					IP_CT_TCP_STATE_FLAG_WINDOW_SCALE;
+			}
+			ptr +=3D opsize - 2;
+			length -=3D opsize;
+		}
 	}
+}
=20
-	WRITE_LOCK(&tcp_lock);
-	oldtcpstate =3D conntrack->proto.tcp.state;
-	newconntrack
-		=3D tcp_conntracks
-		[CTINFO2DIR(ctinfo)]
-		[get_conntrack_index(&tcph)][oldtcpstate];
-
-	/* Invalid */
-	if (newconntrack =3D=3D TCP_CONNTRACK_MAX) {
-		DEBUGP("ip_conntrack_tcp: Invalid dir=3D%i index=3D%u conntrack=3D%u\n",
-		       CTINFO2DIR(ctinfo), get_conntrack_index(&tcph),
-		       conntrack->proto.tcp.state);
-		WRITE_UNLOCK(&tcp_lock);
-		return -1;
+static void tcp_sack(struct tcphdr *tcph, __u32 *sack)
+{
+	__u32 tmp;
+	unsigned char *ptr;
+	int length =3D (tcph->doff*4) - sizeof(struct tcphdr);
+=09
+	/* Fast path for timestamp-only option */
+	if (length =3D=3D TCPOLEN_TSTAMP_ALIGNED*4
+	    && *(__u32 *)(tcph + 1) =3D=3D
+	        __constant_ntohl((TCPOPT_NOP << 24)=20
+	        		 | (TCPOPT_NOP << 16)
+	        		 | (TCPOPT_TIMESTAMP << 8)
+	        		 | TCPOLEN_TIMESTAMP))
+		return;
+	=09
+	ptr =3D (unsigned char *)(tcph + 1);
+	while (length > 0) {
+		int opcode=3D*ptr++;
+		int opsize, i;
+	=09
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			opsize=3D*ptr++;
+			if (opsize < 2) /* "silly options" */
+				return;
+			if (opsize > length)
+				break;	/* don't parse partial options */
+
+			if (opcode =3D=3D TCPOPT_SACK=20
+			    && opsize >=3D (TCPOLEN_SACK_BASE=20
+			    		  + TCPOLEN_SACK_PERBLOCK)
+			    && !((opsize - TCPOLEN_SACK_BASE)=20
+			    	 % TCPOLEN_SACK_PERBLOCK)) {
+			    	for (i =3D 0;
+			    	     i < (opsize - TCPOLEN_SACK_BASE);
+			    	     i +=3D TCPOLEN_SACK_PERBLOCK) {
+					tmp =3D ntohl(*((u_int32_t *)(ptr+i)+1));
+				=09
+					if (after(tmp, *sack))
+						*sack =3D tmp;
+				}
+				return;
+			}
+			ptr +=3D opsize - 2;
+			length -=3D opsize;
+		}
 	}
+}
=20
-	conntrack->proto.tcp.state =3D newconntrack;
+static int tcp_in_window(struct ip_ct_tcp *state,=20
+                         enum ip_conntrack_dir dir,
+                         unsigned int *index,
+                         const struct sk_buff *skb,
+                         struct iphdr *iph,
+                         struct tcphdr *tcph)
+{
+	struct ip_ct_tcp_state *sender =3D &state->seen[dir];
+	struct ip_ct_tcp_state *receiver =3D &state->seen[!dir];
+	__u32 seq, ack, sack, end, win, swin;
+	int res;
+=09
+	/*
+	 * Get the required data from the packet.
+	 */
+	seq =3D ntohl(tcph->seq);
+	ack =3D sack =3D ntohl(tcph->ack_seq);
+	win =3D ntohs(tcph->window);
+	end =3D segment_seq_plus_len(seq, skb->len, iph, tcph);
+=09
+	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
+		tcp_sack(tcph, &sack);
+	=09
+	DEBUGP("tcp_in_window: START\n");
+	DEBUGP("tcp_in_window: src=3D%u.%u.%u.%u:%hu dst=3D%u.%u.%u.%u:%hu "
+	       "seq=3D%u ack=3D%u sack=3D%u win=3D%u end=3D%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),=20
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, sack, win, end);
+	DEBUGP("tcp_in_window: sender end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i=
 "
+	       "receiver end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale,=20
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,=20
+		receiver->td_scale);
+	=09
+	if (sender->td_end =3D=3D 0) {
+		/*
+		 * Initialize sender data.
+		 */
+		if (tcph->syn && tcph->ack) {
+			/*
+			 * Outgoing SYN-ACK in reply to a SYN.
+			 */
+			sender->td_end =3D=20
+			sender->td_maxend =3D end;
+			sender->td_maxwin =3D (win =3D=3D 0 ? 1 : win);
+
+			tcp_options(tcph, sender);
+			/*=20
+			 * RFC 1323:
+			 * Both sides must send the Window Scale option
+			 * to enable window scaling in either direction.
+			 */
+			if (!(sender->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE
+			      && receiver->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE))
+				sender->td_scale =3D=20
+				receiver->td_scale =3D 0;
+		} else {
+			/*
+			 * We are in the middle of a connection,
+			 * its history is lost for us.
+			 * Let's try to use the data from the packet.
+		 	 */
+			sender->td_end =3D end;
+			sender->td_maxwin =3D (win =3D=3D 0 ? 1 : win);
+			sender->td_maxend =3D end + sender->td_maxwin;
+		}
+	} else if (state->state =3D=3D TCP_CONNTRACK_SYN_SENT
+		   && dir =3D=3D IP_CT_DIR_ORIGINAL
+		   && after(end, sender->td_end)) {
+		/*
+		 * RFC 793: "if a TCP is reinitialized ... then it need
+		 * not wait at all; it must only be sure to use sequence=20
+		 * numbers larger than those recently used."
+		 */
+		sender->td_end =3D
+		sender->td_maxend =3D end;
+		sender->td_maxwin =3D (win =3D=3D 0 ? 1 : win);
=20
-	/* Poor man's window tracking: record SYN/ACK for handshake check */
-	if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_SENT
-	    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_REPLY
-	    && tcph.syn && tcph.ack) {
-		conntrack->proto.tcp.handshake_ack
-			=3D htonl(ntohl(tcph.seq) + 1);
-		goto out;
+		tcp_options(tcph, sender);
+	}
+=09
+	if (!(tcph->ack)) {
+		/*
+		 * If there is no ACK, just pretend it was set and OK.
+		 */
+		ack =3D sack =3D receiver->td_end;
+	} else if (((tcp_flag_word(tcph) & (TCP_FLAG_ACK|TCP_FLAG_RST)) =3D=3D=20
+		    (TCP_FLAG_ACK|TCP_FLAG_RST))=20
+		   && (ack =3D=3D 0)) {
+		/*
+		 * Broken TCP stacks, that set ACK in RST packets as well
+		 * with zero ack value.
+		 */
+		ack =3D sack =3D receiver->td_end;
 	}
=20
-	/* Set ASSURED if we see valid ack in ESTABLISHED after SYN_RECV */
-	if (oldtcpstate =3D=3D TCP_CONNTRACK_SYN_RECV
-	    && CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL
-	    && tcph.ack && !tcph.syn
-	    && tcph.ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+	if (seq =3D=3D end)
+		/*
+		 * Packets contains no data: we assume it is valid
+		 * and check the ack value only.
+		 */
+		seq =3D end =3D sender->td_end;
+	=09
+	DEBUGP("tcp_in_window: src=3D%u.%u.%u.%u:%hu dst=3D%u.%u.%u.%u:%hu "
+	       "seq=3D%u ack=3D%u sack =3D%u win=3D%u end=3D%u trim=3D%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		seq, ack, sack, win, end,=20
+		after(end, sender->td_maxend) && before(seq, sender->td_maxend)
+		? sender->td_maxend : end);
+	DEBUGP("tcp_in_window: sender end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i=
 "
+	       "receiver end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale,=20
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
+=09
+	/* Ignore data over the right edge of the receiver's window. */
+	if (after(end, sender->td_maxend) &&
+	    before(seq, sender->td_maxend)) {
+		end =3D sender->td_maxend;
+		if (*index =3D=3D TCP_FIN_SET)
+			*index =3D TCP_ACK_SET;
+	}
+	DEBUGP("tcp_in_window: I=3D%i II=3D%i III=3D%i IV=3D%i\n",
+		before(end, sender->td_maxend + 1)=20
+		    || before(seq, sender->td_maxend + 1),
+	    	after(seq, sender->td_end - receiver->td_maxwin - 1)=20
+	    	    || after(end, sender->td_end - receiver->td_maxwin - 1),
+	    	before(sack, receiver->td_end + 1),
+	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+=09
+	if (sender->loose || receiver->loose ||
+	    (before(end, sender->td_maxend + 1) &&
+	     after(seq, sender->td_end - receiver->td_maxwin - 1) &&
+	     before(sack, receiver->td_end + 1) &&
+	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
+	    	/*
+		 * Take into account window scaling (RFC 1323).
+		 */
+		if (!tcph->syn)
+			win <<=3D sender->td_scale;
+	=09
+		/*
+		 * Update sender data.
+		 */
+		swin =3D win + (sack - ack);
+		if (sender->td_maxwin < swin)
+			sender->td_maxwin =3D swin;
+		if (after(end, sender->td_end))
+			sender->td_end =3D end;
+		if (after(sack + win, receiver->td_maxend - 1)) {
+			receiver->td_maxend =3D sack + win;
+			if (win =3D=3D 0)
+				receiver->td_maxend++;
+		}
+
+		/*=20
+		 * Check retransmissions.
+		 */
+		if (*index =3D=3D TCP_ACK_SET) {
+			if (state->last_dir =3D=3D dir
+			    && state->last_seq =3D=3D seq
+			    && state->last_end =3D=3D end)
+				state->retrans++;
+			else {
+				state->last_dir =3D dir;
+				state->last_seq =3D seq;
+				state->last_end =3D end;
+				state->retrans =3D 0;
+			}
+		}
+		/*
+		 * Close the window of disabled window tracking :-)
+		 */
+		if (sender->loose)
+			sender->loose--;
+	=09
+		res =3D 1;
+	} else {
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+			"ip_ct_tcp: %s ",
+			before(end, sender->td_maxend + 1) ?
+			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
+			before(ack, receiver->td_end + 1) ?
+			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
+			: "ACK is under the lower bound (possibly overly delayed ACK)"
+			: "ACK is over the upper bound (ACKed data has never seen yet)"
+			: "SEQ is under the lower bound (retransmitted already ACKed data)"
+			: "SEQ is over the upper bound (over the window of the receiver)");
+
+		res =3D ip_ct_tcp_be_liberal && !tcph->rst;
+  	}
+ =20
+	DEBUGP("tcp_in_window: res=3D%i sender end=3D%u maxend=3D%u maxwin=3D%u "
+	       "receiver end=3D%u maxend=3D%u maxwin=3D%u\n",
+		res, sender->td_end, sender->td_maxend, sender->td_maxwin,=20
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
=20
-out:	WRITE_UNLOCK(&tcp_lock);
-	ip_ct_refresh_acct(conntrack, ctinfo, skb, *tcp_timeouts[newconntrack]);
+	return res;
+}
=20
-	return NF_ACCEPT;
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+/* Update sender->td_end after NAT successfully mangled the packet */
+int ip_conntrack_tcp_update(struct sk_buff *skb,
+			    struct ip_conntrack *conntrack,=20
+			    int dir)
+{
+	struct iphdr *iph =3D skb->nh.iph;
+	struct tcphdr *tcph =3D (void *)skb->nh.iph + skb->nh.iph->ihl*4;
+	__u32 end;
+#ifdef DEBUGP_VARS
+	struct ip_ct_tcp_state *sender =3D &conntrack->proto.tcp.seen[dir];
+	struct ip_ct_tcp_state *receiver =3D &conntrack->proto.tcp.seen[!dir];
+#endif
+
+	end =3D segment_seq_plus_len(ntohl(tcph->seq), skb->len, iph, tcph);
+=09
+	WRITE_LOCK(&tcp_lock);
+	/*
+	 * We have to worry for the ack in the reply packet only...
+	 */
+	if (after(end, conntrack->proto.tcp.seen[dir].td_end))
+		conntrack->proto.tcp.seen[dir].td_end =3D end;
+	conntrack->proto.tcp.last_end =3D end;
+	WRITE_UNLOCK(&tcp_lock);
+	DEBUGP("tcp_update: sender end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i "
+	       "receiver end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale,=20
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
+	=09
+	return 1;
 }
+=20
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
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1=
] =3D
+{
+	[TH_SYN]			=3D 1,
+	[TH_SYN|TH_ACK]			=3D 1,
+	[TH_RST]			=3D 1,
+	[TH_RST|TH_ACK]			=3D 1,
+	[TH_RST|TH_ACK|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK]			=3D 1,
+	[TH_ACK]			=3D 1,
+	[TH_ACK|TH_PUSH]		=3D 1,
+	[TH_ACK|TH_URG]			=3D 1,
+	[TH_ACK|TH_URG|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK|TH_URG]		=3D 1,
+	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	=3D 1,
+};
=20
-/* Called when a new connection for this protocol found. */
-static int tcp_new(struct ip_conntrack *conntrack, const struct sk_buff *s=
kb)
+/* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.=
  */
+static int tcp_error(struct sk_buff *skb,
+		     enum ip_conntrack_info *ctinfo,
+		     unsigned int hooknum)
 {
-	enum tcp_conntrack newconntrack;
+	struct iphdr *iph =3D skb->nh.iph;
 	struct tcphdr tcph;
+	unsigned int tcplen =3D skb->len - iph->ihl * 4;
+	u_int8_t tcpflags;
+
+	/* Smaller that minimal TCP header? */
+	if (skb_copy_bits(skb, iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0) {
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				"ip_ct_tcp: short packet ");
+		return -NF_ACCEPT;
+  	}
+ =20
+	/* Not whole TCP header or malformed packet */
+	if (tcph.doff*4 < sizeof(struct tcphdr) || tcplen < tcph.doff*4) {
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				"ip_ct_tcp: truncated/malformed packet ");
+		return -NF_ACCEPT;
+	}
+ =20
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the semantic of CHECKSUM_HW is different there=20
+	 * and moreover root might send raw packets.
+	 */
+	/* FIXME: Source route IP option packets --RR */
+	if (hooknum =3D=3D NF_IP_PRE_ROUTING
+	    && csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
+			         skb->ip_summed =3D=3D CHECKSUM_HW ? skb->csum
+			      	 : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_tcp: bad TCP checksum ");
+		return -NF_ACCEPT;
+	}
+
+	/* Check TCP flags. */
+	tcpflags =3D (((u_int8_t *)&tcph)[13] & ~(TH_ECE|TH_CWR));
+	if (!tcp_valid_flags[tcpflags]) {
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_tcp: invalid TCP flag combination ");
+		return -NF_ACCEPT;
+	}
+
+	return NF_ACCEPT;
+}
+
+static inline void copy_whole_tcp_header(const struct sk_buff *skb,
+					 unsigned char *buff)
+{
+	struct iphdr *iph =3D skb->nh.iph;
+	struct tcphdr *tcph =3D (struct tcphdr *)buff;
+
+	/* tcp_error guarantees for us that the packet is not malformed */
+	skb_copy_bits(skb, iph->ihl * 4, buff, sizeof(*tcph));
+	skb_copy_bits(skb, iph->ihl * 4 + sizeof(*tcph),=20
+		      buff + sizeof(*tcph),=20
+		      tcph->doff * 4 - sizeof(*tcph));
+}
+
+/* Returns verdict for packet, or -1 for invalid. */
+static int tcp_packet(struct ip_conntrack *conntrack,
+		      const struct sk_buff *skb,
+		      enum ip_conntrack_info ctinfo)
+{
+	enum tcp_conntrack new_state, old_state;
+	enum ip_conntrack_dir dir;
+	struct iphdr *iph =3D skb->nh.iph;
+	unsigned char buff[15 * 4];
+	struct tcphdr *tcph =3D (struct tcphdr *)buff;
+	unsigned long timeout;
+	unsigned int index;
+=09
+	copy_whole_tcp_header(skb, buff);
+=09
+	WRITE_LOCK(&tcp_lock);
+	old_state =3D conntrack->proto.tcp.state;
+	dir =3D CTINFO2DIR(ctinfo);
+	index =3D get_conntrack_index(tcph);
+	new_state =3D tcp_conntracks[dir][index][old_state];
+
+	switch (new_state) {
+	case TCP_CONNTRACK_IGNORE:
+		/* Either SYN in ORIGINAL, or SYN/ACK in REPLY direction. */
+		if (index =3D=3D TCP_SYNACK_SET
+		    && conntrack->proto.tcp.last_index =3D=3D TCP_SYN_SET
+		    && conntrack->proto.tcp.last_dir !=3D dir
+		    && after(ntohl(tcph->ack_seq),
+		    	     conntrack->proto.tcp.last_seq)) {
+			/* This SYN/ACK acknowledges a SYN that we earlier=20
+			 * ignored as invalid. This means that the client and
+			 * the server are both in sync, while the firewall is
+			 * not. We kill this session and block the SYN/ACK so
+			 * that the client cannot but retransmit its SYN and=20
+			 * thus initiate a clean new session.
+			 */
+		    	WRITE_UNLOCK(&tcp_lock);
+			if (LOG_INVALID(IPPROTO_TCP))
+				nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+					  "ip_ct_tcp: killing out of sync session ");
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)
+		    					    conntrack);
+		    	return -NF_DROP;
+		}
+		conntrack->proto.tcp.last_index =3D index;
+		conntrack->proto.tcp.last_dir =3D dir;
+		conntrack->proto.tcp.last_seq =3D ntohl(tcph->seq);
+	=09
+		WRITE_UNLOCK(&tcp_lock);
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_tcp: invalid SYN (ignored) ");
+		return NF_ACCEPT;
+	case TCP_CONNTRACK_MAX:
+		/* Invalid packet */
+		DEBUGP("ip_ct_tcp: Invalid dir=3D%i index=3D%u ostate=3D%u\n",
+		       dir, get_conntrack_index(tcph),
+		       old_state);
+		WRITE_UNLOCK(&tcp_lock);
+		if (LOG_INVALID(IPPROTO_TCP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+				  "ip_ct_tcp: invalid state ");
+		return -NF_ACCEPT;
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state >=3D TCP_CONNTRACK_TIME_WAIT) {=09
+		    	/* Attempt to reopen a closed connection.
+		    	* Delete this connection and look up again. */
+		    	WRITE_UNLOCK(&tcp_lock);
+		    	if (del_timer(&conntrack->timeout))
+		    		conntrack->timeout.function((unsigned long)
+		    					    conntrack);
+		    	return -NF_REPEAT;
+		}
+		break;
+	case TCP_CONNTRACK_CLOSE:
+		if (index =3D=3D TCP_RST_SET
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && conntrack->proto.tcp.last_index <=3D TCP_SYNACK_SET
+		    && after(ntohl(tcph->ack_seq),
+		    	     conntrack->proto.tcp.last_seq)) {
+			/* Ignore RST closing down invalid SYN=20
+			   we had let trough. */=20
+		    	WRITE_UNLOCK(&tcp_lock);
+			if (LOG_INVALID(IPPROTO_TCP))
+				nf_log_packet(PF_INET, 0, skb, NULL, NULL,=20
+					  "ip_ct_tcp: invalid RST (ignored) ");
+			return NF_ACCEPT;
+		}
+		/* Just fall trough */
+	default:
+		/* Keep compilers happy. */
+		break;
+	}
=20
-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0)
-		return -1;
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index,=20
+			   skb, iph, tcph)) {
+		WRITE_UNLOCK(&tcp_lock);
+		return -NF_ACCEPT;
+	}
+	/* From now on we have got in-window packets */
+=09
+	/* If FIN was trimmed off, we don't change state. */
+	conntrack->proto.tcp.last_index =3D index;
+	new_state =3D tcp_conntracks[dir][index][old_state];
+
+	DEBUGP("tcp_conntracks: src=3D%u.%u.%u.%u:%hu dst=3D%u.%u.%u.%u:%hu "
+	       "syn=3D%i ack=3D%i fin=3D%i rst=3D%i old=3D%i new=3D%i\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest),
+		(tcph->syn ? 1 : 0), (tcph->ack ? 1 : 0),
+		(tcph->fin ? 1 : 0), (tcph->rst ? 1 : 0),
+		old_state, new_state);
+
+	conntrack->proto.tcp.state =3D new_state;
+	timeout =3D conntrack->proto.tcp.retrans >=3D ip_ct_tcp_max_retrans
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
+		   && (old_state =3D=3D TCP_CONNTRACK_SYN_RECV
+		       || old_state =3D=3D TCP_CONNTRACK_ESTABLISHED)
+		   && new_state =3D=3D TCP_CONNTRACK_ESTABLISHED) {
+		/* Set ASSURED if we see see valid ack in ESTABLISHED=20
+		   after SYN_RECV or a valid answer for a picked up=20
+		   connection. */
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+	}
+	ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
+
+	return NF_ACCEPT;
+}
+=20
+  /* Called when a new connection for this protocol found. */
+static int tcp_new(struct ip_conntrack *conntrack,
+		   const struct sk_buff *skb)
+{
+	enum tcp_conntrack new_state;
+	struct iphdr *iph =3D skb->nh.iph;
+	unsigned char buff[15 * 4];
+	struct tcphdr *tcph =3D (struct tcphdr *)buff;
+#ifdef DEBUGP_VARS
+	struct ip_ct_tcp_state *sender =3D &conntrack->proto.tcp.seen[0];
+	struct ip_ct_tcp_state *receiver =3D &conntrack->proto.tcp.seen[1];
+#endif
=20
+	copy_whole_tcp_header(skb, buff);
+ =20
 	/* Don't need lock here: this conntrack not in circulation yet */
-	newconntrack
-		=3D tcp_conntracks[0][get_conntrack_index(&tcph)]
+	new_state
+		=3D tcp_conntracks[0][get_conntrack_index(tcph)]
 		[TCP_CONNTRACK_NONE];
=20
 	/* Invalid: delete conntrack */
-	if (newconntrack =3D=3D TCP_CONNTRACK_MAX) {
-		DEBUGP("ip_conntrack_tcp: invalid new deleting.\n");
+	if (new_state >=3D TCP_CONNTRACK_MAX) {
+		DEBUGP("ip_ct_tcp: invalid new deleting.\n");
 		return 0;
 	}
=20
-	conntrack->proto.tcp.state =3D newconntrack;
+	if (new_state =3D=3D TCP_CONNTRACK_SYN_SENT) {
+		/* SYN packet */
+		conntrack->proto.tcp.seen[0].td_end =3D
+			segment_seq_plus_len(ntohl(tcph->seq), skb->len,
+					     iph, tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin =3D ntohs(tcph->window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin =3D=3D 0)
+			conntrack->proto.tcp.seen[0].td_maxwin =3D 1;
+		conntrack->proto.tcp.seen[0].td_maxend =3D
+			conntrack->proto.tcp.seen[0].td_end;
+
+		tcp_options(tcph, &conntrack->proto.tcp.seen[0]);
+		conntrack->proto.tcp.seen[1].flags =3D 0;
+		conntrack->proto.tcp.seen[0].loose =3D=20
+		conntrack->proto.tcp.seen[1].loose =3D 0;
+	} else if (ip_ct_tcp_loose =3D=3D 0) {
+		/* Don't try to pick up connections. */
+		return 0;
+	} else {
+		/*
+		 * We are in the middle of a connection,
+		 * its history is lost for us.
+		 * Let's try to use the data from the packet.
+		 */
+		conntrack->proto.tcp.seen[0].td_end =3D
+			segment_seq_plus_len(ntohl(tcph->seq), skb->len,
+					     iph, tcph);
+		conntrack->proto.tcp.seen[0].td_maxwin =3D ntohs(tcph->window);
+		if (conntrack->proto.tcp.seen[0].td_maxwin =3D=3D 0)
+			conntrack->proto.tcp.seen[0].td_maxwin =3D 1;
+		conntrack->proto.tcp.seen[0].td_maxend =3D
+			conntrack->proto.tcp.seen[0].td_end +=20
+			conntrack->proto.tcp.seen[0].td_maxwin;
+		conntrack->proto.tcp.seen[0].td_scale =3D 0;
+
+		/* We assume SACK. Should we assume window scaling too? */
+		conntrack->proto.tcp.seen[0].flags =3D
+		conntrack->proto.tcp.seen[1].flags =3D IP_CT_TCP_FLAG_SACK_PERM;
+		conntrack->proto.tcp.seen[0].loose =3D=20
+		conntrack->proto.tcp.seen[1].loose =3D ip_ct_tcp_loose;
+	}
+   =20
+	conntrack->proto.tcp.seen[1].td_end =3D 0;
+	conntrack->proto.tcp.seen[1].td_maxend =3D 0;
+	conntrack->proto.tcp.seen[1].td_maxwin =3D 1;
+	conntrack->proto.tcp.seen[1].td_scale =3D 0;     =20
+
+	/* tcp_packet will set them */
+	conntrack->proto.tcp.state =3D TCP_CONNTRACK_NONE;
+	conntrack->proto.tcp.last_index =3D TCP_NONE_SET;
+	=20
+	DEBUGP("tcp_new: sender end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i "
+	       "receiver end=3D%u maxend=3D%u maxwin=3D%u scale=3D%i\n",
+		sender->td_end, sender->td_maxend, sender->td_maxwin,
+		sender->td_scale,=20
+		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		receiver->td_scale);
 	return 1;
 }
-
+ =20
 static int tcp_exp_matches_pkt(struct ip_conntrack_expect *exp,
 			       const struct sk_buff *skb)
 {
@@ -261,7 +1059,7 @@
 	struct tcphdr tcph;
 	unsigned int datalen;
=20
-	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0)
+	if (skb_copy_bits(skb, iph->ihl * 4, &tcph, sizeof(tcph)) !=3D 0)
 		return 0;
 	datalen =3D skb->len - iph->ihl*4 - tcph.doff*4;
=20
@@ -279,4 +1077,5 @@
 	.packet 		=3D tcp_packet,
 	.new 			=3D tcp_new,
 	.exp_matches_pkt	=3D tcp_exp_matches_pkt,
+	.error			=3D tcp_error,
 };
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_=
standalone.c linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntra=
ck_standalone.c
--- linux-2.6.8-rc2-nfpending/net/ipv4/netfilter/ip_conntrack_standalone.c	=
2004-07-22 16:26:13.297679800 -0400
+++ linux-2.6.8-rc2-nfpending-tcpwin/net/ipv4/netfilter/ip_conntrack_standa=
lone.c	2004-07-22 16:45:56.259842216 -0400
@@ -505,6 +505,10 @@
 extern unsigned long ip_ct_tcp_timeout_last_ack;
 extern unsigned long ip_ct_tcp_timeout_time_wait;
 extern unsigned long ip_ct_tcp_timeout_close;
+extern unsigned long ip_ct_tcp_timeout_max_retrans;
+extern int ip_ct_tcp_loose;
+extern int ip_ct_tcp_be_liberal;
+extern int ip_ct_tcp_max_retrans;
=20
 /* From ip_conntrack_proto_udp.c */
 extern unsigned long ip_ct_udp_timeout;
@@ -647,6 +651,38 @@
 		.extra1		=3D &log_invalid_proto_min,
 		.extra2		=3D &log_invalid_proto_max,
 	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
+		.procname	=3D "ip_conntrack_tcp_timeout_max_retrans",
+		.data		=3D &ip_ct_tcp_timeout_max_retrans,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_LOOSE,
+		.procname	=3D "ip_conntrack_tcp_loose",
+		.data		=3D &ip_ct_tcp_loose,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL,
+		.procname	=3D "ip_conntrack_tcp_be_liberal",
+		.data		=3D &ip_ct_tcp_be_liberal,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec,
+	},
+	{
+		.ctl_name	=3D NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS,
+		.procname	=3D "ip_conntrack_tcp_max_retrans",
+		.data		=3D &ip_ct_tcp_max_retrans,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D &proc_dointvec,
+	},
 	{ .ctl_name =3D 0 }
 };
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xUyMHIOv46mebLva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAoGDXaXGVTD0i/8RAoOvAJsFbZu9Ylb4djSKT41etqz9lpK14wCfWyng
DH4axZSMe8tLn0FsyNp8zI4=
=t6ee
-----END PGP SIGNATURE-----

--xUyMHIOv46mebLva--
