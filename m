From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 4/4] fix the path to detect esp/connbytes support in kernel
Date: Fri, 07 Apr 2006 20:34:32 +0900 (JST)
Message-ID: <200604071134.k37BYXMq007297@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="04-test.patch"
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

[IPTABLES,IP6TABLES]: fix the path to detect esp/connbytes support in kernel

The recent kernels don't have ipt_connbytes.c and ip6t_esp.c.

---
commit 12bc86c77dae9d0590c5ee021d9c00f2291bfe0b
tree 29a3b1b160d4784a2b264c348d1f781eedbb0ae5
parent c94b52d4b6fff1bfc2da3e192b39e0f45cd12750
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 20:18:10 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 20:18:10 +0900

 extensions/.connbytes-test |    2 +-
 extensions/.esp-test6      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/.connbytes-test b/extensions/.connbytes-test
index 350140f..61355d0 100755
--- a/extensions/.connbytes-test
+++ b/extensions/.connbytes-test
@@ -1,2 +1,2 @@
 #! /bin/sh
-[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_connbytes.c ] && echo connbytes
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_connbytes.h ] && echo connbytes
diff --git a/extensions/.esp-test6 b/extensions/.esp-test6
index ff63ca4..7ded945 100755
--- a/extensions/.esp-test6
+++ b/extensions/.esp-test6
@@ -1,2 +1,2 @@
 #!/bin/sh
-[ -f $KERNEL_DIR/net/ipv6/netfilter/ip6t_esp.c -a -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_esp.h ] && echo esp
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_esp.h ] && echo esp
