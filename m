Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97443F4121
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 03:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778730562; cv=none; b=RLeRcqJF9srrP7iZEdqS30g/hz3AsHFX7k1FXTV+jf/GIxErGYkE/Z29EP9i34p+PJ0Ez9sYDcMN2h8XzunJ/PPdI5ITTntg/4xPddFbO0r31EVeloV7n3N0qcb8ymiFR+wc56yo6oP3CF3VonxxF92bJVlpeseeWKKsplAu0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778730562; c=relaxed/simple;
	bh=RoXvO2+AaKu5f87UK5Y/fYNoLxMpwI4W1umB+e2JLeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY/Y24plnLMnt4vNcKeYtE7kp7++0VmJBVGHngOAoPPGtfd9jTThiFeNRghMeTUbucmAfH7HR0wBgHLcmKaXuoy5qmPl+4HKkNG1DUIAGsidBFgX/Bry4+HmBlk0ciP253fnkPU9sP96+QKJuqhw8QeELH4nxIiztW8Ly3LUWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAAXOsQiRgVqoBwGAA--.6967S3;
	Thu, 14 May 2026 11:48:55 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	stephen@networkplumber.org,
	sw@simonwunderlich.de,
	davem@davemloft.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	royenheart@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] bridge: br_netfilter: give fake rtable its own lifetime
Date: Thu, 14 May 2026 11:48:42 +0800
Message-ID: <783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778687139.git.royenheart@gmail.com>
References: <cover.1778687139.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAAXOsQiRgVqoBwGAA--.6967S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtFyfKr43uF4DGw15CF1DAwb_yoW3Kr4rpF
	4rKa93tr4UXFy3Kw48AF1Iyry3Krs5CFW3urya9r9avw10gF1kAa9akry2v3WrZFWkCFW5
	JF47Kr45K3yDZr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0HCWoEFm8UngAAsf

From: Haoze Xie <royenheart@gmail.com>

The bridge netfilter fake rtable is currently embedded in struct
net_bridge even though packets can keep using it after bridge teardown.

Give the fake rtable its own allocated lifetime and make
bridge_parent_rtable() return a referenced dst. This way the bridge and
any packets that still carry the fake dst each hold their own reference,
so bridge teardown no longer leaves a dangling fake dst behind.

We are sending this to the nf tree because the patch touches
br_netfilter paths; if the net tree is preferred, please let us know.

Fixes: 4adf0af6818f ("bridge: send correct MTU value in PMTU (revised)")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 include/net/netfilter/br_netfilter.h | 14 +++++++-
 net/bridge/br_device.c               | 18 ++++++++--
 net/bridge/br_netfilter_hooks.c      |  2 +-
 net/bridge/br_netfilter_ipv6.c       |  2 +-
 net/bridge/br_nf_core.c              | 49 +++++++++++++++++++++++-----
 net/bridge/br_private.h              | 12 +++----
 6 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 371696ec11b2..ad09dad09da8 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -3,6 +3,7 @@
 #define _BR_NETFILTER_H_
 
 #include <linux/netfilter.h>
+#include <net/dst.h>
 
 #include "../../../net/bridge/br_private.h"
 
@@ -44,9 +45,20 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_bridge_port *port;
+	struct rtable *rt;
 
+	rt = NULL;
+	rcu_read_lock();
 	port = br_port_get_rcu(dev);
-	return port ? &port->br->fake_rtable : NULL;
+	if (!port)
+		goto out;
+
+	rt = rcu_dereference(port->br->fake_rtable);
+	if (rt && !dst_hold_safe(&rt->dst))
+		rt = NULL;
+out:
+	rcu_read_unlock();
+	return rt;
 #else
 	return NULL;
 #endif
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a35ceae0a6f2..ca2e76929377 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -146,6 +146,15 @@ static int br_dev_init(struct net_device *dev)
 		return err;
 	}
 
+	err = br_netfilter_rtable_init(br);
+	if (err) {
+		br_multicast_uninit_stats(br);
+		br_vlan_flush(br);
+		br_mdb_hash_fini(br);
+		br_fdb_hash_fini(br);
+		return err;
+	}
+
 	netdev_lockdep_set_classes(dev);
 	return 0;
 }
@@ -154,6 +163,7 @@ static void br_dev_uninit(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
+	br_netfilter_rtable_fini(br);
 	br_multicast_dev_del(br);
 	br_multicast_uninit_stats(br);
 	br_vlan_flush(br);
@@ -210,8 +220,11 @@ static int br_change_mtu(struct net_device *dev, int new_mtu)
 	/* this flag will be cleared if the MTU was automatically adjusted */
 	br_opt_toggle(br, BROPT_MTU_SET_BY_USER, true);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	/* remember the MTU in the rtable for PMTU */
-	dst_metric_set(&br->fake_rtable.dst, RTAX_MTU, new_mtu);
+	struct rtable *rt;
+
+	rt = rcu_dereference_protected(br->fake_rtable, lockdep_rtnl_is_held());
+	if (rt)
+		dst_metric_set(&rt->dst, RTAX_MTU, new_mtu);
 #endif
 
 	return 0;
@@ -529,7 +542,6 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	br_netfilter_rtable_init(br);
 	br_stp_timer_init(br);
 	br_multicast_init(br);
 	INIT_DELAYED_WORK(&br->gc_work, br_fdb_cleanup);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 0ab1c94db4b9..8b3b2fb48334 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -417,7 +417,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			return 0;
 		}
 		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set(skb, &rt->dst);
 	}
 
 	skb->dev = br_indev;
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index d8548428929e..4e245645f7e6 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -144,7 +144,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			return 0;
 		}
 		skb_dst_drop(skb);
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set(skb, &rt->dst);
 	}
 
 	skb->dev = br_indev;
