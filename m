From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Netfilter modules to use modern parameters
Date: Tue, 23 Sep 2003 18:31:29 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923083215.7CFC62C23F@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Requires previous patch send to lkml, entitled [PATCH] module_param_array().

Harald: I changed ULOG's flushtimeout to always use 100ths of a
second, to avoid being kernel-version and arch specific.

If no objections, I'll send to DaveM (it's 2.6-only).

Cheers,
Rusty.

Name: New-style Module Parameters for Netfilter
Author: Rusty Russell
Status: Tested on 2.6.0-test5-bk9
Depends: Module/array_params.patch.gz

D: Allow module parameters to be boot parameters too, and where
D: appropriate expose through sysfs.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_amanda.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_amanda.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-09-22 10:08:41.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-09-23 18:27:53.000000000 +1000
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
+#include <linux/moduleparam.h>
 #include <net/checksum.h>
 #include <net/udp.h>
 
@@ -33,7 +34,7 @@ static unsigned int master_timeout = 300
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
-MODULE_PARM(master_timeout, "i");
+module_param(master_timeout, int, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 
 DECLARE_LOCK(ip_amanda_lock);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_core.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_core.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-23 18:27:53.000000000 +1000
@@ -29,8 +29,8 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
-/* For ERR_PTR().  Yeah, I know... --RR */
-#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/moduleparam.h>
 
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -1395,7 +1395,7 @@ void ip_conntrack_cleanup(void)
 }
 
 static int hashsize;
-MODULE_PARM(hashsize, "i");
+module_param(hashsize, int, 0400);
 
 int __init ip_conntrack_init(void)
 {
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_ftp.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_ftp.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-09-23 18:27:53.000000000 +1000
@@ -10,6 +10,7 @@
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
+#include <linux/moduleparam.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
@@ -24,12 +25,10 @@ struct module *ip_conntrack_ftp = THIS_M
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-#ifdef MODULE_PARM
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
-#endif
+module_param_array(ports, int, ports_c, 0400);
 
 static int loose;
-MODULE_PARM(loose, "i");
+module_param(loose, int, 0600);
 
 #if 0
 #define DEBUGP printk
@@ -406,10 +405,10 @@ static int __init init(void)
 	int i, ret;
 	char *tmpname;
 
-	if (ports[0] == 0)
-		ports[0] = FTP_PORT;
+	if (ports_c == 0)
+		ports[ports_c++] = FTP_PORT;
 
-	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i = 0; i < ports_c; i++) {
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
@@ -435,7 +434,6 @@ static int __init init(void)
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
 	return 0;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_irc.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_irc.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_irc.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_irc.c	2003-09-23 18:27:53.000000000 +1000
@@ -32,6 +32,7 @@
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+#include <linux/moduleparam.h>
 
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
@@ -44,14 +45,12 @@ static char irc_buffer[65536];
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
-#ifdef MODULE_PARM
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-MODULE_PARM(max_dcc_channels, "i");
+module_param(max_dcc_channels, int, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per IRC session");
-MODULE_PARM(dcc_timeout, "i");
+module_param(dcc_timeout, int, 0400);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
-#endif
 
 static char *dccprotos[] = { "SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT " };
 #define MINMATCHLEN	5
@@ -247,10 +246,10 @@ static int __init init(void)
 	}
 	
 	/* If no port given, default to standard irc port */
-	if (ports[0] == 0)
-		ports[0] = IRC_PORT;
+	if (ports_c == 0)
+		ports[ports_c++] = IRC_PORT;
 
-	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i = 0; i < ports_c; i++) {
 		hlpr = &irc_helpers[i];
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
@@ -279,7 +278,6 @@ static int __init init(void)
 			fini();
 			return -EBUSY;
 		}
-		ports_c++;
 	}
 	return 0;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_tftp.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_tftp.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-09-23 18:27:53.000000000 +1000
@@ -15,6 +15,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
+#include <linux/moduleparam.h>
 
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("tftp connection tracking helper");
@@ -23,10 +24,8 @@ MODULE_LICENSE("GPL");
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-#ifdef MODULE_PARM
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
-#endif
 
 #if 0
 #define DEBUGP(format, args...) printk(__FILE__ ":" __FUNCTION__ ": " \
