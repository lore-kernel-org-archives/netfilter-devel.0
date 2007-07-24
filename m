From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: Clean up duplicate includes in net/bridge/
Date: Tue, 24 Jul 2007 17:54:15 +0200 (MEST)
Message-ID: <20070724155345.18487.82046.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Clean up duplicate includes in net/bridge/

This patch cleans up duplicate includes in
	net/bridge/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1d99f5a08243ed513a0250943a4c092bc0b9eeba
tree e80db45eca5c67d6a9bf660e5d3c3bf09c2fe305
parent 01e8429f5fcc78ccdf3a9bc785fd7bfec86f5eef
author Jesper Juhl <jesper.juhl@gmail.com> Tue, 24 Jul 2007 17:28:18 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 24 Jul 2007 17:28:18 +0200

 net/bridge/netfilter/ebt_log.c  |    1 -
 net/bridge/netfilter/ebt_ulog.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 984e9c6..457815f 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -9,7 +9,6 @@
  *
  */
 
-#include <linux/in.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_log.h>
 #include <linux/netfilter.h>
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 6fec352..204c968 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -36,7 +36,6 @@
 #include <linux/timer.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
-#include <linux/module.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ulog.h>
 #include <net/sock.h>
