From: sam@cerbere.dyndns.info (Samir Bellabes)
Subject: ip_conntrack_count broken - kernel 2.6 - New patch
Date: Sun, 15 Aug 2004 15:17:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040815131740.GA23767@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Harald,
   The ip_conntrack_count is broken with kernel 2.6.8.
   This patch, which do the same thing, applies correctly.

thanks.

-- 
samir bellabes
sam@cerbere.dyndns.info

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6-ip_conntrack_count.patch"

diff -Nru --exclude '*~' linux-2.6.8/include/linux/sysctl.h linux-2.6.8-conntrack_count/include/linux/sysctl.h
--- linux-2.6.8/include/linux/sysctl.h	2004-08-15 03:34:57.000000000 +0200
+++ linux-2.6.8-conntrack_count/include/linux/sysctl.h	2004-08-15 03:47:25.000000000 +0200
@@ -410,6 +410,7 @@
 	NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT=12,
 	NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT=13,
 	NET_IPV4_NF_CONNTRACK_BUCKETS=14,
+	NET_IPV4_NF_CONNTRACK_COUNT=15,
 };
  
 /* /proc/sys/net/ipv6 */
diff -Nru --exclude '*~' linux-2.6.8/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.8-conntrack_count/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.8/net/ipv4/netfilter/ip_conntrack_core.c	2004-08-15 03:34:58.000000000 +0200
+++ linux-2.6.8-conntrack_count/net/ipv4/netfilter/ip_conntrack_core.c	2004-08-15 03:42:59.000000000 +0200
@@ -65,7 +65,7 @@
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size = 0;
 int ip_conntrack_max;
-static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
+atomic_t ip_conntrack_count = ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
 struct ip_conntrack ip_conntrack_untracked;
diff -Nru --exclude '*~' linux-2.6.8/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.8-conntrack_count/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.8/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-15 03:34:58.000000000 +0200
+++ linux-2.6.8-conntrack_count/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-15 03:46:11.000000000 +0200
@@ -312,6 +312,7 @@
 
 /* From ip_conntrack_core.c */
 extern int ip_conntrack_max;
+extern atomic_t ip_conntrack_count;
 extern unsigned int ip_conntrack_htable_size;
 
 /* From ip_conntrack_proto_tcp.c */
@@ -346,6 +347,14 @@
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_COUNT,
+		.procname	= "ip_conntrack_count",
+		.data		= &ip_conntrack_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
 		.procname	= "ip_conntrack_buckets",
 		.data		= &ip_conntrack_htable_size,

--OXfL5xGRrasGEqWY--
