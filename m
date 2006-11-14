From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: ip6_tables: fixed conflicted optname for
	getsockopt
Date: Tue, 14 Nov 2006 08:03:31 +0100 (MET)
Message-ID: <20061114070330.13023.82132.sendpatchset@localhost.localdomain>
References: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_tables: fixed conflicted optname for getsockopt

66 and 67 for getsockopt on IPv6 socket is doubly used for IPv6 Advanced
API and ip6tables. This moves numbers for ip6tables to 68 and 69.
This also kills XT_SO_* because {ip,ip6,arp}_tables doesn't have so much
common numbers now.

The old userland tools keep to behave as ever, because old kernel always
calls functions of IPv6 Advanced API for their numbers.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 73d0810541a170f679076824e0a8765ea6017a10
tree 42dad7f440cc4a9fcc91f4825dd27cedb8605dbc
parent 0c9a47cafdd2f6db3e090359392efd64d5d027cd
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 14 Nov 2006 07:57:41 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:57:41 +0100

 include/linux/in6.h                       |   12 +++++++++++-
 include/linux/netfilter/x_tables.h        |   16 ----------------
 include/linux/netfilter_arp/arp_tables.h  |   25 +++++++++++++------------
 include/linux/netfilter_ipv4/ip_tables.h  |   27 +++++++++++++++------------
 include/linux/netfilter_ipv6/ip6_tables.h |   27 +++++++++++++++------------
 5 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/include/linux/in6.h b/include/linux/in6.h
index 9be6a47..f28621f 100644
--- a/include/linux/in6.h
+++ b/include/linux/in6.h
@@ -225,7 +225,7 @@ #define IPV6_USE_MIN_MTU	63
 #endif
 
 /*
- * Netfilter
+ * Netfilter (1)
  *
  * Following socket options are used in ip6_tables;
  * see include/linux/netfilter_ipv6/ip6_tables.h.
@@ -240,4 +240,14 @@ #endif
 #define IPV6_RECVTCLASS		66
 #define IPV6_TCLASS		67
 
+/*
+ * Netfilter (2)
+ *
+ * Following socket options are used in ip6_tables;
+ * see include/linux/netfilter_ipv6/ip6_tables.h.
+ *
+ * IP6T_SO_GET_REVISION_MATCH	68
+ * IP6T_SO_GET_REVISION_TARGET	69
+ */
+
 #endif
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 04319a7..022edfa 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -96,22 +96,6 @@ #define XT_STANDARD_TARGET ""
 /* Error verdict. */
 #define XT_ERROR_TARGET "ERROR"
 
-/*
- * New IP firewall options for [gs]etsockopt at the RAW IP level.
- * Unlike BSD Linux inherits IP options so you don't have to use a raw
- * socket for this. Instead we check rights in the calls. */
-#define XT_BASE_CTL		64	/* base for firewall socket options */
-
-#define XT_SO_SET_REPLACE	(XT_BASE_CTL)
-#define XT_SO_SET_ADD_COUNTERS	(XT_BASE_CTL + 1)
-#define XT_SO_SET_MAX		XT_SO_SET_ADD_COUNTERS
-
-#define XT_SO_GET_INFO			(XT_BASE_CTL)
-#define XT_SO_GET_ENTRIES		(XT_BASE_CTL + 1)
-#define XT_SO_GET_REVISION_MATCH	(XT_BASE_CTL + 2)
-#define XT_SO_GET_REVISION_TARGET	(XT_BASE_CTL + 3)
-#define XT_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
-
 #define SET_COUNTER(c,b,p) do { (c).bcnt = (b); (c).pcnt = (p); } while(0)
 #define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
 
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 44e39b6..0be2354 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -112,19 +112,20 @@ struct arpt_entry
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use a raw
  * socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in.h before adding new number here.
  */
