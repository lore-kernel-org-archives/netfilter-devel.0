From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/4]: Use correct types for "ports" module parameter
Date: Tue, 13 Sep 2005 09:37:10 +0200
Message-ID: <432681A6.5090305@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080409080206030309020009"
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
--------------080409080206030309020009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are my queued netfilter patches including the
DHCP/MASQUERADE fix. Please apply.


--------------080409080206030309020009
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Use correct type for "ports" module parameter

With large port numbers the helper_names buffer can overflow.
Noticed by Samir Bellabes <sbellabes@mandriva.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d53f0d343998b81945723c43046c4f2ee301e45b
tree 2e8a7c30c3fb32cae0eacb4231ac3554e18f6a47
parent 1d8674edb534a3c5cb549bfde5a39fa5598cb3bc
author Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 00:58:11 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 00:58:11 +0200

 net/ipv4/netfilter/ip_conntrack_ftp.c  |    6 +++---
 net/ipv4/netfilter/ip_conntrack_irc.c  |    6 +++---
 net/ipv4/netfilter/ip_conntrack_tftp.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -29,9 +29,9 @@ static char *ftp_buffer;
 static DEFINE_SPINLOCK(ip_ftp_lock);
 
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
 
 static int loose;
 module_param(loose, int, 0600);
@@ -450,7 +450,7 @@ out_update_nl:
 }
 
 static struct ip_conntrack_helper ftp[MAX_PORTS];
-static char ftp_names[MAX_PORTS][10];
+static char ftp_names[MAX_PORTS][sizeof("ftp-65535")];
 
 /* Not __exit: called from init() */
 static void fini(void)
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -34,7 +34,7 @@
 #include <linux/moduleparam.h>
 
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
 static int max_dcc_channels = 8;
 static unsigned int dcc_timeout = 300;
@@ -52,7 +52,7 @@ EXPORT_SYMBOL_GPL(ip_nat_irc_hook);
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 module_param(max_dcc_channels, int, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per IRC session");
@@ -240,7 +240,7 @@ static int help(struct sk_buff **pskb,
 }
 
 static struct ip_conntrack_helper irc_helpers[MAX_PORTS];
-static char irc_names[MAX_PORTS][10];
+static char irc_names[MAX_PORTS][sizeof("irc-65535")];
 
 static void fini(void);
 
diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -26,9 +26,9 @@ MODULE_DESCRIPTION("tftp connection trac
 MODULE_LICENSE("GPL");
 
 #define MAX_PORTS 8
-static int ports[MAX_PORTS];
+static short ports[MAX_PORTS];
 static int ports_c;
-module_param_array(ports, int, &ports_c, 0400);
+module_param_array(ports, short, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of tftp servers");
 
 #if 0
@@ -100,7 +100,7 @@ static int tftp_help(struct sk_buff **ps
 }
 
 static struct ip_conntrack_helper tftp[MAX_PORTS];
-static char tftp_names[MAX_PORTS][10];
+static char tftp_names[MAX_PORTS][sizeof("tftp-65535")];
 
 static void fini(void)
 {

--------------080409080206030309020009--
