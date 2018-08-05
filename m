From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/21] netfilter: bridge: Expose nf_tables bridge hook priorities through uapi
Date: Sun,  5 Aug 2018 23:21:37 +0200
Message-ID: <20180805212141.3033-18-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

Netfilter exposes standard hook priorities in case of ipv4, ipv6 and
arp but not in case of bridge.

This patch exposes the hook priority values of the bridge family (which are
different from the formerly mentioned) via uapi so that they can be used by
user-space applications just like the others.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge.h      | 11 -----------
 include/uapi/linux/netfilter_bridge.h | 11 +++++++++++
 net/bridge/br_netfilter_hooks.c       |  1 +
 net/bridge/netfilter/ebtable_filter.c |  1 +
 net/bridge/netfilter/ebtable_nat.c    |  1 +
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index b671fdfd212b..fa0686500970 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -5,17 +5,6 @@
 #include <uapi/linux/netfilter_bridge.h>
 #include <linux/skbuff.h>
 
-enum nf_br_hook_priorities {
-	NF_BR_PRI_FIRST = INT_MIN,
-	NF_BR_PRI_NAT_DST_BRIDGED = -300,
-	NF_BR_PRI_FILTER_BRIDGED = -200,
-	NF_BR_PRI_BRNF = 0,
-	NF_BR_PRI_NAT_DST_OTHER = 100,
-	NF_BR_PRI_FILTER_OTHER = 200,
-	NF_BR_PRI_NAT_SRC = 300,
-	NF_BR_PRI_LAST = INT_MAX,
-};
-
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 12fb77633f83..156ccd089df1 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -26,4 +26,15 @@
 #define NF_BR_BROUTING		5
 #define NF_BR_NUMHOOKS		6
 
+enum nf_br_hook_priorities {
+	NF_BR_PRI_FIRST = INT_MIN,
+	NF_BR_PRI_NAT_DST_BRIDGED = -300,
+	NF_BR_PRI_FILTER_BRIDGED = -200,
+	NF_BR_PRI_BRNF = 0,
+	NF_BR_PRI_NAT_DST_OTHER = 100,
+	NF_BR_PRI_FILTER_OTHER = 200,
+	NF_BR_PRI_NAT_SRC = 300,
+	NF_BR_PRI_LAST = INT_MAX,
+};
+
 #endif /* _UAPI__LINUX_BRIDGE_NETFILTER_H */
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 9b16eaf33819..6e0dc6bcd32a 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -26,6 +26,7 @@
 #include <linux/if_pppox.h>
 #include <linux/ppp_defs.h>
 #include <linux/netfilter_bridge.h>
+#include <uapi/linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_arp.h>
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index c41da5fac84f..550324c516ee 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/netfilter_bridge/ebtables.h>
+#include <uapi/linux/netfilter_bridge.h>
 #include <linux/module.h>
 
 #define FILTER_VALID_HOOKS ((1 << NF_BR_LOCAL_IN) | (1 << NF_BR_FORWARD) | \
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 08df7406ecb3..c0fb3ca518af 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/netfilter_bridge/ebtables.h>
+#include <uapi/linux/netfilter_bridge.h>
 #include <linux/module.h>
 
 #define NAT_VALID_HOOKS ((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT) | \
-- 
2.11.0
