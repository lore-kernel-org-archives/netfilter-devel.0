From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PATCH] get rid of warnings if /proc not defined.
Date: Fri, 25 Jul 2003 13:47:29 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725134729.1b4698d0.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Trivial -- Get rid of warnings in netfilter if /proc is not configured on.
Patch against 2.6.0-test1

diff -Nru a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c	Fri Jul 25 12:30:29 2003
+++ b/net/ipv4/netfilter/ipt_recent.c	Fri Jul 25 12:30:29 2003
@@ -91,8 +91,10 @@
  */
 static spinlock_t recent_lock = SPIN_LOCK_UNLOCKED;
 
+#ifdef CONFIG_PROC_FS
 /* Our /proc/net/ipt_recent entry */
 static struct proc_dir_entry *proc_net_ipt_recent = NULL;
+#endif
 
 /* Function declaration for later. */
 static int
@@ -959,8 +961,10 @@
 	int count;
 
 	printk(version);
+#ifdef CONFIG_PROC_FS
 	proc_net_ipt_recent = proc_mkdir("ipt_recent",proc_net);
 	if(!proc_net_ipt_recent) return -ENOMEM;
+#endif
 
 	if(ip_list_hash_size && ip_list_hash_size <= ip_list_tot) {
 	  printk(KERN_WARNING RECENT_NAME ": ip_list_hash_size too small, resetting to default.\n");
