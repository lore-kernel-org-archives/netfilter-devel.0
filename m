From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PATCH] ipv4 netfilter MODULE_PARM conversion
Date: Fri, 23 Jul 2004 13:18:36 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040723131836.2f5c3bbd@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: coreteam@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This converts all the netfilter ipv4 modules to use the new module_param
rather than the soon to be deprecated MODULE_PARM

Signed-off-by: Stephen Hemminger <shemminger@osdl.org>

diff -Nru a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-07-23 13:05:42 -07:00
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
@@ -34,7 +35,7 @@
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
-MODULE_PARM(master_timeout, "i");
+module_param(master_timeout, int, 0);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 
 static char *conns[] = { "DATA ", "MESG ", "INDEX " };
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-23 13:05:42 -07:00
@@ -24,6 +24,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
@@ -1373,7 +1374,7 @@
 }
 
 static int hashsize;
-MODULE_PARM(hashsize, "i");
+module_param(hashsize, int, 0);
 
 int __init ip_conntrack_init(void)
 {
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-07-23 13:05:42 -07:00
@@ -10,6 +10,7 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <linux/ctype.h>
@@ -33,10 +34,10 @@
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 
 static int loose;
-MODULE_PARM(loose, "i");
+module_param(loose, int, 0);
 
 #if 0
 #define DEBUGP printk
diff -Nru a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c	2004-07-23 13:05:42 -07:00
@@ -24,6 +24,7 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
@@ -44,11 +45,11 @@
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-MODULE_PARM(max_dcc_channels, "i");
+module_param(max_dcc_channels, int, 0);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per IRC session");
-MODULE_PARM(dcc_timeout, "i");
+module_param(dcc_timeout, int, 0);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
 
 static char *dccprotos[] = { "SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT " };
diff -Nru a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-07-23 13:05:42 -07:00
@@ -12,6 +12,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 
@@ -27,7 +28,7 @@
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
 
 #if 0
diff -Nru a/net/ipv4/netfilter/ip_nat_ftp.c b/net/ipv4/netfilter/ip_nat_ftp.c
--- a/net/ipv4/netfilter/ip_nat_ftp.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_nat_ftp.c	2004-07-23 13:05:42 -07:00
@@ -9,6 +9,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
@@ -33,7 +34,7 @@
 static int ports[MAX_PORTS];
 static int ports_c;
 
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 
 DECLARE_LOCK_EXTERN(ip_ftp_lock);
 
diff -Nru a/net/ipv4/netfilter/ip_nat_irc.c b/net/ipv4/netfilter/ip_nat_irc.c
--- a/net/ipv4/netfilter/ip_nat_irc.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_nat_irc.c	2004-07-23 13:05:42 -07:00
@@ -17,6 +17,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
@@ -41,7 +42,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 
 /* protects irc part of conntracks */
diff -Nru a/net/ipv4/netfilter/ip_nat_snmp_basic.c b/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-07-23 13:05:42 -07:00
@@ -45,6 +45,7 @@
  */
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/netfilter_ipv4.h>
@@ -606,10 +607,41 @@
 #define SERR_NSI    1
 #define SERR_EOM    2
 
+static void fast_csum(unsigned char *csum, const unsigned char *optr,
+                      const unsigned char *nptr, int odd);
+/* 
+ * Mangle IP address.
+ * 	- begin points to the start of the snmp messgae
+ *      - addr points to the start of the address
+ */
 static inline void mangle_address(unsigned char *begin,
                                   unsigned char *addr,
                                   const struct oct1_map *map,
-                                  u_int16_t *check);
+                                  u_int16_t *check)
+{
+	if (map->from == NOCT1(*addr)) {
+		u_int32_t old;
+		
+		if (debug)
+			memcpy(&old, (unsigned char *)addr, sizeof(old));
+			
+		*addr = map->to;
+		
+		/* Update UDP checksum if being used */
+		if (*check) {
+			unsigned char odd = !((addr - begin) % 2);
+			
+			fast_csum((unsigned char *)check,
+			          &map->from, &map->to, odd);
+			          
+		}
+		
+		if (debug)
+			printk(KERN_DEBUG "bsalg: mapped %u.%u.%u.%u to "
+			       "%u.%u.%u.%u\n", NIPQUAD(old), NIPQUAD(*addr));
+	}
+}
+
 struct snmp_cnv
 {
 	unsigned int class;
@@ -990,39 +1022,6 @@
 	csum[1] = x & 0xFF;
 }
 
