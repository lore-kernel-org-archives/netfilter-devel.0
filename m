From: Michal Rokos <michal@rokos.info>
Subject: nf_conntrack_core: port to module_param
Date: Sat, 16 Oct 2004 00:10:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410160010.40500.michal@rokos.info>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Hello,

as Yasuyuki KOZAKAI directed, I'm sending nf_conntrack patches here 
instead of usagi-users.

This one is 1 addition I forget to fold into last patch I sent.

Make nf_conntrack_core use module_param() and turn of debugging by 
default.

Michal

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/15 23:52:28+02:00 michal@michal.rokos.info 
#   Forgot to port nf_conntrack_core to module_param too.
# 
# net/netfilter/nf_conntrack_core.c
#   2004/10/15 23:52:17+02:00 michal@michal.rokos.info +2 -2
#   Port nf_conntrack_core to module_param too.
# 
diff -Nru a/net/netfilter/nf_conntrack_core.c 
b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c 2004-10-16 00:07:30 +02:00
+++ b/net/netfilter/nf_conntrack_core.c 2004-10-16 00:07:30 +02:00
@@ -53,7 +53,7 @@
 
 #define NF_CONNTRACK_VERSION "0.3"
 
-#if 1
+#if 0
 #define DEBUGP printk
 #else
 #define DEBUGP(format, args...)
@@ -1653,7 +1653,7 @@
 }
 
 static int hashsize;
-MODULE_PARM(hashsize, "i");
+module_param(hashsize, int, 0400);
 
 int __init nf_conntrack_init(void)
 {
