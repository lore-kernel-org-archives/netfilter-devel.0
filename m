From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH]: fixed multiple bugs in ipv6 version of ULOG
Date: Mon, 14 Mar 2005 13:23:02 +0200
Message-ID: <42357416.3000008@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010508020000050101000103"
To: netfilter-devel@lists.netfilter.org
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
--------------010508020000050101000103
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

To apply, do

~  patch -p1 < ULOGv6-2.patch

in your patch-o-matic-ng directory

- -----------------

Fixes in 2.4 version:
~  - wrong dependency in Config.in
~  - patch was based on some patched 2.4 version, didn't work with vanilla
kernel

Fixes in 2.6 version:
~  - registered itself with wrong protocol family to nf_log

Cleanups in both versions:
~  - improved help
~  - dropped unnecessary includes
~  - updated author

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCNXQHxyF48ZTvn+4RAjUNAKDQq9UqvK1pUdVbdw40c727HAt+/gCg5xFk
sBiDaVyMRcj2XWmam9HLhQA=
=4iK/
-----END PGP SIGNATURE-----

--------------010508020000050101000103
Content-Type: text/x-patch;
 name="ULOGv6-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ULOGv6-2.patch"

diff -ur --exclude-from=/tmp/srcdiff.excludes.BQ5XVc -N debug-patch-o-matic-ng-20050220/ULOG/linux/Documentation/Configure.help.ladd patch-o-matic-ng-20050312/ULOG/linux/Documentation/Configure.help.ladd
--- debug-patch-o-matic-ng-20050220/ULOG/linux/Documentation/Configure.help.ladd	2005-02-15 01:27:50.000000000 +0200
+++ patch-o-matic-ng-20050312/ULOG/linux/Documentation/Configure.help.ladd	2005-03-14 12:35:46.000000000 +0200
@@ -6,7 +6,8 @@
   daemon using netlink multicast sockets; unlike the LOG target
   which can only be viewed through syslog.
 
-  This target requires the ipv4 version to be compiled as well.
+  NOTE: This target requires the ipv4 version of ULOG to be compiled as
+        well.
 
   The apropriate userspace logging daemon (ulogd) may be obtained from
   <http://www.gnumonks.org/projects/ulogd/>
diff -ur --exclude-from=/tmp/srcdiff.excludes.BQ5XVc -N debug-patch-o-matic-ng-20050220/ULOG/linux/net/ipv6/netfilter/Config.in.ladd patch-o-matic-ng-20050312/ULOG/linux/net/ipv6/netfilter/Config.in.ladd
--- debug-patch-o-matic-ng-20050220/ULOG/linux/net/ipv6/netfilter/Config.in.ladd	2005-02-15 01:27:50.000000000 +0200
+++ patch-o-matic-ng-20050312/ULOG/linux/net/ipv6/netfilter/Config.in.ladd	2005-03-14 12:47:02.000000000 +0200
@@ -1,4 +1,4 @@
     dep_tristate '    LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_FILTER
-    if [ "$CONFIG_IP_NF_TARGET_LOG" != "n" ]; then
-      dep_tristate '    ULOG target support' CONFIG_IP6_NF_TARGET_ULOG $CONFIG_IP6_NF_FILTER $CONFIG_IP_NF_TARGET_LOG
+    if [ "$CONFIG_IP_NF_TARGET_ULOG" != "n" ]; then
+      dep_tristate '    ULOG target support' CONFIG_IP6_NF_TARGET_ULOG $CONFIG_IP6_NF_FILTER $CONFIG_IP_NF_TARGET_ULOG
     fi
diff -ur --exclude-from=/tmp/srcdiff.excludes.BQ5XVc -N debug-patch-o-matic-ng-20050220/ULOG/linux/net/ipv6/netfilter/ip6t_ULOG.c patch-o-matic-ng-20050312/ULOG/linux/net/ipv6/netfilter/ip6t_ULOG.c
--- debug-patch-o-matic-ng-20050220/ULOG/linux/net/ipv6/netfilter/ip6t_ULOG.c	2005-02-15 01:27:50.000000000 +0200
+++ patch-o-matic-ng-20050312/ULOG/linux/net/ipv6/netfilter/ip6t_ULOG.c	2005-03-14 11:48:28.000000000 +0200
@@ -26,25 +26,11 @@
  */
 
 #include <linux/module.h>
-#include <linux/config.h>
-#include <linux/spinlock.h>
-#include <linux/socket.h>
-#include <linux/skbuff.h>
-#include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/netlink.h>
-#include <linux/netdevice.h>
-#include <linux/mm.h>
-#include <linux/moduleparam.h>
-#include <linux/netfilter.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <net/sock.h>
-#include <linux/bitops.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jonas Berlin <jberlin@niksula.hut.fi>");
+MODULE_AUTHOR("Jonas Berlin <xkr47@outerspace.dyndns.org>");
 MODULE_DESCRIPTION("ip6tables userspace logging module");
 
 #if 0
@@ -54,47 +40,24 @@
 #define DEBUGP(format, args...)
 #endif
 
-static unsigned int nflog = 1;
-module_param(nflog, int, 0400);
-MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
-
 // from ipt_ULOG.c
-void ipt_ulog_packet(unsigned int hooknum,
-		     const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const struct ipt_ulog_info *loginfo,
-		     const char *prefix);
+unsigned int ipt_ulog_target(struct sk_buff **pskb,
+			     unsigned int hooknum,
+			     const struct net_device *in,
+			     const struct net_device *out,
+			     const void *targinfo, void *userinfo);
 
 static unsigned int ip6t_ulog_target(struct sk_buff **pskb,
+				    unsigned int hooknum,
 				    const struct net_device *in,
 				    const struct net_device *out,
-				    unsigned int hooknum,
 				    const void *targinfo, void *userinfo)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
