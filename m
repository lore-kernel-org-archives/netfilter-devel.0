From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 1/8]: Fix DECLARE_MUTEX in header file
Date: Fri, 04 Mar 2005 13:18:38 +0100
Message-ID: <4228521E.2020402@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="01.diff"
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
#   2005/02/08 16:37:27+01:00 pablo@eurodev.net 
#   [NETFILTER]: Fix DECLARE_MUTEX in header file
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_tables.c
#   2005/02/08 16:37:26+01:00 pablo@eurodev.net +2 -0
#   [NETFILTER]: Fix DECLARE_MUTEX in header file
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_tables.h
#   2005/02/08 16:37:26+01:00 pablo@eurodev.net +0 -1
#   [NETFILTER]: Fix DECLARE_MUTEX in header file
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
--- a/include/linux/netfilter_ipv4/ip_tables.h	2005-03-04 01:52:00 +01:00
+++ b/include/linux/netfilter_ipv4/ip_tables.h	2005-03-04 01:52:00 +01:00
@@ -336,7 +336,6 @@
 /*
  *	Main firewall chains definitions and global var's definitions.
  */
-static DECLARE_MUTEX(ipt_mutex);
 #ifdef __KERNEL__
 
 #include <linux/init.h>
diff -Nru a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c	2005-03-04 01:52:00 +01:00
+++ b/net/ipv4/netfilter/ip_tables.c	2005-03-04 01:52:00 +01:00
@@ -53,6 +53,8 @@
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
+static DECLARE_MUTEX(ipt_mutex);
+
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) != 0)
