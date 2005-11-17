From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: DCCP conntrack/NAT
Date: Thu, 17 Nov 2005 06:41:25 +0100
Message-ID: <437C1805.40400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000200010309020806040009"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	dccp@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ian McDonald <imcdnzl@gmail.com>
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
--------------000200010309020806040009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ian,

I've updated the DCCP conntrack patch to apply to the current
kernel and added NAT support. No further work has be done
so far, the state transitions are probably still incomplete
and/or wrong, but NAT seems to work in some quick testing.

If you're going to test it, please let me know about problems.



--------------000200010309020806040009
Content-Type: text/x-patch;
 name="dccp-conntrack-nat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dccp-conntrack-nat.diff"

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 116fcac..177869e 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -71,6 +71,7 @@ enum ctattr_l4proto {
 enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
 	CTA_PROTOINFO_TCP,
+	CTA_PROTOINFO_DCCP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
@@ -82,6 +83,13 @@ enum ctattr_protoinfo_tcp {
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
 
+enum ctattr_protoinfo_dccp {
+	CTA_PROTOINFO_DCCP_UNSPEC,
+	CTA_PROTOINFO_DCCP_STATE,
+	__CTA_PROTOINFO_DCCP_MAX
+};
+#define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
+
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
 	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index b3432ab..df974f1 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -14,6 +14,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_proto_gre.h>
 #include <linux/netfilter_ipv4/ip_conntrack_sctp.h>
+#include <linux/netfilter_ipv4/ip_conntrack_dccp.h>
 
 /* per conntrack: protocol private data */
 union ip_conntrack_proto {
@@ -22,6 +23,7 @@ union ip_conntrack_proto {
 	struct ip_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
 	struct ip_ct_icmp icmp;
+	struct ip_ct_dccp dccp;
 };
 
 union ip_conntrack_expect_proto {
diff --git a/include/linux/netfilter_ipv4/ip_conntrack_dccp.h b/include/linux/netfilter_ipv4/ip_conntrack_dccp.h
new file mode 100644
index 0000000..7751057
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ip_conntrack_dccp.h
@@ -0,0 +1,28 @@
+#ifndef _IP_CONNTRACK_DCCP_H
+#define _IP_CONNTRACK_DCCP_H
+
+/* Exposed to userspace over nfnetlink */
+enum dccp_ct_states {
+	CT_DCCP_NONE,
+	CT_DCCP_REQ_SENT,
+	CT_DCCP_RES_RCVD,
+	CT_DCCP_PART_OPEN,
+	CT_DCCP_OPEN,
+	CT_DCCP_CLOSE_REQ,
+	CT_DCCP_CLOSING,
+	CT_DCCP_CLOSED,
+	CT_DCCP_TIME_WAIT,
+	CT_DCCP_IGNORE,
+	CT_DCCP_MAX,
+};
+
+#ifdef __KERNEL__
+
+struct ip_ct_dccp
+{
+	u_int8_t	state;
+};
+
+#endif /* __KERNEL__ */
+
+#endif /* _IP_CONNTRACK_DCCP_H */
diff --git a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
index 2fdabdb..c15a169 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
@@ -32,6 +32,9 @@ union ip_conntrack_manip_proto
 		u_int16_t port;
 	} sctp;
 	struct {
+		u_int16_t port;
+	} dccp;
+	struct {
 		__be16 key;	/* key is 32bit, pptp only uses 16 */
 	} gre;
 };
@@ -68,6 +71,9 @@ struct ip_conntrack_tuple
 				u_int16_t port;
 			} sctp;
 			struct {
+				u_int16_t port;
+			} dccp;
+			struct {
 				__be16 key;	/* key is 32bit, 
 						 * pptp only uses 16 */
 			} gre;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 6bc03c9..c771634 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -477,6 +477,15 @@ enum
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
 	NET_IPV4_NF_CONNTRACK_COUNT=27,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_REQ_SENT=28,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_RES_RCVD=29,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_PART_OPEN=30,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_OPEN=31,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSE_REQ=32,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSING=33,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSED=34,
+	NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_TIME_WAIT=35,
+	NET_IPV4_NF_CONNTRACK_DCCP_LOOSE=36,
 };
  
 /* /proc/sys/net/ipv6 */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9d3c8b5..22fb86d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -83,6 +83,14 @@ config IP_NF_CT_PROTO_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+config IP_NF_CT_PROTO_DCCP
