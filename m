From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/5]: Don't export common symbols from ipfwadm.ko
Date: Thu, 14 Oct 2004 02:18:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC5E6.40308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080802070809030506030703"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080802070809030506030703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

ip_conntrack_tcp_update is exported from both ip_conntrack and
ipfwadm, causing bogus module dependencies. This patch moves it
to ip_conntrack_standalone. ip_conntrack_count doesn't need to
be exported at all.



--------------080802070809030506030703
Content-Type: text/x-patch;
 name="2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/14 00:57:06+02:00 okir@suse.de 
#   [NETFILTER]: Don't export common symbols from ipfwadm.ko
#   
#   Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update were
#   showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
#   in modules.dep.
#   
#   Signed-off-by: Olaf Kirch <okir@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/10/14 00:56:40+02:00 okir@suse.de +3 -0
#   [NETFILTER]: Don't export common symbols from ipfwadm.ko
#   
#   Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update were
#   showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
#   in modules.dep.
#   
#   Signed-off-by: Olaf Kirch <okir@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_tcp.c
#   2004/10/14 00:56:39+02:00 okir@suse.de +0 -1
#   [NETFILTER]: Don't export common symbols from ipfwadm.ko
#   
#   Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update were
#   showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
#   in modules.dep.
#   
#   Signed-off-by: Olaf Kirch <okir@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/10/14 00:56:39+02:00 okir@suse.de +0 -1
#   [NETFILTER]: Don't export common symbols from ipfwadm.ko
#   
#   Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update were
#   showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
#   in modules.dep.
#   
#   Signed-off-by: Olaf Kirch <okir@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-14 01:36:39 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-14 01:36:39 +02:00
@@ -62,7 +62,6 @@
 
 /* ip_conntrack_standalone needs this */
 atomic_t ip_conntrack_count = ATOMIC_INIT(0);
-EXPORT_SYMBOL(ip_conntrack_count);
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-14 01:36:39 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-14 01:36:39 +02:00
@@ -737,7 +737,6 @@
 	return 1;
 }
  
-EXPORT_SYMBOL(ip_conntrack_tcp_update);
 #endif
 
 #define	TH_FIN	0x01
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-14 01:36:39 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-14 01:36:39 +02:00
@@ -903,3 +903,6 @@
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+EXPORT_SYMBOL(ip_conntrack_tcp_update);
+#endif

--------------080802070809030506030703--
