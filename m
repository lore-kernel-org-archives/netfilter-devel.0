From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] netfilter: Fix cleanup in ipt_recent should
	ipt_registrater_match error
Date: Sat, 01 Jan 2005 15:57:27 +1100
Message-ID: <1104555447.2791.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
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

Name: Fix cleanup in ipt_recent should ipt_registrater_match error
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

When ipt_registrater_match() fails, ipt_recent doesn't remove its proc
entry.  Found by nfsim.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_recent.c	2005-01-01 12:07:56.364981672 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_recent.c	2005-01-01 12:11:44.159351664 +1100
@@ -959,7 +959,7 @@
 /* Kernel module initialization. */
 static int __init init(void)
 {
-	int count;
+	int err, count;
 
 	printk(version);
 #ifdef CONFIG_PROC_FS
@@ -983,7 +983,10 @@
 	if(debug) printk(KERN_INFO RECENT_NAME ": ip_list_hash_size: %d\n",ip_list_hash_size);
 #endif
 
-	return ipt_register_match(&recent_match);
+	err = ipt_register_match(&recent_match);
+	if (err)
+		remove_proc_entry("ipt_recent", proc_net);
+	return err;
 }
 
 /* Kernel module destruction. */

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
