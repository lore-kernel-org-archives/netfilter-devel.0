Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04A2284B37
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jun 2026 06:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780728663; cv=none; b=OjzoaamnIejb5WxVAYAprxGVsuJeQZ3faf8SUEQFQE7LjuI7CrWdO5KZMC5OSBx+99GbRbVOHhk4H8CJxn5mPTkAJg93RrUqtn5YlK0/oGnNBcJpeEmK9IXCCf2STKhla1J4o9/q2b/D1CFp4TbVafKktjXsbLrvtCZs9iLTXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780728663; c=relaxed/simple;
	bh=/xVZtrFDTcASgFVnbKdhHDuuAraWZEjLTFeXDm6Drzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LLzM5abQ6dE9+/ZlWAbsIa9RIh6+D/wWju0mDSbSR7Xql9gZBAPmLkPLFtIGPbJjCyRfTOE5ayqfdQDa6EG4Ew16+mZNQdmMwPpZRg/dd1K15g1Af9kPZDbWRdoofZBzVs/89u++FW6Kq8zqr4YWX9Zs/PApldH9ipr8qCUUCAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACHqMI_wyNqZ09iAA--.50172S2;
	Sat, 06 Jun 2026 14:50:39 +0800 (CST)
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
Subject: [PATCH nf v4 1/1] bridge: br_netfilter: pin bridge device while NFQUEUE holds fake dst
Date: Sat,  6 Jun 2026 14:50:34 +0800
Message-ID: <cbc3a29c0654e8fcee30cb021d57883fed77fafc.1780630094.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACHqMI_wyNqZ09iAA--.50172S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKFyDtr1kurWrAw1rXr4fKrg_yoW7Wr13pF
	W5Kay8J3yvqryUK3ykAr4Ivr1avrs5Cr4fWa4Ikryru3s8XFy5Zr4kKFWUuFWxCF4vkw43
	JFs0gF4ktFW5ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8V
	W8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0KCWoihtAJKQAAsx

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
Changes in v4:
  - inline the bridge fake-dst device lookup into
    __nf_queue_entry_init_physdevs()
  - drop the extra helper introduced in v3 and keep the queue-entry setup
    local
  - use dst_dev_rcu() as suggested during review
  - drop the unnecessary blackhole_netdev special case
  - expand the comment to state explicitly that dst_hold() cannot protect
    the embedded fake rtable backing storage
  - v3 Link: https://lore.kernel.org/all/fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com/
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
 net/netfilter/nf_queue.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

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
index 57b450024a99..ffe3e98fc2ca 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -68,6 +68,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_put(entry->bridge_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -84,6 +85,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = NULL;
 
 	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
@@ -92,6 +95,17 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 		entry->physin = NULL;
 		entry->physout = NULL;
 	}
+
+	if (entry->state.pf == NFPROTO_BRIDGE &&
+	    nf_bridge_info_exists(skb) &&
+	    dst && (dst->flags & DST_FAKE_RTABLE))
+		dev = dst_dev_rcu(dst);
+
+	/* Must hold a reference on the bridge device: dst_hold() protects
+	 * the dst itself, but the fake rtable is embedded in bridge-private
+	 * storage that netdevice teardown can free independently.
+	 */
+	entry->bridge_dev = dev;
 #endif
 }
 
@@ -108,6 +122,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_hold(entry->bridge_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
-- 
2.47.3

