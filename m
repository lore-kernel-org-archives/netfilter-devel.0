From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: Clean up duplicate includes in net/netfilter/
Date: Tue, 24 Jul 2007 17:54:16 +0200 (MEST)
Message-ID: <20070724155347.18487.14683.sendpatchset@localhost.localdomain>
References: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Clean up duplicate includes in net/netfilter/

This patch cleans up duplicate includes in
	net/netfilter/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 910ff48fe7571e72bd2b8519cbd6383d81319b26
tree 88176f444ea5e6fef4259aca0b0df0af2766516d
parent 1d99f5a08243ed513a0250943a4c092bc0b9eeba
author Jesper Juhl <jesper.juhl@gmail.com> Tue, 24 Jul 2007 17:29:06 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 24 Jul 2007 17:29:06 +0200

 net/netfilter/nf_conntrack_proto_tcp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udplite.c |    1 -
 net/netfilter/xt_physdev.c                 |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 87ad3cc..eb3fe74 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 13d94a0..2a2fd1a 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 93e747b..b906b41 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index f47cab7..a4bab04 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -13,7 +13,6 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_bridge.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
