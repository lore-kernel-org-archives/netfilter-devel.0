From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/14]: iptables: fix typos in ipt_connbytes.h
Date: Fri,  3 Feb 2006 14:44:10 +0100 (MET)
Message-ID: <20060203134410.2141.36095.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: iptables: fix typos in ipt_connbytes.h

Fix some typos that make iptables userspace compilation fail.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 94b31e7f3e367691f07b3497b64562d31a0b2e29
tree f773e9c3fd28a51a12fdf649f9f0e3e2d8d3133d
parent c84c986a5028347c036a1915a3320c51dd3be4a6
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 03 Feb 2006 12:40:46 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:40:46 +0100

 include/linux/netfilter_ipv4/ipt_connbytes.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_connbytes.h b/include/linux/netfilter_ipv4/ipt_connbytes.h
index b04dfa3..f63e6ee 100644
--- a/include/linux/netfilter_ipv4/ipt_connbytes.h
+++ b/include/linux/netfilter_ipv4/ipt_connbytes.h
@@ -1,10 +1,10 @@
 #ifndef _IPT_CONNBYTES_H
 #define _IPT_CONNBYTES_H
 
-#include <net/netfilter/xt_connbytes.h>
+#include <linux/netfilter/xt_connbytes.h>
 #define ipt_connbytes_what xt_connbytes_what
 
-#define IPT_CONNBYTES_PKTS	XT_CONNBYTES_PACKETS
+#define IPT_CONNBYTES_PKTS	XT_CONNBYTES_PKTS
 #define IPT_CONNBYTES_BYTES	XT_CONNBYTES_BYTES
 #define IPT_CONNBYTES_AVGPKT	XT_CONNBYTES_AVGPKT
 
