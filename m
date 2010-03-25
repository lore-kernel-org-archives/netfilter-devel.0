From: wzt.wzt@gmail.com
Subject: [PATCH] Netfilter: Code cleanup on net/netfilter
Date: Thu, 25 Mar 2010 17:21:54 +0800
Message-ID: <20100325092154.GB29056@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fix some coding styles and remove moduleparam.h

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv4/netfilter/nf_nat_h323.c       |    1 -
 net/ipv4/netfilter/nf_nat_standalone.c |    3 +--
 net/ipv4/netfilter/nf_nat_tftp.c       |    1 -
 net/netfilter/nf_conntrack_proto.c     |    2 --
 4 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 7e8e6fc..d4c0618 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 5678e95..0b49248 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -137,9 +137,8 @@ nf_nat_fn(unsigned int hooknum,
 				ret = nf_nat_rule_find(skb, hooknum, in, out,
 						       ct);
 
-			if (ret != NF_ACCEPT) {
+			if (ret != NF_ACCEPT)
 				return ret;
-			}
 		} else
 			pr_debug("Already setup manip %s for ct %p\n",
 				 maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
index b096e81..7274a43 100644
--- a/net/ipv4/netfilter/nf_nat_tftp.c
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/udp.h>
 
 #include <net/netfilter/nf_nat_helper.h>
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 1a4568b..f71cd5d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -13,12 +13,10 @@
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <linux/stddef.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
-#include <linux/moduleparam.h>
 #include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-- 
1.6.5.3
