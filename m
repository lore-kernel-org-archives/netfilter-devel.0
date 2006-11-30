From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/12]: changed version to 1.4.0
Date: Thu, 30 Nov 2006 18:48:48 +0900 (JST)
Message-ID: <200611300948.kAU9mnuX005137@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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



---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index cc1de3b..dbf3ce4 100644
--- a/Makefile
+++ b/Makefile
@@ -14,8 +14,8 @@ TOPLEVEL_INCLUDED=YES
 ifndef KERNEL_DIR
 KERNEL_DIR="/lib/modules/$(shell uname -r)/build"
 endif
-IPTABLES_VERSION:=1.3.6
-OLD_IPTABLES_VERSION:=1.3.5
+IPTABLES_VERSION:=1.4.0
+OLD_IPTABLES_VERSION:=1.3.6
 
 PREFIX:=/usr/local
 LIBDIR:=$(PREFIX)/lib
-- 
1.4.4
