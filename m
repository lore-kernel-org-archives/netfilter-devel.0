From: Phil Oester <netfilter@linuxace.com>
Subject: [PATCH] kernel panic with rpc.patch
Date: Thu, 2 Sep 2004 16:23:57 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902232357.GA18422@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
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


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some useless __MOD_INC_USE_COUNT macros make rpc patch panic on boot.
The below removes them.  Boot tested.

This fixes bugzilla #50


Phil



--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-rpc

diff -ru pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c
--- pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2003-12-18 13:48:00.000000000 -0500
+++ pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2004-09-02 19:09:56.599859208 -0400
@@ -394,10 +394,6 @@
 {
 	int port;
 
-	DEBUGP("incrementing usage counts\n");
-	__MOD_INC_USE_COUNT(ip_conntrack_rpc_udp);
-	__MOD_INC_USE_COUNT(ip_conntrack_rpc_tcp);
-
 	/* If no port given, default to standard RPC port */
 	if (ports[0] == 0)
 		ports[0] = RPC_PORT;

--r5Pyd7+fXNt84Ff3--
