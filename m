From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 5/8]: Fix cleanup in ipt_recent
Date: Fri, 04 Mar 2005 13:18:50 +0100
Message-ID: <4228522A.3000307@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="05.diff"
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
#   2005/03/04 00:48:18+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix cleanup in ipt_recent
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   When ipt_register_match() fails, ipt_recent doesn't remove its proc
#   entry.  Found by nfsim.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_recent.c
#   2005/03/04 00:48:16+01:00 kaber@coreworks.de +5 -2
#   [NETFILTER]: Fix cleanup in ipt_recent
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   When ipt_register_match() fails, ipt_recent doesn't remove its proc
#   entry.  Found by nfsim.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c	2005-03-04 01:52:05 +01:00
+++ b/net/ipv4/netfilter/ipt_recent.c	2005-03-04 01:52:05 +01:00
@@ -962,7 +962,7 @@
 /* Kernel module initialization. */
 static int __init init(void)
 {
-	int count;
+	int err, count;
 
 	printk(version);
 #ifdef CONFIG_PROC_FS
@@ -986,7 +986,10 @@
 	if(debug) printk(KERN_INFO RECENT_NAME ": ip_list_hash_size: %d\n",ip_list_hash_size);
 #endif
 
-	return ipt_register_match(&recent_match);
+	err = ipt_register_match(&recent_match);
+	if (err)
+		remove_proc_entry("ipt_recent", proc_net);
+	return err;
 }
 
 /* Kernel module destruction. */
