From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4]: Fix compile errors without NAT
Date: Tue, 25 Jan 2005 05:48:16 +0100
Message-ID: <41F5CF90.2020002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050902000301020701060501"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------050902000301020701060501
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------050902000301020701060501
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/25 04:10:59+01:00 gandalf@wlug.westbo.se 
#   [NETFILTER]: Fix compile errors without NAT
#   
#   This patch fixes some compile errors with NAT that has appeared
#   after all the recent patches.
#   
#   Move struct ip_conntrack_expect after the definition of struct
#   ip_conntrack. Add #ifdef CONFIG_IP_NF_NAT_NEEDED around
#   ip_nat_initialized() Add lockhelp.h to ipt_CLUSTERIP.c
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_CLUSTERIP.c
#   2005/01/25 04:10:50+01:00 gandalf@wlug.westbo.se +1 -0
#   [NETFILTER]: Fix compile errors without NAT
#   
#   This patch fixes some compile errors with NAT that has appeared
#   after all the recent patches.
#   
#   Move struct ip_conntrack_expect after the definition of struct
#   ip_conntrack. Add #ifdef CONFIG_IP_NF_NAT_NEEDED around
#   ip_nat_initialized() Add lockhelp.h to ipt_CLUSTERIP.c
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2005/01/25 04:10:50+01:00 gandalf@wlug.westbo.se +30 -27
#   [NETFILTER]: Fix compile errors without NAT
#   
#   This patch fixes some compile errors with NAT that has appeared
#   after all the recent patches.
#   
#   Move struct ip_conntrack_expect after the definition of struct
#   ip_conntrack. Add #ifdef CONFIG_IP_NF_NAT_NEEDED around
#   ip_nat_initialized() Add lockhelp.h to ipt_CLUSTERIP.c
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-25 04:37:08 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-25 04:37:08 +01:00
@@ -122,33 +122,6 @@
 #define IP_NF_ASSERT(x)
 #endif
 
-struct ip_conntrack_expect
-{
-	/* Internal linked list (global expectation list) */
-	struct list_head list;
-
-	/* We expect this tuple, with the following mask */
-	struct ip_conntrack_tuple tuple, mask;
- 
-	/* Function to call after setup and insertion */
-	void (*expectfn)(struct ip_conntrack *new,
-			 struct ip_conntrack_expect *this);
-
-	/* The conntrack of the master connection */
-	struct ip_conntrack *master;
-
-	/* Timer function; deletes the expectation. */
-	struct timer_list timeout;
-
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	/* This is the original per-proto part, used to map the
-	 * expected connection the way the recipient expects. */
-	union ip_conntrack_manip_proto saved_proto;
-	/* Direction relative to the master connection. */
-	enum ip_conntrack_dir dir;
-#endif
-};
-
 struct ip_conntrack_counter
 {
 	u_int64_t packets;
@@ -206,6 +179,33 @@
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 };
 
+struct ip_conntrack_expect
+{
+	/* Internal linked list (global expectation list) */
+	struct list_head list;
+
+	/* We expect this tuple, with the following mask */
+	struct ip_conntrack_tuple tuple, mask;
+ 
+	/* Function to call after setup and insertion */
+	void (*expectfn)(struct ip_conntrack *new,
+			 struct ip_conntrack_expect *this);
+
+	/* The conntrack of the master connection */
+	struct ip_conntrack *master;
+
+	/* Timer function; deletes the expectation. */
+	struct timer_list timeout;
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	/* This is the original per-proto part, used to map the
+	 * expected connection the way the recipient expects. */
+	union ip_conntrack_manip_proto saved_proto;
+	/* Direction relative to the master connection. */
+	enum ip_conntrack_dir dir;
+#endif
+};
+
 static inline struct ip_conntrack *
 tuplehash_to_ctrack(const struct ip_conntrack_tuple_hash *hash)
 {
@@ -301,6 +301,7 @@
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
+#ifdef CONFIG_IP_NF_NAT_NEEDED
 static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
 				     enum ip_nat_manip_type manip)
 {
@@ -308,5 +309,7 @@
 		return test_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
 	return test_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
 }
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
+
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -Nru a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-25 04:37:08 +01:00
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-25 04:37:08 +01:00
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
 
 #define CLUSTERIP_VERSION "0.6"
 

--------------050902000301020701060501--