@@ -92,10 +91,10 @@ static int __init init(void)
 	int i, ret;
 	char *tmpname;
 
-	if (!ports[0])
-		ports[0]=TFTP_PORT;
+	if (ports_c == 0)
+		ports[ports_c++] = TFTP_PORT;
 
-	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+	for (i = 0; i < ports_c; i++) {
 		/* Create helper structure */
 		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
 
@@ -125,7 +124,6 @@ static int __init init(void)
 			fini();
 			return(ret);
 		}
-		ports_c++;
 	}
 	return(0);
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_ftp.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_ftp.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_ftp.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_ftp.c	2003-09-23 18:27:53.000000000 +1000
@@ -3,6 +3,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <linux/moduleparam.h>
 #include <net/tcp.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
@@ -23,10 +24,7 @@ MODULE_DESCRIPTION("ftp NAT helper");
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-
-#ifdef MODULE_PARM
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
-#endif
+module_param_array(ports, int, ports_c, 0400);
 
 DECLARE_LOCK_EXTERN(ip_ftp_lock);
 
@@ -306,10 +304,10 @@ static int __init init(void)
 	int i, ret = 0;
 	char *tmpname;
 
-	if (ports[0] == 0)
-		ports[0] = FTP_PORT;
+	if (ports_c == 0)
+		ports[ports_c] = FTP_PORT;
 
-	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+	for (i = 0; i < ports_c; i++) {
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].mask.dst.protonum = 0xFFFF;
@@ -336,7 +334,6 @@ static int __init init(void)
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
 
 	return ret;
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_irc.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_irc.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_irc.c	2003-09-23 00:39:46.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_irc.c	2003-09-23 18:27:53.000000000 +1000
@@ -27,6 +27,7 @@
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/moduleparam.h>
 
 #if 0
 #define DEBUGP printk
@@ -41,10 +42,8 @@ static int ports_c;
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-#ifdef MODULE_PARM
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-#endif
 
 /* protects irc part of conntracks */
 DECLARE_LOCK_EXTERN(ip_irc_lock);
@@ -237,11 +236,10 @@ static int __init init(void)
 	struct ip_nat_helper *hlpr;
 	char *tmpname;
 
-	if (ports[0] == 0) {
-		ports[0] = IRC_PORT;
-	}
+	if (ports_c == 0)
+		ports[ports_c++] = IRC_PORT;
 
-	for (i = 0; (i < MAX_PORTS) && ports[i] != 0; i++) {
+	for (i = 0; i < ports_c; i++) {
 		hlpr = &ip_nat_irc_helpers[i];
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
@@ -271,7 +269,6 @@ static int __init init(void)
 			fini();
 			return 1;
 		}
-		ports_c++;
 	}
 	return ret;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_snmp_basic.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-09-23 00:39:46.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-09-23 18:27:53.000000000 +1000
@@ -47,6 +47,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
@@ -1357,4 +1358,4 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-MODULE_PARM(debug, "i");
+module_param(debug, bool, 0600);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_tftp.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_tftp.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ip_nat_tftp.c	2003-09-23 00:39:46.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ip_nat_tftp.c	2003-09-23 18:27:53.000000000 +1000
@@ -28,6 +28,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_tftp.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/moduleparam.h>
 
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("tftp NAT helper");
@@ -37,10 +38,8 @@ MODULE_LICENSE("GPL");
 
 static int ports[MAX_PORTS];
 static int ports_c = 0;
-#ifdef MODULE_PARM
-MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
-#endif
 
 #if 0
 #define DEBUGP(format, args...) printk(__FILE__ ":" __FUNCTION__ ": " \
@@ -160,10 +159,10 @@ static int __init init(void)
 	int i, ret = 0;
 	char *tmpname;
 
-	if (!ports[0])
-		ports[0] = TFTP_PORT;
+	if (ports_c == 0)
+		ports[ports_c++] = TFTP_PORT;
 
