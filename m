From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/8] netfilter:
Date: Fri, 31 Dec 2004 22:39:05 +1100
Message-ID: <1104493146.2791.13.camel@localhost.localdomain>
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

Name: Fix cleanup patch when sysctl registration fails
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

nfsim gains sysctl support, and sure enough, --failtest uncovered an
unregister when the registration had failed, plus 0 return despite failure.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-30 19:18:06.170896368 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-30 19:18:29.426361000 +1100
@@ -791,7 +791,8 @@
 	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
 	if (ip_ct_sysctl_header == NULL) {
 		printk("ip_conntrack: can't register to sysctl.\n");
-		goto cleanup;
+		ret = -ENOMEM;
+		goto cleanup_localinops;
 	}
 #endif
 
@@ -800,6 +801,7 @@
  cleanup:
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(ip_ct_sysctl_header);
+ cleanup_localinops:
 #endif
 	nf_unregister_hook(&ip_conntrack_local_in_ops);
  cleanup_inoutandlocalops:

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