+	ipt_ulog_target(pskb, hooknum, in, out, targinfo, userinfo);
 
-	ipt_ulog_packet(hooknum, *pskb, in, out, loginfo, NULL);
- 
  	return IP6T_CONTINUE;
 }
  
-static void ip6t_logfn(unsigned int hooknum,
-		      const struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const char *prefix)
-{
-	struct ipt_ulog_info loginfo = { 
-		.nl_group = ULOG_DEFAULT_NLGROUP,
-		.copy_range = 0,
-		.qthreshold = ULOG_DEFAULT_QTHRESHOLD,
-		.prefix = ""
-	};
-
-	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
-}
-
 static int ip6t_ulog_checkentry(const char *tablename,
 			       const struct ip6t_entry *e,
 			       void *targinfo,
@@ -123,11 +86,10 @@
 	return 1;
 }
 
-static struct ip6t_target ip6t_ulog_reg = {
-	.name		= "ULOG",
-	.target		= ip6t_ulog_target,
-	.checkentry	= ip6t_ulog_checkentry,
-	.me		= THIS_MODULE,
+
+static struct ip6t_target ip6t_ulog_reg =
+    { {NULL, NULL}, "ULOG", ip6t_ulog_target, ip6t_ulog_checkentry, NULL,
+THIS_MODULE
 };
 
 static int __init init(void)
@@ -137,8 +99,6 @@
 	if (ip6t_register_target(&ip6t_ulog_reg) != 0) {
 		return -EINVAL;
 	}
-	if (nflog)
-		nf_log_register(PF_INET, &ip6t_logfn);
 	
 	return 0;
 }
@@ -147,8 +107,6 @@
 {
 	DEBUGP("ip6t_ULOG: cleanup_module\n");
 
-	if (nflog)
-		nf_log_unregister(PF_INET, &ip6t_logfn);
 	ip6t_unregister_target(&ip6t_ulog_reg);
 }
 
diff -ur --exclude-from=/tmp/srcdiff.excludes.BQ5XVc -N debug-patch-o-matic-ng-20050220/ULOG/linux-2.6/net/ipv6/netfilter/Kconfig.ladd patch-o-matic-ng-20050312/ULOG/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
--- debug-patch-o-matic-ng-20050220/ULOG/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	2005-02-15 01:27:50.000000000 +0200
+++ patch-o-matic-ng-20050312/ULOG/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	2005-03-14 12:57:55.966009157 +0200
@@ -7,7 +7,8 @@
 	  daemon using netlink multicast sockets; unlike the LOG target
 	  which can only be viewed through syslog.
 
-	  This target requires the ipv4 version to be compiled as well.
+	  NOTE: This target requires the ipv4 version of ULOG to be compiled as
+	        well.
 
 	  The apropriate userspace logging daemon (ulogd) may be obtained from
 	  <http://www.gnumonks.org/projects/ulogd/>
diff -ur --exclude-from=/tmp/srcdiff.excludes.BQ5XVc -N debug-patch-o-matic-ng-20050220/ULOG/linux-2.6/net/ipv6/netfilter/ip6t_ULOG.c patch-o-matic-ng-20050312/ULOG/linux-2.6/net/ipv6/netfilter/ip6t_ULOG.c
--- debug-patch-o-matic-ng-20050220/ULOG/linux-2.6/net/ipv6/netfilter/ip6t_ULOG.c	2005-02-15 01:27:50.000000000 +0200
+++ patch-o-matic-ng-20050312/ULOG/linux-2.6/net/ipv6/netfilter/ip6t_ULOG.c	2005-03-14 12:07:13.000000000 +0200
@@ -26,25 +26,11 @@
  */
 
 #include <linux/module.h>
-#include <linux/config.h>
-#include <linux/spinlock.h>
-#include <linux/socket.h>
-#include <linux/skbuff.h>
-#include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/netlink.h>
-#include <linux/netdevice.h>
-#include <linux/mm.h>
-#include <linux/moduleparam.h>
-#include <linux/netfilter.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
-#include <net/sock.h>
-#include <linux/bitops.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jonas Berlin <jberlin@niksula.hut.fi>");
+MODULE_AUTHOR("Jonas Berlin <xkr47@outerspace.dyndns.org>");
 MODULE_DESCRIPTION("ip6tables userspace logging module");
 
 #if 0
@@ -72,7 +58,7 @@
 				    unsigned int hooknum,
 				    const void *targinfo, void *userinfo)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
+	const struct ipt_ulog_info *loginfo = (const struct ipt_ulog_info *) targinfo;
 
 	ipt_ulog_packet(hooknum, *pskb, in, out, loginfo, NULL);
  
@@ -138,7 +124,7 @@
 		return -EINVAL;
 	}
 	if (nflog)
-		nf_log_register(PF_INET, &ip6t_logfn);
+		nf_log_register(PF_INET6, &ip6t_logfn);
 	
 	return 0;
 }
@@ -148,7 +134,7 @@
 	DEBUGP("ip6t_ULOG: cleanup_module\n");
 
 	if (nflog)
-		nf_log_unregister(PF_INET, &ip6t_logfn);
+		nf_log_unregister(PF_INET6, &ip6t_logfn);
 	ip6t_unregister_target(&ip6t_ulog_reg);
 }
 

--------------010508020000050101000103--
