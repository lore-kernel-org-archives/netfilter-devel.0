From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 2/8]: Fix another DECLARE_MUTEX in header file
Date: Fri, 04 Mar 2005 13:18:42 +0100
Message-ID: <42285222.4010709@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/09 00:01:18+01:00 sj-netfilter@cookinglinux.org 
#   [NETFILTER]: Fix another DECLARE_MUTEX in header file
#   
#   Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/02/09 00:01:16+01:00 sj-netfilter@cookinglinux.org +1 -0
#   [NETFILTER]: Fix another DECLARE_MUTEX in header file
#   
#   Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv6/ip6_tables.h
#   2005/02/09 00:01:15+01:00 sj-netfilter@cookinglinux.org +0 -2
#   [NETFILTER]: Fix another DECLARE_MUTEX in header file
#   
#   Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-04 01:52:01 +01:00
+++ b/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-04 01:52:01 +01:00
@@ -106,8 +106,6 @@
 	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
 };
 
-static DECLARE_MUTEX(ip6t_mutex);
-
 /* Values for "flag" field in struct ip6t_ip6 (general ip6 structure). */
 #define IP6T_F_PROTO		0x01	/* Set if rule cares about upper 
 					   protocols */
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-03-04 01:52:01 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-03-04 01:52:01 +01:00
@@ -58,6 +58,7 @@
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
+static DECLARE_MUTEX(ip6t_mutex);
 
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) != 0)
