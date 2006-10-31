From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [RFC][NETFILTER]: ip6_tables: fixed conflicted optname for
 getsockopt
Date: Tue, 31 Oct 2006 21:10:46 +0900 (JST)
Message-ID: <200610311210.k9VCAmMs009424@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, yoshfuji@linux-ipv6.org
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


Hi all,

I've noticed that 66 and 67 for getsockopt on IPv6 socket are doubly used
by IPv6 Advanced API and Netfilter ip6tables.

The following patch changes numbers for Netfilter to 68 and 69.
That doesn't change the behavior of old userland binary.

What do you think ?

In detail:

These numbers are defined in include/linux/in6.h and
include/linux/netfilter_ipv6/ip6_tables.h
(via include/linux/netfilter/x_tables).

66:	IPV6_RECVTCLASS and IP6T_GET_REVISION_MATCH
67:	IPV6_TCLASS     and IP6T_GET_REVISION_TARGET

The current kernel always calls functions of Advanced API for them,
and return 0 which means success for IP6T_GET_REVISION_{MATCH,TARGET}.
Then userland tool might believe that newer revision of match/target is
supported.

Currently I cannot see big problem on this because userland tools can
use newer revision in kernel anyway. But clearly they should be fixed.

The following patch changes numbers for Netfilter to 68 and 69.
An other possible solution is to distinguish them by something like
optlen of getsockopt argument, but I'm not sure this is best.

BTW, I didn't moves the definitions for numbers of getsockopt in
ip6_tables.h to in6.h, even if it's the potential issue. Because
I want to avoid build error of userland tools such as ip6tables which
includes netinet/in.h. It has some same declarations in linux/in6.h.

-- Yasuyui Kozakai


[NETFILTER]: ip6_tables: fixed conflicted optname for getsockopt

66 and 67 for getsockopt on IPv6 socket is doubly used for IPv6 Advanced
API and ip6tables. This moves numbers for ip6tables to 68 and 69.
This also kills XT_SO_* because {ip,ip6,arp}_tables doesn't have so much
common numbers now.

The old userland tools keep to behave as ever, because old kernel always
calls functions of IPv6 Advanced API for their numbers.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 7faf99b25c29a53e1e974a11044b260e6cc0f8d8
tree 3c481aa59af0eeb0fed11555503cd1a6392f2a80
parent e80391500078b524083ba51c3df01bbaaecc94bb
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 31 Oct 2006 20:23:09 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 31 Oct 2006 20:23:09 +0900

 include/linux/in6.h                       |   12 +++++++++++-
 include/linux/netfilter/x_tables.h        |   16 ----------------
 include/linux/netfilter_arp/arp_tables.h  |   23 ++++++++++++-----------
 include/linux/netfilter_ipv4/ip_tables.h  |   25 ++++++++++++++-----------
 include/linux/netfilter_ipv6/ip6_tables.h |   25 ++++++++++++++-----------
 5 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/include/linux/in6.h b/include/linux/in6.h
index 9be6a47..f28621f 100644
--- a/include/linux/in6.h
+++ b/include/linux/in6.h
@@ -225,7 +225,7 @@ struct in6_flowlabel_req
 #endif
 
 /*
- * Netfilter
+ * Netfilter (1)
  *
  * Following socket options are used in ip6_tables;
  * see include/linux/netfilter_ipv6/ip6_tables.h.
@@ -240,4 +240,14 @@ struct in6_flowlabel_req
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
@@ -96,22 +96,6 @@ struct _xt_align
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
+#define ARPT_BASE_CTL		96
 
-#define ARPT_SO_SET_REPLACE		(XT_SO_SET_REPLACE+ARPT_CTL_OFFSET)
-#define ARPT_SO_SET_ADD_COUNTERS	(XT_SO_SET_ADD_COUNTERS+ARPT_CTL_OFFSET)
-#define ARPT_SO_SET_MAX			(XT_SO_SET_MAX+ARPT_CTL_OFFSET)
-
-#define ARPT_SO_GET_INFO		(XT_SO_GET_INFO+ARPT_CTL_OFFSET)
-#define ARPT_SO_GET_ENTRIES		(XT_SO_GET_ENTRIES+ARPT_CTL_OFFSET)
-/* #define ARPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH  */
-#define ARPT_SO_GET_REVISION_TARGET	(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OFFSET)
-#define ARPT_SO_GET_MAX			(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OFFSET)
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
+ * socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in.h before adding new number here.
+ */
+#define IPT_BASE_CTL		64
 
-#define IPT_SO_SET_REPLACE	XT_SO_SET_REPLACE
-#define IPT_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
-#define IPT_SO_SET_MAX		XT_SO_SET_MAX
-
-#define IPT_SO_GET_INFO			XT_SO_GET_INFO
-#define IPT_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
-#define IPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
-#define IPT_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
-#define IPT_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
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
+ * a raw socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in6.h before adding new number here.
+ */
+#define IP6T_BASE_CTL			64
 
-#define IP6T_SO_SET_REPLACE		XT_SO_SET_REPLACE
-#define IP6T_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
-#define IP6T_SO_SET_MAX			XT_SO_SET_MAX
-
-#define IP6T_SO_GET_INFO		XT_SO_GET_INFO
-#define IP6T_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
-#define	IP6T_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
-#define	IP6T_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
-#define IP6T_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
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