-/* 
- * Mangle IP address.
- * 	- begin points to the start of the snmp messgae
- *      - addr points to the start of the address
- */
-static inline void mangle_address(unsigned char *begin,
-                                  unsigned char *addr,
-                                  const struct oct1_map *map,
-                                  u_int16_t *check)
-{
-	if (map->from == NOCT1(*addr)) {
-		u_int32_t old;
-		
-		if (debug)
-			memcpy(&old, (unsigned char *)addr, sizeof(old));
-			
-		*addr = map->to;
-		
-		/* Update UDP checksum if being used */
-		if (*check) {
-			unsigned char odd = !((addr - begin) % 2);
-			
-			fast_csum((unsigned char *)check,
-			          &map->from, &map->to, odd);
-			          
-		}
-		
-		if (debug)
-			printk(KERN_DEBUG "bsalg: mapped %u.%u.%u.%u to "
-			       "%u.%u.%u.%u\n", NIPQUAD(old), NIPQUAD(*addr));
-	}
-}
-
 /*
  * Parse and mangle SNMP message according to mapping.
  * (And this is the fucking 'basic' method).
@@ -1357,4 +1356,4 @@
 module_init(init);
 module_exit(fini);
 
-MODULE_PARM(debug, "i");
+module_param(debug, int, 0);
diff -Nru a/net/ipv4/netfilter/ip_nat_tftp.c b/net/ipv4/netfilter/ip_nat_tftp.c
--- a/net/ipv4/netfilter/ip_nat_tftp.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ip_nat_tftp.c	2004-07-23 13:05:42 -07:00
@@ -22,6 +22,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
@@ -41,7 +42,7 @@
 
 static int ports[MAX_PORTS];
 static int ports_c = 0;
-MODULE_PARM(ports,"1-" __MODULE_STRING(MAX_PORTS) "i");
+module_param_array(ports, int, ports_c, 0);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
 
 #if 0
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2004-07-23 13:05:42 -07:00
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
@@ -28,7 +29,7 @@
 MODULE_DESCRIPTION("iptables syslog logging module");
 
 static unsigned int nflog = 1;
-MODULE_PARM(nflog, "i");
+module_param(nflog, int, 0);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
  
 #if 0
diff -Nru a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
--- a/net/ipv4/netfilter/ipt_ULOG.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ipt_ULOG.c	2004-07-23 13:05:42 -07:00
@@ -41,6 +41,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/config.h>
 #include <linux/spinlock.h>
 #include <linux/socket.h>
@@ -74,15 +75,15 @@
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , ## args); } while (0)
 
 static unsigned int nlbufsiz = 4096;
-MODULE_PARM(nlbufsiz, "i");
+module_param(nlbufsiz, int, 0);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
 static unsigned int flushtimeout = 10 * HZ;
-MODULE_PARM(flushtimeout, "i");
+module_param(flushtimeout, int, 0);
 MODULE_PARM_DESC(flushtimeout, "buffer flush timeout");
 
 static unsigned int nflog = 1;
-MODULE_PARM(nflog, "i");
+module_param(nflog, int, 0);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
 
 /* global data structures */
diff -Nru a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/ipt_recent.c	2004-07-23 13:05:42 -07:00
@@ -7,6 +7,7 @@
  * by normal system calls. */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
@@ -37,12 +38,13 @@
 MODULE_AUTHOR("Stephen Frost <sfrost@snowman.net>");
 MODULE_DESCRIPTION("IP tables recently seen matching module " RECENT_VER);
 MODULE_LICENSE("GPL");
-MODULE_PARM(ip_list_tot,"i");
-MODULE_PARM(ip_pkt_list_tot,"i");
-MODULE_PARM(ip_list_hash_size,"i");
-MODULE_PARM(ip_list_perms,"i");
+
+module_param(ip_list_tot, int, 0);
+module_param(ip_pkt_list_tot, int, 0);
+module_param(ip_list_hash_size, int, 0);
+module_param(ip_list_perms, int, 0);
 #ifdef DEBUG
-MODULE_PARM(debug,"i");
+module_param(debug, int, 0);
 MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
 #endif
 MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
diff -Nru a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
--- a/net/ipv4/netfilter/iptable_filter.c	2004-07-23 13:05:42 -07:00
+++ b/net/ipv4/netfilter/iptable_filter.c	2004-07-23 13:05:42 -07:00
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 MODULE_LICENSE("GPL");
@@ -155,7 +156,7 @@
 
 /* Default to forward because I got too much mail already. */
 static int forward = NF_ACCEPT;
-MODULE_PARM(forward, "i");
+module_param(forward, int, 0);
 
 static int __init init(void)
 {
