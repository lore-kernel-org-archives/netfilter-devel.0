From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH 27/45] net: remove duplicate includes
Date: Mon, 11 Dec 2017 22:09:46 +0530
Message-ID: <1513010386-3394-1-git-send-email-pravin.shedge4linux@gmail.com>
Cc: pravin.shedge4linux@gmail.com, linux-kernel@vger.kernel.org
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, f.fainelli@gmail.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, mingo@kernel.org,
        rmk+kernel@armlinux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 net/core/netprio_cgroup.c            | 1 -
 net/dsa/slave.c                      | 1 -
 net/netfilter/nf_conntrack_netlink.c | 1 -
 net/sched/act_meta_mark.c            | 1 -
 net/sched/act_meta_skbtcindex.c      | 1 -
 net/sched/cls_api.c                  | 1 -
 net/sched/cls_u32.c                  | 1 -
 7 files changed, 7 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 1c48109..b905747 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d6e7a64..a95a55f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -16,7 +16,6 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/mdio.h>
-#include <linux/list.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mirred.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59c0899..332b518 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -45,7 +45,6 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <net/netfilter/nf_conntrack_labels.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
diff --git a/net/sched/act_meta_mark.c b/net/sched/act_meta_mark.c
index 1e3f10e..6445184 100644
--- a/net/sched/act_meta_mark.c
+++ b/net/sched/act_meta_mark.c
@@ -22,7 +22,6 @@
 #include <net/pkt_sched.h>
 #include <uapi/linux/tc_act/tc_ife.h>
 #include <net/tc_act/tc_ife.h>
-#include <linux/rtnetlink.h>
 
 static int skbmark_encode(struct sk_buff *skb, void *skbdata,
 			  struct tcf_meta_info *e)
diff --git a/net/sched/act_meta_skbtcindex.c b/net/sched/act_meta_skbtcindex.c
index 2ea1f26..7221437 100644
--- a/net/sched/act_meta_skbtcindex.c
+++ b/net/sched/act_meta_skbtcindex.c
@@ -22,7 +22,6 @@
 #include <net/pkt_sched.h>
 #include <uapi/linux/tc_act/tc_ife.h>
 #include <net/tc_act/tc_ife.h>
-#include <linux/rtnetlink.h>
 
 static int skbtcindex_encode(struct sk_buff *skb, void *skbdata,
 			     struct tcf_meta_info *e)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ddcf04b..f40256a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <linux/init.h>
 #include <linux/kmod.h>
-#include <linux/err.h>
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index ac152b4..507859c 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -45,7 +45,6 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
-#include <linux/netdevice.h>
 #include <linux/idr.h>
 
 struct tc_u_knode {
-- 
2.7.4