+	tristate "DCCP protocol connection tracking support (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK && EXPERIMENTAL
+	help
+	  This option enables connection tracking support for the DCCP protocol.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_FTP
 	tristate "FTP protocol support"
 	depends on IP_NF_CONNTRACK
@@ -589,6 +597,14 @@ config IP_NF_NAT_NEEDED
 	depends on IP_NF_NAT != n
 	default y
 
+config IP_NF_NAT_PROTO_DCCP
+	tristate "DCCP protocol NAT support (EXPERIMENTAL)"
+	depends on IP_NF_CT_PROTO_DCCP && IP_NF_NAT && EXPERIMENTAL
+	help
+	  This option enables NAT support for the DCCP protocol.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	depends on IP_NF_NAT
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 058c48e..b601df3 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -17,8 +17,9 @@ obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conn
 obj-$(CONFIG_IP_NF_CONNTRACK_NETLINK) += ip_conntrack_netlink.o
 
 
-# SCTP protocol connection tracking
+# protocol connection tracking helpers
 obj-$(CONFIG_IP_NF_CT_PROTO_SCTP) += ip_conntrack_proto_sctp.o
+obj-$(CONFIG_IP_NF_CT_PROTO_DCCP) += ip_conntrack_proto_dccp.o
 
 # connection tracking helpers
 obj-$(CONFIG_IP_NF_PPTP) += ip_conntrack_pptp.o
@@ -28,6 +29,9 @@ obj-$(CONFIG_IP_NF_FTP) += ip_conntrack_
 obj-$(CONFIG_IP_NF_IRC) += ip_conntrack_irc.o
 obj-$(CONFIG_IP_NF_NETBIOS_NS) += ip_conntrack_netbios_ns.o
 
