From: Olaf Kirch <okir@suse.de>
Subject: [PATCH] Don't export common symbols from ipfwadm.ko
Date: Thu, 7 Oct 2004 15:42:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041007134207.GA21992@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

As of 2.6.9-rc2, two symbols additional symbols (ip_conntrack_count and
ip_conntrack_tcp_update). These are exported from conntrack*c files
linked into both ip_conntrack.ko and ipfwadm.ko, so the symbols show
up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
in modules.dep. The patch below moves the EXPORT_SYMBOL() statements
to ip_conntrack_standalone.c.

Cheers
Olaf
-- 
Olaf Kirch     | Things that make Monday morning interesting, #1:
okir@suse.de   |        "I want to use NFS over AX25, can you help me?"
---------------+ 

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ipfwadm-symbol-cleanup


Exported kernel symbols ip_conntrack_count and ip_conntrack_tcp_update were
showing up both in ip_conntrack.ko and ipfwadm.ko, causing bogus dependencies
in modules.dep. The patch below moves the EXPORT_SYMBOL() statements to
ip_conntrack_standalone.c.

Signed-off-by: Olaf Kirch <okir@suse.de>

Index: linux-2.6.8/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.8.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-30 13:35:33.000000000 +0200
+++ linux-2.6.8/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-06 11:28:59.000000000 +0200
@@ -62,7 +62,6 @@
 
 /* ip_conntrack_standalone needs this */
 atomic_t ip_conntrack_count = ATOMIC_INIT(0);
-EXPORT_SYMBOL(ip_conntrack_count);
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
Index: linux-2.6.8/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.8.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-09-30 13:35:24.000000000 +0200
+++ linux-2.6.8/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-06 11:29:53.000000000 +0200
@@ -737,7 +737,6 @@
 	return 1;
 }
  
-EXPORT_SYMBOL(ip_conntrack_tcp_update);
 #endif
 
 #define	TH_FIN	0x01
Index: linux-2.6.8/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.8.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-30 13:35:33.000000000 +0200
+++ linux-2.6.8/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-06 11:30:34.000000000 +0200
@@ -46,6 +46,14 @@
 MODULE_LICENSE("GPL");
 
 extern atomic_t ip_conntrack_count;
+/* We export these symbols here rather than where they're defined
+ * to prevent them from showing up in ipfwadm.ko
+ */
+EXPORT_SYMBOL(ip_conntrack_count);
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+EXPORT_SYMBOL(ip_conntrack_tcp_update);
+#endif
+
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 unsigned int ip_ct_log_invalid = 0;

--a8Wt8u1KmwUX3Y2C--