diff --git a/net/bridge/br_nf_core.c b/net/bridge/br_nf_core.c
index a8c67035e23c..89a0a3d107de 100644
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -14,6 +14,8 @@
 #include <linux/kernel.h>
 #include <linux/in_route.h>
 #include <linux/inetdevice.h>
+#include <linux/slab.h>
+#include <linux/rcupdate.h>
 #include <net/route.h>
 
 #include "br_private.h"
@@ -49,6 +51,11 @@ static unsigned int fake_mtu(const struct dst_entry *dst)
 	return dst->dev->mtu;
 }
 
+struct br_fake_rtable {
+	struct rtable	rt;
+	u32		metrics[RTAX_MAX];
+};
+
 static struct dst_ops fake_dst_ops = {
 	.family		= AF_INET,
 	.update_pmtu	= fake_update_pmtu,
@@ -65,24 +72,50 @@ static struct dst_ops fake_dst_ops = {
  * ipt_REJECT needs it.  Future netfilter modules might
  * require us to fill additional fields.
  */
-void br_netfilter_rtable_init(struct net_bridge *br)
+int br_netfilter_rtable_init(struct net_bridge *br)
 {
-	struct rtable *rt = &br->fake_rtable;
+	struct br_fake_rtable *fake_rt;
+	struct rtable *rt;
+
+	fake_rt = kmem_cache_zalloc(fake_dst_ops.kmem_cachep, GFP_KERNEL);
+	if (!fake_rt)
+		return -ENOMEM;
 
-	rcuref_init(&rt->dst.__rcuref, 1);
-	rt->dst.dev = br->dev;
-	dst_init_metrics(&rt->dst, br->metrics, false);
+	rt = &fake_rt->rt;
+	dst_init(&rt->dst, &fake_dst_ops, br->dev, DST_OBSOLETE_NONE,
+		 DST_NOXFRM | DST_FAKE_RTABLE);
+	dst_init_metrics(&rt->dst, fake_rt->metrics, false);
 	dst_metric_set(&rt->dst, RTAX_MTU, br->dev->mtu);
-	rt->dst.flags	= DST_NOXFRM | DST_FAKE_RTABLE;
-	rt->dst.ops = &fake_dst_ops;
+	rcu_assign_pointer(br->fake_rtable, rt);
+
+	return 0;
+}
+
+void br_netfilter_rtable_fini(struct net_bridge *br)
+{
+	struct rtable *rt;
+
+	rt = rcu_replace_pointer(br->fake_rtable, NULL, lockdep_rtnl_is_held());
+	if (rt)
+		dst_release(&rt->dst);
 }
 
 int __init br_nf_core_init(void)
 {
-	return dst_entries_init(&fake_dst_ops);
+	int err;
+
+	fake_dst_ops.kmem_cachep =
+		KMEM_CACHE(br_fake_rtable, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	err = dst_entries_init(&fake_dst_ops);
+	if (err)
+		fake_dst_ops.kmem_cachep = NULL;
+
+	return err;
 }
 
 void br_nf_core_fini(void)
 {
 	dst_entries_destroy(&fake_dst_ops);
+	kmem_cache_destroy(fake_dst_ops.kmem_cachep);
+	fake_dst_ops.kmem_cachep = NULL;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bed1b1d9b282..bb4aa408f232 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -508,11 +508,7 @@ struct net_bridge {
 	struct rhashtable		fdb_hash_tbl;
 	struct list_head		port_list;
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	union {
-		struct rtable		fake_rtable;
-		struct rt6_info		fake_rt6_info;
-	};
-	u32				metrics[RTAX_MAX];
+	struct rtable __rcu		*fake_rtable;
 #endif
 	u16				group_fwd_mask;
 	u16				group_fwd_mask_required;
@@ -2018,11 +2014,13 @@ extern const struct nf_br_ops __rcu *nf_br_ops;
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 int br_nf_core_init(void);
 void br_nf_core_fini(void);
-void br_netfilter_rtable_init(struct net_bridge *);
+int br_netfilter_rtable_init(struct net_bridge *br);
+void br_netfilter_rtable_fini(struct net_bridge *br);
 #else
 static inline int br_nf_core_init(void) { return 0; }
 static inline void br_nf_core_fini(void) {}
-#define br_netfilter_rtable_init(x)
+static inline int br_netfilter_rtable_init(struct net_bridge *br) { return 0; }
+static inline void br_netfilter_rtable_fini(struct net_bridge *br) {}
 #endif
 
 /* br_stp.c */
-- 
2.47.3

