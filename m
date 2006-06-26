From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: nf_conntrack: Fix undefined references to
	local_bh_*
Date: Mon, 26 Jun 2006 17:43:10 +0200 (MEST)
Message-ID: <20060626154310.11682.21299.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Fix undefined references to local_bh_*

  CC      net/netfilter/nf_conntrack_proto_sctp.o
net/netfilter/nf_conntrack_proto_sctp.c: In function `sctp_print_conntrack':
net/netfilter/nf_conntrack_proto_sctp.c:206: warning: implicit declaration of function `local_bh_disable'
net/netfilter/nf_conntrack_proto_sctp.c:208: warning: implicit declaration of function `local_bh_enable'
  CC      net/netfilter/nf_conntrack_netlink.o
net/netfilter/nf_conntrack_netlink.c: In function `ctnetlink_dump_table':
net/netfilter/nf_conntrack_netlink.c:429: warning: implicit declaration of function `local_bh_disable'
net/netfilter/nf_conntrack_netlink.c:452: warning: implicit declaration of function `local_bh_enable'

Spotted by Toralf Förster

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7cb7437f3a26e2054d315a9baea52f9d825a7286
tree 72c74e7b320d2763b3ba2e7387cf3f003c250b67
parent c223657397019f91ab8f7a7b8b417eae4a378c72
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 19 Jun 2006 16:48:59 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 19 Jun 2006 16:48:59 +0200

 net/netfilter/nf_conntrack_netlink.c    |    1 +
 net/netfilter/nf_conntrack_proto_sctp.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b8c7c56..af48459 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -29,6 +29,7 @@ #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 #include <linux/notifier.h>
 
 #include <linux/netfilter.h>
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0c6da49..0839b70 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -28,6 +28,8 @@ #include <linux/ip.h>
 #include <linux/sctp.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
