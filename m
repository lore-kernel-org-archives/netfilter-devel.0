From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/18]: Fix module_param types and permissions
Date: Thu,  5 Jan 2006 05:06:46 +0100 (MET)
Message-ID: <20060105040610.23512.26101.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix module_param types and permissions

Fix netfilter module_param types and permissions. Also fix an off-by-one in
the ipt_ULOG nlbufsiz < 128k check.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f771b92e29f4a46b7e5cd506f2584bfae187ba6a
tree 642b66e4f1ea352ed02a28880215dfe553d4d007
parent d5c7bf63c8ae6153ecdf70add3f5b935d4b088a1
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:58:23 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:58:23 +0100

 net/ipv4/netfilter/ip_conntrack_amanda.c     |    2 +-
 net/ipv4/netfilter/ip_conntrack_ftp.c        |    2 +-
 net/ipv4/netfilter/ip_conntrack_irc.c        |   10 +++-------
 net/ipv4/netfilter/ip_conntrack_netbios_ns.c |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                |   10 +++++-----
 net/ipv4/netfilter/ipt_recent.c              |   20 ++++++++++----------
 net/netfilter/nf_conntrack_ftp.c             |    2 +-
 7 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
index 0366eed..84e4f79 100644
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c
@@ -36,7 +36,7 @@ static unsigned int master_timeout = 300
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
-module_param(master_timeout, int, 0600);
+module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 
 static const char *conns[] = { "DATA ", "MESG ", "INDEX " };
diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
index 68b173b..e627e58 100644
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -34,7 +34,7 @@ static int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 
 static int loose;
-module_param(loose, int, 0600);
+module_param(loose, bool, 0600);
 
 unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
index d7c4042..c51a2cf 100644
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -36,7 +36,7 @@
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
 static int ports_c;
-static int max_dcc_channels = 8;
+static unsigned int max_dcc_channels = 8;
 static unsigned int dcc_timeout = 300;
 /* This is slow, but it's simple. --RR */
 static char *irc_buffer;
@@ -54,9 +54,9 @@ MODULE_DESCRIPTION("IRC (DCC) connection
 MODULE_LICENSE("GPL");
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
-module_param(max_dcc_channels, int, 0400);
+module_param(max_dcc_channels, uint, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per IRC session");
-module_param(dcc_timeout, int, 0400);
+module_param(dcc_timeout, uint, 0400);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
 
 static const char *dccprotos[] = { "SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT " };
@@ -254,10 +254,6 @@ static int __init init(void)
 		printk("ip_conntrack_irc: max_dcc_channels must be a positive integer\n");
 		return -EBUSY;
 	}
-	if (dcc_timeout < 0) {
-		printk("ip_conntrack_irc: dcc_timeout must be a positive integer\n");
-		return -EBUSY;
-	}
 
 	irc_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!irc_buffer)
diff --git a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
index 186646e..4e68e16 100644
--- a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
+++ b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
@@ -37,7 +37,7 @@ MODULE_DESCRIPTION("NetBIOS name service
 MODULE_LICENSE("GPL");
 
 static unsigned int timeout = 3;
-module_param(timeout, int, 0600);
+module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
 static int help(struct sk_buff **pskb,
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 2883ccd..3fdf147 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -77,15 +77,15 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NE
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , ## args); } while (0)
 
 static unsigned int nlbufsiz = 4096;
-module_param(nlbufsiz, uint, 0600); /* FIXME: Check size < 128k --RR */
+module_param(nlbufsiz, uint, 0400);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
 static unsigned int flushtimeout = 10;
-module_param(flushtimeout, int, 0600);
+module_param(flushtimeout, uint, 0600);
 MODULE_PARM_DESC(flushtimeout, "buffer flush timeout (hundredths of a second)");
 
-static unsigned int nflog = 1;
-module_param(nflog, int, 0400);
+static int nflog = 1;
+module_param(nflog, bool, 0400);
 MODULE_PARM_DESC(nflog, "register as internal netfilter logging module");
 
 /* global data structures */
@@ -376,7 +376,7 @@ static int __init init(void)
 
 	DEBUGP("ipt_ULOG: init module\n");
 
-	if (nlbufsiz >= 128*1024) {
+	if (nlbufsiz > 128*1024) {
 		printk("Netlink buffer has to be <= 128kB\n");
 		return -EINVAL;
 	}
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 261cbb4..5ddccb1 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -24,10 +24,10 @@
 #define HASH_LOG 9
 
 /* Defaults, these can be overridden on the module command-line. */
-static int ip_list_tot = 100;
-static int ip_pkt_list_tot = 20;
-static int ip_list_hash_size = 0;
-static int ip_list_perms = 0644;
+static unsigned int ip_list_tot = 100;
+static unsigned int ip_pkt_list_tot = 20;
+static unsigned int ip_list_hash_size = 0;
+static unsigned int ip_list_perms = 0644;
 #ifdef DEBUG
 static int debug = 1;
 #endif
@@ -38,13 +38,13 @@ KERN_INFO RECENT_NAME " " RECENT_VER ": 
 MODULE_AUTHOR("Stephen Frost <sfrost@snowman.net>");
 MODULE_DESCRIPTION("IP tables recently seen matching module " RECENT_VER);
 MODULE_LICENSE("GPL");
-module_param(ip_list_tot, int, 0400);
-module_param(ip_pkt_list_tot, int, 0400);
-module_param(ip_list_hash_size, int, 0400);
-module_param(ip_list_perms, int, 0400);
+module_param(ip_list_tot, uint, 0400);
+module_param(ip_pkt_list_tot, uint, 0400);
+module_param(ip_list_hash_size, uint, 0400);
+module_param(ip_list_perms, uint, 0400);
 #ifdef DEBUG
-module_param(debug, int, 0600);
-MODULE_PARM_DESC(debug,"debugging level, defaults to 1");
+module_param(debug, bool, 0600);
+MODULE_PARM_DESC(debug,"enable debugging output");
 #endif
 MODULE_PARM_DESC(ip_list_tot,"number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot,"number of packets per IP to remember");
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 65080e2..d5a6eaf 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -44,7 +44,7 @@ static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 
 static int loose;
-module_param(loose, int, 0600);
+module_param(loose, bool, 0600);
 
 unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
