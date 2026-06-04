Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9D932BF51
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780594360; cv=none; b=HKaLTlncifY1dHOhtf9mFu8ELsxRP71NE/OpE3KqPm0g+WWsTBRFTVnVcsnwRgG9fZd97Nwybra2I3onKD0Mi5/q3KHjoT1WsbiRqkLNEboxhNvEI7j1wxtgDLeVTQhaSWgGSuAeAgxappAopTeXxUIWY3qanFFC6AW4AUZZb6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780594360; c=relaxed/simple;
	bh=qXpyPYIn5Jjbj/MmgeVG2X1/zHQCdLmB7X93bdxUPuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJwwB96kX6n+QEnFOtubwcTAzuwH4CbYSz/tYbe/bJeuXmE/fZwYd4dbOSC8PDGIqjtFSdoo7IBp4frgBvRW5DGT7hYkbOs6w4FFzLDDchbqsVYAm6T18xQEvdUOUo1ME8OsGi8PBMp1EoSGPEhjJuOMIrYI0iKhVNR2pe6PC7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACnyMKrtiFqMexbAA--.13373S2;
	Fri, 05 Jun 2026 01:32:28 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	royenheart@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf v3 1/1] bridge: br_netfilter: pin bridge device while NFQUEUE holds fake dst
Date: Fri,  5 Jun 2026 01:32:22 +0800
Message-ID: <fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACnyMKrtiFqMexbAA--.13373S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF48Gr1kWr4fGFyDZr17GFg_yoW7Gry8pF
	WYqayrJ392gFy7K3ykAr4Ivr1a9rs5Cr4fWryIkryFyr1YqF15Zr4kKFWUZFWxCF4vkw43
	JFs0gF4kKFWUXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEICWohNVALzAACsq

From: Haoze Xie <royenheart@gmail.com>

The bridge netfilter fake rtable is embedded in struct net_bridge and is
attached to bridged packets with skb_dst_set_noref(). If such a packet is
queued to NFQUEUE, __nf_queue() upgrades that fake dst with
skb_dst_force().

At that point the queued skb can hold a real dst reference after bridge
teardown has started. The problem is not that every bridged packet needs
its own dst reference. The problem is that NFQUEUE can keep the bridge
private fake dst alive after unregister begins.

Fix this by keeping the bridge fake dst model unchanged and pinning the
bridge master device only while the packet sits in NFQUEUE. Record the
bridge device in nf_queue_entry when the queued skb carries a bridge fake
dst, take a device reference for the queue lifetime, and drop it when the
queue entry is freed.

This keeps netdev_priv(br->dev) alive until verdict completion, so the
embedded fake rtable and its metrics backing storage cannot be freed out
from under dst_release(). It also avoids the constant refcount bump and
avoids using ipv4-specific dst helpers for IPv6 bridge traffic.

Fixes: 34666d467cbf ("netfilter: bridge: move br_netfilter out of the core")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
Changes in v3:
  - drop the per-packet fake dst refcounting from v2
  - stop using ipv4-specific dst helpers for the fake dst
  - keep the existing bridge fake rtable model unchanged on the fast path
  - pin the bridge master device only when NFQUEUE upgrades a fake dst
  into an asynchronous queued reference
  - v2 Link: https://lore.kernel.org/all/831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com/
changes in v2:
  - spell out how NFQUEUE upgrades the fake dst into a real reference
  - switch to rt_dst_alloc() instead of br_netfilter-private dst_ops state
  - detach the bridge device with dst_dev_put() during teardown
  - keep the ref-holding contract local to bridge_parent_rtable()
  - v1 Link: https://lore.kernel.org/all/783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com/

 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 3978c3174cdb..fc3e81c07364 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -18,6 +18,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*bridge_dev;
 	struct net_device	*physin;
 	struct net_device	*physout;
 #endif
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 57b450024a99..ba9e2f3fbd94 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -24,6 +24,27 @@
 
 static const struct nf_queue_handler __rcu *nf_queue_handler;
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+static struct net_device *nf_queue_bridge_dev(const struct sk_buff *skb,
+					      const struct nf_hook_state *state)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev;
+
+	if (state->pf != NFPROTO_BRIDGE || !nf_bridge_info_exists(skb))
+		return NULL;
+
+	if (!dst || !(dst->flags & DST_FAKE_RTABLE))
+		return NULL;
+
+	dev = READ_ONCE(dst->dev);
+	if (!dev || dev == blackhole_netdev)
+		return NULL;
+
+	return dev;
+}
+#endif
+
 /*
  * Hook for nfnetlink_queue to register its queue handler.
  * We do this so that most of the NFQUEUE code can be modular.
@@ -68,6 +89,8 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->bridge_dev)
+		dev_put(entry->bridge_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -85,6 +108,7 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
 
+	entry->bridge_dev = NULL;
 	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
 		entry->physout = nf_bridge_get_physoutdev(skb);
@@ -108,6 +132,9 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	entry->bridge_dev = nf_queue_bridge_dev(entry->skb, state);
+	if (entry->bridge_dev)
+		dev_hold(entry->bridge_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
-- 
2.47.3