+# protocol NAT helpers
+obj-$(CONFIG_IP_NF_NAT_PROTO_DCCP) += ip_nat_proto_dccp.o
+
 # NAT helpers 
 obj-$(CONFIG_IP_NF_NAT_PPTP) += ip_nat_pptp.o
 obj-$(CONFIG_IP_NF_NAT_AMANDA) += ip_nat_amanda.o
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_dccp.c b/net/ipv4/netfilter/ip_conntrack_proto_dccp.c
new file mode 100644
index 0000000..f90e152
--- /dev/null
+++ b/net/ipv4/netfilter/ip_conntrack_proto_dccp.c
@@ -0,0 +1,741 @@
+/*
+ * DCCP connection tracking protocol helper
+ *
+ * (c) 2005 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/sysctl.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/dccp.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("DCCP connection tracking protocol helper");
+MODULE_LICENSE("GPL");
+
+static DEFINE_SPINLOCK(dccp_lock);
+
+static int ip_ct_dccp_loose = 1;
+
+#define DCCP_MSL (2 * 60 * HZ)
+static unsigned long ip_ct_dccp_timeout_req_sent	= DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_res_rcvd	= 4 * DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_part_open	= 4 * DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_open		= 5 * 86400 * HZ;
+static unsigned long ip_ct_dccp_timeout_close_req	= DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_closing		= DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_closed		= DCCP_MSL;
+static unsigned long ip_ct_dccp_timeout_time_wait	= 2 * DCCP_MSL;
+
+static char *dccp_state_names[] = {
+	[CT_DCCP_NONE]		= "NONE",
+	[CT_DCCP_REQ_SENT]	= "REQUEST_SENT",
+	[CT_DCCP_RES_RCVD]	= "RESONSE_RCVD",
+	[CT_DCCP_PART_OPEN]	= "PART_OPEN",
+	[CT_DCCP_OPEN]		= "OPEN",
+	[CT_DCCP_CLOSE_REQ]	= "CLOSE_REQ",
+	[CT_DCCP_CLOSING]	= "CLOSING",
+	[CT_DCCP_CLOSED]	= "CLOSED",
+	[CT_DCCP_TIME_WAIT]	= "TIME_WAIT",
+	[CT_DCCP_IGNORE]	= "IGNORE",
+	[CT_DCCP_MAX]		= "INVALID",
+};
+
+static unsigned long *dccp_timeout[] = {
+	[CT_DCCP_REQ_SENT]	= &ip_ct_dccp_timeout_req_sent,
+	[CT_DCCP_RES_RCVD]	= &ip_ct_dccp_timeout_res_rcvd,
+	[CT_DCCP_PART_OPEN]	= &ip_ct_dccp_timeout_part_open,
+	[CT_DCCP_OPEN]		= &ip_ct_dccp_timeout_open,
+	[CT_DCCP_CLOSE_REQ]	= &ip_ct_dccp_timeout_close_req,
+	[CT_DCCP_CLOSING]	= &ip_ct_dccp_timeout_closing,
+	[CT_DCCP_CLOSED]	= &ip_ct_dccp_timeout_closed,
+	[CT_DCCP_TIME_WAIT]	= &ip_ct_dccp_timeout_time_wait,
+};
+
+#define sNO	CT_DCCP_NONE
+#define sRS	CT_DCCP_REQ_SENT
+#define sRR	CT_DCCP_RES_RCVD
+#define sPO	CT_DCCP_PART_OPEN
+#define sOP	CT_DCCP_OPEN
+#define sCR	CT_DCCP_CLOSE_REQ
+#define sCG	CT_DCCP_CLOSING
+#define sCL	CT_DCCP_CLOSED
+#define sTW	CT_DCCP_TIME_WAIT
+#define sIG	CT_DCCP_IGNORE
+#define sIV	CT_DCCP_MAX
+
+static u_int8_t dccp_state_table[IP_CT_DIR_MAX][10][CT_DCCP_MAX] = {
+	[IP_CT_DIR_ORIGINAL] = {
+		[DCCP_PKT_REQUEST] = {
+		/*
+		 * sNO -> sRS	Regular request
+		 * sRS -> sRS	Retransmitted request
+		 * sRR -> sIG	Late retransmitted request
+		 * sPO -> sIG	Request during partopen state, server will ignore it
+		 * sOP -> sIG	Request during open state: server will ignore it
+		 * sCR -> sIG
+		 * sCG -> sIG
+		 * sCL -> sRS	Server is expected to be in listen not in closed state
+		 * sIW -> sIG	Time-wait
+		 *
+		 *      sNO, sRS, sRR, sPO. sOP, sCR, sCG, sCL, sTW, */
+			sRS, sRS, sIG, sIG, sIG, sIG, sIG, sRS, sIG,
+		},
+		[DCCP_PKT_RESPONSE] = {
+		/*
+		 * A response in the original directory is always invalid.
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV,
+		},
+		[DCCP_PKT_ACK] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sPO	ACK for response
+		 * sPO -> sPO	retransmitted ACK for response
+		 * sOP -> sOP	regular ACK
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sOP, sIV, sPO, sPO, sOP, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_DATA] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sIV	must use data-ack in part_open state
+		 * sOP -> sOP	regular data packet
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sIV, sOP, sIV, sIV, sIV, sIV,
+		},
+		[DCCP_PKT_DATAACK] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sPO	stay in part_open state
+		 * sOP -> sOP
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sPO, sOP, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_CLOSEREQ] = {
+		/*
+		 * CLOSEREQ may only be sent by the server.
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_CLOSE] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sIV
+		 * sOP -> sCG
+		 * sCR -> sCG
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sIV, sCG, sCG, sIV, sIV, sIV
+		},
+		[DCCP_PKT_RESET] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sCL
+		 * sRR -> sCL
+		 * sPO -> sCL
+		 * sOP -> sCL
+		 * sCR -> sCL
+		 * sCG -> sCL
+		 * sCL -> sCL
+		 * sIW -> sCL
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sCL, sCL, sCL, sCL, sCL, sCL, sTW, sTW
+		},
+		[DCCP_PKT_SYNC] = {
+		/*
+		 * sNO ->
+		 * sRS ->
+		 * sRR ->
+		 * sPO ->
+		 * sOP ->
+		 * sCR ->
+		 * sCG ->
+		 * sCL ->
+		 * sIW ->
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+		},
+		[DCCP_PKT_SYNCACK] = {
+		/*
+		 * sNO ->
+		 * sRS ->
+		 * sRR ->
+		 * sPO ->
+		 * sOP ->
+		 * sCR ->
+		 * sCG ->
+		 * sCL ->
+		 * sIW ->
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+		},
+	},
+	[IP_CT_DIR_REPLY] = {
+		[DCCP_PKT_REQUEST] = {
+		/*
+		 * A request in the reply direction is always invalid.
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_RESPONSE] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sRR	response to clients request
+		 * sRR -> sIV
+		 * sPO -> sIV
+		 * sOP -> sIV
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sRR, sIV, sIV, sIV, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_ACK] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sOP	Enter open state (8.1.5)
+		 * sOP -> sOP
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sOP, sOP, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_DATA] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sOP	Enter open state (8.1.5)
+		 * sOP -> sOP
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sOP, sOP, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_DATAACK] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sOP	Enter open state (8.1.5)
+		 * sOP -> sOP
+		 * sCR -> sIV
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sOP, sOP, sIV, sIV, sIV, sIV
+		},
+		[DCCP_PKT_CLOSEREQ] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sOP -> sCR	Move directly top CLOSE_REQ (8.1.5)
+		 * sOP -> sCR
+		 * sCR -> sCR	retransmit
+		 * sCG -> sIV
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sCR, sCR, sCR, sIV, sIV, sIV
+		},
+		[DCCP_PKT_CLOSE] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sIV
+		 * sRR -> sIV
+		 * sPO -> sOP -> sCG	Move direcly to CLOSING
+		 * sOP -> sCG
+		 * sCR -> sCG
+		 * sCG -> sCG	retransmit
+		 * sCL -> sIV
+		 * sIW -> sIV
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sIV, sIV, sCG, sCG, sCG, sCG, sIV, sIV
+		},
+		[DCCP_PKT_RESET] = {
+		/*
+		 * sNO -> sIV
+		 * sRS -> sCL
+		 * sRR -> sCL
+		 * sPO -> sCL
+		 * sOP -> sCL
+		 * sCR -> sCL
+		 * sCG -> sCL
+		 * sCL -> sCL
+		 * sIW -> sCL
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+			sIV, sCL, sCL, sCL, sCL, sCL, sCL, sTW, sTW
+		},
+		[DCCP_PKT_SYNC] = {
+		/*
+		 * sNO ->
+		 * sRS ->
+		 * sRR ->
+		 * sPO ->
+		 * sOP ->
+		 * sCR ->
+		 * sCG ->
+		 * sCL ->
+		 * sIW ->
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+		},
+		[DCCP_PKT_SYNCACK] = {
+		/*
+		 * sNO ->
+		 * sRS ->
+		 * sRR ->
+		 * sPO ->
+		 * sOP ->
+		 * sCR ->
+		 * sCG ->
+		 * sCL ->
+		 * sIW ->
+		 *
+		 *      sNO, sRS, sRR, sPO, sOP, sCR, sCG, sCL, sTW */
+		},
+	},
+};
+
+static int dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                             struct ip_conntrack_tuple *tuple)
+{
+	struct dccp_hdr _hdr, *dh;
+
+	dh = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	if (dh == NULL)
+		return 0;
+	tuple->src.u.dccp.port = dh->dccph_sport;
+	tuple->dst.u.dccp.port = dh->dccph_dport;
+	return 1;
+}
+
+static int dccp_invert_tuple(struct ip_conntrack_tuple *inv,
+                             const struct ip_conntrack_tuple *tuple)
+{
+	inv->src.u.dccp.port = tuple->dst.u.dccp.port;
+	inv->dst.u.dccp.port = tuple->src.u.dccp.port;
+	return 1;
+}
+
+static int dccp_new(struct ip_conntrack *ct, const struct sk_buff *skb)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct dccp_hdr _dh, *dh;
+	char *logmsg;
+	u_int8_t state;
+
+	dh = skb_header_pointer(skb, iph->ihl * 4, sizeof(_dh), &dh);
+	BUG_ON(dh == NULL);
+
+	state = dccp_state_table[IP_CT_DIR_ORIGINAL][dh->dccph_type][CT_DCCP_NONE];
+	if (state >= CT_DCCP_MAX) {
+		logmsg = "ip_ct_dccp: invalid state transition ";
+		goto out_invalid;
+	}
+
+	if (state == CT_DCCP_REQ_SENT) {
+		;
+	} else if (ip_ct_dccp_loose == 0) {
+		logmsg = "ip_ct_dccp: not picking up existing connection ";
+		goto out_invalid;
+	}
+
+	ct->proto.dccp.state = CT_DCCP_NONE;
+	return 1;
+
+out_invalid:
+	if (LOG_INVALID(IPPROTO_DCCP))
+		nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL, logmsg);
+	return 0;
+}
+
+static int dccp_packet(struct ip_conntrack *ct, const struct sk_buff *skb,
+                       enum ip_conntrack_info ctinfo)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct dccp_hdr _dh, *dh;
+	u_int8_t type, state;
+
+	dh = skb_header_pointer(skb, iph->ihl * 4, sizeof(_dh), &dh);
+	BUG_ON(dh == NULL);
+	type = dh->dccph_type;
+
+	spin_lock_bh(&dccp_lock);
+	state = ct->proto.dccp.state;
+	state = dccp_state_table[CTINFO2DIR(ctinfo)][type][state];
+	ct->proto.dccp.state = state;
+	spin_unlock_bh(&dccp_lock);
+
+	switch (state) {
+	case CT_DCCP_IGNORE:
+	case CT_DCCP_MAX:
+		return -NF_ACCEPT;
+	}
+
+	if (type == DCCP_PKT_RESET &&
+	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (del_timer(&ct->timeout))
+			ct->timeout.function((unsigned long)ct);
+		return NF_ACCEPT;
+	}
+
+	ip_ct_refresh_acct(ct, ctinfo, skb, *dccp_timeout[state]);
+	return NF_ACCEPT;
+}
+
+static int dccp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+                      unsigned int hooknum)
+{
+	struct iphdr *iph = skb->nh.iph;
+	struct dccp_hdr _dh, *dh;
+	unsigned int dccp_len = skb->len - iph->ihl * 4;
+	unsigned int csum_len;
+	char *logmsg;
+
+	dh = skb_header_pointer(skb, iph->ihl * 4, sizeof(_dh), &dh);
+	if (dh == NULL) {
+		logmsg = "ip_ct_dccp: short packet ";
+		goto out_invalid;
+	}
+
+	if (dh->dccph_doff * 4 < sizeof(struct dccp_hdr) ||
+	    dh->dccph_doff * 4 > dccp_len) {
+		logmsg = "ip_ct_dccp: truncated/malformed packet ";
+		goto out_invalid;
+	}
+
+	csum_len = dccp_len;
+	if (dh->dccph_cscov) {
+		csum_len = (dh->dccph_cscov - 1) * 4;
+		if (csum_len > dccp_len) {
+			logmsg = "ip_ct_dccp: bad checksum coverage ";
+			goto out_invalid;
+		}
+	}
+
+	if (hooknum == NF_IP_PRE_ROUTING &&
+	    skb->ip_summed != CHECKSUM_UNNECESSARY &&
+	    csum_tcpudp_magic(iph->saddr, iph->daddr, dccp_len, IPPROTO_DCCP,
+	                      skb->ip_summed == CHECKSUM_HW ? skb->csum
+	                      : skb_checksum(skb, iph->ihl * 4, csum_len, 0))) {
+		logmsg = "ip_ct_dccp: bad checksum ";
+		goto out_invalid;
+	}
+
+	if (dh->dccph_type >= DCCP_PKT_INVALID) {
+		logmsg = "ip_ct_dccp: reserved packet type ";
+		goto out_invalid;
+	}
+
+	return NF_ACCEPT;
+
+out_invalid:
+	if (LOG_INVALID(IPPROTO_DCCP))
+		nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL, logmsg);
+	return -NF_ACCEPT;
+}
+
+static int dccp_print_tuple(struct seq_file *s,
+                            const struct ip_conntrack_tuple *tuple)
+{
+	return seq_printf(s, "sport=%hu dport=%hu ",
+	                  ntohs(tuple->src.u.dccp.port),
+			  ntohs(tuple->dst.u.dccp.port));
+}
+
+static int dccp_print_conntrack(struct seq_file *s,
+                                const struct ip_conntrack *ct)
+{
+	return seq_printf(s, "%s ", dccp_state_names[ct->proto.dccp.state]);
+}
+
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+static int dccp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
+                          const struct ip_conntrack *ct)
+{
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_DCCP);
+
+	read_lock_bh(&dccp_lock);
+	NFA_PUT(skb, CTA_PROTOINFO_DCCP_STATE, sizeof(u_int8_t),
+	        &ct->proto.dccp.state);
+	read_unlock_bh(&dccp_lock);
+	NFA_NEST_END(skb, nest_parms);
+	return 0;
+
+nfattr_failure:
+	read_unlock_bh(&dccp_lock);
+	return -1;
+}
+
+static const size_t cta_min_dccp[CTA_PROTOINFO_DCCP_MAX] = {
+	[CTA_PROTOINFO_DCCP_STATE-1]	= sizeof(u_int8_t),
+};
+
+static int nfattr_to_dccp(struct nfattr *cda[], struct ip_conntrack *ct)
+{
+	struct nfattr *attr = cda[CTA_PROTOINFO_DCCP-1];
+	struct nfattr *tb[CTA_PROTOINFO_DCCP_MAX];
+
+	if (!attr)
+		return 0;
+
+	nfattr_parse_nested(tb, CTA_PROTOINFO_DCCP_MAX, attr);
+	if (nfattr_bad_size(tb, CTA_PROTOINFO_DCCP_MAX, cta_min_dccp))
+		return -EINVAL;
+	if (!tb[CTA_PROTOINFO_DCCP_STATE-1])
+		return -EINVAL;
+
+	write_lock_bh(&dccp_lock);
+	ct->proto.dccp.state =
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_STATE-1]);
+	write_unlock_bh(&dccp_lock);
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_SYSCTL
+static ctl_table dccp_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_REQ_SENT,
+		.procname	= "ip_conntrack_dccp_timeout_req_sent",
+		.data		= &ip_ct_dccp_timeout_req_sent,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_req_sent),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_REQ_SENT,
+		.procname	= "ip_conntrack_dccp_timeout_res_rcvd",
+		.data		= &ip_ct_dccp_timeout_res_rcvd,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_res_rcvd),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_PART_OPEN,
+		.procname	= "ip_conntrack_dccp_timeout_part_open",
+		.data		= &ip_ct_dccp_timeout_part_open,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_part_open),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_OPEN,
+		.procname	= "ip_conntrack_dccp_timeout_open",
+		.data		= &ip_ct_dccp_timeout_open,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_open),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSE_REQ,
+		.procname	= "ip_conntrack_dccp_timeout_close_req",
+		.data		= &ip_ct_dccp_timeout_close_req,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_close_req),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSING,
+		.procname	= "ip_conntrack_dccp_timeout_closing",
+		.data		= &ip_ct_dccp_timeout_closing,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_closing),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_CLOSED,
+		.procname	= "ip_conntrack_dccp_timeout_closed",
+		.data		= &ip_ct_dccp_timeout_closed,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_closed),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_TIMEOUT_TIME_WAIT,
+		.procname	= "ip_conntrack_dccp_timeout_time_wait",
+		.data		= &ip_ct_dccp_timeout_time_wait,
+		.maxlen		= sizeof(ip_ct_dccp_timeout_time_wait),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_DCCP_LOOSE,
+		.procname	= "ip_conntrack_dccp_loose",
+		.data		= &ip_ct_dccp_loose,
+		.maxlen		= sizeof(ip_ct_dccp_loose),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0,
+	}
+};
+
+static ctl_table ip_ct_netfilter_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NETFILTER,
+		.procname	= "netfilter",
+		.mode		= 0555,
+		.child		= dccp_sysctl_table,
+	},
+	{
+		.ctl_name	= 0,
+	}
+};
+
+static ctl_table ip_ct_ipv4_table[] = {
+	{
+		.ctl_name	= NET_IPV4,
+		.procname	= "ipv4",
+		.mode		= 0555,
+		.child		= ip_ct_netfilter_table,
+	},
+	{
+		.ctl_name	= 0,
+	}
+};
+
+static ctl_table ip_ct_net_table[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.mode		= 0555,
+		.child		= ip_ct_ipv4_table,
+	},
+	{
+		.ctl_name	= 0,
+	}
+
+};
+
+static struct ctl_table_header *ip_ct_sysctl_header;
+
+static int dccp_sysctl_register(void)
+{
+	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
+	if (ip_ct_sysctl_header != NULL)
+		return 0;
+	return -ENOMEM;
+}
+
+static void dccp_sysctl_unregister(void)
+{
+	unregister_sysctl_table(ip_ct_sysctl_header);
+}
+#else
+static int dccp_sysctl_register(void)
+{
+	return 0;
+}
+
+static void dccp_sysctl_unregister(void)
+{
+	return;
+}
+#endif
+
+static struct ip_conntrack_protocol dccp_proto = {
+	.proto			= IPPROTO_DCCP,
+	.name			= "dccp",
+	.pkt_to_tuple		= dccp_pkt_to_tuple,
+	.invert_tuple		= dccp_invert_tuple,
+	.new			= dccp_new,
+	.packet			= dccp_packet,
+	.error			= dccp_error,
+	.print_tuple		= dccp_print_tuple,
+	.print_conntrack	= dccp_print_conntrack,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.to_nfattr		= dccp_to_nfattr,
+	.from_nfattr		= nfattr_to_dccp,
+	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
+	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
+#endif
+};
+
+static int __init init(void)
+{
+	int err;
+
+	err = ip_conntrack_protocol_register(&dccp_proto);
+	if (err)
+		goto err1;
+	err = dccp_sysctl_register();
+	if (err)
+		goto err2;
+	return 0;
+
+err2:
+	ip_conntrack_protocol_unregister(&dccp_proto);
+err1:
+	return err;
+}
+
+static void __exit fini(void)
+{
+	dccp_sysctl_unregister();
+	ip_conntrack_protocol_unregister(&dccp_proto);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/ipv4/netfilter/ip_nat_proto_dccp.c b/net/ipv4/netfilter/ip_nat_proto_dccp.c
new file mode 100644
index 0000000..a700cf0
--- /dev/null
+++ b/net/ipv4/netfilter/ip_nat_proto_dccp.c
@@ -0,0 +1,196 @@
+/*
+ * DCCP NAT protocol helper
+ *
+ * (c) 2005 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/dccp.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_protocol.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("DCCP NAT protocol helper");
+MODULE_LICENSE("GPL");
+
+static int
+dccp_in_range(const struct ip_conntrack_tuple *tuple,
+              enum ip_nat_manip_type maniptype,
+              const union ip_conntrack_manip_proto *min,
+              const union ip_conntrack_manip_proto *max)
+{
+	u_int16_t port;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		port = tuple->src.u.dccp.port;
+	else
+		port = tuple->dst.u.dccp.port;
+
+	return ntohs(port) >= ntohs(min->dccp.port) &&
+	       ntohs(port) <= ntohs(max->dccp.port);
+}
+
+static int
+dccp_unique_tuple(struct ip_conntrack_tuple *tuple,
+                  const struct ip_nat_range *range,
+                  enum ip_nat_manip_type maniptype,
+		  const struct ip_conntrack *ct)
+{
+	static u_int16_t port;
+	u_int16_t *portptr;
+	unsigned int range_size, min, i;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		portptr = &tuple->src.u.dccp.port;
+	else
+		portptr = &tuple->dst.u.dccp.port;
+
+	/* If no range specified... */
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
+		/* If it's dst rewrite, can't change port */
+		if (maniptype == IP_NAT_MANIP_DST)
+			return 0;
+
+		/* Map privileged onto privileged. */
+		if (ntohs(*portptr) < 1024) {
+			/* Loose convention: >> 512 is credential passing */
+			if (ntohs(*portptr)<512) {
+				min = 1;
+				range_size = 511 - min + 1;
+			} else {
+				min = 600; 
+				range_size = 1023 - min + 1;
+			}
+		} else {
+			min = 1024;
+			range_size = 65535 - 1024 + 1;
+		}
+	} else {
+		min = ntohs(range->min.dccp.port);
+		range_size = ntohs(range->max.dccp.port) - min + 1;
+	}
+
+	for (i = 0; i < range_size; i++, port++) {
+		*portptr = htons(min + port % range_size);
+		if (!ip_nat_used_tuple(tuple, ct)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int
+dccp_manip_pkt(struct sk_buff **pskb,
+               unsigned int iphdroff,
+               const struct ip_conntrack_tuple *tuple,
+               enum ip_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	struct dccp_hdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl * 4;
+	u_int32_t oldip, newip;
+	u_int16_t *portptr, oldport, newport;
+	int hdrsize = 8; /* DCCP connection tracking guarantees this much */
+
+	if ((*pskb)->len >= hdroff + sizeof(struct dccp_hdr))
+		hdrsize = sizeof(struct dccp_hdr);
+
+	if (!skb_make_writable(pskb, hdroff + hdrsize))
+		return 0;
+
+	iph = (struct iphdr *)((*pskb)->data + iphdroff);
+	hdr = (struct dccp_hdr *)((*pskb)->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		oldip = iph->saddr;
+		newip = tuple->src.ip;
+		newport = tuple->src.u.dccp.port;
+		portptr = &hdr->dccph_sport;
+	} else {
+		oldip = iph->daddr;
+		newip = tuple->dst.ip;
+		newport = tuple->dst.u.dccp.port;
+		portptr = &hdr->dccph_dport;
+	}
+
+	oldport = *portptr;
+	*portptr = newport;
+
+	if (hdrsize < sizeof(*hdr))
+		return 1;
+	hdr->dccph_checksum = ip_nat_cheat_check(~oldip, newip,
+	                               ip_nat_cheat_check(oldport ^ 0xFFFF,
+	                                                  newport,
+	                                                  hdr->dccph_checksum));
+	return 1;
+}
+
+static unsigned int
+dccp_print(char *buffer,
+           const struct ip_conntrack_tuple *match,
+           const struct ip_conntrack_tuple *mask)
+{
+	unsigned int len = 0;
+
+	if (mask->src.u.dccp.port)
+		len += sprintf(buffer + len, "srcpt=%u ",
+		               ntohs(match->src.u.dccp.port));
+	if (mask->dst.u.dccp.port)
+		len += sprintf(buffer + len, "dstpt=%u ",
+		               ntohs(match->dst.u.dccp.port));
+	return len;
+}
+
+static unsigned int
+dccp_print_range(char *buffer, const struct ip_nat_range *range)
+{
+	if (range->min.dccp.port != 0 || range->max.dccp.port != 0xFFFF) {
+		if (range->min.dccp.port == range->max.dccp.port)
+			return sprintf(buffer, "port %u ",
+			               ntohs(range->min.dccp.port));
+		else
+			return sprintf(buffer, "ports %u-%u ",
+			               ntohs(range->min.dccp.port),
+			               ntohs(range->max.dccp.port));
+	}
+	return 0;
+}
+
+static struct ip_nat_protocol ip_nat_proto_dccp = {
+	.name			= "DCCP",
+	.protonum		= IPPROTO_DCCP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= dccp_manip_pkt,
+	.in_range		= dccp_in_range,
+	.unique_tuple		= dccp_unique_tuple,
+	.print			= dccp_print,
+	.print_range		= dccp_print_range,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
+	.nfattr_to_range	= ip_nat_port_nfattr_to_range,
+#endif
+};
+
+static int __init init(void)
+{
+	return ip_nat_protocol_register(&ip_nat_proto_dccp);
+}
+
+static void __exit fini(void)
+{
+	ip_nat_protocol_unregister(&ip_nat_proto_dccp);
+}
+
+module_init(init);
+module_exit(fini);

--------------000200010309020806040009--
