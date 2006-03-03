From: Gregor Maier <gregor@net.in.tum.de>
Subject: [PATCH] Fix wrong option in Makefile for CONFIG_BRIDGE_EBT_ULOG
Date: Fri, 3 Mar 2006 22:01:00 +0100
Message-ID: <20060303210100.GA11792@net.in.tum.de>
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

[PATCH] Fix wrong option spelling in Makefile for CONFIG_BRIDGE_EBT_ULOG

Signed-off-by: Gregor Maier <gregor@net.in.tum.de>

diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 8bf6d9f..905087e 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -29,4 +29,4 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_sna
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
-obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_ulog.o
+obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
