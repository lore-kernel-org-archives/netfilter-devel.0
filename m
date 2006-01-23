From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]iptables: fix typos in ipt_connbytes.h
Date: Mon, 23 Jan 2006 10:53:44 +0900 (JST)
Message-ID: <200601230153.k0N1rj8V023685@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Jan_23_10_53_44_2006_248)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
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

----Next_Part(Mon_Jan_23_10_53_44_2006_248)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

userspace connbytes fails to be build because of that.
Please apply attached patch to kernel tree.

Regards,

-- Yasuyuki Kozakai

----Next_Part(Mon_Jan_23_10_53_44_2006_248)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-connbytes.patch"

[NETFILTER]iptables: fix typos in ipt_connbytes.h

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 4e61ccb0584e488c5a23b5a444f6ce780bcf1ecc
tree 7b24a9295bd18915a74ce0a7b560259b2b2819ec
parent 3ee68c4af3fd7228c1be63254b9f884614f9ebb2
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 22 Jan 2006 22:15:12 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 22 Jan 2006 22:15:12 +0900

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
 

----Next_Part(Mon_Jan_23_10_53_44_2006_248)----
