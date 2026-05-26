Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDFE35838F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779765718; cv=none; b=r2C8oKF1F+yfGf7L1ozIWewBOSS3LrXM/Q/t6fHSh6NI/gdbmzc2PvDocUSv429rnlxXqjF38J+++Wa299BTm5XDP40DdpcLe3NqTeWJX18FU2nE+z0ryrx/tBukWvLaGAhFQzq5nqKs8yzpVhUQdhNqA1J9qoYb8P8wWcfxxTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779765718; c=relaxed/simple;
	bh=lDT0Q3DixdJcia7ri43T2ziyqd6gnHwDBYXZSOj6vTI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JyGdORm0I4d16UYprfdP55vq4mYBP6CvMoPAp896OZ+kE/HGvxPSRNkZiUvd0fZWiUJfdYxX8zD4Ce941O6x3+mEUiiqjNrlja1HemJaKPPsP3+FEzYHW+bO1leGX4h8oYd4D0FFUaE/G4mS+e5FDQYxJF02aeyhxC0p+Ot7pA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABnicOmERVqgxQvAA--.2271S2;
	Tue, 26 May 2026 11:21:11 +0800 (CST)
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
Subject: [PATCH nf v2 1/1] bridge: br_netfilter: move fake rtable off struct net_bridge
Date: Tue, 26 May 2026 11:21:03 +0800
Message-ID: <831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABnicOmERVqgxQvAA--.2271S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKFWUJr15uw43uF4rCr4xCrg_yoWftw4rpF
	4rKayftr4UXF1Ygw48AF4Iyr13Krs5CFW3uryfC34S9w1jgF1kAa9akry2va1rZFWkuFW5
	JF12qr45t3yDZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsSCWoUBk4H1wAEsz

From: Haoze Xie <royenheart@gmail.com>

The bridge netfilter fake rtable currently lives inside struct
net_bridge and is reattached to bridged packets with
skb_dst_set_noref(). If such a packet is queued to NFQUEUE,
__nf_queue() upgrades that fake dst with skb_dst_force().

At that point queued packets can hold a real dst reference even after
bridge teardown starts freeing the backing struct net_bridge storage.
When verdict reinjection later drops the skb, dst_release() can hit the
freed bridge-private fake rtable.

Fix this by moving the fake rtable out of struct net_bridge and making
bridge_parent_rtable() hand out a referenced dst. This keeps the queued
skb path from holding a pointer into struct net_bridge while keeping the
kludge local to br_netfilter.

Use rt_dst_alloc() so the fake dst reuses the core IPv4 rtable
lifecycle, and release the bridge device reference during teardown via
dst_dev_put() before dropping the bridge-owned dst reference.

Fixes: 4adf0af6818f ("bridge: send correct MTU value in PMTU (revised)")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
changes in v2:
  - spell out how NFQUEUE upgrades the fake dst into a real reference
  - switch to rt_dst_alloc() instead of br_netfilter-private dst_ops state
  - detach the bridge device with dst_dev_put() during teardown
  - keep the ref-holding contract local to bridge_parent_rtable()
  - v1 Link: https://lore.kernel.org/all/783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com/

 include/net/netfilter/br_netfilter.h | 15 +++++-
 net/bridge/br_device.c               | 15 ++++--
 net/bridge/br_netfilter_hooks.c      |  2 +-
 net/bridge/br_netfilter_ipv6.c       |  2 +-
 net/bridge/br_nf_core.c              | 71 ++++++++++------------------
 net/bridge/br_private.h              | 12 ++---
 6 files changed, 55 insertions(+), 62 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 371696ec11b2..99f64c2e70c0 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -3,6 +3,7 @@
 #define _BR_NETFILTER_H_
 
 #include <linux/netfilter.h>
+#include <net/dst.h>
 
 #include "../../../net/bridge/br_private.h"
 
@@ -44,9 +45,21 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_bridge_port *port;
+	struct rtable *rt;
 
+	/* Caller receives a held dst reference and must drop it. */
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
index a35ceae0a6f2..00f426420bab 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -131,8 +131,16 @@ static int br_dev_init(struct net_device *dev)
 		return err;
 	}
 