-	for (i = 0 ; (i < MAX_PORTS) && ports[i] ; i++) {
+	for (i = 0; i < ports_c; i++) {
 		memset(&tftp[i], 0, sizeof(struct ip_nat_helper));
 
 		tftp[i].tuple.dst.protonum = IPPROTO_UDP;
@@ -192,7 +191,6 @@ static int __init init(void)
 			fini();
 			return ret;
 		}
-		ports_c++;
 	}
 	return ret;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ipt_ULOG.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ipt_ULOG.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ipt_ULOG.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ipt_ULOG.c	2003-09-23 18:30:16.000000000 +1000
@@ -29,8 +29,8 @@
  * by that factor.
  *
  * flushtimeout:
- *   Specify, after how many clock ticks (intel: 100 per second) the queue
- * should be flushed even if it is not full yet.
+ *   Specify, after how many hundredths of a second the queue should be
+ *   flushed even if it is not full yet.
  *
  * ipt_ULOG.c,v 1.22 2002/10/30 09:07:31 laforge Exp
  */
@@ -45,6 +45,7 @@
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
@@ -68,12 +69,12 @@ MODULE_DESCRIPTION("iptables userspace l
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format, ## args); } while (0)
 
 static unsigned int nlbufsiz = 4096;
-MODULE_PARM(nlbufsiz, "i");
+module_param(nlbufsiz, uint, 0600); /* FIXME: Check size < 128k --RR */
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
-static unsigned int flushtimeout = 10 * HZ;
-MODULE_PARM(flushtimeout, "i");
-MODULE_PARM_DESC(flushtimeout, "buffer flush timeout");
+static unsigned int flushtimeout = 10;
+module_param(flushtimeout, int, 0600);
+MODULE_PARM_DESC(flushtimeout, "buffer flush timeout (hundredths of a second)");
 
 /* global data structures */
 
@@ -255,7 +256,7 @@ static unsigned int ipt_ulog_target(stru
 
 	/* if timer isn't already running, start it */
 	if (!timer_pending(&ub->timer)) {
-		ub->timer.expires = jiffies + flushtimeout;
+		ub->timer.expires = jiffies + flushtimeout * HZ / 100;
 		add_timer(&ub->timer);
 	}
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ipt_recent.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ipt_recent.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/ipt_recent.c	2003-09-22 10:23:04.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/ipt_recent.c	2003-09-23 18:27:53.000000000 +1000
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/ip.h>
 #include <linux/vmalloc.h>
+#include <linux/moduleparam.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_recent.h>
@@ -37,12 +38,12 @@ KERN_INFO RECENT_NAME " " RECENT_VER ": 
 MODULE_AUTHOR("Stephen Frost <sfrost@snowman.net>");
 MODULE_DESCRIPTION("IP tables recently seen matching module " RECENT_VER);
 MODULE_LICENSE("GPL");
-MODULE_PARM(ip_list_tot,"i");
-MODULE_PARM(ip_pkt_list_tot,"i");
-MODULE_PARM(ip_list_hash_size,"i");
-MODULE_PARM(ip_list_perms,"i");
+module_param(ip_list_tot, int, 0400);
+module_param(ip_pkt_list_tot, int, 0400);
+module_param(ip_list_hash_size, int, 0400);
+module_param(ip_list_perms, int, 0400);
 #ifdef DEBUG
-MODULE_PARM(debug,"i");
+module_param(debug, int, 0600);
 MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
 #endif
 MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/iptable_filter.c .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/iptable_filter.c
--- .6739-linux-2.6.0-test5-bk9/net/ipv4/netfilter/iptable_filter.c	2003-09-22 10:28:14.000000000 +1000
+++ .6739-linux-2.6.0-test5-bk9.updated/net/ipv4/netfilter/iptable_filter.c	2003-09-23 18:27:53.000000000 +1000
@@ -4,6 +4,7 @@
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
  */
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 MODULE_LICENSE("GPL");
@@ -148,7 +149,7 @@ static struct nf_hook_ops ipt_ops[] = {
 
 /* Default to forward because I got too much mail already. */
 static int forward = NF_ACCEPT;
-MODULE_PARM(forward, "i");
+module_param(forward, bool, 0000);
 
 static int __init init(void)
 {
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
