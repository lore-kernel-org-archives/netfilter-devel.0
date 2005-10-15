From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK] fixes the path to nf_conntrack headers
Date: Sun, 16 Oct 2005 05:26:26 +0900 (JST)
Message-ID: <200510152026.j9FKQRrt024512@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Oct_16_05_26_26_2005_234)--"
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

----Next_Part(Sun_Oct_16_05_26_26_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

We have changed to move directory for headers used in only kernel to
include/net/netfilter, and there are files that hasn't followed it yet.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Please apply this to nf_conntrack tree.
Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Oct_16_05_26_26_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-headers.patch"

[NETFILTER] fixes the path to nf_conntrack headers

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 6e6fac3178d6a360d009271144c8738d41ae9ee2
tree 33abd63ad4a7d4d486915c655b92207e5b2ee607
parent 90345e5013ffc3541f0d0382d8f2e9d12e702e38
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 16 Oct 2005 04:42:36 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 16 Oct 2005 04:42:36 +0900

 include/net/netfilter/nf_conntrack_compat.h |    4 ++--
 net/ipv4/netfilter/ipt_conntrack.c          |    2 +-
 net/ipv4/netfilter/ipt_helper.c             |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_compat.h b/include/net/netfilter/nf_conntrack_compat.h
--- a/include/net/netfilter/nf_conntrack_compat.h
+++ b/include/net/netfilter/nf_conntrack_compat.h
@@ -53,8 +53,8 @@ static inline int nf_ct_get_ctinfo(const
 
 #else /* CONFIG_IP_NF_CONNTRACK */
 
-#include <linux/netfilter/ipv4/nf_conntrack_ipv4.h>
-#include <linux/netfilter/nf_conntrack.h>
+#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/nf_conntrack.h>
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
 
diff --git a/net/ipv4/netfilter/ipt_conntrack.c b/net/ipv4/netfilter/ipt_conntrack.c
--- a/net/ipv4/netfilter/ipt_conntrack.c
+++ b/net/ipv4/netfilter/ipt_conntrack.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
 #else
-#include <linux/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack.h>
 #endif
 
 #include <linux/netfilter_ipv4/ip_tables.h>
diff --git a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helper.c
--- a/net/ipv4/netfilter/ipt_helper.c
+++ b/net/ipv4/netfilter/ipt_helper.c
@@ -18,9 +18,9 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #else
-#include <linux/netfilter/nf_conntrack.h>
-#include <linux/netfilter/nf_conntrack_core.h>
-#include <linux/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_helper.h>
 #endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_helper.h>

----Next_Part(Sun_Oct_16_05_26_26_2005_234)----