+	err = br_netfilter_rtable_init(br);
+	if (err) {
+		br_mdb_hash_fini(br);
+		br_fdb_hash_fini(br);
+		return err;
+	}
+
 	err = br_vlan_init(br);
 	if (err) {
+		br_netfilter_rtable_fini(br);
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
 		return err;
@@ -141,6 +149,7 @@ static int br_dev_init(struct net_device *dev)
 	err = br_multicast_init_stats(br);
 	if (err) {
 		br_vlan_flush(br);
+		br_netfilter_rtable_fini(br);
 		br_mdb_hash_fini(br);
 		br_fdb_hash_fini(br);
 		return err;
@@ -154,6 +163,7 @@ static void br_dev_uninit(struct net_device *dev)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
+	br_netfilter_rtable_fini(br);
 	br_multicast_dev_del(br);
 	br_multicast_uninit_stats(br);
 	br_vlan_flush(br);
@@ -209,10 +219,6 @@ static int br_change_mtu(struct net_device *dev, int new_mtu)
 
 	/* this flag will be cleared if the MTU was automatically adjusted */
 	br_opt_toggle(br, BROPT_MTU_SET_BY_USER, true);
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	/* remember the MTU in the rtable for PMTU */
-	dst_metric_set(&br->fake_rtable.dst, RTAX_MTU, new_mtu);
-#endif
 
 	return 0;
 }
@@ -529,7 +535,6 @@ void br_dev_setup(struct net_device *dev)
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
index a8c67035e23c..e28512175671 100644
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/in_route.h>
 #include <linux/inetdevice.h>
+#include <linux/rcupdate.h>
 #include <net/route.h>
 
 #include "br_private.h"
@@ -21,43 +22,6 @@
 #include <linux/sysctl.h>
 #endif
 
-static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			     struct sk_buff *skb, u32 mtu,
-			     bool confirm_neigh)
-{
-}
-
-static void fake_redirect(struct dst_entry *dst, struct sock *sk,
-			  struct sk_buff *skb)
-{
-}
-
-static u32 *fake_cow_metrics(struct dst_entry *dst, unsigned long old)
-{
-	return NULL;
-}
-
-static struct neighbour *fake_neigh_lookup(const struct dst_entry *dst,
-					   struct sk_buff *skb,
-					   const void *daddr)
-{
-	return NULL;
-}
-
-static unsigned int fake_mtu(const struct dst_entry *dst)
-{
-	return dst->dev->mtu;
-}
-
-static struct dst_ops fake_dst_ops = {
-	.family		= AF_INET,
-	.update_pmtu	= fake_update_pmtu,
-	.redirect	= fake_redirect,
-	.cow_metrics	= fake_cow_metrics,
-	.neigh_lookup	= fake_neigh_lookup,
-	.mtu		= fake_mtu,
-};
-
 /*
  * Initialize bogus route table used to keep netfilter happy.
  * Currently, we fill in the PMTU entry because netfilter
@@ -65,24 +29,37 @@ static struct dst_ops fake_dst_ops = {
  * ipt_REJECT needs it.  Future netfilter modules might
  * require us to fill additional fields.
  */
-void br_netfilter_rtable_init(struct net_bridge *br)
+int br_netfilter_rtable_init(struct net_bridge *br)
 {
-	struct rtable *rt = &br->fake_rtable;
+	struct rtable *rt;
+
+	rt = rt_dst_alloc(br->dev, 0, RTN_UNSPEC, true);
+	if (!rt)
+		return -ENOMEM;
+
+	rt->dst.flags |= DST_FAKE_RTABLE;
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
+	if (!rt)
+		return;
 
-	rcuref_init(&rt->dst.__rcuref, 1);
-	rt->dst.dev = br->dev;
-	dst_init_metrics(&rt->dst, br->metrics, false);
-	dst_metric_set(&rt->dst, RTAX_MTU, br->dev->mtu);
-	rt->dst.flags	= DST_NOXFRM | DST_FAKE_RTABLE;
-	rt->dst.ops = &fake_dst_ops;
+	dst_dev_put(&rt->dst);
+	dst_release(&rt->dst);
 }
 
 int __init br_nf_core_init(void)
 {
-	return dst_entries_init(&fake_dst_ops);
+	return 0;
 }
 
 void br_nf_core_fini(void)
 {
-	dst_entries_destroy(&fake_dst_ops);
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

