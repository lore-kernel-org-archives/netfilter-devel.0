From: Patrick Schaaf <bof@bof.de>
Subject: [PATCH] ROUTE target 2.4 Config.in.ladd correction
Date: Tue, 23 Nov 2004 09:28:31 +0100
Message-ID: <20041123082830.GA13622@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Please apply this - doesn't build with all-modular v6 netfilter, otherwise:

--- svn-20041120-patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd Sat Nov 20 11:28:25 2004
+++ patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter/Config.in.ladd Tue Nov 23 09:25:25 2004
@@ -1,3 +1,3 @@
     dep_tristate '    MARK target support' CONFIG_IP6_NF_TARGET_MARK
$CONFIG_IP6_NF_MANGLE
-    dep_mbool '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CONFIG_IP6_NF_MANGLE
+    dep_tristate '    ROUTE target support' CONFIG_IP6_NF_TARGET_ROUTE $CONFIG_IP6_NF_MANGLE
 
