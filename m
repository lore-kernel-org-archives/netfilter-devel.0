From: Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH] netfilter: fix out-of-bounds accesses in clusterip_tg_check()
Date: Tue, 30 Jan 2018 15:21:34 +0100
Message-ID: <20180130142134.131750-1-dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, willemb@google.com
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Commit 136e92bbec0a switched local_nodes from an array to a bitmask
but did not add proper bounds checks. As the result
clusterip_config_init_nodelist() can both over-read
ipt_clusterip_tgt_info.local_nodes and over-write
clusterip_config.local_nodes.

Add bounds checks for both.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 136e92bbec0a ("[NETFILTER] CLUSTERIP: use a bitmap to store node responsibility data")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 69060e3abe85..1e4a7209a3d2 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -431,7 +431,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 	struct clusterip_config *config;
-	int ret;
+	int ret, i;
 
 	if (par->nft_compat) {
 		pr_err("cannot use CLUSTERIP target from nftables compat\n");
@@ -450,8 +450,18 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		pr_info("Please specify destination IP\n");
 		return -EINVAL;
 	}
-
-	/* FIXME: further sanity checks */
+	if (cipinfo->num_local_nodes > ARRAY_SIZE(cipinfo->local_nodes)) {
+		pr_info("bad num_local_nodes %u\n", cipinfo->num_local_nodes);
+		return -EINVAL;
+	}
+	for (i = 0; i < cipinfo->num_local_nodes; i++) {
+		if (cipinfo->local_nodes[i] - 1 >=
+		    sizeof(config->local_nodes) * 8) {
+			pr_info("bad local_nodes[%d] %u\n",
+				i, cipinfo->local_nodes[i]);
+			return -EINVAL;
+		}
+	}
 
 	config = clusterip_config_find_get(par->net, e->ip.dst.s_addr, 1);
 	if (!config) {
-- 
2.16.0.rc1.238.g530d649a79-goog
