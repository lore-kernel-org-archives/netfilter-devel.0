From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Fix proc removal in ip_conntrack_standalone
Date: Thu, 30 Dec 2004 17:56:11 +1100
Message-ID: <1104389771.20956.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Fix proc removal in ip_conntrack_standalone
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Someone thought it would be clever if proc code ignores removal of
non-existent entries.  Hence, we missed that
/proc/net/stat/ip_conntrack is never removed on module removal or init
failure.

Found by nfsim.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-30 17:39:26.910760688 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-30 17:39:52.719837112 +1100
@@ -820,8 +820,8 @@
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
-	proc_net_remove("ip_conntrack_stat");
-cleanup_proc_exp:
+	remove_proc_entry("ip_conntrack", proc_net_stat);
+ cleanup_proc_exp:
 	proc_net_remove("ip_conntrack_expect");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