-#define ARPT_CTL_OFFSET		32
-#define ARPT_BASE_CTL		(XT_BASE_CTL+ARPT_CTL_OFFSET)
-
-#define ARPT_SO_SET_REPLACE		(XT_SO_SET_REPLACE+ARPT_CTL_OFFSET)
-#define ARPT_SO_SET_ADD_COUNTERS	(XT_SO_SET_ADD_COUNTERS+ARPT_CTL_OFFSET)
-#define ARPT_SO_SET_MAX			(XT_SO_SET_MAX+ARPT_CTL_OFFSET)
-
-#define ARPT_SO_GET_INFO		(XT_SO_GET_INFO+ARPT_CTL_OFFSET)
-#define ARPT_SO_GET_ENTRIES		(XT_SO_GET_ENTRIES+ARPT_CTL_OFFSET)
-/* #define ARPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH  */
-#define ARPT_SO_GET_REVISION_TARGET	(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OFFSET)
-#define ARPT_SO_GET_MAX			(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OFFSET)
+#define ARPT_BASE_CTL		96
+
+#define ARPT_SO_SET_REPLACE		(ARPT_BASE_CTL)
+#define ARPT_SO_SET_ADD_COUNTERS	(ARPT_BASE_CTL + 1)
+#define ARPT_SO_SET_MAX			ARPT_SO_SET_ADD_COUNTERS
+
+#define ARPT_SO_GET_INFO		(ARPT_BASE_CTL)
+#define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
+/* #define ARPT_SO_GET_REVISION_MATCH	(APRT_BASE_CTL + 2) */
+#define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
+#define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
 
 /* CONTINUE verdict for targets */
 #define ARPT_CONTINUE XT_CONTINUE
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index a536bbd..4f06dad 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -101,18 +101,21 @@ struct ipt_entry
 /*
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use a raw
- * socket for this. Instead we check rights in the calls. */
-#define IPT_BASE_CTL		XT_BASE_CTL
-
-#define IPT_SO_SET_REPLACE	XT_SO_SET_REPLACE
-#define IPT_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
-#define IPT_SO_SET_MAX		XT_SO_SET_MAX
-
-#define IPT_SO_GET_INFO			XT_SO_GET_INFO
-#define IPT_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
-#define IPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
-#define IPT_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
-#define IPT_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
+ * socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in.h before adding new number here.
+ */
+#define IPT_BASE_CTL		64
+
+#define IPT_SO_SET_REPLACE	(IPT_BASE_CTL)
+#define IPT_SO_SET_ADD_COUNTERS	(IPT_BASE_CTL + 1)
+#define IPT_SO_SET_MAX		IPT_SO_SET_ADD_COUNTERS
+
+#define IPT_SO_GET_INFO			(IPT_BASE_CTL)
+#define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
+#define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
+#define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
+#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
 
 #define IPT_CONTINUE XT_CONTINUE
 #define IPT_RETURN XT_RETURN
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index d7a8e9c..4aed340 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -107,18 +107,21 @@ struct ip6t_entry
 /*
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use
- * a raw socket for this. Instead we check rights in the calls. */
-#define IP6T_BASE_CTL			XT_BASE_CTL
-
-#define IP6T_SO_SET_REPLACE		XT_SO_SET_REPLACE
-#define IP6T_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
-#define IP6T_SO_SET_MAX			XT_SO_SET_MAX
-
-#define IP6T_SO_GET_INFO		XT_SO_GET_INFO
-#define IP6T_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
-#define	IP6T_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
-#define	IP6T_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
-#define IP6T_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
+ * a raw socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in6.h before adding new number here.
+ */
+#define IP6T_BASE_CTL			64
+
+#define IP6T_SO_SET_REPLACE		(IP6T_BASE_CTL)
+#define IP6T_SO_SET_ADD_COUNTERS	(IP6T_BASE_CTL + 1)
+#define IP6T_SO_SET_MAX			IP6T_SO_SET_ADD_COUNTERS
+
+#define IP6T_SO_GET_INFO		(IP6T_BASE_CTL)
+#define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
+#define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 4)
+#define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
+#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
 
 /* CONTINUE verdict for targets */
 #define IP6T_CONTINUE XT_CONTINUE
