From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/8] netfilter: Fix ip_conntrack_proto_sctp exit on sysctl
	fail
Date: Fri, 31 Dec 2004 22:37:01 +1100
Message-ID: <1104493022.2791.8.camel@localhost.localdomain>
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

Name: Fix ip_conntrack_proto_sctp exit on sysctl fail
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

On failure from register_sysctl_table, we return with exit 0.  Oops.
init and fini should also be static.  nfsim found these.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-12-31 20:56:22.301260200 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-12-31 20:57:06.537535264 +1100
@@ -609,7 +609,7 @@
 static struct ctl_table_header *ip_ct_sysctl_header;
 #endif
 
-int __init init(void)
+static int __init init(void)
 {
 	int ret;
 
@@ -622,6 +622,7 @@
 #ifdef CONFIG_SYSCTL
 	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
 	if (ip_ct_sysctl_header == NULL) {
+		ret = -ENOMEM;
 		printk("ip_conntrack_proto_sctp: can't register to sysctl.\n");
 		goto cleanup;
 	}
@@ -639,7 +640,7 @@
 	return ret;
 }
 
-void __exit fini(void)
+static void __exit fini(void)
 {
 	ip_conntrack_protocol_unregister(&ip_conntrack_protocol_sctp);
 #ifdef CONFIG_SYSCTL

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
